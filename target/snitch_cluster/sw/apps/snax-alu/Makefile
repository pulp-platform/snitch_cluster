# Copyright 2024 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Ryan Antonio <ryan.antonio@esat.kuleuven.be>

APP     = snax-alu

INCDIRS = data

INCDIRS += ../../snax/snax-alu/include

# Include this binary in the final build
RISCV_LDFLAGS += ../../snax/snax-alu/build/snax-alu-lib.o

SRCS    = src/snax-alu.c

include ../common.mk
include ./data/Makefile

$(DEP): $(DATA_H)
