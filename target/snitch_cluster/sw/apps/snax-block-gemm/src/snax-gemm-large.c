
#include "data.h"
#include "snrt.h"

int main() {
    // Set err value for checking
    int err = 0;

    // if(snrt_is_compute_core()){
    //     for(int i = 0 ; i < m ; i++){
    //         for(int s = 0 ; s < k ; s++){
    //             printf("A[%d] = %d \n", i * k + s, A[i * k + s]);
    //         }
    //     }

    //     for(int s = 0 ; s < k ; s++){
    //         for(int j = 0 ; j < n ; j++){
    //             printf("B[%d] = %d \n", s * n + j, B[s * n + j]);
    //         }
    //     }
    // }

    // Read the mcycle CSR (this is our way to mark/delimit a specific code
    // region for benchmarking)
    uint32_t start_cycle = snrt_mcycle();

    if (snrt_is_compute_core()) {
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                C_golden[i * k + j] = 0;
                for (int s = 0; s < k; s++) {
                    C_golden[i * k + j] =
                        C_golden[i * k + j] +
                        (uint32_t)A[i * k + s] * (uint32_t)B[s + j * k];
                    // snrt_cluster_hw_barrier();
                }
            }
        }

        // for(int i = 0 ; i < m ; i++){
        //     for(int j = 0 ; j < n ; j++){
        //         printf("C_golden[%d][%d] = %d\n",i,j,C_golden[i * n + j]);
        //     }
        // }

        // Read the mcycle CSR
        uint32_t end_cycle = snrt_mcycle();
        printf("cycle number for CPU to do matrix multiply: %d \n",
               end_cycle - start_cycle);
    };

    // uint32_t final_output;

    uint8_t *local_a, *local_b;
    uint32_t *local_c;

    // // Allocate space in TCDM
    local_a = (uint8_t *)snrt_l1_next();
    local_b = local_a + m * k * sizeof(uint8_t);
    local_c = (uint32_t *)(local_b + n * k * sizeof(uint8_t));

    uint32_t dma_pre_load = snrt_mcycle();

    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(local_a, A, m * k * sizeof(uint8_t));
        snrt_dma_start_1d(local_b, B, n * k * sizeof(uint8_t));
    }

    snrt_cluster_hw_barrier();

    // Read the mcycle CSR (this is our way to mark/delimit a specific code
    // region for benchmarking)
    uint32_t pre_is_compute_core = snrt_mcycle();

    if (snrt_is_compute_core()) {
        // This marks the start of the accelerator style of MAC operation
        uint32_t csr_set = snrt_mcycle();

        // Set addresses
        write_csr(0x3c0, (uint32_t)local_a);
        write_csr(0x3c1, (uint32_t)local_b);
        write_csr(0x3c2, (uint32_t)local_c);

        // CSR start
        write_csr(0x3c3, 0);

        // Start of CSR start and poll until accelerator finishes
        uint32_t gemm_start = snrt_mcycle();

        uint32_t break_poll;

        // while(1){
        //     // 0x3c4 is the CSR address for accelerator status
        //     break_poll = read_csr(0x3c4);
        //     if(break_poll == 1){
        //         break;
        //     };
        // };

        uint32_t gemm_end = snrt_mcycle();

        printf("cycle number for Gemm to do matrix multiply: %d \n",
               gemm_end - dma_pre_load);

        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                printf("C[%d][%d] = %d\n", i, j, *(local_c + (i * n + j)));
            }
        }

        uint32_t end_of_check = snrt_mcycle();
    };

    // snrt_cluster_hw_barrier();

    return err;
}
