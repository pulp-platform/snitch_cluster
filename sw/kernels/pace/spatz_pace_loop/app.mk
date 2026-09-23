# Copyright 2026 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

APP              := spatz_pace_loop
$(APP)_BUILD_DIR ?= $(SN_ROOT)/sw/kernels/pace/$(APP)/build
SRC_DIR          := $(SN_ROOT)/sw/kernels/pace/$(APP)/src
SRCS             := $(SRC_DIR)/main.c

$(APP)_SCRIPT_DIR ?= $(SN_ROOT)/sw/kernels/pace/elementwise/scripts

ifneq ($(PACE_DEGREE),)
$(APP)_RISCV_CFLAGS += -DPACE_CSR_DEGREE=$(PACE_DEGREE)
endif

include $(SN_ROOT)/sw/kernels/pace/common.mk

APP              := spatz_pace_loop_pwpa_fp16
$(APP)_BUILD_DIR ?= $(SN_ROOT)/sw/kernels/pace/spatz_pace_loop/build/pwpa_fp16
$(APP)_DATA_CFG  ?= $(SN_ROOT)/sw/kernels/pace/spatz_pace_loop/data/params_fp16.json
SRC_DIR          := $(SN_ROOT)/sw/kernels/pace/spatz_pace_loop/src
SRCS             := $(SRC_DIR)/main.c

$(APP)_SCRIPT_DIR ?= $(SN_ROOT)/sw/kernels/pace/elementwise/scripts

ifneq ($(PACE_DEGREE),)
$(APP)_RISCV_CFLAGS += -DPACE_CSR_DEGREE=$(PACE_DEGREE)
endif

include $(SN_ROOT)/sw/kernels/pace/common.mk

APP              := spatz_pace_loop_pwpa_bfp16
$(APP)_BUILD_DIR ?= $(SN_ROOT)/sw/kernels/pace/spatz_pace_loop/build/pwpa_bfp16
$(APP)_DATA_CFG  ?= $(SN_ROOT)/sw/kernels/pace/spatz_pace_loop/data/params_bfp16.json
SRC_DIR          := $(SN_ROOT)/sw/kernels/pace/spatz_pace_loop/src
SRCS             := $(SRC_DIR)/main.c

$(APP)_SCRIPT_DIR ?= $(SN_ROOT)/sw/kernels/pace/elementwise/scripts

ifneq ($(PACE_DEGREE),)
$(APP)_RISCV_CFLAGS += -DPACE_CSR_DEGREE=$(PACE_DEGREE)
endif

include $(SN_ROOT)/sw/kernels/pace/common.mk
