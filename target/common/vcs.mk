# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

VCS_TOP_MODULE = tb_bin

$(VCS_BUILDDIR):
	mkdir -p $@

$(VCS_BUILDDIR)/compile.sh: $(BENDER_YML) $(BENDER_LOCK) | $(VCS_BUILDDIR)
	$(BENDER) script vcs $(VCS_BENDER) --vlog-arg="$(VLOGAN_FLAGS)" --vcom-arg="$(VHDLAN_FLAGS)" > $@
	chmod +x $@

# Generate dependency file with RTL sources and headers using Verilator
$(VCS_BUILDDIR)/$(VCS_TOP_MODULE).d: $(BENDER_YML) $(BENDER_LOCK) $(GENERATED_RTL_SOURCES) | $(VCS_BUILDDIR)
	$(VLT) $(shell $(BENDER) script verilator $(VCS_BENDER)) \
		--Mdir $(VCS_BUILDDIR) --MMD -E --top-module $(VCS_TOP_MODULE) > /dev/null
	mv $(VCS_BUILDDIR)/V$(VCS_TOP_MODULE)__ver.d $@
	sed -i 's|^[^:]*:|$(BIN_DIR)/$(TARGET).vcs:|' $@

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
-include $(VCS_BUILDDIR)/$(VCS_TOP_MODULE).d
endif
