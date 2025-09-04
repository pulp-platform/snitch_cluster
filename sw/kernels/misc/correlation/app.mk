# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

APP              := correlation
$(APP)_BUILD_DIR ?= $(SN_ROOT)/sw/kernels/misc/$(APP)/build
SRC_DIR          := $(SN_ROOT)/sw/kernels/misc/$(APP)/src
SRCS             := $(SRC_DIR)/main.c

include $(SN_ROOT)/sw/kernels/datagen.mk
include $(SN_ROOT)/sw/kernels/common.mk
