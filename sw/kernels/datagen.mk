# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

DATA_DIR    := $(realpath $(SRC_DIR)/../data)

$(APP)_SCRIPT_DIR ?= $(realpath $(SRC_DIR)/../scripts)
$(APP)_DATA_CFG   ?= $(DATA_DIR)/params.json
SECTION           ?=
DATA_H            := $($(APP)_BUILD_DIR)/data.h
DATAGEN_PY        := $($(APP)_SCRIPT_DIR)/datagen.py

$(APP)_HEADERS      := $(DATA_H)
$(APP)_INCDIRS      += $(dir $(DATA_H)) $(SRC_DIR)
$(APP)_DATAGEN_ARGS += -c $($(APP)_DATA_CFG)
$(APP)_DATAGEN_ARGS += --section="$(SECTION)"

$(dir $(DATA_H)):
	mkdir -p $@

$(DATA_H): DATAGEN_ARGS := $($(APP)_DATAGEN_ARGS)
$(DATA_H): $(DATAGEN_PY) $($(APP)_DATA_CFG) | $(dir $(DATA_H))
	$< $(DATAGEN_ARGS) $@
