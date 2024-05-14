#include "snrt.h"
#include "data.h"

// Define your kernel
void transpose_baseline(float A[M][N], double B[N][M]) {

    for (int i=0; i < M; i++) {
        for (int j = 0; j < N; ++j)
        {
            B[j][i] = A[i][j];
        }
    }
}

// first only do FP16
void transpose_shuffle_h(uint32_t *a, double *b, int M, int N) {
    uint32_t mask_0 = 0x3B2A;
    uint32_t mask_1 = 0x1908;
    uint32_t mask_2 = 0x32BA;
    uint32_t mask_3 = 0x1098;




}
void transpose_shuffle_s(float *a, float *b, int M, int N) {
    uint32_t mask_0 = 0x19;
    uint32_t mask_1 = 0x08;

    // M = 2;
    // N = 2;

    // for (int i=0; i < M; i++) {
    //     for (int j = 0; j < N-1; ++j)
    //     {
    //         
    //     }
    // } 

    asm volatile(
        "fmv.s.x ft0, %0\n"
        "fmv.s.x ft1, %1\n"
        "fmv.s.x ft2, %2\n"
        "fmv.s.x ft3, %3\n"
        "vfcpka.s.s ft4, ft0, ft1\n"
        "vfcpka.s.s ft5, ft2, ft3\n"
        : "r"(a[0][0]), "r"(a[0][1]), "r"(a[1][0]), "r"(a[1][1]));     

        asm volatile(
            "vfshuffle.s ft4, ft5, %0\n" 
            "fsw ft4, 0(%1) \n"      // ?
            : "+r"(mask_0), "r"(a)
            :"memory");
        
        asm volatile(
            "vfcpka.s.s ft4, ft0, ft1\n"  
            "vfshuffle.s ft4, ft5, %0\n"  
            : "+r"(mask_1));

}

int main() {
    // Read the mcycle CSR (this is our way to mark/delimit a specific code region for benchmarking)
    uint32_t start_cycle = mcycle();

    // DM core does not participate in the computation
    if(snrt_is_compute_core())
        transpose_shuffle();

    // Read the mcycle CSR
    uint32_t end_cycle = mcycle();
}