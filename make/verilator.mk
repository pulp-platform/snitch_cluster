# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

#######################
# Makefile invocation #
#######################

SN_VLT_NUM_THREADS ?= 1
SN_VLT_JOBS        ?= $(shell nproc)

#############
# Variables #
#############

# Directories
SN_VLT_BUILDDIR = $(SN_TARGET_DIR)/sim/build/work-vlt
SN_VLT_FESVR    = $(SN_VLT_BUILDDIR)/riscv-isa-sim

# Flags
SN_VLT_BENDER_FLAGS += $(SN_COMMON_BENDER_FLAGS) -t verilator -DASSERTS_OFF
SN_VLT_FLAGS += --timing
SN_VLT_FLAGS += --timescale 1ns/1ps
SN_VLT_FLAGS += --trace-vcd
SN_VLT_FLAGS += --no-assert-case
SN_VLT_FLAGS += -Wno-BLKANDNBLK
SN_VLT_FLAGS += -Wno-LITENDIAN
SN_VLT_FLAGS += -Wno-CASEINCOMPLETE
SN_VLT_FLAGS += -Wno-CMPCONST
SN_VLT_FLAGS += -Wno-WIDTH
SN_VLT_FLAGS += -Wno-WIDTHCONCAT
SN_VLT_FLAGS += -Wno-UNSIGNED
SN_VLT_FLAGS += -Wno-UNOPTFLAT
SN_VLT_FLAGS += -Wno-fatal
SN_VLT_FLAGS += --unroll-count 1024
SN_VLT_FLAGS += --threads $(SN_VLT_NUM_THREADS)

# Misc
SN_VLT_TOP_MODULE = testharness
SN_VLT_RTL_PREREQ_FILE = $(SN_VLT_BUILDDIR)/$(SN_VLT_TOP_MODULE).d

#########
# Rules #
#########

$(SN_VLT_BUILDDIR):
	mkdir -p $@

# Generate RTL prerequisites
$(eval $(call sn_gen_rtl_prerequisites,$(SN_VLT_RTL_PREREQ_FILE),$(SN_VLT_BUILDDIR),$(SN_VLT_BENDER_FLAGS),$(SN_VLT_TOP_MODULE),$(SN_BIN_DIR)/$(TARGET).vlt))

# Generate and run compilation script, building the Verilator simulation binary
$(SN_BIN_DIR)/$(TARGET)_bin.vlt: $(SN_TB_CC_SOURCES) $(SN_VLT_CC_SOURCES) $(SN_WORK_DIR)/lib/libfesvr.a $(SN_VLT_RTL_PREREQ_FILE) | $(SN_BIN_DIR) $(SN_VLT_BUILDDIR)
	$(SN_VLT) $(shell $(SN_BENDER) script verilator $(SN_VLT_BENDER_FLAGS)) \
		$(SN_VLT_FLAGS) --Mdir $(SN_VLT_BUILDDIR) \
		-CFLAGS -std=c++20 \
		-CFLAGS -I$(SN_WORK_DIR)/include \
		-CFLAGS -I$(SN_TB_DIR) \
		-j $(SN_VLT_JOBS) \
		-o $@ --cc --exe --build --top-module $(SN_VLT_TOP_MODULE) \
		$(SN_TB_CC_SOURCES) $(SN_VLT_CC_SOURCES) $(SN_WORK_DIR)/lib/libfesvr.a | tee $(SN_VLT_BUILDDIR)/verilator.log

# This target just redirects the verilator simulation binary.
# On IIS machines, verilator needs to be built and run in
# the oseda environment, which is why this is necessary.
$(SN_BIN_DIR)/$(TARGET).vlt: $(SN_BIN_DIR)/$(TARGET)_bin.vlt | $(SN_BIN_DIR)
	@echo "#!/bin/bash" > $@
	@echo '$(SN_VERILATOR_SEPP) $(realpath $<) $$(realpath $$1) $$2' >> $@
	@chmod +x $@

.PHONY: verilator clean-verilator

verilator: $(SN_BIN_DIR)/$(TARGET).vlt

clean-verilator: clean-work
	rm -rf $(SN_BIN_DIR)/$(TARGET).vlt $(SN_BIN_DIR)/$(TARGET)_bin.vlt $(SN_VLT_BUILDDIR)

clean: clean-verilator

SN_DEPS += $(SN_VLT_RTL_PREREQ_FILE)
