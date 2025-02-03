# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

APP              := exp
SRCS             := $(SN_ROOT)/sw/apps/$(APP)/main.c
$(APP)_BUILD_DIR ?= $(SN_ROOT)/target/snitch_cluster/sw/apps/$(APP)/build

include $(SN_ROOT)/target/snitch_cluster/sw/apps/common.mk
