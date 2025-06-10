# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

#############
# Variables #
#############

# Tools
VCS_SEPP ?=
VCS      ?= $(VCS_SEPP) vcs

# VCS_BUILDDIR should be the same as the `DEFAULT : ./work-vcs`
# in target/snitch_cluster/synopsys_sim.setup
VCS_BENDER_FLAGS += $(COMMON_BENDER_FLAGS) $(COMMON_BENDER_SIM_FLAGS) -t vcs
VCS_SOURCES       = $(shell $(BENDER) script flist-plus $(VCS_BENDER_FLAGS) | $(SED_SRCS))

# Directories
VCS_BUILDDIR = $(SN_TARGET_DIR)/work-vcs

# Flags
VLOGAN_FLAGS := -assert svaext
VLOGAN_FLAGS += -assert disable_cover
VLOGAN_FLAGS += -full64
VLOGAN_FLAGS += -kdb
VLOGAN_FLAGS += -timescale=1ns/1ps
VHDLAN_FLAGS := -full64
VHDLAN_FLAGS += -kdb
VCS_FLAGS    += -full64
VCS_FLAGS    += -assert disable_cover
VCS_FLAGS    += -override_timescale=1ns/1ps

# Misc
VCS_TOP_MODULE = tb_bin
VCS_RTL_PREREQ_FILE = $(VCS_BUILDDIR)/$(VCS_TOP_MODULE).d

#########
# Rules #
#########

$(VCS_BUILDDIR):
	mkdir -p $@

# Generate RTL prerequisites
$(eval $(call gen_rtl_prerequisites,$(VCS_RTL_PREREQ_FILE),$(VCS_BUILDDIR),$(VCS_BENDER),$(VCS_TOP_MODULE),$(BIN_DIR)/$(TARGET).vcs))

# Generate compilation script
$(VCS_BUILDDIR)/compile.sh: $(BENDER_YML) $(BENDER_LOCK) | $(VCS_BUILDDIR)
	$(BENDER) script vcs $(VCS_BENDER_FLAGS) --vlog-arg="$(VLOGAN_FLAGS)" --vcom-arg="$(VHDLAN_FLAGS)" > $@
	chmod +x $@

# Run compilation script and create VCS simulation binary
$(SN_BIN_DIR)/$(TARGET).vcs: $(VCS_BUILDDIR)/compile.sh $(TB_CC_SOURCES) $(RTL_CC_SOURCES) work/lib/libfesvr.a | $(SN_BIN_DIR)
	$(VCS_SEPP) $< > $(VCS_BUILDDIR)/compile.log
	$(VCS) -Mlib=$(VCS_BUILDDIR) -Mdir=$(VCS_BUILDDIR) -o $@ -cc $(CC) -cpp $(CXX) \
		$(VCS_FLAGS) $(VCS_TOP_MODULE) $(TB_CC_SOURCES) $(RTL_CC_SOURCES) \
		-CFLAGS "$(TB_CC_FLAGS)" -LDFLAGS "-L$(FESVR)/lib" -lfesvr

.PHONY: vcs clean-vcs

vcs: $(SN_BIN_DIR)/$(TARGET).vcs

# Clean all build directories and temporary files for VCS simulation
clean-vcs: clean-work
	rm -rf $(BIN_DIR)/$(TARGET).vcs $(VCS_BUILDDIR) vc_hdrs.h

clean: clean-vcs

ifneq ($(filter-out clean%,$(MAKECMDGOALS)),)
-include $(VCS_RTL_PREREQ_FILE)
endif
