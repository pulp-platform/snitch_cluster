# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

###############
# Directories #
###############

SNRT_TESTS_SRCDIR    = $(SN_ROOT)/sw/tests
SNRT_TESTS_BUILDDIR ?= $(SN_ROOT)/target/snitch_cluster/sw/tests/build

###################
# Build variables #
###################

SNRT_TESTS_RISCV_CFLAGS += $(RISCV_CFLAGS)
SNRT_TESTS_RISCV_CFLAGS += $(addprefix -I,$(SNRT_INCDIRS))

SNRT_BASE_LD    = $(SNRT_DIR)/base.ld
SNRT_MEMORY_LD ?= $(SN_ROOT)/target/snitch_cluster/sw/runtime/memory.ld

SNRT_TESTS_RISCV_LDFLAGS += $(RISCV_LDFLAGS)
SNRT_TESTS_RISCV_LDFLAGS += -L$(dir $(SNRT_MEMORY_LD))
SNRT_TESTS_RISCV_LDFLAGS += -T$(SNRT_BASE_LD)
SNRT_TESTS_RISCV_LDFLAGS += -L$(SNRT_BUILDDIR)
SNRT_TESTS_RISCV_LDFLAGS += -lsnRuntime

SNRT_LD_DEPS = $(SNRT_MEMORY_LD) $(SNRT_BASE_LD) $(SNRT_LIB)

###########
# Outputs #
###########

SNRT_TEST_NAMES   = $(basename $(notdir $(wildcard $(SNRT_TESTS_SRCDIR)/*.c)))
SNRT_TEST_ELFS    = $(abspath $(addprefix $(SNRT_TESTS_BUILDDIR)/,$(addsuffix .elf,$(SNRT_TEST_NAMES))))
SNRT_TEST_DEPS    = $(abspath $(addprefix $(SNRT_TESTS_BUILDDIR)/,$(addsuffix .d,$(SNRT_TEST_NAMES))))
SNRT_TEST_DUMPS   = $(abspath $(addprefix $(SNRT_TESTS_BUILDDIR)/,$(addsuffix .dump,$(SNRT_TEST_NAMES))))
SNRT_TEST_OUTPUTS = $(SNRT_TEST_ELFS)

ifeq ($(DEBUG),ON)
SNRT_TEST_OUTPUTS += $(SNRT_TEST_DUMPS)
endif

#########
# Rules #
#########

.PHONY: sn-tests sn-clean-tests

sn-tests: $(SNRT_TEST_OUTPUTS)

sn-clean-tests:
	rm -rf $(SNRT_TESTS_BUILDDIR)

$(SNRT_TESTS_BUILDDIR):
	mkdir -p $@

$(SNRT_TESTS_BUILDDIR)/%.d: $(SNRT_TESTS_SRCDIR)/%.c | $(SNRT_TESTS_BUILDDIR)
	$(RISCV_CC) $(SNRT_TESTS_RISCV_CFLAGS) -MM -MT '$(SNRT_TESTS_BUILDDIR)/$*.elf' $< > $@

$(SNRT_TESTS_BUILDDIR)/%.elf: $(SNRT_TESTS_SRCDIR)/%.c $(SNRT_LD_DEPS) $(SNRT_TESTS_BUILDDIR)/%.d | $(SNRT_TESTS_BUILDDIR)
	$(RISCV_CC) $(SNRT_TESTS_RISCV_CFLAGS) $(SNRT_TESTS_RISCV_LDFLAGS) $(SNRT_TESTS_SRCDIR)/$*.c -o $@

$(SNRT_TESTS_BUILDDIR)/%.dump: $(SNRT_TESTS_BUILDDIR)/%.elf | $(SNRT_TESTS_BUILDDIR)
	$(RISCV_OBJDUMP) $(RISCV_OBJDUMP_FLAGS) $< > $@

$(SNRT_TEST_DEPS): | $(SNRT_HAL_HDRS)

ifneq ($(filter-out clean%,$(MAKECMDGOALS)),)
-include $(SNRT_TEST_DEPS)
endif
