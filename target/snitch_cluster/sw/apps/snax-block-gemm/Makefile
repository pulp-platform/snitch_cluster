# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Ryan Antonio <ryan.antonio@esat.kuleuven.be>

APP     = snax-block-gemm
# SRCS    = src/snax-block-gemm.c
SRCS    = src/snax-block-gemm-no-contention.c
SRCS    += src/snax-gemm-lib.c
INCDIRS = data

include ../common.mk
include ./data/Makefile

$(DEP): $(DATA_H)