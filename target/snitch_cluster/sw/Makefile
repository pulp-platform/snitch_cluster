# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

TARGET ?= all
SELECT_RUNTIME ?= rtl

ifeq ($(SELECT_RUNTIME), banshee)
RUNTIME = runtime/banshee
else ifeq ($(SELECT_RUNTIME), rtl-generic)
RUNTIME = runtime/rtl-generic
else
RUNTIME = runtime/rtl
endif

SUBDIRS += $(RUNTIME) snax/mac snax/gemm snax/streamer-gemm snax/streamer-simd math apps tests

.PHONY: all $(SUBDIRS)

all: $(SUBDIRS)

# Explicit dependency of apps on runtime
apps: $(RUNTIME) math snax/mac snax/gemm snax/streamer-gemm snax/streamer-simd
	$(MAKE) -C $@ TARGET=$(TARGET)

# Explicit dependency of tests on runtime
tests: $(RUNTIME) math snax/mac snax/gemm snax/streamer-gemm snax/streamer-simd
	$(MAKE) -C $@ $(TARGET)

runtime/rtl runtime/banshee runtime/rtl-generic math snax/mac snax/gemm snax/streamer-gemm snax/streamer-simd:
	$(MAKE) -C $@ $(TARGET)
