# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

#############
# Variables #
#############

# Tools
SN_VCS_SEPP ?=
SN_VCS      ?= $(SN_VCS_SEPP) vcs

# Directories
# SN_VCS_BUILDDIR should be the same as the `DEFAULT : ./work-vcs`
# in target/sim/synopsys_sim.setup
SN_VCS_BUILDDIR = $(SN_TARGET_DIR)/sim/build/work-vcs

# Flags
SN_VCS_BENDER_FLAGS += $(SN_COMMON_BENDER_FLAGS) $(SN_COMMON_BENDER_SIM_FLAGS) -t vcs
SN_VLOGAN_FLAGS := -assert svaext
SN_VLOGAN_FLAGS += -assert disable_cover
SN_VLOGAN_FLAGS += -full64
SN_VLOGAN_FLAGS += -kdb
SN_VLOGAN_FLAGS += -timescale=1ns/1ps
SN_VHDLAN_FLAGS := -full64
SN_VHDLAN_FLAGS += -kdb
SN_VCS_FLAGS    += -full64
SN_VCS_FLAGS    += -assert disable_cover
SN_VCS_FLAGS    += -override_timescale=1ns/1ps

# Misc
SN_VCS_TOP_MODULE = tb_bin
SN_VCS_RTL_PREREQ_FILE = $(SN_VCS_BUILDDIR)/$(SN_VCS_TOP_MODULE).d

#########
# Rules #
#########

$(SN_VCS_BUILDDIR):
	mkdir -p $@

# Generate RTL prerequisites
$(eval $(call sn_gen_rtl_prerequisites,$(SN_VCS_RTL_PREREQ_FILE),$(SN_VCS_BUILDDIR),$(SN_VCS_BENDER_FLAGS),$(SN_VCS_TOP_MODULE),$(SN_BIN_DIR)/$(TARGET).vcs))

# Generate compilation script
$(SN_VCS_BUILDDIR)/compile.sh: $(SN_BENDER_YML) $(SN_BENDER_LOCK) | $(SN_VCS_BUILDDIR)
	$(SN_BENDER) script vcs $(SN_VCS_BENDER_FLAGS) --vlog-arg="$(SN_VLOGAN_FLAGS)" --vcom-arg="$(SN_VHDLAN_FLAGS)" > $@
	chmod +x $@

# Run compilation script and create VCS simulation binary
$(SN_BIN_DIR)/$(TARGET).vcs: $(SN_VCS_BUILDDIR)/compile.sh $(SN_TB_CC_SOURCES) $(SN_RTL_CC_SOURCES) $(SN_WORK_DIR)/lib/libfesvr.a $(SN_VCS_RTL_PREREQ_FILE) | $(SN_BIN_DIR)
	$(SN_VCS_SEPP) $< > $(SN_VCS_BUILDDIR)/compile.log
	$(SN_VCS) -Mlib=$(SN_VCS_BUILDDIR) -Mdir=$(SN_VCS_BUILDDIR) -o $@ -cc $(CC) -cpp $(CXX) \
		$(SN_VCS_FLAGS) $(SN_VCS_TOP_MODULE) $(SN_TB_CC_SOURCES) $(SN_RTL_CC_SOURCES) \
		-CFLAGS "$(SN_TB_CC_FLAGS)" -LDFLAGS "-L$(SN_FESVR)/lib" -lfesvr

.PHONY: vcs clean-vcs

vcs: $(SN_BIN_DIR)/$(TARGET).vcs

# Clean all build directories and temporary files for VCS simulation
clean-vcs: clean-work
	rm -rf $(SN_BIN_DIR)/$(TARGET).vcs $(SN_VCS_BUILDDIR) vc_hdrs.h

clean: clean-vcs

SN_DEPS += $(SN_VCS_RTL_PREREQ_FILE)
