// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Lucia Luzi <luzil@ethz.ch>
// Author: Gianluca Bellocchi <gianluca.bellocchi@unimore.it>

/// Convert OBI to TCDM protocol.
module obi_to_tcdm #(
    parameter type obi_req_t = logic,
    parameter type obi_rsp_t = logic,
    parameter type tcdm_req_t = logic,
    parameter type tcdm_rsp_t = logic,
    parameter int unsigned DataWidth   = 0,
    parameter int unsigned IdWidth     = 0,
    parameter int unsigned MemRespLat  = 0,
    parameter int unsigned NumChannels = 1
) (
    input  logic      clk_i,
    input  logic      rst_ni,
    input  obi_req_t  [NumChannels-1:0] obi_req_i,
    output obi_rsp_t  [NumChannels-1:0] obi_rsp_o,
    output tcdm_req_t [NumChannels-1:0] tcdm_req_o,
    input  tcdm_rsp_t [NumChannels-1:0] tcdm_rsp_i
);

  typedef logic [DataWidth-1:0] obi_data_t;
  typedef logic [IdWidth-1:0]   obi_id_t;

  typedef struct packed {
    obi_data_t rdata;
    obi_id_t   rid;
  } obi_r_payload_t;

  localparam int unsigned RspBufDepth = MemRespLat + 1;
  localparam int unsigned CreditWidth = $clog2(RspBufDepth + 1);

  for (genvar i = 0; i < NumChannels; i++) begin : gen_tcdm_obi_adapt
    // Backpressure on new requests.
    logic can_accept;
    // Merged read-write R-channel responses after pipeline.
    logic      obi_p_rvalid;
    obi_data_t obi_p_rdata;
    obi_id_t   obi_p_rid;
    // Credit counter signals.
    logic [CreditWidth-1:0] credit_q, credit_d;
    logic                   req_hs, rsp_hs;
    // Response buffer signals.
    obi_r_payload_t rsp_buf_in, rsp_buf_out;
    logic           rsp_buf_valid;

    assign tcdm_req_o[i].q_valid = obi_req_i[i].req & can_accept;

    assign tcdm_req_o[i].q = '{
      addr:  obi_req_i[i].a.addr,
      write: obi_req_i[i].a.we,
      amo:   lsu_pkg::AMONone,
      data:  obi_req_i[i].a.wdata,
      strb:  obi_req_i[i].a.be,
      user:  '0
    };

    assign obi_rsp_o[i].gnt = tcdm_rsp_i[i].q_ready & can_accept;

    // Backward TCDM write acknowledgement.
    //
    // This would be missing as TCDM writes are fire-and-forget. OBI has instead a R-channel response
    // for both read and write transactions. The converter thus drives write ack after `MemRespLat`
    // cycles from the first grant to the OBI interface.
    if (MemRespLat > 0) begin : gen_id_pipeline
      // Pipelined signals.
      logic    [MemRespLat-1:0] p_ack;
      logic    [MemRespLat-1:0] p_we;
      obi_id_t [MemRespLat-1:0] p_id;

      // R-channel response pipeline.
      always_ff @(posedge clk_i or negedge rst_ni) begin: r_resp_pipeline
        if (!rst_ni) begin
          p_ack <= '0;
          p_we <= '0;
          p_id <= '0;
        end else begin
          // Load current ack.
          p_ack[0] <= obi_req_i[i].req & obi_rsp_o[i].gnt;
          p_we[0] <= (obi_req_i[i].req & obi_rsp_o[i].gnt) ? obi_req_i[i].a.we  : '0;
          p_id[0] <= (obi_req_i[i].req & obi_rsp_o[i].gnt) ? obi_req_i[i].a.aid : '0;
          // Implement pipeline as a shift register.
          for (int k = 1; k < MemRespLat; k++) begin
            p_ack[k] <= p_ack[k-1];
            p_we[k] <= p_we[k-1];
            p_id[k] <= p_id[k-1];
          end
        end
      end

      // Prepare data for the OBI R-channel.
      assign obi_p_rvalid = tcdm_rsp_i[i].p_valid |
                          (p_ack[MemRespLat-1] & p_we[MemRespLat-1]);
      assign obi_p_rdata  = tcdm_rsp_i[i].p.data;
      assign obi_p_rid    = p_id[MemRespLat-1];

    // Zero-latency: write response is valid in the same cycle as the grant.
    end else begin : gen_id_zero_latency
      // Prepare data for the OBI R-channel.
      assign obi_p_rvalid = tcdm_rsp_i[i].p_valid |
                            (obi_req_i[i].req & obi_rsp_o[i].gnt & obi_req_i[i].a.we);
      assign obi_p_rdata  = tcdm_rsp_i[i].p.data;
      assign obi_p_rid    = obi_req_i[i].a.aid;
    end

    // Credit-based flow control for response buffer.
    assign req_hs = obi_req_i[i].req  & obi_rsp_o[i].gnt;
    assign rsp_hs = obi_rsp_o[i].rvalid & obi_req_i[i].rready;

    assign can_accept = (credit_q != '0);
    assign credit_d   = credit_q - CreditWidth'(req_hs) + CreditWidth'(rsp_hs);

    always_ff @(posedge clk_i or negedge rst_ni) begin : proc_credit
      if (!rst_ni) begin
        credit_q <= CreditWidth'(RspBufDepth);
      end else begin
        credit_q <= credit_d;
      end
    end

    // Response buffer.
    assign rsp_buf_in = '{rdata: obi_p_rdata, rid: obi_p_rid};

    cc_stream_fifo #(
      .FallThrough (1'b1),
      .Depth       (RspBufDepth),
      .data_t      (obi_r_payload_t)
    ) i_rsp_buffer (
      .clk_i,
      .rst_ni,
      .clr_i   (1'b0),
      .flush_i (1'b0),
      .usage_o (/* unused */),
      .data_i  (rsp_buf_in),
      .valid_i (obi_p_rvalid),
      .ready_o (/* unused: credit counter guarantees space */),
      .data_o  (rsp_buf_out),
      .valid_o (rsp_buf_valid),
      .ready_i (obi_req_i[i].rready)
    );

    // Assign local R response to OBI response interface.
    assign obi_rsp_o[i].rvalid = rsp_buf_valid;
    assign obi_rsp_o[i].r = '{
      rdata:      rsp_buf_out.rdata,
      rid:        rsp_buf_out.rid,
      err:        1'b0,
      r_optional: '0
    };

  end

endmodule
