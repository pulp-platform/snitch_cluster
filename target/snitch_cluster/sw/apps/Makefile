# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

SUBDIRS  = lto
SUBDIRS += nop
# Tests below don't work with the generic runtime
ifneq ($(SELECT_RUNTIME), rtl-generic)
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
SUBDIRS += snax-gemm-engine
SUBDIRS += snax-gemm-base
SUBDIRS += snax-block-gemm
SUBDIRS += snax-streamer-gemm
SUBDIRS += snax-streamer-simd
SUBDIRS += snax-mac-mult
SUBDIRS += snax-alu
SUBDIRS += snax-data-reshuffler
SUBDIRS += snax-streamer-gemm-conv

.PHONY: all clean $(SUBDIRS)

all: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@ $(TARGET)
