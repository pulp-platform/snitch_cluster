# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

VLT_TOP_MODULE = testharness

# Generate dependency file with RTL sources and headers using Verilator
$(VLT_BUILDDIR)/$(VLT_TOP_MODULE).d: $(BENDER_YML) $(BENDER_LOCK) $(GENERATED_RTL_SOURCES) | $(VLT_BUILDDIR)
	$(VLT) $(shell $(BENDER) script verilator $(VLT_BENDER)) \
		--Mdir $(VLT_BUILDDIR) --MMD -E --top-module $(VLT_TOP_MODULE) > /dev/null
	mv $(VLT_BUILDDIR)/V$(VLT_TOP_MODULE)__ver.d $@
	sed -i 's|^[^:]*:|$(BIN_DIR)/$(TARGET).vlt:|' $@

$(BIN_DIR)/$(TARGET).vlt: $(TB_CC_SOURCES) $(VLT_CC_SOURCES) $(VLT_BUILDDIR)/lib/libfesvr.a | $(BIN_DIR)
	$(VLT) $(shell $(BENDER) script verilator $(VLT_BENDER)) \
		$(VLT_FLAGS) --Mdir $(VLT_BUILDDIR) \
		-CFLAGS "$(VLT_CFLAGS)" \
		-LDFLAGS "$(VLT_LDFLAGS)" \
		-j $(VLT_JOBS) \
		-o ../$@ --cc --exe --build --top-module $(VLT_TOP_MODULE) $(TB_CC_SOURCES) $(VLT_CC_SOURCES)

.PHONY: clean-vlt
clean-vlt: clean-work
	rm -rf $(BIN_DIR)/$(TARGET).vlt $(VLT_BUILDDIR)

clean: clean-vlt

ifneq ($(filter-out clean%,$(MAKECMDGOALS)),)
-include $(VLT_BUILDDIR)/$(VLT_TOP_MODULE).d
endif
