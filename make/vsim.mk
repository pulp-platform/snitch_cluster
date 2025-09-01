# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

#############
# Variables #
#############

# Tools
SN_QUESTA_SEPP ?=
SN_VSIM        ?= $(SN_QUESTA_SEPP) vsim
SN_VOPT        ?= $(SN_QUESTA_SEPP) vopt
SN_VLOG        ?= $(SN_QUESTA_SEPP) vlog
SN_VLIB        ?= $(SN_QUESTA_SEPP) vlib

# Directories
SN_VSIM_BUILDDIR ?= $(SN_TARGET_DIR)/sim/build/work-vsim

# Flags
SN_VSIM_BENDER_FLAGS = $(SN_COMMON_BENDER_FLAGS) $(SN_COMMON_BENDER_SIM_FLAGS) -t vsim
SN_VLOG_FLAGS += -64
SN_VLOG_FLAGS += -svinputport=compat
SN_VLOG_FLAGS += -override_timescale 1ns/1ps
SN_VLOG_FLAGS += -suppress 2583
SN_VLOG_FLAGS += -suppress 13314
SN_VLOG_FLAGS += -work $(SN_VSIM_BUILDDIR)
SN_VOPT_FLAGS += -work $(SN_VSIM_BUILDDIR)
SN_VSIM_FLAGS += -64
SN_VSIM_FLAGS += -work $(SN_VSIM_BUILDDIR)
SN_VSIM_FLAGS += -t 1ps

# DEBUG flag ensures visibility of all signals in the waveforms
ifeq ($(DEBUG), ON)
SN_VSIM_FLAGS += -do "log -r /*"
SN_VOPT_FLAGS  = +acc
endif

# PL_SIM flag selects between RTL or post-layout simulation
ifeq ($(PL_SIM), 1)
include $(SN_ROOT)/nonfree/gf12/modelsim/Makefrag
SN_COMMON_BENDER_FLAGS += -t postlayout
SN_VOPT_FLAGS += -modelsimini $(SN_ROOT)/nonfree/gf12/modelsim/modelsim.ini
SN_VOPT_FLAGS += +nospecify
SN_VOPT_FLAGS += $(SN_GATE_LIBS)
SN_VSIM_FLAGS += -modelsimini $(SN_ROOT)/nonfree/gf12/modelsim/modelsim.ini
SN_VSIM_FLAGS += +nospecify
endif

# VCD_DUMP flag enables VCD dump generation
ifeq ($(VCD_DUMP), 1)
SN_VSIM_FLAGS += -do "source $(SN_ROOT)/nonfree/gf12/modelsim/vcd.tcl"
else
SN_VSIM_FLAGS += -do "run -a"
endif

# Select .gui simulator binary when simulating with DEBUG flag
ifeq ($(DEBUG), ON)
SN_VSIM_BINARY = $(SN_BIN_DIR)/$(TARGET).vsim.gui
else
SN_VSIM_BINARY = $(SN_BIN_DIR)/$(TARGET).vsim
endif

# Misc
SN_VSIM_TOP_MODULE = tb_bin
SN_VSIM_RTL_PREREQ_FILE = $(SN_VSIM_BUILDDIR)/$(SN_VSIM_TOP_MODULE).d

#########
# Rules #
#########

$(SN_VSIM_BUILDDIR):
	mkdir -p $@

# Generate RTL prerequisites
$(eval $(call sn_gen_rtl_prerequisites,$(SN_VSIM_RTL_PREREQ_FILE),$(SN_VSIM_BUILDDIR),$(SN_VSIM_BENDER_FLAGS),$(SN_VSIM_TOP_MODULE),$(SN_BIN_DIR)/$(TARGET).vsim))

# Generate compilation script
$(SN_VSIM_BUILDDIR)/compile.vsim.tcl: $(SN_BENDER_YML) $(SN_BENDER_LOCK) | $(SN_VSIM_BUILDDIR)
	$(SN_VLIB) $(dir $@)
	$(SN_BENDER) script vsim $(SN_VSIM_BENDER_FLAGS) --vlog-arg="$(SN_VLOG_FLAGS) " > $@
	echo '$(SN_VLOG) -work $(SN_VSIM_BUILDDIR) $(SN_TB_CC_SOURCES) $(SN_RTL_CC_SOURCES) -vv -ccflags "$(SN_TB_CC_FLAGS)"' >> $@
	echo 'return 0' >> $@

# Run compilation script and create Questasim simulation binary
$(SN_BIN_DIR)/$(TARGET).vsim: $(SN_VSIM_BUILDDIR)/compile.vsim.tcl $(SN_TB_CC_SOURCES) $(SN_RTL_CC_SOURCES) $(SN_WORK_DIR)/lib/libfesvr.a $(SN_VSIM_RTL_PREREQ_FILE) | $(SN_BIN_DIR)
	$(SN_VSIM) -c -do "source $<; quit" | tee $(dir $<)/vlog.log
	@! grep -P "Errors: [1-9]*," $(dir $<)/vlog.log
	$(SN_VOPT) $(SN_VOPT_FLAGS) -work $(dir $<) $(SN_VSIM_TOP_MODULE) -o $(SN_VSIM_TOP_MODULE)_opt | tee $(dir $<)/vopt.log
	@! grep -P "Errors: [1-9]*," $(dir $<)/vopt.log
	@echo "#!/bin/bash" > $@
	@echo 'binary=$$(realpath $$1)' >> $@
	@echo 'echo $$binary > .rtlbinary' >> $@
	@echo '$(SN_VSIM) +permissive $(SN_VSIM_FLAGS) $$3 -c \
				-quiet -ldflags "-Wl,-rpath,$(SN_FESVR)/lib -L$(SN_FESVR)/lib -lfesvr -lutil" \
				$(SN_VSIM_TOP_MODULE)_opt +permissive-off ++$$binary ++$$2' >> $@
	@chmod +x $@
	@echo "#!/bin/bash" > $@.gui
	@echo 'binary=$$(realpath $$1)' >> $@.gui
	@echo 'echo $$binary > .rtlbinary' >> $@.gui
	@echo '$(SN_VSIM) +permissive $(SN_VSIM_FLAGS) \
				-quiet -ldflags "-Wl,-rpath,$(SN_FESVR)/lib -L$(SN_FESVR)/lib -lfesvr -lutil" \
				$(SN_VSIM_TOP_MODULE)_opt +permissive-off ++$$binary ++$$2' >> $@.gui
	@chmod +x $@.gui

.PHONY: vsim vsim-run clean-vsim

vsim: $(SN_BIN_DIR)/$(TARGET).vsim

vsim-run: $(SN_VSIM_BINARY) $(SN_BINARY)
	cd $(SN_SIM_DIR) && $(SN_VERIFY_PY) $(SN_VSIM_BINARY) $(SN_BINARY)

# Clean all build directories and temporary files for Questasim simulation
clean-vsim: clean-work
	rm -rf $(SN_BIN_DIR)/$(TARGET).vsim $(SN_BIN_DIR)/$(TARGET).vsim.gui $(SN_VSIM_BUILDDIR) vsim.wlf

clean: clean-vsim

SN_DEPS += $(SN_VSIM_RTL_PREREQ_FILE)
