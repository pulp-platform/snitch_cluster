# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

###############
# Executables #
###############

BENDER ?= bender
REGGEN ?= $(shell $(BENDER) path register_interface)/vendor/lowrisc_opentitan/util/regtool.py
SN_CLUSTER_GEN     ?= $(SN_ROOT)/util/clustergen.py
SN_CLUSTER_GEN_SRC ?= $(wildcard $(SN_ROOT)/util/clustergen/*.py)

###################
# General targets #
###################

.PHONY: snrt-all snrt-clean

snrt-all: snrt snrt-apps snrt-tests
snrt-clean: snrt-clean snrt-clean-apps snrt-clean-tests

####################
# Platform headers #
####################

SNRT_CLUSTER_GEN_HEADERS = snitch_cluster_cfg.h \
					               snitch_cluster_addrmap.h

SNRT_REGGEN_HEADERS = snitch_cluster_peripheral.h

SN_PERIPH_DIR           = $(SN_ROOT)/hw/snitch_cluster/src/snitch_cluster_peripheral
SNRT_TARGET_C_HDRS_DIR ?= $(SN_ROOT)/target/snitch_cluster/sw/runtime/common
SNRT_TARGET_C_HDRS      = $(addprefix $(SNRT_TARGET_C_HDRS_DIR)/,$(SNRT_CLUSTER_GEN_HEADERS) $(REGGEN_HEADERS))

# CLUSTERGEN headers,
$(addprefix $(SNRT_TARGET_C_HDRS_DIR)/,$(SNRT_CLUSTER_GEN_HEADERS)): %.h: $(SN_CFG) $(SN_CLUSTER_GEN) $(SN_CLUSTER_GEN_SRC) %.h.tpl
	@echo "[CLUSTERGEN] Generate $@"
	$(SN_CLUSTER_GEN) -c $< --outdir $(SNRT_TARGET_C_HDRS_DIR) --template $@.tpl

# REGGEN headers
SN_PERIPH_REG_CFG ?= $(SN_PERIPH_DIR)/snitch_cluster_peripheral_reg.hjson

$(SNRT_TARGET_C_HDRS_DIR)/snitch_cluster_peripheral.h: $(SN_ROOT)/hw/snitch_cluster/src/snitch_cluster_peripheral/snitch_cluster_peripheral_reg.hjson $(REGGEN)
	$(REGGEN) -D -o $@ $<

.PHONY: snrt-clean-headers
snrt-clean-sw: snrt-clean-headers
snrt-clean-headers:
	rm -f $(SNRT_TARGET_C_HDRS)

##################
# Subdirectories #
##################

include $(SN_ROOT)/target/snitch_cluster/sw/toolchain.mk
include $(SN_ROOT)/target/snitch_cluster/sw/runtime/runtime.mk
include $(SN_ROOT)/target/snitch_cluster/sw/tests/tests.mk

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

# Include Makefile from each app subdirectory
$(foreach app,$(SNRT_APPS), \
	$(eval include $(app)/app.mk) \
)
