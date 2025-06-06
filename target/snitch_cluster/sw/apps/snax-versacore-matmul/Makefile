# Copyright 2025 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Xiaoling Yi < xiaoling.yi @esat.kuleuven.be>

APP = snax-versacore-matmul

INCDIRS = data \
          ../../snax/versacore/include

# Include this binary in the final build
RISCV_LDFLAGS += ../../snax/versacore/build/snax-versacore-lib.o

SRCS = src/snax-versacore-matmul.c

include ../common.mk
include ./data/Makefile

$(DEP): $(DATA_H)
