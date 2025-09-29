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

SN_TESTS       += $(wildcard $(SN_TESTS_SRCDIR)/*.c)
SN_TEST_NAMES   = $(basename $(notdir $(SN_TESTS)))
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

.PHONY: $(SN_TEST_NAMES) sn-tests sn-clean-tests

$(SN_TEST_NAMES): %: $(SN_TESTS_BUILDDIR)/%.dump | $(SN_TESTS_BUILDDIR)

sn-tests: $(SN_TEST_OUTPUTS)

sn-clean-tests:
	rm -rf $(SN_TESTS_BUILDDIR)

$(SN_TESTS_BUILDDIR):
	mkdir -p $@

# Rules to build a single test
# $(1) = full source path
define sn_test_rules

$$(SN_TESTS_BUILDDIR)/$$(notdir $$(basename $(1))).d: $(1) | $$(SN_TESTS_BUILDDIR)
	$$(SN_RISCV_CXX) $$(SN_TESTS_RISCV_CFLAGS) -MM -MT '$$(SN_TESTS_BUILDDIR)/$$(notdir $$(basename $(1))).elf' -x c++ $$< > $$@

$$(SN_TESTS_BUILDDIR)/$$(notdir $$(basename $(1))).elf: $(1) $$(SN_RUNTIME_LD_DEPS) $$(SN_TESTS_BUILDDIR)/$$(notdir $$(basename $(1))).d | $$(SN_TESTS_BUILDDIR)
	$$(SN_RISCV_CXX) $$(SN_TESTS_RISCV_CFLAGS) $$(SN_TESTS_RISCV_LDFLAGS) -x c++ $(1) -o $$@

$$(SN_TESTS_BUILDDIR)/$$(notdir $$(basename $(1))).dump: $$(SN_TESTS_BUILDDIR)/$$(notdir $$(basename $(1))).elf | $$(SN_TESTS_BUILDDIR)
	$$(SN_RISCV_OBJDUMP) $$(SN_RISCV_OBJDUMP_FLAGS) $$< > $$@

endef

# Instantiate rules for each test
$(foreach test,$(SN_TESTS), \
	$(eval $(call sn_test_rules,$(test))) \
)

$(SN_TEST_DEPS): | $(SN_RUNTIME_HAL_HDRS)

SN_DEPS += $(SN_TEST_DEPS)
