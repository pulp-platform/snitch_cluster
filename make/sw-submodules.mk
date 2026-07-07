# Copyright 2026 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

ifndef SN_SW_SUBMODULES_MK
SN_SW_SUBMODULES_MK := 1

# Keep Bender checkouts cheap: initialize only the SW submodules needed by the
# selected target, and leave large/ASIC-only submodules untouched.
SN_SW_SUBMODULE_MARKERS = $(SN_ROOT)/sw/deps/printf/printf.h
SN_SW_SUBMODULE_MARKERS += $(SN_ROOT)/sw/deps/riscv-opcodes/encoding.h
SN_SW_SUBMODULE_MARKERS += $(SN_ROOT)/sw/runtime/src/../../deps/riscv-opcodes/encoding.h
SN_SW_SUBMODULE_MARKERS += $(SN_ROOT)/sw/deps/riscv-tests/isa/rv32ui/Makefrag

.PHONY: sn-sw-submodules
sn-sw-submodules:
	git -C $(SN_ROOT) submodule update --init --recursive sw/deps/printf sw/deps/riscv-opcodes sw/deps/riscv-tests

$(SN_SW_SUBMODULE_MARKERS): sn-sw-submodules

endif
