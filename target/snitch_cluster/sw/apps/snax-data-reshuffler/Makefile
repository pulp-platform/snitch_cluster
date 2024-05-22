# Copyright 2023 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

APP     = snax-data-reshuffler

INCDIRS = data

INCDIRS += ../../snax/data-reshuffler/include

# Include this binary in the final build
RISCV_LDFLAGS += ../../snax/data-reshuffler/build/snax-data-reshuffler-lib.o

SRCS    = src/snax-data-reshuffler.c

include ../common.mk
include ./data/Makefile

$(DEP): $(DATA_H)
