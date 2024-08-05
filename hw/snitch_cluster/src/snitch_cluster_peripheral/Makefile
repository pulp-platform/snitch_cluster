# Copyright 2021 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51
#
# Noah Huetter <huettern@iis.ee.ethz.ch>

BENDER?=bender
REGTOOL=$(shell $(BENDER) path register_interface)/vendor/lowrisc_opentitan/util/regtool.py
PYTHON3=$(shell which python)

SCHEMA=snitch_cluster_peripheral_reg.hjson

PKG=snitch_cluster_peripheral_reg_pkg.sv
TOP=snitch_cluster_peripheral_reg_top.sv

all: $(PKG) $(TOP)

$(PKG): $(SCHEMA)
	$(PYTHON3) $(REGTOOL) -r -t $(dir $@) $<
$(TOP): $(SCHEMA)
	$(PYTHON3) $(REGTOOL) -r -t $(dir $@) $<
