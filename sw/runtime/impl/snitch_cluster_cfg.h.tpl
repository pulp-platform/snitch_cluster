// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

<%
  for external_addr_region in cfg['external_addr_regions']:
    if external_addr_region['name'] == 'dram':
        dram = external_addr_region
%>

<%
  supports_dma = False
  supports_ssr = False
  supports_frep = False
  supports_copift = False
  supports_pulp = False
  pulp_subextensions = [
    'xpulppostmod',
    'xpulpabs',
    'xpulpbitop',
    'xpulpbr',
    'xpulpclip',
    'xpulpmacsi',
    'xpulpminmax',
    'xpulpslet',
    'xpulpvect',
    'xpulpvectshufflepack',
  ]
  for hive in cfg['cluster']['hives']:
    for core in hive['cores']:
      supports_dma = supports_dma or core['xdma']
      supports_ssr = supports_ssr or core['xssr']
      supports_frep = supports_frep or core['xfrep']
      supports_copift = supports_copift or core['xcopift']
      supports_pulp = supports_pulp or any([core[ext] for ext in pulp_subextensions])
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

#define SNRT_COLLECTIVE_OPCODE_WIDTH ${cfg['cluster']['collective_width']}

% if cfg['cluster']['enable_narrow_collectives']:
#define SNRT_SUPPORTS_NARROW_MULTICAST
#define SNRT_SUPPORTS_NARROW_REDUCTION
% endif

% if supports_dma:
#define SNRT_SUPPORTS_DMA
% endif

% if supports_ssr:
#define SNRT_SUPPORTS_SSR
% endif

% if supports_frep:
#define SNRT_SUPPORTS_FREP
% endif

% if supports_copift:
#define SNRT_SUPPORTS_COPIFT
% endif

% if supports_pulp:
#define SNRT_SUPPORTS_PULP
% endif

// Software configuration
#define SNRT_LOG2_STACK_SIZE 10
