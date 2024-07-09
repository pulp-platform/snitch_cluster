# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>
# Viviane Potocnik <vivianep@iis.ee.ethz.ch>

######################
# Invocation options #
######################

DEBUG ?= OFF # ON to turn on debugging symbols

###################
# Build variables #
###################

# Compiler toolchain
ifneq ($(SELECT_TOOLCHAIN), llvm-generic)
# specialized version does not use a version specifier in the binary
LLVM_BINROOT    = /tools/riscv-llvm/bin
LLVM_VERSION    = 
else
LLVM_BINROOT    = /usr/bin
LLVM_VERSION    =
endif
RISCV_CC        ?= $(LLVM_BINROOT)/clang$(LLVM_VERSION)
RISCV_LD        ?= $(LLVM_BINROOT)/ld.lld$(LLVM_VERSION)
RISCV_AR        ?= $(LLVM_BINROOT)/llvm-ar$(LLVM_VERSION)
RISCV_OBJCOPY   ?= $(LLVM_BINROOT)/llvm-objcopy$(LLVM_VERSION)
RISCV_OBJDUMP   ?= $(LLVM_BINROOT)/llvm-objdump$(LLVM_VERSION)
RISCV_DWARFDUMP ?= $(LLVM_BINROOT)/llvm-dwarfdump$(LLVM_VERSION)

LLVM_VER        ?= $(shell /tools/riscv-llvm/bin/llvm-config --version | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+')

# Compiler flags
ifneq ($(SELECT_TOOLCHAIN), llvm-generic)
RISCV_CFLAGS += -mcpu=snitch
RISCV_CFLAGS += -menable-experimental-extensions
else
RISCV_CFLAGS += --target=riscv32-unknown-elf
RISCV_CFLAGS += -mcpu=generic-rv32
RISCV_CFLAGS += -march=rv32imafdzfh
RISCV_CFLAGS += -fno-builtin-memset
# Required by printf lib such that svnprintf does not emit __udivdi3
RISCV_CFLAGS += -DPRINTF_DISABLE_SUPPORT_LONG_LONG
endif
# Common flags
RISCV_CFLAGS += $(addprefix -I,$(INCDIRS))
RISCV_CFLAGS += -mabi=ilp32d
RISCV_CFLAGS += -mcmodel=medany
# RISCV_CFLAGS += -mno-fdiv # Not supported by Clang
RISCV_CFLAGS += -ffast-math
RISCV_CFLAGS += -fno-builtin-printf
RISCV_CFLAGS += -fno-builtin-sqrtf
RISCV_CFLAGS += -fno-common
RISCV_CFLAGS += -fopenmp
RISCV_CFLAGS += -ftls-model=local-exec
RISCV_CFLAGS += -O3
ifeq ($(DEBUG), ON)
RISCV_CFLAGS += -g
endif
# Required by math library to avoid conflict with stdint definition
RISCV_CFLAGS += -D__DEFINED_uint64_t

# Linker flags
ifneq ($(SELECT_TOOLCHAIN), llvm-generic)
RISCV_LDFLAGS += -nostartfiles
RISCV_LDFLAGS += -lclang_rt.builtins-riscv32
RISCV_LDFLAGS += -L/tools/riscv-llvm/lib/clang/$(LLVM_VER)/lib/
RISCV_LDFLAGS += -lc
endif
# Common flags
RISCV_LDFLAGS += -fuse-ld=$(RISCV_LD)
RISCV_LDFLAGS += -nostdlib

# Archiver flags
RISCV_ARFLAGS = rcs
