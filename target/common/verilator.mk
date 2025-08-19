# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

#######################
# Makefile invocation #
#######################

VLT_NUM_THREADS ?= 1
VLT_JOBS        ?= $(shell nproc)

#############
# Variables #
#############

# Tools
VERILATOR_SEPP ?=
VLT            ?= $(VERILATOR_SEPP) verilator

# Directories
VLT_BUILDDIR = $(SN_TARGET_DIR)/work-vlt
VLT_FESVR    = $(VLT_BUILDDIR)/riscv-isa-sim

# Flags
VLT_BENDER_FLAGS += $(COMMON_BENDER_FLAGS) -t verilator -DASSERTS_OFF
VLT_FLAGS += --timing
VLT_FLAGS += --timescale 1ns/1ps
VLT_FLAGS += --trace
VLT_FLAGS += -Wno-BLKANDNBLK
VLT_FLAGS += -Wno-LITENDIAN
VLT_FLAGS += -Wno-CASEINCOMPLETE
VLT_FLAGS += -Wno-CMPCONST
VLT_FLAGS += -Wno-WIDTH
VLT_FLAGS += -Wno-WIDTHCONCAT
VLT_FLAGS += -Wno-UNSIGNED
VLT_FLAGS += -Wno-UNOPTFLAT
VLT_FLAGS += -Wno-fatal
VLT_FLAGS += --unroll-count 1024
VLT_FLAGS += --threads $(VLT_NUM_THREADS)

# Misc
VLT_TOP_MODULE = testharness
VLT_RTL_PREREQ_FILE = $(VLT_BUILDDIR)/$(VLT_TOP_MODULE).d

#########
# Rules #
#########

$(VLT_BUILDDIR):
	mkdir -p $@

# Generate RTL prerequisites
$(eval $(call gen_rtl_prerequisites,$(VLT_RTL_PREREQ_FILE),$(VLT_BUILDDIR),$(VLT_BENDER_FLAGS),$(VLT_TOP_MODULE),$(SN_BIN_DIR)/$(TARGET).vlt))

# Build fesvr seperately for verilator since this might use different compilers
# and libraries than modelsim/vcs and
# TODO(colluca): is this assumption still valid?
$(VLT_FESVR)/${FESVR_VERSION}_unzip:
	mkdir -p $(dir $@)
	wget -O $(dir $@)/${FESVR_VERSION} https://github.com/riscv/riscv-isa-sim/tarball/${FESVR_VERSION}
	tar xfm $(dir $@)${FESVR_VERSION} --strip-components=1 -C $(dir $@)
	patch $(VLT_FESVR)/fesvr/context.h < patches/context.h.diff
	touch $@

$(VLT_BUILDDIR)/lib/libfesvr.a: $(VLT_FESVR)/${FESVR_VERSION}_unzip
	cd $(dir $<)/ && ./configure --prefix `pwd` \
        CC=${CC} CXX=${CXX} CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}"
	$(MAKE) -C $(dir $<) install-config-hdrs install-hdrs libfesvr.a
	mkdir -p $(dir $@)
	cp $(dir $<)libfesvr.a $@

# Generate and run compilation script, building the Verilator simulation binary
$(SN_BIN_DIR)/$(TARGET)_bin.vlt: $(TB_CC_SOURCES) $(VLT_CC_SOURCES) $(VLT_BUILDDIR)/lib/libfesvr.a | $(SN_BIN_DIR) $(VLT_BUILDDIR)
	$(VLT) $(shell $(BENDER) script verilator $(VLT_BENDER_FLAGS)) \
		$(VLT_FLAGS) --Mdir $(VLT_BUILDDIR) \
		-CFLAGS -std=c++20 \
		-CFLAGS -I$(VLT_FESVR)/include \
		-CFLAGS -I$(TB_DIR) \
		-CFLAGS -I$(MKFILE_DIR)test \
		-j $(VLT_JOBS) \
		-o $@ --cc --exe --build --top-module $(VLT_TOP_MODULE) \
		$(TB_CC_SOURCES) $(VLT_CC_SOURCES) $(VLT_BUILDDIR)/lib/libfesvr.a

# This target just redirects the verilator simulation binary.
# On IIS machines, verilator needs to be built and run in
# the oseda environment, which is why this is necessary.
$(SN_BIN_DIR)/$(TARGET).vlt: $(SN_BIN_DIR)/$(TARGET)_bin.vlt | $(SN_BIN_DIR)
	@echo "#!/bin/bash" > $@
	@echo '$(VERILATOR_SEPP) $(realpath $<) $$(realpath $$1) $$2' >> $@
	@chmod +x $@

.PHONY: verilator clean-verilator

verilator: $(SN_BIN_DIR)/$(TARGET).vlt

clean-verilator: clean-work
	rm -rf $(SN_BIN_DIR)/$(TARGET).vlt $(SN_BIN_DIR)/$(TARGET)_bin.vlt $(VLT_BUILDDIR)

clean: clean-verilator

ifneq ($(filter-out clean%,$(MAKECMDGOALS)),)
-include $(VLT_RTL_PREREQ_FILE)
endif
