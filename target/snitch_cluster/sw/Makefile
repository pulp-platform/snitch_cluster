# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

TARGET ?= all
SELECT_RUNTIME ?= rtl

ifeq ($(SELECT_RUNTIME), banshee)
RUNTIME = runtime/banshee
else
RUNTIME = runtime/rtl
endif

MATH = ../../../sw/math

SUBDIRS = runtime/banshee runtime/rtl $(MATH) apps tests

.PHONY: all $(SUBDIRS)

all: $(SUBDIRS)

# Explicit dependency of apps on runtime
apps: $(RUNTIME) $(MATH)
	$(MAKE) -C $@ TARGET=$(TARGET)

# Explicit dependency of tests on runtime
tests: $(RUNTIME) $(MATH)
	$(MAKE) -C $@ $(TARGET)

runtime/rtl runtime/banshee $(MATH):
	$(MAKE) -C $@ $(TARGET)
