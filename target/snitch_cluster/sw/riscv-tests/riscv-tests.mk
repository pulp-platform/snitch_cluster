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
RVT_SCRDIR := $(ROOT)/sw/deps/riscv-tests/isa
RVT_BUILDDIR := $(ROOT)/target/snitch_cluster/sw/riscv-tests/build/

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

include $(RVT_SCRDIR)/rv32ui/Makefrag
# include $(RVT_SCRDIR)/rv32uc/Makefrag
include $(RVT_SCRDIR)/rv32um/Makefrag
include $(RVT_SCRDIR)/rv32ua/Makefrag
include $(RVT_SCRDIR)/rv32uf/Makefrag
include $(RVT_SCRDIR)/rv32ud/Makefrag
# include $(RVT_SCRDIR)/rv32uzfh/Makefrag
# include $(RVT_SCRDIR)/rv32uzba/Makefrag
# include $(RVT_SCRDIR)/rv32uzbb/Makefrag
# include $(RVT_SCRDIR)/rv32uzbc/Makefrag
# include $(RVT_SCRDIR)/rv32uzbs/Makefrag
# include $(RVT_SCRDIR)/rv32si/Makefrag
# include $(RVT_SCRDIR)/rv32mi/Makefrag

###################
# Build variables #
###################
# Provided variables from toolchain.mk
# - RISCV_CC
# - RISCV_LD
# - RISCV_OBJDUMP

RVT_RISCV_CFLAGS := $(RISCV_CFLAGS) $(RISCV_LDFLAGS)
RVT_RISCV_CFLAGS += -mno-relax -fvisibility=hidden
RVT_RISCV_OBJDUMP_FLAGS := $(RISCV_OBJDUMP_FLAGS)
RVT_RISCV_OBJDUMP_FLAGS += --disassemble-zeroes --section=.text --section=.text.startup --section=.text.init --section=.data

#########
# Rules #
#########
vpath %.S $(RVT_SCRDIR)

# Create the objdumps for each compiled program
%.dump: %
	$(RISCV_OBJDUMP) $(RVT_RISCV_OBJDUMP_FLAGS) $(RVT_BUILDDIR)$<.elf > $(RVT_BUILDDIR)$@

# Macro to compile each program
define compile_template

$$($(1)_p_tests): $(1)-p-%: $(1)/%.S | $(RVT_BUILDDIR)
	$$(RISCV_CC) $$(RVT_RISCV_CFLAGS) -I$(RVT_SCRDIR)/../env/p -I$(RVT_SCRDIR)/macros/scalar -T$(RVT_SCRDIR)/../env/p/link.ld $$< -o $(RVT_BUILDDIR)$$@.elf
$(1)_tests += $$($(1)_p_tests)

$$($(1)_v_tests): $(1)-v-%: $(1)/%.S
	$$(RISCV_CC) $$(RVT_RISCV_CFLAGS) -DENTROPY=0x$$(shell echo \$$@ | md5sum | cut -c 1-7) -std=gnu99 -O2 -I$(RVT_SCRDIR)/../env/v -I$(RVT_SCRDIR)/macros/scalar -T$(RVT_SCRDIR)/../env/v/link.ld $(RVT_SCRDIR)/../env/v/entry.S $(RVT_SCRDIR)/../env/v/*.c $$< -o $(RVT_BUILDDIR)$$@.elf
$(1)_tests += $$($(1)_v_tests)

$(1)_tests_dump = $$(addsuffix .dump, $$($(1)_tests))

$(1): $$($(1)_tests_dump)

.PHONY: $(1)

COMPILER_SUPPORTS_$(1) := $$(shell $(RISCV_CC) $(2) -c -x c /dev/null -o /dev/null 2> /dev/null; echo $$$$?)
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

junk += $(addprefix $(RVT_BUILDDIR),$(addsuffix .elf,$(tests))) $(addprefix $(RVT_BUILDDIR),$(tests_dump))

$(RVT_BUILDDIR):
	mkdir -p $@

.PHONY: riscv-tests clean-riscv-tests

riscv-tests: $(tests_dump) | $(RVT_BUILDDIR)

clean-riscv-tests:
	rm -rf $(junk)

# Integrate into main Makefile flow
sw: riscv-tests
clean-sw: clean-riscv-tests
