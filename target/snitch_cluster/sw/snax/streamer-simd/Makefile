# Copyright 2023 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

# Usage of absolute paths is required to externally include
# this Makefile from multiple different locations

MK_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
include $(MK_DIR)/../../toolchain.mk

# Banshee runtime is not supported
ifeq ($(SELECT_RUNTIME), rtl-generic)
RUNTIME_DIR := rtl-generic
else
RUNTIME_DIR := rtl
endif

################
## Directories #
################

# Fixed paths in repository tree
ROOT     = $(abspath $(MK_DIR)/../../../../..)
SNRT_DIR = $(ROOT)/sw/snRuntime
## Paths relative to the runtime including this Makefile
BUILDDIR = $(abspath build)
SRC_DIR  = $(abspath src)

####################
## Build variables #
####################

INCDIRS += $(abspath include)
INCDIRS += $(SNRT_DIR)/src
INCDIRS += $(SNRT_DIR)/api
INCDIRS += $(SNRT_DIR)/src/omp
INCDIRS += $(SNRT_DIR)/api/omp
INCDIRS += $(SNRT_DIR)/vendor/riscv-opcodes
INCDIRS += $(ROOT)/target/snitch_cluster/sw/runtime/common
INCDIRS += $(ROOT)/target/snitch_cluster/sw/runtime/$(RUNTIME_DIR)/src
INCDIRS += $(ROOT)/target/snitch_cluster/sw/runtime/$(RUNTIME_DIR)/include

############
## Outputs #
############

OBJS        = $(BUILDDIR)/snax-streamer-simd-lib.o
ALL_OUTPUTS = $(OBJS)


##########
## Rules #
##########

.PHONY: all
all: $(ALL_OUTPUTS)

.PHONY: clean
clean:
	rm -rf $(BUILDDIR)

$(BUILDDIR):
	mkdir -p $@

$(BUILDDIR)/%.o: $(SRC_DIR)/%.c | $(BUILDDIR)
	$(RISCV_CC) $(RISCV_CFLAGS) -c $< -o $@
