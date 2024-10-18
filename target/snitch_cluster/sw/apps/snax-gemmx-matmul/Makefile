# Copyright 2023 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

APP     = snax-gemmx-matmul

INCDIRS = data

INCDIRS += ../../snax/gemmx/include

# Include this binary in the final build
RISCV_LDFLAGS += ../../snax/gemmx/build/snax-gemmx-lib.o

SRCS    = src/snax-gemmx-matmul.c

include ../common.mk
include ./data/Makefile

$(DEP): $(DATA_H)
