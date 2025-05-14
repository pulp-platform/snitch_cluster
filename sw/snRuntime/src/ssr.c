// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

extern void snrt_fpu_fence();

extern void snrt_ssr_enable();

extern void snrt_ssr_disable();

extern void snrt_sc_enable(uint32_t mask);

extern void snrt_sc_disable(uint32_t mask);
