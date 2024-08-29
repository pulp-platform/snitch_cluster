# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

APP              := doitgen
$(APP)_BUILD_DIR ?= $(ROOT)/target/snitch_cluster/sw/apps/$(APP)/build
SRC_DIR          := $(ROOT)/sw/apps/$(APP)/src
SRCS             := $(SRC_DIR)/main.c
$(APP)_INCDIRS   := $(ROOT)/sw/blas/

include $(ROOT)/sw/apps/common.mk
include $(ROOT)/target/snitch_cluster/sw/apps/common.mk
