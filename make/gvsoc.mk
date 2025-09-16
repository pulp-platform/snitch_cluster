# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

SN_GVSOC_BUILDDIR ?= $(SN_TARGET_DIR)/sim/build/work-gvsoc

$(SN_BIN_DIR)/$(TARGET).gvsoc:
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

.PHONY: sn-clean-gvsoc
sn-clean-gvsoc:
	rm -rf $(SN_BIN_DIR)/$(TARGET).gvsoc $(SN_GVSOC_BUILDDIR)

sn-clean: sn-clean-gvsoc
