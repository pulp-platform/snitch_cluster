# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Ryan Antonio <ryan.antonio@esat.kuleuven.be>
# Josse Van Delm <jvandelm@esat.kuleuven.be>

PYTHON = python3
MK_DIR   := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
DATA_DIR := $(realpath $(MK_DIR)/data)
SRC_DIR  := $(realpath $(MK_DIR)/src)
DATAGEN_PY = $(DATA_DIR)/datagen.py
DATA_H     = $(DATA_DIR)/data.h

LENGTH ?= 512
TILE_SIZE ?= 32

APP     ?= snax-mac-tiled
SRCS    ?= $(SRC_DIR)/snax-mac-tiled.c
INCDIRS += $(DATA_DIR) $(SRC_DIR)

$(DATA_H): $(DATAGEN_PY)
	$< --length=$(LENGTH) --tile_size=$(TILE_SIZE) > $@

.PHONY: clean-data clean

clean-data:
	rm -f $(DATA_H)

clean: clean-data

include ../common.mk

$(DEP): $(DATA_H)

