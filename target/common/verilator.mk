# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

VLT_TOP_MODULE = testharness
VLT_RTL_PREREQ_FILE = $(VLT_BUILDDIR)/$(VLT_TOP_MODULE).d

$(VLT_BUILDDIR):
	mkdir -p $@

# Generate RTL prerequisites
$(eval $(call gen_rtl_prerequisites,$(VLT_RTL_PREREQ_FILE),$(VLT_BUILDDIR),$(VLT_BENDER),$(VLT_TOP_MODULE),$(BIN_DIR)/$(TARGET).vlt))

# This target just redirects the verilator simulation binary.
# On IIS machines, verilator needs to be built and run in
# the oseda environment, which is why this is necessary.
$(BIN_DIR)/$(TARGET).vlt: $(BIN_DIR)/$(TARGET)_bin.vlt
	@echo "#!/bin/bash" > $@
	@echo '$(VERILATOR_SEPP) $(realpath $<) $$(realpath $$1) $$2' >> $@
	@chmod +x $@

$(BIN_DIR)/$(TARGET)_bin.vlt: $(TB_CC_SOURCES) $(VLT_CC_SOURCES) $(VLT_BUILDDIR)/lib/libfesvr.a | $(BIN_DIR)
	$(VLT) $(shell $(BENDER) script verilator $(VLT_BENDER)) \
		$(VLT_FLAGS) --Mdir $(VLT_BUILDDIR) \
		-CFLAGS -std=c++20 \
		-CFLAGS -I$(VLT_FESVR)/include \
		-CFLAGS -I$(TB_DIR) \
		-CFLAGS -I$(MKFILE_DIR)test \
		-j $(VLT_JOBS) \
		-o ../$@ --cc --exe --build --top-module $(VLT_TOP_MODULE) \
		$(TB_CC_SOURCES) $(VLT_CC_SOURCES) $(VLT_BUILDDIR)/lib/libfesvr.a

.PHONY: clean-vlt
clean-vlt: clean-work
	rm -rf $(BIN_DIR)/$(TARGET).vlt $(BIN_DIR)/$(TARGET)_bin.vlt $(VLT_BUILDDIR)

clean: clean-vlt

ifneq ($(filter-out clean%,$(MAKECMDGOALS)),)
-include $(VLT_RTL_PREREQ_FILE)
endif
