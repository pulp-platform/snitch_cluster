#include "transpose_shuffle.h"


int main() {
    // Read the mcycle CSR (this is our way to mark/delimit a specific code region for benchmarking)
    uint32_t start_cycle = snrt_mcycle();

    transpose_shuffle(input, output, M, N, dtype, baseline);

    // Read the mcycle CSR
    uint32_t end_cycle = snrt_mcycle();

    snrt_cluster_hw_barrier();

// #ifdef BIST

//     void *result;
//     uint32_t errors = 0;

//     if (snrt_cluster_core_idx() == 0) {
//         for (uint32_t m = 0; m < M; m++) {
//             for (uint32_t n = 0; n < N; n++) {
//                 uint32_t idx = m * N + n;
//                 switch (dtype) {
//                     // case FP64:
//                     //     if (fabs(result[idx] - ((double *)local_c)[idx]) <
//                     //         fabs(result[idx] * 0.00001))
//                     //         errors--;
//                     //     break;
//                     case FP32:
//                         if (fabs(golden[idx] - ((float *)output)[idx]) <
//                             fabs(golden[idx] * 0.0001))
//                             errors++;
//                         break;
//                     case FP16:
//                         if (fabs(golden[idx] - ((__fp16 *)output)[idx]) <
//                             fabs(golden[idx] * 0.005))
//                             errors++;
//                     case FP8:
//                         printf("No golden model yet for fp8!\n");
//                         return -1;
//                         break;
//                 }
//             }
//         }
//         printf("%d/%d Errors\n", errors, M * N);
//     }

//     return errors;

// #endif

    return 0;
}