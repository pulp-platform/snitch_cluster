# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

VSIM_TOP_MODULE = tb_bin
VSIM_RTL_PREREQ_FILE = $(VSIM_BUILDDIR)/$(VSIM_TOP_MODULE).d

$(VSIM_BUILDDIR):
	mkdir -p $@

# Generate RTL prerequisites
$(eval $(call gen_rtl_prerequisites,$(VSIM_RTL_PREREQ_FILE),$(VSIM_BUILDDIR),$(VSIM_BENDER),$(VSIM_TOP_MODULE),$(BIN_DIR)/$(TARGET).vsim))

# Generation compilation script
$(VSIM_BUILDDIR)/compile.vsim.tcl: $(BENDER_YML) $(BENDER_LOCK) | $(VSIM_BUILDDIR)
	$(VLIB) $(dir $@)
	$(BENDER) script vsim $(VSIM_BENDER) --vlog-arg="$(VLOG_FLAGS) -work $(dir $@) " > $@
	echo '$(VLOG) -work $(dir $@) $(TB_CC_SOURCES) $(RTL_CC_SOURCES) -vv -ccflags "$(TB_CC_FLAGS)"' >> $@
	echo 'return 0' >> $@

# Run compilation script and create Questasim simulation binary
$(BIN_DIR)/$(TARGET).vsim: $(VSIM_BUILDDIR)/compile.vsim.tcl $(TB_CC_SOURCES) $(RTL_CC_SOURCES) work/lib/libfesvr.a | $(BIN_DIR)
	$(VSIM) -c -do "source $<; quit" | tee $(dir $<)vlog.log
	@! grep -P "Errors: [1-9]*," $(dir $<)vlog.log
	$(VOPT) $(VOPT_FLAGS) -work $(VSIM_BUILDDIR) $(VSIM_TOP_MODULE) -o $(VSIM_TOP_MODULE)_opt | tee $(dir $<)vopt.log
	@! grep -P "Errors: [1-9]*," $(dir $<)vopt.log
	@echo "#!/bin/bash" > $@
	@echo 'binary=$$(realpath $$1)' >> $@
	@echo 'echo $$binary > .rtlbinary' >> $@
	@echo '$(VSIM) +permissive $(VSIM_FLAGS) $$3 -work $(MKFILE_DIR)/$(VSIM_BUILDDIR) -c \
				-quiet -ldflags "-Wl,-rpath,$(FESVR)/lib -L$(FESVR)/lib -lfesvr -lutil" \
				$(VSIM_TOP_MODULE)_opt +permissive-off ++$$binary ++$$2' >> $@
	@chmod +x $@
	@echo "#!/bin/bash" > $@.gui
	@echo 'binary=$$(realpath $$1)' >> $@.gui
	@echo 'echo $$binary > .rtlbinary' >> $@.gui
	@echo '$(VSIM) +permissive $(VSIM_FLAGS) -work $(MKFILE_DIR)/$(VSIM_BUILDDIR) \
				-quiet -ldflags "-Wl,-rpath,$(FESVR)/lib -L$(FESVR)/lib -lfesvr -lutil" \
				$(VSIM_TOP_MODULE)_opt +permissive-off ++$$binary ++$$2' >> $@.gui
	@chmod +x $@.gui

# Clean all build directories and temporary files for Questasim simulation
.PHONY: clean-vsim
clean-vsim: clean-work
	rm -rf $(BIN_DIR)/$(TARGET).vsim $(BIN_DIR)/$(TARGET).vsim.gui $(VSIM_BUILDDIR) vsim.wlf

clean: clean-vsim

ifneq ($(filter-out clean%,$(MAKECMDGOALS)),)
-include $(VSIM_RTL_PREREQ_FILE)
endif
