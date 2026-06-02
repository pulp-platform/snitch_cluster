# Copyright 2026 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

set PROJECT snitch_cluster_wrapper

new_project ${PROJECT} -force
current_methodology $env(SPYGLASS_HOME)/GuideWare/latest/block/rtl_handoff

# Read the RTL
read_file -type sourcelist analyze.tcl

set_option top ${PROJECT}
set_option enableSV09 yes
set_option allow_module_override yes
set_option designread_disable_flatten no
set_option nopreserve yes
set_parameter handle_large_bus yes

# Do not elaborate non-synthesizable modules
set_option stop sram
set_option stop sim_dram
set_option stop bus_err_unit_bare
set_option stop tc_sram
set_option stop tc_sram_impl

# Waive unused macro warnings for macros created implictly by bender
waive -rules CMD_define02 -msg "*TARGET_FLIST*"
waive -rules CMD_define02 -msg "*TARGET_RTL*"
waive -rules CMD_define02 -msg "*TARGET_SNITCH_CLUSTER*"
waive -rules CMD_define02 -msg "*TARGET_SNITCH_CLUSTER_WRAPPER*"

compile_design
run_goal -goal lint/lint_rtl

exit -force
