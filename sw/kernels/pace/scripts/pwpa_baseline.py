# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import os
import numpy as np

# -------------------------------------------------
# FP16 helpers
# -------------------------------------------------

def f16(x):
    return np.float16(x)

def f16_to_u16(x):
    return int(np.float16(x).view(np.uint16))

def f16_hex(x):
    return f"0x{f16_to_u16(x):04x}"

def fma_fp16(a, b, c):
    """
    Emulate fused FP16 FMA:
    - Cast inputs to FP64
    - Compute a*b + c in FP64
    - Cast once back to FP16
    """
    a64 = np.float64(a)
    b64 = np.float64(b)
    c64 = np.float64(c)

    result64 = a64 * b64 + c64   # high precision
    return np.float16(result64)  # single rounding to FP16


# -------------------------------------------------
# Random FP16 generator
# -------------------------------------------------

def random_fp16(rng):
    sign = -1 if rng.random() > 0.5 else 1
    exp = rng.integers(-8, 8)
    mant = 1.0 + rng.random()
    return f16(sign * mant * (2.0 ** exp))

# -------------------------------------------------
# Main generator
# -------------------------------------------------

def generate(N=32, seed=1, outdir="poly_deg1_two_sets"):
    rng = np.random.default_rng(seed)
    os.makedirs(outdir, exist_ok=True)

    # -------------------------------------------------
    # Two coefficient sets
    # y = a1*x + a0
    # -------------------------------------------------

    coeff_set0 = [random_fp16(rng), random_fp16(rng)]  # [a1, a0]
    coeff_set1 = [random_fp16(rng), random_fp16(rng)]  # [a1, a0]

    # -------------------------------------------------
    # Input tensor 16 x N
    # -------------------------------------------------

    x = np.array(
        [random_fp16(rng) for _ in range(16 * N)],
        dtype=np.float16
    ).reshape(16, N)

    # Nx16 memory layout
    x_mem = x.T

    # ==================================================
    # HEADER FILE
    # ==================================================

    header_file = os.path.join(outdir, f"poly_deg1_{N}x16.h")

    with open(header_file, "w") as f:

        f.write("#ifndef POLY_DEG1_STIM_H\n")
        f.write("#define POLY_DEG1_STIM_H\n\n")
        f.write("#include <stdint.h>\n\n")
        f.write(f"#define POLY_N {N}\n\n")

        f.write("// Coefficient Set 0: y = a1*x + a0\n")
        f.write("static const uint16_t coeff_set0[2] = {\n")
        for c in coeff_set0:
            f.write(f"    {f16_hex(c)},\n")
        f.write("};\n\n")

        f.write("// Coefficient Set 1: y = a1*x + a0\n")
        f.write("static const uint16_t coeff_set1[2] = {\n")
        for c in coeff_set1:
            f.write(f"    {f16_hex(c)},\n")
        f.write("};\n\n")

        f.write("// Input tensor [N][16]\n")
        f.write(f"static const uint16_t poly_input[{N}][16] = {{\n")

        for row in range(N):
            f.write("    { ")
            for lane in range(16):
                f.write(f"{f16_hex(x_mem[row, lane])}")
                if lane != 15:
                    f.write(", ")
            f.write(" }")
            if row != N - 1:
                f.write(",")
            f.write("\n")

        f.write("};\n\n")
        f.write("#endif\n")

    # ==================================================
    # DEBUG FILE
    # ==================================================

    debug_file = os.path.join(outdir, f"debug_{N}.log")

    with open(debug_file, "w") as fd:

        fd.write("Degree-1 Polynomial Debug Log\n\n")

        fd.write("Coefficient Set 0:\n")
        fd.write(f"a1 = {f16_hex(coeff_set0[0])}\n")
        fd.write(f"a0 = {f16_hex(coeff_set0[1])}\n\n")

        fd.write("Coefficient Set 1:\n")
        fd.write(f"a1 = {f16_hex(coeff_set1[0])}\n")
        fd.write(f"a0 = {f16_hex(coeff_set1[1])}\n\n")

        # Process 4 FMAs per iteration
        # Each column has 16 lanes → 4 iterations per column

        for col in range(N):

            fd.write(f"\n================ COLUMN {col} ================\n")

            for iter_idx in range(4):

                # Select coefficient set
                if iter_idx % 2 == 0:
                    coeffs = coeff_set0
                    set_name = "SET0"
                else:
                    coeffs = coeff_set1
                    set_name = "SET1"

                fd.write(f"\nIteration {iter_idx} using {set_name}\n")

                # 4 lanes per iteration
                for lane in range(iter_idx * 4, (iter_idx + 1) * 4):

                    xi = x_mem[col, lane]

                    A = coeffs[0]  # a1
                    B = xi
                    C = coeffs[1]  # a0

                    y = fma_fp16(A, B, C)

                    fd.write(
                        f"Lane {lane}: "
                        f"A={f16_hex(A)} "
                        f"B={f16_hex(B)} "
                        f"C={f16_hex(C)} "
                        f"OUT={f16_hex(y)}\n"
                    )

    print(f"Generated degree-1 stimuli + debug for {N}x16")

# -------------------------------------------------
# Run for required sizes
# -------------------------------------------------

if __name__ == "__main__":
    for N in [32, 64, 128, 256, 512, 1024]:
        generate(N)
