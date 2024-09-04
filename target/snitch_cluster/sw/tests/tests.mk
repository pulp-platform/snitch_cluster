# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

###############
# Directories #
###############

TESTS_SRCDIR   = $(ROOT)/sw/tests
TESTS_BUILDDIR = $(ROOT)/target/snitch_cluster/sw/tests/build

###################
# Build variables #
###################

TESTS_RISCV_CFLAGS += $(RISCV_CFLAGS)
TESTS_RISCV_CFLAGS += $(addprefix -I,$(SNRT_INCDIRS))

TESTS_RISCV_LDFLAGS += $(RISCV_LDFLAGS)
TESTS_RISCV_LDFLAGS += -L$(abspath $(SNRT_TARGET_DIR)/..)
TESTS_RISCV_LDFLAGS += -T$(abspath $(SNRT_DIR)/base.ld)
TESTS_RISCV_LDFLAGS += -L$(SNRT_TARGET_DIR)/build
TESTS_RISCV_LDFLAGS += -lsnRuntime

###########
# Outputs #
###########

TEST_NAMES   = $(basename $(notdir $(wildcard $(TESTS_SRCDIR)/*.c)))
TEST_ELFS    = $(abspath $(addprefix $(TESTS_BUILDDIR)/,$(addsuffix .elf,$(TEST_NAMES))))
TEST_DEPS    = $(abspath $(addprefix $(TESTS_BUILDDIR)/,$(addsuffix .d,$(TEST_NAMES))))
TEST_DUMPS   = $(abspath $(addprefix $(TESTS_BUILDDIR)/,$(addsuffix .dump,$(TEST_NAMES))))
TEST_OUTPUTS = $(TEST_ELFS)

ifeq ($(DEBUG),ON)
TEST_OUTPUTS += $(TEST_DUMPS)
endif

#########
# Rules #
#########

.PHONY: tests clean-tests

sw: tests
clean-sw: clean-tests

tests: $(TEST_OUTPUTS)

clean-tests:
	rm -rf $(TESTS_BUILDDIR)

$(TESTS_BUILDDIR):
	mkdir -p $@

$(TESTS_BUILDDIR)/%.d: $(TESTS_SRCDIR)/%.c | $(TESTS_BUILDDIR)
	$(RISCV_CC) $(TESTS_RISCV_CFLAGS) -MM -MT '$(TESTS_BUILDDIR)/$*.elf' $< > $@

$(TESTS_BUILDDIR)/%.elf: $(TESTS_SRCDIR)/%.c $(SNRT_LIB) $(TESTS_BUILDDIR)/%.d | $(TESTS_BUILDDIR)
	$(RISCV_CC) $(TESTS_RISCV_CFLAGS) $(TESTS_RISCV_LDFLAGS) $(TESTS_SRCDIR)/$*.c -o $@

$(TESTS_BUILDDIR)/%.dump: $(TESTS_BUILDDIR)/%.elf | $(TESTS_BUILDDIR)
	$(RISCV_OBJDUMP) $(RISCV_OBJDUMP_FLAGS) $< > $@

$(TEST_DEPS): | $(TARGET_C_HDRS)

ifneq ($(filter-out clean%,$(MAKECMDGOALS)),)
-include $(DEP)
endif
