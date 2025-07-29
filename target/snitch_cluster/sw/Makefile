# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

TARGET ?= all
SELECT_RUNTIME ?= rtl-generic

ifeq ($(SELECT_RUNTIME), banshee)
RUNTIME = runtime/banshee
else ifeq ($(SELECT_RUNTIME), rtl)
RUNTIME = runtime/rtl
else
RUNTIME = runtime/rtl-generic
endif

SUBDIRS += math $(RUNTIME) snax/mac apps tests

ifeq (${CFG_OVERRIDE}, cfg/snax_KUL_dse_cluster_3D.hjson)
SUBDIRS += snax/gemmx snax/data-reshuffler
endif
ifeq (${CFG_OVERRIDE}, cfg/snax_KUL_dse_cluster_2D.hjson)
SUBDIRS += snax/gemmx snax/data-reshuffler
endif
ifeq (${CFG_OVERRIDE}, cfg/snax_KUL_dse_cluster_1D.hjson)
SUBDIRS += snax/gemmx snax/data-reshuffler
endif
ifeq ($(CFG_OVERRIDE), cfg/snax_xdma_cluster.hjson)
SUBDIRS += snax/xdma
endif
ifeq ($(CFG_OVERRIDE), cfg/snax_KUL_cluster.hjson)
SUBDIRS += snax/xdma
endif

ifeq ($(CFG_OVERRIDE), cfg/snax_compiler_test_cluster.hjson)
SUBDIRS += snax/xdma
endif
ifeq ($(CFG_OVERRIDE), cfg/snax_versacore_cluster.hjson)

SUBDIRS += snax/versacore snax/xdma
endif
ifeq (${CFG_OVERRIDE}, cfg/snax_alu_cluster.hjson)
SUBDIRS += snax/snax-alu
endif

ifeq (${CFG_OVERRIDE}, cfg/snax_multi_alu_cluster.hjson)
SUBDIRS += snax/snax-alu
endif

ifeq (${CFG_OVERRIDE}, cfg/snax_hypercorex_cluster.hjson)
SUBDIRS += snax/hypercorex
endif

.PHONY: all $(SUBDIRS)

all: $(SUBDIRS)

# Explicit dependency of apps on runtime
apps: math $(RUNTIME) snax/snax-alu snax/mac snax/data-reshuffler snax/gemmx snax/versacore snax/xdma snax/hypercorex
	$(MAKE) -C $@ TARGET=$(TARGET)

# Explicit dependency of tests on runtime
tests: math $(RUNTIME) snax/snax-alu snax/mac snax/data-reshuffler snax/gemmx snax/versacore snax/xdma snax/hypercorex
	$(MAKE) -C $@ $(TARGET)

runtime/rtl runtime/banshee runtime/rtl-generic math snax/snax-alu snax/mac snax/data-reshuffler snax/gemmx snax/versacore snax/xdma snax/hypercorex:
	$(MAKE) -C $@ $(TARGET)
