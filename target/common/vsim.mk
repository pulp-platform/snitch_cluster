# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

VSIM_TOP_MODULE = tb_bin

$(VSIM_BUILDDIR):
	mkdir -p $@

$(VSIM_BUILDDIR)/compile.vsim.tcl: $(BENDER_YML) $(BENDER_LOCK) | $(VSIM_BUILDDIR)
	$(VLIB) $(dir $@)
	$(BENDER) script vsim $(VSIM_BENDER) --vlog-arg="$(VLOG_FLAGS) -work $(dir $@) " > $@
	echo '$(VLOG) -work $(dir $@) $(TB_CC_SOURCES) $(RTL_CC_SOURCES) -vv -ccflags "$(TB_CC_FLAGS)"' >> $@
	echo 'return 0' >> $@

# Intermediate file required to avoid "Argument list too long" errors in Occamy
# when invoking Verilator
$(VSIM_BUILDDIR)/$(TARGET).f: $(BENDER_YML) $(BENDER_LOCK) | $(VSIM_BUILDDIR)
	$(BENDER) script verilator $(VSIM_BENDER) > $@

# Generate dependency file with RTL sources and headers using Verilator
$(VSIM_BUILDDIR)/$(VSIM_TOP_MODULE).d: $(VSIM_BUILDDIR)/$(TARGET).f $(GENERATED_RTL_SOURCES) | $(VSIM_BUILDDIR)
	$(VLT) -f $< --Mdir $(VSIM_BUILDDIR) --MMD -E --top-module $(VSIM_TOP_MODULE) > /dev/null
	mv $(VSIM_BUILDDIR)/V$(VSIM_TOP_MODULE)__ver.d $@
	sed -i 's|^[^:]*:|$(BIN_DIR)/$(TARGET).vsim:|' $@

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
				-ldflags "-Wl,-rpath,$(FESVR)/lib -L$(FESVR)/lib -lfesvr -lutil" \
				$(VSIM_TOP_MODULE)_opt +permissive-off ++$$binary ++$$2' >> $@
	@chmod +x $@
	@echo "#!/bin/bash" > $@.gui
	@echo 'binary=$$(realpath $$1)' >> $@.gui
	@echo 'echo $$binary > .rtlbinary' >> $@.gui
	@echo '$(VSIM) +permissive $(VSIM_FLAGS) -work $(MKFILE_DIR)/$(VSIM_BUILDDIR) \
				-ldflags "-Wl,-rpath,$(FESVR)/lib -L$(FESVR)/lib -lfesvr -lutil" \
				$(VSIM_TOP_MODULE)_opt +permissive-off ++$$binary ++$$2' >> $@.gui
	@chmod +x $@.gui

# Clean all build directories and temporary files for Questasim simulation
.PHONY: clean-vsim
clean-vsim: clean-work
	rm -rf $(BIN_DIR)/$(TARGET).vsim $(BIN_DIR)/$(TARGET).vsim.gui $(VSIM_BUILDDIR) vsim.wlf

clean: clean-vsim

ifneq ($(filter-out clean%,$(MAKECMDGOALS)),)
-include $(VSIM_BUILDDIR)/$(VSIM_TOP_MODULE).d
endif
