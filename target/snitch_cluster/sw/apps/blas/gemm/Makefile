# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Tim Fischer <fischeti@iis.ee.ethz.ch>

include ../../../../../../sw/blas/gemm/Makefile
include ../../common.mk

$(DEP): $(DATA_H)

# Add test target to the Makefile
.PHONY: test
test:
	./test/run.sh $(CFG_PATTERN) $(YAML_FILE)