
#include "data.h"
#include "snrt.h"
#include "stdint.h"
#include <stdbool.h>
#include "snax_gemm_lib.h"

// gen random data
// allocate space in TCDM
// write data from l3 to tcdm
// config csr
// wait until finish
// check result

int32_t gen_size_config(uint8_t Batch, uint8_t M, uint8_t K, uint8_t N){
    return ((int32_t)Batch << 24) | ((int32_t)M << 16) | ((int32_t)K << 8) | (int32_t)N;
}

bool base_gemm(int m, int k, int n, uint8_t* A, uint8_t* B, uint32_t* C_cpu){

    if (snrt_is_compute_core()) {
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                C_cpu[i * k + j] = 0;
                for (int s = 0; s < k; s++) {
                    C_cpu[i * k + j] =
                        C_cpu[i * k + j] +
                        (uint32_t)A[i * k + s] * (uint32_t)B[s + j * k];
                }
            }
        }
    };

    return 0;

}

bool batch_gemm(uint8_t Batch, uint8_t M, uint8_t K, uint8_t N, uint8_t* A, uint8_t* B, uint32_t* C, uint32_t ldA, uint32_t ldB,uint32_t ldC, uint32_t strideA,uint32_t strideB,uint32_t strideC){

    uint8_t* start_addr_a = A;
    uint8_t* start_addr_b = B;
    uint32_t* start_addr_c = C;
    uint8_t* addr_a;
    uint8_t* addr_b;
    uint32_t* addr_c;

    // Read the mcycle CSR (this is our way to mark/delimit a specific code
    // region for benchmarking)
    uint32_t start_cycle = snrt_mcycle();
    
    if (snrt_is_compute_core()) {
        for (int b = 0; b < Batch; b++) {
            for (int m = 0; m < M; m++) {
                for (int n = 0; n < N; n++) {
                    for (int k = 0; k < K; k++) {
                        addr_a = start_addr_a + b * strideA + m * ldA + k * baseAddrIncrementA;
                        addr_b = start_addr_b + b * strideB + n * ldB + k * baseAddrIncrementB;
                        addr_c = start_addr_c + b * strideC + m * ldC + n * baseAddrIncrementC;
                        base_gemm(meshRow, tileSize, meshCol, addr_a, addr_b, addr_c);
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

int main() {
    // Set err value for checking
    int err = 0;

    // Prepare addresses in TCDM
    uint8_t *local_a, *local_b;
    uint32_t *local_c;

    // Allocate space in TCDM
    uint32_t m = M * meshRow;
    uint32_t k = K * tileSize;
    uint32_t n = N * meshRow;
    local_a = (uint8_t *)snrt_l1_next();
    local_b = local_a + m * k * sizeof(uint8_t) + 64;
    local_c = (uint32_t *)(local_b + n * k * sizeof(uint8_t));

    uint32_t dma_pre_load = snrt_mcycle();

    // Transfer data from L3 to L1
    // Using DMA only
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(local_a, A, m * k * sizeof(uint8_t));
        snrt_dma_start_1d(local_b, B, n * k * sizeof(uint8_t));
    }

    // Wait for DMA to finish
    snrt_cluster_hw_barrier();

    if (snrt_is_compute_core()) {
        // This marks the start of the accelerator style of MAC operation
        uint32_t csr_set = snrt_mcycle();

        // Set addresses
        write_csr(0x3c0, (uint32_t)local_a);
        write_csr(0x3c1, (uint32_t)local_b);
        write_csr(0x3c2, (uint32_t)local_c);

        write_csr(0x3c3, gen_size_config(Batch, M, K ,N));

        write_csr(0x3c4,128);
        write_csr(0x3c5,128);
        write_csr(0x3c6,512);

        write_csr(0x3c7,0);
        write_csr(0x3c8,0);
        write_csr(0x3c9,0);

        // CSR start
        write_csr(0x3ca, 1);

        // Start of CSR start and poll until accelerator finishes
        uint32_t gemm_start = snrt_mcycle();

        uint32_t break_poll;

        while(1){
            // STATE_CSR is the CSR address for accelerator status
            break_poll = read_csr(0x3ca);
            if(break_poll == 1){
                break;
            };
        };

        uint32_t gemm_end = snrt_mcycle();

        printf("cycle number for Gemm to do matrix multiply: %d \n",
               gemm_end - dma_pre_load);

        for (int i = 0; i < M * meshRow; i++) {
            for (int j = 0; j < N * meshCol; j++) {
                printf("C[%d][%d] = %d\n", i, j, *(local_c + (i * n + j)));
            }
        }

        uint32_t end_of_check = snrt_mcycle();
    };

    // snrt_cluster_hw_barrier();

    if(snrt_is_compute_core()){
        batch_gemm(Batch,M,K,N,A,B,C_cpu,128,128,512,0,0,0);
    }

    return err;
}
