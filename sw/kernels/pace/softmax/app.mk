# Copyright 2026 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

APP              := pace_softmax
$(APP)_BUILD_DIR ?= $(SN_ROOT)/sw/kernels/pace/softmax/build
SRC_DIR          := $(SN_ROOT)/sw/kernels/pace/softmax/src
SRCS             := $(SRC_DIR)/main.c

include $(SN_ROOT)/sw/kernels/pace/common.mk
