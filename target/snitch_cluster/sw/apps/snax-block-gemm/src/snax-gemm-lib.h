#include "stdint.h"
#include <stdbool.h>
#include "snrt.h"

// wrap some functions for tests
#ifndef CSR_DEF_H
#define CSR_DEF_H

#define Address_A_CSR 0x3c0
#define Address_B_CSR 0x3c1
#define Address_C_CSR 0x3c2

#define B_M_K_N_CSR 0x3c3

#define ldA_CSR 0x3c4
#define ldB_CSR 0x3c5
#define ldC_CSR 0x3c6

#define StrideA_CSR 0x3c7
#define StrideB_CSR 0x3c8
#define StrideC_CSR 0x3c9

#define STATE_CSR 0x3ca

#endif // CSR_DEF_H

#ifndef GEMM_PARAMETER_H
#define GEMM_PARAMETER_H

#define dataWidthA 8
#define dataWidthB 8
#define dataWidthC (dataWidthA * 4)

#define tileSize 8
#define meshRow 8
#define meshCol 8

#define dataWidthPerAddr 8

#define baseAddrIncrementA (dataWidthA * meshRow * tileSize / dataWidthPerAddr)
#define baseAddrIncrementB (dataWidthB * meshCol * tileSize / dataWidthPerAddr)
#define baseAddrIncrementC (dataWidthC * meshRow * meshCol / dataWidthPerAddr)

#endif

int32_t gen_size_config(uint8_t Batch, uint8_t M, uint8_t K, uint8_t N);

bool base_gemm(int m, int k, int n, int8_t * A, int8_t * B, int32_t* C_cpu, bool new_batch);

bool batch_gemm_cpu(uint8_t Batch, uint8_t M, uint8_t K, uint8_t N, int8_t* A, int8_t* B, int32_t* C, uint32_t ldA, uint32_t ldB,uint32_t ldC, uint32_t strideA,uint32_t strideB,uint32_t strideC);

bool load_input_data(uint8_t Batch, uint8_t M, uint8_t K, uint8_t N,int8_t *local_a, int8_t *local_b,int8_t* A, int8_t* B,uint32_t strideInnermostA, uint32_t strideInnermostB,uint32_t ldA, uint32_t ldB, uint32_t strideA,uint32_t strideB);

bool set_batch_gemm(uint32_t size_setting, int8_t *local_a, int8_t *local_b, int32_t *local_c,uint32_t strideInnermostA, uint32_t strideInnermostB,uint32_t strideInnermostC,uint32_t ldA, uint32_t ldB,uint32_t ldC, uint32_t strideA,uint32_t strideB,uint32_t strideC);

bool start_batch_gemm();

bool wait_batch_gemm();

uint32_t check_result(int32_t* output, int32_t* output_golden, uint8_t Batch,
                      uint8_t M, uint8_t N,uint32_t strideInnermostC,uint32_t ldC, uint32_t strideC);
                      