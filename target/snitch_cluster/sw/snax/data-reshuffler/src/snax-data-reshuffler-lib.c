// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

#include "snax-data-reshuffler-lib.h"
#include "streamer_csr_addr_map.h"

// Set STREAMER configuration CSR
void set_data_reshuffler_csr(int tempLoop0_in, int tempLoop1_in,
                             int tempLoop2_in, int tempLoop3_in,
                             int tempLoop4_in, int tempStride0_in,
                             int tempStride1_in, int tempStride2_in,
                             int tempStride3_in, int tempStride4_in,
                             int spatialStride1_in, int tempLoop0_out,
                             int tempLoop1_out, int tempLoop2_out,
                             int tempStride0_out, int tempStride1_out,
                             int tempStride2_out, int spatialStride1_out,
                             int32_t delta_local_in, int32_t delta_local_out) {
    // base ptr for data reader (In)
    csrw_ss(BASE_PTR_READER_0_LOW, (uint32_t)(delta_local_in + snrt_l1_next()));

    // fixed spatial strides for data reader (In)
    csrw_ss(S_STRIDE_READER_0_0, spatialStride1_in);

    // temporal loop bounds, from innermost to outermost for data reader (In)
    csrw_ss(T_BOUND_READER_0_0, tempLoop0_in);
    csrw_ss(T_BOUND_READER_0_1, tempLoop1_in);
    csrw_ss(T_BOUND_READER_0_2, tempLoop2_in);
    csrw_ss(T_BOUND_READER_0_3, tempLoop3_in);
    csrw_ss(T_BOUND_READER_0_4, tempLoop4_in);

    // temporal strides for data reader (In)
    csrw_ss(T_STRIDE_READER_0_0, tempStride0_in);
    csrw_ss(T_STRIDE_READER_0_1, tempStride1_in);
    csrw_ss(T_STRIDE_READER_0_2, tempStride2_in);
    csrw_ss(T_STRIDE_READER_0_3, tempStride3_in);
    csrw_ss(T_STRIDE_READER_0_4, tempStride4_in);

    // base ptr for data writer (Out)
    csrw_ss(BASE_PTR_WRITER_0_LOW,
            (uint32_t)(delta_local_out + snrt_l1_next()));

    // fixed spatial strides for data writer (Out)
    csrw_ss(S_STRIDE_WRITER_0_0, spatialStride1_out);

    // temporal loop bounds, from innermost to outermost for data writer (Out)
    csrw_ss(T_BOUND_WRITER_0_0, tempLoop0_out);
    csrw_ss(T_BOUND_WRITER_0_1, tempLoop1_out);
    csrw_ss(T_BOUND_WRITER_0_2, tempLoop2_out);

    // temporal strides for data writer (Out)
    csrw_ss(T_STRIDE_WRITER_0_0, tempStride0_out);
    csrw_ss(T_STRIDE_WRITER_0_1, tempStride1_out);
    csrw_ss(T_STRIDE_WRITER_0_2, tempStride2_out);
}

// Set CSR to start STREAMER
void start_streamer() { csrw_ss(STREAMER_START_CSR, 1); }

void wait_streamer() { csrw_ss(STREAMER_START_CSR, 0); }

#define DATA_RESHUFFLER_CSR_ADDR_BASE (STREAMER_PERFORMANCE_COUNTER_CSR + 1)
#define DATA_RESHUFFLER_SETTING (DATA_RESHUFFLER_CSR_ADDR_BASE + 0)
#define DATA_RESHUFFLER_START (DATA_RESHUFFLER_CSR_ADDR_BASE + 1)
#define DATA_RESHUFFLER_BUSY (DATA_RESHUFFLER_CSR_ADDR_BASE + 2)
#define DATA_RESHUFFLER_PERFORMANCE_COUNTER (DATA_RESHUFFLER_CSR_ADDR_BASE + 3)

void set_data_reshuffler(int T2Len, int reduceLen, int opcode) {
    // set transpose or not
    uint32_t csr0 = ((uint32_t)T2Len << 8) | ((uint32_t)reduceLen << 2) |
                    ((uint32_t)opcode);
    csrw_ss(DATA_RESHUFFLER_SETTING, csr0);
}

void start_data_reshuffler() { csrw_ss(DATA_RESHUFFLER_START, 1); }

void wait_data_reshuffler() { csrw_ss(DATA_RESHUFFLER_START, 0); }

uint32_t read_data_reshuffler_perf_counter() {
    uint32_t perf_counter = csrr_ss(DATA_RESHUFFLER_PERFORMANCE_COUNTER);
    return perf_counter;
}

uint32_t test_a_chrunk_of_data(int8_t* base_ptr_local, int8_t* base_ptr_l2,
                               int len) {
    uint32_t error = 0;
    for (int i = 0; i < len; i++) {
        if ((int8_t)base_ptr_local[i] != (int8_t)base_ptr_l2[i]) {
            // printf(
            //     "Error: after reshuffle base_ptr_local[%d] = %d, golden "
            //     "base_ptr_l2[%d] = %d \n",
            //     i, (int8_t)base_ptr_local[i], i, (int8_t)base_ptr_l2[i]);
            error++;
        }
    }
    return error;
}
