# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Andrea Belano <andrea.belano2@unibo.it>

APP              := redmule
$(APP)_BUILD_DIR := $(SN_ROOT)/target/snitch_cluster/sw/apps/$(APP)/build
SRCS             := $(SN_ROOT)/target/snitch_cluster/sw/apps/$(APP)/src/$(APP).c
$(APP)_INCDIRS   := $(SN_ROOT)/target/snitch_cluster/sw/apps/$(APP)/data

include $(SN_ROOT)/target/snitch_cluster/sw/apps/common.mk
