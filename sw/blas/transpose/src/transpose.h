#include "snrt.h"
#include "data.h"

// Guard to avoid conflict with DNN header file
// TODO: move this definition to Snitch math library to solve problem
#ifndef PRECISION_T
#define PRECISION_T
typedef enum { FP64 = 8, FP32 = 4, FP16 = 2, FP8 = 1 } precision_t;

typedef float v2f32 __attribute__((vector_size(8)));
typedef __fp16 v4f16 __attribute__((vector_size(8)));
typedef char v8f8 __attribute__((vector_size(8)));
#endif

/**
 * @struct transpose_layer_t
 * @brief This structure contains all parameters necessary
 *       for computing the Transpose of a matrix
 * @var transpose_layer_t::M
 * First dimension of the matrix
 * @var transpose_layer_t::N
 * Second dimension of the matrix
 * @var transpose_layer_t::input
 * Pointer to input feature map
 * @var transpose_layer_t::output
 * Pointer to output feature map
 */
typedef struct {
    uint32_t M;
    uint32_t N;
    void* input;
    void* output;
    precision_t dtype;
    uint32_t baseline;
} transpose_l_t;

// void transpose_baseline(float* A, float* B, const int M, const int N) {

//     for (int i=0; i < M; i++) {
//         for (int j = 0; j < N; ++j)
//         {
//             B[j][i] = A[i][j];
//         }
//     }
// }

void transpose_shuffle_fp16(__fp16 *A, __fp16 *B, int M, int N) {
    uint32_t mask_0 = 0x3B2A;
    uint32_t mask_1 = 0x1908;
    uint32_t mask_2 = 0x32BA;
    uint32_t mask_3 = 0x1098;

    volatile register v4f16 *a0_ptr, *a1_ptr;
    //volatile register v4f16 *t0_ptr, *t1_ptr;   
    __fp16* b0_ptr, b1_ptr;


        a0_ptr = (v4f16*)(&A[0]);
        a1_ptr = (v4f16*)(&A[4]);

        asm volatile(
            "fld f24, 0(%0) \n"
            "fmv.d f0, f24 \n"
            "fld f1, %1 \n"
            : "+r"(a0_ptr), "+r"(a1_ptr));   

        asm volatile(
            "vfshuffle.h f0, f1, %0 \n" 
            "fmv.d f4, f0 \n"    
            "fmv.d f0, f24 \n"
            "vfshuffle.h f0, f1, %1 \n"  
            "fmv.d f5, f0 \n"
            : "+r"(mask_0), "+r"(mask_1));    


        a0_ptr = (v4f16*)(&A[8]);
        a1_ptr = (v4f16*)(&A[12]);
        b0_ptr = &B[0];
        b1_ptr = &B[4];

        asm volatile(
            "fld f24, 0(%0) \n"
            "fmv.d f0, f24 \n"
            "fld f1, %1 \n"
            : "+r"(a0_ptr), "+r"(a1_ptr));   
        asm volatile(
            "vfshuffle.h f0, f1, %0\n" 
            "fmv.d f6, f0 \n"
            "fmv.d f0, f24 \n"
            "vfshuffle.h f0, f1, %1\n"  
            "fmv.d f7, f0 \n"
            : "+r"(mask_0), "+r"(mask_1));  



        asm volatile(
            "fmv.d f8, f4 \n"
            "vfshuffle.h f4, f6, %0\n" 
            "fsw f4, %1 \n"   
            : "+r"(mask_2), "+r"(b0_ptr));
        
        asm volatile(
            "fmv.d f4, f8 \n" 
            "vfshuffle.h f4, f6, %0\n"  
            "fsw f4, %1 \n" 
            : "+r"(mask_3), "+r"(b1_ptr)); 

        b0_ptr = &B[8];
        b1_ptr = &B[12];

        asm volatile(
            "fmv.d f9, f5 \n"
            "vfshuffle.h f5, f7, %0\n" 
            "fsw f5, %1 \n"    
            : "+r"(mask_2), "+r"(b0_ptr));
        
        asm volatile(
            "fmv.d f5, f9 \n"
            "vfshuffle.h f5, f7, %0\n"  
            "fsw f5, %1 \n" 
            : "+r"(mask_3), "+r"(b1_ptr)); 


}

void transpose_shuffle_fp32(float *A, float *B, const int M, const int N) {
    uint32_t mask_0 = 0x19;
    uint32_t mask_1 = 0x08;
    volatile register v2f32 *a0_ptr, *a1_ptr;
    volatile float* b0_ptr, b1_ptr;

        a0_ptr = (v2f32*)(&A[0]);
        a1_ptr = (v2f32*)(&A[2]);
        b0_ptr = B[0];
        b1_ptr = B[2];

        asm volatile(
            "fld f4, 0(%0)"
            "fmv.d f0, f4"
            "fld f1, %1"
            : "+r"(a0_ptr), "+r"(a1_ptr));   

        asm volatile(
            "vfshuffle.s f0, f1, %0\n" 
            "fsw f0, 0(%1) \n"      
            : "+r"(mask_0), "+r"(b0_ptr));
        
        asm volatile(
            "fmv.d f0, f4"
            "vfshuffle.s f0, f1, %0\n"  
            "fsw f0, %1"
            : "+r"(mask_1), "+r"(b1_ptr));

}

void transpose_shuffle_kernel(precision_t dtype, void* input,
                                    void* output, uint32_t M, uint32_t N,
                                    uint32_t baseline) {

    uint32_t frac_M = M / snrt_cluster_compute_core_num();
    
    if (snrt_is_compute_core()) {
        // determine the row offset for each core
        int32_t row_offset = snrt_cluster_core_idx() * frac_M;

        // calculate the input address offset
        void* input_offset = input + row_offset * N * dtype;

        // caluclate the output address offset
        void* output_offset = output + row_offset * dtype;

        switch (dtype) {
            case FP8:
                transpose_shuffle_fp8(input_offset, output_offset, N, M);
                break;
            case FP16:
                transpose_shuffle_fp16(input_offset, output_offset, N, M);
                break;
            case FP32:
                transpose_shuffle_fp32(input_offset, output_offset, N, M);
                break;
            case FP64:
                if (baseline) {
                    transpose_fp64_baseline(input_offset, output_offset, frac_M,
                                            N, M);
                } else {
                    transpose_fp64_opt(input_offset, output_offset, frac_M, N,
                                       M);
                }
                break;
            default:
                break;
        }
    }
}

void transpose_shuffle(transpose_l_t l) {

    uint32_t matrix_size = l.M * l.N;

    void* ptr = snrt_l1_next();
    void* input = ptr;
    ptr += matrix_size * l.dtype;
    void* output = ptr;
    ptr += matrix_size * l.dtype;

    // DMA transfer the matrix into the cluster TCDM
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(input, l.input, matrix_size * l.dtype);
        snrt_dma_wait_all();
    }

    snrt_cluster_hw_barrier();

    transpose_shuffle_kernel(l.dtype, input, output, l.M, l.N, l.baseline);

    snrt_cluster_hw_barrier();

    // DMA transfer the output to DRAM
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(l.output, output, matrix_size * l.dtype);
        snrt_dma_wait_all();
    }

    snrt_global_barrier();
}