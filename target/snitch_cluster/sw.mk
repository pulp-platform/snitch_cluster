# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

###################
# General targets #
###################

.PHONY: sn-sw sn-clean-sw

sn-sw: sn-runtime sn-tests sn-apps
sn-clean-sw: sn-clean-runtime sn-clean-tests sn-clean-apps

####################
# Platform headers #
####################

SNRT_HAL_SRC_DIR   ?= $(SN_ROOT)/sw/runtime/impl/hal
SNRT_HAL_BUILD_DIR ?= $(SNRT_HAL_SRC_DIR)

SNITCH_CLUSTER_CFG_H                = $(SNRT_HAL_BUILD_DIR)/snitch_cluster_cfg.h
SNITCH_CLUSTER_ADDRMAP_H            = $(SNRT_HAL_BUILD_DIR)/snitch_cluster_addrmap.h
SNITCH_CLUSTER_RAW_ADDRMAP_H        = $(SNRT_HAL_BUILD_DIR)/snitch_cluster_raw_addrmap.h
SNITCH_CLUSTER_PERIPHERAL_H         = $(SNRT_HAL_BUILD_DIR)/snitch_cluster_peripheral.h
SNITCH_CLUSTER_PERIPHERAL_ADDRMAP_H = $(SNRT_HAL_BUILD_DIR)/snitch_cluster_peripheral_addrmap.h
SNITCH_CLUSTER_ADDRMAP_RDL          = $(SNRT_HAL_BUILD_DIR)/snitch_cluster_addrmap.rdl

SNITCH_CLUSTER_CFG_H_TPL       = $(SNRT_HAL_SRC_DIR)/snitch_cluster_cfg.h.tpl
SNITCH_CLUSTER_ADDRMAP_RDL_TPL = $(SNRT_HAL_SRC_DIR)/snitch_cluster_addrmap.rdl.tpl

SNRT_HAL_HDRS += $(SNITCH_CLUSTER_CFG_H)
SNRT_HAL_HDRS += $(SNITCH_CLUSTER_ADDRMAP_H)
SNRT_HAL_HDRS += $(SNITCH_CLUSTER_RAW_ADDRMAP_H)
SNRT_HAL_HDRS += $(SNITCH_CLUSTER_PERIPHERAL_H)
SNRT_HAL_HDRS += $(SNITCH_CLUSTER_PERIPHERAL_ADDRMAP_H)

# CLUSTERGEN rules
$(eval $(call sn_cluster_gen_rule,$(SNITCH_CLUSTER_CFG_H),$(SNITCH_CLUSTER_CFG_H_TPL)))
$(eval $(call sn_cluster_gen_rule,$(SNITCH_CLUSTER_ADDRMAP_RDL),$(SNITCH_CLUSTER_ADDRMAP_RDL_TPL)))

# peakrdl headers
SN_PEAKRDL_INCDIRS += -I $(SN_ROOT)/hw/snitch_cluster/src/snitch_cluster_peripheral
SN_PEAKRDL_INCDIRS += -I $(SN_GEN_DIR)
$(eval $(call peakrdl_generate_header_rule,$(SNITCH_CLUSTER_PERIPHERAL_H),$(SN_ROOT)/hw/snitch_cluster/src/snitch_cluster_peripheral/snitch_cluster_peripheral_reg.rdl))
$(eval $(call peakrdl_generate_header_rule,$(SNITCH_CLUSTER_ADDRMAP_H),$(SNITCH_CLUSTER_ADDRMAP_RDL),$(SN_PEAKRDL_INCDIRS)))
# Addrmap depends on generated cluster RDL
$(SNITCH_CLUSTER_ADDRMAP_H): $(SN_CLUSTER_RDL)

$(SNITCH_CLUSTER_RAW_ADDRMAP_H): $(SNITCH_CLUSTER_ADDRMAP_RDL) $(SN_CLUSTER_RDL)
	@echo "[peakrdl] Generating $@"
	$(PEAKRDL) raw-header $< -o $(SNITCH_CLUSTER_RAW_ADDRMAP_H) --base_name $(notdir $(basename $@)) --format c $(SN_PEAKRDL_INCDIRS)

