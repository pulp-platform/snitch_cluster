# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

APP              := gelu
$(APP)_BUILD_DIR ?= $(SN_ROOT)/sw/dnn/$(APP)/build
SRC_DIR          := $(SN_ROOT)/sw/dnn/$(APP)/src
SRCS             := $(SRC_DIR)/main.c

include $(SN_ROOT)/sw/dnn/common.mk
