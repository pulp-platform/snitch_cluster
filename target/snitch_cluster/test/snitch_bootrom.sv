// Copyright 2024 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Fabian Schuiki <fschuiki@iis.ee.ethz.ch>
// Florian Zaruba <zarubaf@iis.ee.ethz.ch>
// Stefan Mach <smach@iis.ee.ethz.ch>
// Thomas Benz <tbenz@iis.ee.ethz.ch>
// Paul Scheffler <paulsc@iis.ee.ethz.ch>
// Wolfgang Roenninger <wroennin@iis.ee.ethz.ch>
//
// AUTOMATICALLY GENERATED by gen_bootrom.py; edit the script instead.

module snitch_bootrom #(
    parameter int unsigned AddrWidth = 32,
    parameter int unsigned DataWidth = 32,
    parameter int unsigned BootromSize = 65536
)(
    input  logic                 clk_i,
    input  logic                 rst_ni,
    input  logic [AddrWidth-1:0] addr_i,
    output logic [DataWidth-1:0] data_o
);

    logic [BootromSize/4-1:0][31:0] bootrom;
    logic [BootromSize/DataWidth*8-1:0][DataWidth-1:0] bootrom_aligned;
    logic [$clog2(BootromSize)-1:$clog2(DataWidth/8)] addr_aligned;

    assign bootrom_aligned = bootrom;
    assign addr_aligned = addr_i[$clog2(BootromSize)-1:$clog2(DataWidth/8)];
    assign data_o = bootrom_aligned[addr_aligned];

    always_comb begin : gen_bootrom
        bootrom = '0;
            bootrom[0] = 32'h00000297; /* 0x0000 */
            bootrom[1] = 32'h02c28293; /* 0x0004 */
            bootrom[2] = 32'h30529073; /* 0x0008 */
            bootrom[3] = 32'h30046073; /* 0x000c */
            bootrom[4] = 32'h000802b7; /* 0x0010 */
            bootrom[5] = 32'h00828293; /* 0x0014 */
            bootrom[6] = 32'h00100313; /* 0x0018 */
            bootrom[7] = 32'h00b31313; /* 0x001c */
            bootrom[8] = 32'h0062e2b3; /* 0x0020 */
            bootrom[9] = 32'h30429073; /* 0x0024 */
            bootrom[10] = 32'h10500073; /* 0x0028 */
            bootrom[11] = 32'h00000297; /* 0x002c */
            bootrom[12] = 32'hfffff337; /* 0x0030 */
            bootrom[13] = 32'h15c30313; /* 0x0034 */
            bootrom[14] = 32'h006282b3; /* 0x0038 */
            bootrom[15] = 32'h0002a283; /* 0x003c */
            bootrom[16] = 32'h000280e7; /* 0x0040 */
            bootrom[17] = 32'hfbdff06f; /* 0x0044 */
    end

endmodule
