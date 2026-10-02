#!/usr/bin/env python3
# Copyright 2026 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import os
import re
import shutil
import subprocess
import sys
import types
from pathlib import Path

_REPO_ROOT = Path(__file__).resolve().parents[4]
if str(_REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(_REPO_ROOT))

try:
    from snitch.util.sim.data_utils import ctype_from_precision_t
    from snitch.util.sim.verif_utils import Verifier
except ModuleNotFoundError:
    import util.sim.data_utils as util_sim_data_utils

    snitch_pkg = sys.modules.setdefault("snitch", types.ModuleType("snitch"))
    util_pkg = sys.modules.setdefault("snitch.util", types.ModuleType("snitch.util"))
    setattr(snitch_pkg, "util", util_pkg)
    sys.modules.setdefault("snitch.util.sim.data_utils", util_sim_data_utils)

    import util.sim as util_sim
    import util.sim.Elf as util_sim_elf

    setattr(util_pkg, "sim", util_sim)
    sys.modules.setdefault("snitch.util.sim", util_sim)
    sys.modules.setdefault("snitch.util.sim.Elf", util_sim_elf)

    from util.sim.data_utils import ctype_from_precision_t
    from util.sim.verif_utils import Verifier


PACE_MODE_BY_MACRO = (
    ("PACE_MODE_PWPA", "pwpa"),
    ("PACE_MODE_INV", "inv"),
    ("PACE_MODE_SQRT", "sqrt"),
    ("PACE_MODE_RSQRT", "rsqrt"),
)


def data_header_for(snitch_bin):
    return Path(snitch_bin).resolve().with_name("data.h")


def read_data_header(snitch_bin):
    data_h = data_header_for(snitch_bin)
    if not data_h.exists():
        raise FileNotFoundError(f"Missing generated header next to ELF: {data_h}")
    return data_h.read_text()


def parse_defines(text):
    defines = {}
    for line in text.splitlines():
        match = re.match(r"\s*#\s*define\s+([A-Za-z_][A-Za-z0-9_]*)\s+(.+?)\s*$", line)
        if match:
            value = match.group(2).split("//", 1)[0].strip()
            defines[match.group(1)] = value
    return defines


def macro_int(defines, name, default=0):
    value = defines.get(name)
    if value is None:
        return default
    try:
        return int(value.split()[0], 0)
    except ValueError:
        return default


def macro_enabled(defines, name):
    return macro_int(defines, name, 0) != 0


def detect_precision_from_defines(defines):
    if macro_enabled(defines, "ENABLE_BF16") or macro_enabled(defines, "PACE_DTYPE_BFP16"):
        return "BF16"
    if macro_enabled(defines, "ENABLE_FP16"):
        return "FP16"
    if macro_enabled(defines, "ENABLE_FP32"):
        return "FP32"
    return "FP32"


def ctype_from_pace_precision(prec):
    if str(prec).upper() in {"BF16", "BFP16"}:
        return "uint16_t"
    return ctype_from_precision_t(prec)


def dtype_suffix_from_defines(defines):
    if macro_enabled(defines, "PACE_DTYPE_BFP16") or macro_enabled(defines, "PACE_DTYPE_BF16"):
        return "h"
    if macro_enabled(defines, "PACE_DTYPE_FP16") or macro_enabled(defines, "ENABLE_FP16"):
        return "h"
    return "s"


def pace_mode_from_defines(defines):
    for macro, mode in PACE_MODE_BY_MACRO:
        if macro_enabled(defines, macro):
            return mode
    return "pwpa"


def infer_elementwise_mnemonics(defines):
    suffix = dtype_suffix_from_defines(defines)
    mode = pace_mode_from_defines(defines)
    if macro_enabled(defines, "PACE_EXEC_SCALAR"):
        return [f"pace.{mode}.{suffix}"]
    return [f"vpace.{mode}.{suffix}"]


