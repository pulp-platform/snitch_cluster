# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

###############
# Directories #
###############

SN_RUNTIME_DIR       = $(SN_ROOT)/sw/runtime
SN_RUNTIME_BUILDDIR ?= $(SN_RUNTIME_DIR)/build

###################
# Build variables #
###################

SN_RUNTIME_S_SRCS = snrt.S
SN_RUNTIME_C_SRCS = snrt.cc

SN_RUNTIME_INCDIRS += $(SN_RUNTIME_DIR)/src
SN_RUNTIME_INCDIRS += $(SN_RUNTIME_DIR)/api
SN_RUNTIME_INCDIRS += $(SN_RUNTIME_DIR)/src/omp
SN_RUNTIME_INCDIRS += $(SN_RUNTIME_DIR)/api/omp
SN_RUNTIME_INCDIRS += $(SN_RUNTIME_DIR)/vendor/riscv-opcodes
SN_RUNTIME_INCDIRS += $(SN_RUNTIME_SRCDIR)
SN_RUNTIME_INCDIRS += $(SN_RUNTIME_HAL_BUILD_DIR)

SN_RUNTIME_RISCV_CFLAGS += $(SN_RISCV_CFLAGS)
SN_RUNTIME_RISCV_CFLAGS += $(addprefix -I,$(SN_RUNTIME_INCDIRS))

###########
# Outputs #
###########

SN_RUNTIME_OBJS    = $(addprefix $(SN_RUNTIME_BUILDDIR)/,$(addsuffix .o,$(notdir $(SN_RUNTIME_S_SRCS) $(SN_RUNTIME_C_SRCS))))
SN_RUNTIME_DEPS    = $(addprefix $(SN_RUNTIME_BUILDDIR)/,$(addsuffix .d,$(notdir $(SN_RUNTIME_S_SRCS) $(SN_RUNTIME_C_SRCS))))
SN_RUNTIME_LIB     = $(SN_RUNTIME_BUILDDIR)/libsnRuntime.a
SN_RUNTIME_DUMP    = $(SN_RUNTIME_BUILDDIR)/libsnRuntime.dump
SN_RUNTIME_OUTPUTS = $(SN_RUNTIME_LIB)

ifeq ($(DEBUG), ON)
SN_RUNTIME_OUTPUTS += $(SN_RUNTIME_DUMP)
endif

#########
# Rules #
#########

.PHONY: sn-runtime sn-clean-runtime

sn-runtime: $(SN_RUNTIME_OUTPUTS)

sn-clean-runtime:
	rm -rf $(SN_RUNTIME_BUILDDIR)

$(call sn_normalize_dir, $(SN_RUNTIME_BUILDDIR)):
	mkdir -p $@

$(SN_RUNTIME_OBJS): $(SN_RUNTIME_BUILDDIR)/%.o: $(SN_RUNTIME_SRCDIR)/% $(SN_RUNTIME_BUILDDIR)/%.d | $(SN_RUNTIME_BUILDDIR)
	$(SN_RISCV_CXX) $(SN_RUNTIME_RISCV_CFLAGS) -c $< -o $@

$(SN_RUNTIME_DEPS): $(SN_RUNTIME_BUILDDIR)/%.d: $(SN_RUNTIME_SRCDIR)/% | $(SN_RUNTIME_BUILDDIR)
	$(SN_RISCV_CXX) $(SN_RUNTIME_RISCV_CFLAGS) -MM -MT '$(@:.d=.o)' $< > $@

$(SN_RUNTIME_LIB): $(SN_RUNTIME_OBJS) | $(SN_RUNTIME_BUILDDIR)
	$(SN_RISCV_AR) $(SN_RISCV_ARFLAGS) $@ $^

$(SN_RUNTIME_DUMP): $(SN_RUNTIME_LIB) | $(SN_RUNTIME_BUILDDIR)
	$(SN_RISCV_OBJDUMP) $(SN_RISCV_OBJDUMP_FLAGS) $< > $@

$(SN_RUNTIME_DEPS): | $(SN_RUNTIME_HAL_HDRS)

SN_DEPS += $(SN_RUNTIME_DEPS)
