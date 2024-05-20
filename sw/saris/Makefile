# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Paul Scheffler <paulsc@iis.ee.ethz.ch>
# Luca Colagrande <colluca@iis.ee.ethz.ch>

all:

###############
# Environment #
###############

# NOTE: the LLVM_BINROOT environment variable must point to a specific revision of PULP RISCV
# LLVM 15 (see README.md). After compilation, you can set LLVM_BINROOT in your environment, this
# makefile, or pass it on invocation of `make`.
ifndef LLVM_BINROOT
$(error LLVM_BINROOT is not set; please compile the SARIS version of LLVM 15 (see README.md) and set LLVM_BINROOT to its binary location.)
endif

PYTHON3 ?= python3

SARISDIR ?= .
GENDIR   ?= $(SARISDIR)/gen
UTILDIR  ?= $(SARISDIR)/util
BINDIR 	 ?= $(SARISDIR)/bin
DUMPDIR  ?= $(SARISDIR)/dump
RTDIR 	 ?= $(SARISDIR)/runtime

# We depend on the printf submodule
PRINTFDIR ?= $(SARISDIR)/../deps/printf

############################
# Compiler (LLVM 15) Setup #
############################

RISCV_MARCH  ?= \
rv32imafd_zfh_xfrep_xssr_xdma_xfalthalf_xfquarter_xfaltquarter_xfvecsingle_xfvechalf_$\
xfvecalthalf_xfvecquarter_xfvecaltquarter_xfauxhalf_xfauxalthalf_xfauxquarter_xfauxaltquarter_$\
xfauxvecsingle_xfauxvechalf_xfauxvecalthalf_xfauxvecquarter_xfauxvecaltquarter_xfexpauxvechalf_$\
xfexpauxvecalthalf_xfexpauxvecquarter_xfexpauxvecaltquarter

RISCV_MABI   ?= ilp32d

RISCV_CC      ?= $(LLVM_BINROOT)/clang
RISCV_CXX     ?= $(LLVM_BINROOT)/clang++
RISCV_OBJDUMP ?= $(LLVM_BINROOT)/llvm-objdump
RISCV_STRIP   ?= $(LLVM_BINROOT)/llvm-strip

RISCV_STACK  ?= 2048
RISCV_FLAGS ?= -mcpu=snitch -march=$(RISCV_MARCH) -Ofast -flto -mabi=$(RISCV_MABI) \
               -Wframe-larger-than=$(RISCV_STACK) -nostdlib -mcmodel=medany -I$(RTDIR) \
               -I$(SARISDIR)/stencils -I$(PRINTFDIR) -ffreestanding -fno-builtin \
               -ffunction-sections

RISCV_CFLAGS ?= $(RISCV_FLAGS)
# Loop unrolling optimization
RISCV_CFLAGS += -mllvm --allow-unroll-and-jam
RISCV_CFLAGS += -mllvm --unroll-allow-partial
RISCV_CFLAGS += -mllvm --unroll-runtime
# Tree height reduction options
RISCV_CFLAGS += -mllvm --enable-fp-thr
RISCV_CFLAGS += -mllvm --thr-max-depth=5
RISCV_CFLAGS += -mllvm --thr-se-leaves
RISCV_CFLAGS += -mllvm --thr-fuse-bias
RISCV_CFLAGS += -mllvm --thr-se-factor=2
RISCV_CFLAGS += -mllvm --thr-re-factor=1
# Machine scheduler and PostRA options
RISCV_CFLAGS += -mllvm --post-RA-scheduler
RISCV_CFLAGS += -mllvm --enable-misched
RISCV_CFLAGS += -mllvm --enable-post-misched
RISCV_CFLAGS += -mllvm --misched-postra

RISCV_CCFLAGS  ?= $(RISCV_CFLAGS) -std=gnu11
RISCV_CXXFLAGS ?= $(RISCV_CFLAGS) -std=gnu++14
RISCV_LDFLAGS  ?= -fuse-ld=$(LLVM_BINROOT)/ld.lld -flto -static -lm $(RISCV_FLAGS) \
                  -Wl,--fatal-warnings -Wl,-z,stack-size=$(RISCV_STACK)
RISCV_DMPFLAGS ?= --mcpu=snitch

############################
# SARIS Program Build Flow #
############################

.SECONDEXPANSION:
.DELETE_ON_ERROR:

# Extracting word nr. $(1) from $(2)-separated list $(3)
pw = $(word $(1), $(subst $(2), ,$(3)))

$(GENDIR) $(BINDIR) $(DUMPDIR):
	mkdir -p $@

$(BINDIR)/crt0.o: $(SARISDIR)/runtime/crt0.S | $(BINDIR)
	$(RISCV_CC) $(RISCV_CCFLAGS) -c $< -o $@

$(BINDIR)/istc.%.c.o: $(GENDIR)/$$(call pw,1,.,$$*).cpp | $(BINDIR)
	$(RISCV_CXX) $(RISCV_CXXFLAGS) -c $< -o $@

.PRECIOUS: $(BINDIR)/%.elf
$(BINDIR)/istc.%.elf: $(BINDIR)/istc.%.c.o $(BINDIR)/crt0.o $(RTDIR)/link.ld | $(BINDIR)
	$(RISCV_CC) $(RISCV_LDFLAGS) -o $@ $< $(BINDIR)/crt0.o -T$(RTDIR)/link.ld
	$(RISCV_STRIP) $@ -g -S -d --strip-debug -R .comment -R .riscv.attributes

.PRECIOUS: $(DUMPDIR)/%.dump
$(DUMPDIR)/%.dump: $(BINDIR)/%.elf | $(DUMPDIR)
	@$(RISCV_OBJDUMP) $(RISCV_DMPFLAGS) -j .text  -d $< >$@
	@$(RISCV_OBJDUMP) $(RISCV_DMPFLAGS) -j .misc  -s $< | tail -n +3 >>$@
	@$(RISCV_OBJDUMP) $(RISCV_DMPFLAGS) -j .tcdm  -s $< | tail -n +3 >>$@
	@$(RISCV_OBJDUMP) $(RISCV_DMPFLAGS) -j .tcdmc -s $< | tail -n +3 >>$@

# Phony for program and dump build
prog.%: $(BINDIR)/%.elf $(DUMPDIR)/%.dump
	@echo -e '\x1b[44;33;1mBUILT: $*\x1b[0m'

clean:
	rm -rf $(BINDIR) $(DUMPDIR) $(GENDIR)

############################
# SARIS Program Generation #
############################

.PRECIOUS: $(GENDIR)/%.cpp
$(GENDIR)/%.cpp: $(UTILDIR)/evalgen.py $(SARISDIR)/eval.json $(UTILDIR)/eval.cpp.tpl | $(GENDIR)
	$(PYTHON3) $^ $* > $@

EVAL_NAMES ?= $(shell jq -r 'keys | join(" ")' $(SARISDIR)/eval.json)
ISTC_PROGS += $(patsubst %,istc.%,$(EVAL_NAMES))

# Default: compile all SARIS programs in eval.json
all: $(addprefix prog.,$(ISTC_PROGS))
