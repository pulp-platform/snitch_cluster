# Copyright 2023 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

APP     = snax-streamer-gemm-conv-simd

INCDIRS = data

INCDIRS += ../../snax/streamer-gemm/include
INCDIRS += ../../snax/streamer-gemm-conv-simd/include
INCDIRS += ../../snax/gemm/include
INCDIRS += ../../snax/streamer-simd/include

# Include this binary in the final build
RISCV_LDFLAGS += ../../snax/streamer-gemm/build/snax-streamer-gemm-lib.o
RISCV_LDFLAGS += ../../snax/gemm/build/snax-gemm-lib.o
RISCV_LDFLAGS += ../../snax/streamer-simd/build/snax-streamer-simd-lib.o
RISCV_LDFLAGS += ../../snax/streamer-gemm-conv-simd/build/snax-streamer-gemm-conv-simd-lib.o

SRCS    = src/snax-streamer-gemm-conv-simd.c

include ../common.mk
include ./data/Makefile

$(DEP): $(DATA_H)
