// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Without CAQ, all checks in all cores should fail (return 8*0b1111 == 120).
// With CAQ, all checks in all cores should pass (return 8*0b0000 == 0).

#include <snrt.h>

#define NUM_WORKERS 4

// To prevent X reads on non-CAQ-proofed systems, we need a sync
static inline void fp_sync() {
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
        *ret = NUM_WORKERS * 0b1111;
        asm volatile("fence" ::: "memory");
    }
    snrt_cluster_hw_barrier();

    // Allocate 8 doubles to work on on stack; 4 inputs and 4 outputs
    volatile double work[8] = {3.4232857249561 + 0.565 * core_id,  // in0
                               2.3164242512938 + 0.565 * core_id,  // in1
                               8.3332613559798 + 0.565 * core_id,  // in2
                               5.6413213082822 + 0.565 * core_id,  // in3
                               -1.0,
                               -1.0,
                               -1.0,
                               -1.0};

    // Ensure FP data is written even without CAQ (prevents X loads)
    fp_sync();

    // Test integer-FP load-store races
    asm volatile(
        // Preload ft0 with in0
        "fld      ft0,   0      (%[b]) \n"
        // Preload ft0 with in1
        "fld      ft1,  (1*8)   (%[b]) \n"
        // Preload {t1, t0} with in2
        "lw       t0,   (2*8)   (%[b]) \n"
        "lw       t1,   (2*8+4) (%[b]) \n"
        // Preload {t3, t2} with in3
        "lw       t2,   (3*8)   (%[b]) \n"
        "lw       t3,   (3*8+4) (%[b]) \n"
        // Preload work[4] with in2 (x guard)
        "sw       t0,   (4*8)   (%[b]) \n"
        "sw       t1,   (4*8+4) (%[b]) \n"
        // Preload work[5] with in3 (x guard)
        "sw       t2,   (5*8)   (%[b]) \n"
        "sw       t3,   (5*8+4) (%[b]) \n"

        // FS -> IL race: {t1, t0} should contain in0 at end, *not* in2
        "fsd      ft0,  (4*8)   (%[b]) \n"
        "lw       t0,   (4*8)   (%[b]) \n"
        "lw       t1,   (4*8+4) (%[b]) \n"
        // FS -> IS race: work[4] should contain in0 at end, *not* in1 or in2
        "fsd      ft1,  (4*8)   (%[b]) \n"
        "sw       t0,   (4*8)   (%[b]) \n"
        "sw       t1,   (4*8+4) (%[b]) \n"
        // FL -> IS race: ft2 should contain in0 at end, *not* in3
        "fld      ft2,  (4*8)   (%[b]) \n"
        "sw       t2,   (5*8)   (%[b]) \n"
        "sw       t3,   (5*8+4) (%[b]) \n"
        // WB: work[5] should contain in0 at end, *not* in1, in2 or in3
        "fsd      ft2,  (5*8)   (%[b]) \n"
        // FL -> Atomic race: AMOs modify memory!
        "fld      ft2,  (3*8)   (%[b]) \n"
        "fsd      ft2,  (6*8)   (%[b]) \n"
        "addi     t0, %[b], (6*8)      \n"
        "addi     t1, zero, 0xF        \n"
        // Stall-spam sequencer: ensures fld happens *after* atomic without CAQ
        "fmadd.d  ft0, ft2, ft3, ft0   \n"
        "fmadd.d  ft0, ft2, ft3, ft0   \n"
        "fmadd.d  ft0, ft2, ft3, ft0   \n"
        "fmadd.d  ft0, ft2, ft3, ft0   \n"
        // WB: work[7] should be in1 (unmutated) and work[6] in1 with mant.+0xF
        "fsd      ft1,  (6*8)   (%[b]) \n"
        "amoadd.w t2, t1, (t0)         \n"
        "fsd      ft1,  (7*8)   (%[b]) \n"
        // Sync before AMO writeback to prevent race with fsd without CAQ
        "fmv.x.w  t0, ft3              \n"
        "mv       zero, t0             \n"
        "sw       t2,   (7*8)   (%[b]) \n" ::[b] "r"(work)
        : "t0", "t1", "t2", "t3", "ft0", "ft1", "ft2", "memory");

    // Replicate AMO magic (with necessary syncs)
    volatile double tmp = work[1];
    fp_sync();
    volatile uint32_t *tmp_lo = (volatile uint32_t *)(void *)&tmp;
    *tmp_lo += 0xF;
    fp_sync();

    // Verify contents of output fields
    volatile uint32_t o0c = (work[4] == work[0]);
    volatile uint32_t o1c = (work[5] == work[0]);
    volatile uint32_t o2c = (work[6] == tmp);
    volatile uint32_t o3c = (work[7] == work[1]);

    // Compose, atomically add output nibble
    volatile uint32_t ret_loc =
        ((o3c & 1) << 3) | ((o2c & 1) << 2) | ((o1c & 1) << 1) | (o1c & 1);
    __atomic_fetch_add(ret, -ret_loc, __ATOMIC_RELAXED);

    // Let us see if all cores arrive here
    snrt_cluster_hw_barrier();
    return (core_id == 0 ? *ret : 0);
}
