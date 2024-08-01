# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

PI_ESTIMATION_DIR := $(ROOT)/sw/apps/montecarlo/pi_estimation
PRNG_DIR          := $(ROOT)/sw/apps/prng

APP              := pi_estimation
SRCS             := $(PI_ESTIMATION_DIR)/main.c
$(APP)_INCDIRS   := $(PI_ESTIMATION_DIR) $(PRNG_DIR)
$(APP)_BUILD_DIR ?= $(ROOT)/target/snitch_cluster/sw/apps/montecarlo/pi_estimation/build

include $(ROOT)/target/snitch_cluster/sw/apps/common.mk
