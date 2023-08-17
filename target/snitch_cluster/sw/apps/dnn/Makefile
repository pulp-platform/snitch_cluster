# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Gianna Paulin <pauling@iis.ee.ethz.ch>

# Usage of absolute paths is required to externally include this Makefile
MK_DIR   := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
SRC_DIR  := $(realpath $(MK_DIR)/$(APP)/src)
DNN_DIR  := $(realpath $(MK_DIR)../../../../../sw/dnn/src)
BLAS_DIR := $(realpath $(MK_DIR)../../../../../sw/blas/)

SRCS     = $(realpath $(SRC_DIR)/$(APP).c)
INCDIRS += $(SRC_DIR) $(BLAS_DIR) $(DNN_DIR)

DATA_CFG = $(SRC_DIR)/params.hjson
DATA_H = $(SRC_DIR)/data.h

$(DATA_H): $(MK_DIR)/datagen.py $(DATA_CFG)
	$< -c $(DATA_CFG) -o $@

.PHONY: clean-data clean

clean-data:
	rm -f $(DATA_H)

clean: clean-data
