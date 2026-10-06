// Copyright 2025 ETH Zurich and University of Bologna.
//
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//
// SPDX-License-Identifier: SHL-0.51

// Author: Arpan Suravi Prasad <prasadar@iis.ee.ethz.ch>
`include "common_cells/registers.svh"
`include "common_cells/assertions.svh"

module axi_pace_mem #(
  parameter type         axi_req_t  = logic,
  parameter type         axi_resp_t = logic,
  parameter type         pace_cfg_t = logic,
  parameter bit          PaceEnable = 1'b0,
  parameter int unsigned PaceDegree = 0,
  parameter int unsigned PaceParts  = 0,
  parameter int unsigned PaceEps    = 0,
  parameter int unsigned PaceDataWidth = 0,
  parameter pace_cfg_t   PaceCfg    = pace_cfg_t'({
    PaceEnable,
    32'd0,
    PaceDegree,
    PaceParts,
    PaceEps,
    PaceDataWidth,
    32'd0,
    32'd0,
    32'd0
  }),
  parameter int unsigned AddrWidth  = 0,
  parameter int unsigned DataWidth  = 0,
  parameter int unsigned IdWidth    = 0,
  parameter int unsigned NumBanks   = 1,
  parameter int unsigned BufDepth   = 1,
  localparam int unsigned EffectivePaceDataWidth =
      (PaceDataWidth > 0) ? PaceDataWidth : 1,
  localparam int unsigned PaceCoeffWidth =
      PaceEnable ? ((PaceDegree + 1) * PaceParts * PaceDataWidth) : 0,
  localparam int unsigned PaceBoundWidth = PaceEnable ? ((PaceParts - 1) * PaceDataWidth) : 0,
  localparam int unsigned PaceEpsWidth   = PaceEnable ? (2 * PaceDataWidth * PaceEps) : 0,
  localparam int unsigned PaceParamWidth = PaceCoeffWidth + PaceBoundWidth + PaceEpsWidth,
  localparam type addr_t       = logic [AddrWidth-1:0],
  localparam type mem_data_t   = logic [DataWidth/NumBanks-1:0],
  localparam type mem_strb_t   = logic [DataWidth/NumBanks/8-1:0],
  localparam type pace_param_t = logic [cc_pkg::iomsb(PaceParamWidth):0]
) (
  input  logic                           clk_i,
  input  logic                           rst_ni,
  output logic                           busy_o,
  input  axi_req_t                       axi_req_i,
  output axi_resp_t                      axi_resp_o,
  output pace_param_t                    pace_param_o
);
  logic           [NumBanks-1:0]  mem_req;
  logic           [NumBanks-1:0]  mem_gnt;
  addr_t          [NumBanks-1:0]  mem_addr;
  mem_data_t      [NumBanks-1:0]  mem_wdata;
  logic           [NumBanks-1:0]  mem_we;
  logic           [NumBanks-1:0]  mem_rvalid;
  mem_data_t      [NumBanks-1:0]  mem_rdata;

  axi_to_mem #(
    .axi_req_t   (axi_req_t),
    .axi_resp_t  (axi_resp_t),
    .AddrWidth   (AddrWidth),
    .DataWidth   (DataWidth),
    .IdWidth     (IdWidth),
    .NumBanks    (32'd1),
    .BufDepth    (BufDepth),
    .HideStrb    (1'b0),
    .OutFifoDepth(32'd1)
  ) i_axi_to_mem (
    .clk_i,
    .rst_ni,
    .busy_o,
    .axi_req_i   (axi_req_i),
    .axi_resp_o  (axi_resp_o),
    .mem_req_o   (mem_req),
    .mem_gnt_i   (mem_gnt),
    .mem_addr_o  (mem_addr),
    .mem_wdata_o (mem_wdata),
    .mem_strb_o  (),
    .mem_atop_o  (),
    .mem_we_o    (mem_we),
    .mem_rvalid_i(mem_rvalid),
    .mem_rdata_i (mem_rdata)
  );

  `FF(mem_rvalid, mem_we & mem_req & mem_gnt, 1'b0, clk_i, rst_ni)


  `ASSERT_INIT(PACE_EPS_VALUE, (PaceEps == 0) | (PaceEps == 1),
               "Only PaceEps=0 or 1 is supported it is an enable")

  localparam int unsigned TotalWords =
      ((PaceParamWidth > 0 ? PaceParamWidth : 1) + DataWidth - 1) / DataWidth;
  localparam int unsigned MemAddrWidth = $clog2(TotalWords);
  localparam int unsigned AddrOffset   = $clog2(DataWidth / 8);

  logic [2**MemAddrWidth-1:0][DataWidth-1:0] mem_content;

  assign mem_gnt = 1'b1;

  register_file_1r_1w_all #(
    .ADDR_WIDTH(MemAddrWidth),
    .DATA_WIDTH(DataWidth)
  ) i_pace_param_mem (
    .clk        (clk_i),
    .ReadEnable (1'b0),
    .ReadAddr   ('0),
    .ReadData   (),
    .WriteEnable(mem_req & mem_gnt & mem_we),
    .WriteAddr  (mem_addr[0][AddrOffset+:MemAddrWidth]),
    .WriteData  (mem_wdata),
    .WriteBE    ('1),
    .MemContent (mem_content)
  );

  localparam int unsigned DataWidthRatio = DataWidth / EffectivePaceDataWidth;

  for (genvar ii = 0;
       ii < ((PaceParamWidth > 0 ? PaceParamWidth : 1) / EffectivePaceDataWidth);
       ii++) begin : gen_pace_param
    localparam int Rem = ii % DataWidthRatio;
    localparam int Quo = ii / DataWidthRatio;
    assign pace_param_o[ii*EffectivePaceDataWidth+:EffectivePaceDataWidth] =
      mem_content[Quo][Rem*EffectivePaceDataWidth+:EffectivePaceDataWidth];
  end
endmodule
