// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Without CAQ, all checks in all cores should fail (return 8*0b11111 == 248).
// With CAQ, all checks in all cores should pass (return 8*0b00000 == 0).

#include <snrt.h>

#define NUM_WORKERS 4

// To prevent X reads on non-CAQ-proofed systems, we need a sync
inline void fp_sync() {
    asm volatile(
        "fmv.x.w  t0, ft3  \n"
        "mv       zero, t0 \n"
        "fence             \n" ::
            : "t0", "memory");
}

int main() {
    uint32_t core_id = snrt_cluster_core_idx();

    // Only use one cluster
    if (snrt_cluster_idx() != 0 || core_id >= NUM_WORKERS) {
        snrt_cluster_hw_barrier();
        snrt_cluster_hw_barrier();
        return 0;
    }

    // Allocate and initialize common return for all cores
    volatile uint32_t *ret = (volatile uint32_t *)snrt_l1_next();
    if (core_id == 0) {
        *ret = NUM_WORKERS * 0b11111;
        asm volatile("fence" ::: "memory");
    }
    snrt_cluster_hw_barrier();

    // Allocate 8 doubles to work on on stack; 4 inputs and 5 outputs
    volatile double work[9] = {3.4232857249561 + 0.565 * core_id,  // in0
                               2.3164242512938 + 0.565 * core_id,  // in1
                               8.3332613559798 + 0.565 * core_id,  // in2
                               5.6413213082822 + 0.565 * core_id,  // in3
                               -1.0,
                               -1.0,
                               -1.0,
                               -1.0,
                               -1.0};

    // Ensure FP data is written even without CAQ (prevents X loads)
    fp_sync();

    // Test integer-FP load-store races using FREP
    asm volatile(
        // Preload t0-2 with zero
        "mv       t0, zero             \n"
        "mv       t1, zero             \n"
        "mv       t2, zero             \n"
        // Preload ft0-7 with in0-3 and in3-0 (reversed)
        "fld      ft0,   (0*8)  (%[b]) \n"
        "fld      ft1,   (1*8)  (%[b]) \n"
        "fld      ft2,   (2*8)  (%[b]) \n"
        "fld      ft3,   (3*8)  (%[b]) \n"
        "fld      ft4,   (3*8)  (%[b]) \n"
        "fld      ft5,   (2*8)  (%[b]) \n"
        "fld      ft6,   (1*8)  (%[b]) \n"
        "fld      ft7,   (0*8)  (%[b]) \n"
        // Stall-spam sequencer: ensures fsd's happen *after* lw's without CAQ
        "fmadd.d  ft0, ft2, ft3, ft0   \n"
        "fmadd.d  ft0, ft2, ft3, ft0   \n"
        "fmadd.d  ft0, ft2, ft3, ft0   \n"
        "fmadd.d  ft0, ft2, ft3, ft0   \n"
        // Fill buffer with float stores and issue integer loads at the same
        // time. The integer loads should *not* overtake the first (nonrepeat)
        // stores. The repeated stores overwriting the to-be-loaded data
        // *should* be overtaken and *not* block the (nonrepeated) integer
        // loads. In the end, the integer regs should contain the LSWs of
        // in0-2 and work[4:7] should contain in3-0 (reverse order).
        "frep.o %[c4], 4, 7, 0b0100    \n"
        "fsd      ft0,   (4*8)  (%[b]) \n"
        "lw       t0,    (4*8)  (%[b]) \n"
        "fsd      ft1,   (5*8)  (%[b]) \n"
        "lw       t1,    (5*8)  (%[b]) \n"
        "fsd      ft2,   (6*8)  (%[b]) \n"
        "lw       t2,    (6*8)  (%[b]) \n"
        "fsd      ft3,   (7*8)  (%[b]) \n"
        // Synchronize to wait for FREP to conclude
        "fmv.x.w  t3, ft3              \n"
        "mv       zero, t3             \n"
        // Preload t3-t4 with in1
        "lw       t3,    (1*8)  (%[b]) \n"
        "lw       t4,  (1*8+4)  (%[b]) \n"
        // We check the contents of t0-2 by overwriting the LSWs of work[7:5].
        // This should not change work[7:5] unless t0-2 are wrong.
        "sw       t0,    (7*8)  (%[b]) \n"
        "sw       t1,    (6*8)  (%[b]) \n"
        "sw       t2,    (5*8)  (%[b]) \n"
        // Quick nonverifying check with a single-instruction FREP.I.
        // Make sure in trace this does not stall with different targets
        "frep.i   %[c100], 1, 3, 0b001 \n"
        "fsd      ft1,   (4*8)  (%[b]) \n"
        "lw       t0,    (4*8)  (%[b]) \n"
        // Stall-spam sequencer to ensure FPSS is behind on execution
        "fmadd.d  ft0, ft2, ft3, ft0   \n"
        "fmadd.d  ft0, ft2, ft3, ft0   \n"
        "fmadd.d  ft0, ft2, ft3, ft0   \n"
        "fmadd.d  ft0, ft2, ft3, ft0   \n"
        // We check FREP.I by repeatedly loading (for a sufficiently long time)
        // work[4], which we write in3 to using the integer core. The needed
        // instructions for the latter are issued *after* the FREP, but should
        // overtake repeated loads (at least the last), leading to a repeated
        // store of in3 in work[8] previously containing in1. We Finally mutate
        // work[8] with itself to ensure our float store blocks the int load.
        "fsd      ft1,   (8*8)  (%[b]) \n"
        "frep.i   %[c100], 2, 3, 0b0   \n"
        "fld      ft0,   (4*8)  (%[b]) \n"
        "lw       t0,    (3*8)  (%[b]) \n"
        "lw       t1,  (3*8+4)  (%[b]) \n"
        "sw       t0,    (4*8)  (%[b]) \n"
        "sw       t1,  (4*8+4)  (%[b]) \n"
        "fsd      ft0,   (8*8)  (%[b]) \n"
        // Try to spoil later store of in1 in work[4] if core skips FREP.
        "fsd      ft3,   (4*8)  (%[b]) \n"
        // Load LSW of just-stored work[8] into t0 to get in3, not in0.
        "lw       t0,    (8*8)  (%[b]) \n"
        // Store to work[4] to observe possible reorder of next step.
        // If this goes wrong, work[4] will contain in3 in the end, not in1.
        "fsd      ft3,   (8*8)  (%[b]) \n"
        // Store in1 to work[4] with integer core. If we have no CAQ,
        // we skip past the FREP and this results in incorrect work[8].
        // We store only the LSW to ensure this happens after the prior fsd.
        "sw       t3,    (4*8)  (%[b]) \n"
        "sw       t4,  (4*8+4)  (%[b]) \n"
        // Synchronize
        "fmv.x.w  t3, ft0              \n"
        "mv       zero, t3             \n"
        // Store t0 back to LSW of work[8] which should not mutate it.
        "sw       t0,    (8*8)  (%[b]) \n" ::[b] "r"(work),
        [ c4 ] "r"(4), [ c100 ] "r"(100)
        : "t0", "t1", "t2", "t3", "t4", "ft0", "ft1", "ft2", "ft3", "ft4",
          "ft5", "ft6", "ft7", "memory");

    // Ensure integer stores are written
    fp_sync();

    // Verify contents of output fields
    volatile uint32_t o0c = (work[7] == work[0]);
    volatile uint32_t o1c = (work[6] == work[1]);
    volatile uint32_t o2c = (work[5] == work[2]);
    volatile uint32_t o3c = (work[4] == work[1]);
    volatile uint32_t o4c = (work[8] == work[3]);

    // Compose, atomically add output nibble
    volatile uint32_t ret_loc = ((o4c & 1) << 4) | ((o3c & 1) << 3) |
                                ((o2c & 1) << 2) | ((o1c & 1) << 1) | (o1c & 1);
    __atomic_fetch_add(ret, -ret_loc, __ATOMIC_RELAXED);

    // Let us see if all cores arrive here
    snrt_cluster_hw_barrier();
    return (core_id == 0 ? *ret : 0);
}
