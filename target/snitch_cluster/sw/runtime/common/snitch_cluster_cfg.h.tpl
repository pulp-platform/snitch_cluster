// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#define CFG_CLUSTER_NR_CORES ${cfg['cluster']['nr_cores']}
#define CFG_CLUSTER_BASE_HARTID ${cfg['cluster']['cluster_base_hartid']}
#define SNRT_BASE_HARTID CFG_CLUSTER_BASE_HARTID
#define SNRT_CLUSTER_CORE_NUM CFG_CLUSTER_NR_CORES
#define SNRT_CLUSTER_NUM ${cfg['nr_clusters']}
#define SNRT_CLUSTER_DM_CORE_NUM 1
#define SNRT_TCDM_START_ADDR CLUSTER_TCDM_BASE_ADDR
#define SNRT_TCDM_BANK_WIDTH ${cfg['cluster']['data_width'] // 8}
#define SNRT_TCDM_BANK_NUM ${cfg['cluster']['tcdm']['banks']}
#define SNRT_TCDM_HYPERBANK_NUM ${cfg['cluster']['tcdm']['hyperbanks']}
#define SNRT_TCDM_BANK_PER_HYPERBANK_NUM ${cfg['cluster']['tcdm']['banks'] // cfg['cluster']['tcdm']['hyperbanks']}
#define SNRT_TCDM_SIZE ${hex(cfg['cluster']['tcdm']['size'] * 1024)}
#define SNRT_TCDM_HYPERBANK_SIZE ${hex(cfg['cluster']['tcdm']['size'] * 1024 // cfg['cluster']['tcdm']['hyperbanks'])}
#define SNRT_TCDM_HYPERBANK_WIDTH (SNRT_TCDM_BANK_PER_HYPERBANK_NUM * SNRT_TCDM_BANK_WIDTH)
#define SNRT_CLUSTER_OFFSET ${cfg['cluster']['cluster_base_offset']}

#define SNRT_SUPPORTS_MULTICAST ${cfg['cluster']['enable_multicast']}

// Software configuration
#define SNRT_LOG2_STACK_SIZE 10
