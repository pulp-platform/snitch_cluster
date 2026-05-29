# Copyright 2025 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Common build rules for Spatz kernels.
# Include this file AFTER setting:
#   APP              - kernel name
#   $(APP)_BUILD_DIR - output directory
#   SRC_DIR          - kernel root (contains main.c, kernel/, data/)
#   DATAHEADER       - data header filename (e.g. data_256.h), with default set beforehand

SPATZ_SW_DIR  := $(SN_ROOT)/sw/spatz
BENCHMARK_DIR := $(SPATZ_SW_DIR)/benchmark

# main.c #includes its kernel/*.c directly, so only main.c and benchmark.c are compiled
SRCS += $(BENCHMARK_DIR)/benchmark.c

# Include paths:
#   - sw/spatz/include  for benchmark.h
#   - kernel/           for the kernel header (included by main.c via "kernel/...")
#   - data/             so DATAHEADER resolves without a path prefix
$(APP)_INCDIRS += $(SPATZ_SW_DIR)/include
$(APP)_INCDIRS += $(SRC_DIR)/kernel
$(APP)_INCDIRS += $(SRC_DIR)/data

# Expose the data header to the preprocessor.
# Use per-app $(APP)_DATAHEADER so that concurrent inclusion of multiple
# app.mk files does not clobber a shared DATAHEADER variable.
$(APP)_RISCV_CFLAGS += -DDATAHEADER='"$($(APP)_DATAHEADER)"'

include $(SN_ROOT)/sw/kernels/common.mk
