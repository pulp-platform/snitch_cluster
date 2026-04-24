// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

`ifndef SNITCH_CV_X_IF_TYPEDEF_SVH_
`define SNITCH_CV_X_IF_TYPEDEF_SVH_

`define CV_X_IF_ISSUE_REQ_STRUCT(__xif_id_width) \
  struct packed {                                \
    logic [31:0]                   instr;        \
    logic [31:0]                   hartid;       \
    logic [``__xif_id_width``-1:0] id;           \
  }

`define CV_X_IF_ISSUE_RESP_STRUCT \
  struct packed {                 \
    logic       accept;           \
    logic       writeback;        \
    logic [2:0] register_read;    \
  }

`define CV_X_IF_REGISTER_STRUCT(__xif_id_width) \
  struct packed {                               \
    logic [31:0]                   hartid;      \
    logic [``__xif_id_width``-1:0] id;          \
    logic [2:0][31:0]              rs;          \
    logic [2:0]                    rs_valid;    \
  }

`define CV_X_IF_COMMIT_STRUCT(__xif_id_width)   \
  struct packed {                               \
    logic [31:0]                   hartid;      \
    logic [``__xif_id_width``-1:0] id;          \
    logic                          commit_kill; \
  }

`define CV_X_IF_RESULT_STRUCT(__xif_id_width) \
  struct packed {                             \
    logic [31:0]                   hartid;    \
    logic [``__xif_id_width``-1:0] id;        \
    logic [31:0]                   data;      \
    logic [4:0]                    rd;        \
    logic                          we;        \
  }

`define CV_X_IF_TYPEDEF_ALL(__xif_id_width) \
  typedef `CV_X_IF_ISSUE_REQ_STRUCT(__xif_id_width) x_issue_req_t; \
  typedef `CV_X_IF_ISSUE_RESP_STRUCT x_issue_resp_t; \
  typedef `CV_X_IF_REGISTER_STRUCT(__xif_id_width) x_register_t; \
  typedef `CV_X_IF_COMMIT_STRUCT(__xif_id_width) x_commit_t; \
  typedef `CV_X_IF_RESULT_STRUCT(__xif_id_width) x_result_t;

`endif
