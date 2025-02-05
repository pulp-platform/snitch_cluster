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

SNRT_TESTS_RISCV_LDFLAGS += $(RISCV_LDFLAGS)
SNRT_TESTS_RISCV_LDFLAGS += -L$(abspath $(SNRT_TARGET_DIR)/..)
SNRT_TESTS_RISCV_LDFLAGS += -T$(abspath $(SNRT_DIR)/base.ld)
SNRT_TESTS_RISCV_LDFLAGS += -L$(SNRT_TARGET_DIR)/build
SNRT_TESTS_RISCV_LDFLAGS += -lsnRuntime

###########
# Outputs #
###########

SNRT_TEST_NAMES   = $(basename $(notdir $(wildcard $(SNRT_TESTS_SRCDIR)/*.c)))
SNRT_TEST_ELFS    = $(abspath $(addprefix $(SNRT_TESTS_BUILDDIR)/,$(addsuffix .elf,$(SNRT_TEST_NAMES))))
SNRT_TEST_DEPS    = $(abspath $(addprefix $(SNRT_TESTS_BUILDDIR)/,$(addsuffix .d,$(SNRT_TEST_NAMES))))
SNRT_TEST_DUMPS   = $(abspath $(addprefix $(SNRT_TESTS_BUILDDIR)/,$(addsuffix .dump,$(SNRT_TEST_NAMES))))
SNRT_TEST_DWARFS  = $(abspath $(addprefix $(SNRT_TESTS_BUILDDIR)/,$(addsuffix .dwarf,$(SNRT_TEST_NAMES))))
SNRT_TEST_OUTPUTS = $(SNRT_TEST_ELFS)

ifeq ($(DEBUG), ON)
SNRT_TEST_OUTPUTS += $(SNRT_TEST_DUMPS) $(SNRT_TEST_DWARFS)
endif

#########
# Rules #
#########

.PHONY: snrt-tests snrt-clean-tests

snrt-tests: $(SNRT_TEST_OUTPUTS)

snrt-clean-tests:
	rm -rf $(SNRT_TESTS_BUILDDIR)

$(SNRT_TESTS_BUILDDIR):
	mkdir -p $@

$(SNRT_TESTS_BUILDDIR)/%.d: $(SNRT_TESTS_SRCDIR)/%.c | $(SNRT_TESTS_BUILDDIR)
	$(RISCV_CC) $(SNRT_TESTS_RISCV_CFLAGS) -MM -MT '$(SNRT_TESTS_BUILDDIR)/$*.elf' $< > $@

$(SNRT_TESTS_BUILDDIR)/%.elf: $(SNRT_TESTS_SRCDIR)/%.c $(SNRT_LIB) $(SNRT_TESTS_BUILDDIR)/%.d | $(SNRT_TESTS_BUILDDIR)
	$(RISCV_CC) $(SNRT_TESTS_RISCV_CFLAGS) $(SNRT_TESTS_RISCV_LDFLAGS) $(SNRT_TESTS_SRCDIR)/$*.c -o $@

$(SNRT_TESTS_BUILDDIR)/%.dump: $(SNRT_TESTS_BUILDDIR)/%.elf | $(SNRT_TESTS_BUILDDIR)
	$(RISCV_OBJDUMP) $(RISCV_OBJDUMP_FLAGS) $< > $@

$(SNRT_TESTS_BUILDDIR)/%.dwarf: $(SNRT_TESTS_BUILDDIR)/%.elf | $(SNRT_TESTS_BUILDDIR)
	$(RISCV_DWARFDUMP) $< > $@

$(TEST_DEPS): | $(TARGET_C_HDRS)

ifneq ($(MAKECMDGOALS),snrt-clean-tests)
-include $(TEST_DEPS)
endif
