// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "sndnn.h"

#include "batchnorm.c"
#include "batchnorm_layer.c"
#include "conv2d.c"
#include "conv2d_layer.c"
#include "gelu_layer.c"
#include "gemm.c"
#include "layernorm_layer.c"
#include "linear_layer.c"
#include "maxpool.c"
#include "maxpool_layer.c"
#include "snrt.h"
#include "utils.c"
// #include "nnlinear_backend_baseline.c"
// #include "softmax_layer.c"
