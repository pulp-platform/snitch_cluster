# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

$(BIN_DIR)/$(TARGET).vlt: $(VLT_SOURCES) $(TB_CC_SOURCES) $(VLT_CC_SOURCES) $(VLT_BUILDDIR)/lib/libfesvr.a | $(BIN_DIR)
	$(VLT) $(shell $(BENDER) script verilator $(VLT_BENDER)) \
		$(VLT_FLAGS) -Mdir $(VLT_BUILDDIR) \
		-CFLAGS "$(VLT_CFLAGS)" \
		-LDFLAGS "$(VLT_LDFLAGS)" \
		-j $(VLT_JOBS) \
		-o ../$@ --cc --exe --build --top-module testharness $(TB_CC_SOURCES) $(VLT_CC_SOURCES)

.PHONY: clean-vlt
clean-vlt: clean-work
	rm -rf $(BIN_DIR)/$(TARGET).vlt $(VLT_BUILDDIR)

clean: clean-vlt
