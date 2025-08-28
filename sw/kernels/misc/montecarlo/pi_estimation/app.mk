# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

PI_ESTIMATION_DIR := $(SN_ROOT)/sw/kernels/misc/montecarlo/pi_estimation
PRNG_DIR          := $(SN_ROOT)/sw/kernels/misc/prng

APP              := pi_estimation
SRCS             := $(PI_ESTIMATION_DIR)/main.c
$(APP)_INCDIRS   := $(PI_ESTIMATION_DIR) $(PRNG_DIR)
$(APP)_BUILD_DIR ?= $(SN_ROOT)/sw/kernels/misc/montecarlo/pi_estimation/build

include $(SN_ROOT)/sw/kernels/common.mk
