# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Makefile invocation
DEBUG    ?= OFF  # ON to turn on wave logging
PL_SIM   ?= 0    # 1 for post-layout simulation
VCD_DUMP ?= 0    # 1 to dump VCD traces

# Directories
SIM_DIR      ?= $(shell pwd)
TB_DIR       ?= $(SN_ROOT)/target/common/test
UTIL_DIR     ?= $(SN_ROOT)/util
LOGS_DIR      = $(SIM_DIR)/logs
SN_PERIPH_DIR = $(SN_ROOT)/hw/snitch_cluster/src/snitch_cluster_peripheral
SN_TARGET_DIR = $(SN_ROOT)/target
SN_GEN_DIR   ?= $(SN_ROOT)/hw/generated
SN_HW_DIR     = $(SN_ROOT)/hw
SN_BIN_DIR    = $(SN_TARGET_DIR)/sim/build/bin
SN_WORK_DIR   = $(SN_TARGET_DIR)/sim/build/work

# External executables
BENDER	     ?= bender
PEAKRDL      ?= peakrdl
VERIBLE_FMT  ?= verible-verilog-format
CLANG_FORMAT ?= clang-format
RISCV_MC     ?= $(LLVM_BINROOT)/llvm-mc
ADDR2LINE    ?= $(LLVM_BINROOT)/llvm-addr2line
# tail is required for nonsense oseda output
VLT_BIN       = $(shell $(VERILATOR_SEPP) which verilator_bin | tail -n1 | $(VERILATOR_SEPP) xargs realpath | tail -n1)

# Internal executables
GENTRACE_PY       ?= $(UTIL_DIR)/trace/gen_trace.py
ANNOTATE_PY       ?= $(UTIL_DIR)/trace/annotate.py
EVENTS_PY         ?= $(UTIL_DIR)/trace/events.py
JOIN_PY           ?= $(UTIL_DIR)/bench/join.py
ROI_PY            ?= $(UTIL_DIR)/bench/roi.py
VISUALIZE_PY      ?= $(UTIL_DIR)/bench/visualize.py
SN_BOOTROM_GEN     = $(SN_ROOT)/util/clustergen/gen_bootrom.py
SN_CLUSTER_GEN     = $(SN_ROOT)/util/clustergen/clustergen.py

# Gentrace prerequisites
SN_GENTRACE_SRC = $(UTIL_DIR)/trace/sequencer.py

# Annotate prerequisites
SN_ANNOTATE_SRC = $(UTIL_DIR)/trace/a2l.py

# Clustergen prerequisites
SN_CLUSTER_GEN_SRC = $(SN_ROOT)/util/clustergen/cluster.py

# Bender prerequisites
SN_BENDER_LOCK = $(SN_ROOT)/Bender.lock
SN_BENDER_YML  = $(SN_ROOT)/Bender.yml

# fesvr is being installed here
FESVR         ?= $(SN_WORK_DIR)
FESVR_VERSION ?= 35d50bc40e59ea1d5566fbd3d9226023821b1bb6

# Flags
COMMON_BENDER_FLAGS     += -t rtl -t snitch_cluster
COMMON_BENDER_SIM_FLAGS += -t simulation -t test
RISCV_MC_FLAGS          ?= -disassemble -mcpu=snitch
ANNOTATE_FLAGS          ?= -q --keep-time --addr2line=$(ADDR2LINE)
LAYOUT_EVENTS_FLAGS     ?= --cfg=$(CFG)

#################
# Prerequisites #
#################
# Eventually it could be an option to package this statically using musl libc.
$(SN_WORK_DIR)/${FESVR_VERSION}_unzip:
	mkdir -p $(dir $@)
	wget -O $(dir $@)/${FESVR_VERSION} https://github.com/riscv/riscv-isa-sim/tarball/${FESVR_VERSION}
	tar xfm $(dir $@)${FESVR_VERSION} --strip-components=1 -C $(dir $@)
	touch $@

$(SN_WORK_DIR)/lib/libfesvr.a: $(SN_WORK_DIR)/${FESVR_VERSION}_unzip
	cd $(dir $<)/ && ./configure --prefix `pwd`
	make -C $(dir $<) install-config-hdrs install-hdrs libfesvr.a
	mkdir -p $(dir $@)
	cp $(dir $<)libfesvr.a $@

$(SN_GEN_DIR) $(SN_BIN_DIR):
	mkdir -p $@

########
# Util #
########

# Normalizes a directory name by removing the trailing slash, if any.
# Use to ensure that dependencies and targets are consistently specified.
define normalize_dir
$(patsubst %/,%,$(1))
endef

# Common rule to generate C header with peakRDL
# $1: target name, $2: prerequisite (rdl description file), $3 (optional) additional peakRDL flags
define peakrdl_generate_header_rule
$(1): $(2) | $(call normalize_dir,$(dir $(1)))
	@echo "[peakRDL] Generating $$@"
	$(PEAKRDL) c-header $$< -o $$@ -i -b ltoh $(3)
	@$(CLANG_FORMAT) -i $$@
endef

# Arg 1: binary
# Arg 2: max size in bytes
define BINARY_SIZE_CHECK
  echo "Binary size: $$(stat -c %s $(1))B"
  @[ "$$(stat -c %s $(1))" -lt "$(2)" ] || (echo "Binary exceeds specified size of $(2)B"; exit 1)
endef

