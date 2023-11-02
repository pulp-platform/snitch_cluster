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
