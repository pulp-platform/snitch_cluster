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

.PHONY: all clean
all: rtl sw
clean: clean-rtl clean-sw clean-work clean-logs clean-bender clean-misc

##########
# Common #
##########

MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MKFILE_DIR  := $(dir $(MKFILE_PATH))
SN_ROOT     := $(realpath ${MKFILE_DIR}../..)

TARGET = snitch_cluster

include $(SN_ROOT)/target/common/common.mk

#########################
# Files and directories #
#########################

TB_DIR = $(SN_ROOT)/target/common/test

# If the configuration file is overriden on the command-line (through
# CFG_OVERRIDE) and this file differs from the least recently used
# (LRU) config, all targets depending on the configuration file have
# to be rebuilt. This file is used to express this condition as a
# prerequisite for other rules.
DEFAULT_SN_CFG = cfg/default.json
SN_CFG         = cfg/lru.json

########
# Misc #
########

COMMON_BENDER_FLAGS += -t snitch_cluster_wrapper

###############
# C testbench #
###############

TB_CC_SOURCES += \
	${TB_DIR}/ipc.cc \
	${TB_DIR}/common_lib.cc \
	$(SN_GEN_DIR)/bootdata.cc

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

# This target is always evaluated and creates a symlink to the least
# recently used config file. Because it is a symlink, targets to which it is a
# prerequisite will only be updated if the symlink target is newer than the
# depending targets, regardless of the symlink timestamp itself. The symlink
# timestamp can be taken into account by using the `make -L` flag on the
# command-line, however for simplicity we touch the symlink targets so it can
# be used without.
$(SN_CFG): FORCE
	@# If the LRU config file doesn't exist, we use the default config.
	@if [ ! -e "$@" ] ; then \
		echo "Using default config file: $(DEFAULT_SN_CFG)"; \
		ln -s --relative $(DEFAULT_SN_CFG) $@; \
		touch $(DEFAULT_SN_CFG); \
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

include $(SN_ROOT)/target/snitch_cluster/sw.mk

.PHONY: sw clean-sw
sw: sn-sw
clean-sw: sn-clean-sw

#######
# RTL #
#######

include $(SN_ROOT)/target/common/rtl.mk

.PHONY: rtl clean-rtl
rtl: sn-rtl
clean-rtl: sn-clean-rtl

########
# Misc #
########

SN_LINK_LD_TPL  = $(SN_ROOT)/hw/snitch_cluster/test/link.ld.tpl
SN_BOOTDATA_TPL = $(SN_ROOT)/hw/snitch_cluster/test/bootdata.cc.tpl

$(eval $(call sn_cluster_gen_rule,$(SN_GEN_DIR)/link.ld,$(SN_LINK_LD_TPL)))
$(eval $(call sn_cluster_gen_rule,$(SN_GEN_DIR)/bootdata.cc,$(SN_BOOTDATA_TPL)))

misc: $(SN_GEN_DIR)/link.ld $(SN_GEN_DIR)/bootdata.cc
clean-misc:
	rm -rf $(SN_GEN_DIR)/link.ld $(SN_GEN_DIR)/bootdata.cc

##############
# Simulators #
##############

include $(SN_ROOT)/target/common/verilator.mk
include $(SN_ROOT)/target/common/vsim.mk
include $(SN_ROOT)/target/common/vcs.mk

#########
# GVSOC #
#########

include $(SN_ROOT)/target/common/gvsoc.mk

########
# Util #
########

.PHONY: clean-work clean-bender clean-logs

clean-work:
	rm -rf work

clean-bender:
	rm -rf $(SN_ROOT)/.bender/

clean-logs:
	rm -rf $(LOGS_DIR)
