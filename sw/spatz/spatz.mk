# Copyright 2025 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Spatz benchmark kernels. Each entry points to a directory containing app.mk.
SN_APPS += $(SN_ROOT)/sw/spatz/dp-faxpy
# TODO: port remaining kernels once dp-faxpy compiles cleanly
# SN_APPS += $(SN_ROOT)/sw/spatz/dp-fconv2d
# SN_APPS += $(SN_ROOT)/sw/spatz/dp-fdotp
# SN_APPS += $(SN_ROOT)/sw/spatz/dp-fft
SN_APPS += $(SN_ROOT)/sw/spatz/dp-fmatmul
# SN_APPS += $(SN_ROOT)/sw/spatz/gemv
# SN_APPS += $(SN_ROOT)/sw/spatz/hp-fmatmul
# SN_APPS += $(SN_ROOT)/sw/spatz/sa-gemv
# SN_APPS += $(SN_ROOT)/sw/spatz/sdotp-bp-fmatmul
# SN_APPS += $(SN_ROOT)/sw/spatz/sdotp-hp-fmatmul
# SN_APPS += $(SN_ROOT)/sw/spatz/sp-fft
SN_APPS += $(SN_ROOT)/sw/spatz/sp-fmatmul

# Add the standalone Spatz smoke test to the test suite
SN_TESTS += $(SN_ROOT)/sw/spatz/src/spatz_test.c
