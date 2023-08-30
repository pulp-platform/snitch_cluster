# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Viviane Potocnik ETH Zurich <vivianep@iis.ee.ethz.ch>

# Usage of absolute paths is required to externally include this Makefile
MK_DIR   := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
SRC_DIR  := $(realpath $(MK_DIR)../../../target/snitch_cluster/sw/apps/transformer/src)
DNN_DIR  := $(realpath $(MK_DIR)../../dnn/src/)
BLAS_DIR := $(realpath $(MK_DIR)../../blas/)
APP_DIR  := $(realpath $(MK_DIR)src)
DATA_GEN_DIR := $(realpath $(MK_DIR)../../../target/snitch_cluster/sw/apps/dnn/)
APP     ?= transformer

$(info DATA_GEN_DIR: $(DATA_GEN_DIR))

SRCS     = $(realpath $(SRC_DIR)/$(APP).c)
INCDIRS += $(SRC_DIR) $(BLAS_DIR) $(DNN_DIR) $(APP_DIR)

DATA_CFG = $(SRC_DIR)/params.hjson
DATA_H = $(SRC_DIR)/data.h

$(info Generating $(DATA_H) from $(DATA_CFG) using $(DATA_GEN_DIR)/datagen.py)

$(DATA_H): $(DATA_GEN_DIR)/datagen.py $(DATA_CFG)
	$(info Generating $(DATA_H) from $(DATA_CFG))
	$(info Running command: $< -c $(DATA_CFG) -o $@ )
	$< -c $(DATA_CFG) -o $@
	$(info Done and saved to $(DATA_H))

.PHONY: clean-data clean echo

clean-data:
	rm -f $(DATA_H)

clean: clean-data

echo:
	$(info prefix: $(realpath $(MK_DIR)))
	$(info APP: $(APP))
	$(info APP_DIR: $(APP_DIR))
	$(info DATA_H: $(DATA_H))
	$(info DATA_CFG: $(DATA_CFG))
	$(info MK_DIR: $(MK_DIR))
	$(info SRC_DIR: $(SRC_DIR))
	$(info DNN_DIR: $(DNN_DIR))
	$(info BLAS_DIR: $(BLAS_DIR))
	$(info SRCS: $(SRCS))
	$(info INCDIRS: $(INCDIRS))
	$(info DEP: $(DEP))
	$(info PYTHON: $(MK_DIR)dnn/datagen.py)
	$(info PYTHON COMMAND: $(MK_DIR)dnn/datagen.py -c $(DATA_CFG) -o $(DATA_H))