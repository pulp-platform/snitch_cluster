# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Tools
BENDER ?= bender
VCS_SEPP ?=
VCS ?= $(VCS_SEPP) vcs

# VCS_BUILDDIR should to be the same as the `DEFAULT : ./work-vcs`
# in target/snitch_cluster/synopsys_sim.setup
BENDER_LOCK  ?= $(SNITCH_ROOT)/Bender.lock
VCS_BENDER   += $(COMMON_BENDER_FLAGS) $(COMMON_SIM_BENDER_FLAGS) -t vcs
VCS_SOURCES   = $(shell $(BENDER) script flist-plus $(VCS_BENDER) | $(SED_SRCS))

VCS_BUILDDIR := work-vcs
BIN_DIR 		 ?= bin
TARGET       ?= snitch_cluster

# Flags
VLOGAN_FLAGS := -assert svaext
VLOGAN_FLAGS += -assert disable_cover
VLOGAN_FLAGS += -full64
VLOGAN_FLAGS += -kdb
VLOGAN_FLAGS += -timescale=1ns/1ps
VHDLAN_FLAGS := -full64
VHDLAN_FLAGS += -kdb

$(VCS_BUILDDIR)/compile.sh: $(BENDER_LOCK)
	mkdir -p $(VCS_BUILDDIR)
	$(BENDER) script vcs $(VCS_BENDER) --vlog-arg="$(VLOGAN_FLAGS)" --vcom-arg="$(VHDLAN_FLAGS)" > $@
	chmod +x $@
	$(VCS) $@ > $(VCS_BUILDDIR)/compile.log

# Build compilation script and compile all sources for VCS simulation
$(BIN_DIR)/$(TARGET).vcs: $(VCS_SOURCES) $(TB_SRCS) $(TB_CC_SOURCES) $(RTL_CC_SOURCES) $(VCS_BUILDDIR)/compile.sh work/lib/libfesvr.a
	mkdir -p $(BIN_DIR)
	$(VCS) -Mlib=$(VCS_BUILDDIR) -Mdir=$(VCS_BUILDDIR) -o $(BIN_DIR)/$(TARGET).vcs -cc $(CC) -cpp $(CXX) \
		-assert disable_cover -override_timescale=1ns/1ps -full64 tb_bin $(TB_CC_SOURCES) $(RTL_CC_SOURCES) \
		-CFLAGS "$(TB_CC_FLAGS)" -LDFLAGS "-L$(FESVR)/lib" -lfesvr

.PHONY: clean-vcs

# Clean all build directories and temporary files for VCS simulation
clean-vcs: clean-work
	rm -rf $(BIN_DIR)/$(TARGET).vcs $(VCS_BUILDDIR) vc_hdrs.h
