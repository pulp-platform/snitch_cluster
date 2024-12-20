# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

###############
# Directories #
###############

SNRT_DIR         = $(SNITCH_ROOT)/sw/snRuntime
SNRT_TARGET_DIR ?= $(SNITCH_ROOT)/target/snitch_cluster/sw/runtime/$(SELECT_RUNTIME)
SNRT_BUILDDIR    = $(SNRT_TARGET_DIR)/build
SNRT_SRCDIR      = $(SNRT_TARGET_DIR)/src

###################
# Build variables #
###################

SNRT_S_SRCS = snrt.S
SNRT_C_SRCS = snrt.c

SNRT_INCDIRS += $(SNRT_DIR)/src
SNRT_INCDIRS += $(SNRT_DIR)/api
SNRT_INCDIRS += $(SNRT_DIR)/src/omp
SNRT_INCDIRS += $(SNRT_DIR)/api/omp
SNRT_INCDIRS += $(SNRT_DIR)/vendor/riscv-opcodes
SNRT_INCDIRS += $(SNRT_SRCDIR)
SNRT_INCDIRS += $(SNRT_HAL_HDRS_DIR)

SNRT_RISCV_CFLAGS += $(RISCV_CFLAGS)
SNRT_RISCV_CFLAGS += $(addprefix -I,$(SNRT_INCDIRS))

###########
# Outputs #
###########

SNRT_OBJS    = $(addprefix $(SNRT_BUILDDIR)/,$(addsuffix .o,$(notdir $(SNRT_S_SRCS) $(SNRT_C_SRCS))))
SNRT_DEPS    = $(addprefix $(SNRT_BUILDDIR)/,$(addsuffix .d,$(notdir $(SNRT_S_SRCS) $(SNRT_C_SRCS))))
SNRT_LIB     = $(SNRT_BUILDDIR)/libsnRuntime.a
SNRT_DUMP    = $(SNRT_BUILDDIR)/libsnRuntime.dump
SNRT_OUTPUTS = $(SNRT_LIB)

ifeq ($(DEBUG), ON)
SNRT_OUTPUTS += $(SNRT_DUMP)
endif


#########
# Rules #
#########

.PHONY: runtime clean-runtime

sw: runtime
clean-sw: clean-runtime

runtime: $(SNRT_OUTPUTS)

clean-runtime:
	rm -rf $(SNRT_BUILDDIR)

$(SNRT_BUILDDIR):
	mkdir -p $@

$(SNRT_BUILDDIR)/%.o: $(SNRT_SRCDIR)/% $(SNRT_BUILDDIR)/%.d | $(SNRT_BUILDDIR)
	$(RISCV_CC) $(SNRT_RISCV_CFLAGS) -c $< -o $@

$(SNRT_BUILDDIR)/%.d: $(SNRT_SRCDIR)/% | $(SNRT_BUILDDIR)
	$(RISCV_CC) $(SNRT_RISCV_CFLAGS) -MM -MT '$(@:.d=.o)' $< > $@

$(SNRT_LIB): $(SNRT_OBJS) | $(SNRT_BUILDDIR)
	$(RISCV_AR) $(RISCV_ARFLAGS) $@ $^

$(SNRT_DUMP): $(SNRT_LIB) | $(SNRT_BUILDDIR)
	$(RISCV_OBJDUMP) $(RISCV_OBJDUMP_FLAGS) $< > $@

$(SNRT_DEPS): | $(SNRT_HAL_HDRS)

ifneq ($(filter-out clean%,$(MAKECMDGOALS)),)
-include $(SNRT_DEPS)
endif