$(SNITCH_CLUSTER_PERIPHERAL_ADDRMAP_H): $(SN_ROOT)/hw/snitch_cluster/src/snitch_cluster_peripheral/snitch_cluster_peripheral_reg.rdl
	@echo "[peakrdl] Generating $@"
	$(PEAKRDL) raw-header $< -o $(SNITCH_CLUSTER_PERIPHERAL_ADDRMAP_H) --format c $(SN_PEAKRDL_INCDIRS)


.PHONY: sn-clean-headers
sn-clean-sw: sn-clean-headers
sn-clean-headers:
	rm -f $(SNRT_HAL_HDRS) $(SNITCH_CLUSTER_ADDRMAP_RDL)

##################
# Subdirectories #
##################

include $(SN_ROOT)/target/snitch_cluster/sw/toolchain.mk
include $(SN_ROOT)/sw/runtime/runtime.mk
include $(SN_ROOT)/sw/tests/tests.mk
include $(SN_ROOT)/sw/riscv-tests/riscv-tests.mk

SNRT_BUILD_APPS ?= ON

ifeq ($(SNRT_BUILD_APPS), ON)
SNRT_APPS  = $(SN_ROOT)/target/snitch_cluster/sw/apps/nop
SNRT_APPS += $(SN_ROOT)/target/snitch_cluster/sw/apps/blas/axpy
SNRT_APPS += $(SN_ROOT)/target/snitch_cluster/sw/apps/blas/gemm
SNRT_APPS += $(SN_ROOT)/target/snitch_cluster/sw/apps/blas/gemv
SNRT_APPS += $(SN_ROOT)/target/snitch_cluster/sw/apps/blas/dot
SNRT_APPS += $(SN_ROOT)/target/snitch_cluster/sw/apps/blas/syrk
SNRT_APPS += $(SN_ROOT)/target/snitch_cluster/sw/apps/dnn/batchnorm
# SNRT_APPS += $(SN_ROOT)/target/snitch_cluster/sw/apps/dnn/conv2d
# SNRT_APPS += $(SN_ROOT)/target/snitch_cluster/sw/apps/dnn/fusedconv
SNRT_APPS += $(SN_ROOT)/target/snitch_cluster/sw/apps/dnn/gelu
SNRT_APPS += $(SN_ROOT)/target/snitch_cluster/sw/apps/dnn/layernorm
SNRT_APPS += $(SN_ROOT)/target/snitch_cluster/sw/apps/dnn/maxpool
SNRT_APPS += $(SN_ROOT)/target/snitch_cluster/sw/apps/dnn/softmax
SNRT_APPS += $(SN_ROOT)/target/snitch_cluster/sw/apps/dnn/flashattention_2
SNRT_APPS += $(SN_ROOT)/target/snitch_cluster/sw/apps/dnn/concat
SNRT_APPS += $(SN_ROOT)/target/snitch_cluster/sw/apps/dnn/fused_concat_linear
SNRT_APPS += $(SN_ROOT)/target/snitch_cluster/sw/apps/dnn/transpose
SNRT_APPS += $(SN_ROOT)/target/snitch_cluster/sw/apps/dnn/mha
SNRT_APPS += $(SN_ROOT)/target/snitch_cluster/sw/apps/montecarlo/pi_estimation
SNRT_APPS += $(SN_ROOT)/target/snitch_cluster/sw/apps/atax
SNRT_APPS += $(SN_ROOT)/target/snitch_cluster/sw/apps/correlation
SNRT_APPS += $(SN_ROOT)/target/snitch_cluster/sw/apps/covariance
SNRT_APPS += $(SN_ROOT)/target/snitch_cluster/sw/apps/doitgen
SNRT_APPS += $(SN_ROOT)/target/snitch_cluster/sw/apps/kmeans
SNRT_APPS += $(SN_ROOT)/target/snitch_cluster/sw/apps/exp
SNRT_APPS += $(SN_ROOT)/target/snitch_cluster/sw/apps/log
SNRT_APPS += $(SN_ROOT)/target/snitch_cluster/sw/apps/kbpcpa
SNRT_APPS += $(SN_ROOT)/target/snitch_cluster/sw/apps/box3d1r
SNRT_APPS += $(SN_ROOT)/target/snitch_cluster/sw/apps/j3d27pt
endif

# Include Makefile from each app subdirectory
$(foreach app,$(SNRT_APPS), \
	$(eval include $(app)/app.mk) \
)
