# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

# Usage of absolute paths is required to externally include
# this Makefile from multiple different locations
MK_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
include $(MK_DIR)/../toolchain.mk

########
# Apps #
########

# Note, various tests only work with the non-generic runtime and the specific llvm toolchain
# moving to the generic runtime there are less tests that work,
# and moving to generic llvm even less tests work
APPS        = $(shell $(MK_DIR)/../../../../util/sim/list_apps.py --in-dir tests/ ../runtime.yaml)
APPS        += $(shell $(MK_DIR)/../../../../util/sim/list_apps.py --in-dir tests/ ../standard-fp.yaml)
# These tests only need custom riscv instructions, no custom builtins
ifneq ($(SELECT_TOOLCHAIN), llvm-generic)
APPS        += $(shell $(MK_DIR)/../../../../util/sim/list_apps.py --in-dir tests/ ../custom-fp.yaml)
ifneq ($(SELECT_RUNTIME), rtl-generic)
# These tests need custom builtins in the runtime
APPS        += $(shell $(MK_DIR)/../../../../util/sim/list_apps.py --in-dir tests/ ../openmp.yaml)
APPS        += $(shell $(MK_DIR)/../../../../util/sim/list_apps.py --in-dir tests/ ../snitch-cluster-openmp.yaml)
APPS        += $(shell $(MK_DIR)/../../../../util/sim/list_apps.py --in-dir tests/ ../snitch-cluster-runtime.yaml)
# These tests need custom builtins in the runtime and custom riscv instructions
APPS        += $(shell $(MK_DIR)/../../../../util/sim/list_apps.py --in-dir tests/ ../dnn.yaml)
APPS        += $(shell $(MK_DIR)/../../../../util/sim/list_apps.py --in-dir tests/ ../blas.yaml)
endif
endif

###############
# Directories #
###############

ROOT        = $(abspath ../../../..)
SNRT_DIR    = $(ROOT)/sw/snRuntime
SRC_DIR     = $(ROOT)/sw/tests
BUILDDIR    = $(ROOT)/target/snitch_cluster/sw/tests/build
ifeq ($(SELECT_RUNTIME), banshee)
RUNTIME_DIR = $(ROOT)/target/snitch_cluster/sw/runtime/banshee
else ifeq ($(SELECT_RUNTIME), rtl-generic)
RUNTIME_DIR = $(ROOT)/target/snitch_cluster/sw/runtime/rtl-generic
else
RUNTIME_DIR = $(ROOT)/target/snitch_cluster/sw/runtime/rtl
endif

###################
# Build variables #
###################

INCDIRS += $(RUNTIME_DIR)/src
INCDIRS += $(RUNTIME_DIR)/../common
INCDIRS += $(SNRT_DIR)/api
INCDIRS += $(SNRT_DIR)/api/omp
INCDIRS += $(SNRT_DIR)/src
INCDIRS += $(SNRT_DIR)/src/omp
INCDIRS += $(SNRT_DIR)/vendor/riscv-opcodes

RISCV_LDFLAGS += -L$(abspath $(RUNTIME_DIR))
RISCV_LDFLAGS += -T$(abspath $(SNRT_DIR)/base.ld)
RISCV_LDFLAGS += -L$(abspath $(RUNTIME_DIR)/build/)
RISCV_LDFLAGS += -lsnRuntime

###########
# Outputs #
###########

ELFS        = $(abspath $(addprefix $(BUILDDIR)/,$(addsuffix .elf,$(APPS))))
DEPS        = $(abspath $(addprefix $(BUILDDIR)/,$(addsuffix .d,$(APPS))))
DUMPS       = $(abspath $(addprefix $(BUILDDIR)/,$(addsuffix .dump,$(APPS))))
DWARFS      = $(abspath $(addprefix $(BUILDDIR)/,$(addsuffix .dwarf,$(APPS))))
ALL_OUTPUTS = $(ELFS)

ifeq ($(DEBUG), ON)
ALL_OUTPUTS += $(DUMPS) $(DWARFS)
endif

#########
# Rules #
#########

.PHONY: all
all: $(ALL_OUTPUTS)

.PHONY: clean
clean:
	rm -rf $(BUILDDIR)

$(BUILDDIR):
	mkdir -p $@

$(BUILDDIR)/%.d: $(SRC_DIR)/%.c | $(BUILDDIR)
	$(RISCV_CC) $(RISCV_CFLAGS) -MM -MT '$(BUILDDIR)/$*.elf' $< > $@

$(BUILDDIR)/%.elf: $(SRC_DIR)/%.c $(BUILDDIR)/%.d | $(BUILDDIR)
	$(RISCV_CC) $(RISCV_CFLAGS) $(RISCV_LDFLAGS) $(SRC_DIR)/$*.c -o $@

$(BUILDDIR)/%.dump: $(BUILDDIR)/%.elf | $(BUILDDIR)
	$(RISCV_OBJDUMP) -D -S $< > $@

$(BUILDDIR)/%.dwarf: $(BUILDDIR)/%.elf | $(BUILDDIR)
	$(RISCV_DWARFDUMP) --all $< > $@

ifneq ($(MAKECMDGOALS),clean)
-include $(DEPS)
endif
