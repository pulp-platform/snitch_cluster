# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

###############
# Directories #
###############

SN_TESTS_SRCDIR    = $(SN_ROOT)/sw/tests/src
SN_TESTS_BUILDDIR ?= $(SN_ROOT)/sw/tests/build

###################
# Build variables #
###################

SN_TESTS_RISCV_CFLAGS += $(SN_RISCV_CFLAGS)
SN_TESTS_RISCV_CFLAGS += $(addprefix -I,$(SN_RUNTIME_INCDIRS))

SN_RUNTIME_BASE_LD    = $(SN_RUNTIME_DIR)/base.ld
SN_RUNTIME_MEMORY_LD ?= $(SN_RUNTIME_SRCDIR)/memory.ld

SN_TESTS_RISCV_LDFLAGS += $(SN_RISCV_LDFLAGS)
SN_TESTS_RISCV_LDFLAGS += -L$(dir $(SN_RUNTIME_MEMORY_LD))
SN_TESTS_RISCV_LDFLAGS += -T$(SN_RUNTIME_BASE_LD)
SN_TESTS_RISCV_LDFLAGS += -L$(SN_RUNTIME_BUILDDIR)
SN_TESTS_RISCV_LDFLAGS += -lsnRuntime

SN_RUNTIME_LD_DEPS = $(SN_RUNTIME_MEMORY_LD) $(SN_RUNTIME_BASE_LD) $(SN_RUNTIME_LIB)

###########
# Outputs #
###########

SN_TEST_NAMES   = $(basename $(notdir $(wildcard $(SN_TESTS_SRCDIR)/*.c)))
SN_TEST_ELFS    = $(abspath $(addprefix $(SN_TESTS_BUILDDIR)/,$(addsuffix .elf,$(SN_TEST_NAMES))))
SN_TEST_DEPS    = $(abspath $(addprefix $(SN_TESTS_BUILDDIR)/,$(addsuffix .d,$(SN_TEST_NAMES))))
SN_TEST_DUMPS   = $(abspath $(addprefix $(SN_TESTS_BUILDDIR)/,$(addsuffix .dump,$(SN_TEST_NAMES))))
SN_TEST_OUTPUTS = $(SN_TEST_ELFS)

ifeq ($(DEBUG),ON)
SN_TEST_OUTPUTS += $(SN_TEST_DUMPS)
endif

#########
# Rules #
#########

.PHONY: sn-tests sn-clean-tests

sn-tests: $(SN_TEST_OUTPUTS)

sn-clean-tests:
	rm -rf $(SN_TESTS_BUILDDIR)

$(SN_TESTS_BUILDDIR):
	mkdir -p $@

$(SN_TEST_DEPS): $(SN_TESTS_BUILDDIR)/%.d: $(SN_TESTS_SRCDIR)/%.c | $(SN_TESTS_BUILDDIR)
	$(SN_RISCV_CXX) $(SN_TESTS_RISCV_CFLAGS) -MM -MT '$(SN_TESTS_BUILDDIR)/$*.elf' -x c++ $< > $@

$(SN_TEST_ELFS): $(SN_TESTS_BUILDDIR)/%.elf: $(SN_TESTS_SRCDIR)/%.c $(SN_RUNTIME_LD_DEPS) $(SN_TESTS_BUILDDIR)/%.d | $(SN_TESTS_BUILDDIR)
	$(SN_RISCV_CXX) $(SN_TESTS_RISCV_CFLAGS) $(SN_TESTS_RISCV_LDFLAGS) -x c++ $(SN_TESTS_SRCDIR)/$*.c -o $@

$(SN_TEST_DUMPS): $(SN_TESTS_BUILDDIR)/%.dump: $(SN_TESTS_BUILDDIR)/%.elf | $(SN_TESTS_BUILDDIR)
	$(SN_RISCV_OBJDUMP) $(SN_RISCV_OBJDUMP_FLAGS) $< > $@

$(SN_TEST_DEPS): | $(SN_RUNTIME_HAL_HDRS)

SN_DEPS += $(SN_TEST_DEPS)
