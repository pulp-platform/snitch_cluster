# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

SUBDIRS  = lto
SUBDIRS += nop
# Tests below don't work with the generic runtime
ifneq ($(filter $(SELECT_RUNTIME),rtl banshee),)
SUBDIRS += blas/axpy
SUBDIRS += blas/gemm
SUBDIRS += dnn/batchnorm
SUBDIRS += dnn/conv2d
SUBDIRS += dnn/fusedconv
SUBDIRS += dnn/gelu
SUBDIRS += dnn/gemm
SUBDIRS += dnn/layernorm
SUBDIRS += dnn/linear
SUBDIRS += dnn/maxpool
SUBDIRS += dnn/softmax
endif
SUBDIRS += montecarlo/pi_estimation
SUBDIRS += snax-mac
SUBDIRS += snax-mac-simple/untiled
SUBDIRS += snax-mac-simple/tiled
ifeq ($(CFG_OVERRIDE), cfg/snax_alu_cluster.hjson)
SUBDIRS += snax-alu
endif
ifeq ($(CFG_OVERRIDE), cfg/snax_multi_alu_cluster.hjson)
SUBDIRS += snax-alu
SUBDIRS += snax-multi-alu
endif
ifeq ($(CFG_OVERRIDE), cfg/snax_KUL_dse_cluster_3D.hjson)
SUBDIRS += snax-data-reshuffler
SUBDIRS += snax-gemmx-matmul
SUBDIRS += snax-gemmx-conv
endif
ifeq ($(CFG_OVERRIDE), cfg/snax_KUL_dse_cluster_2D.hjson)
SUBDIRS += snax-data-reshuffler
SUBDIRS += snax-gemmx-matmul
endif
ifeq ($(CFG_OVERRIDE), cfg/snax_KUL_dse_cluster_1D.hjson)
SUBDIRS += snax-data-reshuffler
SUBDIRS += snax-gemmx-matmul
SUBDIRS += snax-gemmx-conv
endif
ifeq ($(CFG_OVERRIDE), cfg/snax_xdma_cluster.hjson)
SUBDIRS += snax-xdma-memset
SUBDIRS += snax-xdma-maxpool
SUBDIRS += snax-xdma-transpose
SUBDIRS += snax-xdma-reshape-comparison
endif
ifeq ($(CFG_OVERRIDE), cfg/snax_KUL_cluster.hjson)
SUBDIRS += snax-xdma-memset
SUBDIRS += snax-xdma-maxpool
SUBDIRS += snax-xdma-transpose
SUBDIRS += snax-xdma-reshape-comparison
endif
ifeq ($(CFG_OVERRIDE), cfg/snax_compiler_test_cluster.hjson)
SUBDIRS += snax-xdma-memset
SUBDIRS += snax-xdma-maxpool
SUBDIRS += snax-xdma-transpose
SUBDIRS += snax-xdma-reshape-comparison
SUBDIRS += snax-xdma-elementwise-add
SUBDIRS += snax-xdma-rescale-down
endif
ifeq ($(CFG_OVERRIDE), cfg/snax_versacore_cluster.hjson)
SUBDIRS += snax-versacore-matmul
SUBDIRS += snax-xdma-memset
SUBDIRS += snax-xdma-maxpool
SUBDIRS += snax-xdma-transpose
SUBDIRS += snax-xdma-reshape-comparison
endif
SUBDIRS += snax-multi-cluster-playground
ifeq ($(CFG_OVERRIDE), cfg/snax_hypercorex_cluster.hjson)
SUBDIRS += snax-hypercorex/test-csr
SUBDIRS += snax-hypercorex/char-recog
SUBDIRS += snax-hypercorex/high-dim-bind
SUBDIRS += snax-hypercorex/am-search
SUBDIRS += snax-hypercorex/isolet-recog
SUBDIRS += snax-hypercorex/ucihar-recog
SUBDIRS += snax-hypercorex/digit-recog
SUBDIRS += snax-hypercorex/dna-recog
SUBDIRS += snax-hypercorex/lang-recog
SUBDIRS += snax-hypercorex/vec-compress
endif


.PHONY: all clean $(SUBDIRS)

all: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@ $(TARGET)
