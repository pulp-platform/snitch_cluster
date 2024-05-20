# Copyright 2024 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Ryan Antonio <ryan.antonio@esat.kuleueven.be>

# Usage of absolute paths is required to externally include this Makefile
MK_DIR   := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
DATA_DIR := $(realpath $(MK_DIR))

# Set these as default values
LENGTH ?= 320
MODE ?= 0

# File paths
DATAGEN_PY = $(DATA_DIR)/datagen.py
DATA_H = $(DATA_DIR)/data.h

.PHONY: clean clean-data

clean-data:
	rm -f $(DATA_H)

clean: clean-data

$(DATA_H): 
	$(DATAGEN_PY) $< --mode=$(MODE) --length=$(LENGTH) > $@


