# Copyright 2024 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Ryan Antonio <ryan.antonio@esat.kuleuven.be>

APP     = dna-recog-long

# Grab the include directory from the snax-hypercorex
INCDIRS += ../../../snax/hypercorex/include
INCDIRS += data

RISCV_LDFLAGS += ../../../snax/hypercorex/build/snax-hypercorex-lib.o

include ./data/Makefile
include ../Makefile
include ../../common.mk

$(DEP): $(DATA_H)
