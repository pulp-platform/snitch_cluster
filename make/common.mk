# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

#############
# Variables #
#############

# Directories
SN_CFG_DIR   ?= $(SN_ROOT)/cfg
SN_SIM_DIR   ?= $(SN_ROOT)/test
SN_TB_DIR    ?= $(SN_ROOT)/target/sim/tb
SN_UTIL_DIR  ?= $(SN_ROOT)/util
SN_LOGS_DIR   = $(SN_SIM_DIR)/logs
SN_PERIPH_DIR = $(SN_ROOT)/hw/snitch_cluster/src/snitch_cluster_peripheral
SN_TARGET_DIR = $(SN_ROOT)/target
SN_GEN_DIR   ?= $(SN_ROOT)/hw/generated
SN_HW_DIR     = $(SN_ROOT)/hw
SN_BIN_DIR    = $(SN_TARGET_DIR)/sim/build/bin
SN_WORK_DIR   = $(SN_TARGET_DIR)/sim/build/work

# External executables
SN_BENDER	      ?= bender
SN_PEAKRDL        ?= peakrdl
SN_VERIBLE_FMT    ?= verible-verilog-format
SN_CLANG_FORMAT   ?= clang-format
SN_RISCV_MC       ?= $(SN_LLVM_BINROOT)/llvm-mc
SN_ADDR2LINE      ?= $(SN_LLVM_BINROOT)/llvm-addr2line
# tail is required for nonsense oseda output
SN_VERILATOR_SEPP ?=
SN_VLT_BIN         = $(shell $(SN_VERILATOR_SEPP) which verilator_bin | tail -n1 | $(SN_VERILATOR_SEPP) xargs realpath | tail -n1)
SN_VLT            ?= $(SN_VERILATOR_SEPP) verilator

# Internal executables
SN_GENTRACE_PY  ?= $(SN_UTIL_DIR)/trace/gen_trace.py
SN_ANNOTATE_PY  ?= $(SN_UTIL_DIR)/trace/annotate.py
SN_EVENTS_PY    ?= $(SN_UTIL_DIR)/trace/events.py
SN_JOIN_PY      ?= $(SN_UTIL_DIR)/bench/join.py
SN_ROI_PY       ?= $(SN_UTIL_DIR)/bench/roi.py
SN_VISUALIZE_PY ?= $(SN_UTIL_DIR)/bench/visualize.py
SN_BOOTROM_GEN   = $(SN_ROOT)/util/clustergen/gen_bootrom.py
SN_CLUSTER_GEN   = $(SN_ROOT)/util/clustergen/clustergen.py

# Gentrace prerequisites
SN_GENTRACE_SRC = $(SN_UTIL_DIR)/trace/sequencer.py

# Annotate prerequisites
SN_ANNOTATE_SRC = $(SN_UTIL_DIR)/trace/a2l.py

# Clustergen prerequisites
SN_CLUSTER_GEN_SRC = $(SN_ROOT)/util/clustergen/cluster.py

# Bender prerequisites
SN_BENDER_LOCK = $(SN_ROOT)/Bender.lock
SN_BENDER_YML  = $(SN_ROOT)/Bender.yml

# Flags
SN_COMMON_BENDER_FLAGS     += -t rtl -t snitch_cluster
SN_COMMON_BENDER_SIM_FLAGS += -t simulation -t test
SN_RISCV_MC_FLAGS          ?= -disassemble -mcpu=snitch
SN_ANNOTATE_FLAGS          ?= -q --keep-time --addr2line=$(SN_ADDR2LINE)
SN_LAYOUT_EVENTS_FLAGS     ?= --cfg=$(SN_CFG)

# Internal state
SN_DEPS :=

#################
# Prerequisites #
#################

$(SN_GEN_DIR) $(SN_BIN_DIR) $(SN_WORK_DIR):
	mkdir -p $@

#############
# Utilities #
#############

# Normalizes a directory name by removing the trailing slash, if any.
# Use to ensure that dependencies and targets are consistently specified.
define sn_normalize_dir
$(patsubst %/,%,$(1))
endef

# Common rule to generate C header with peakRDL
# $1: target name, $2: prerequisite (rdl description file), $3 (optional) additional peakRDL flags
define sn_peakrdl_generate_header_rule
$(1): $(2) | $(call sn_normalize_dir,$(dir $(1)))
	@echo "[peakRDL] Generating $$@"
	$(SN_PEAKRDL) c-header $$< -o $$@ -i -b ltoh $(3)
	@$(SN_CLANG_FORMAT) -i $$@
endef

# Common rule to fill a template file with clustergen
# Arg 1: path for the generated file
# Arg 2: path of the template file
define sn_cluster_gen_rule
$(1): $(SN_CFG) $(SN_CLUSTER_GEN) $(SN_CLUSTER_GEN_SRC) $(2) | $(call sn_normalize_dir,$(dir $(1)))
	@echo "[CLUSTERGEN] Generate $$@"
	$(SN_CLUSTER_GEN) -c $$< -o $$@ --template $(2)
endef

# Common rule to generate a Makefile with RTL source and header
# files listed as prerequisites for a given target.
# Generates also an intermediate file list to avoid "Argument list too long"
# errors when invoking Verilator with a large number of files.
# Arg 1: path for the generated file
# Arg 2: path to directory storing intermediate files
# Arg 3: bender arguments
# Arg 4: top module name
# Arg 5: name of target for which prerequisites are generated
define sn_gen_rtl_prerequisites
$(2)/$(4).f: $(SN_BENDER_YML) $(SN_BENDER_LOCK) | $(2)
	$(SN_BENDER) script verilator $(3) > $$@

$(1): $(2)/$(4).f $(SN_GEN_RTL_SRCS) | $(2)
	$(SN_VLT) -f $$< --Mdir $(2) --MMD -E --top-module $(4) > /dev/null
	mv $(2)/V$(4)__ver.d $$@
	sed -E -i -e 's|^[^:]*:|$(5):|' \
	    -e ':a; s/(^|[[:space:]])$(subst /,\/,$(SN_VLT_BIN))($|[[:space:]])/\1\2/g; ta' $$@
endef

# Common function to conditionally include dependency files, only when a target
# which actually depends on a certain file is executed on the command-line.
# Avoids time-consuming generation of dependency files until strictly needed.
# Usage:
#   $(call sn_include_deps)
define sn_include_deps
$(eval $(if $(strip $(MAKECMDGOALS)),$(shell list-dependent-make-targets -M -r $(SN_DEPS))))
endef
