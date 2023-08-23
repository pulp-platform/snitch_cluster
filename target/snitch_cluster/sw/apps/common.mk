# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

# Usage of absolute paths is required to externally include
# this Makefile from multiple different locations
MK_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
include $(MK_DIR)/../toolchain.mk

###############
# Directories #
###############

# Fixed paths in repository tree
ROOT     := $(abspath $(MK_DIR)/../../../..)
SNRT_DIR := $(ROOT)/sw/snRuntime
ifeq ($(SELECT_RUNTIME), banshee)
RUNTIME_DIR  := $(ROOT)/target/snitch_cluster/sw/runtime/banshee
RISCV_CFLAGS += -DBIST
else
RUNTIME_DIR := $(ROOT)/target/snitch_cluster/sw/runtime/rtl
endif

# Paths relative to the app including this Makefile
BUILDDIR = $(abspath build)

###################
# Build variables #
###################

INCDIRS += $(RUNTIME_DIR)/src
INCDIRS += $(RUNTIME_DIR)/../common
INCDIRS += $(SNRT_DIR)/api
INCDIRS += $(SNRT_DIR)/api/omp
INCDIRS += $(SNRT_DIR)/src
INCDIRS += $(SNRT_DIR)/src/omp
INCDIRS += $(ROOT)/sw/deps/riscv-opcodes

# Math library override
INCDIRS += $(ROOT)/sw/math/arch/riscv64/bits/
INCDIRS += $(ROOT)/sw/math/arch/generic
INCDIRS += $(ROOT)/sw/math/src/include
INCDIRS += $(ROOT)/sw/math/src/internal
INCDIRS += $(ROOT)/sw/math/include/bits
INCDIRS += $(ROOT)/sw/math/include

RISCV_LDFLAGS += -L$(abspath $(RUNTIME_DIR))
RISCV_LDFLAGS += -T$(abspath $(SNRT_DIR)/base.ld)
RISCV_LDFLAGS += -L$(abspath $(RUNTIME_DIR)/build/)
RISCV_LDFLAGS += -lsnRuntime

###########
# Outputs #
###########

ELF         = $(abspath $(addprefix $(BUILDDIR)/,$(addsuffix .elf,$(APP))))
DEP         = $(abspath $(addprefix $(BUILDDIR)/,$(addsuffix .d,$(APP))))
DUMP        = $(abspath $(addprefix $(BUILDDIR)/,$(addsuffix .dump,$(APP))))
DWARF       = $(abspath $(addprefix $(BUILDDIR)/,$(addsuffix .dwarf,$(APP))))
ALL_OUTPUTS = $(ELF) $(DEP) $(DUMP) $(DWARF)

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

$(DEP): $(SRCS) | $(BUILDDIR)
	$(RISCV_CC) $(RISCV_CFLAGS) -MM -MT '$(ELF)' $< > $@

$(ELF): $(SRCS) $(DEP) | $(BUILDDIR)
	$(RISCV_CC) $(RISCV_CFLAGS) $(RISCV_LDFLAGS) $(SRCS) -o $@

$(DUMP): $(ELF) | $(BUILDDIR)
	$(RISCV_OBJDUMP) -D $< > $@

$(DWARF): $(ELF) | $(BUILDDIR)
	$(RISCV_DWARFDUMP) $< > $@

ifneq ($(MAKECMDGOALS),clean)
-include $(DEP)
endif
