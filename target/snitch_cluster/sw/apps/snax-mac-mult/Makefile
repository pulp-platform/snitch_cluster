# Copyright 2023 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Ryan Antonio <ryan.antonio@esat.kuleuven.be>

APP     = snax-mac-mult
SRCS    = src/snax-mac-mult.c
INCDIRS = data

INCDIRS += ../../snax/mac/include/

RISCV_LDFLAGS += ../../snax/mac/build/mac.o 

include ../common.mk
include ./data/Makefile

$(DEP): $(DATA_H)
