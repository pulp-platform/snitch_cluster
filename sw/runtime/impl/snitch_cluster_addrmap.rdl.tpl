## Copyright 2025 ETH Zurich and University of Bologna.
## Solderpad Hardware License, Version 0.51, see LICENSE for details.
## SPDX-License-Identifier: SHL-0.51
// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

${disclaimer}

`include "snitch_cluster.rdl"

addrmap snitch_cluster_addrmap {

    snitch_cluster cluster @${hex(cfg['cluster']['cluster_base_addr'])};

% if cfg['cluster']['alias_region_enable']:
    snitch_cluster cluster_alias @${hex(cfg['cluster']['alias_region_base'])};
% endif

};
