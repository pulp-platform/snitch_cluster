# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

MK_TARGET ?= all
SELECT_RUNTIME ?= rtl

ifeq ($(SELECT_RUNTIME), banshee)
RUNTIME = sw/runtime/banshee
else
RUNTIME = sw/runtime/rtl
endif

####################
# Platform headers #
####################

CLUSTER_GEN_HEADERS = snitch_cluster_cfg.h \
					  snitch_cluster_addrmap.h

REGGEN_HEADERS = snitch_cluster_peripheral.h

TARGET_C_HDRS_DIR = sw/runtime/common
TARGET_C_HDRS     = $(addprefix $(TARGET_C_HDRS_DIR)/,$(CLUSTER_GEN_HEADERS) $(REGGEN_HEADERS))

# CLUSTERGEN headers
$(addprefix $(TARGET_C_HDRS_DIR)/,$(CLUSTER_GEN_HEADERS)): %.h: $(CFG) $(CLUSTER_GEN_PREREQ) %.h.tpl
	@echo "[CLUSTERGEN] Generate $@"
	$(CLUSTER_GEN) -c $< --outdir $(TARGET_C_HDRS_DIR) --template $@.tpl

# REGGEN headers
$(TARGET_C_HDRS_DIR)/snitch_cluster_peripheral.h: $(ROOT)/hw/snitch_cluster/src/snitch_cluster_peripheral/snitch_cluster_peripheral_reg.hjson $(REGGEN)
	$(call reggen_generate_header,$@,$<)

########
# Apps #
########

APPS  = sw/apps/lto
APPS += sw/apps/nop
APPS += sw/apps/blas/axpy
APPS += sw/apps/blas/gemm
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

SUBDIRS = sw/runtime/banshee sw/runtime/rtl $(APPS) sw/tests

.PHONY: sw clean-sw $(SUBDIRS)

sw: $(SUBDIRS)
clean-sw:
	$(MAKE) sw MK_TARGET=clean
	rm -f $(TARGET_C_HDRS)

# Runtime libraries depend on platform headers
sw/runtime/rtl sw/runtime/banshee: $(TARGET_C_HDRS)
	$(MAKE) -C $@ $(MK_TARGET)

# Apps depend on runtime libraries
$(APPS) sw/tests: $(RUNTIME)
	$(MAKE) -C $@ $(MK_TARGET)
