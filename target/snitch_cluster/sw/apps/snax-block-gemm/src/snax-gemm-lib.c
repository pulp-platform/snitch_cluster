#include "snax-gemm-lib.h"

int32_t gen_size_config(uint8_t Batch, uint8_t M, uint8_t K, uint8_t N){
    return ((int32_t)Batch << 24) | ((int32_t)M << 16) | ((int32_t)K << 8) | (int32_t)N;
}

bool base_gemm(int m, int k, int n, int8_t * A, int8_t * B, int32_t* C_cpu, bool new_batch){

    if (snrt_is_compute_core()) {
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if(new_batch == true){
                    C_cpu[i * n + j] = 0;
                }
                for (int s = 0; s < k; s++) {
                    C_cpu[i * n + j] =
                        C_cpu[i * n + j] +
                        (int32_t)A[i * k + s] * (int32_t)B[s + j * k];
                }
            }
        }
    };

    return 0;

}

bool batch_gemm_cpu(uint8_t Batch, uint8_t M, uint8_t K, uint8_t N, int8_t* A, int8_t* B, int32_t* C, uint32_t ldA, uint32_t ldB,uint32_t ldC, uint32_t strideA,uint32_t strideB,uint32_t strideC){

    int8_t* start_addr_a = A;
    int8_t* start_addr_b = B;
    int32_t* start_addr_c = C;
    int8_t* addr_a;
    int8_t* addr_b;
    int32_t* addr_c;

    bool clear;

    // Read the mcycle CSR (this is our way to mark/delimit a specific code
    // region for benchmarking)
    uint32_t start_cycle = snrt_mcycle();
    
    if (snrt_is_compute_core()) {
        for (int b = 0; b < Batch; b++) {
            // new batch init
            for (int m = 0; m < M; m++) {
                for (int n = 0; n < N; n++) {
                    for (int k = 0; k < K; k++) {
                        addr_a = start_addr_a + (b * strideA + m * ldA + k * baseAddrIncrementA) / sizeof(int8_t);
                        addr_b = start_addr_b + (b * strideB + n * ldB + k * baseAddrIncrementB) / sizeof(int8_t);
                        addr_c = start_addr_c + (b * strideC + m * ldC + n * baseAddrIncrementC) / sizeof(int32_t);
                        clear = k == 0;
                        printf("b = %d, m = %d, n = %d, k = %d, clear = %d \n",
                               b, m, n, k, clear);
                        base_gemm(meshRow, tileSize, meshCol, addr_a, addr_b,
                                  addr_c, clear);
                    }
                }
            }
        } 
    }

    // Read the mcycle CSR
    uint32_t end_cycle = snrt_mcycle();
    printf("cycle number for CPU to do matrix multiply: %d \n",
            end_cycle - start_cycle);

    return 0;
}

bool load_input_data(uint8_t Batch, uint8_t M, uint8_t K, uint8_t N,int8_t *local_a, int8_t *local_b,int8_t* A, int8_t* B,
uint32_t strideInnermostA, uint32_t strideInnermostB,uint32_t ldA, uint32_t ldB, uint32_t strideA,uint32_t strideB){

    int8_t* addr_a;
    int8_t* addr_b;

    int8_t* addr_A;
    int8_t* addr_B;

    if (snrt_is_dm_core()) {
        for (int b = 0; b < Batch; b++) {
            for (int m = 0; m < M; m++) {
                // for (int n = 0; n < N; n++) {
                    for (int k = 0; k < K; k++) {    
                        addr_a = local_a + (b * strideA + m * ldA + k * strideInnermostA) / sizeof(int8_t);
                        addr_A = A + (b * M * meshRow * meshCol * N + m * meshRow * meshCol * N + k * meshRow * meshCol) / sizeof(int8_t);
                        snrt_dma_start_1d(addr_a, addr_A, meshRow * tileSize * sizeof(int8_t));
                    }
                // }
            }
        } 
    }   

    if (snrt_is_dm_core()) {
        for (int b = 0; b < Batch; b++) {
            // for (int m = 0; m < M; m++) {
                for (int n = 0; n < N; n++) {
                    for (int k = 0; k < K; k++) {    
                        addr_b = local_b + (b * strideB + n * ldB + k * strideInnermostB) / sizeof(int8_t);
                        addr_B = B + (b * M * meshRow * meshCol * N + n * meshRow * meshCol * N + k * meshRow * meshCol) / sizeof(int8_t);
                        snrt_dma_start_1d(addr_b, addr_B, meshCol * tileSize * sizeof(int8_t));
                    }
                }
            // }
        } 
    }

    return false;
}

bool set_batch_gemm(uint32_t size_setting, int8_t *local_a, int8_t *local_b, int32_t *local_c,uint32_t strideInnermostA, uint32_t strideInnermostB,uint32_t strideInnermostC,uint32_t ldA, uint32_t ldB,uint32_t ldC, uint32_t strideA,uint32_t strideB,uint32_t strideC){

    write_csr(0x3c0, size_setting);

    // Set addresses
    write_csr(0x3c1, (uint32_t)local_a);
    write_csr(0x3c2, (uint32_t)local_b);
    write_csr(0x3c3, (uint32_t)local_c);


    write_csr(0x3c4,strideInnermostA);
    // set_stride_A(ldA);
    write_csr(0x3c5,strideInnermostB);
    write_csr(0x3c6,strideInnermostC);

    write_csr(0x3c7,ldA);
    // set_stride_A(ldA);
    write_csr(0x3c8,ldB);
    write_csr(0x3c9,ldC);

    write_csr(0x3ca,strideA);
    write_csr(0x3cb,strideB);
    write_csr(0x3cc,strideC);

    return 0;

}

bool start_batch_gemm() {
    // CSR start
    write_csr(0x3ce, 1);
    return 0;
}

bool wait_batch_gemm(){
    uint32_t break_poll;

    while (1) {
        // STATE_CSR is the CSR address for accelerator status
        break_poll = read_csr(0x3ce);
        if ((break_poll >> 1) == 1) {
            break;
        };
    };

    return 0;
}

uint32_t check_result(int32_t* output, int32_t* output_golden, uint8_t Batch,
                      uint8_t M, uint8_t N, uint32_t strideInnermostC, uint32_t ldC, uint32_t strideC) {
    /*
     * Compare output to output_golden with length
     */
    uint32_t err = 0;
    uint32_t golden_idx;
    int32_t * out_addr;

    for (int b = 0; b < Batch; b++) {
        for (int m = 0; m < M; m++) {
            for (int n = 0; n < N; n++) {
                for (int i = 0; i < meshRow; i++){
                    for (int j = 0; j < meshCol; j++){
                        golden_idx = i * meshCol + j + b * M * meshRow * meshCol * N + m * meshRow * meshCol * N + n * meshRow * meshCol;
                        out_addr = output + (b * strideC + m * ldC + n * strideInnermostC) / sizeof(int32_t) + i * meshCol + j;
                        // Check if output is same as golden output
                        if ((int32_t) *out_addr != output_golden[golden_idx]) {
                            printf("%dth not equal: output %d, golden %d \n", golden_idx,
                                   (int32_t) *out_addr, output_golden[golden_idx]);
                            err++;
                        };
                    };
                }
            }
        }
    }

    return err;

}
