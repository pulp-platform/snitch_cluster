// Luca Colombo Chips-IT 2026
// Idle core where core 0 iterates on nothing while other cores wait.
// Used to obtain idle power
#include "snrt.h"

int main() {
    uint32_t core_idx = snrt_cluster_core_idx();
    //uint32_t time1, time2;
    uint32_t cycle1;
    if(core_idx==0){
        cycle1=snrt_mcycle();
        asm volatile (
            "li t0, 1001\n\t"
            "1:\n\t"
            "addi t0, t0, -1\n\t"
            "bnez t0, 1b\n\t"
            ::: "t0"
        );
 
    }
    snrt_cluster_hw_barrier();
    uint32_t cycle2=snrt_mcycle();
    if(core_idx==0)
        printf("Cycle1 %d and cycle2 %d",cycle1,cycle2);

        
    return 0;
}
