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

SN_RUNTIME_SRCDIR ?= $(SN_ROOT)/sw/runtime/impl

SN_SNITCH_CLUSTER_CFG_H                = $(SN_RUNTIME_SRCDIR)/snitch_cluster_cfg.h
SN_SNITCH_CLUSTER_ADDRMAP_H            = $(SN_RUNTIME_SRCDIR)/snitch_cluster_addrmap.h
SN_SNITCH_CLUSTER_RAW_ADDRMAP_H        = $(SN_RUNTIME_SRCDIR)/snitch_cluster_raw_addrmap.h
SN_SNITCH_CLUSTER_PERIPHERAL_H         = $(SN_RUNTIME_SRCDIR)/snitch_cluster_peripheral.h
SN_SNITCH_CLUSTER_PERIPHERAL_ADDRMAP_H = $(SN_RUNTIME_SRCDIR)/snitch_cluster_peripheral_addrmap.h
SN_SNITCH_CLUSTER_ADDRMAP_RDL          = $(SN_RUNTIME_SRCDIR)/snitch_cluster_addrmap.rdl

SN_SNITCH_CLUSTER_CFG_H_TPL       = $(SN_RUNTIME_SRCDIR)/snitch_cluster_cfg.h.tpl
SN_SNITCH_CLUSTER_ADDRMAP_RDL_TPL = $(SN_RUNTIME_SRCDIR)/snitch_cluster_addrmap.rdl.tpl

SN_RUNTIME_HAL_HDRS += $(SN_SNITCH_CLUSTER_CFG_H)
SN_RUNTIME_HAL_HDRS += $(SN_SNITCH_CLUSTER_ADDRMAP_H)
SN_RUNTIME_HAL_HDRS += $(SN_SNITCH_CLUSTER_RAW_ADDRMAP_H)
SN_RUNTIME_HAL_HDRS += $(SN_SNITCH_CLUSTER_PERIPHERAL_H)
SN_RUNTIME_HAL_HDRS += $(SN_SNITCH_CLUSTER_PERIPHERAL_ADDRMAP_H)

# CLUSTERGEN rules
$(eval $(call sn_cluster_gen_rule,$(SN_SNITCH_CLUSTER_CFG_H),$(SN_SNITCH_CLUSTER_CFG_H_TPL)))
$(eval $(call sn_cluster_gen_rule,$(SN_SNITCH_CLUSTER_ADDRMAP_RDL),$(SN_SNITCH_CLUSTER_ADDRMAP_RDL_TPL)))

# peakrdl headers
SN_PEAKRDL_INCDIRS += -I $(SN_ROOT)/hw/snitch_cluster/src/snitch_cluster_peripheral
SN_PEAKRDL_INCDIRS += -I $(SN_GEN_DIR)
$(eval $(call sn_peakrdl_generate_header_rule,$(SN_SNITCH_CLUSTER_PERIPHERAL_H),$(SN_ROOT)/hw/snitch_cluster/src/snitch_cluster_peripheral/snitch_cluster_peripheral_reg.rdl))
$(eval $(call sn_peakrdl_generate_header_rule,$(SN_SNITCH_CLUSTER_ADDRMAP_H),$(SN_SNITCH_CLUSTER_ADDRMAP_RDL),$(SN_PEAKRDL_INCDIRS)))
# Addrmap depends on generated cluster RDL
$(SN_SNITCH_CLUSTER_ADDRMAP_H): $(SN_CLUSTER_RDL)

$(SN_SNITCH_CLUSTER_RAW_ADDRMAP_H): $(SN_SNITCH_CLUSTER_ADDRMAP_RDL) $(SN_CLUSTER_RDL)
	@echo "[peakrdl] Generating $@"
	$(SN_PEAKRDL) raw-header $< -o $(SN_SNITCH_CLUSTER_RAW_ADDRMAP_H) --base_name $(notdir $(basename $@)) --format c $(SN_PEAKRDL_INCDIRS)

$(SN_SNITCH_CLUSTER_PERIPHERAL_ADDRMAP_H): $(SN_ROOT)/hw/snitch_cluster/src/snitch_cluster_peripheral/snitch_cluster_peripheral_reg.rdl
	@echo "[peakrdl] Generating $@"
	$(SN_PEAKRDL) raw-header $< -o $(SN_SNITCH_CLUSTER_PERIPHERAL_ADDRMAP_H) --format c $(SN_PEAKRDL_INCDIRS)

.PHONY: sn-clean-headers
sn-clean-sw: sn-clean-headers
sn-clean-headers:
	rm -f $(SN_RUNTIME_HAL_HDRS) $(SN_SNITCH_CLUSTER_ADDRMAP_RDL)

##################
# Subdirectories #
##################

include $(SN_ROOT)/sw/toolchain.mk
include $(SN_ROOT)/sw/runtime/runtime.mk
include $(SN_ROOT)/sw/tests/tests.mk
include $(SN_ROOT)/sw/riscv-tests/riscv-tests.mk

SN_BUILD_APPS ?= ON

ifeq ($(SN_BUILD_APPS), ON)
SN_APPS += $(SN_ROOT)/sw/kernels/blas/axpy
SN_APPS += $(SN_ROOT)/sw/kernels/blas/gemm
SN_APPS += $(SN_ROOT)/sw/kernels/blas/gemv
SN_APPS += $(SN_ROOT)/sw/kernels/blas/dot
SN_APPS += $(SN_ROOT)/sw/kernels/blas/syrk
SN_APPS += $(SN_ROOT)/sw/kernels/dnn/batchnorm
# SN_APPS += $(SN_ROOT)/sw/kernels/dnn/conv2d
# SN_APPS += $(SN_ROOT)/sw/kernels/dnn/fusedconv
SN_APPS += $(SN_ROOT)/sw/kernels/dnn/gelu
SN_APPS += $(SN_ROOT)/sw/kernels/dnn/layernorm
SN_APPS += $(SN_ROOT)/sw/kernels/dnn/maxpool
SN_APPS += $(SN_ROOT)/sw/kernels/dnn/softmax
SN_APPS += $(SN_ROOT)/sw/kernels/dnn/flashattention_2
SN_APPS += $(SN_ROOT)/sw/kernels/dnn/concat
SN_APPS += $(SN_ROOT)/sw/kernels/dnn/fused_concat_linear
SN_APPS += $(SN_ROOT)/sw/kernels/dnn/transpose
SN_APPS += $(SN_ROOT)/sw/kernels/dnn/mha
SN_APPS += $(SN_ROOT)/sw/kernels/misc/montecarlo/pi_estimation
SN_APPS += $(SN_ROOT)/sw/kernels/misc/atax
SN_APPS += $(SN_ROOT)/sw/kernels/misc/correlation
SN_APPS += $(SN_ROOT)/sw/kernels/misc/covariance
SN_APPS += $(SN_ROOT)/sw/kernels/misc/doitgen
SN_APPS += $(SN_ROOT)/sw/kernels/misc/kmeans
SN_APPS += $(SN_ROOT)/sw/kernels/misc/exp
SN_APPS += $(SN_ROOT)/sw/kernels/misc/log
SN_APPS += $(SN_ROOT)/sw/kernels/misc/kbpcpa
SN_APPS += $(SN_ROOT)/sw/kernels/misc/box3d1r
SN_APPS += $(SN_ROOT)/sw/kernels/misc/j3d27pt
SN_APPS += $(SN_ROOT)/sw/kernels/misc/sort
endif

# Include Makefile from each app subdirectory
$(foreach app,$(SN_APPS), \
	$(eval include $(app)/app.mk) \
)
