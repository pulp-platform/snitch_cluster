# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

APP              := log
SRCS             := $(SN_ROOT)/sw/kernels/misc/$(APP)/main.c
$(APP)_BUILD_DIR ?= $(SN_ROOT)/sw/kernels/misc/$(APP)/build

include $(SN_ROOT)/sw/kernels/common.mk
