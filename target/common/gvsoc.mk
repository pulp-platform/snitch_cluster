# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

GVSOC_BUILDDIR ?= work-gvsoc

$(BIN_DIR)/$(TARGET).gvsoc:
	@echo "#!/bin/bash" > $@
	@echo 'binary=$$(realpath $$1)' >> $@
	@echo 'echo $$binary > .rtlbinary' >> $@
	@echo 'path="$$(dirname "$$(dirname "$$(readlink -f "$${BASH_SOURCE[0]}")")")"' >> $@
	@echo 'if [ -z "$$GVSOC_TARGET" ]; then' >> $@
	@echo '    GVSOC_TARGET=snitch' >> $@
	@echo 'fi' >> $@
	@echo 'gvsoc --target=$${GVSOC_TARGET} --binary $$binary \
	   --control-script=$${path}/../../util/sim/gvsoc_control.py $$2 run' >> $@
	@chmod +x $@

.PHONY: clean-gvsoc
clean-gvsoc:
	rm -rf $(BIN_DIR)/$(TARGET).gvsoc $(GVSOC_BUILDDIR)

clean: clean-gvsoc
