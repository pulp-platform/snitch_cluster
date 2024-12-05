# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

$(BIN_DIR)/$(TARGET).gvsoc:
	@echo "#!/bin/bash" > $@
	@echo 'binary=$$(realpath $$1)' >> $@
	@echo 'echo $$binary > .rtlbinary' >> $@
	@echo 'gvsoc --target=snitch --binary $$binary \
	   --control-script=$(GVSOC_BUILDDIR)/pulp/pulp/snitch/utils/gvcontrol.py $$2 run' >> $@
	@chmod +x $@

.PHONY: clean-gvsoc
clean-gvsoc:
	rm -rf $(BIN_DIR)/$(TARGET).gvsoc $(GVSOC_BUILDDIR)

clean: clean-gvsoc
