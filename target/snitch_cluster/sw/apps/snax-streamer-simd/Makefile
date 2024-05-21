# Copyright 2023 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

APP     = snax-streamer-simd

INCDIRS = data

INCDIRS += ../../snax/streamer-simd/include

# Include this binary in the final build
RISCV_LDFLAGS += ../../snax/streamer-simd/build/snax-streamer-simd-lib.o

SRCS    = src/snax-streamer-simd.c

include ../common.mk
include ./data/Makefile

$(DEP): $(DATA_H)
