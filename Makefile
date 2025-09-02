# Copyright 2020 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51
#
# Fabian Schuiki <fschuiki@iis.ee.ethz.ch>
# Florian Zaruba <zarubaf@iis.ee.ethz.ch>
# Luca Colagrande <colluca@iis.ee.ethz.ch>

#######################
# Makefile invocation #
#######################

DEBUG        ?= OFF  # ON to turn on debugging symbols and wave logging
CFG_OVERRIDE ?=      # Override default configuration file
PL_SIM       ?= 0    # 1 for post-layout simulation
VCD_DUMP     ?= 0    # 1 to dump VCD traces

# Non-namespaced aliases for common command-line variables
ifdef SIM_DIR
	SN_SIM_DIR = $(SIM_DIR)
endif
ifdef BINARY
	SN_BINARY = $(BINARY)
endif
ifdef ROI_SPEC
	SN_ROI_SPEC = $(ROI_SPEC)
endif
ifdef VERIFY_PY
	SN_VERIFY_PY = $(VERIFY_PY)
endif

.PHONY: all clean
all: rtl sw
clean: clean-rtl clean-sw clean-work clean-logs clean-bender clean-misc

##########
# Common #
##########

SN_ROOT := $(realpath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

include $(SN_ROOT)/make/common.mk

TARGET = snitch_cluster
SN_COMMON_BENDER_FLAGS += -t snitch_cluster_wrapper

#################
# Configuration #
#################

SN_DEFAULT_CFG = $(SN_CFG_DIR)/default.json

# If the configuration file is overriden on the command-line (through
# CFG_OVERRIDE) and this file differs from the least recently used
# (LRU) config, all targets depending on the configuration file have
# to be rebuilt. This file is used to express this condition as a
# prerequisite for other rules.
SN_CFG = $(SN_CFG_DIR)/lru.json

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
		echo "Using default config file: $(SN_DEFAULT_CFG)"; \
		ln -s --relative $(SN_DEFAULT_CFG) $@; \
		touch $(SN_DEFAULT_CFG); \
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

########
# Docs #
########

DOCS_DIR = docs

GENERATED_DOCS_DIR = $(DOCS_DIR)/generated
GENERATED_DOC_SRCS = $(GENERATED_DOCS_DIR)/peripherals.md

DOXYGEN_DOCS_DIR = $(DOCS_DIR)/doxygen
DOXYGEN_INPUTS   = $(DOCS_DIR)/rm/runtime.md
DOXYGEN_INPUTS  += $(shell find sw/runtime -name '*.c' -o -name '*.h')
DOXYFILE         = $(DOCS_DIR)/Doxyfile

.PHONY: doc-srcs doxygen-docs docs clean-docs

doc-srcs: $(GENERATED_DOC_SRCS)

doxygen-docs: $(DOXYGEN_DOCS_DIR)

docs: doc-srcs doxygen-docs
	mkdocs build

clean-docs:
	rm -rf $(GENERATED_DOCS_DIR)
	rm -rf $(DOXYGEN_DOCS_DIR)
	rm -rf site

$(GENERATED_DOCS_DIR):
	mkdir -p $@

$(GENERATED_DOCS_DIR)/peripherals.md: hw/snitch_cluster/src/snitch_cluster_peripheral/snitch_cluster_peripheral_reg.rdl | $(GENERATED_DOCS_DIR)
	$(SN_PEAKRDL) markdown $< -o $@

$(DOXYGEN_DOCS_DIR): $(DOXYFILE) $(DOXYGEN_INPUTS)
	doxygen $<

#######
# RTL #
#######

include $(SN_ROOT)/make/rtl.mk

.PHONY: rtl clean-rtl
rtl: sn-rtl
clean-rtl: sn-clean-rtl

############
# Non-free #
############

NONFREE_REMOTE ?= git@iis-git.ee.ethz.ch:pulp-restricted/snitch-cluster-nonfree.git
NONFREE_COMMIT ?= refactor
NONFREE_DIR = $(SN_ROOT)/nonfree

.PHONY: nonfree clean-nonfree

nonfree:
	cd $(NONFREE_DIR) && \
	git init && \
	git remote add origin $(NONFREE_REMOTE) && \
	git fetch origin && \
	git checkout $(NONFREE_COMMIT) -f

clean-nonfree:
	rm -rf $(NONFREE_DIR)
	mkdir -p $(NONFREE_DIR)/util && touch $(NONFREE_DIR)/util/.gitignore

-include $(NONFREE_DIR)/Makefile

############
# Software #
############

include $(SN_ROOT)/make/sw.mk

.PHONY: tests riscv-tests apps sw clean-tests clean-riscv-tests clean-apps clean-sw
tests: sn-tests
riscv-tests: sn-riscv-tests
apps: sn-apps
sw: sn-sw
clean-tests: sn-clean-tests
clean-riscv-tests: sn-clean-riscv-tests
clean-apps: sn-clean-apps
clean-sw: sn-clean-sw

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

######################
# Simulation targets #
######################

SN_TB_CC_SOURCES += \
	$(SN_TB_DIR)/ipc.cc \
	$(SN_TB_DIR)/common_lib.cc \
	$(SN_GEN_DIR)/bootdata.cc

SN_RTL_CC_SOURCES += $(SN_TB_DIR)/rtl_lib.cc

SN_VLT_CC_SOURCES += \
	$(SN_TB_DIR)/verilator_lib.cc \
	$(SN_TB_DIR)/tb_bin.cc

SN_TB_CC_FLAGS += \
	-std=c++14 \
	-I$(SN_FESVR)/include \
	-I$(SN_TB_DIR)

SN_FESVR = $(SN_WORK_DIR)
SN_FESVR_VERSION ?= 35d50bc40e59ea1d5566fbd3d9226023821b1bb6

# Eventually it could be an option to package this statically using musl libc.
$(SN_WORK_DIR)/$(SN_FESVR_VERSION)_unzip: | $(SN_WORK_DIR)
	wget -O $(dir $@)/$(SN_FESVR_VERSION) https://github.com/riscv/riscv-isa-sim/tarball/$(SN_FESVR_VERSION)
	tar xfm $(dir $@)$(SN_FESVR_VERSION) --strip-components=1 -C $(dir $@)
	touch $@

$(SN_WORK_DIR)/lib/libfesvr.a: $(SN_WORK_DIR)/$(SN_FESVR_VERSION)_unzip
	cd $(dir $<)/ && ./configure --prefix `pwd`
	make -C $(dir $<) install-config-hdrs install-hdrs libfesvr.a
	mkdir -p $(dir $@)
	cp $(dir $<)libfesvr.a $@

include $(SN_ROOT)/make/verilator.mk
include $(SN_ROOT)/make/vsim.mk
include $(SN_ROOT)/make/vcs.mk

#########
# GVSOC #
#########

include $(SN_ROOT)/make/gvsoc.mk

##########
# Traces #
##########

include $(SN_ROOT)/make/traces.mk

.PHONY: traces annotate perf visual-trace clean-traces clean-annotate clean-perf clean-visual-trace
traces: sn-traces
annotate: sn-annotate
perf: sn-perf
visual-trace: sn-visual-trace
clean-traces: sn-clean-traces
clean-annotate: sn-clean-annotate
clean-perf: sn-clean-perf
clean-visual-trace: sn-clean-visual-trace

############################
# Additional PHONY targets #
############################

.PHONY: clean-work clean-bender clean-logs

clean-work:
	rm -rf $(SN_WORK_DIR)

clean-bender:
	rm -rf $(SN_ROOT)/.bender/

clean-logs:
	rm -rf $(SN_LOGS_DIR)

#########
# Final #
#########

# After all Make fragments have appended their dependency files to SN_DEPS,
# conditionally include all dependency files in one go. Ensures that
# list-dependent-make-targets is only invoked once, for better speed.
$(call sn_include_deps)
