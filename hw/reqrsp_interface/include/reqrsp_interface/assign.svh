// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>
// Author: Fabian Schuiki <fschuiki@iis.ee.ethz.ch>
// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

// Macros to assign reqrsp structs and interfaces with q/p channels.

`ifndef REQRSP_ASSIGN_SVH_
`define REQRSP_ASSIGN_SVH_

// Tie off a reqrsp-like interface
`define REQRSP_TIE_OFF_REQ(__req) \
  assign ``__req``.q       = '0;  \
  assign ``__req``.q_valid = 1'b0; \
  assign ``__req``.p_ready = 1'b0;

`define REQRSP_TIE_OFF_RSP(__rsp) \
  assign ``__rsp``.p       = '0;  \
  assign ``__rsp``.p_valid = 1'b0; \
  assign ``__rsp``.q_ready = 1'b0;

// Assign a reqrsp handshake.
`define REQRSP_ASSIGN_VALID(__opt_as, __dst, __src, __chan) \
  __opt_as ``__dst``.``__chan``_valid = ``__src``.``__chan``_valid;

`define REQRSP_ASSIGN_READY(__opt_as, __dst, __src, __chan) \
  __opt_as ``__dst``.``__chan``_ready = ``__src``.``__chan``_ready;

`define REQRSP_ASSIGN_HANDSHAKE(__opt_as, __dst, __src, __chan) \
  `REQRSP_ASSIGN_VALID(__opt_as, __dst, __src, __chan)          \
  `REQRSP_ASSIGN_READY(__opt_as, __src, __dst, __chan)

`define REQRSP_ASSIGN_REQ(__opt_as, __dst, __src) \
  __opt_as ``__dst``.q       = ``__src``.q;       \
  __opt_as ``__dst``.q_valid = ``__src``.q_valid; \
  __opt_as ``__dst``.p_ready = ``__src``.p_ready;

`define REQRSP_ASSIGN_RSP(__opt_as, __dst, __src) \
  __opt_as ``__dst``.p       = ``__src``.p;       \
  __opt_as ``__dst``.p_valid = ``__src``.p_valid; \
  __opt_as ``__dst``.q_ready = ``__src``.q_ready;

`define REQRSP_ASSIGN(__slv, __mst)          \
  `REQRSP_ASSIGN_REQ(assign, __slv, __mst)   \
  `REQRSP_ASSIGN_RSP(assign, __mst, __slv)

`define REQRSP_ASSIGN_FROM_REQ(__reqrsp, __req) \
  `REQRSP_ASSIGN_REQ(assign, __reqrsp, __req)

`define REQRSP_ASSIGN_FROM_RSP(__reqrsp, __rsp) \
  `REQRSP_ASSIGN_RSP(assign, __reqrsp, __rsp)

`define REQRSP_ASSIGN_TO_REQ(__req, __reqrsp) \
  `REQRSP_ASSIGN_REQ(assign, __req, __reqrsp)

`define REQRSP_ASSIGN_TO_RSP(__rsp, __reqrsp) \
  `REQRSP_ASSIGN_RSP(assign, __rsp, __reqrsp)

`endif
