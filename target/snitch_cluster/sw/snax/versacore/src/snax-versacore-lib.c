// Copyright 2025 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

#include "snax-versacore-lib.h"
#include <stdbool.h>
#include "snrt.h"
#include "stdint.h"
#include "streamer_csr_addr_map.h"

int32_t gen_subtraction_config(int8_t subtraction_a, int8_t subtraction_b) {
    return ((uint8_t)subtraction_b << 8) | (uint8_t)subtraction_a;
}

void set_versacore_streamer_csr(
    int32_t delta_local_a, int32_t* Aslstride, int32_t* Atlbound,
    int32_t* Atlstride, int32_t set_addr_remap_index_A, int32_t transpose_A,
    int32_t* channel_en_A,

    int32_t delta_local_b, int32_t* Bslstride, int32_t* Btlbound,
    int32_t* Btlstride, int32_t set_addr_remap_index_B, int32_t transpose_B,
    int32_t* channel_en_B,

    int32_t delta_local_c, int32_t* Cslstride, int32_t* Ctlbound,
    int32_t* Ctlstride, int32_t set_addr_remap_index_C, int32_t* channel_en_C,
    int32_t broadcast_C,

    int32_t delta_local_d32, int32_t* D32slstride, int32_t* D32tlbound,
    int32_t* D32tlstride, int32_t set_addr_remap_index_D32,
    int32_t* channel_en_D) {
#ifdef SNAX_OPENGEMM_OUTPUT_STATIONARY_ONLY

    // ----------------------------------A-----------------------------------
    // ----------------------------------A-----------------------------------
    // ----------------------------------A-----------------------------------
    // base ptr for A
    csrw_ss(BASE_PTR_READER_0_LOW, (uint32_t)(delta_local_a + snrt_l1_next()));

    // spatial strides for A
    for (int i = 0; i < S_STRIDE_NUM_READER_0; i++) {
        csrw_ss(S_STRIDE_BASE_READER_0 + i, Aslstride[i]);
    }

    // loop bounds, from innermost to outermost, for data mover A
    for (int i = 0; i < T_BOUND_NUM_READER_0; i++) {
        csrw_ss(T_BOUND_BASE_READER_0 + i, Atlbound[i]);
    }

    // temporal strides for A
    for (int i = 0; i < T_STRIDE_NUM_READER_0; i++) {
        csrw_ss(T_STRIDE_BASE_READER_0 + i, Atlstride[i]);
    }

    // set the address remap index for A
#ifdef ADDR_REMAP_INDEX_READER_0
    csrw_ss(ADDR_REMAP_INDEX_READER_0, set_addr_remap_index_A);
#endif

    // set the channel enable
#ifdef ENABLED_CHANNEL_READER_0
    for (int i = 0; i < ENABLED_CHANNEL_READER_0_CSR_NUM; i++) {
        csrw_ss(ENABLED_CHANNEL_READER_0 + i, channel_en_A[i]);
    }
#endif
    // ----------------------------------B-----------------------------------
    // ----------------------------------B-----------------------------------
    // ----------------------------------B-----------------------------------

    // base ptr for B
    csrw_ss(BASE_PTR_READER_1_LOW, (uint32_t)(delta_local_b + snrt_l1_next()));

    // spatial strides for B
    for (int i = 0; i < S_STRIDE_NUM_READER_1; i++) {
        csrw_ss(S_STRIDE_BASE_READER_1 + i, Bslstride[i]);
    }

    // loop bounds, from innermost to outermost, for data mover B
    for (int i = 0; i < T_BOUND_NUM_READER_1; i++) {
        csrw_ss(T_BOUND_BASE_READER_1 + i, Btlbound[i]);
    }

    // temporal strides for B
    for (int i = 0; i < T_STRIDE_NUM_READER_1; i++) {
        csrw_ss(T_STRIDE_BASE_READER_1 + i, Btlstride[i]);
    }

    // set the address remap index for B
#ifdef ADDR_REMAP_INDEX_READER_1
    csrw_ss(ADDR_REMAP_INDEX_READER_1, set_addr_remap_index_B);
#endif

    // set the channel enable
#ifdef ENABLED_CHANNEL_READER_1
    for (int i = 0; i < ENABLED_CHANNEL_READER_1_CSR_NUM; i++) {
        csrw_ss(ENABLED_CHANNEL_READER_1 + i, channel_en_B[i]);
    }
#endif

    // ----------------------------------C-----------------------------------
    // ----------------------------------C-----------------------------------
    // ----------------------------------C-----------------------------------
    // base ptr for C
    csrw_ss(BASE_PTR_READER_WRITER_0_LOW,
            (uint32_t)(delta_local_c + snrt_l1_next()));

    // spatial strides for C
    for (int i = 0; i < S_STRIDE_NUM_READER_WRITER_0; i++) {
        csrw_ss(S_STRIDE_BASE_READER_WRITER_0 + i, Cslstride[i]);
    }

    // loop bounds, from innermost to outermost, for data mover C
    for (int i = 0; i < T_BOUND_NUM_READER_WRITER_0; i++) {
        csrw_ss(T_BOUND_BASE_READER_WRITER_0 + i, Ctlbound[i]);
    }

    // temporal strides for C
    for (int i = 0; i < T_STRIDE_NUM_READER_WRITER_0; i++) {
        csrw_ss(T_STRIDE_BASE_READER_WRITER_0 + i, Ctlstride[i]);
    }

    // set the address remap index for C
#ifdef ADDR_REMAP_INDEX_READER_WRITER_0
    csrw_ss(ADDR_REMAP_INDEX_READER_WRITER_0, set_addr_remap_index_C);
#endif

    // set the channel enable
#ifdef ENABLED_CHANNEL_READER_WRITER_0
    for (int i = 0; i < ENABLED_CHANNEL_READER_WRITER_0_CSR_NUM; i++) {
        csrw_ss(ENABLED_CHANNEL_READER_WRITER_0 + i, channel_en_C[i]);
    }
#endif

    // ----------------------------------D32-----------------------------------
    // ----------------------------------D32-----------------------------------
    // ----------------------------------D32-----------------------------------
    // base ptr for D32
    csrw_ss(BASE_PTR_READER_WRITER_1_LOW,
            (uint32_t)(delta_local_d32 + snrt_l1_next()));

    // spatial strides for D32
    for (int i = 0; i < S_STRIDE_NUM_READER_WRITER_1; i++) {
        csrw_ss(S_STRIDE_BASE_READER_WRITER_1 + i, D32slstride[i]);
    }

    // for D32, from N to M

    for (int i = 0; i < T_BOUND_NUM_READER_WRITER_1; i++) {
        csrw_ss(T_BOUND_BASE_READER_WRITER_1 + i, D32tlbound[i]);
    }

    // temporal strides for D32
    for (int i = 0; i < T_STRIDE_NUM_READER_WRITER_1; i++) {
        csrw_ss(T_STRIDE_BASE_READER_WRITER_1 + i, D32tlstride[i]);
    }

    // set the address remap index for D32
#ifdef ADDR_REMAP_INDEX_READER_WRITER_1
    csrw_ss(ADDR_REMAP_INDEX_READER_WRITER_1, set_addr_remap_index_D32);
#endif

    // set the channel enable
#ifdef ENABLED_CHANNEL_READER_WRITER_1
    for (int i = 0; i < ENABLED_CHANNEL_READER_WRITER_1_CSR_NUM; i++) {
        csrw_ss(ENABLED_CHANNEL_READER_WRITER_1 + i, channel_en_D[i]);
    }
#endif

    // ------------------------- datapath extension ----------------------------
    // ------------------------- datapath extension ----------------------------
    // ------------------------- datapath extension ----------------------------

    // set the transpose
#ifdef READER_EXTENSION_0_CSR_BASE
    csrw_ss(READER_EXTENSION_0_CSR_BASE, transpose_A == 1 ? 0 : 1);
#endif

#ifdef READER_EXTENSION_1_CSR_BASE
    csrw_ss(READER_EXTENSION_1_CSR_BASE, transpose_B == 1 ? 0 : 1);
#endif

#ifdef READER_WRITER_EXTENSION_0_CSR_BASE
    csrw_ss(READER_WRITER_EXTENSION_0_CSR_BASE, broadcast_C == 1 ? 0 : 1);
#endif

#else
    // ----------------------------------A-----------------------------------
    // ----------------------------------A-----------------------------------
    // ----------------------------------A-----------------------------------
    // base ptr for A
    csrw_ss(BASE_PTR_READER_0_LOW, (uint32_t)(delta_local_a + snrt_l1_next()));

    // spatial strides for A
    for (int i = 0; i < S_STRIDE_NUM_READER_0; i++) {
        csrw_ss(S_STRIDE_BASE_READER_0 + i, Aslstride[i]);
    }

    // loop bounds, from innermost to outermost, for data mover A
    for (int i = 0; i < T_BOUND_NUM_READER_0; i++) {
        csrw_ss(T_BOUND_BASE_READER_0 + i, Atlbound[i]);
    }

    // temporal strides for A
    for (int i = 0; i < T_STRIDE_NUM_READER_0; i++) {
        csrw_ss(T_STRIDE_BASE_READER_0 + i, Atlstride[i]);
    }

    // set the address remap index for A
#ifdef ADDR_REMAP_INDEX_READER_0
    csrw_ss(ADDR_REMAP_INDEX_READER_0, set_addr_remap_index_A);
#endif

    // set the channel enable
#ifdef ENABLED_CHANNEL_READER_0
    for (int i = 0; i < ENABLED_CHANNEL_READER_0_CSR_NUM; i++) {
        csrw_ss(ENABLED_CHANNEL_READER_0 + i, channel_en_A[i]);
    }
#endif
    // ----------------------------------B-----------------------------------
    // ----------------------------------B-----------------------------------
    // ----------------------------------B-----------------------------------

    // base ptr for B
    csrw_ss(BASE_PTR_READER_1_LOW, (uint32_t)(delta_local_b + snrt_l1_next()));

    // spatial strides for B
    for (int i = 0; i < S_STRIDE_NUM_READER_1; i++) {
        csrw_ss(S_STRIDE_BASE_READER_1 + i, Bslstride[i]);
    }

    // loop bounds, from innermost to outermost, for data mover B
    for (int i = 0; i < T_BOUND_NUM_READER_1; i++) {
        csrw_ss(T_BOUND_BASE_READER_1 + i, Btlbound[i]);
    }

    // temporal strides for B
    for (int i = 0; i < T_STRIDE_NUM_READER_1; i++) {
        csrw_ss(T_STRIDE_BASE_READER_1 + i, Btlstride[i]);
    }

    // set the address remap index for B
#ifdef ADDR_REMAP_INDEX_READER_1
    csrw_ss(ADDR_REMAP_INDEX_READER_1, set_addr_remap_index_B);
#endif

    // set the channel enable
#ifdef ENABLED_CHANNEL_READER_1
    for (int i = 0; i < ENABLED_CHANNEL_READER_1_CSR_NUM; i++) {
        csrw_ss(ENABLED_CHANNEL_READER_1 + i, channel_en_B[i]);
    }
#endif

    // ----------------------------------C-----------------------------------
    // ----------------------------------C-----------------------------------
    // ----------------------------------C-----------------------------------
    // base ptr for C
    csrw_ss(BASE_PTR_READER_2_LOW, (uint32_t)(delta_local_c + snrt_l1_next()));

    // spatial strides for C
    for (int i = 0; i < S_STRIDE_NUM_READER_2; i++) {
        csrw_ss(S_STRIDE_BASE_READER_2 + i, Cslstride[i]);
    }

    // loop bounds, from innermost to outermost, for data mover C
    for (int i = 0; i < T_BOUND_NUM_READER_2; i++) {
        csrw_ss(T_BOUND_BASE_READER_2 + i, Ctlbound[i]);
    }

    // temporal strides for C
    for (int i = 0; i < T_STRIDE_NUM_READER_2; i++) {
        csrw_ss(T_STRIDE_BASE_READER_2 + i, Ctlstride[i]);
    }

    // set the address remap index for C
#ifdef ADDR_REMAP_INDEX_READER_2
    csrw_ss(ADDR_REMAP_INDEX_READER_2, set_addr_remap_index_C);
#endif

    // set the channel enable
#ifdef ENABLED_CHANNEL_READER_2
    for (int i = 0; i < ENABLED_CHANNEL_READER_2_CSR_NUM; i++) {
        csrw_ss(ENABLED_CHANNEL_READER_2 + i, channel_en_C[i]);
    }
#endif

    // ----------------------------------D32-----------------------------------
    // ----------------------------------D32-----------------------------------
    // ----------------------------------D32-----------------------------------
    // base ptr for D32
    csrw_ss(BASE_PTR_WRITER_0_LOW,
            (uint32_t)(delta_local_d32 + snrt_l1_next()));

    // spatial strides for D32
    for (int i = 0; i < S_STRIDE_NUM_WRITER_0; i++) {
        csrw_ss(S_STRIDE_BASE_WRITER_0 + i, D32slstride[i]);
    }

    // for D32, from N to M

    for (int i = 0; i < T_BOUND_NUM_WRITER_0; i++) {
        csrw_ss(T_BOUND_BASE_WRITER_0 + i, D32tlbound[i]);
    }

    // temporal strides for D32
    for (int i = 0; i < T_STRIDE_NUM_WRITER_0; i++) {
        csrw_ss(T_STRIDE_BASE_WRITER_0 + i, D32tlstride[i]);
    }

    // set the address remap index for D32
#ifdef ADDR_REMAP_INDEX_WRITER_0
    csrw_ss(ADDR_REMAP_INDEX_WRITER_0, set_addr_remap_index_D32);
#endif

    // set the channel enable
#ifdef ENABLED_CHANNEL_WRITER_0
    for (int i = 0; i < ENABLED_CHANNEL_WRITER_0_CSR_NUM; i++) {
        csrw_ss(ENABLED_CHANNEL_WRITER_0 + i, channel_en_D[i]);
    }
#endif

    // ------------------------- datapath extension ----------------------------
    // ------------------------- datapath extension ----------------------------
    // ------------------------- datapath extension ----------------------------

    // set the transpose
#ifdef READER_EXTENSION_0_CSR_BASE
    csrw_ss(READER_EXTENSION_0_CSR_BASE, transpose_A == 1 ? 0 : 1);
#endif

#ifdef READER_EXTENSION_1_CSR_BASE
    csrw_ss(READER_EXTENSION_1_CSR_BASE, transpose_B == 1 ? 0 : 1);
#endif

#ifdef READER_WRITER_EXTENSION_0_CSR_BASE
    csrw_ss(READER_WRITER_EXTENSION_0_CSR_BASE, broadcast_C == 1 ? 0 : 1);
#endif

#endif
}

