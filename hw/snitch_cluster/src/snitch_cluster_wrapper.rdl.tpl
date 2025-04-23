## Copyright 2025 ETH Zurich and University of Bologna.
## Solderpad Hardware License, Version 0.51, see LICENSE for details.
## SPDX-License-Identifier: SHL-0.51
// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

${disclaimer}

`ifndef __${cfg['cluster']['name'].upper()}_WRAPPER_RDL__
`define __${cfg['cluster']['name'].upper()}_WRAPPER_RDL__

`include "snitch_cluster_peripheral_reg.rdl"

addrmap ${cfg['cluster']['name']}_wrapper #(
    longint unsigned BASE_ADDR = ${hex(cfg['cluster']['cluster_base_addr'])}
) {

    default regwidth = ${cfg['cluster']['data_width']};

    mem TCDM {
        mementries = ${hex(int(cfg['cluster']['tcdm']['size'] * 1024 * 8 / cfg['cluster']['data_width']))};
        memwidth = ${cfg['cluster']['data_width']};
    };

    mem BOOTROM {
        mementries = ${hex(int(4 * 1024 * 8 / cfg['cluster']['data_width']))};
        memwidth = ${cfg['cluster']['data_width']};
    };

    mem ZEROMEM {
        mementries = ${hex(int(cfg['cluster']['zero_mem_size'] * 1024 * 8 / cfg['cluster']['data_width']))};
        memwidth = ${cfg['cluster']['data_width']};
    };


    external TCDM                 TCDM           @BASE_ADDR;
%if cfg['cluster']['int_bootrom_enable']:
    external BOOTROM              BOOTROM        @BASE_ADDR + ${hex(cfg['cluster']['tcdm']['size'] * 1024)};
% endif
    snitch_cluster_peripheral_reg peripheral_reg @BASE_ADDR + ${hex((cfg['cluster']['tcdm']['size'] + (int(cfg['cluster']['int_bootrom_enable']) * 4)) * 1024)};
    external ZEROMEM              ZEROMEM        @BASE_ADDR + ${hex((cfg['cluster']['tcdm']['size'] + (int(cfg['cluster']['int_bootrom_enable']) * 4) + cfg['cluster']['cluster_periph_size']) * 1024)};


};

`endif // __${cfg['cluster']['name'].upper()}_WRAPPER_RDL__
