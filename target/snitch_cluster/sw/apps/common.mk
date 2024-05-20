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
APP_BUILDDIR ?= $(abspath build)

###################
# Build variables #
###################

INCDIRS += $(RUNTIME_DIR)/src
INCDIRS += $(RUNTIME_DIR)/../common
INCDIRS += $(SNRT_DIR)/api
INCDIRS += $(SNRT_DIR)/api/omp
INCDIRS += $(SNRT_DIR)/src
INCDIRS += $(SNRT_DIR)/src/omp
INCDIRS += $(ROOT)/sw/blas
INCDIRS += $(ROOT)/sw/deps/riscv-opcodes

LIBS += $(RUNTIME_DIR)/build/libsnRuntime.a

LIBDIRS  = $(dir $(LIBS))
LIBNAMES = $(patsubst lib%,%,$(notdir $(basename $(LIBS))))

RISCV_LDFLAGS += -L$(abspath $(RUNTIME_DIR))
RISCV_LDFLAGS += -T$(abspath $(SNRT_DIR)/base.ld)
RISCV_LDFLAGS += $(addprefix -L,$(LIBDIRS))
RISCV_LDFLAGS += $(addprefix -l,$(LIBNAMES))

###########
# Outputs #
###########

ELF         = $(abspath $(addprefix $(APP_BUILDDIR)/,$(addsuffix .elf,$(APP))))
DEP         = $(abspath $(addprefix $(APP_BUILDDIR)/,$(addsuffix .d,$(APP))))
DUMP        = $(abspath $(addprefix $(APP_BUILDDIR)/,$(addsuffix .dump,$(APP))))
DWARF       = $(abspath $(addprefix $(APP_BUILDDIR)/,$(addsuffix .dwarf,$(APP))))
ALL_OUTPUTS = $(ELF) $(DEP) $(DUMP) $(DWARF)

#########
# Rules #
#########

.PHONY: all
all: $(ALL_OUTPUTS)

.PHONY: clean
clean:
	rm -rf $(APP_BUILDDIR)

.PHONY: $(APP)
$(APP): $(ELF)

$(APP_BUILDDIR):
	mkdir -p $@

$(DEP): $(SRCS) | $(APP_BUILDDIR)
	$(RISCV_CC) $(RISCV_CFLAGS) -MM -MT '$(ELF)' $< > $@

$(ELF): $(SRCS) $(DEP) $(LIBS) | $(APP_BUILDDIR)
	$(RISCV_CC) $(RISCV_CFLAGS) $(RISCV_LDFLAGS) $(SRCS) -o $@

$(DUMP): $(ELF) | $(APP_BUILDDIR)
	$(RISCV_OBJDUMP) $(RISCV_OBJDUMP_FLAGS) $< > $@

$(DWARF): $(ELF) | $(APP_BUILDDIR)
	$(RISCV_DWARFDUMP) $< > $@

ifneq ($(MAKECMDGOALS),clean)
-include $(DEP)
endif
