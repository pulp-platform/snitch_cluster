# Copyright 2026 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

PACE_ELEMENTWISE_SRC_DIR := $(SN_ROOT)/sw/kernels/pace/elementwise/src
PACE_ELEMENTWISE_SRCS    := $(PACE_ELEMENTWISE_SRC_DIR)/main.c
PACE_ELEMENTWISE_DATA_DIR := $(SN_ROOT)/sw/kernels/pace/elementwise/data

APP              := pace_elementwise
$(APP)_BUILD_DIR ?= $(SN_ROOT)/sw/kernels/pace/elementwise/build
$(APP)_DATA_CFG  ?= $(PACE_ELEMENTWISE_DATA_DIR)/params.json
SRC_DIR          := $(PACE_ELEMENTWISE_SRC_DIR)
SRCS             := $(PACE_ELEMENTWISE_SRCS)
include $(SN_ROOT)/sw/kernels/datagen.mk
$(APP)_INCDIRS += $(SN_ROOT)/sw/kernels/pace/common
include $(SN_ROOT)/sw/kernels/common.mk
