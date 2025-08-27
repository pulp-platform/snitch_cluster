# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

#############
# Variables #
#############

# Tools
QUESTA_SEPP	?=
VSIM        ?= $(QUESTA_SEPP) vsim
VOPT        ?= $(QUESTA_SEPP) vopt
VLOG        ?= $(QUESTA_SEPP) vlog
VLIB        ?= $(QUESTA_SEPP) vlib

# Sources
VSIM_BENDER_FLAGS = $(COMMON_BENDER_FLAGS) $(COMMON_BENDER_SIM_FLAGS) -t vsim
VSIM_SOURCES      = $(shell ${BENDER} script flist-plus $(VSIM_BENDER_FLAGS) | ${SED_SRCS})

# Directories
VSIM_BUILDDIR ?= $(SN_TARGET_DIR)/sim/build/work-vsim

# Flags
VLOG_FLAGS += -64
VLOG_FLAGS += -svinputport=compat
VLOG_FLAGS += -override_timescale 1ns/1ps
VLOG_FLAGS += -suppress 2583
VLOG_FLAGS += -suppress 13314
VLOG_FLAGS += -work $(VSIM_BUILDDIR)
VOPT_FLAGS += -work $(VSIM_BUILDDIR)
VSIM_FLAGS += -64
VSIM_FLAGS += -work $(VSIM_BUILDDIR)
VSIM_FLAGS += -t 1ps

# DEBUG flag ensures visibility of all signals in the waveforms
ifeq ($(DEBUG), ON)
VSIM_FLAGS += -do "log -r /*"
VOPT_FLAGS  = +acc
endif

# PL_SIM flag selects between RTL or post-layout simulation
ifeq ($(PL_SIM), 1)
include $(SN_ROOT)/nonfree/gf12/modelsim/Makefrag
COMMON_BENDER_FLAGS += -t postlayout
VOPT_FLAGS += -modelsimini $(SN_ROOT)/nonfree/gf12/modelsim/modelsim.ini
VOPT_FLAGS += +nospecify
VOPT_FLAGS += $(GATE_LIBS)
VSIM_FLAGS += -modelsimini $(SN_ROOT)/nonfree/gf12/modelsim/modelsim.ini
VSIM_FLAGS += +nospecify
endif

# VCD_DUMP flag enables VCD dump generation
ifeq ($(VCD_DUMP), 1)
VSIM_FLAGS += -do "source $(ROOT)/nonfree/gf12/modelsim/vcd.tcl"
else
VSIM_FLAGS += -do "run -a"
endif

# Misc
VSIM_TOP_MODULE = tb_bin
VSIM_RTL_PREREQ_FILE = $(VSIM_BUILDDIR)/$(VSIM_TOP_MODULE).d

#########
# Rules #
#########

$(VSIM_BUILDDIR):
	mkdir -p $@

# Generate RTL prerequisites
$(eval $(call gen_rtl_prerequisites,$(VSIM_RTL_PREREQ_FILE),$(VSIM_BUILDDIR),$(VSIM_BENDER_FLAGS),$(VSIM_TOP_MODULE),$(SN_BIN_DIR)/$(TARGET).vsim))

# Generate compilation script
$(VSIM_BUILDDIR)/compile.vsim.tcl: $(BENDER_YML) $(BENDER_LOCK) | $(VSIM_BUILDDIR)
	$(VLIB) $(dir $@)
	$(BENDER) script vsim $(VSIM_BENDER_FLAGS) --vlog-arg="$(VLOG_FLAGS) " > $@
	echo '$(VLOG) -work $(VSIM_BUILDDIR) $(TB_CC_SOURCES) $(RTL_CC_SOURCES) -vv -ccflags "$(TB_CC_FLAGS)"' >> $@
	echo 'return 0' >> $@

# Run compilation script and create Questasim simulation binary
$(SN_BIN_DIR)/$(TARGET).vsim: $(VSIM_BUILDDIR)/compile.vsim.tcl $(TB_CC_SOURCES) $(RTL_CC_SOURCES) $(SN_WORK_DIR)/lib/libfesvr.a | $(SN_BIN_DIR)
	$(VSIM) -c -do "source $<; quit" | tee $(dir $<)/vlog.log
	@! grep -P "Errors: [1-9]*," $(dir $<)/vlog.log
	$(VOPT) $(VOPT_FLAGS) -work $(dir $<) $(VSIM_TOP_MODULE) -o $(VSIM_TOP_MODULE)_opt | tee $(dir $<)/vopt.log
	@! grep -P "Errors: [1-9]*," $(dir $<)/vopt.log
	@echo "#!/bin/bash" > $@
	@echo 'binary=$$(realpath $$1)' >> $@
	@echo 'echo $$binary > .rtlbinary' >> $@
	@echo '$(VSIM) +permissive $(VSIM_FLAGS) $$3 -c \
				-quiet -ldflags "-Wl,-rpath,$(FESVR)/lib -L$(FESVR)/lib -lfesvr -lutil" \
				$(VSIM_TOP_MODULE)_opt +permissive-off ++$$binary ++$$2' >> $@
	@chmod +x $@
	@echo "#!/bin/bash" > $@.gui
	@echo 'binary=$$(realpath $$1)' >> $@.gui
	@echo 'echo $$binary > .rtlbinary' >> $@.gui
	@echo '$(VSIM) +permissive $(VSIM_FLAGS) \
				-quiet -ldflags "-Wl,-rpath,$(FESVR)/lib -L$(FESVR)/lib -lfesvr -lutil" \
				$(VSIM_TOP_MODULE)_opt +permissive-off ++$$binary ++$$2' >> $@.gui
	@chmod +x $@.gui

.PHONY: vsim clean-vsim

vsim: $(SN_BIN_DIR)/$(TARGET).vsim

# Clean all build directories and temporary files for Questasim simulation
clean-vsim: clean-work
	rm -rf $(SN_BIN_DIR)/$(TARGET).vsim $(SN_BIN_DIR)/$(TARGET).vsim.gui $(VSIM_BUILDDIR) vsim.wlf

clean: clean-vsim

ifneq ($(filter-out clean%,$(MAKECMDGOALS)),)
-include $(VSIM_RTL_PREREQ_FILE)
endif
