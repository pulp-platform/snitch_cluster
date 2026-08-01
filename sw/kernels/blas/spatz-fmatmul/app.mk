# Copyright 2026 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

APP              := spatz-fmatmul
$(APP)_BUILD_DIR ?= $(SN_ROOT)/sw/kernels/blas/$(APP)/build
SRC_DIR          := $(SN_ROOT)/sw/kernels/blas/$(APP)/src
SRCS             := $(SRC_DIR)/main.c

include $(SN_ROOT)/sw/kernels/datagen.mk
# For layer.h, shared with the other spatz-* kernels
$(APP)_INCDIRS += $(DATA_DIR)

include $(SN_ROOT)/sw/kernels/common.mk
