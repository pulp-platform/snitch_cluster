# Copyright 2020 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51
#
# Fabian Schuiki <fschuiki@iis.ee.ethz.ch>
# Florian Zaruba <zarubaf@iis.ee.ethz.ch>

#######################
# Makefile invocation #
#######################

# ON to turn on debugging symbols and wave logging
DEBUG ?= OFF
# Override default config file
CFG_OVERRIDE ?=

.DEFAULT_GOAL := help
.PHONY: all clean
all: rtl sw
clean: clean-rtl clean-work clean-logs clean-bender clean-generated

##########
# Common #
##########

MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MKFILE_DIR  := $(dir $(MKFILE_PATH))
ROOT        := $(realpath ${MKFILE_DIR}../..)
SNITCH_ROOT := $(ROOT)

TARGET = snitch_cluster

include $(ROOT)/target/common/common.mk

############
# Programs #
############

REGGEN          ?= $(shell $(BENDER) path register_interface)/vendor/lowrisc_opentitan/util/regtool.py
CLUSTER_GEN     ?= $(ROOT)/util/clustergen.py
BOOTROM_GEN     ?= $(ROOT)/util/gen_bootrom.py
CLUSTER_GEN_SRC ?= $(wildcard $(ROOT)/util/clustergen/*.py)

#########################
# Files and directories #
#########################

BIN_DIR           ?= bin
GENERATED_DIR     ?= $(MKFILE_DIR)generated
TEST_DIR          ?= $(MKFILE_DIR)test
PERIPH_DIR        ?= $(ROOT)/hw/snitch_cluster/src/snitch_cluster_peripheral

# If the configuration file is overriden on the command-line (through
# CFG_OVERRIDE) and this file differs from the least recently used
# (LRU) config, all targets depending on the configuration file have
# to be rebuilt. This file is used to express this condition as a
# prerequisite for other rules.
DEFAULT_CFG = cfg/default.json
CFG         = cfg/lru.json

# Common dependency for all RTL simulators
$(BIN_DIR):
	mkdir -p $@

#####################
# Simulator options #
#####################

COMMON_BENDER_FLAGS += -t snitch_cluster_wrapper

QUESTA_64BIT = -64
VLOG_64BIT   = -64

VSIM_FLAGS += ${QUESTA_64BIT}

VLOG_FLAGS += -svinputport=compat
VLOG_FLAGS += -override_timescale 1ns/1ps
VLOG_FLAGS += -suppress 2583
VLOG_FLAGS += -suppress 13314
VLOG_FLAGS += ${VLOG_64BIT}

###############
# C testbench #
###############

TB_CC_SOURCES += \
	${TB_DIR}/ipc.cc \
	${TB_DIR}/common_lib.cc \
	$(GENERATED_DIR)/bootdata.cc

RTL_CC_SOURCES += ${TB_DIR}/rtl_lib.cc

VLT_CC_SOURCES += \
	${TB_DIR}/verilator_lib.cc \
	${TB_DIR}/tb_bin.cc

TB_CC_FLAGS += \
	-std=c++14 \
	-I${MKFILE_DIR}/test \
	-I${FESVR}/include \
	-I${TB_DIR}

#################
# Prerequisites #
#################

CLUSTER_GEN_PREREQ = ${CLUSTER_GEN} ${CLUSTER_GEN_SRC}

# This target is always evaluated and creates a symlink to the least
# recently used config file. Because it is a symlink, targets to which it is a
# prerequisite will only be updated if the symlink target is newer than the
# depending targets, regardless of the symlink timestamp itself. The symlink
# timestamp can be taken into account by using the `make -L` flag on the
# command-line, however for simplicity we touch the symlink targets so it can
# be used without.
$(CFG): FORCE
	@# If the LRU config file doesn't exist, we use the default config.
	@if [ ! -e "$@" ] ; then \
		echo "Using default config file: $(DEFAULT_CFG)"; \
		ln -s --relative $(DEFAULT_CFG) $@; \
		touch $(DEFAULT_CFG); \
	fi
	@# If a config file is provided on the command-line and the LRU
	@# config file doesn't point to it already, then we make it point to it
	@if [ $(CFG_OVERRIDE) ] ; then \
		echo "Overriding config file with: $(CFG_OVERRIDE)"; \
		target=$$(readlink -f $@); \
		if [ "$$target" = "$(abspath $(CFG_OVERRIDE))" ] ; then \
			echo "LRU config file already points to $(CFG_OVERRIDE). Nothing to be done."; \
		else \
			rm -f $@; \
			ln -s --relative $(CFG_OVERRIDE) $@; \
			touch $(CFG_OVERRIDE); \
		fi \
	fi
FORCE:

############
# Software #
############

include $(ROOT)/target/snitch_cluster/sw.mk

#######
# RTL #
#######

GENERATED_RTL_SOURCES  = $(PERIPH_DIR)/snitch_cluster_peripheral_reg_top.sv
GENERATED_RTL_SOURCES += $(PERIPH_DIR)/snitch_cluster_peripheral_reg_pkg.sv
GENERATED_RTL_SOURCES += $(GENERATED_DIR)/snitch_cluster_wrapper.sv
GENERATED_RTL_SOURCES += $(GENERATED_DIR)/snitch_cluster_pkg.sv
GENERATED_RTL_SOURCES += $(TEST_DIR)/snitch_bootrom.sv

.PHONY: rtl clean-rtl

rtl: $(GENERATED_RTL_SOURCES)

clean-rtl:
	rm -f $(GENERATED_RTL_SOURCES)

$(GENERATED_DIR):
	mkdir -p $@

CLUSTER_WRAPPER_TPL = $(ROOT)/hw/snitch_cluster/src/snitch_cluster_wrapper.sv.tpl
CLUSTER_PKG_TPL     = $(ROOT)/hw/snitch_cluster/src/snitch_cluster_pkg.sv.tpl
LINK_LD_TPL         = $(ROOT)/hw/snitch_cluster/test/link.ld.tpl
BOOTDATA_TPL        = $(ROOT)/hw/snitch_cluster/test/bootdata.cc.tpl

# OCCAMYGEN artifacts
$(eval $(call cluster_gen_rule,$(GENERATED_DIR)/snitch_cluster_wrapper.sv,$(CLUSTER_WRAPPER_TPL)))
$(eval $(call cluster_gen_rule,$(GENERATED_DIR)/snitch_cluster_pkg.sv,$(CLUSTER_PKG_TPL)))
$(eval $(call cluster_gen_rule,$(GENERATED_DIR)/link.ld,$(LINK_LD_TPL)))
$(eval $(call cluster_gen_rule,$(GENERATED_DIR)/bootdata.cc,$(BOOTDATA_TPL)))

# REGGEN regfile
$(PERIPH_DIR)/snitch_cluster_peripheral_reg_pkg.sv: $(PERIPH_DIR)/snitch_cluster_peripheral_reg_top.sv
$(PERIPH_DIR)/snitch_cluster_peripheral_reg_top.sv: $(PERIPH_DIR)/snitch_cluster_peripheral_reg.hjson
	@echo "[REGGEN] Generating peripheral regfile"
	$(REGGEN) -r -t $(PERIPH_DIR) $<

# Bootrom
.PHONY: bootrom
bootrom: $(TEST_DIR)/snitch_bootrom.sv
$(TEST_DIR)/bootrom.elf $(TEST_DIR)/bootrom.dump $(TEST_DIR)/bootrom.bin $(TEST_DIR)/snitch_bootrom.sv: $(TEST_DIR)/bootrom.S $(TEST_DIR)/bootrom.ld $(BOOTROM_GEN)
	$(RISCV_CC) -mabi=ilp32d -march=rv32imafd -static -nostartfiles -fuse-ld=$(RISCV_LD) -Lsw/runtime -T$(TEST_DIR)/bootrom.ld $< -o $(TEST_DIR)/bootrom.elf
	$(RISCV_OBJDUMP) -d $(TEST_DIR)/bootrom.elf > $(TEST_DIR)/bootrom.dump
	$(RISCV_OBJCOPY) -j .text -O binary $(TEST_DIR)/bootrom.elf $(TEST_DIR)/bootrom.bin
	$(BOOTROM_GEN) --sv-module snitch_bootrom $(TEST_DIR)/bootrom.bin > $(TEST_DIR)/snitch_bootrom.sv

#############
# Verilator #
#############

include $(ROOT)/target/common/verilator.mk

############
# Modelsim #
############

include $(ROOT)/target/common/vsim.mk

#######
# VCS #
#######

include $(ROOT)/target/common/vcs.mk

#########
# GVSOC #
#########

include $(ROOT)/target/common/gvsoc.mk

########
# Util #
########

.PHONY: clean-work clean-bender clean-logs help

clean-work:
	rm -rf work

clean-bender:
	rm -rf $(ROOT)/.bender/

clean-logs:
	rm -rf $(LOGS_DIR)

clean-generated:
	rm -rf $(GENERATED_DIR)

# Help command
Blue=\033[1;34m
Black=\033[0m
help:
	@echo -e "${Blue}Makefile Targets${Black} for the ${Blue}Snitch Cluster${Black}"
	@echo -e "Use 'make <target>' where <target> is one of:"
	@echo -e ""
	@echo -e "${Blue}help           ${Black}Show an overview of all Makefile targets."
	@echo -e ""
	@echo -e "${Blue}$(BIN_DIR)/$(TARGET).vcs  ${Black}Build compilation script and compile all sources for VCS simulation."
	@echo -e "${Blue}$(BIN_DIR)/$(TARGET).vlt  ${Black}Build compilation script and compile all sources for Verilator simulation."
	@echo -e "${Blue}$(BIN_DIR)/$(TARGET).vsim ${Black}Build compilation script and compile all sources for Questasim simulation."
	@echo -e ""
	@echo -e "${Blue}sw               ${Black}Build all software."
	@echo -e "${Blue}rtl              ${Black}Build all RTL."
	@echo -e ""
	@echo -e "${Blue}clean            ${Black}Clean everything except traces in logs directory."
	@echo -e "${Blue}clean-bender     ${Black}Clean Bender dependencies."
	@echo -e "${Blue}clean-rtl        ${Black}Clean all generated RTL sources."
	@echo -e "${Blue}clean-sw         ${Black}Clean all software."
	@echo -e "${Blue}clean-generated  ${Black}Delete all generated files in the generated directory."
	@echo -e "${Blue}clean-logs       ${Black}Delete all traces in logs directory."
	@echo -e "${Blue}clean-vcs        ${Black}Clean all build directories and temporary files for VCS simulation."
	@echo -e "${Blue}clean-vlt        ${Black}Clean all build directories and temporary files for Verilator simulation."
	@echo -e "${Blue}clean-vsim       ${Black}Clean all build directories and temporary files for Questasim simulation."
	@echo -e ""
	@echo -e "Additional useful targets from the included Makefrag:"
	@echo -e "${Blue}traces           ${Black}Generate the better readable traces in .logs/trace_hart_<hart_id>.txt."
	@echo -e "${Blue}annotate         ${Black}Annotate the better readable traces in .logs/trace_hart_<hart_id>.s with the source code related with the retired instructions."
