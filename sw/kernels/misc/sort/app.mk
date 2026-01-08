# Copyright 2026 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

APP              := sort
SRCS             := $(SN_ROOT)/sw/kernels/misc/$(APP)/src/main.c
$(APP)_BUILD_DIR ?= $(SN_ROOT)/sw/kernels/misc/$(APP)/build

include $(SN_ROOT)/sw/kernels/datagen.mk
include $(SN_ROOT)/sw/kernels/common.mk
