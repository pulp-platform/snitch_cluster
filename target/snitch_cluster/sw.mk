# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

###################
# General targets #
###################

.PHONY: sw clean-sw

all: sw
clean: clean-sw

####################
# Platform headers #
####################

SNRT_HAL_HDRS_DIR = $(ROOT)/target/snitch_cluster/sw/runtime/common

SNITCH_CLUSTER_CFG_H        = $(SNRT_HAL_HDRS_DIR)/snitch_cluster_cfg.h
SNITCH_CLUSTER_ADDRMAP_H    = $(SNRT_HAL_HDRS_DIR)/snitch_cluster_addrmap.h
SNITCH_CLUSTER_PERIPHERAL_H = $(SNRT_HAL_HDRS_DIR)/snitch_cluster_peripheral.h

SNRT_HAL_HDRS = $(SNITCH_CLUSTER_CFG_H) $(SNITCH_CLUSTER_ADDRMAP_H) $(SNITCH_CLUSTER_PERIPHERAL_H)

# CLUSTERGEN headers
$(eval $(call cluster_gen_rule,$(SNITCH_CLUSTER_CFG_H),$(SNITCH_CLUSTER_CFG_H).tpl))
$(eval $(call cluster_gen_rule,$(SNITCH_CLUSTER_ADDRMAP_H),$(SNITCH_CLUSTER_ADDRMAP_H).tpl))

# REGGEN headers
$(SNITCH_CLUSTER_PERIPHERAL_H): $(ROOT)/hw/snitch_cluster/src/snitch_cluster_peripheral/snitch_cluster_peripheral_reg.hjson $(REGGEN)
	$(call reggen_generate_header,$@,$<)

.PHONY: clean-headers
clean-sw: clean-headers
clean-headers:
	rm -f $(SNRT_HAL_HDRS)

##################
# Subdirectories #
##################

include sw/toolchain.mk
include sw/runtime/runtime.mk
include sw/tests/tests.mk

APPS  = sw/apps/nop
APPS += sw/apps/blas/axpy
APPS += sw/apps/blas/gemm
APPS += sw/apps/blas/gemv
APPS += sw/apps/blas/dot
APPS += sw/apps/blas/syrk
APPS += sw/apps/dnn/batchnorm
APPS += sw/apps/dnn/conv2d
APPS += sw/apps/dnn/fusedconv
APPS += sw/apps/dnn/gelu
APPS += sw/apps/dnn/layernorm
APPS += sw/apps/dnn/maxpool
APPS += sw/apps/dnn/softmax
APPS += sw/apps/dnn/flashattention_2
APPS += sw/apps/dnn/concat
APPS += sw/apps/dnn/fused_concat_linear
APPS += sw/apps/dnn/transpose
APPS += sw/apps/montecarlo/pi_estimation
APPS += sw/apps/atax
APPS += sw/apps/correlation
APPS += sw/apps/covariance
APPS += sw/apps/doitgen
APPS += sw/apps/kmeans
APPS += sw/apps/exp
APPS += sw/apps/log

# Include Makefile from each app subdirectory
$(foreach app,$(APPS), \
	$(eval include $(app)/app.mk) \
)
