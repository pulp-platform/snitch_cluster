# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

APP                 := kmeans
$(APP)_BUILD_DIR    ?= $(SN_ROOT)/target/snitch_cluster/sw/apps/$(APP)/build
SRC_DIR             := $(SN_ROOT)/sw/apps/$(APP)/src
SRCS                := $(SRC_DIR)/main.c
$(APP)_DATAGEN_ARGS  = --no-gui

include $(SN_ROOT)/sw/apps/common.mk
include $(SN_ROOT)/target/snitch_cluster/sw/apps/common.mk
