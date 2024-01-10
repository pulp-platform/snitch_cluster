# Copyright 2023 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

APP     = snax-block-gemm

INCDIRS = data

INCDIRS += ../../snax/gemm/include

# Include this binary in the final build
RISCV_LDFLAGS += ../../snax/gemm/build/snax-gemm-lib.o

SRCS    = src/snax-block-gemm.c

include ../common.mk
include ./data/Makefile

$(DEP): $(DATA_H)
