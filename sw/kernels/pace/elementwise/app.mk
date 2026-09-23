# Copyright 2026 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

PACE_ELEMENTWISE_SRC_DIR := $(SN_ROOT)/sw/kernels/pace/elementwise/src
PACE_ELEMENTWISE_SRCS    := $(PACE_ELEMENTWISE_SRC_DIR)/main.c
PACE_ELEMENTWISE_DATA_DIR := $(SN_ROOT)/sw/kernels/pace/elementwise/data

APP              := pace_elementwise
$(APP)_BUILD_DIR ?= $(SN_ROOT)/sw/kernels/pace/elementwise/build
SRC_DIR          := $(PACE_ELEMENTWISE_SRC_DIR)
SRCS             := $(PACE_ELEMENTWISE_SRCS)
include $(SN_ROOT)/sw/kernels/pace/common.mk

APP              := pace_elementwise_gelu_fp16_scalar
$(APP)_BUILD_DIR ?= $(SN_ROOT)/sw/kernels/pace/elementwise/build/gelu_fp16_scalar
$(APP)_DATA_CFG  ?= $(PACE_ELEMENTWISE_DATA_DIR)/params_gelu_fp16_scalar.json
SRC_DIR          := $(PACE_ELEMENTWISE_SRC_DIR)
SRCS             := $(PACE_ELEMENTWISE_SRCS)
include $(SN_ROOT)/sw/kernels/pace/common.mk

APP              := pace_elementwise_gelu_fp16_vector
$(APP)_BUILD_DIR ?= $(SN_ROOT)/sw/kernels/pace/elementwise/build/gelu_fp16_vector
$(APP)_DATA_CFG  ?= $(PACE_ELEMENTWISE_DATA_DIR)/params_gelu_fp16_vector.json
SRC_DIR          := $(PACE_ELEMENTWISE_SRC_DIR)
SRCS             := $(PACE_ELEMENTWISE_SRCS)
include $(SN_ROOT)/sw/kernels/pace/common.mk

APP              := pace_elementwise_gelu_fp32_scalar
$(APP)_BUILD_DIR ?= $(SN_ROOT)/sw/kernels/pace/elementwise/build/gelu_fp32_scalar
$(APP)_DATA_CFG  ?= $(PACE_ELEMENTWISE_DATA_DIR)/params_gelu_fp32_scalar.json
SRC_DIR          := $(PACE_ELEMENTWISE_SRC_DIR)
SRCS             := $(PACE_ELEMENTWISE_SRCS)
include $(SN_ROOT)/sw/kernels/pace/common.mk

APP              := pace_elementwise_gelu_fp32_vector
$(APP)_BUILD_DIR ?= $(SN_ROOT)/sw/kernels/pace/elementwise/build/gelu_fp32_vector
$(APP)_DATA_CFG  ?= $(PACE_ELEMENTWISE_DATA_DIR)/params_gelu_fp32_vector.json
SRC_DIR          := $(PACE_ELEMENTWISE_SRC_DIR)
SRCS             := $(PACE_ELEMENTWISE_SRCS)
include $(SN_ROOT)/sw/kernels/pace/common.mk

APP              := pace_elementwise_inv_fp16_scalar
$(APP)_BUILD_DIR ?= $(SN_ROOT)/sw/kernels/pace/elementwise/build/inv_fp16_scalar
$(APP)_DATA_CFG  ?= $(PACE_ELEMENTWISE_DATA_DIR)/params_inv_fp16_scalar.json
SRC_DIR          := $(PACE_ELEMENTWISE_SRC_DIR)
SRCS             := $(PACE_ELEMENTWISE_SRCS)
include $(SN_ROOT)/sw/kernels/pace/common.mk

APP              := pace_elementwise_inv_fp16_vector
$(APP)_BUILD_DIR ?= $(SN_ROOT)/sw/kernels/pace/elementwise/build/inv_fp16_vector
$(APP)_DATA_CFG  ?= $(PACE_ELEMENTWISE_DATA_DIR)/params_inv_fp16_vector.json
SRC_DIR          := $(PACE_ELEMENTWISE_SRC_DIR)
SRCS             := $(PACE_ELEMENTWISE_SRCS)
include $(SN_ROOT)/sw/kernels/pace/common.mk

APP              := pace_elementwise_inv_bfp16_vector
$(APP)_BUILD_DIR ?= $(SN_ROOT)/sw/kernels/pace/elementwise/build/inv_bfp16_vector
$(APP)_DATA_CFG  ?= $(PACE_ELEMENTWISE_DATA_DIR)/params_inv_bfp16_vector.json
SRC_DIR          := $(PACE_ELEMENTWISE_SRC_DIR)
SRCS             := $(PACE_ELEMENTWISE_SRCS)
include $(SN_ROOT)/sw/kernels/pace/common.mk

APP              := pace_elementwise_inv_fp32_scalar
$(APP)_BUILD_DIR ?= $(SN_ROOT)/sw/kernels/pace/elementwise/build/inv_fp32_scalar
$(APP)_DATA_CFG  ?= $(PACE_ELEMENTWISE_DATA_DIR)/params_inv_fp32_scalar.json
SRC_DIR          := $(PACE_ELEMENTWISE_SRC_DIR)
SRCS             := $(PACE_ELEMENTWISE_SRCS)
include $(SN_ROOT)/sw/kernels/pace/common.mk

APP              := pace_elementwise_inv_fp32_vector
$(APP)_BUILD_DIR ?= $(SN_ROOT)/sw/kernels/pace/elementwise/build/inv_fp32_vector
$(APP)_DATA_CFG  ?= $(PACE_ELEMENTWISE_DATA_DIR)/params_inv_fp32_vector.json
SRC_DIR          := $(PACE_ELEMENTWISE_SRC_DIR)
SRCS             := $(PACE_ELEMENTWISE_SRCS)
include $(SN_ROOT)/sw/kernels/pace/common.mk