# Common rule to fill a template file with clustergen
# Arg 1: path for the generated file
# Arg 2: path of the template file
define sn_cluster_gen_rule
$(1): $(SN_CFG) $(SN_CLUSTER_GEN) $(SN_CLUSTER_GEN_SRC) $(2) | $(call normalize_dir,$(dir $(1)))
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
define gen_rtl_prerequisites
$(2)/$(4).f: $(SN_BENDER_YML) $(SN_BENDER_LOCK) | $(2)
	$(BENDER) script verilator $(3) > $$@

$(1): $(2)/$(4).f $(SN_GEN_RTL_SRCS) | $(2)
	$(VLT) -f $$< --Mdir $(2) --MMD -E --top-module $(4) > /dev/null
	mv $(2)/V$(4)__ver.d $$@
	sed -E -i -e 's|^[^:]*:|$(5):|' \
	    -e ':a; s/(^|[[:space:]])$(subst /,\/,$(VLT_BIN))($|[[:space:]])/\1\2/g; ta' $$@
endef

##########
# Traces #
##########

SNITCH_DASM_TRACES      = $(shell (ls $(LOGS_DIR)/trace_hart_*.dasm 2>/dev/null))
SNITCH_TXT_TRACES       = $(shell (echo $(SNITCH_DASM_TRACES) | sed 's/\.dasm/\.txt/g'))
SNITCH_ANNOTATED_TRACES = $(shell (echo $(SNITCH_DASM_TRACES) | sed 's/\.dasm/\.s/g'))
SNITCH_PERF_DUMPS       = $(shell (echo $(SNITCH_DASM_TRACES) | sed 's/trace_hart/hart/g' | sed 's/.dasm/_perf.json/g'))
DMA_PERF_DUMPS          = $(LOGS_DIR)/dma_*_perf.json

TXT_TRACES       += $(SNITCH_TXT_TRACES)
ANNOTATED_TRACES += $(SNITCH_ANNOTATED_TRACES)
PERF_DUMPS       += $(SNITCH_PERF_DUMPS)
JOINT_PERF_DUMP   = $(LOGS_DIR)/perf.json
ROI_DUMP          = $(LOGS_DIR)/roi.json
VISUAL_TRACE      = $(LOGS_DIR)/trace.json

VISUALIZE_PY_FLAGS += --tracevis "$(BINARY) $(SNITCH_TXT_TRACES) --addr2line $(ADDR2LINE) -f snitch"
GENTRACE_PY_FLAGS  += --mc-exec $(RISCV_MC) --mc-flags "$(RISCV_MC_FLAGS)"

# Do not suspend trace generation upon gentrace errors when debugging
ifeq ($(DEBUG),ON)
GENTRACE_PY_FLAGS += --permissive
endif

.PHONY: traces annotate visual-trace clean-traces clean-annotate clean-perf clean-visual-trace
traces: $(TXT_TRACES)
annotate: $(ANNOTATED_TRACES)
perf: $(JOINT_PERF_DUMP)
visual-trace: $(VISUAL_TRACE)
clean-traces:
	rm -f $(TXT_TRACES) $(SNITCH_PERF_DUMPS) $(DMA_PERF_DUMPS)
clean-annotate:
	rm -f $(ANNOTATED_TRACES)
clean-perf:
	rm -f $(PERF_DUMPS) $(JOINT_PERF_DUMP)
clean-visual-trace:
	rm -f $(VISUAL_TRACE)

$(addprefix $(LOGS_DIR)/,trace_hart_%.txt hart_%_perf.json dma_%_perf.json): $(LOGS_DIR)/trace_hart_%.dasm $(GENTRACE_PY) $(SN_GENTRACE_SRC)
	$(GENTRACE_PY) $< $(GENTRACE_PY_FLAGS) --dma-trace $(SIM_DIR)/dma_trace_$*_00000.log --dump-hart-perf $(LOGS_DIR)/hart_$*_perf.json --dump-dma-perf $(LOGS_DIR)/dma_$*_perf.json -o $(LOGS_DIR)/trace_hart_$*.txt

# Generate source-code interleaved traces for all harts. Reads the binary from
# the logs/.rtlbinary file that is written at start of simulation in the vsim script
BINARY ?= $(shell cat $(SIM_DIR)/.rtlbinary)
$(LOGS_DIR)/trace_hart_%.s: $(LOGS_DIR)/trace_hart_%.txt ${ANNOTATE_PY} $(SN_ANNOTATE_SRC)
	${ANNOTATE_PY} ${ANNOTATE_FLAGS} -o $@ $(BINARY) $<
$(LOGS_DIR)/trace_hart_%.diff: $(LOGS_DIR)/trace_hart_%.txt ${ANNOTATE_PY} $(SN_ANNOTATE_SRC)
	${ANNOTATE_PY} ${ANNOTATE_FLAGS} -o $@ $(BINARY) $< -d

$(JOINT_PERF_DUMP): $(PERF_DUMPS) $(JOIN_PY)
	$(JOIN_PY) -i $(shell ls $(LOGS_DIR)/*_perf.json) -o $@

$(ROI_DUMP): $(JOINT_PERF_DUMP) $(ROI_SPEC) $(ROI_PY)
	$(ROI_PY) $(JOINT_PERF_DUMP) $(ROI_SPEC) --cfg $(SN_CFG) -o $@

$(VISUAL_TRACE): $(ROI_DUMP) $(VISUALIZE_PY)
	$(VISUALIZE_PY) $(ROI_DUMP) $(VISUALIZE_PY_FLAGS) -o $@
