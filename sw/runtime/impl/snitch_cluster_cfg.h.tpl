// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

<%
  for external_addr_region in cfg['external_addr_regions']:
    if external_addr_region['name'] == 'dram':
        dram = external_addr_region
%>

#include "snitch_cluster_raw_addrmap.h"

#define CFG_CLUSTER_NR_CORES ${cfg['cluster']['nr_cores']}
#define CFG_CLUSTER_BASE_HARTID ${cfg['cluster']['cluster_base_hartid']}
#define SNRT_BASE_HARTID CFG_CLUSTER_BASE_HARTID
#define SNRT_CLUSTER_CORE_NUM CFG_CLUSTER_NR_CORES
#define SNRT_CLUSTER_NUM ${cfg['nr_clusters']}
#define SNRT_CLUSTER_DM_CORE_NUM 1
#define SNRT_TCDM_BANK_WIDTH ${cfg['cluster']['data_width'] // 8}
#define SNRT_TCDM_BANK_NUM ${cfg['cluster']['tcdm']['banks']}
#define SNRT_TCDM_HYPERBANK_NUM ${cfg['cluster']['tcdm']['hyperbanks']}
#define SNRT_TCDM_BANK_PER_HYPERBANK_NUM ${cfg['cluster']['tcdm']['banks'] // cfg['cluster']['tcdm']['hyperbanks']}
#define SNRT_TCDM_SIZE ${hex(cfg['cluster']['tcdm']['size'] * 1024)}
#define SNRT_TCDM_HYPERBANK_SIZE ${hex(cfg['cluster']['tcdm']['size'] * 1024 // cfg['cluster']['tcdm']['hyperbanks'])}
#define SNRT_TCDM_HYPERBANK_WIDTH (SNRT_TCDM_BANK_PER_HYPERBANK_NUM * SNRT_TCDM_BANK_WIDTH)
#define SNRT_CLUSTER_OFFSET ${cfg['cluster']['cluster_base_offset']}
#define SNRT_NUM_SEQUENCER_LOOPS ${cfg['cluster']['hives'][0]['cores'][0]['num_sequencer_loops']}
#define SNRT_NUM_SEQUENCER_INSNS ${cfg['cluster']['hives'][0]['cores'][0]['num_sequencer_instructions']}
#define SNRT_L3_START_ADDR ${hex(dram['address'])}ULL
#define SNRT_L3_END_ADDR (SNRT_L3_START_ADDR + ${hex(dram['length'])}ULL)

% if cfg['cluster']['enable_multicast']:
#define SNRT_SUPPORTS_MULTICAST
% endif

// Software configuration
#define SNRT_LOG2_STACK_SIZE 10
