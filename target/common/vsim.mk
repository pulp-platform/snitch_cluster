# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Tool versions
BENDER ?= bender
QUESTA_SEPP	?=
VSIM ?= $(QUESTA_SEPP) vsim
VOPT ?= $(QUESTA_SEPP) vopt
VLOG ?= $(QUESTA_SEPP) vlog
VLIB ?= $(QUESTA_SEPP) vlib

BENDER_LOCK ?= $(SN_ROOT)/Bender.lock

# Sources
VSIM_BENDER  = $(COMMON_BENDER_FLAGS) $(COMMON_SIM_BENDER_FLAGS) -t vsim
VSIM_SOURCES = $(shell ${BENDER} script flist-plus $(VSIM_BENDER) | ${SED_SRCS})
VSIM_BUILDDIR ?= work-vsim
BIN_DIR ?= bin
TARGET ?= snitch_cluster

# QuestaSim Flags
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

ifeq ($(DEBUG), ON)
	VSIM_FLAGS    += -do "log -r /*; run -a"
	VOPT_FLAGS     = +acc
else
	VSIM_FLAGS    += -do "run -a"
endif

$(VSIM_BUILDDIR):
	mkdir -p $@

$(VSIM_BUILDDIR)/compile.vsim.tcl: $(BENDER_LOCK) | $(VSIM_BUILDDIR)
	$(VLIB) $(dir $@)
	$(BENDER) script vsim $(VSIM_BENDER) --vlog-arg="$(VLOG_FLAGS) -work $(dir $@) " > $@
	echo '$(VLOG) -work $(VSIM_BUILDDIR) $(TB_CC_SOURCES) $(RTL_CC_SOURCES) -vv -ccflags "$(TB_CC_FLAGS)"' >> $@
	echo 'return 0' >> $@

# Build compilation script and compile all sources for Questasim simulation
$(BIN_DIR)/$(TARGET).vsim: $(VSIM_BUILDDIR)/compile.vsim.tcl $(VSIM_SOURCES) $(TB_SRCS) $(TB_CC_SOURCES) $(RTL_CC_SOURCES) work/lib/libfesvr.a | $(BIN_DIR)
	$(VSIM) -c -do "source $<; quit" | tee $(VSIM_BUILDDIR)vlog.log
	@! grep -P "Errors: [1-9]*," $(VSIM_BUILDDIR)vlog.log
	$(VOPT) $(VOPT_FLAGS) -work $(VSIM_BUILDDIR) tb_bin -o tb_bin_opt | tee $(VSIM_BUILDDIR)vopt.log
	@! grep -P "Errors: [1-9]*," $(VSIM_BUILDDIR)vopt.log
	@echo "#!/bin/bash" > $@
	@echo 'binary=$$(realpath $$1)' >> $@
	@echo 'echo $$binary > .rtlbinary' >> $@
	@echo '$(VSIM) +permissive $(VSIM_FLAGS) $$3 -c \
				-quiet -ldflags "-Wl,-rpath,$(FESVR)/lib -L$(FESVR)/lib -lfesvr -lutil" \
				tb_bin_opt +permissive-off ++$$binary ++$$2' >> $@
	@chmod +x $@
	@echo "#!/bin/bash" > $@.gui
	@echo 'binary=$$(realpath $$1)' >> $@.gui
	@echo 'echo $$binary > .rtlbinary' >> $@.gui
	@echo '$(VSIM) +permissive $(VSIM_FLAGS) \
				-quiet -ldflags "-Wl,-rpath,$(FESVR)/lib -L$(FESVR)/lib -lfesvr -lutil" \
				tb_bin_opt +permissive-off ++$$binary ++$$2' >> $@.gui
	@chmod +x $@.gui

# Clean all build directories and temporary files for Questasim simulation
.PHONY: clean-vsim
clean-vsim: clean-work
	rm -rf $(BIN_DIR)/$(TARGET).vsim $(BIN_DIR)/$(TARGET).vsim.gui $(VSIM_BUILDDIR) vsim.wlf

clean: clean-vsim
