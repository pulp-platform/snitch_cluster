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

SNRT_SRCDIR ?= $(SN_ROOT)/sw/runtime/impl

SNITCH_CLUSTER_CFG_H                = $(SNRT_SRCDIR)/snitch_cluster_cfg.h
SNITCH_CLUSTER_ADDRMAP_H            = $(SNRT_SRCDIR)/snitch_cluster_addrmap.h
SNITCH_CLUSTER_RAW_ADDRMAP_H        = $(SNRT_SRCDIR)/snitch_cluster_raw_addrmap.h
SNITCH_CLUSTER_PERIPHERAL_H         = $(SNRT_SRCDIR)/snitch_cluster_peripheral.h
SNITCH_CLUSTER_PERIPHERAL_ADDRMAP_H = $(SNRT_SRCDIR)/snitch_cluster_peripheral_addrmap.h
SNITCH_CLUSTER_ADDRMAP_RDL          = $(SNRT_SRCDIR)/snitch_cluster_addrmap.rdl

SNITCH_CLUSTER_CFG_H_TPL       = $(SNRT_SRCDIR)/snitch_cluster_cfg.h.tpl
SNITCH_CLUSTER_ADDRMAP_RDL_TPL = $(SNRT_SRCDIR)/snitch_cluster_addrmap.rdl.tpl

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

include $(SN_ROOT)/sw/toolchain.mk
include $(SN_ROOT)/sw/runtime/runtime.mk
include $(SN_ROOT)/sw/tests/tests.mk
include $(SN_ROOT)/sw/riscv-tests/riscv-tests.mk

SNRT_BUILD_APPS ?= ON

ifeq ($(SNRT_BUILD_APPS), ON)
SNRT_APPS += $(SN_ROOT)/sw/kernels/blas/axpy
SNRT_APPS += $(SN_ROOT)/sw/kernels/blas/gemm
SNRT_APPS += $(SN_ROOT)/sw/kernels/blas/gemv
SNRT_APPS += $(SN_ROOT)/sw/kernels/blas/dot
SNRT_APPS += $(SN_ROOT)/sw/kernels/blas/syrk
SNRT_APPS += $(SN_ROOT)/sw/kernels/dnn/batchnorm
# SNRT_APPS += $(SN_ROOT)/sw/kernels/dnn/conv2d
# SNRT_APPS += $(SN_ROOT)/sw/kernels/dnn/fusedconv
SNRT_APPS += $(SN_ROOT)/sw/kernels/dnn/gelu
SNRT_APPS += $(SN_ROOT)/sw/kernels/dnn/layernorm
SNRT_APPS += $(SN_ROOT)/sw/kernels/dnn/maxpool
SNRT_APPS += $(SN_ROOT)/sw/kernels/dnn/softmax
SNRT_APPS += $(SN_ROOT)/sw/kernels/dnn/flashattention_2
SNRT_APPS += $(SN_ROOT)/sw/kernels/dnn/concat
SNRT_APPS += $(SN_ROOT)/sw/kernels/dnn/fused_concat_linear
SNRT_APPS += $(SN_ROOT)/sw/kernels/dnn/transpose
SNRT_APPS += $(SN_ROOT)/sw/kernels/dnn/mha
SNRT_APPS += $(SN_ROOT)/sw/kernels/misc/montecarlo/pi_estimation
SNRT_APPS += $(SN_ROOT)/sw/kernels/misc/atax
SNRT_APPS += $(SN_ROOT)/sw/kernels/misc/correlation
SNRT_APPS += $(SN_ROOT)/sw/kernels/misc/covariance
SNRT_APPS += $(SN_ROOT)/sw/kernels/misc/doitgen
SNRT_APPS += $(SN_ROOT)/sw/kernels/misc/kmeans
SNRT_APPS += $(SN_ROOT)/sw/kernels/misc/exp
SNRT_APPS += $(SN_ROOT)/sw/kernels/misc/log
SNRT_APPS += $(SN_ROOT)/sw/kernels/misc/kbpcpa
SNRT_APPS += $(SN_ROOT)/sw/kernels/misc/box3d1r
SNRT_APPS += $(SN_ROOT)/sw/kernels/misc/j3d27pt
endif

# Include Makefile from each app subdirectory
$(foreach app,$(SNRT_APPS), \
	$(eval include $(app)/app.mk) \
)
