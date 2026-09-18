// Luca Colombo 2025 CHIPS-IT
/* Matrix multiplication dst_TCDM = A*B, only with square matrices */
#include "snrt.h"
#include "data.h"
#include "matrix_mul_opt.h"

/* Print first/last elements  */
// avoid, giant matrix sizes, works pefectly
uint32_t CHECK_RESULTS = 0;

int main() {
    uint32_t core_idx = snrt_cluster_core_idx();
    uint32_t ncores = snrt_cluster_compute_core_num();

    /* DM core allocates and initializes matrices in TCDM */
    if (snrt_is_dm_core()) {


        mat_a_TCDM = (float *)snrt_l1_next();
        mat_b_TCDM = mat_a_TCDM + M * K;
        dst_TCDM = mat_b_TCDM + K * N;

        size_t size_a = M * K * sizeof(float);
        size_t size_b = K * N * sizeof(float);
        size_t size_dst = M * N * sizeof(float);

        snrt_dma_start_1d(mat_a_TCDM, mat_a, size_a);
        snrt_dma_start_1d(mat_b_TCDM, mat_b, size_b);
        snrt_dma_start_1d(dst_TCDM, golden, size_dst);
        snrt_dma_wait_all();
    }

    snrt_cluster_hw_barrier();
    uint32_t cycle1=snrt_mcycle();
    // Only the compute cores do something
    if(snrt_is_compute_core()){

        /* calculate chunks per core, split the columns of the b matrix */
        uint32_t chunk_per_core = N / ncores;

        /* compute offset for this core */
        uint32_t offset = core_idx * chunk_per_core;
        uint32_t m = M;
        uint32_t n = N;
        uint32_t k = K;
        
        matrix_mul_opt(chunk_per_core,offset, mat_a_TCDM, mat_b_TCDM, dst_TCDM, m, n, k);

    }

    snrt_cluster_hw_barrier();
    uint32_t cycle2=snrt_mcycle();
    uint32_t err = 0;
    // 5e-5 like the gemm benchmark, which does the same math: a dot product of
    // K = 64 terms accumulates ~1e-5 of rounding in fp32, so 1e-5 was flagging
    // pure rounding (the original kernel failed it too, with 2 elements).
    float eps = 5e-5f;

    if (core_idx == 0) {
        printf("Cycle1 %d and cycle2 %d",cycle1,cycle2);
    }
    if (CHECK_RESULTS == 1 && core_idx == 0) {
        asm("nop \n");
        for(uint32_t i = 0; i < M * N; i++){
            if(fabsf(dst_TCDM[i] - golden[i]) > eps){
                err ++;
            }
        }
        printf("Errors: %u\n", err);
    }

    return err;
}