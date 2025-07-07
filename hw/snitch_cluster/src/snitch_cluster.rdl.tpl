## Copyright 2025 ETH Zurich and University of Bologna.
## Solderpad Hardware License, Version 0.51, see LICENSE for details.
## SPDX-License-Identifier: SHL-0.51
// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

${disclaimer}

<%! 
import math

def next_power_of_2(n):
    """Returns the next power of 2 greater than or equal to n."""
    return 1 if n == 0 else 2**math.ceil(math.log2(n))
%>

`ifndef __${cfg['cluster']['name'].upper()}_RDL__
`define __${cfg['cluster']['name'].upper()}_RDL__

`include "snitch_cluster_peripheral_reg.rdl"

addrmap ${cfg['cluster']['name']} {

    default regwidth = ${cfg['cluster']['data_width']};

    mem tcdm {
        mementries = ${hex(int(cfg['cluster']['tcdm']['size'] * 1024 * 8 / cfg['cluster']['data_width']))};
        memwidth = ${cfg['cluster']['data_width']};
    };

    mem bootrom {
        mementries = ${hex(int(4 * 1024 * 8 / cfg['cluster']['data_width']))};
        memwidth = ${cfg['cluster']['data_width']};
    };

    mem zeromem {
        mementries = ${hex(int(cfg['cluster']['zero_mem_size'] * 1024 * 8 / cfg['cluster']['data_width']))};
        memwidth = ${cfg['cluster']['data_width']};
    };


    external tcdm                 tcdm           ;
%if cfg['cluster']['int_bootrom_enable']:
    external bootrom              bootrom        @${hex(next_power_of_2(cfg['cluster']['tcdm']['size']) * 1024)};
% endif
    snitch_cluster_peripheral_reg peripheral_reg @${hex((next_power_of_2(cfg['cluster']['tcdm']['size']) + (int(cfg['cluster']['int_bootrom_enable']) * 4)) * 1024)};
    external zeromem              zeromem        @${hex((next_power_of_2(cfg['cluster']['tcdm']['size']) + (int(cfg['cluster']['int_bootrom_enable']) * 4) + cfg['cluster']['cluster_periph_size']) * 1024)};


};

`endif // __${cfg['cluster']['name'].upper()}_RDL__
