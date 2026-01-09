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
SN_YOSYS_DIR     = $(SN_ROOT)/target/asic/yosys
SN_YOSYS_OUT     = $(SN_YOSYS_DIR)/out
SN_YOSYS_TMP     = $(SN_YOSYS_DIR)/tmp
SN_YOSYS_REPORTS = $(SN_YOSYS_DIR)/reports

# Inputs
SN_YOSYS_TOP_MODULE = snitch_cluster_wrapper

# Flags
SN_YOSYS_BENDER_DEFINES = VERILATOR SYNTHESIS COMMON_CELLS_ASSERTS_OFF
SN_YOSYS_BENDER_TARGETS = snitch_cluster snitch_cluster_wrapper asic ihp13 rtl synthesis
SN_YOSYS_BENDER_FLAGS   = $(foreach t,$(SN_YOSYS_BENDER_TARGETS),-t $(t)) $(foreach d,$(SN_YOSYS_BENDER_DEFINES),-D $(d)=1)

# Intermediate files
SN_YOSYS_FILELIST        = $(SN_YOSYS_TMP)/snitch.flist
SN_YOSYS_RTL_PREREQ_FILE = $(SN_YOSYS_TMP)/$(SN_YOSYS_TOP_MODULE).d

# Outputs (debug netlist preserves multibit signals)
SN_YOSYS_NETLIST       = $(SN_YOSYS_OUT)/$(SN_YOSYS_TOP_MODULE)_yosys.v
SN_YOSYS_NETLIST_DEBUG = $(SN_YOSYS_OUT)/$(SN_YOSYS_TOP_MODULE)_debug_yosys.v

#########
# Rules #
#########

$(SN_YOSYS_OUT) $(SN_YOSYS_TMP) $(SN_YOSYS_REPORTS):
	mkdir -p $@

# Generate RTL prerequisites
$(eval $(call sn_gen_rtl_prerequisites,$(SN_YOSYS_RTL_PREREQ_FILE),$(SN_YOSYS_TMP),$(SN_YOSYS_BENDER_FLAGS),$(SN_YOSYS_TOP_MODULE),$(SN_YOSYS_NETLIST)))

$(SN_YOSYS_FILELIST): $(SN_BENDER_LOCK) $(SN_BENDER_YML)
	$(SN_BENDER) script flist-plus $(SN_YOSYS_BENDER_FLAGS) > $@
# At the moment we need to filter out `axi_riscv_atomics` from synthesis
# since they cause elaboration issues. They are not used in the design,
# but only in the testbench, which might be the issue here.
	sed -i '/axi_riscv_atomics/d' $@

# Synthesize netlist using Yosys
$(SN_YOSYS_NETLIST) $(SN_YOSYS_NETLIST_DEBUG) &: $(SN_YOSYS_FILELIST) $(SN_YOSYS_RTL_PREREQ_FILE) | $(SN_YOSYS_OUT) $(SN_YOSYS_TMP) $(SN_YOSYS_REPORTS)
	cd $(SN_YOSYS_DIR) && \
	SV_FLIST="$(SN_YOSYS_FILELIST)" \
	TOP_DESIGN="$(SN_YOSYS_TOP_MODULE)" \
	TMP="$(SN_YOSYS_TMP)" \
	OUT="$(SN_YOSYS_OUT)" \
	REPORTS="$(SN_YOSYS_REPORTS)" \
	$(SN_YOSYS) -c $(SN_YOSYS_DIR)/scripts/yosys_synthesis.tcl 2>&1 \
		| TZ=UTC awk '{ print strftime("[%Y-%m-%d %H:%M %Z]"), $$0 }' \
		| tee "$(SN_YOSYS_DIR)/$(SN_YOSYS_TOP_MODULE).log" \
		| awk -f $(SN_YOSYS_DIR)/scripts/filter_output.awk

.PHONY: yosys clean-yosys

yosys: $(SN_YOSYS_NETLIST)

clean-yosys:
	rm -rf $(SN_YOSYS_OUT)
	rm -rf $(SN_YOSYS_TMP)
	rm -rf $(SN_YOSYS_REPORTS)
	rm -f $(SN_YOSYS_DIR)/$(SN_YOSYS_TOP_MODULE).log

clean: clean-yosys

SN_DEPS += $(SN_YOSYS_RTL_PREREQ_FILE)
