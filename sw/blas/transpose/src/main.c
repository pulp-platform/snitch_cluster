#include "transpose.h"
#include "data.h"

int main() {
    // Read the mcycle CSR (this is our way to mark/delimit a specific code region for benchmarking)
    uint32_t start_cycle = mcycle();

    // DM core does not participate in the computation
    if(snrt_is_compute_core())
        transpose_shuffle(layer);

    // Read the mcycle CSR
    uint32_t end_cycle = mcycle();
}