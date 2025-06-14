// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include <stddef.h>
#include <stdint.h>

// Forward declarations
#include "alloc_decls.h"
#include "cls_decls.h"
#include "dma_decls.h"
#include "riscv_decls.h"
#include "start_decls.h"
#include "sync_decls.h"
#include "team_decls.h"

// Snitch cluster specific
#include "snitch_cluster_defs.h"
#include "snitch_cluster_memory.h"

// Implementation
#include "alloc.h"
#include "alloc_v2.h"
#include "cls.h"
#include "cluster_interrupts.h"
#include "copift.h"
#include "dm.h"
#include "dma.h"
#include "dump.h"
#include "eu.h"
#include "kmp.h"
#include "omp.h"
#include "perf_cnt.h"
#include "printf.h"
#include "riscv.h"
#include "snitch_cluster_global_interrupts.h"
#include "snitch_cluster_start.h"
#include "ssr.h"
#include "sync.h"
#include "team.h"
#include "types.h"
