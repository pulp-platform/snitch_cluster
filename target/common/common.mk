# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Makefile invocation
DEBUG ?= OFF  # ON to turn on wave logging

# Directories
SIM_DIR  ?= $(shell pwd)
TB_DIR   ?= $(SN_ROOT)/target/common/test
UTIL_DIR ?= $(SN_ROOT)/util
LOGS_DIR  = $(SIM_DIR)/logs

# External executables
VERIBLE_FMT  ?= verible-verilog-format
CLANG_FORMAT ?= clang-format
RISCV_MC     ?= $(LLVM_BINROOT)/llvm-mc
ADDR2LINE    ?= $(LLVM_BINROOT)/llvm-addr2line

# Internal executables
GENTRACE_PY      ?= $(UTIL_DIR)/trace/gen_trace.py
ANNOTATE_PY      ?= $(UTIL_DIR)/trace/annotate.py
EVENTS_PY        ?= $(UTIL_DIR)/trace/events.py
JOIN_PY          ?= $(UTIL_DIR)/bench/join.py
ROI_PY           ?= $(UTIL_DIR)/bench/roi.py
VISUALIZE_PY     ?= $(UTIL_DIR)/bench/visualize.py

MATCH_END := '/+incdir+/ s/$$/\/*\/*/'
MATCH_BGN := 's/+incdir+//g'
MATCH_DEF := '/+define+/d'
SED_SRCS  := sed -e ${MATCH_END} -e ${MATCH_BGN} -e ${MATCH_DEF}

COMMON_BENDER_FLAGS += -t rtl -t snitch_cluster
COMMON_SIM_BENDER_FLAGS += -t simulation -t test

# fesvr is being installed here
FESVR         ?= ${MKFILE_DIR}work
FESVR_VERSION ?= 35d50bc40e59ea1d5566fbd3d9226023821b1bb6

RISCV_MC_FLAGS      ?= -disassemble -mcpu=snitch
ANNOTATE_FLAGS      ?= -q --keep-time --addr2line=$(ADDR2LINE)
LAYOUT_EVENTS_FLAGS ?= --cfg=$(CFG)

#################
# Prerequisites #
#################
# Eventually it could be an option to package this statically using musl libc.
work/${FESVR_VERSION}_unzip:
	mkdir -p $(dir $@)
	wget -O $(dir $@)/${FESVR_VERSION} https://github.com/riscv/riscv-isa-sim/tarball/${FESVR_VERSION}
	tar xfm $(dir $@)${FESVR_VERSION} --strip-components=1 -C $(dir $@)
	touch $@

work/lib/libfesvr.a: work/${FESVR_VERSION}_unzip
	cd $(dir $<)/ && ./configure --prefix `pwd`
	make -C $(dir $<) install-config-hdrs install-hdrs libfesvr.a
	mkdir -p $(dir $@)
	cp $(dir $<)libfesvr.a $@

# Build fesvr seperately for verilator since this might use different compilers
# and libraries than modelsim/vcs and
$(VLT_FESVR)/${FESVR_VERSION}_unzip:
	mkdir -p $(dir $@)
	wget -O $(dir $@)/${FESVR_VERSION} https://github.com/riscv/riscv-isa-sim/tarball/${FESVR_VERSION}
	tar xfm $(dir $@)${FESVR_VERSION} --strip-components=1 -C $(dir $@)
	patch $(VLT_FESVR)/fesvr/context.h < patches/context.h.diff
	touch $@

$(VLT_BUILDDIR)/lib/libfesvr.a: $(VLT_FESVR)/${FESVR_VERSION}_unzip
	cd $(dir $<)/ && ./configure --prefix `pwd` \
        CC=${CC} CXX=${CXX} CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}"
	$(MAKE) -C $(dir $<) install-config-hdrs install-hdrs libfesvr.a
	mkdir -p $(dir $@)
	cp $(dir $<)libfesvr.a $@

########
# Util #
########

# Common rule to generate C header with REGGEN
# $1: target name, $2: prerequisite (hjson description file)
define reggen_generate_header
	@echo "[REGGEN] Generating $1"
	@$(REGGEN) -D -o $1 $2
	@$(CLANG_FORMAT) -i $1
endef

# Arg 1: binary
# Arg 2: max size in bytes
define BINARY_SIZE_CHECK
  echo "Binary size: $$(stat -c %s $(1))B"
  @[ "$$(stat -c %s $(1))" -lt "$(2)" ] || (echo "Binary exceeds specified size of $(2)B"; exit 1)
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

$(addprefix $(LOGS_DIR)/,trace_hart_%.txt hart_%_perf.json dma_%_perf.json): $(LOGS_DIR)/trace_hart_%.dasm $(GENTRACE_PY)
	$(GENTRACE_PY) $< --mc-exec $(RISCV_MC) --mc-flags "$(RISCV_MC_FLAGS)" --permissive --dma-trace $(SIM_DIR)/dma_trace_$*_00000.log --dump-hart-perf $(LOGS_DIR)/hart_$*_perf.json --dump-dma-perf $(LOGS_DIR)/dma_$*_perf.json -o $(LOGS_DIR)/trace_hart_$*.txt

# Generate source-code interleaved traces for all harts. Reads the binary from
# the logs/.rtlbinary file that is written at start of simulation in the vsim script
BINARY ?= $(shell cat $(SIM_DIR)/.rtlbinary)
$(LOGS_DIR)/trace_hart_%.s: $(LOGS_DIR)/trace_hart_%.txt ${ANNOTATE_PY}
	${ANNOTATE_PY} ${ANNOTATE_FLAGS} -o $@ $(BINARY) $<
$(LOGS_DIR)/trace_hart_%.diff: $(LOGS_DIR)/trace_hart_%.txt ${ANNOTATE_PY}
	${ANNOTATE_PY} ${ANNOTATE_FLAGS} -o $@ $(BINARY) $< -d

$(JOINT_PERF_DUMP): $(PERF_DUMPS) $(JOIN_PY)
	$(JOIN_PY) -i $(shell ls $(LOGS_DIR)/*_perf.json) -o $@

$(ROI_DUMP): $(JOINT_PERF_DUMP) $(ROI_SPEC) $(ROI_PY)
	$(ROI_PY) $(JOINT_PERF_DUMP) $(ROI_SPEC) --cfg $(CFG) -o $@

$(VISUAL_TRACE): $(ROI_DUMP) $(VISUALIZE_PY)
	$(VISUALIZE_PY) $(ROI_DUMP) $(VISUALIZE_PY_FLAGS) -o $@
