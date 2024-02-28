# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

###############
# Executables #
###############

BENDER ?= bender
REGGEN  = $(shell $(BENDER) path register_interface)/vendor/lowrisc_opentitan/util/regtool.py

#########################
# Files and directories #
#########################

ROOT = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

#######################
# Global Make targets #
#######################

.PHONY: all
.PHONY: clean

############
# Non-free #
############

NONFREE_REMOTE ?= git@iis-git.ee.ethz.ch:pulp-restricted/snitch-cluster-nonfree.git
NONFREE_COMMIT ?= e30961e20a23a76442da27d2ba07c9fe20f3b575
NONFREE_DIR = $(ROOT)/nonfree

all: nonfree
clean: clean-nonfree
.PHONY: nonfree clean-nonfree

nonfree: $(NONFREE_DIR)

$(NONFREE_DIR):
	git clone $(NONFREE_REMOTE) $(NONFREE_DIR)
	cd $(NONFREE_DIR) && git checkout $(NONFREE_COMMIT)

clean-nonfree:
	rm -rf $(NONFREE_DIR)

-include $(NONFREE_DIR)/Makefile

########
# Docs #
########

GENERATED_DOCS_DIR = docs/generated
GENERATED_DOC_SRCS = $(GENERATED_DOCS_DIR)/peripherals.md

all: docs
clean: clean-docs
.PHONY: doc-srcs docs clean-docs

doc-srcs: $(GENERATED_DOC_SRCS)

docs: doc-srcs
	mkdocs build

clean-docs:
	rm -rf $(GENERATED_DOCS_DIR)

$(GENERATED_DOCS_DIR):
	mkdir -p $@

$(GENERATED_DOCS_DIR)/peripherals.md: hw/snitch_cluster/src/snitch_cluster_peripheral/snitch_cluster_peripheral_reg.hjson | $(GENERATED_DOCS_DIR)
	$(REGGEN) -d $< > $@