// Set GEMM configuration CSR
void set_versacore_csr(uint32_t tempLoop0, uint32_t tempLoop1,
                       uint32_t tempLoop2, uint32_t subtractions,
                       uint32_t array_shape, uint32_t data_type) {
    // set loop bounds, from innermost to outermost, aka from K to N to M
    csrw_ss(T_BOUND_K, tempLoop0);
    csrw_ss(T_BOUND_N, tempLoop1);
    csrw_ss(T_BOUND_M, tempLoop2);

    // set subtraction a and b
    csrw_ss(SUBTRACTIONS, subtractions);

    // set array shape
    csrw_ss(ARRAY_SHAPE_CFG, array_shape);
    // set data type
    csrw_ss(DATA_TYPE_CFG, data_type);
}

// Stall until Streamer and GEMM accelerator finish
void wait_versacore_and_streamer() {
    csrw_ss(STREAMER_START_CSR, 0);
    csrw_ss(STREAMER_START_CSR, 0);
    csrw_ss(GEMMX_START, 0);
    while (csrr_ss(GEMMX_BUSY)) {
    }
    while (csrr_ss(STREAMER_BUSY_CSR)) {
    }
}

void wait_versacore() {
    csrw_ss(GEMMX_START, 0);
    csrw_ss(GEMMX_START, 0);
    while (csrr_ss(GEMMX_BUSY)) {
    }
}

// Read performance counter of the Streamer, a read-only CSR
uint32_t read_versacore_streamer_perf_counter() {
    uint32_t perf_counter = csrr_ss(STREAMER_PERFORMANCE_COUNTER_CSR);
    return perf_counter;
}

// Read performance counter of GEMM, a read-only CSR
uint32_t read_versacore_perf_counter() {
    uint32_t perf_counter = csrr_ss(GEMMX_PERFORMANCE_COUNTER);
    return perf_counter;
}

uint32_t check_versacore_result_D32(int8_t* output, int8_t* output_golden,
                                    int32_t data_length,
                                    bool banked_data_layout) {
    uint32_t err = 0;

    if (banked_data_layout) {
        for (int i = 0; i < data_length / 16; i += 1) {
            for (int j = 0; j < 16; j++) {
                if (*(output + i * (256 / 4) + j) !=
                    output_golden[i * 16 + j]) {
                    err++;
                }
            }
        }
    } else {
        for (int i = 0; i < data_length; i++) {
            if (output[i] != output_golden[i]) {
                err++;
                printf("Unequals. output[%d] = %d, output_golden[%d] = %d\n", i,
                       output[i], i, output_golden[i]);
            }
        }
    }

    return err;
}
