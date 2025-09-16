# Copyright 2025 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Pascal Etterli <petterli@student.ethz.ch>
#
# This Makefile builds the ISA tests from the RISC-V Test repository.
# It makes use of the ETHZ LLVM clang infrastructure instead of the provided
# gcc build setup in the original repository.
# See also: https://github.com/riscv-software-src/riscv-tests

##################
# Test selection #
##################
# Sources & destination
SN_RVTESTS_SCRDIR    = $(SN_ROOT)/sw/deps/riscv-tests/isa
SN_RVTESTS_BUILDDIR ?= $(SN_ROOT)/sw/riscv-tests/build/

# Select the desired test cases
# We ignore the following tests as we cannot build them with the snitch
# compiler toolchain.
# - rv32mi: CSR tcontrol is not recognized
#
# We ignore the following test cases as we don't implement the extensions
# - rv32uc
# - rv32si
# - rv32uzfh
# - rv32uzba
# - rv32uzbb
# - rv32uzbc
# - rv32uzbs

include $(SN_RVTESTS_SCRDIR)/rv32ui/Makefrag
# include $(SN_RVTESTS_SCRDIR)/rv32uc/Makefrag
include $(SN_RVTESTS_SCRDIR)/rv32um/Makefrag
include $(SN_RVTESTS_SCRDIR)/rv32ua/Makefrag
include $(SN_RVTESTS_SCRDIR)/rv32uf/Makefrag
include $(SN_RVTESTS_SCRDIR)/rv32ud/Makefrag
# include $(SN_RVTESTS_SCRDIR)/rv32uzfh/Makefrag
# include $(SN_RVTESTS_SCRDIR)/rv32uzba/Makefrag
# include $(SN_RVTESTS_SCRDIR)/rv32uzbb/Makefrag
# include $(SN_RVTESTS_SCRDIR)/rv32uzbc/Makefrag
# include $(SN_RVTESTS_SCRDIR)/rv32uzbs/Makefrag
# include $(SN_RVTESTS_SCRDIR)/rv32si/Makefrag
# include $(SN_RVTESTS_SCRDIR)/rv32mi/Makefrag

###################
# Build variables #
###################
# Provided variables from toolchain.mSN_k
# - RISCV_CC
# - RISCV_LD
# - RISCV_OBJDUMP

SN_RVT_RISCV_CFLAGS := $(SN_RISCV_CFLAGS) $(SN_RISCV_LDFLAGS)
SN_RVT_RISCV_CFLAGS += -mno-relax -fvisibility=hidden
SN_RVT_RISCV_OBJDUMP_FLAGS := $(SN_RISCV_OBJDUMP_FLAGS)
SN_RVT_RISCV_OBJDUMP_FLAGS += --disassemble-zeroes --section=.text --section=.text.startup --section=.text.init --section=.data

#########
# Rules #
#########
vpath %.S $(SN_RVTESTS_SCRDIR)
vpath %.elf $(SN_RVTESTS_BUILDDIR)
vpath %.dump $(SN_RVTESTS_BUILDDIR)

# Macro to compile each program
define compile_template

$$(addsuffix .elf,$$($(1)_p_tests)): $(1)-p-%.elf: $(1)/%.S | $(SN_RVTESTS_BUILDDIR)
	$$(SN_RISCV_CC) $$(SN_RVT_RISCV_CFLAGS) -I$(SN_RVTESTS_SCRDIR)/../env/p -I$(SN_RVTESTS_SCRDIR)/macros/scalar -T$(SN_RVTESTS_SCRDIR)/../env/p/link.ld $$< -o $(SN_RVTESTS_BUILDDIR)$$@
$(1)_tests += $$($(1)_p_tests)

$$(addsuffix .elf,$$($(1)_v_tests)): $(1)-v-%.elf: $(1)/%.S
	$$(SN_RISCV_CC) $$(SN_RVT_RISCV_CFLAGS) -DENTROPY=0x$$(shell echo \$$@ | md5sum | cut -c 1-7) -std=gnu99 -O2 -I$(SN_RVTESTS_SCRDIR)/../env/v -I$(SN_RVTESTS_SCRDIR)/macros/scalar -T$(SN_RVTESTS_SCRDIR)/../env/v/link.ld $(SN_RVTESTS_SCRDIR)/../env/v/entry.S $(SN_RVTESTS_SCRDIR)/../env/v/*.c $$< -o $(SN_RVTESTS_BUILDDIR)$$@
$(1)_tests += $$($(1)_v_tests)

$(1)_tests_dump = $$(addsuffix .dump, $$($(1)_tests))

$(1): $$($(1)_tests_dump)

.PHONY: $(1)

$$($(1)_tests_dump): %.dump: %.elf
	$$(SN_RISCV_OBJDUMP) $$(SN_RVT_RISCV_OBJDUMP_FLAGS) $$(SN_RVTESTS_BUILDDIR)$$< > $$(SN_RVTESTS_BUILDDIR)$$@

COMPILER_SUPPORTS_$(1) := $$(shell $(SN_RISCV_CC) $(2) -c -x c /dev/null -o /dev/null 2> /dev/null; echo $$$$?)
ifeq ($$(COMPILER_SUPPORTS_$(1)),0)
tests += $$($(1)_tests)
endif

tests += $$($(1)_tests)

endef

# auto generate all test cases. Generates empty ones if Makefrag is not included above
$(eval $(call compile_template,rv32ui))
$(eval $(call compile_template,rv32uc))
$(eval $(call compile_template,rv32um))
$(eval $(call compile_template,rv32ua))
$(eval $(call compile_template,rv32uf))
$(eval $(call compile_template,rv32ud))
$(eval $(call compile_template,rv32uzfh))
$(eval $(call compile_template,rv32uzba))
$(eval $(call compile_template,rv32uzbb))
$(eval $(call compile_template,rv32uzbc))
$(eval $(call compile_template,rv32uzbs))
$(eval $(call compile_template,rv32si))
$(eval $(call compile_template,rv32mi))

tests_dump = $(addsuffix .dump, $(tests))

junk += $(addprefix $(SN_RVTESTS_BUILDDIR),$(addsuffix .elf,$(tests))) $(addprefix $(SN_RVTESTS_BUILDDIR),$(tests_dump))

$(SN_RVTESTS_BUILDDIR):
	mkdir -p $@

.PHONY: sn-riscv-tests sn-clean-riscv-tests

sn-riscv-tests: $(tests_dump) | $(SN_RVTESTS_BUILDDIR)

sn-clean-riscv-tests:
	rm -rf $(junk)

# Integrate into main Makefile flow
sn-sw: sn-riscv-tests
sn-clean-sw: sn-clean-riscv-tests
