// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

/// # Snitch-wide Constants.
/// Fixed constants for a Snitch system.

package snitch_pkg;

  /// RISC-V hart ID width (32 bits per spec).
  localparam int unsigned HartIdWidth = 32;
  typedef logic [HartIdWidth-1:0] hart_id_t;

  // Snitch AWUSER width, fixed to 64b corresponding to {USER_HIGH, USER_LOW} CSRs
  localparam int unsigned UserWidth = 64;

  typedef enum logic [3:0] {
    None, RegRs1, RegRs2, RegRs3, RegRd, IImmediate, UImmediate, JImmediate, SImmediate,
    SFImmediate, PC, Csr, CsrImmediate, PBImmediate
  } op_select_e;

  /// Async interrupts of the core.
  typedef struct packed {
    /// Debug request
    logic debug;
    /// Machine external interrupt pending
    logic meip;
    /// Machine external timer interrupt pending
    logic mtip;
    /// Machine external software interrupt pending
    logic msip;
    /// Machine cluster-local interrupt pending
    logic mcip;
    /// Machine external accelerator interrupt pending
    logic mxip;
  } interrupts_t;

  typedef enum logic [1:0] {
    PrivLvlM = 2'b11,
    PrivLvlS = 2'b01,
    PrivLvlU = 2'b00
  } priv_lvl_t;

  // Extension state.
  typedef enum logic [1:0] {
    XOff = 2'b00,
    XInitial = 2'b01,
    XClean = 2'b10,
    XDirty = 2'b11
  } x_state_e;

  typedef struct packed {
    logic         sd;     // signal dirty - read-only - hardwired zero
    logic [7:0]   wpri3;  // writes preserved reads ignored
    logic         tsr;    // trap sret
    logic         tw;     // time wait
    logic         tvm;    // trap virtual memory
    logic         mxr;    // make executable readable
    logic         sum;    // permit supervisor user memory access
    logic         mprv;   // modify privilege - privilege level for ld/st
    x_state_e     xs;     // extension register - hardwired to zero
    x_state_e     fs;     // extension register - hardwired to zero for non FP and to Dirty for FP.
    priv_lvl_t    mpp;    // holds the previous privilege mode up to machine
    logic [1:0]   wpri2;  // writes preserved reads ignored
    logic         spp;    // holds the previous privilege mode up to supervisor
    logic         mpie;   // machine interrupts enable bit active prior to trap
    logic         wpri1;  // writes preserved reads ignored
    logic         spie;   // supervisor interrupts enable bit active prior to trap
    logic         upie;   // user interrupts enable bit active prior to trap - hardwired to zero
    logic         mie;    // machine interrupts enable
    logic         wpri0;  // writes preserved reads ignored
    logic         sie;    // supervisor interrupts enable
    logic         uie;    // user interrupts enable - hardwired to zero
  } status_rv32_t;

  // Virtual Memory
  localparam int unsigned PageShift = 12;
  /// Size in bits of the virtual address segments
  localparam int unsigned VpnSize = 10;

  /// Virtual Address Definition
  typedef struct packed {
    /// Virtual Page Number 1
    logic [31:32-VpnSize] vpn1;
    /// Virtual Page Number 0
    logic [PageShift+VpnSize-1:PageShift] vpn0;
  } va_t;

  typedef struct packed {
    logic               d;
    logic               a;
    logic               u;
    logic               x;
    logic               w;
    logic               r;
  } pte_flags_t;

  localparam logic [3:0] InstrAddrMisaligned  = 0;
  localparam logic [3:0] InstrAccessFault     = 1;
  localparam logic [3:0] IllegalInstr         = 2;
  localparam logic [3:0] Breakpoint           = 3;
  localparam logic [3:0] LoadAddrMisaligned   = 4;
  localparam logic [3:0] LoadAccessFault      = 5;
  localparam logic [3:0] StoreAddrMisaligned  = 6;
  localparam logic [3:0] StoreAccessFault     = 7;
  localparam logic [3:0] EnvCallUMode         = 8;  // environment call from user mode
  localparam logic [3:0] EnvCallSMode         = 9;  // environment call from supervisor mode
  localparam logic [3:0] EnvCallMMode         = 11; // environment call from machine mode
  localparam logic [3:0] InstrPageFault       = 12; // Instruction page fault
  localparam logic [3:0] LoadPageFault        = 13; // Load page fault
  localparam logic [3:0] StorePageFault       = 15; // Store page fault

  localparam logic [3:0] MSI = 3;
  localparam logic [3:0] MTI = 7;
  localparam logic [3:0] MEI = 11;
  localparam logic [4:0] MCI = 19;
  localparam logic [4:0] MXI = 20;
  localparam logic [3:0] SSI = 1;
  localparam logic [3:0] STI = 5;
  localparam logic [3:0] SEI = 9;
  localparam logic [4:0] SCI = 17;

  // Event strobes per core, counted by the performance counters in the cluster
  // peripherals.
  typedef struct packed {
    logic issue_fpu;          // core operations performed in the FPU
    logic issue_fpu_seq;      // includes load/store operations
    logic issue_core_to_fpu;  // instructions issued from core to FPU
    logic retired_instr;      // number of instructions retired by the core
    logic retired_load;       // number of load instructions retired by the core
    logic retired_i;          // number of base instructions retired by the core
    logic retired_acc;        // number of offloaded instructions retired by the core
    logic retired_x;          // number of offloaded instructions to the XIF retired by the core
  } core_events_t;

  /// ISA configuration
  typedef struct packed {
    /// Reduced-register extension.
    bit RVE;
    /// RISC-V V extension for Spatz
    bit RVV;
    /// Enable Snitch DMA as accelerator.
    bit Xdma;
    bit Xssr;
    bit Xfrep;
    bit Xcopift;
    /// Enable F Extension.
    bit RVF;
    /// Enable D Extension.
    bit RVD;
    bit Zfh;
    bit XF16ALT;
    bit XF8;
    bit XF8ALT;
    /// Enable div/sqrt unit (buggy - use with caution)
    bit XDivSqrt;
    bit XFVEC;
    bit XFDOTP;
    bit XFAUX;
    /// Enable Xcvmem instructions (overlaps with DMA, SSR, copift)
    bit Xcvmem;
    bit Xpulpabs;
    bit Xpulpbitop;
    bit Xpulpbr;
    bit Xpulpclip;
    bit Xpulpmacsi;
    bit Xpulpminmax;
    bit Xpulpslet;
    bit Xpulpvect;
    bit Xpulpvectshufflepack;
  } isa_cfg_t;

  // SSRs
  localparam logic [11:0] CsrMseg = 12'hBC0;

  // Snitch (and not the CC) defines the accelerators it supports, since they have to be known
  // by Snitch to properly address them in the decoder. This is unlike the CV-X-IF interface
  // where coprocessors don't have to be addressed by the processor.
  typedef enum logic [31:0] {
    FP_SS = 0,
    IPU = 1,
    DMA_SS = 2,
    SSR_CFG = 3,
    NUM_ACC = 4
  } acc_addr_e;

  localparam int unsigned XifNumRs = 3;
  localparam int unsigned XifRfrWidth = 32;
  localparam int unsigned XifRfwWidth = 32;
  localparam int unsigned XifHartIdWidth = 32;
  localparam int unsigned XifDualRead = 0;
  localparam int unsigned XifIssueRegisterSplit = 0;

  function automatic int unsigned calculate_flen(isa_cfg_t isa);
    return isa.RVD     ? 64 : // D ext.
           isa.RVF     ? 32 : // F ext.
           isa.Zfh     ? 16 : // Zfh ext.
           isa.XF16ALT ? 16 : // Xf16alt ext.
           isa.XF8     ?  8 : // Xf8 ext.
           isa.XF8ALT  ?  8 : // Xf8alt ext.
                          0;  // Unused in case of no FP
  endfunction

  function automatic bit calculate_fp_enable(isa_cfg_t isa);
    return isa.RVF || isa.RVD || isa.Zfh || isa.XF16ALT || isa.XF8 || isa.XF8ALT ||
           isa.XFVEC || isa.XFAUX || isa.XFDOTP;
  endfunction

  function automatic bit calculate_xpulpv2(isa_cfg_t isa);
    return isa.Xpulpabs || isa.Xpulpbitop || isa.Xpulpbr || isa.Xpulpclip || isa.Xpulpmacsi ||
           isa.Xpulpminmax || isa.Xpulpslet || isa.Xpulpvect || isa.Xpulpvectshufflepack;
  endfunction

  // --------------------
  // Trace Infrastructure
  // --------------------
  // pragma translate_off
  typedef enum logic [1:0] {
    SrcSnitch =  0,
    SrcFpu = 1,
    SrcFpuSeq = 2,
    SrcDca = 3
  } trace_src_e;

  typedef struct packed {
    trace_src_e source;
    longint     stall;
    longint     exception;
    longint     rs1;
    longint     rs2;
    longint     rd;
    longint     is_load;
    longint     is_store;
    longint     is_branch;
    longint     pc_d;
    longint     opa;
    longint     opb;
    op_select_e opa_select;
    op_select_e opb_select;
    op_select_e opc_select;
    longint     write_rd;
    longint     csr_addr;
    longint     writeback;
    longint     gpr_rdata_1;
    longint     ls_size;
    longint     ld_result_32;
    longint     lsu_rd;
    longint     retire_load;
    longint     alu_result;
    longint     ls_amo;
    longint     retire_acc;
    longint     acc_pid;
    longint     acc_pdata_32;
    longint     fpu_offload;
    longint     is_seq_insn;
  } snitch_trace_extras_t;

  typedef struct packed {
    logic [31:0]          pc_q;
    priv_lvl_t            priv_lvl_q;
    logic [31:0]          instr;
    snitch_trace_extras_t extras;
  } snitch_trace_t;

  // verilog_lint: waive-start line-length
  function automatic string print_snitch_extras(snitch_trace_extras_t trace);
    string extras_str = "{";
    extras_str = $sformatf("%s'%s': '%s', ", extras_str, "source", trace.source.name);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "stall", trace.stall);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "exception", trace.exception);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "rs1", trace.rs1);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "rs2", trace.rs2);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "rd", trace.rd);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "is_load", trace.is_load);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "is_store", trace.is_store);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "is_branch", trace.is_branch);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "pc_d", trace.pc_d);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "opa", trace.opa);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "opb", trace.opb);
    extras_str = $sformatf("%s'%s': '%s', ", extras_str, "opa_select", trace.opa_select.name);
    extras_str = $sformatf("%s'%s': '%s', ", extras_str, "opb_select", trace.opb_select.name);
    extras_str = $sformatf("%s'%s': '%s', ", extras_str, "opc_select", trace.opc_select.name);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "write_rd", trace.write_rd);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "csr_addr", trace.csr_addr);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "writeback", trace.writeback);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "gpr_rdata_1", trace.gpr_rdata_1);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "ls_size", trace.ls_size);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "ld_result_32", trace.ld_result_32);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "lsu_rd", trace.lsu_rd);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "retire_load", trace.retire_load);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "alu_result", trace.alu_result);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "ls_amo", trace.ls_amo);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "retire_acc", trace.retire_acc);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "acc_pid", trace.acc_pid);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "acc_pdata_32", trace.acc_pdata_32);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "fpu_offload", trace.fpu_offload);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "is_seq_insn", trace.is_seq_insn);
    extras_str = $sformatf("%s}", extras_str);
    return extras_str;
  endfunction
  // verilog_lint: waive-stop line-length

  typedef struct packed {
    trace_src_e source;
    longint     acc_q_hs;
    longint     fpu_out_hs;
    longint     lsu_q_hs;
    longint     op_in;
    longint     rs1;
    longint     rs2;
    longint     rs3;
    longint     rd;
    longint     op_sel_0;
    longint     op_sel_1;
    longint     op_sel_2;
    longint     src_fmt;
    longint     dst_fmt;
    longint     int_fmt;
    longint     acc_qdata_0;
    longint     acc_qdata_1;
    longint     acc_qdata_2;
    longint     op_0;
    longint     op_1;
    longint     op_2;
    longint     use_fpu;
    longint     fpu_in_rd;
    longint     fpu_in_acc;
    longint     ls_size;
    longint     is_load;
    longint     is_store;
    longint     lsu_qaddr;
    longint     lsu_rd;
    longint     fpu_out_acc;
    longint     fpr_waddr;
    longint     fpr_wdata;
    longint     fpr_we;
  } fpss_trace_t;

  function automatic string print_fpss_extras(fpss_trace_t trace);
    string extras_str = "{";
    extras_str = $sformatf("%s'%s': '%s', ", extras_str, "source", trace.source.name);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "acc_q_hs", trace.acc_q_hs);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "fpu_out_hs", trace.fpu_out_hs);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "lsu_q_hs", trace.lsu_q_hs);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "op_in", trace.op_in);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "rs1", trace.rs1);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "rs2", trace.rs2);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "rs3", trace.rs3);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "rd", trace.rd);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "op_sel_0", trace.op_sel_0);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "op_sel_1", trace.op_sel_1);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "op_sel_2", trace.op_sel_2);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "src_fmt", trace.src_fmt);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "dst_fmt", trace.dst_fmt);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "int_fmt", trace.int_fmt);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "acc_qdata_0", trace.acc_qdata_0);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "acc_qdata_1", trace.acc_qdata_1);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "acc_qdata_2", trace.acc_qdata_2);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "op_0", trace.op_0);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "op_1", trace.op_1);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "op_2", trace.op_2);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "use_fpu", trace.use_fpu);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "fpu_in_rd", trace.fpu_in_rd);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "fpu_in_acc", trace.fpu_in_acc);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "ls_size", trace.ls_size);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "is_load", trace.is_load);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "is_store", trace.is_store);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "lsu_qaddr", trace.lsu_qaddr);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "lsu_rd", trace.lsu_rd);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "fpu_out_acc", trace.fpu_out_acc);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "fpr_waddr", trace.fpr_waddr);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "fpr_wdata", trace.fpr_wdata);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "fpr_we", trace.fpr_we);
    extras_str = $sformatf("%s}", extras_str);
    return extras_str;
  endfunction

  typedef struct packed {
    trace_src_e source;
    longint     cbuf_push;
    longint     max_inst;
    longint     max_iter;
    longint     stg_max;
    longint     stg_mask;
  } fpu_sequencer_trace_t;

  function automatic string print_fpu_sequencer_extras(fpu_sequencer_trace_t trace);
    string extras_str = "{";
    extras_str = $sformatf("%s'%s': '%s', ", extras_str, "source", trace.source.name);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "cbuf_push", trace.cbuf_push);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "max_inst", trace.max_inst);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "max_iter", trace.max_iter);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "stg_max", trace.stg_max);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "stg_mask", trace.stg_mask);
    extras_str = $sformatf("%s}", extras_str);
    return extras_str;
  endfunction

  typedef struct packed {
    trace_src_e source;
    longint     req_hs;
    longint     rsp_hs;
    longint     operand0;
    longint     operand1;
    longint     operand2;
    longint     rnd_mode;
    longint     op;
    longint     op_mod;
    longint     src_fmt;
    longint     dst_fmt;
    longint     int_fmt;
    longint     vectorial_op;
    longint     tag;
    longint     status;
    longint     result;
  } dca_trace_t;

  function automatic string print_dca_extras(dca_trace_t trace);
    string extras_str = "{";
    extras_str = $sformatf("%s'%s': '%s', ", extras_str, "source", trace.source.name);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "req_hs", trace.req_hs);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "rsp_hs", trace.rsp_hs);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "op", trace.op);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "op_mod", trace.op_mod);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "rnd_mode", trace.rnd_mode);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "vectorial_op", trace.vectorial_op);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "operand0", trace.operand0);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "operand1", trace.operand1);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "operand2", trace.operand2);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "src_fmt", trace.src_fmt);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "dst_fmt", trace.dst_fmt);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "int_fmt", trace.int_fmt);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "status", trace.status);
    extras_str = $sformatf("%s'%s': 0x%0x, ", extras_str, "result", trace.result);
    extras_str = $sformatf("%s}", extras_str);
    return extras_str;
  endfunction
  // pragma translate_on

endpackage
