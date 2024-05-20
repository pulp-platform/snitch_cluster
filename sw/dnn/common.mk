# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

include $(ROOT)/sw/apps/common.mk
$(APP)_INCDIRS += $(ROOT)/sw/dnn/src
$(APP)_INCDIRS += $(ROOT)/sw/blas
