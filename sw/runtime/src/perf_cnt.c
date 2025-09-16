// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

extern void perf_regs_t* snrt_perf_counters();

extern void snrt_cfg_perf_counter(uint32_t perf_cnt, uint16_t metric,
                                  uint16_t hart);

extern void snrt_start_perf_counter(uint32_t perf_cnt);

extern void snrt_stop_perf_counter(uint32_t perf_cnt);

extern void snrt_reset_perf_counter(uint32_t perf_cnt);

extern uint32_t snrt_get_perf_counter(uint32_t perf_cnt);
