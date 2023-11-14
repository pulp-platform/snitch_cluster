
#include "data.h"

#include "snax-gemm-lib.h"

// gen random data
// allocate space in TCDM
// write data from l3 to tcdm
// config csr
// start
// wait until finish
// check result

int main() {
    // Set err value for checking
    int err = 0;

    // Prepare addresses in TCDM
    int8_t *local_a, *local_b;
    int32_t* local_c;

    // Allocate space in TCDM
    local_a = (int8_t*)snrt_l1_next();
    local_b = local_a + delta_local_a * sizeof(int8_t);
    // local_c = (int32_t*)(local_b + meshCol * tileSize * sizeof(int8_t));
    local_c = (int32_t*)(local_b + delta_local_b * sizeof(int8_t));

    uint32_t dma_pre_load = snrt_mcycle();

    // Transfer data from L3 to L1
    // Using DMA only
    load_input_data(Batch, M, K, N, local_a, local_b, A, B, strideInnermostA, strideInnermostB,
    ldA, ldB, strideA, strideB);

    // Wait for DMA to finish
    snrt_cluster_hw_barrier();

    if (snrt_is_compute_core()) {
        // This marks the start of the accelerator style of MAC
        // operation
        uint32_t csr_set = snrt_mcycle();

        // Start of CSR start and poll until accelerator finishes
        uint32_t size_setting = gen_size_config(Batch, M, K ,N);
        uint32_t gemm_start = snrt_mcycle();

        set_batch_gemm(size_setting, local_a, local_b, local_c,strideInnermostA, strideInnermostB,strideInnermostC,
        ldA,ldB, ldC, strideA, strideB, strideC);
        start_batch_gemm();
        wait_batch_gemm();

        uint32_t gemm_end = snrt_mcycle();

        printf("cycle number for Gemm to do matrix multiply: %d \n",
                gemm_end - gemm_start);

        // for (int i = 0; i < M * meshRow; i++) {
        //     for (int j = 0; j < N * meshCol; j++) {
        //         printf("C[%d][%d] = %d\n", i, j, *(local_c + (i * n +
        //         j)));
        //     }
        // }

        uint32_t end_of_check = snrt_mcycle();

        err = check_result(local_c, C_golden, Batch, M, N,strideInnermostC, ldC, strideC);
        printf("gemm err: %d\n", err);
    };

    // snrt_cluster_hw_barrier();

    // if (snrt_is_compute_core()) {
    //     batch_gemm_cpu(Batch, M, K, N, A, B, C_cpu, 128, 128, 512, 0, 0,0);

    //     err = check_result(C_cpu, C_golden, Batch, M, N, ldC, strideC);
    //     // for (int i = 0; i < M * meshRow; i++) {
    //     //     for (int j = 0; j < N * meshCol; j++) {
    //     //         printf("C_cpu[%d][%d] = %d\n", i, j, *(C_cpu + (i * n
    //     //         + j)));
    //     //     }
    //     // }
    //     printf("cpu err: %d\n", err);
    // }

    return err;
}
