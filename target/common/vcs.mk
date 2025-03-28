# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

VCS_TOP_MODULE = tb_bin
VCS_RTL_PREREQ_FILE = $(VCS_BUILDDIR)/$(VCS_TOP_MODULE).d

$(VCS_BUILDDIR):
	mkdir -p $@

# Generate RTL prerequisites
$(eval $(call gen_rtl_prerequisites,$(VCS_RTL_PREREQ_FILE),$(VCS_BUILDDIR),$(VCS_BENDER),$(VCS_TOP_MODULE),$(BIN_DIR)/$(TARGET).vcs))

# Generation compilation script
$(VCS_BUILDDIR)/compile.sh: $(BENDER_YML) $(BENDER_LOCK) | $(VCS_BUILDDIR)
	$(BENDER) script vcs $(VCS_BENDER) --vlog-arg="$(VLOGAN_FLAGS)" --vcom-arg="$(VHDLAN_FLAGS)" > $@
	chmod +x $@

# Run compilation script and create VCS simulation binary
$(BIN_DIR)/$(TARGET).vcs: $(VCS_BUILDDIR)/compile.sh $(TB_CC_SOURCES) $(RTL_CC_SOURCES) work/lib/libfesvr.a | $(BIN_DIR)
	$(VCS_SEPP) $< > $(VCS_BUILDDIR)/compile.log
	$(VCS) -Mlib=$(VCS_BUILDDIR) -Mdir=$(VCS_BUILDDIR) -o $@ -cc $(CC) -cpp $(CXX) \
		-assert disable_cover -override_timescale=1ns/1ps -full64 $(VCS_TOP_MODULE) $(TB_CC_SOURCES) $(RTL_CC_SOURCES) \
		-CFLAGS "$(TB_CC_FLAGS)" -LDFLAGS "-L$(FESVR)/lib" -lfesvr

# Clean all build directories and temporary files for VCS simulation
.PHONY: clean-vcs
clean-vcs: clean-work
	rm -rf $(BIN_DIR)/$(TARGET).vcs $(VCS_BUILDDIR) vc_hdrs.h

clean: clean-vcs

ifneq ($(filter-out clean%,$(MAKECMDGOALS)),)
-include $(VCS_RTL_PREREQ_FILE)
endif
