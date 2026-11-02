# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

include $(SN_ROOT)/sw/kernels/datagen.mk
$(APP)_INCDIRS += $(SN_ROOT)/sw/kernels/pace/common
$(APP)_INCDIRS += $(SN_ROOT)/sw/kernels/pace/pwpa
$(APP)_INCDIRS += $(SN_ROOT)/sw/kernels/pace/pace_softmax
$(APP)_RISCV_CFLAGS += -Xclang -target-feature -Xclang +xpace
# $(APP)_INCDIRS += $(SN_ROOT)/sw/kernels/blas
include $(SN_ROOT)/sw/kernels/common.mk