def infer_softmax_mnemonics(defines):
    suffix = dtype_suffix_from_defines(defines)
    inv_prefix = "vpace" if macro_int(defines, "PACE_LANES", 1) > 1 else "pace"
    return [f"vpace.pwpa.{suffix}", f"{inv_prefix}.inv.{suffix}"]


def infer_expected_mnemonics(defines):
    if "Q_SIZE" in defines and "SOFTMAX_UNROLL" in defines:
        return infer_softmax_mnemonics(defines)
    if any(name in defines for name, _ in PACE_MODE_BY_MACRO):
        return infer_elementwise_mnemonics(defines)
    return []


def find_objdump():
    binroot = os.environ.get("SN_LLVM_BINROOT")
    candidates = []
    if binroot:
        candidates.append(Path(binroot) / "llvm-objdump")
    candidates.append(_REPO_ROOT / "llvm-project" / "install" / "bin" / "llvm-objdump")
    path_objdump = shutil.which("llvm-objdump")
    if path_objdump:
        candidates.append(Path(path_objdump))
    for candidate in candidates:
        if candidate and candidate.exists():
            return candidate
    return None


class PaceVerifier(Verifier):
    OUTPUT_UIDS = ["ofmap", "golden"]
    EXPECTED_MNEMONICS = ()

    def parser(self):
        parser = super().parser()
        parser.add_argument(
            "--static-only",
            action="store_true",
            help="Check generated data.h and ELF disassembly without running simulation",
        )
        parser.add_argument(
            "--skip-bp-mode-check",
            action="store_true",
            help="Do not require PACE_BP_MODE_NONUNIFORM in generated data.h",
        )
        parser.add_argument(
            "--skip-pace-instruction-check",
            action="store_true",
            help="Do not check ELF disassembly for expected PACE mnemonics",
        )
        parser.add_argument(
            "--expect-pace",
            action="append",
            default=[],
            help="Additional PACE mnemonic that must appear in the ELF disassembly",
        )
        return parser

    def __init__(self):
        super().__init__()
        self.data_h_text = read_data_header(self.args.snitch_bin)
        self.defines = parse_defines(self.data_h_text)
        self.prec = detect_precision_from_defines(self.defines)

    def get_actual_results(self):
        return self.get_output_from_symbol("ofmap", ctype_from_pace_precision(self.prec))

    def get_expected_results(self):
        return self.get_output_from_symbol("golden", ctype_from_pace_precision(self.prec))

    def check_results(self, *args):
        return super().check_results(*args, rtol=0)

    def expected_mnemonics(self):
        expected = list(self.EXPECTED_MNEMONICS)
        if not expected:
            expected = infer_expected_mnemonics(self.defines)
        expected.extend(self.args.expect_pace)
        return expected

    def check_bp_mode(self):
        if self.args.skip_bp_mode_check:
            return 0
        if not macro_enabled(self.defines, "PACE_BP_MODE_NONUNIFORM"):
            print("PACE verify failed: generated data.h does not enable PACE_BP_MODE_NONUNIFORM")
            return 1
        return 0

    def check_disassembly(self):
        if self.args.skip_pace_instruction_check:
            return 0
        expected = self.expected_mnemonics()
        if not expected:
            print("PACE verify warning: no expected PACE mnemonics inferred")
            return 0
        objdump = find_objdump()
        if objdump is None:
            print("PACE verify failed: could not find llvm-objdump")
            return 1
        result = subprocess.run(
            [str(objdump), "-d", self.args.snitch_bin],
            check=False,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            universal_newlines=True,
        )
        if result.returncode != 0:
            print(result.stderr)
            print("PACE verify failed: llvm-objdump could not disassemble the ELF")
            return 1
        missing = [mnemonic for mnemonic in expected if mnemonic not in result.stdout]
        if missing:
            print(f"PACE verify failed: missing expected instruction(s): {', '.join(missing)}")
            return 1
        print(f"PACE static checks passed: {', '.join(expected)}")
        return 0

    def check_static(self):
        return self.check_bp_mode() or self.check_disassembly()

    def main(self):
        static_ret = self.check_static()
        if static_ret or self.args.static_only:
            return static_ret
        return super().main()
