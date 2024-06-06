#include "transpose_shuffle.h"


int main() {
    // Read the mcycle CSR (this is our way to mark/delimit a specific code region for benchmarking)
    uint32_t start_cycle = snrt_mcycle();

    transpose_shuffle(input, output, M, N, dtype, baseline, opt_ssr);

    // Read the mcycle CSR
    uint32_t end_cycle = snrt_mcycle();

    snrt_cluster_hw_barrier();

    return 0;
}