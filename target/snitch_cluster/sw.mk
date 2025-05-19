# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

###################
# General targets #
###################

.PHONY: sn-sw sn-clean-sw

sn-sw: sn-runtime sn-tests
sn-clean-sw: sn-clean-runtime sn-clean-tests

####################
# Platform headers #
####################

SNRT_HAL_HDRS_DIR ?= $(SN_ROOT)/target/snitch_cluster/sw/runtime/common

SNITCH_CLUSTER_CFG_H        = $(SNRT_HAL_HDRS_DIR)/snitch_cluster_cfg.h
SNITCH_CLUSTER_ADDRMAP_H    = $(SNRT_HAL_HDRS_DIR)/snitch_cluster_addrmap.h
SNITCH_CLUSTER_PERIPHERAL_H = $(SNRT_HAL_HDRS_DIR)/snitch_cluster_peripheral.h

SNRT_HAL_HDRS = $(SNITCH_CLUSTER_CFG_H) $(SNITCH_CLUSTER_ADDRMAP_H) $(SNITCH_CLUSTER_PERIPHERAL_H)

# CLUSTERGEN headers
$(eval $(call sn_cluster_gen_rule,$(SNITCH_CLUSTER_CFG_H),$(SNITCH_CLUSTER_CFG_H).tpl))
$(eval $(call sn_cluster_gen_rule,$(SNITCH_CLUSTER_ADDRMAP_H),$(SNITCH_CLUSTER_ADDRMAP_H).tpl))

# peakrdl headers
$(SNITCH_CLUSTER_PERIPHERAL_H): $(SN_ROOT)/hw/snitch_cluster/src/snitch_cluster_peripheral/snitch_cluster_peripheral_reg.rdl
	$(call peakrdl_generate_header,$@,$<)

.PHONY: sn-clean-headers
sn-clean-sw: sn-clean-headers
sn-clean-headers:
	rm -f $(SNRT_HAL_HDRS)

##################
# Subdirectories #
##################

include $(SN_ROOT)/target/snitch_cluster/sw/toolchain.mk
include $(SN_ROOT)/target/snitch_cluster/sw/runtime/runtime.mk
include $(SN_ROOT)/target/snitch_cluster/sw/tests/tests.mk
include $(SN_ROOT)/target/snitch_cluster/sw/riscv-tests/riscv-tests.mk

SNRT_BUILD_APPS ?= ON

ifeq ($(SNRT_BUILD_APPS), ON)
SNRT_APPS  = sw/apps/nop
SNRT_APPS += sw/apps/blas/axpy
SNRT_APPS += sw/apps/blas/gemm
SNRT_APPS += sw/apps/blas/gemv
SNRT_APPS += sw/apps/blas/dot
SNRT_APPS += sw/apps/blas/syrk
SNRT_APPS += sw/apps/dnn/batchnorm
SNRT_APPS += sw/apps/dnn/conv2d
SNRT_APPS += sw/apps/dnn/fusedconv
SNRT_APPS += sw/apps/dnn/gelu
SNRT_APPS += sw/apps/dnn/layernorm
SNRT_APPS += sw/apps/dnn/maxpool
SNRT_APPS += sw/apps/dnn/softmax
SNRT_APPS += sw/apps/dnn/flashattention_2
SNRT_APPS += sw/apps/dnn/concat
SNRT_APPS += sw/apps/dnn/fused_concat_linear
SNRT_APPS += sw/apps/dnn/transpose
SNRT_APPS += sw/apps/montecarlo/pi_estimation
SNRT_APPS += sw/apps/atax
SNRT_APPS += sw/apps/correlation
SNRT_APPS += sw/apps/covariance
SNRT_APPS += sw/apps/doitgen
SNRT_APPS += sw/apps/kmeans
SNRT_APPS += sw/apps/exp
SNRT_APPS += sw/apps/log
SNRT_APPS += sw/apps/kbpcpa
SNRT_APPS += sw/apps/box3d1r
SNRT_APPS += sw/apps/j3d27pt

# Include Makefile from each app subdirectory
$(foreach app,$(SNRT_APPS), \
	$(eval include $(SN_ROOT)/target/snitch_cluster/$(app)/app.mk) \
)

sn-sw: sn-apps
sn-clean-sw: sn-clean-apps

endif
