# PACE merge decisions

## 2026-10-02

- Applied the tested reworked PACE port to the user's `doublebw-pace` Snitch
  branch and local `../spatz_vpu` branch. Neither repository was committed or
  pushed. The earlier worktrees remain only as comparison copies.
- Preserved the branch's BF16/fmatmul/kernel changes, iDMA lock and local VPU
  path. Replaced the old PACE-over-`VFMUL` dispatch and VPU-local coefficient
  buffer with explicit `PACE_*`/`VPACE_*` instructions and cluster-owned AXI
  PACE memory. The obsolete `sw/tests/src/pace_vfmul.c` and VPU
  `hw/src/pace_mem.sv` were removed; both are recoverable from Git.
- Kept normal `cfg/spatz.json` non-PACE and single-bandwidth. Added opt-in
  `cfg/spatz-pace.json` for Step 1 and `cfg/spatz-pace-doublebw.json` for
  Step 2. Double bandwidth requires both `DOUBLE_BW` and `BUF_FPU` RTL
  defines, selected by `SN_SPATZ_DOUBLE_BW=ON` in the Makefile.
- PACE instruction bit 25 is part of the operation code, not a vector-mask
  bit. Force `op_arith.vm=1` for PACE; otherwise VFU writeback is masked by
  unrelated `v0` bits. The simulator VIP adds the cluster base to generated
  scratch/CLINT offsets so the boot ROM receives its start interrupt.
- In a non-PACE build, the PACE memory has zero size. Do not install its
  direct or alias AXI rules. The packed rule-array declaration was reversed
  relative to its positional assignment, so it is now indexed `[0:7]` to
  make rule indices and feature gating agree.

## Verification on the user's branch

- `make spatz_pace_loop` with the xpace LLVM toolchain: builds.
- `make vsim` and `make vsim-run` with `cfg/spatz-pace.json`,
  `SN_SPATZ_PACE=ON`: FP32 `vpace.pwpa.s`, 8,192 elements, `errors=0`, verifier
  passes.
- The same test with `cfg/spatz-pace-doublebw.json` and
  `SN_SPATZ_DOUBLE_BW=ON`: `errors=0`, verifier passes.
- `make vsim` and fmatmul `make vsim-run` with non-PACE `cfg/spatz.json`:
  zero simulator errors and the verifier exits successfully.
- Questa still reports known DCA port-width warnings (DCA is disabled in the
  tested configs); non-PACE fmatmul simulation has one warning but no errors.

## 2026-10-07 rebase onto upstream main

- Rebased `diyou/pace-new` from merge base `5ec2bf5` onto upstream main
  `8142c0f`. All 11 branch commits replayed without textual conflicts; a
  range-diff confirmed that their patches were preserved.
- Kept the PACE Spatz dependency at `5b43f4e903ca446a99395671a80075b40861a41e`.
  Step 1 continues to use `cfg/spatz-pace.json` with double bandwidth off.
- Added compatibility for both `peakrdl-rawheader` 0.1.1 (the version locked
  by this repository and CI) and 0.2.x (used by the Gwaihir environment).
  The versions emit different address-macro names and base-name prefixes.
- Questa 2023.4 requires `vopt +acc` for the PACE payload structs; without it,
  simulation load reports unresolved struct-field references even though
  compilation and optimization report zero errors. This is enabled only for
  `SN_SPATZ_PACE=ON`.
- Rebuilt RTL and software through Make. Questa simulations pass for the FP32,
  FP16, and BF16 PACE loop variants with `SN_SPATZ_DOUBLE_BW=OFF`; every run
  reports `errors=0`, and the static verifier finds the expected PACE opcode.
  The existing DCA port-width warnings remain when DCA is disabled.
