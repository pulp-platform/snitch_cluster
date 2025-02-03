# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

###############
# Executables #
###############

BENDER     	    ?= bender
REGGEN     	    ?= $(shell $(BENDER) path register_interface)/vendor/lowrisc_opentitan/util/regtool.py
CLUSTER_GEN	    ?= $(SNITCH_ROOT)/util/clustergen.py
CLUSTER_GEN_SRC ?= $(wildcard $(SNITCH_ROOT)/util/clustergen/*.py)

###################
# General targets #
###################

.PHONY: snitch-sw snitch-clean-sw

snitch-all: snitch-sw
snitch-clean: snitch-clean-sw

####################
# Platform headers #
####################

CLUSTER_GEN_HEADERS = snitch_cluster_cfg.h \
					  snitch_cluster_addrmap.h

REGGEN_HEADERS = snitch_cluster_peripheral.h

TARGET_C_HDRS_DIR ?= $(SNITCH_ROOT)/target/snitch_cluster/sw/runtime/common
TARGET_C_HDRS      = $(addprefix $(TARGET_C_HDRS_DIR)/,$(CLUSTER_GEN_HEADERS) $(REGGEN_HEADERS))

# CLUSTERGEN headers,
$(addprefix $(TARGET_C_HDRS_DIR)/,$(CLUSTER_GEN_HEADERS)): %.h: $(SNITCH_CFG) $(CLUSTER_GEN) $(CLUSTER_GEN) %.h.tpl
	@echo "[CLUSTERGEN] Generate $@"
	$(CLUSTER_GEN) -c $< --outdir $(TARGET_C_HDRS_DIR) --template $@.tpl

# REGGEN headers
$(TARGET_C_HDRS_DIR)/snitch_cluster_peripheral.h: $(SNITCH_ROOT)/hw/snitch_cluster/src/snitch_cluster_peripheral/snitch_cluster_peripheral_reg.hjson $(REGGEN)
	$(REGGEN) -D -o $@ $<

.PHONY: snitch-clean-headers
snitch-clean-sw: snitch-clean-headers
snitch-clean-headers:
	rm -f $(TARGET_C_HDRS)

##################
# Subdirectories #
##################

include $(SNITCH_ROOT)/target/snitch_cluster/sw/toolchain.mk
include $(SNITCH_ROOT)/target/snitch_cluster/sw/runtime/runtime.mk
include $(SNITCH_ROOT)/target/snitch_cluster/sw/tests/tests.mk

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

# Include Makefile from each app subdirectory
$(foreach app,$(APPS), \
	$(eval include $(app)/app.mk) \
)
