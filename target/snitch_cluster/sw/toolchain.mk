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

# Directory to the MUSL installation
MUSL_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
SW_INSTALL_DIR  ?= $(abspath $(MUSL_DIR)/../../../sw/deps/install/)

# Compiler toolchain
LLVM_BINROOT    ?= $(dir $(shell which riscv32-unknown-elf-clang))
RISCV_CC        ?= $(LLVM_BINROOT)/clang
RISCV_LD        ?= $(LLVM_BINROOT)/ld.lld
RISCV_AR        ?= $(LLVM_BINROOT)/llvm-ar
RISCV_OBJCOPY   ?= $(LLVM_BINROOT)/llvm-objcopy
RISCV_OBJDUMP   ?= $(LLVM_BINROOT)/llvm-objdump
RISCV_DWARFDUMP ?= $(LLVM_BINROOT)/llvm-dwarfdump

# Compiler flags
RISCV_CFLAGS += $(addprefix -I,$(INCDIRS))

# musl specific flags
RISCV_CFLAGS += -I$(SW_INSTALL_DIR)/include
RISCV_CFLAGS += -B$(SW_INSTALL_DIR)/bin

RISCV_CFLAGS += -mcpu=snitch
RISCV_CFLAGS += -menable-experimental-extensions
RISCV_CFLAGS += -mabi=ilp32d
RISCV_CFLAGS += -mcmodel=medany
RISCV_CFLAGS += -ffast-math
RISCV_CFLAGS += -fno-builtin-printf
RISCV_CFLAGS += -fno-common
RISCV_CFLAGS += -fopenmp

# TODO: check why the LTO flags optimizes the CBSS section away
# RISCV_CFLAGS += -flto=thin

RISCV_CFLAGS += -ftls-model=local-exec
RISCV_CFLAGS += -nostdinc

RISCV_CFLAGS += -O3
ifeq ($(DEBUG), ON)
RISCV_CFLAGS += -g
endif

# Linker flags
RISCV_LDFLAGS += -fuse-ld=$(RISCV_LD)
RISCV_LDFLAGS += -nostartfiles
RISCV_LDFLAGS += -lm
# musl specific flags
RISCV_LDFLAGS += -L$(SW_INSTALL_DIR)/lib
RISCV_LDFLAGS += -nostdinc
# RISCV_LDFLAGS += -flto=thin

# Archiver flags
RISCV_ARFLAGS = rcs
