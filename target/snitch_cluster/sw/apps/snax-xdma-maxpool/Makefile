# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Yunhao Deng <yunhao.deng@kuleuven.be>

APP     = snax-xdma-maxpool
SRCS    = src/snax-xdma-maxpool.c
INCDIRS = data
INCDIRS += ../../snax/xdma/include

RISCV_LDFLAGS += ../../snax/xdma/build/snax-xdma-lib.o

include ../common.mk
include ./data/Makefile
$(DEP): $(DATA_H)
