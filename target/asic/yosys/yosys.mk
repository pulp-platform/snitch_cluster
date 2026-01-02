# Copyright (c) 2025 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Authors:
# - Philippe Sauter <phsauter@iis.ee.ethz.ch>
# - Luca Colagrande <colluca@iis.ee.ethz.ch>

#############
# Variables #
#############

# Tools
SN_YOSYS ?= yosys

# Directories
YOSYS_DIR     = $(SN_ROOT)/target/asic/yosys
YOSYS_OUT     = $(YOSYS_DIR)/out
YOSYS_TMP     = $(YOSYS_DIR)/tmp
YOSYS_REPORTS = $(YOSYS_DIR)/reports
PROJ_DIR      = $(SN_ROOT)/target/asic

# top level to be synthesized
TOP_DESIGN		?= snitch_cluster_wrapper

# file containing include dirs, defines and paths to all source files
SV_FLIST    	:= $(PROJ_DIR)/snitch.flist

# path to the resulting netlists (debug preserves multibit signals)
NETLIST			:= $(YOSYS_OUT)/$(TOP_DESIGN)_yosys.v
NETLIST_DEBUG	:= $(YOSYS_OUT)/$(TOP_DESIGN)_debug_yosys.v
SV_DEFINES     ?= VERILATOR SYNTHESIS COMMON_CELLS_ASSERTS_OFF
BENDER_TARGETS ?= snitch_cluster snitch_cluster_wrapper asic ihp13 rtl synthesis
BENDER_FLAGS    = $(foreach t,$(BENDER_TARGETS),-t $(t)) $(foreach d,$(SV_DEFINES),-D $(d)=1)

# Misc
SN_YOSYS_RTL_PREREQ_FILE = $(YOSYS_TMP)/$(TOP_DESIGN).d

#########
# Rules #
#########

# Generate RTL prerequisites
$(eval $(call sn_gen_rtl_prerequisites,$(SN_YOSYS_RTL_PREREQ_FILE),$(YOSYS_TMP),$(BENDER_FLAGS),$(TOP_DESIGN),$(NETLIST)))

$(SV_FLIST): $(SN_BENDER_LOCK) $(SN_BENDER_YML)
	$(SN_BENDER) script flist-plus $(BENDER_FLAGS) > $@

# Synthesize netlist using Yosys
$(NETLIST) $(NETLIST_DEBUG): $(SV_FLIST) $(SN_YOSYS_RTL_PREREQ_FILE)
	@mkdir -p $(YOSYS_OUT)
	@mkdir -p $(YOSYS_TMP)
	@mkdir -p $(YOSYS_REPORTS)
	cd $(YOSYS_DIR) && \
	SV_FLIST="$(SV_FLIST)" \
	TOP_DESIGN="$(TOP_DESIGN)" \
	TMP="$(YOSYS_TMP)" \
	OUT="$(YOSYS_OUT)" \
	REPORTS="$(YOSYS_REPORTS)" \
	$(SN_YOSYS) -c $(YOSYS_DIR)/scripts/yosys_synthesis.tcl 2>&1 \
		| TZ=UTC awk '{ print strftime("[%Y-%m-%d %H:%M %Z]"), $$0 }' \
		| tee "$(YOSYS_DIR)/$(TOP_DESIGN).log" \
		| awk -f $(YOSYS_DIR)/scripts/filter_output.awk

.PHONY: yosys clean-yosys

yosys: $(NETLIST)

clean-yosys:
	rm -rf $(YOSYS_OUT)
	rm -rf $(YOSYS_TMP)
	rm -rf $(YOSYS_REPORTS) 
	rm -f $(YOSYS_DIR)/$(TOP_DESIGN).log
	rm -f $(SV_FLIST)

clean: clean-yosys

SN_DEPS += $(SN_YOSYS_RTL_PREREQ_FILE)
