# Copyright 2024 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

MK_DIR   := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

CHISEL_MODULE = BlockGemmSIMD
pkg_name = gemm_simd

define gen_sv_file
	mkdir -p $(MK_DIR)generated/$(pkg_name) && cd $(MK_DIR) && sbt "runMain snax_acc.$(pkg_name).$(1)"
endef

CHISEL_GENERATED_DIR = $(MK_DIR)generated

CHISEL_GENERATED_FILES = $(MK_DIR)generated/$(pkg_name)/$(CHISEL_MODULE).sv

SCALA_SOURCES := $(wildcard src/main/scala/snax_acc/$(pkg_name)/*.scala)
$(CHISEL_GENERATED_FILES): $(SCALA_SOURCES)
	$(call gen_sv_file,$(CHISEL_MODULE))

.PHONY: clean-data clean

clean-chisel-generated-sv:
	rm -f -r $(CHISEL_GENERATED_FILES) $(CHISEL_GENERATED_FILES_OLD) $(CHISEL_GENERATED_DIR)

clean: clean-chisel-generated-sv	
