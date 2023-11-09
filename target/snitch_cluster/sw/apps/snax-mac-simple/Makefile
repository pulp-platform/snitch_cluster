# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Gianna Paulin <pauling@iis.ee.ethz.ch>
# Josse Van Delm <jvandelm@esat.kuleuven.be>

# Usage of absolute paths is required to externally include this Makefile
MK_DIR   := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
SRC_DIR  := $(realpath $(MK_DIR)/$(APP)/src)

INCDIRS += $(SRC_DIR)
INCDIRS += ../../../snax/mac/include

# Include this binary in the final build
RISCV_LDFLAGS += ../../../snax/mac/build/mac.o

SRCS     = $(realpath $(SRC_DIR)/$(APP).c)

LENGTH ?= 20
TILE_SIZE ?= 4

DATA_H = $(SRC_DIR)/data.h

$(DATA_H): $(MK_DIR)/datagen.py
	$< --length=$(LENGTH) --tile_size=$(TILE_SIZE) > $@

.PHONY: clean-data clean

clean-data:
	rm -f $(DATA_H)

clean: clean-data
