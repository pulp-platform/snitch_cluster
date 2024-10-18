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
SUBDIRS += snax-mac-mult
ifeq ($(CFG_OVERRIDE), cfg/snax_alu.hjson)
SUBDIRS += snax-alu
endif
ifeq ($(CFG_OVERRIDE), cfg/snax_kul_cluster_mixed_narrow_wide.hjson)
SUBDIRS += snax-data-reshuffler
SUBDIRS += snax-gemmx-matmul
SUBDIRS += snax-gemmx-conv
endif
ifeq ($(CFG_OVERRIDE), cfg/snax_kul_cluster_mixed_narrow_wide_xdma.hjson)
SUBDIRS += snax-gemmx-matmul
SUBDIRS += snax-gemmx-conv
SUBDIRS += snax-xdma-memset
SUBDIRS += snax-xdma-maxpool
endif
SUBDIRS += snax-multi-cluster-playground
ifeq ($(CFG_OVERRIDE), cfg/snax_hypercorex.hjson)
SUBDIRS += snax-hypercorex/test-csr
SUBDIRS += snax-hypercorex/char-recog
endif

.PHONY: all clean $(SUBDIRS)

all: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@ $(TARGET)
