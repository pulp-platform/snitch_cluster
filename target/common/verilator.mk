# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Tools
BENDER ?= bender
VERILATOR_SEPP ?=
VLT ?= $(VERILATOR_SEPP) verilator

VLT_JOBS        ?= $(shell nproc)
VLT_NUM_THREADS ?= 1

VLT_BENDER   += $(COMMON_BENDER_FLAGS) -t verilator -DCOMMON_CELLS_ASSERTS_OFF
VLT_SOURCES   = $(shell $(BENDER) script flist-plus $(VLT_BENDER) | $(SED_SRCS))
VLT_BUILDDIR := $(abspath work-vlt)

VLT_FESVR     = $(VLT_BUILDDIR)/riscv-isa-sim
VLT_FLAGS    += --timing
VLT_FLAGS    += --timescale 1ns/1ps
VLT_FLAGS    += --trace
VLT_FLAGS    += -Wno-BLKANDNBLK
VLT_FLAGS    += -Wno-LITENDIAN
VLT_FLAGS    += -Wno-CASEINCOMPLETE
VLT_FLAGS    += -Wno-CMPCONST
VLT_FLAGS    += -Wno-WIDTH
VLT_FLAGS    += -Wno-WIDTHCONCAT
VLT_FLAGS    += -Wno-UNSIGNED
VLT_FLAGS    += -Wno-UNOPTFLAT
VLT_FLAGS    += -Wno-fatal
VLT_FLAGS    += --unroll-count 1024
VLT_FLAGS    += --threads $(VLT_NUM_THREADS)

# This target just redirects the verilator simulation binary.
# On IIS machines, verilator needs to be built and run in
# the oseda environment, which is why this is necessary.
$(BIN_DIR)/$(TARGET).vlt: $(BIN_DIR)/$(TARGET)_bin.vlt
	@echo "#!/bin/bash" > $@
	@echo '$(VERILATOR_SEPP) $(realpath $<) $$(realpath $$1) $$2' >> $@
	@chmod +x $@

$(BIN_DIR)/$(TARGET)_bin.vlt: $(VLT_SOURCES) $(TB_CC_SOURCES) $(VLT_CC_SOURCES) $(VLT_BUILDDIR)/lib/libfesvr.a | $(BIN_DIR)
	$(VLT) $(shell $(BENDER) script verilator $(VLT_BENDER)) \
		$(VLT_FLAGS) --Mdir $(VLT_BUILDDIR) \
		-CFLAGS -std=c++20 \
		-CFLAGS -I$(VLT_FESVR)/include \
		-CFLAGS -I$(TB_DIR) \
		-CFLAGS -I$(MKFILE_DIR)test \
		-j $(VLT_JOBS) \
		-o ../$@ --cc --exe --build --top-module testharness $(TB_CC_SOURCES) $(VLT_CC_SOURCES) $(VLT_BUILDDIR)/lib/libfesvr.a

.PHONY: clean-vlt
clean-vlt: clean-work
	rm -rf $(BIN_DIR)/$(TARGET).vlt $(BIN_DIR)/$(TARGET)_bin.vlt $(VLT_BUILDDIR)

clean: clean-vlt
