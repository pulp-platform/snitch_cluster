# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

SUBDIRS  = lto
SUBDIRS += nop
SUBDIRS += blas/axpy
SUBDIRS += blas/gemm
SUBDIRS += sndnn/batchnorm
# SUBDIRS += sndnn/conv2d # fails with exit code 32
SUBDIRS += sndnn/fusedconv
SUBDIRS += sndnn/gelu
SUBDIRS += sndnn/gemm
# SUBDIRS += sndnn/layernorm # throws illegal instruction in simulation
SUBDIRS += sndnn/linear
SUBDIRS += sndnn/maxpool
# SUBDIRS += sndnn/softmax

.PHONY: all clean $(SUBDIRS)

all: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@ $(TARGET)
