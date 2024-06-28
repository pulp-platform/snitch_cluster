# Copyright 2024 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

MK_DIR   := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

CHISEL_GENERATED_DIR = $(MK_DIR)generated

define gen_sv_file
	mkdir -p $(MK_DIR)generated/$(1) && cd $(MK_DIR) && sbt "runMain snax_acc.$(1).$(2)"
endef

GEMMX = BlockGemmRescaleSIMD
GEMMX_PKG_NAME = gemmx

GEMMX_GENERATED_FILES = $(MK_DIR)generated/$(GEMMX_PKG_NAME)/$(GEMMX).sv
GEMMX_SCALA_SOURCES := $(wildcard src/main/scala/snax_acc/$(GEMMX_PKG_NAME)/*.scala)

$(GEMMX_GENERATED_FILES): $(GEMMX_SCALA_SOURCES)
	$(call gen_sv_file,$(GEMMX_PKG_NAME),$(GEMMX))

DR = Reshuffler
DR_PKG_NAME = reshuffle

DR_GENERATED_FILES = $(MK_DIR)generated/$(DR_PKG_NAME)/$(DR).sv
DR_SCALA_SOURCES := $(wildcard src/main/scala/snax_acc/$(DR_PKG_NAME)/*.scala)

$(DR_GENERATED_FILES): $(DR_SCALA_SOURCES)
	$(call gen_sv_file,$(DR_PKG_NAME),$(DR))

.PHONY: clean-data clean

clean-chisel-generated-sv:
	rm -f -r $(CHISEL_GENERATED_FILES) $(CHISEL_GENERATED_FILES_OLD) $(CHISEL_GENERATED_DIR)

clean: clean-chisel-generated-sv	
