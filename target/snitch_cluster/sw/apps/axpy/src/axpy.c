#include "snrt.h"
#include "data.h"

// Define your kernel
void axpy(uint32_t l, double a, double *x, double *y, double *z) {
    int core_idx = snrt_cluster_core_idx();
    int offset = core_idx * l;

    for (int i = 0; i < l; i++) {
        z[offset] = a * x[offset] + y[offset];
        offset++;
    }
    snrt_fpu_fence();
}

int main() {
    // Read the mcycle CSR (this is our way to mark/delimit a specific code region for benchmarking)
    uint32_t start_cycle = snrt_mcycle();

    // DM core does not participate in the computation
    if(snrt_is_compute_core())
        axpy(L / snrt_cluster_compute_core_num(), a, x, y, z);

    // Read the mcycle CSR
    uint32_t end_cycle = snrt_mcycle();
}