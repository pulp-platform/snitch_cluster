// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

`include "dca_interface/typedef.svh"

// Forks a wide Direct Compute Access (DCA) request to multiple lanes,
// operating in SIMD fashion.
module dca_fork #(
    parameter int unsigned LaneDataWidth = 64,
    parameter int unsigned NumLanes = 8,
    parameter int unsigned TagWidth = 7,
    // Derived parameters
    localparam int unsigned DataWidth = LaneDataWidth * NumLanes,
    localparam type dca_req_t = `DCA_REQ_STRUCT(DataWidth, TagWidth),
    localparam type dca_rsp_t = `DCA_RSP_STRUCT(DataWidth, TagWidth),
    localparam type dca_lane_req_t = `DCA_REQ_STRUCT(LaneDataWidth, TagWidth),
    localparam type dca_lane_rsp_t = `DCA_RSP_STRUCT(LaneDataWidth, TagWidth)
) (
    input  logic clk_i,
    input  logic rst_ni,
    input  dca_req_t slv_req_i,
    output dca_rsp_t slv_rsp_o,
    output dca_lane_req_t [NumLanes-1:0] mst_req_o,
    input  dca_lane_rsp_t [NumLanes-1:0] mst_rsp_i
);

    logic [NumLanes-1:0] flat_q_valids;
    logic [NumLanes-1:0] flat_q_readies;
    logic [NumLanes-1:0] flat_p_valids;
    logic [NumLanes-1:0] flat_p_readies;

    // Fork the DCA request to all lanes
    stream_fork #(
      .N_OUP(NumLanes)
    ) i_dca_fork_fpu (
      .clk_i  (clk_i),
      .rst_ni (rst_ni),
      .valid_i(slv_req_i.q_valid),
      .ready_o(slv_rsp_o.q_ready),
      .valid_o(flat_q_valids),
      .ready_i(flat_q_readies)
    );

    // Join the DCA responses from all lanes
    stream_join #(
      .N_INP(NumLanes)
    ) i_dca_join_fpu (
      .inp_valid_i(flat_p_valids),
      .inp_ready_o(flat_p_readies),
      .oup_valid_o(slv_resp_o.p_valid),
      .oup_ready_i(slv_req_i.p_ready)
    );

    for (genvar i = 0; i < NumLanes; i++) begin : gen_lane
        // The same operation flags are sent to all lanes
        assign mst_req_o[i].q.dca_rnd_mode = slv_req_i.q.dca_rnd_mode;
        assign mst_req_o[i].q.dca_op_code = slv_req_i.q.dca_op_code;
        assign mst_req_o[i].q.dca_op_mode = slv_req_i.q.dca_op_mode;
        assign mst_req_o[i].q.dca_src_format = slv_req_i.q.dca_src_format;
        assign mst_req_o[i].q.dca_dst_format = slv_req_i.q.dca_dst_format;
        assign mst_req_o[i].q.dca_int_format = slv_req_i.q.dca_int_format;
        assign mst_req_o[i].q.dca_vector_op = slv_req_i.q.dca_vector_op;
        assign mst_req_o[i].q.dca_tag = slv_req_i.q.dca_tag;
        // Data is split across lanes, to perform SIMD operation (both operands and result)
        assign mst_req_o[i].q.dca_operands[2][DataWidth-1:0] = slv_req_i.q.dca_operands[2][DataWidth*i+:DataWidth];
        assign mst_req_o[i].q.dca_operands[1][DataWidth-1:0] = slv_req_i.q.dca_operands[1][DataWidth*i+:DataWidth];
        assign mst_req_o[i].q.dca_operands[0][DataWidth-1:0] = slv_req_i.q.dca_operands[0][DataWidth*i+:DataWidth];
        assign slv_rsp_o.p.dca_result[DataWidth*i+:DataWidth] = mst_rsp_i[i].p.dca_result[DataWidth-1:0];
        // Connect the handshake signals
        assign mst_req_o[i].q_valid = flat_q_valids[i];
        assign mst_req_o[i].p_ready = flat_p_readies[i];
        assign flat_q_readies[i] = mst_rsp_i[i].q_ready;
        assign flat_p_valids[i] = mst_rsp_i[i].p_valid;
    //   end else begin
    //     // Disable the connection to the DMA core
    //     assign mst_req_o[i].q = '0;
    //     assign mst_req_o[i].q_valid = 1'b0;
    //     assign mst_req_o[i].p_ready = 1'b1;
    //   end
    end

    // The response tag is the same across all responses so we simply take it from the first
    assign slv_rsp_o.p.dca_tag = dca_rsp[0].p.dca_tag;

    // OR-reduce the status bits from all lanes
    // TODO(colluca): double-check that this is actually a bitwise OR
    always_comb begin
        slv_rsp_o.p.dca_status = '0;
        for (int i = 0; i < (NumLanes-1); i++) begin
            slv_rsp_o.p.dca_status |= mst_rsp_i[i].p.dca_status;
        end
    end

endmodule