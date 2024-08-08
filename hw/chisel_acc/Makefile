# Copyright 2024 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>


####################
# Path Definitions #
####################

MK_CUR_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

CHISEL_GENERATED_DIR = $(MK_CUR_DIR)generated

#######################
# Function Definition #
#######################
define gen_snax_acc_sv_file
	mkdir -p $(MK_CUR_DIR)generated/$(1) && cd $(MK_CUR_DIR) && sbt "runMain snax_acc.$(1).$(2)"
endef

GEMM = BlockGemm
GEMM_PKG_NAME = gemm

GEMM_GENERATED_FILES = $(MK_CUR_DIR)generated/$(GEMM_PKG_NAME)/$(GEMM).sv
GEMM_SCALA_SOURCES := $(wildcard src/main/scala/snax_acc/$(GEMM_PKG_NAME)/*.scala)

$(GEMM_GENERATED_FILES): $(GEMM_SCALA_SOURCES)
	$(call gen_snax_acc_sv_file,$(GEMM_PKG_NAME),$(GEMM))

GEMMX = BlockGemmRescaleSIMD
GEMMX_PKG_NAME = gemmx

GEMMX_GENERATED_FILES = $(MK_CUR_DIR)generated/$(GEMMX_PKG_NAME)/$(GEMMX).sv
GEMMX_SCALA_SOURCES := $(wildcard src/main/scala/snax_acc/$(GEMMX_PKG_NAME)/*.scala)

$(GEMMX_GENERATED_FILES): $(GEMMX_SCALA_SOURCES)
	$(call gen_snax_acc_sv_file,$(GEMMX_PKG_NAME),$(GEMMX))

DR = Reshuffler
DR_PKG_NAME = reshuffle

DR_GENERATED_FILES = $(MK_CUR_DIR)generated/$(DR_PKG_NAME)/$(DR).sv
DR_SCALA_SOURCES := $(wildcard src/main/scala/snax_acc/$(DR_PKG_NAME)/*.scala)

$(DR_GENERATED_FILES): $(DR_SCALA_SOURCES)
	$(call gen_snax_acc_sv_file,$(DR_PKG_NAME),$(DR))

.PHONY: clean-data clean

clean:
	rm -f -r $(GEMMX_GENERATED_FILES) $(DR_GENERATED_FILES) $(CHISEL_GENERATED_DIR)
