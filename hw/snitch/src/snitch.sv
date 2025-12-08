// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>
// Description: Top-Level of Snitch Integer Core RV32E

`include "common_cells/registers.svh"
`include "common_cells/assertions.svh"

// `SNITCH_ENABLE_PERF Enables mcycle, minstret performance counters (read only)

module snitch import snitch_pkg::*; import riscv_instr::*; #(
  /// Boot address of core.
  parameter logic [31:0] BootAddr  = 32'h0000_1000,
  /// Physical Address width of the core.
  parameter int unsigned AddrWidth = 48,
  /// Data width of memory interface.
  parameter int unsigned DataWidth = 64,
  /// Reduced-register extension.
  parameter bit          RVE       = 0,
  /// Enable Snitch DMA as accelerator.
  parameter bit          Xdma      = 0,
  parameter bit          Xssr      = 0,
  parameter bit          Xcopift   = 0,
  /// Enable FP in general
  parameter bit          FP_EN     = 1,
  /// Enable F Extension.
  parameter bit          RVF       = 0,
  /// Enable D Extension.
  parameter bit          RVD       = 0,
  parameter bit          XF16      = 0,
  parameter bit          XF16ALT   = 0,
  parameter bit          XF8       = 0,
  parameter bit          XF8ALT    = 0,
  /// Enable div/sqrt unit (buggy - use with caution)
  parameter bit          XDivSqrt  = 0,
  parameter bit          XFVEC     = 0,
  parameter bit          XFDOTP    = 0,
  parameter bit          XFAUX     = 0,
  int unsigned           FLEN      = DataWidth,
  /// Enable virtual memory support.
  parameter bit          VMSupport = 1,
  parameter bit          OwnMulDiv = 0,
  /// Enable Xpulp instructions
  parameter bit          Xpulppostmod = 0,  // overlaps witch DMA, SSR, copift and frep
  parameter bit          Xpulpabs     = 0,
  parameter bit          Xpulpbitop   = 0,
  parameter bit          Xpulpbr      = 0,
  parameter bit          Xpulpclip    = 0,
  parameter bit          Xpulpmacsi   = 0,
  parameter bit          Xpulpminmax  = 0,
  parameter bit          Xpulpslet    = 0,
  parameter bit          Xpulpvect    = 0,
  parameter bit          Xpulpvectshufflepack = 0,
  parameter bit          Xpulpv2     = 0,
  /// Data port request type.
  parameter type         dreq_t    = logic,
  /// Data port response type.
  parameter type         drsp_t     = logic,
  parameter type         acc_req_t  = logic,
  parameter type         acc_resp_t = logic,
  parameter type         pa_t       = logic,
  parameter type         l0_pte_t   = logic,
  // XIF parameters
  parameter bit          EnableXif  = 1,
  parameter int unsigned XifIdWidth = 4,
  // XIF port types
  parameter type         x_issue_req_t  = logic,
  parameter type         x_issue_resp_t = logic,
  parameter type         x_register_t   = logic,
  parameter type         x_commit_t     = logic,
  parameter type         x_result_t     = logic,
  parameter int unsigned NumIntOutstandingLoads = 0,
  parameter int unsigned NumIntOutstandingMem = 0,
  parameter int unsigned NumDTLBEntries = 0,
  parameter int unsigned NumITLBEntries = 0,
  parameter snitch_pma_pkg::snitch_pma_t SnitchPMACfg = '{default: 0},
  /// Consistency Address Queue (CAQ) parameters
  parameter int unsigned CaqDepth    = 0,
  parameter int unsigned CaqTagWidth = 0,
  /// Enable debug support.
  parameter bit         DebugSupport = 1,
  /// Derived parameter *Do not override*
  parameter type addr_t = logic [AddrWidth-1:0],
  parameter type data_t = logic [DataWidth-1:0]
) (
  input  logic          clk_i,
  input  logic          rst_i,
  input  logic [31:0]   hart_id_i,
  /// Interrupts
  input  interrupts_t   irq_i,
  /// Instruction cache flush request
  output logic          flush_i_valid_o,
  /// Flush has completed when the signal goes to `1`.
  /// Tie to `1` if unused
  input  logic          flush_i_ready_i,
  // Instruction Refill Port
  output addr_t         inst_addr_o,
  output logic          inst_cacheable_o,
  input  logic [31:0]   inst_data_i,
  output logic          inst_valid_o,
  input  logic          inst_ready_i,
  /// Accelerator Interface - Master Port
  /// Independent channels for transaction request and read completion.
  /// AXI-like handshaking.
  /// Same IDs need to be handled in-order.
  output acc_req_t      acc_qreq_o,
  output logic          acc_qvalid_o,
  input  logic          acc_qready_i,
  input  acc_resp_t     acc_prsp_i,
  input  logic          acc_pvalid_i,
  output logic          acc_pready_o,
  // X Interface - Issue ports
  output x_issue_req_t  x_issue_req_o,
  input  x_issue_resp_t x_issue_resp_i,
  output logic          x_issue_valid_o,
  input  logic          x_issue_ready_i,
  output x_register_t   x_register_o,
  output logic          x_register_valid_o,
  input  logic          x_register_ready_i,
  output x_commit_t     x_commit_o,
  output logic          x_commit_valid_o,
  // X Interface - Result ports
  input  x_result_t     x_result_i,
  input  logic          x_result_valid_i,
  output logic          x_result_ready_o,
  // i2f queue interface
  output logic [31:0]   i2f_rdata_o,
  output logic          i2f_rvalid_o,
  input  logic          i2f_rready_i,
  // f2i queue interface
  input  logic [31:0]   f2i_wdata_i,
  input  logic          f2i_wvalid_i,
  output logic          f2i_wready_o,
  /// TCDM Data Interface
  /// Write transactions do not return data on the `P Channel`
  /// Transactions need to be handled strictly in-order.
  output dreq_t         data_req_o,
  input  drsp_t         data_rsp_i,
  // Address Translation interface.
  output logic    [1:0] ptw_valid_o,
  input  logic    [1:0] ptw_ready_i,
  output va_t     [1:0] ptw_va_o,
  output pa_t     [1:0] ptw_ppn_o,
  input  l0_pte_t [1:0] ptw_pte_i,
  input  logic    [1:0] ptw_is_4mega_i,
  // FPU **un-timed** Side-channel
  output fpnew_pkg::roundmode_e     fpu_rnd_mode_o,
  output fpnew_pkg::fmt_mode_t      fpu_fmt_mode_o,
  input  fpnew_pkg::status_t        fpu_status_i,
  /// Consistency Address Queue (CAQ) interface.
  /// Used by FPU to notify Snitch LSU of retired loads/stores.
  input  logic          caq_pvalid_i,
  // Core events for performance counters
  output snitch_pkg::core_events_t  core_events_o,
  // FP Queue CSR
  output logic          en_copift_o,
  // Cluster HW barrier
  output logic          barrier_o,
  input  logic          barrier_i
);
  // Debug module's base address
  localparam logic [31:0] DmBaseAddress = 0;
  localparam int RegWidth = RVE ? 4 : 5;
  /// Total physical address portion.
  localparam int unsigned PPNSize = AddrWidth - PageShift;
  localparam bit NSX = XF16 | XF16ALT | XF8 | XFVEC;

  // Number of read ports
  localparam int unsigned NumRfReadPorts = EnableXif | Xpulppostmod ? 3 : 2;

  logic illegal_inst, illegal_csr;
  logic interrupt, ecall, ebreak;
  logic zero_lsb;

  logic meip, mtip, msip, mcip, mxip;
  logic seip, stip, ssip, scip;
  logic interrupts_enabled;
  logic any_interrupt_pending;

  // Instruction fetch
  logic [31:0] pc_d, pc_q;
  logic wfi_d, wfi_q;
  logic [31:0] consec_pc;
  // Immediates
  logic [31:0] iimm, uimm, jimm, bimm, simm, pbimm;
  /* verilator lint_off WIDTH */
  assign iimm = $signed({inst_data_i[31:20]});
  assign uimm = {inst_data_i[31:12], 12'b0};
  assign jimm = $signed({inst_data_i[31],
                                  inst_data_i[19:12], inst_data_i[20], inst_data_i[30:21], 1'b0});
  assign bimm = $signed({inst_data_i[31],
                                    inst_data_i[7], inst_data_i[30:25], inst_data_i[11:8], 1'b0});
  assign simm = $signed({inst_data_i[31:25], inst_data_i[11:7]});
  assign pbimm = $signed(inst_data_i[24:20]); // Xpulpv2 immediate branching signed immediate
  /* verilator lint_on WIDTH */

  logic [31:0] opa, opb, opc;
  logic [32:0] adder_result;
  logic [31:0] alu_result;

  logic [RegWidth-1:0] rd, rs1, rs2, rs3;
  logic stall, lsu_stall, acc_stall, nonacc_stall, fence_stall, x_stall;
  // Register connections
  logic [NumRfReadPorts-1:0][RegWidth-1:0] gpr_raddr;
  logic [NumRfReadPorts-1:0][31:0]         gpr_rdata;
  logic [0:0][RegWidth-1:0]                gpr_waddr;
  logic [0:0][31:0]                        gpr_wdata;
  logic [0:0]                              gpr_we;
  logic [2**RegWidth-1:0]                  sb_d, sb_q;

  // Decoder output for I2F and F2I instructions
  logic        rs1_is_f2i;
  logic        rs2_is_f2i;
  logic        rd_is_i2f;

  // I2F queue write
  logic        i2f_wready;
  logic        i2f_wvalid;
  logic [31:0] i2f_wdata;
  // F2I queue read
  logic        f2i_rready;
  logic        f2i_rvalid;
  logic [31:0] f2i_rdata;

  // Classify instructions
  logic        is_fp_inst;
  logic        is_acc_inst;

  // Load/Store Defines
  logic is_load, is_store, is_signed;
  logic is_postincr;
  logic is_fp_load, is_fp_store;
  logic ls_misaligned;
  logic ld_addr_misaligned;
  logic st_addr_misaligned;
  logic inst_addr_misaligned;

  logic caq_qvalid, caq_qready, caq_ena, caq_empty;

  logic  itlb_valid, itlb_ready;
  va_t   itlb_va;
  logic  itlb_page_fault;
  pa_t   itlb_pa;

  logic  dtlb_valid, dtlb_ready;
  va_t   dtlb_va;
  logic  dtlb_page_fault;
  pa_t   dtlb_pa;
  logic  trans_ready;
  logic  trans_active;
  logic  itlb_trans_valid, dtlb_trans_valid;
  logic [PPNSize-1:0] trans_active_exp;
  logic  tlb_flush;


  typedef enum logic [1:0] {
    Byte = 2'b00,
    HalfWord = 2'b01,
    Word = 2'b10,
    Double = 2'b11
  } ls_size_e;
  ls_size_e ls_size;

  reqrsp_pkg::amo_op_e ls_amo;

  data_t ld_result;
  logic  lsu_qready, lsu_qvalid;
  logic  lsu_tlb_qready, lsu_tlb_qvalid; // gated version considering TLB and LSU
  logic  lsu_pvalid, lsu_pready;
  logic  lsu_empty;
  addr_t ls_paddr;
  logic [RegWidth-1:0] lsu_rd;

  logic retire_load; // retire a load instruction
  logic retire_p; // retire from post-increment instructions
  logic retire_i; // retire the rest of the base instruction set
  logic retire_acc; // retire an instruction we offloaded
  logic retire_x; // retire an XIF-offloaded instruction

  logic valid_instr;
  logic exception;

  // ALU Operations
  typedef enum logic [3:0]  {
    Add, Sub,
    Slt, Sltu,
    Sll, Srl, Sra,
    LXor, LOr, LAnd, LNAnd,
    Eq, Neq, Ge, Geu,
    BypassA
  } alu_op_e;
  alu_op_e alu_op;

  typedef enum logic [3:0] {
    None, RegRs1, RegRs2, RegRs3, RegRd, IImmediate, UImmediate, JImmediate, SImmediate, SFImmediate, PC, CSR, CSRImmmediate, PBImmediate
  } op_select_e;
  op_select_e opa_select, opb_select, opc_select;

  logic write_rd; // write destination this cycle
  logic write_rs1; // write rs1 destination this cycle
  logic uses_rd;
  typedef enum logic [2:0] {Consec, Alu, Exception, MRet, SRet, DRet} next_pc_e;
  next_pc_e next_pc;

  typedef enum logic [1:0] {RdAlu, RdConsecPC, RdBypass} rd_select_e;
  rd_select_e rd_select;
  logic [31:0] rd_bypass;

  logic is_branch;

  // -----
  // CSRs
  // -----
  logic [31:0] csr_rvalue;
  logic csr_en;
  logic csr_dump;
  logic csr_stall_d, csr_stall_q;
  // Multicast mask
  logic [31:0] csr_mcast_d, csr_mcast_q;

  localparam logic M = 0;
  localparam logic S = 1;

  logic [1:0][31:0] scratch_d, scratch_q;
  logic [1:0][31:0] epc_d, epc_q;
  logic [0:0][31:2] tvec_d, tvec_q;
  logic [0:0][4:0] cause_d, cause_q;
  logic [0:0] cause_irq_d, cause_irq_q;
  logic spp_d, spp_q;
  logic csr_copift_d, csr_copift_q;
  snitch_pkg::priv_lvl_t mpp_d, mpp_q;
  logic [0:0] ie_d, ie_q;
  logic [0:0] pie_d, pie_q;
  // Interrupts
  logic [1:0] eie_d, eie_q;
  logic [1:0] tie_d, tie_q;
  logic [1:0] sie_d, sie_q;
  logic [1:0] cie_d, cie_q;
  logic [1:0] xie_d, xie_q;
  logic       seip_d, seip_q;
  logic       stip_d, stip_q;
  logic       ssip_d, ssip_q;
  logic       scip_d, scip_q;
  snitch_pkg::priv_lvl_t priv_lvl_d, priv_lvl_q;

  typedef struct packed {
    logic mode;
    logic [21:0] ppn;
  } satp_t;
  satp_t satp_d, satp_q;

  dm::dcsr_t dcsr_d, dcsr_q;
  logic [31:0] dpc_d, dpc_q;
  logic [31:0] dscratch_d, dscratch_q;
  logic debug_d, debug_q;

  `FFAR(scratch_q, scratch_d, '0, clk_i, rst_i)
  `FFAR(tvec_q, tvec_d, '0, clk_i, rst_i)
  `FFAR(epc_q, epc_d, '0, clk_i, rst_i)
  `FFAR(satp_q, satp_d, '0, clk_i, rst_i)
  `FFAR(cause_q, cause_d, '0, clk_i, rst_i)
  `FFAR(cause_irq_q, cause_irq_d, '0, clk_i, rst_i)
  `FFAR(priv_lvl_q, priv_lvl_d, snitch_pkg::PrivLvlM, clk_i, rst_i)
  `FFAR(mpp_q, mpp_d, snitch_pkg::PrivLvlU, clk_i, rst_i)
  `FFAR(spp_q, spp_d, 1'b0, clk_i, rst_i)
  `FFAR(ie_q, ie_d, '0, clk_i, rst_i)
  `FFAR(pie_q, pie_d, '0, clk_i, rst_i)
  `FFAR(csr_copift_q, csr_copift_d, 1'b0, clk_i, rst_i)
  // Interrupts
  `FFAR(eie_q, eie_d, '0, clk_i, rst_i)
  `FFAR(tie_q, tie_d, '0, clk_i, rst_i)
  `FFAR(sie_q, sie_d, '0, clk_i, rst_i)
  `FFAR(cie_q, cie_d, '0, clk_i, rst_i)
  `FFAR(xie_q, xie_d, '0, clk_i, rst_i)
  `FFAR(seip_q, seip_d, '0, clk_i, rst_i)
  `FFAR(stip_q, stip_d, '0, clk_i, rst_i)
  `FFAR(ssip_q, ssip_d, '0, clk_i, rst_i)
  `FFAR(scip_q, scip_d, '0, clk_i, rst_i)

  if (DebugSupport) begin : gen_debug
    `FFAR(dcsr_q, dcsr_d, '0, clk_i, rst_i)
    `FFAR(dpc_q, dpc_d, '0, clk_i, rst_i)
    `FFAR(dscratch_q, dscratch_d, '0, clk_i, rst_i)
    `FFAR(debug_q, debug_d, '0, clk_i, rst_i) // Debug mode
  end else begin : gen_no_debug
    assign dcsr_q = '0;
    assign dpc_q  = '0;
    assign dscratch_q = '0;
    assign debug_q = '0;
  end

  `FFAR(csr_stall_q, csr_stall_d, '0, clk_i, rst_i)
  `FFAR(csr_mcast_q, csr_mcast_d, '0, clk_i, rst_i)

  typedef struct packed {
    fpnew_pkg::fmt_mode_t  fmode;
    fpnew_pkg::roundmode_e frm;
    fpnew_pkg::status_t    fflags;
  } fcsr_t;
  fcsr_t fcsr_d, fcsr_q;

  assign fpu_rnd_mode_o = fcsr_q.frm;
  assign fpu_fmt_mode_o = fcsr_q.fmode;

  // Registers
  `FFAR(pc_q, pc_d, BootAddr, clk_i, rst_i)
  `FFAR(wfi_q, wfi_d, '0, clk_i, rst_i)
  `FFAR(sb_q, sb_d, '0, clk_i, rst_i)
  `FFAR(fcsr_q, fcsr_d, '0, clk_i, rst_i)

  // performance counter
  `ifdef SNITCH_ENABLE_PERF
  logic [63:0] cycle_q;
  logic [63:0] instret_q;
  logic retired_instr_q;
  logic retired_load_q;
  logic retired_i_q;
  logic retired_acc_q;
  logic retired_x_q;
  `FFAR(cycle_q, cycle_q + 1, '0, clk_i, rst_i)
  `FFLAR(instret_q, instret_q + 1, !stall, '0, clk_i, rst_i)
  `FFAR(retired_instr_q, !stall, '0, clk_i, rst_i)
  `FFAR(retired_load_q, retire_load, '0, clk_i, rst_i)
  `FFAR(retired_i_q, retire_i, '0, clk_i, rst_i)
  `FFAR(retired_acc_q, retire_acc, '0, clk_i, rst_i)
  `FFAR(retired_x_q, retire_x, '0, clk_i, rst_i)
  assign core_events_o.retired_instr = retired_instr_q;
  assign core_events_o.retired_load = retired_load_q;
  assign core_events_o.retired_i = retired_i_q;
  assign core_events_o.retired_acc = retired_acc_q;
  assign core_events_o.retired_x = retired_x_q;
  `else
  assign core_events_o = '0;
  `endif

  logic [AddrWidth-32-1:0] mseg_q, mseg_d;
  `FFAR(mseg_q, mseg_d, '0, clk_i, rst_i)

  // accelerator offloading interface
  // register int destination in scoreboard
  logic  acc_register_rd;

  assign acc_qreq_o.id = rd;
  assign acc_qreq_o.data_op = inst_data_i;
  assign acc_qreq_o.data_arga = {{32{opa[31]}}, opa};
  assign acc_qreq_o.data_argb = {{32{opb[31]}}, opb};
  // operand C is used for load/store instructions or for multiply-accumulate function
  assign acc_qreq_o.data_argc = (acc_qreq_o.addr == XPULP_IPU) ? {{32{opc[31]}}, opc} : ls_paddr;

  // XIF ID counter
  logic [XifIdWidth-1:0] xif_offload_counter_q;
  `FFLAR(xif_offload_counter_q, xif_offload_counter_q + 1, x_issue_ready_i & x_issue_valid_o, '0, clk_i, rst_i)

  // ---------
  // L0 ITLB
  // ---------
  assign itlb_va = va_t'(pc_q[31:PageShift]);

  if (VMSupport) begin : gen_itlb
    snitch_l0_tlb #(
      .pa_t (pa_t),
      .l0_pte_t (l0_pte_t),
      .NrEntries ( NumITLBEntries )
    ) i_snitch_l0_tlb_inst (
      .clk_i,
      .rst_i,
      .flush_i ( tlb_flush ),
      .priv_lvl_i ( priv_lvl_q ),
      .valid_i ( itlb_valid ),
      .ready_o ( itlb_ready ),
      .va_i ( itlb_va ),
      .write_i ( 1'b0 ),
      .read_i  ( 1'b0 ),
      .execute_i ( 1'b1 ),
      .page_fault_o ( itlb_page_fault ),
      .pa_o ( itlb_pa ),
      // Refill port
      .valid_o ( ptw_valid_o[0] ),
      .ready_i ( ptw_ready_i[0] ),
      .va_o ( ptw_va_o[0] ),
      .pte_i ( ptw_pte_i[0] ),
      .is_4mega_i ( ptw_is_4mega_i[0] )
    );
  end else begin : gen_no_itlb
    // Tie off core-side interface (itlb_pa unused as trans_active == '0)
    assign itlb_pa          = '0;
    assign itlb_ready       = 1'b0;
    assign itlb_page_fault  = 1'b0;
    // Tie off TLB refill request
    assign ptw_valid_o[0] = 1'b0;
    assign ptw_va_o[0]    = '0;
  end

  assign itlb_valid = trans_active & inst_valid_o;
  assign itlb_trans_valid = trans_active & itlb_valid & itlb_ready;

  // ---------------------------
  // Instruction Fetch Interface
  // ---------------------------
  // TODO(paulsc) Add CSR-based segmentation solution for case without VM without sudden jump.
  // Mulitplexer using and/or as this signal is likely timing critical.
  assign inst_addr_o[PPNSize+PageShift-1:PageShift] =
      ({(PPNSize){trans_active}} & itlb_pa)
    | (~{(PPNSize){trans_active}} & {{{AddrWidth-32}{1'b0}}, pc_q[31:PageShift]});
  assign inst_addr_o[PageShift-1:0] = pc_q[PageShift-1:0];
  assign inst_cacheable_o = snitch_pma_pkg::is_inside_cacheable_regions(SnitchPMACfg, inst_addr_o);
  assign inst_valid_o = ~wfi_q && ~csr_stall_q;

  // --------------------
  // Control
  // --------------------
  // Scoreboard: Keep track of rd dependencies
  logic operands_ready;
  logic dst_ready;
  logic opa_ready, opb_ready, opc_ready;
  logic x_issue_hs;

  assign x_issue_hs = EnableXif & x_issue_valid_o & x_issue_ready_i;

  always_comb begin
    sb_d = sb_q;
    if (retire_load) sb_d[lsu_rd] = 1'b0;
    // only place the reservation if we actually executed the load or offload instruction
    if ((is_load | (acc_register_rd & ~(en_copift_o & is_fp_inst)) | (x_issue_hs & x_issue_resp_i.writeback)) && !stall && !exception) sb_d[rd] = 1'b1;
    if (retire_acc) sb_d[acc_prsp_i.id[RegWidth-1:0]] = 1'b0;
    if (EnableXif & retire_x) sb_d[x_result_i.rd] = 1'b0;
    sb_d[0] = 1'b0;
  end
  assign opa_ready = (opa_select != RegRs1) | (rs1_is_f2i ? f2i_rvalid : ~sb_q[rs1]);
  assign opb_ready = ((opb_select != RegRs2) | (rs2_is_f2i ? f2i_rvalid : ~sb_q[rs2])) & ((opb_select != RegRd) | ~sb_q[rd]);
  assign opc_ready = ((opc_select != RegRs2) | (rs2_is_f2i ? f2i_rvalid : ~sb_q[rs2])) & ((opc_select != RegRs3) | ~sb_q[rs3]) & ((opc_select != RegRd) | ~sb_q[rd]);

  assign operands_ready = opa_ready & opb_ready & opc_ready;
  // either we are not using the destination register or we need to make
  // sure that its destination operand is not marked busy in the scoreboard.
  // TODO(colluca): should this include also the additional destination register of postmod instructions?
  assign dst_ready = uses_rd ? (rd_is_i2f ? i2f_wready : ~sb_q[rd]) : 1'b1;

  assign valid_instr = inst_ready_i
                      & inst_valid_o
                      & operands_ready
                      & dst_ready
                      & ((itlb_valid & itlb_ready) | ~trans_active);
  assign acc_qvalid_o = is_acc_inst & valid_instr & ((is_fp_store | is_fp_load) ? (trans_ready & caq_qready) : 1'b1);
  // the accelerator interface stalled us. Also wait for CAQ if this is an FP load/store.
  assign acc_stall = acc_qvalid_o & ~acc_qready_i | (caq_ena & ~caq_qready);
  // the coprocessor is not ready yet
  assign x_stall = EnableXif & ((x_issue_valid_o & ~x_issue_ready_i) | (x_register_valid_o & ~x_register_ready_i));
  // the LSU Interface didn't accept our request yet
  assign lsu_stall = lsu_tlb_qvalid & ~lsu_tlb_qready;
  // Stall the stage if we either didn't get a valid instruction, the LSU is not ready
  // or we are waiting on a fence instruction.
  // We do not include accelerator stalls in this signal for loop-free CAQ enable control.
  assign nonacc_stall = ~valid_instr | lsu_stall | fence_stall;
  // To get the signal for all stall conditions, add the accelerator stalls.
  assign stall = nonacc_stall | acc_stall | x_stall;

  // --------------------
  // Instruction Frontend
  // --------------------
  assign consec_pc = pc_q + ((is_branch & alu_result[0]) ? bimm : 'd4);

  logic [31:0] npc;
  always_comb begin
    pc_d = pc_q;
    npc = pc_q; // the next PC if we wouldn't be in debug mode
    // if we got a valid instruction word increment the PC unless we are waiting for an event
    if (!stall && !wfi_q && !csr_stall_q) begin
      casez (next_pc)
        Consec: npc = consec_pc;
        Alu: npc = alu_result & {{31{1'b1}}, ~zero_lsb};
        Exception: npc = {tvec_q[M], 2'b0};
        MRet: npc = epc_q[M];
        SRet: npc = epc_q[S];
        DRet: npc = dpc_q;
        default:;
      endcase
      // default update
      pc_d = npc;
      // debug mode updates
      // if we are in debug mode, and encounter an exception go to exception address
      // the only exception is EBREAK which terminates the program buffer.
      if (debug_q && next_pc == Exception) begin
        pc_d = (inst_data_i == EBREAK) ?
          DmBaseAddress + dm::HaltAddress : DmBaseAddress + dm::ExceptionAddress;
      end else begin
      end
      if (!debug_q && ((DebugSupport && irq_i.debug) || dcsr_q.step))
        pc_d = DmBaseAddress + dm::HaltAddress;
    end
  end

  // --------------------
  // Decoder
  // --------------------
  assign rd = inst_data_i[7 + RegWidth - 1:7];
  assign rs1 = inst_data_i[15 + RegWidth - 1:15];
  assign rs2 = inst_data_i[20 + RegWidth - 1:20];
  assign rs3 = inst_data_i[27 + RegWidth - 1:27];

  always_comb begin
    illegal_inst = 1'b0;
    ecall = 1'b0;
    ebreak = 1'b0;
    alu_op = Add;
    opa_select = None;
    opb_select = None;
    opc_select = None;

    x_issue_req_o      = '0;
    x_register_o       = '0;
    x_commit_o         = '0;
    x_issue_valid_o    = 1'b0;
    x_register_valid_o = 1'b0;
    x_commit_valid_o   = 1'b0;

    flush_i_valid_o = 1'b0;
    tlb_flush = 1'b0;
    next_pc = Consec;

    rd_select = RdAlu;
    write_rd = 1'b1;
    // if we are writing the field this cycle we need
    // an int destination register
    uses_rd = write_rd;
    // instruction writes rs1 in the decoding cycle
    write_rs1 = 1'b0;

    rd_bypass = '0;
    zero_lsb = 1'b0;
    is_branch = 1'b0;
    // LSU interface
    is_load = 1'b0;
    is_store = 1'b0;
    is_postincr = 1'b0;
    is_fp_load = 1'b0;
    is_fp_store = 1'b0;
    is_signed = 1'b0;
    ls_size = Byte;
    ls_amo = reqrsp_pkg::AMONone;

    is_acc_inst = 1'b0;
    acc_qreq_o.addr = FP_SS;
    acc_register_rd = 1'b0;

    debug_d = (!debug_q && (
          // the external debugger or an ebreak instruction triggerd the
          // request to debug.
          (DebugSupport && irq_i.debug) ||
          // We encountered an ebreak and the default ebreak behaviour is switched off
          (dcsr_q.ebreakm && inst_data_i == EBREAK) ||
          // This was a single-step
          dcsr_q.step)
        ) ? valid_instr : debug_q;

    csr_en = 1'b0;
    fence_stall = 1'b0;

    // Debug request and wake up are possibilties to move out of
    // the low power state.
    wfi_d = ((DebugSupport && irq_i.debug) || debug_q || any_interrupt_pending) ? 1'b0 : wfi_q;

    unique casez (inst_data_i)
      ADD: begin
        opa_select = RegRs1;
        opb_select = RegRs2;
      end
      ADDI: begin
        opa_select = RegRs1;
        opb_select = IImmediate;
      end
      SUB: begin
        alu_op = Sub;
        opa_select = RegRs1;
        opb_select = RegRs2;
      end
      XOR: begin
        opa_select = RegRs1;
        opb_select = RegRs2;
        alu_op = LXor;
      end
      XORI: begin
        alu_op = LXor;
        opa_select = RegRs1;
        opb_select = IImmediate;
      end
      OR: begin
        opa_select = RegRs1;
        opb_select = RegRs2;
        alu_op = LOr;
      end
      ORI: begin
        alu_op = LOr;
        opa_select = RegRs1;
        opb_select = IImmediate;
      end
      AND: begin
        alu_op = LAnd;
        opa_select = RegRs1;
        opb_select = RegRs2;
      end
      ANDI: begin
        alu_op = LAnd;
        opa_select = RegRs1;
        opb_select = IImmediate;
      end
      SLT: begin
        alu_op = Slt;
        opa_select = RegRs1;
        opb_select = RegRs2;
      end
      SLTI: begin
        alu_op = Slt;
        opa_select = RegRs1;
        opb_select = IImmediate;
      end
      SLTU: begin
        alu_op = Sltu;
        opa_select = RegRs1;
        opb_select = RegRs2;
      end
      SLTIU: begin
        alu_op = Sltu;
        opa_select = RegRs1;
        opb_select = IImmediate;
      end
      SLL: begin
        alu_op = Sll;
        opa_select = RegRs1;
        opb_select = RegRs2;
      end
      SRL: begin
        alu_op = Srl;
        opa_select = RegRs1;
        opb_select = RegRs2;
      end
      SRA: begin
        alu_op = Sra;
        opa_select = RegRs1;
        opb_select = RegRs2;
      end
      SLLI: begin
        alu_op = Sll;
        opa_select = RegRs1;
        opb_select = IImmediate;
      end
      SRLI: begin
        alu_op = Srl;
        opa_select = RegRs1;
        opb_select = IImmediate;
      end
      SRAI: begin
        alu_op = Sra;
        opa_select = RegRs1;
        opb_select = IImmediate;
      end
      LUI: begin
        opa_select = None;
        opb_select = None;
        rd_select = RdBypass;
        rd_bypass = uimm;
      end
      AUIPC: begin
        opa_select = UImmediate;
        opb_select = PC;
      end
      JAL: begin
        rd_select = RdConsecPC;
        opa_select = JImmediate;
        opb_select = PC;
        next_pc = Alu;
      end
      JALR: begin
        rd_select = RdConsecPC;
        opa_select = RegRs1;
        opb_select = IImmediate;
        next_pc = Alu;
        zero_lsb = 1'b1;
      end
      // use the ALU for comparisons
      BEQ: begin
        is_branch = 1'b1;
        write_rd = 1'b0;
        alu_op = Eq;
        opa_select = RegRs1;
        opb_select = RegRs2;
      end
      BNE: begin
        is_branch = 1'b1;
        write_rd = 1'b0;
        alu_op = Neq;
        opa_select = RegRs1;
        opb_select = RegRs2;
      end
      BLT: begin
        is_branch = 1'b1;
        write_rd = 1'b0;
        alu_op = Slt;
        opa_select = RegRs1;
        opb_select = RegRs2;
      end
      BLTU: begin
        is_branch = 1'b1;
        write_rd = 1'b0;
        alu_op = Sltu;
        opa_select = RegRs1;
        opb_select = RegRs2;
      end
      BGE: begin
        is_branch = 1'b1;
        write_rd = 1'b0;
        alu_op = Ge;
        opa_select = RegRs1;
        opb_select = RegRs2;
      end
      BGEU: begin
        is_branch = 1'b1;
        write_rd = 1'b0;
        alu_op = Geu;
        opa_select = RegRs1;
        opb_select = RegRs2;
      end
      // Load/Stores
      SB: begin
        write_rd = 1'b0;
        is_store = 1'b1;
        opa_select = RegRs1;
        opb_select = SImmediate;
        opc_select = RegRs2;
      end
      SH: begin
        write_rd = 1'b0;
        is_store = 1'b1;
        ls_size = HalfWord;
        opa_select = RegRs1;
        opb_select = SImmediate;
        opc_select = RegRs2;
      end
      SW: begin
        write_rd = 1'b0;
        is_store = 1'b1;
        ls_size = Word;
        opa_select = RegRs1;
        opb_select = SImmediate;
        opc_select = RegRs2;
      end
      LB: begin
        write_rd = 1'b0;
        uses_rd = 1'b1;
        is_load = 1'b1;
        is_signed = 1'b1;
        opa_select = RegRs1;
        opb_select = IImmediate;
      end
      LH: begin
        write_rd = 1'b0;
        uses_rd = 1'b1;
        is_load = 1'b1;
        is_signed = 1'b1;
        ls_size = HalfWord;
        opa_select = RegRs1;
        opb_select = IImmediate;
      end
      LW: begin
        write_rd = 1'b0;
        uses_rd = 1'b1;
        is_load = 1'b1;
        is_signed = 1'b1;
        ls_size = Word;
        opa_select = RegRs1;
        opb_select = IImmediate;
      end
      LBU: begin
        write_rd = 1'b0;
        uses_rd = 1'b1;
        is_load = 1'b1;
        opa_select = RegRs1;
        opb_select = IImmediate;
      end
      LHU: begin
        write_rd = 1'b0;
        uses_rd = 1'b1;
        is_load = 1'b1;
        ls_size = HalfWord;
        opa_select = RegRs1;
        opb_select = IImmediate;
      end
      // CSR Instructions
      CSRRW: begin // Atomic Read/Write CSR
        opa_select = RegRs1;
        opb_select = None;
        rd_select = RdBypass;
        rd_bypass = csr_rvalue;
        csr_en = valid_instr;
      end
      CSRRWI: begin
        opa_select = CSRImmmediate;
        opb_select = None;
        rd_select = RdBypass;
        rd_bypass = csr_rvalue;
        csr_en = valid_instr;
      end
      CSRRS: begin  // Atomic Read and Set Bits in CSR
        if (inst_data_i[31:20] != CSR_SC) begin
          alu_op = LOr;
          opa_select = RegRs1;
          opb_select = CSR;
          rd_select = RdBypass;
          rd_bypass = csr_rvalue;
          csr_en = valid_instr;
        end else begin
          opa_select = RegRs1;
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end
      end
      CSRRSI: begin
        // offload CSR enable to FP SS
        if (inst_data_i[31:20] != CSR_SSR) begin
          alu_op = LOr;
          opa_select = CSRImmmediate;
          opb_select = CSR;
          rd_select = RdBypass;
          rd_bypass = csr_rvalue;
          csr_en = valid_instr;
        end else begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end
      end
      CSRRC: begin // Atomic Read and Clear Bits in CSR
        if (inst_data_i[31:20] != CSR_SC) begin
          alu_op = LNAnd;
          opa_select = RegRs1;
          opb_select = CSR;
          rd_select = RdBypass;
          rd_bypass = csr_rvalue;
          csr_en = valid_instr;
        end else begin
          opa_select = RegRs1;
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end
      end
      CSRRCI: begin
        if (inst_data_i[31:20] != CSR_SSR) begin
          alu_op = LNAnd;
          opa_select = CSRImmmediate;
          opb_select = CSR;
          rd_select = RdBypass;
          rd_bypass = csr_rvalue;
          csr_en = valid_instr;
        end else begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end
      end
      ECALL: ecall = 1'b1;
      EBREAK: ebreak = 1'b1;
      // Environment return
      SRET: begin
        write_rd = 1'b0;
        if (priv_lvl_q inside {snitch_pkg::PrivLvlM, snitch_pkg::PrivLvlS}) next_pc = SRet;
        else illegal_inst = 1'b1;
      end
      MRET: begin
        write_rd = 1'b0;
        if (priv_lvl_q inside {snitch_pkg::PrivLvlM}) next_pc = MRet;
        else illegal_inst = 1'b1;
      end
      DRET: begin
        if (!debug_q) begin
          illegal_inst = 1'b1;
        end else begin
          next_pc = DRet;
          uses_rd = 1'b0;
          debug_d = ~valid_instr;
        end
      end
      FENCE: begin
        fence_stall = valid_instr && !(lsu_empty && caq_empty);
        write_rd = 1'b0;
      end
      FENCE_I: begin
        flush_i_valid_o = valid_instr;
        fence_stall = flush_i_valid_o & ~flush_i_ready_i;
      end
      SFENCE_VMA: begin
        if (priv_lvl_q == PrivLvlU) illegal_inst = 1'b1;
        else tlb_flush = valid_instr;
      end
      WFI: begin
        if (priv_lvl_q == PrivLvlU) illegal_inst = 1'b1;
        else if (!debug_q && valid_instr) wfi_d = 1'b1;
      end
      // Atomics
      AMOADD_W: begin
        alu_op = BypassA;
        write_rd = 1'b0;
        uses_rd = 1'b1;
        is_load = 1'b1;
        is_signed = 1'b1;
        ls_size = Word;
        ls_amo = reqrsp_pkg::AMOAdd;
        opa_select = RegRs1;
        opb_select = RegRs2;
      end
      AMOXOR_W: begin
        alu_op = BypassA;
        write_rd = 1'b0;
        uses_rd = 1'b1;
        is_load = 1'b1;
        is_signed = 1'b1;
        ls_size = Word;
        ls_amo = reqrsp_pkg::AMOXor;
        opa_select = RegRs1;
        opb_select = RegRs2;
      end
      AMOOR_W: begin
        alu_op = BypassA;
        write_rd = 1'b0;
        uses_rd = 1'b1;
        is_load = 1'b1;
        is_signed = 1'b1;
        ls_size = Word;
        ls_amo = reqrsp_pkg::AMOOr;
        opa_select = RegRs1;
        opb_select = RegRs2;
      end
      AMOAND_W: begin
        alu_op = BypassA;
        write_rd = 1'b0;
        uses_rd = 1'b1;
        is_load = 1'b1;
        is_signed = 1'b1;
        ls_size = Word;
        ls_amo = reqrsp_pkg::AMOAnd;
        opa_select = RegRs1;
        opb_select = RegRs2;
      end
      AMOMIN_W: begin
        alu_op = BypassA;
        write_rd = 1'b0;
        uses_rd = 1'b1;
        is_load = 1'b1;
        is_signed = 1'b1;
        ls_size = Word;
        ls_amo = reqrsp_pkg::AMOMin;
        opa_select = RegRs1;
        opb_select = RegRs2;
      end
      AMOMAX_W: begin
        alu_op = BypassA;
        write_rd = 1'b0;
        uses_rd = 1'b1;
        is_load = 1'b1;
        is_signed = 1'b1;
        ls_size = Word;
        ls_amo = reqrsp_pkg::AMOMax;
        opa_select = RegRs1;
        opb_select = RegRs2;
      end
      AMOMINU_W: begin
        alu_op = BypassA;
        write_rd = 1'b0;
        uses_rd = 1'b1;
        is_load = 1'b1;
        is_signed = 1'b1;
        ls_size = Word;
        ls_amo = reqrsp_pkg::AMOMinu;
        opa_select = RegRs1;
        opb_select = RegRs2;
      end
      AMOMAXU_W: begin
        alu_op = BypassA;
        write_rd = 1'b0;
        uses_rd = 1'b1;
        is_load = 1'b1;
        is_signed = 1'b1;
        ls_size = Word;
        ls_amo = reqrsp_pkg::AMOMaxu;
        opa_select = RegRs1;
        opb_select = RegRs2;
      end
      AMOSWAP_W: begin
        alu_op = BypassA;
        write_rd = 1'b0;
        uses_rd = 1'b1;
        is_load = 1'b1;
        is_signed = 1'b1;
        ls_size = Word;
        ls_amo = reqrsp_pkg::AMOSwap;
        opa_select = RegRs1;
        opb_select = RegRs2;
      end
      LR_W: begin
        alu_op = BypassA;
        write_rd = 1'b0;
        uses_rd = 1'b1;
        is_load = 1'b1;
        is_signed = 1'b1;
        ls_size = Word;
        ls_amo = reqrsp_pkg::AMOLR;
        opa_select = RegRs1;
        opb_select = RegRs2;
      end
      SC_W: begin
        alu_op = BypassA;
        write_rd = 1'b0;
        uses_rd = 1'b1;
        is_load = 1'b1;
        is_signed = 1'b1;
        ls_size = Word;
        ls_amo = reqrsp_pkg::AMOSC;
        opa_select = RegRs1;
        opb_select = RegRs2;
      end
      // Off-load to shared multiplier
      MUL,
      MULH,
      MULHSU,
      MULHU,
      DIV,
      DIVU,
      REM,
      REMU,
      MULW,
      DIVW,
      DIVUW,
      REMW, 
      REMUW: begin
        write_rd = 1'b0;
        uses_rd = 1'b1;
        is_acc_inst = 1'b1;
        opa_select = RegRs1;
        opb_select = RegRs2;
        acc_register_rd = 1'b1;
        acc_qreq_o.addr = Xpulpv2 ? XPULP_IPU : SHARED_MULDIV;
      end                         
      P_ABS: begin                 // Xpulpv2: p.abs
        if (Xpulpabs) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
          opa_select = RegRs1;
          acc_register_rd = 1'b1;
          acc_qreq_o.addr = XPULP_IPU;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      P_EXTHS,                       // Xpulpv2: p.exths
      P_EXTHZ,                       // Xpulpv2: p.exthz
      P_EXTBS,                       // Xpulpv2: p.extbs
      P_EXTBZ: begin                 // Xpulpv2: p.extbz
        if (Xpulpbitop) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
          opa_select = RegRs1;
          acc_register_rd = 1'b1;
          acc_qreq_o.addr = XPULP_IPU;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      // Immediate branching
      P_BEQIMM: begin // Xpulpv2: p.beqimm
        if (Xpulpbr) begin
          is_branch = 1'b1;
          write_rd = 1'b0;
          uses_rd = 1'b0;
          alu_op = Eq;
          opa_select = RegRs1;
          opb_select = PBImmediate;
          acc_qreq_o.addr = XPULP_IPU;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      P_BNEIMM: begin // Xpulpv2: p.bneimm
        if (Xpulpbr) begin
          is_branch = 1'b1;
          write_rd = 1'b0;
          uses_rd = 1'b0;
          alu_op = Neq;
          opa_select = RegRs1;
          opb_select = PBImmediate;
          acc_qreq_o.addr = XPULP_IPU;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      P_CLIP,               // Xpulpv2: p.clip
      P_CLIPU: begin // Xpulpv2: pv.dotsp.sci.b
        if (Xpulpclip) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
          opa_select = RegRs1;
          acc_register_rd = 1'b1;
          acc_qreq_o.addr = XPULP_IPU;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      P_CLIPR,        // Xpulpv2: p.clipr
      P_CLIPUR: begin // Xpulpv2: p.clipur
        if (Xpulpclip) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
          opa_select = RegRs1;
          opb_select = RegRs2;
          acc_register_rd = 1'b1;
          acc_qreq_o.addr = XPULP_IPU;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      // 3 source registers (rs1, rs2, rd)
      // xpulpmacsi_custom extension
      P_MAC,                // Xpulpv2: p.mac
      P_MSU: begin          // Xpulpv2: p.msu
        if (Xpulpmacsi) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
          opa_select = RegRs1;
          opb_select = RegRs2;
          opc_select = RegRd;
          acc_register_rd = 1'b1;
          acc_qreq_o.addr = XPULP_IPU;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      // 2 source registers (rs1, rs2)
      // xpulpminmax_custom extension
      P_MIN,               // Xpulpv2: p.min
      P_MINU,              // Xpulpv2: p.minu
      P_MAX,               // Xpulpv2: p.max
      P_MAXU: begin        // Xpulpv2: p.maxu
        if (Xpulpminmax) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
          opa_select = RegRs1;
          opb_select = RegRs2;
          acc_register_rd = 1'b1;
          acc_qreq_o.addr = XPULP_IPU;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      // 2 source registers (rs1, rs2)
      // xpulpslet_custom extension
      P_SLET,              // Xpulpv2: p.slet
      P_SLETU: begin       // Xpulpv2: p.sletu
        if (Xpulpslet) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
          opa_select = RegRs1;
          opb_select = RegRs2;
          acc_register_rd = 1'b1;
          acc_qreq_o.addr = XPULP_IPU;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      // Off-load to IPU coprocessor
      // 1 source register (rs1)
      PV_ADD_SCI_H,         // Xpulpv2: pv.add.sci.h
      PV_ADD_SCI_B,         // Xpulpv2: pv.add.sci.b
      PV_SUB_SCI_H,         // Xpulpv2: pv.sub.sci.h
      PV_SUB_SCI_B,         // Xpulpv2: pv.sub.sci.b
      PV_AVG_SCI_H,         // Xpulpv2: pv.avg.sci.h
      PV_AVG_SCI_B,         // Xpulpv2: pv.avg.sci.b
      PV_AVGU_SCI_H,        // Xpulpv2: pv.avgu.sci.h
      PV_AVGU_SCI_B,        // Xpulpv2: pv.avgu.sci.b
      PV_MIN_SCI_H,         // Xpulpv2: pv.min.sci.h
      PV_MIN_SCI_B,         // Xpulpv2: pv.min.sci.b
      PV_MINU_SCI_H,        // Xpulpv2: pv.minu.sci.h
      PV_MINU_SCI_B,        // Xpulpv2: pv.minu.sci.b
      PV_MAX_SCI_H,         // Xpulpv2: pv.max.sci.h
      PV_MAX_SCI_B,         // Xpulpv2: pv.max.sci.b
      PV_MAXU_SCI_H,        // Xpulpv2: pv.maxu.sci.h
      PV_MAXU_SCI_B,        // Xpulpv2: pv.maxu.sci.b
      PV_SRL_SCI_H,         // Xpulpv2: pv.srl.sci.h
      PV_SRL_SCI_B,         // Xpulpv2: pv.srl.sci.b
      PV_SRA_SCI_H,         // Xpulpv2: pv.sra.sci.h
      PV_SRA_SCI_B,         // Xpulpv2: pv.sra.sci.b
      PV_SLL_SCI_H,         // Xpulpv2: pv.sll.sci.h
      PV_SLL_SCI_B,         // Xpulpv2: pv.sll.sci.b
      PV_OR_SCI_H,          // Xpulpv2: pv.or.sci.h
      PV_OR_SCI_B,          // Xpulpv2: pv.or.sci.b
      PV_XOR_SCI_H,         // Xpulpv2: pv.xor.sci.h
      PV_XOR_SCI_B,         // Xpulpv2: pv.xor.sci.b
      PV_AND_SCI_B,         // Xpulpv2: pv.and.sci.b
      PV_AND_SCI_H,         // Xpulpv2: pv.and.sci.h
      PV_ABS_H,             // Xpulpv2: pv.abs.h
      PV_ABS_B,             // Xpulpv2: pv.abs.b
      PV_EXTRACT_H,         // Xpulpv2: pv.extract.h
      PV_EXTRACT_B,         // Xpulpv2: pv.extract.b
      PV_EXTRACTU_H,        // Xpulpv2: pv.extractu.h
      PV_EXTRACTU_B,        // Xpulpv2: pv.extractu.b
      PV_DOTUP_SCI_H,       // Xpulpv2: pv.dotup.sci.h
      PV_DOTUP_SCI_B,       // Xpulpv2: pv.dotup.sci.b
      PV_DOTUSP_SCI_H,      // Xpulpv2: pv.dotusp.sci.h
      PV_DOTUSP_SCI_B,      // Xpulpv2: pv.dotusp.sci.b
      PV_DOTSP_SCI_H,       // Xpulpv2: pv.dotsp.sci.h
      PV_DOTSP_SCI_B: begin // Xpulpv2: pv.dotsp.sci.b
        if (Xpulpvect) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
          opa_select = RegRs1;
          acc_register_rd = 1'b1;
          acc_qreq_o.addr = XPULP_IPU;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      // 2 source registers (rs1, rs2)
      // xpulpvect_custom extension
      PV_ADD_H,            // Xpulpv2: pv.add.h
      PV_ADD_SC_H,         // Xpulpv2: pv.add.sc.h
      PV_ADD_B,            // Xpulpv2: pv.add.b
      PV_ADD_SC_B,         // Xpulpv2: pv.add.sc.b
      PV_SUB_H,            // Xpulpv2: pv.sub.h
      PV_SUB_SC_H,         // Xpulpv2: pv.sub.sc.h
      PV_SUB_B,            // Xpulpv2: pv.sub.b
      PV_SUB_SC_B,         // Xpulpv2: pv.sub.sc.b
      PV_AVG_H,            // Xpulpv2: pv.avg.h
      PV_AVG_SC_H,         // Xpulpv2: pv.avg.sc.h
      PV_AVG_B,            // Xpulpv2: pv.avg.b
      PV_AVG_SC_B,         // Xpulpv2: pv.avg.sc.b
      PV_AVGU_H,           // Xpulpv2: pv.avgu.h
      PV_AVGU_SC_H,        // Xpulpv2: pv.avgu.sc.h
      PV_AVGU_B,           // Xpulpv2: pv.avgu.b
      PV_AVGU_SC_B,        // Xpulpv2: pv.avgu.sc.b
      PV_MIN_H,            // Xpulpv2: pv.min.h
      PV_MIN_SC_H,         // Xpulpv2: pv.min.sc.h
      PV_MIN_B,            // Xpulpv2: pv.min.b
      PV_MIN_SC_B,         // Xpulpv2: pv.min.sc.b
      PV_MINU_H,           // Xpulpv2: pv.minu.h
      PV_MINU_SC_H,        // Xpulpv2: pv.minu.sc.h
      PV_MINU_B,           // Xpulpv2: pv.minu.b
      PV_MINU_SC_B,        // Xpulpv2: pv.minu.sc.b
      PV_MAX_H,            // Xpulpv2: pv.max.h
      PV_MAX_SC_H,         // Xpulpv2: pv.max.sc.h
      PV_MAX_B,            // Xpulpv2: pv.max.b
      PV_MAX_SC_B,         // Xpulpv2: pv.max.sc.b
      PV_MAXU_H,           // Xpulpv2: pv.maxu.h
      PV_MAXU_SC_H,        // Xpulpv2: pv.maxu.sc.h
      PV_MAXU_B,           // Xpulpv2: pv.maxu.b
      PV_MAXU_SC_B,        // Xpulpv2: pv.maxu.sc.b
      PV_SRL_H,            // Xpulpv2: pv.srl.h
      PV_SRL_SC_H,         // Xpulpv2: pv.srl.sc.h
      PV_SRL_B,            // Xpulpv2: pv.srl.b
      PV_SRL_SC_B,         // Xpulpv2: pv.srl.sc.b
      PV_SRA_H,            // Xpulpv2: pv.sra.h
      PV_SRA_SC_H,         // Xpulpv2: pv.sra.sc.h
      PV_SRA_B,            // Xpulpv2: pv.sra.b
      PV_SRA_SC_B,         // Xpulpv2: pv.sra.sc.b
      PV_SLL_H,            // Xpulpv2: pv.sll.h
      PV_SLL_SC_H,         // Xpulpv2: pv.sll.sc.h
      PV_SLL_B,            // Xpulpv2: pv.sll.b
      PV_SLL_SC_B,         // Xpulpv2: pv.sll.sc.b
      PV_OR_H,             // Xpulpv2: pv.or.h
      PV_OR_SC_H,          // Xpulpv2: pv.or.sc.h
      PV_OR_B,             // Xpulpv2: pv.or.b
      PV_OR_SC_B,          // Xpulpv2: pv.or.sc.b
      PV_XOR_H,            // Xpulpv2: pv.xor.h
      PV_XOR_SC_H,         // Xpulpv2: pv.xor.sc.h
      PV_XOR_B,            // Xpulpv2: pv.xor.b
      PV_XOR_SC_B,         // Xpulpv2: pv.xor.sc.b
      PV_AND_H,            // Xpulpv2: pv.and.h
      PV_AND_SC_H,         // Xpulpv2: pv.and.sc.h
      PV_AND_B,            // Xpulpv2: pv.and.b
      PV_AND_SC_B,         // Xpulpv2: pv.and.sc.b
      PV_DOTUP_H,          // Xpulpv2: pv.dotup.h
      PV_DOTUP_SC_H,       // Xpulpv2: pv.dotup.sc.h
      PV_DOTUP_B,          // Xpulpv2: pv.dotup.b
      PV_DOTUP_SC_B,       // Xpulpv2: pv.dotup.sc.b
      PV_DOTUSP_H,         // Xpulpv2: pv.dotusp.h
      PV_DOTUSP_SC_H,      // Xpulpv2: pv.dotusp.sc.h
      PV_DOTUSP_B,         // Xpulpv2: pv.dotusp.b
      PV_DOTUSP_SC_B,      // Xpulpv2: pv.dotusp.sc.b
      PV_DOTSP_H,          // Xpulpv2: pv.dotsp.h
      PV_DOTSP_SC_H,       // Xpulpv2: pv.dotsp.sc.h
      PV_DOTSP_B,          // Xpulpv2: pv.dotsp.b
      PV_DOTSP_SC_B: begin // Xpulpv2: pv.dotsp.sc.b
        if (Xpulpvect) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
          opa_select = RegRs1;
          opb_select = RegRs2;
          acc_register_rd = 1'b1;
          acc_qreq_o.addr = XPULP_IPU;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      // 2 source registers (rs1, rd)
      PV_INSERT_H,           // Xpulpv2: pv.insert.h
      PV_INSERT_B,           // Xpulpv2: pv.insert.b
      PV_SDOTUP_SCI_H,       // Xpulpv2: pv.sdotup.sci.h
      PV_SDOTUP_SCI_B,       // Xpulpv2: pv.sdotup.sci.b
      PV_SDOTUSP_SCI_H,      // Xpulpv2: pv.sdotusp.sci.h
      PV_SDOTUSP_SCI_B,      // Xpulpv2: pv.sdotusp.sci.b
      PV_SDOTSP_SCI_H,       // Xpulpv2: pv.sdotsp.sci.h
      PV_SDOTSP_SCI_B: begin // Xpulpv2: pv.sdotsp.sci.b
        if (Xpulpvect) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
          opa_select = RegRs1;
          opc_select = RegRd;
          acc_register_rd = 1'b1;
          acc_qreq_o.addr = XPULP_IPU;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      // 3 source registers (rs1, rs2, rd)
      PV_SDOTUP_H,          // Xpulpv2: pv.sdotup.h
      PV_SDOTUP_SC_H,       // Xpulpv2: pv.sdotup.sc.h
      PV_SDOTUP_B,          // Xpulpv2: pv.sdotup.b
      PV_SDOTUP_SC_B,       // Xpulpv2: pv.sdotup.sc.b
      PV_SDOTUSP_H,         // Xpulpv2: pv.sdotusp.h
      PV_SDOTUSP_SC_H,      // Xpulpv2: pv.sdotusp.sc.h
      PV_SDOTUSP_B,         // Xpulpv2: pv.sdotusp.b
      PV_SDOTUSP_SC_B,      // Xpulpv2: pv.sdotusp.sc.b
      PV_SDOTSP_H,          // Xpulpv2: pv.sdotsp.h
      PV_SDOTSP_SC_H,       // Xpulpv2: pv.sdotsp.sc.h
      PV_SDOTSP_B,          // Xpulpv2: pv.sdotsp.b
      PV_SDOTSP_SC_B: begin // Xpulpv2: pv.sdotsp.sc.b
        if (Xpulpvect) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
          opa_select = RegRs1;
          opb_select = RegRs2;
          opc_select = RegRd;
          acc_register_rd = 1'b1;
          acc_qreq_o.addr = XPULP_IPU;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      // Offload FP-FP Instructions - fire and forget
      // TODO (smach): Check legal rounding modes and issue illegal isn if needed
      // Single Precision Floating-Point
      FADD_S,
      FSUB_S,
      FMUL_S,
      FDIV_S,
      FSGNJ_S,
      FSGNJN_S,
      FSGNJX_S,
      FMIN_S,
      FMAX_S,
      FSQRT_S,
      FMADD_S,
      FMSUB_S,
      FNMSUB_S,
      FNMADD_S: begin
        if (FP_EN && RVF
          && (!(inst_data_i inside {FDIV_S, FSQRT_S}) || XDivSqrt)) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      // Vectors
      VFADD_S,
      VFADD_R_S,
      VFSUB_S,
      VFSUB_R_S,
      VFMUL_S,
      VFMUL_R_S,
      VFDIV_S,
      VFDIV_R_S,
      VFMIN_S,
      VFMIN_R_S,
      VFMAX_S,
      VFMAX_R_S,
      VFSQRT_S,
      VFMAC_S,
      VFMAC_R_S,
      VFMRE_S,
      VFMRE_R_S,
      VFSGNJ_S,
      VFSGNJ_R_S,
      VFSGNJN_S,
      VFSGNJN_R_S,
      VFSGNJX_S,
      VFSGNJX_R_S,
      VFCPKA_S_S,
      VFCPKA_S_D: begin
        if (FP_EN && XFVEC && RVF && RVD
            && (!(inst_data_i inside {VFDIV_S, VFDIV_R_S, VFSQRT_S}) || XDivSqrt)) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      VFSUM_S,
      VFNSUM_S: begin
        if (FP_EN && XFVEC && FLEN >= 64 && XFDOTP && RVF) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      // Double Precision Floating-Point
      FADD_D,
      FSUB_D,
      FMUL_D,
      FDIV_D,
      FSGNJ_D,
      FSGNJN_D,
      FSGNJX_D,
      FMIN_D,
      FMAX_D,
      FSQRT_D,
      FMADD_D,
      FMSUB_D,
      FNMSUB_D,
      FNMADD_D: begin
        if (FP_EN && RVD && (!(inst_data_i inside {FDIV_D, FSQRT_D}) || XDivSqrt)) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      FCVT_S_D,
      FCVT_D_S: begin
        if (FP_EN && RVF && RVD) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      // [Alt] Half Precision Floating-Point
      FADD_H,
      FSUB_H,
      FMUL_H,
      FDIV_H,
      FSQRT_H,
      FMADD_H,
      FMSUB_H,
      FNMSUB_H,
      FNMADD_H,
      FSGNJ_H,
      FSGNJN_H,
      FSGNJX_H,
      FMIN_H,
      FMAX_H: begin
        if (FP_EN && XF16 && fcsr_q.fmode.dst == 1'b0 &&
            (!(inst_data_i inside {FDIV_H, FSQRT_H}) || XDivSqrt)) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else if (FP_EN && XF16ALT && fcsr_q.fmode.dst == 1'b1 &&
            (!(inst_data_i inside {VFDIV_H, VFDIV_R_H, VFSQRT_H}) || XDivSqrt)) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      FMACEX_S_H,
      FMULEX_S_H: begin
        if (FP_EN && RVF && XF16 && XFAUX) begin      
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      FCVT_S_H: begin
        if (FP_EN && RVF && XF16 && fcsr_q.fmode.src == 1'b0) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else if (FP_EN && RVF && XF16ALT && fcsr_q.fmode.src == 1'b1) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      FCVT_H_S: begin
        if (FP_EN && RVF && XF16 && fcsr_q.fmode.dst == 1'b0) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else if (FP_EN && RVF && XF16ALT && fcsr_q.fmode.dst == 1'b1) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      FCVT_D_H: begin
        if (FP_EN && RVD && XF16 && fcsr_q.fmode.src == 1'b0) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else if (FP_EN && RVD && XF16ALT && fcsr_q.fmode.src == 1'b1) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      FCVT_H_D: begin
        if (FP_EN && RVD && XF16 && fcsr_q.fmode.dst == 1'b0) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else if (FP_EN && RVD && XF16ALT && fcsr_q.fmode.dst == 1'b1) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      // FCVT_H_H: begin
      //   if (FP_EN && XF16 && XF16ALT &&
      //      (fcsr_q.fmode.src != fcsr_q.fmode.dst)) begin
      //     write_rd = 1'b0;
      //     is_acc_inst = 1'b1;
      //   end else begin
      //     illegal_inst = 1'b1;
      //   end
      // end

      // Vectorized [Alt] Half Precision Floating-Point
      VFADD_H,
      VFADD_R_H,
      VFSUB_H,
      VFSUB_R_H,
      VFMUL_H,
      VFMUL_R_H,
      VFDIV_H,
      VFDIV_R_H,
      VFMIN_H,
      VFMIN_R_H,
      VFMAX_H,
      VFMAX_R_H,
      VFSQRT_H,
      VFMAC_H,
      VFMAC_R_H,
      VFMRE_H,
      VFMRE_R_H,
      VFSGNJ_H,
      VFSGNJ_R_H,
      VFSGNJN_H,
      VFSGNJN_R_H,
      VFSGNJX_H,
      VFSGNJX_R_H: begin
        if (FP_EN && XFVEC && FLEN >= 32) begin
          if (XF16 && fcsr_q.fmode.dst == 1'b0 &&
              (!(inst_data_i inside {VFDIV_H, VFDIV_R_H, VFSQRT_H}) || XDivSqrt)) begin
            write_rd = 1'b0;
            is_acc_inst = 1'b1;
          end else if (XF16ALT && fcsr_q.fmode.dst == 1'b1 &&
              (!(inst_data_i inside {VFDIV_H, VFDIV_R_H, VFSQRT_H}) || XDivSqrt)) begin
            write_rd = 1'b0;
            is_acc_inst = 1'b1;
          end else begin
            illegal_inst = 1'b1;
          end
        end else begin
          illegal_inst = 1'b1;
        end
      end
      VFSUM_H,
      VFNSUM_H: begin
        if (FP_EN && XFVEC && FLEN >= 64 && XFDOTP) begin
          if ((XF16 && fcsr_q.fmode.src == 1'b0) ||
             (XF16ALT && fcsr_q.fmode.src == 1'b1)) begin
            write_rd = 1'b0;
            is_acc_inst = 1'b1;
          end else begin
            illegal_inst = 1'b1;
          end
        end else begin
          illegal_inst = 1'b1;
        end
      end
      VFCVT_D_S,
      VFCVTU_D_S: begin
        if (FP_EN && XFVEC && RVF && FLEN >= 32) begin
          if (RVF && RVD) begin
            write_rd = 1'b0;
            is_acc_inst = 1'b1;
          end else begin
            illegal_inst = 1'b1;
          end
        end else begin
          illegal_inst = 1'b1;
        end
      end
      VFCPKA_H_S,
      VFCPKB_H_S,
      VFCVT_H_S,
      VFCVTU_H_S: begin
        if (FP_EN && XFVEC && RVF && FLEN >= 32) begin
          if (XF16 && fcsr_q.fmode.dst == 1'b0) begin
            write_rd = 1'b0;
            is_acc_inst = 1'b1;
          end else if (XF16ALT && fcsr_q.fmode.dst == 1'b1) begin
            write_rd = 1'b0;
            is_acc_inst = 1'b1;
          end else begin
            illegal_inst = 1'b1;
          end
        end else begin
          illegal_inst = 1'b1;
        end
      end
      VFCVT_S_H,
      VFCVTU_S_H: begin
        if (FP_EN && XFVEC && RVF && FLEN >= 32) begin
          if (XF16 && fcsr_q.fmode.src == 1'b0) begin
            write_rd = 1'b0;
            is_acc_inst = 1'b1;
          end else if (XF16ALT && fcsr_q.fmode.src == 1'b1) begin
            write_rd = 1'b0;
            is_acc_inst = 1'b1;
          end else begin
            illegal_inst = 1'b1;
          end
        end else begin
          illegal_inst = 1'b1;
        end
      end
      VFCPKA_H_D,
      VFCPKB_H_D: begin
        if (FP_EN && XFVEC && RVD && FLEN >= 32) begin
          if (XF16 && fcsr_q.fmode.dst == 1'b0) begin
            write_rd = 1'b0;
            is_acc_inst = 1'b1;
          end else if (XF16ALT && fcsr_q.fmode.dst == 1'b1) begin
            write_rd = 1'b0;
            is_acc_inst = 1'b1;
          end else begin
            illegal_inst = 1'b1;
          end
        end else begin
          illegal_inst = 1'b1;
        end
      end
      VFCVT_H_H,
      VFCVTU_H_H: begin
        if (FP_EN && XFVEC && RVF && XF16 && XF16ALT && FLEN >= 32) begin
          if (fcsr_q.fmode.src != fcsr_q.fmode.dst) begin
            write_rd = 1'b0;
            is_acc_inst = 1'b1;
          end else begin
            illegal_inst = 1'b1;
          end
        end else begin
          illegal_inst = 1'b1;
        end
      end
      VFDOTPEX_S_H,
      VFDOTPEX_S_R_H,
      VFNDOTPEX_S_H,
      VFNDOTPEX_S_R_H,
      VFSUMEX_S_H,
      VFNSUMEX_S_H: begin
        if (FP_EN && XFVEC && FLEN >= 64 && XFDOTP && RVF) begin
          if ((XF16 && fcsr_q.fmode.src == 1'b0) ||
             (XF16ALT && fcsr_q.fmode.src == 1'b1)) begin
            write_rd = 1'b0;
            is_acc_inst = 1'b1;
          end else begin
            illegal_inst = 1'b1;
          end
        end else begin
          illegal_inst = 1'b1;
        end
      end
      // [Alternate] Quarter Precision Floating-Point
      FADD_B,
      FSUB_B,
      FMUL_B,
      // FDIV_B,
      FSGNJ_B,
      FSGNJN_B,
      FSGNJX_B,
      FMIN_B,
      FMAX_B,
      // FSQRT_B,
      FMADD_B,
      FMSUB_B,
      FNMSUB_B,
      FNMADD_B: begin
        if (FP_EN && XF8 && fcsr_q.fmode.dst == 1'b0) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else if (FP_EN && XF8ALT && fcsr_q.fmode.dst == 1'b1) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      FMACEX_S_B,
      FMULEX_S_B: begin
        if (FP_EN && RVF && XF16 && XFAUX) begin    
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      FCVT_S_B: begin
        if (FP_EN && RVF && XF8 && fcsr_q.fmode.src == 1'b0) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else if (FP_EN && RVF && XF8ALT && fcsr_q.fmode.src == 1'b1) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      FCVT_B_S: begin
        if (FP_EN && RVF && XF8 && fcsr_q.fmode.dst == 1'b0) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else if (FP_EN && RVF && XF8ALT && fcsr_q.fmode.dst == 1'b1) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      FCVT_D_B: begin
        if (FP_EN && RVD && XF8 && fcsr_q.fmode.src == 1'b0) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else if (FP_EN && RVD && XF8ALT && fcsr_q.fmode.src == 1'b1) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      FCVT_B_D: begin
        if (FP_EN && RVD && XF8 && fcsr_q.fmode.dst == 1'b0) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else if (FP_EN && RVF && XF8ALT && fcsr_q.fmode.dst == 1'b1) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      FCVT_H_B: begin
        if (FP_EN) begin
          if ((XF8 && fcsr_q.fmode.src == 1'b0) ||
             (XF8ALT && fcsr_q.fmode.src == 1'b1)) begin
            if ((XF16 && fcsr_q.fmode.dst == 1'b0) ||
               (XF16ALT && fcsr_q.fmode.dst == 1'b1)) begin
              write_rd = 1'b0;
              is_acc_inst = 1'b1;
            end else begin
              illegal_inst = 1'b1;
            end
          end else begin
            illegal_inst = 1'b1;
          end
        end else begin
          illegal_inst = 1'b1;
        end
      end
      FCVT_B_H: begin
        if (FP_EN) begin
          if ((XF16 && fcsr_q.fmode.src == 1'b0) ||
             (XF16ALT && fcsr_q.fmode.src == 1'b1)) begin
            if ((XF8 && fcsr_q.fmode.dst == 1'b0) ||
               (XF8ALT && fcsr_q.fmode.dst == 1'b1)) begin
              write_rd = 1'b0;
              is_acc_inst = 1'b1;
            end else begin
              illegal_inst = 1'b1;
            end
          end else begin
            illegal_inst = 1'b1;
          end
        end else begin
          illegal_inst = 1'b1;
        end
      end
      // Vectorized [Alternate] Quarter Precision Floating-Point
      VFADD_B,
      VFADD_R_B,
      VFSUB_B,
      VFSUB_R_B,
      VFMUL_B,
      VFMUL_R_B,
      VFDIV_B,
      VFDIV_R_B,
      VFMIN_B,
      VFMIN_R_B,
      VFMAX_B,
      VFMAX_R_B,
      VFSQRT_B,
      VFMAC_B,
      VFMAC_R_B,
      VFMRE_B,
      VFMRE_R_B,
      VFSGNJ_B,
      VFSGNJ_R_B,
      VFSGNJN_B,
      VFSGNJN_R_B,
      VFSGNJX_B,
      VFSGNJX_R_B: begin
        if (FP_EN && XFVEC && XF8 && FLEN >= 16			
          && (!(inst_data_i inside {VFDIV_B, VFDIV_R_B, VFSQRT_B}) || XDivSqrt)) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      VFSUM_B,
      VFNSUM_B: begin
        if (FP_EN && XFVEC && FLEN >= 32 && XFDOTP) begin
          if ((XF8 && fcsr_q.fmode.src == 1'b0) ||
             (XF8ALT && fcsr_q.fmode.src == 1'b1)) begin
            write_rd = 1'b0;
            is_acc_inst = 1'b1;
          end else begin
            illegal_inst = 1'b1;
          end
        end else begin
          illegal_inst = 1'b1;
        end
      end
      VFCVT_B_S,
      VFCVTU_B_S,
      VFCPKA_B_S,
      VFCPKB_B_S,
      VFCPKC_B_S,
      VFCPKD_B_S: begin
        if (FP_EN && XFVEC && RVF && FLEN >= 16) begin
          if (XF8 && fcsr_q.fmode.dst == 1'b0) begin
            write_rd = 1'b0;
            is_acc_inst = 1'b1;
          end else if (XF8ALT && fcsr_q.fmode.dst == 1'b1) begin
            write_rd = 1'b0;
            is_acc_inst = 1'b1;
          end else begin
            illegal_inst = 1'b1;
          end
        end else begin
          illegal_inst = 1'b1;
        end
      end
      VFCVT_S_B,
      VFCVTU_S_B: begin
        if (FP_EN && XFVEC && RVF && FLEN >= 16) begin
          if (XF8 && fcsr_q.fmode.src == 1'b0) begin
            write_rd = 1'b0;
            is_acc_inst = 1'b1;
          end else if (XF8ALT && fcsr_q.fmode.src == 1'b1) begin
            write_rd = 1'b0;
            is_acc_inst = 1'b1;
          end else begin
            illegal_inst = 1'b1;
          end
        end else begin
          illegal_inst = 1'b1;
        end
      end
      VFCPKA_B_D,
      VFCPKB_B_D,
      VFCPKC_B_D,
      VFCPKD_B_D: begin
        if (FP_EN && XFVEC && RVD && FLEN >= 16) begin
          if (XF8 && fcsr_q.fmode.dst == 1'b0) begin
            write_rd = 1'b0;
            is_acc_inst = 1'b1;
          end else if (XF8ALT && fcsr_q.fmode.dst == 1'b1) begin
            write_rd = 1'b0;
            is_acc_inst = 1'b1;
          end else begin
            illegal_inst = 1'b1;
          end
        end else begin
          illegal_inst = 1'b1;
        end
      end
      VFCVT_B_H,
      VFCVTU_B_H: begin
        if (FP_EN && XFVEC && FLEN >= 16) begin
          if ((XF16 && fcsr_q.fmode.src == 1'b0) ||
             (XF16ALT && fcsr_q.fmode.src == 1'b1)) begin
            if ((XF8 && fcsr_q.fmode.dst == 1'b0) ||
               (XF8ALT && fcsr_q.fmode.dst == 1'b1)) begin
              write_rd = 1'b0;
              is_acc_inst = 1'b1;
            end else begin
              illegal_inst = 1'b1;
            end
          end else begin
            illegal_inst = 1'b1;
          end
        end else begin
          illegal_inst = 1'b1;
        end
      end
      VFCVT_H_B,
      VFCVTU_H_B: begin
        if (FP_EN && XFVEC && FLEN >= 16) begin
          if ((XF8 && fcsr_q.fmode.src == 1'b0) ||
             (XF8ALT && fcsr_q.fmode.src == 1'b1)) begin
            if ((XF16 && fcsr_q.fmode.dst == 1'b0) ||
               (XF16ALT && fcsr_q.fmode.dst == 1'b1)) begin
              write_rd = 1'b0;
              is_acc_inst = 1'b1;
            end else begin
              illegal_inst = 1'b1;
            end
          end else begin
            illegal_inst = 1'b1;
          end
        end else begin
          illegal_inst = 1'b1;
        end
      end
      VFCVT_B_B,
      VFCVTU_B_B: begin
        if (FP_EN && XFVEC && RVF && XF8 && XF8ALT && FLEN >= 16) begin
          if (fcsr_q.fmode.src != fcsr_q.fmode.dst) begin
            write_rd = 1'b0;
            is_acc_inst = 1'b1;
          end else begin
            illegal_inst = 1'b1;
          end
        end else begin
          illegal_inst = 1'b1;
        end
      end
      VFDOTPEX_H_B,
      VFDOTPEX_H_R_B,
      VFNDOTPEX_H_B,
      VFNDOTPEX_H_R_B,
      VFSUMEX_H_B,
      VFNSUMEX_H_B: begin
        if (FP_EN && XFVEC && FLEN >= 32 && XFDOTP) begin
          if ((XF8 && fcsr_q.fmode.src == 1'b0) ||
             (XF8ALT && fcsr_q.fmode.src == 1'b1)) begin
            if ((XF16 && fcsr_q.fmode.dst == 1'b0) ||
               (XF16ALT && fcsr_q.fmode.dst == 1'b1)) begin
              write_rd = 1'b0;
              is_acc_inst = 1'b1;
            end else begin
              illegal_inst = 1'b1;
            end
          end else begin
            illegal_inst = 1'b1;
          end
        end else begin
          illegal_inst = 1'b1;
        end
      end
      // Offload FP-Int Instructions - fire and forget
      // Double Precision Floating-Point
      FLE_D,
      FLT_D,
      FEQ_D,
      FCLASS_D,
      FCVT_W_D,
      FCVT_WU_D: begin
        if (FP_EN && RVD) begin
          write_rd = 1'b0;
          uses_rd = 1'b1;
          is_acc_inst = 1'b1;
          acc_register_rd = 1'b1; // No RS in GPR but RD in GPR, register in int scoreboard
        end else begin
          illegal_inst = 1'b1;
        end
      end
      // Single Precision Floating-Point
      FLE_S,
      FLT_S,
      FEQ_S,
      FCLASS_S,
      FCVT_W_S,
      FCVT_WU_S,
      FMV_X_W: begin
        if (FP_EN && RVF) begin
          write_rd = 1'b0;
          uses_rd = 1'b1;
          is_acc_inst = 1'b1;
          acc_register_rd = 1'b1; // No RS in GPR but RD in GPR, register in int scoreboard
        end else begin
          illegal_inst = 1'b1;
        end
      end
      // Vectors
      VFEQ_S,
      VFEQ_R_S,
      VFNE_S,
      VFNE_R_S,
      VFLT_S,
      VFLT_R_S,
      VFGE_S,
      VFGE_R_S,
      VFLE_S,
      VFLE_R_S,
      VFGT_S,
      VFGT_R_S,
      VFCLASS_S: begin
        if (FP_EN && XFVEC && RVF && FLEN >= 64) begin
          write_rd = 1'b0;
          uses_rd = 1'b1;
          is_acc_inst = 1'b1;
          acc_register_rd = 1'b1; // No RS in GPR but RD in GPR, register in int scoreboard
        end else begin
          illegal_inst = 1'b1;
        end
      end
      // [Alternate] Half Precision Floating-Point
      FLE_H,
      FLT_H,
      FEQ_H,
      FCLASS_H,
      FCVT_W_H,
      FCVT_WU_H,
      FMV_X_H: begin
        if (FP_EN && XF16 && fcsr_q.fmode.src == 1'b0) begin
          write_rd = 1'b0;
          uses_rd = 1'b1;
          is_acc_inst = 1'b1;
          acc_register_rd = 1'b1; // No RS in GPR but RD in GPR, register in int scoreboard
        end else if (FP_EN && XF16ALT && fcsr_q.fmode.src == 1'b1) begin
          write_rd = 1'b0;
          uses_rd = 1'b1;
          is_acc_inst = 1'b1;
          acc_register_rd = 1'b1; // No RS in GPR but RD in GPR, register in int scoreboard
        end else begin
          illegal_inst = 1'b1;
        end
      end
      // Vectors
      VFEQ_H,
      VFEQ_R_H,
      VFNE_H,
      VFNE_R_H,
      VFLT_H,
      VFLT_R_H,
      VFGE_H,
      VFGE_R_H,
      VFLE_H,
      VFLE_R_H,
      VFGT_H,
      VFGT_R_H,
      VFCLASS_H: begin
        if (FP_EN && XFVEC && FLEN >= 32) begin
          if (XF16 && fcsr_q.fmode.dst == 1'b0) begin
            write_rd = 1'b0;
            uses_rd = 1'b1;
            is_acc_inst = 1'b1;
            acc_register_rd = 1'b1; // No RS in GPR but RD in GPR, register in int scoreboard
          end else if (XF16ALT && fcsr_q.fmode.dst == 1'b1) begin
            write_rd = 1'b0;
            uses_rd = 1'b1;
            is_acc_inst = 1'b1;
            acc_register_rd = 1'b1; // No RS in GPR but RD in GPR, register in int scoreboard
          end else begin
            illegal_inst = 1'b1;
          end
        end
      end
      VFMV_X_H,
      VFCVT_X_H,
      VFCVT_XU_H: begin
        if (FP_EN && XFVEC && FLEN >= 32 && ~RVD) begin
          if (XF16 && fcsr_q.fmode.src == 1'b0) begin
            write_rd = 1'b0;
            uses_rd = 1'b1;
            is_acc_inst = 1'b1;
            acc_register_rd = 1'b1; // No RS in GPR but RD in GPR, register in int scoreboard
          end else if (XF16ALT && fcsr_q.fmode.src == 1'b1) begin
            write_rd = 1'b0;
            uses_rd = 1'b1;
            is_acc_inst = 1'b1;
            acc_register_rd = 1'b1; // No RS in GPR but RD in GPR, register in int scoreboard
          end else begin
            illegal_inst = 1'b1;
          end
        end
      end
      // [Alternate] Quarter Precision Floating-Point
      FLE_B,
      FLT_B,
      FEQ_B,
      FCLASS_B,
      FCVT_W_B,
      FCVT_WU_B,
      FMV_X_B: begin
        if (FP_EN && XF8 && fcsr_q.fmode.src == 1'b0) begin
          write_rd = 1'b0;
          uses_rd = 1'b1;
          is_acc_inst = 1'b1;
          acc_register_rd = 1'b1; // No RS in GPR but RD in GPR, register in int scoreboard
        end else if (FP_EN && XF8ALT && fcsr_q.fmode.src == 1'b1) begin
          write_rd = 1'b0;
          uses_rd = 1'b1;
          is_acc_inst = 1'b1;
          acc_register_rd = 1'b1; // No RS in GPR but RD in GPR, register in int scoreboard
        end else begin
          illegal_inst = 1'b1;
        end
      end
      // Vectors
      VFEQ_B,
      VFEQ_R_B,
      VFNE_B,
      VFNE_R_B,
      VFLT_B,
      VFLT_R_B,
      VFGE_B,
      VFGE_R_B,
      VFLE_B,
      VFLE_R_B,
      VFGT_B,
      VFGT_R_B: begin
        if (FP_EN && XFVEC && FLEN >= 16) begin
          if (XF8 && fcsr_q.fmode.src == 1'b0) begin
            write_rd = 1'b0;
            uses_rd = 1'b1;
            is_acc_inst = 1'b1;
            acc_register_rd = 1'b1; // No RS in GPR but RD in GPR, register in int scoreboard
          end else if (XF8ALT && fcsr_q.fmode.src == 1'b1) begin
            write_rd = 1'b0;
            uses_rd = 1'b1;
            is_acc_inst = 1'b1;
            acc_register_rd = 1'b1; // No RS in GPR but RD in GPR, register in int scoreboard
          end else begin
            illegal_inst = 1'b1;
          end
        end
      end
      VFMV_X_B,
      VFCLASS_B,
      VFCVT_X_B,
      VFCVT_XU_B: begin
        if (FP_EN && XFVEC && FLEN >= 16 && ~RVD) begin
          if (XF8 && fcsr_q.fmode.src == 1'b0) begin
            write_rd = 1'b0;
            uses_rd = 1'b1;
            is_acc_inst = 1'b1;
            acc_register_rd = 1'b1; // No RS in GPR but RD in GPR, register in int scoreboard
          end else if (XF8ALT && fcsr_q.fmode.src == 1'b1) begin
            write_rd = 1'b0;
            uses_rd = 1'b1;
            is_acc_inst = 1'b1;
            acc_register_rd = 1'b1; // No RS in GPR but RD in GPR, register in int scoreboard
          end else begin
            illegal_inst = 1'b1;
          end
        end
      end
      // Offload Int-FP Instructions - fire and forget
      // Double Precision Floating-Point
      FCVT_D_W,
      FCVT_D_WU: begin
        if (FP_EN && RVD) begin
          opa_select = RegRs1;
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      // Single Precision Floating-Point
      FMV_W_X,
      FCVT_S_W,
      FCVT_S_WU: begin
        if (FP_EN && RVF) begin
          opa_select = RegRs1;
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      // [Alternate] Half Precision Floating-Point
      FMV_H_X,
      FCVT_H_W,
      FCVT_H_WU: begin
        if (FP_EN && XF16 && (fcsr_q.fmode.dst == 1'b0)) begin
          opa_select = RegRs1;
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else if (FP_EN && XF16ALT && (fcsr_q.fmode.dst == 1'b1)) begin
          opa_select = RegRs1;
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      // Vectors
      VFMV_H_X,
      VFCVT_H_X,
      VFCVT_H_XU: begin
        if (FP_EN && XFVEC && FLEN >= 32 && ~RVD) begin
          if (XF16 && fcsr_q.fmode.dst == 1'b0) begin
            write_rd = 1'b0;
            is_acc_inst = 1'b1;
          end else if (XF16ALT && fcsr_q.fmode.dst == 1'b1) begin
            write_rd = 1'b0;
            is_acc_inst = 1'b1;
          end else begin
            illegal_inst = 1'b1;
          end
        end
      end
      // [Alternate] Quarter Precision Floating-Point
      FMV_B_X,
      FCVT_B_W,
      FCVT_B_WU: begin
        if (FP_EN && XF8 && fcsr_q.fmode.dst == 1'b0) begin
          opa_select = RegRs1;
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else if (FP_EN && XF8ALT && fcsr_q.fmode.dst == 1'b1) begin
          opa_select = RegRs1;
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      // Vectors
      VFMV_B_X,
      VFCVT_B_X,
      VFCVT_B_XU: begin
        if (FP_EN && XFVEC && FLEN >= 16 && ~RVD) begin
          if (XF8 && fcsr_q.fmode.dst == 1'b0) begin
            write_rd = 1'b0;
            is_acc_inst = 1'b1;
          end else if (XF8ALT && fcsr_q.fmode.dst == 1'b1) begin
            write_rd = 1'b0;
            is_acc_inst = 1'b1;
          end else begin
            illegal_inst = 1'b1;
          end
        end
      end
      // FP Sequencer and Postmod
      FREP_O,
      P_LB_IRPOST,
      P_LBU_IRPOST,
      P_LH_IRPOST,
      P_LHU_IRPOST,
      P_LW_IRPOST,
      P_LB_RRPOST,
      P_LBU_RRPOST,
      P_LH_RRPOST,
      P_LHU_RRPOST,
      P_LW_RRPOST : begin
        if (Xpulppostmod == 1) begin
          casez (inst_data_i)
            P_LB_IRPOST: begin  //  p.lb rd,iimm(rs1!)
              write_rd = 1'b0;
              write_rs1 = 1'b1;
              is_load = 1'b1;
              is_postincr = 1'b1;
              is_signed = 1'b1;
              opa_select = RegRs1;
              opb_select = IImmediate;
            end
            P_LBU_IRPOST: begin // p.lbu
              write_rd = 1'b0;
              write_rs1 = 1'b1;
              is_load = 1'b1;
              is_postincr = 1'b1;
              opa_select = RegRs1;
              opb_select = IImmediate;
            end
            P_LH_IRPOST: begin  //p.lh
              write_rd = 1'b0;
              write_rs1 = 1'b1;
              is_load = 1'b1;
              is_postincr = 1'b1;
              is_signed = 1'b1;
              ls_size = HalfWord;
              opa_select = RegRs1;
              opb_select = IImmediate;
            end
            P_LHU_IRPOST: begin //p.lhu
              write_rd = 1'b0;
              write_rs1 = 1'b1;
              is_load = 1'b1;
              is_postincr = 1'b1;
              ls_size = HalfWord;
              opa_select = RegRs1;
              opb_select = IImmediate;
            end
            P_LW_IRPOST: begin //p.lw
              write_rd = 1'b0;
              write_rs1 = 1'b1;
              is_load = 1'b1;
              is_postincr = 1'b1;
              is_signed = 1'b1;
              ls_size = Word;
              opa_select = RegRs1;
              opb_select = IImmediate;
            end
            P_LB_RRPOST: begin //p.lb rd,rs2(rs1!)
              write_rd = 1'b0;
              write_rs1 = 1'b1;
              is_load = 1'b1;
              is_postincr = 1'b1;
              is_signed = 1'b1;
              opa_select = RegRs1;
              opb_select = RegRs2;
            end
            P_LBU_RRPOST: begin //p.lbu
              write_rd = 1'b0;
              write_rs1 = 1'b1;
              is_load = 1'b1;
              is_postincr = 1'b1;
              opa_select = RegRs1;
              opb_select = RegRs2;
            end
            P_LH_RRPOST: begin //p.lh
              write_rd = 1'b0;
              write_rs1 = 1'b1;
              is_load = 1'b1;
              is_postincr = 1'b1;
              is_signed = 1'b1;
              ls_size = HalfWord;
              opa_select = RegRs1;
              opb_select = RegRs2;
            end
            P_LHU_RRPOST: begin //p.lhu
              write_rd = 1'b0;
              write_rs1 = 1'b1;
              is_load = 1'b1;
              is_postincr = 1'b1;
              ls_size = HalfWord;
              opa_select = RegRs1;
              opb_select = RegRs2;
            end
            P_LW_RRPOST: begin //p.lw
              write_rd = 1'b0;
              write_rs1 = 1'b1;
              is_load = 1'b1;
              is_postincr = 1'b1;
              is_signed = 1'b1;
              ls_size = Word;
              opa_select = RegRs1;
              opb_select = RegRs2;
            end
            default: begin
              illegal_inst = 1'b1;
            end
          endcase
        end else begin
          if (FP_EN && (inst_data_i ==? FREP_O) ) begin
            opa_select = RegRs1;
            write_rd = 1'b0;
            is_acc_inst = 1'b1;
          end else begin
            illegal_inst = 1'b1;
          end 
        end
      end
      P_LB_RR: begin      // p.lb rd,rs2(rs1)
        if (Xpulppostmod == 1) begin
          write_rd = 1'b0;
          is_load = 1'b1;
          is_signed = 1'b1;
          opa_select = RegRs1;
          opb_select = RegRs2;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      P_LBU_RR: begin     // p.lbu
        if (Xpulppostmod == 1) begin
          write_rd = 1'b0;
          is_load = 1'b1;
          opa_select = RegRs1;
          opb_select = RegRs2;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      P_LH_RR: begin      // p.lh
        if (Xpulppostmod == 1) begin
          write_rd = 1'b0;
          is_load = 1'b1;
          is_signed = 1'b1;
          ls_size = HalfWord;
          opa_select = RegRs1;
          opb_select = RegRs2;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      P_LHU_RR: begin     // p.lhu
        if (Xpulppostmod == 1) begin
          write_rd = 1'b0;
          is_load = 1'b1;
          ls_size = HalfWord;
          opa_select = RegRs1;
          opb_select = RegRs2;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      P_LW_RR: begin      // p.lw
        if (Xpulppostmod == 1) begin
          write_rd = 1'b0;
          is_load = 1'b1;
          is_signed = 1'b1;
          ls_size = Word;
          opa_select = RegRs1;
          opb_select = RegRs2;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      // opb is usually assigned with the content of rs2; in stores with reg-reg
      // addressing mode, however, the offset is stored in rd, so rd content is
      // instead assigned to opb: if we cross such signals now (rd -> opb,
      // rs2 -> opc) we don't have to do that in the ALU, with bigger muxes
      P_SB_RRPOST: begin  // p.sb rs2,rd(rs1!)
        if (Xpulppostmod == 1) begin
          write_rd = 1'b0;
          write_rs1 = 1'b1;
          is_store = 1'b1;
          is_postincr = 1'b1;
          opa_select = RegRs1; // rs1 base address
          opb_select = RegRd; // rd offset
          opc_select = RegRs2; // rs2 source data
        end else begin
          illegal_inst = 1'b1;
        end
      end
      P_SH_RRPOST: begin  // p.sh
        if (Xpulppostmod == 1) begin
          write_rd = 1'b0;
          write_rs1 = 1'b1;
          is_store = 1'b1;
          is_postincr = 1'b1;
          ls_size = HalfWord;
          opa_select = RegRs1;
          opb_select = RegRd;
          opc_select = RegRs2;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      P_SW_RRPOST: begin  // p.sw
        if (Xpulppostmod == 1) begin
          write_rd = 1'b0;
          write_rs1 = 1'b1;
          is_store = 1'b1;
          is_postincr = 1'b1;
          ls_size = Word;
          opa_select = RegRs1;
          opb_select = RegRd;
          opc_select = RegRs2;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      P_SB_RR: begin      // p.sb rs2,rs3(rs1)
        if (Xpulppostmod == 1) begin
          write_rd = 1'b0;
          is_store = 1'b1;
          opa_select = RegRs1;
          opb_select = RegRd;
          opc_select = RegRs2;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      P_SH_RR: begin      // p.sh
        if (Xpulppostmod == 1) begin
          write_rd = 1'b0;
          is_store = 1'b1;
          ls_size = HalfWord;
          opa_select = RegRs1;
          opb_select = RegRd;
          opc_select = RegRs2;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      P_SW_RR: begin      // p.sw
        if (Xpulppostmod == 1) begin
          write_rd = 1'b0;
          is_store = 1'b1;
          ls_size = Word;
          opa_select = RegRs1;
          opb_select = RegRd;
          opc_select = RegRs2;
        end else begin
          illegal_inst = 1'b1;
        end
      end 
      // Floating-Point Load/Store
      // Single Precision Floating-Point
      FLW: begin
        if (FP_EN && RVF) begin
          opa_select = RegRs1;
          opb_select = IImmediate;
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
          ls_size = Word;
          is_fp_load = 1'b1;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      FSW: begin
        if (FP_EN && RVF) begin
          opa_select = RegRs1;
          opb_select = SFImmediate;
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
          ls_size = Word;
          is_fp_store = 1'b1;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      // Double Precision Floating-Point
      FLD: begin
        if (FP_EN && (RVD || XFVEC)) begin
          opa_select = RegRs1;
          opb_select = IImmediate;
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
          ls_size = Double;
          is_fp_load = 1'b1;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      FSD: begin
        if (FP_EN && (RVD || XFVEC)) begin
          opa_select = RegRs1;
          opb_select = SFImmediate;
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
          ls_size = Double;
          is_fp_store = 1'b1;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      // Half Precision Floating-Point
      FLH: begin
        if (FP_EN && (XF16 || XF16ALT)) begin
          opa_select = RegRs1;
          opb_select = IImmediate;
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
          ls_size = HalfWord;
          is_fp_load = 1'b1;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      FSH: begin
        if (FP_EN && (XF16 || XF16ALT)) begin
          opa_select = RegRs1;
          opb_select = SFImmediate;
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
          ls_size = HalfWord;
          is_fp_store = 1'b1;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      // Quarter Precision Floating-Point
      FLB: begin
        if (FP_EN && (XF8 || XF8ALT)) begin
          opa_select = RegRs1;
          opb_select = IImmediate;
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
          ls_size = Byte;
          is_fp_load = 1'b1;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      FSB: begin
        if (FP_EN && (XF8 || XF8ALT)) begin
          opa_select = RegRs1;
          opb_select = SFImmediate;
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
          ls_size = Byte;
          is_fp_store = 1'b1;
        end else begin
          illegal_inst = 1'b1;
        end
      end
      // DMA instructions
      P_SB_IRPOST,
      DMSRC,
      DMDST,
      DMSTR,
      DMCPYI,
      DMCPY,
      DMSTATI,
      DMSTAT,
      DMREP,
      FCVT_D_W_COPIFT,
      FCVT_D_WU_COPIFT : begin
        if (Xpulppostmod) begin
          write_rd = 1'b0;
          uses_rd = 1'b0;
          write_rs1 = 1'b1;
          is_store = 1'b1;
          is_postincr = 1'b1;
          opa_select = RegRs1;
          opb_select = SImmediate;
        end else begin
          casez (inst_data_i)
            DMSRC,
            DMDST,
            DMSTR: begin
              if (Xdma) begin
                acc_qreq_o.addr  = DMA_SS;
                opa_select   = RegRs1;
                opb_select   = RegRs2;
                is_acc_inst  = 1'b1;
                write_rd     = 1'b0;
              end else begin
                illegal_inst = 1'b1;
              end
            end
            DMCPYI: begin
              if (Xdma) begin
                acc_qreq_o.addr     = DMA_SS;
                opa_select      = RegRs1;
                is_acc_inst     = 1'b1;
                write_rd        = 1'b0;
                uses_rd         = 1'b1;
                acc_register_rd = 1'b1;
              end else begin
                illegal_inst = 1'b1;
              end
            end
            DMCPY: begin
              if (Xdma) begin
                acc_qreq_o.addr     = DMA_SS;
                opa_select      = RegRs1;
                opb_select      = RegRs2;
                is_acc_inst     = 1'b1;
                write_rd        = 1'b0;
                uses_rd         = 1'b1;
                acc_register_rd = 1'b1;
              end else begin
                illegal_inst = 1'b1;
              end
            end
            DMSTATI: begin
              if (Xdma) begin
                acc_qreq_o.addr     = DMA_SS;
                is_acc_inst     = 1'b1;
                write_rd        = 1'b0;
                uses_rd         = 1'b1;
                acc_register_rd = 1'b1;
              end else begin
                illegal_inst = 1'b1;
              end
            end
            DMSTAT: begin
              if (Xdma) begin
                acc_qreq_o.addr     = DMA_SS;
                opb_select      = RegRs2;
                is_acc_inst     = 1'b1;
                write_rd        = 1'b0;
                uses_rd         = 1'b1;
                acc_register_rd = 1'b1;
              end else begin
                illegal_inst = 1'b1;
              end
            end
            DMREP: begin
              if (Xdma) begin
                acc_qreq_o.addr     = DMA_SS;
                opa_select      = RegRs1;
                is_acc_inst     = 1'b1;
                write_rd        = 1'b0;
              end else begin
                illegal_inst = 1'b1;
              end
            end
            FCVT_D_W_COPIFT,
            FCVT_D_WU_COPIFT: begin
              if (FP_EN && RVD && Xcopift) begin
                write_rd = 1'b0;
                is_acc_inst = 1'b1;
              end else begin
                illegal_inst = 1'b1;
              end
            end
            default: begin
              illegal_inst = 1'b1;
            end
          endcase
        end
      end
      DMUSER: begin
        if (Xdma) begin
          acc_qreq_o.addr = DMA_SS;
          opa_select      = RegRs1;
          is_acc_inst     = 1'b1;
          write_rd        = 1'b0;
        end else begin
          illegal_inst = 1'b1;
        end
      end

      P_SH_IRPOST,
      SCFGRI,
      SCFGR,
      FLT_D_COPIFT: begin
        if (Xpulppostmod) begin
          write_rd = 1'b0;
          uses_rd = 1'b0;
          write_rs1 = 1'b1;
          is_store = 1'b1;
          is_postincr = 1'b1;
          ls_size = HalfWord;
          opa_select = RegRs1;
          opb_select = SImmediate;
        end else begin
          casez (inst_data_i)
            SCFGRI: begin
              if (Xssr) begin
                write_rd = 1'b0;
                uses_rd = 1'b1;
                acc_qreq_o.addr = SSR_CFG;
                is_acc_inst = 1'b1;
                acc_register_rd = 1'b1; // No RS in GPR but RD in GPR, register in int scoreboard
              end else illegal_inst = 1'b1;
            end
            SCFGR: begin
              if (Xssr) begin
                write_rd = 1'b0;
                uses_rd = 1'b1;
                acc_qreq_o.addr = SSR_CFG;
                opb_select = RegRs2;
                is_acc_inst = 1'b1;
                acc_register_rd = 1'b1;
              end else illegal_inst = 1'b1;
            end
            FLT_D_COPIFT: begin
              if (FP_EN && RVD && Xcopift) begin
                write_rd = 1'b0;
                is_acc_inst = 1'b1;
              end else begin
                illegal_inst = 1'b1;
              end
            end
            default: begin
              illegal_inst = 1'b1;
            end
          endcase
        end
      end

      P_SW_IRPOST,
      SCFGWI,
      SCFGW: begin
        if (Xpulppostmod) begin
          write_rd = 1'b0;
          uses_rd = 1'b0;
          write_rs1 = 1'b1;
          is_store = 1'b1;
          is_postincr = 1'b1;
          ls_size = Word;
          opa_select = RegRs1;
          opb_select = SImmediate;
        end else begin
          casez (inst_data_i)
            SCFGWI: begin
              if (Xssr) begin
                acc_qreq_o.addr = SSR_CFG;
                opa_select = RegRs1;
                is_acc_inst = 1'b1;
                write_rd = 1'b0;
              end else illegal_inst = 1'b1;
            end
            SCFGW: begin
              if (Xssr) begin
                acc_qreq_o.addr = SSR_CFG;
                opa_select = RegRs1;
                opb_select = RegRs2;
                is_acc_inst = 1'b1;
                write_rd = 1'b0;
              end else illegal_inst = 1'b1;
            end
            default: begin
              illegal_inst = 1'b1;
            end
          endcase
        end
      end
      PV_SHUFFLE2_H,        // Xpulpv2: pv.shuffle2.h
      PV_SHUFFLE2_B,        // Xpulpv2: pv.shuffle2.b
      PV_PACK,              // Xpulpv2: pv.pack
      PV_PACK_H: begin      // Xpulpv2: pv.pack.h
        if (Xpulpvectshufflepack) begin
          write_rd = 1'b0;
          is_acc_inst = 1'b1;
          opa_select = RegRs1;
          opb_select = RegRs2;
          opc_select = RegRd;
          acc_register_rd = 1'b1;
          acc_qreq_o.addr  = XPULP_IPU;
        end else begin
          illegal_inst = 1'b1;
        end
      end

      default: begin // Offload the instruction to the coprocessor
        if (EnableXif) begin
          write_rd = x_issue_ready_i & x_issue_valid_o & x_issue_resp_i.writeback;

          opa_select = RegRs1;
          opb_select = RegRs2;
          opc_select = RegRs3;

          x_issue_req_o.instr    = inst_data_i;
          x_issue_req_o.id       = xif_offload_counter_q;
          x_issue_req_o.hartid   = hart_id_i;

          x_register_o.hartid    = hart_id_i;
          x_register_o.id        = xif_offload_counter_q;
          x_register_o.rs        = {opc, opb, opa};
          x_register_o.rs_valid  = {~sb_q[rs3], ~sb_q[rs2], ~sb_q[rs1]};

          x_commit_o.hartid      = hart_id_i;
          x_commit_o.id          = xif_offload_counter_q;
          // We do not speculate so the commit_kill signal can be set statically to zero
          x_commit_o.commit_kill = 1'b0;

          // Since we cannot know whether a source register will be used or not by the processor,
          // here we do not use valid_instr as in the other instructions
          x_issue_valid_o         = inst_ready_i
                                  & inst_valid_o
                                  & ((itlb_valid & itlb_ready) | ~trans_active);

          // Same as x_issue_valid since reigsters are provided instantly
          x_register_valid_o      = x_issue_valid_o;

          // Assert x_commit_valid as soon as there's a valid issue handshake
          x_commit_valid_o        = x_issue_valid_o & x_issue_ready_i;

          // Flag the instruction as illegal if not accepted by the coprocessor
          illegal_inst = x_issue_ready_i & x_issue_valid_o & ~x_issue_resp_i.accept;
        end else begin
          illegal_inst = 1'b1;
        end
      end
    endcase

    // Sanitize illegal instructions so that they don't exert any side-effects.
    if (exception) begin
     write_rd = 1'b0;
     write_rs1 = 1'b0;
     is_acc_inst = 1'b0;
     next_pc = Exception;
    end
  end

  assign exception = illegal_inst
                   | ecall
                   | ebreak
                   | interrupt
                   | inst_addr_misaligned
                   | ld_addr_misaligned
                   | st_addr_misaligned
                   | illegal_csr
                   | (dtlb_page_fault & dtlb_trans_valid)
                   | (itlb_page_fault & itlb_trans_valid);

  `ifndef VCS
  // pragma translate_off
  always_ff @(posedge clk_i) begin
    if (!rst_i && illegal_inst && valid_instr) begin
      $info("[Illegal Instruction Core %0d] PC: %h Data: %h",
            hart_id_i, inst_addr_o, inst_data_i);
    end
  end
  // pragma translate_on
  `endif

  assign meip = irq_i.meip & eie_q[M];
  assign mtip = irq_i.mtip & tie_q[M];
  assign msip = irq_i.msip & sie_q[M];
  assign mcip = irq_i.mcip & cie_q[M];
  assign mxip = irq_i.mxip & xie_q[M];

  assign seip = seip_q & eie_q[S];
  assign stip = stip_q & tie_q[S];
  assign ssip = ssip_q & sie_q[S];
  assign scip = scip_q & cie_q[S];

  assign interrupts_enabled = ((priv_lvl_q == PrivLvlM) & ie_q[M]) || (priv_lvl_q != PrivLvlM);
  assign any_interrupt_pending = meip | mtip | msip | mcip | mxip | seip | stip | ssip | scip;
  assign interrupt = interrupts_enabled & any_interrupt_pending;

  // CSR logic
  always_comb begin
    csr_rvalue = '0;
    csr_dump = 1'b0;
    illegal_csr = '0;
    priv_lvl_d = priv_lvl_q;
    // registers
    fcsr_d = fcsr_q;
    fcsr_d.fflags = fcsr_q.fflags | fpu_status_i;
    fcsr_d.fmode.src = fcsr_q.fmode.src;
    fcsr_d.fmode.dst = fcsr_q.fmode.dst;
    scratch_d = scratch_q;
    epc_d = epc_q;
    cause_d = cause_q;
    cause_irq_d = cause_irq_q;

    satp_d = satp_q;
    mseg_d = mseg_q;
    mpp_d = mpp_q;
    ie_d = ie_q;
    pie_d = pie_q;
    spp_d = spp_q;
    // Interrupts
    eie_d = eie_q;
    tie_d = tie_q;
    sie_d = sie_q;
    cie_d = cie_q;
    xie_d = xie_q;
    seip_d = seip_q;
    stip_d = stip_q;
    ssip_d = ssip_q;
    scip_d = scip_q;

    tvec_d = tvec_q;

    dcsr_d = dcsr_q;
    dpc_d = dpc_q;
    dscratch_d = dscratch_q;

    csr_stall_d = csr_stall_q;
    csr_mcast_d = csr_mcast_q;
    csr_copift_d = csr_copift_q;

    if (barrier_i) csr_stall_d = 1'b0;
    barrier_o = 1'b0;

    // DPC and DCSR update logic
    if (!debug_q) begin
      if (valid_instr && inst_data_i == EBREAK) begin
        dpc_d = pc_q;
        dcsr_d.cause = dm::CauseBreakpoint;
      end else if (DebugSupport && irq_i.debug) begin
        dpc_d = npc;
        dcsr_d.cause = dm::CauseRequest;
      end else if (valid_instr && dcsr_q.step) begin
        dpc_d = npc;
        dcsr_d.cause = dm::CauseSingleStep;
      end
    end
    // Right now we skip this due to simplicity.
    if (csr_en) begin
      // Check privilege level.
      if ((priv_lvl_q & inst_data_i[29:28]) == inst_data_i[29:28]) begin
        unique case (inst_data_i[31:20])
          CSR_MISA: csr_rvalue =
                              // A - Atomic Instructions extension
                                (1   <<  0)
                              // C - Compressed extension
                              | (0   <<  2)
                              // D - Double precsision floating-point extension
                              | ((FP_EN & RVD) <<  3)
                              // E - RV32E base ISA
                              | ((FP_EN & RVE) <<  4)
                              // F - Single precsision floating-point extension
                              | ((FP_EN & RVF) <<  5)
                              // I - RV32I/64I/128I base ISA
                              | (1   <<  8)
                              // M - Integer Multiply/Divide extension
                              | (1   << 12)
                              // N - User level interrupts supported
                              | (0   << 13)
                              // S - Supervisor mode implemented
                              | (0   << 18)
                              // U - User mode implemented
                              | (0   << 20)
                              // X - Non-standard extensions present
                              | (((NSX & FP_EN) | Xdma | Xssr) << 23)
                              // RV32
                              | (1   << 30);
          CSR_MHARTID: begin
            csr_rvalue = hart_id_i;
          end
          CSR_DCSR: begin
            if (DebugSupport) begin
              csr_rvalue = dcsr_q;
              dcsr_d.ebreakm = alu_result[15];
              dcsr_d.step = alu_result[2];
            end else illegal_csr = 1'b1;
          end
          CSR_DPC: begin
            if (DebugSupport) begin
              csr_rvalue = dpc_q;
              dpc_d = alu_result;
            end else illegal_csr = 1'b1;
          end
          CSR_DSCRATCH0: begin
            if (DebugSupport) begin
              csr_rvalue = dscratch_q;
              dscratch_d = alu_result;
            end else illegal_csr = 1'b1;
          end
          `ifdef SNITCH_ENABLE_PERF
          CSR_MCYCLE: begin
            csr_rvalue = cycle_q[31:0];
          end
          CSR_MINSTRET: begin
            csr_rvalue = instret_q[31:0];
          end
          CSR_MCYCLEH: begin
            csr_rvalue = cycle_q[63:32];
          end
          CSR_MINSTRETH: begin
            csr_rvalue = instret_q[63:32];
          end
          `endif
          CsrMseg: begin
            csr_rvalue = mseg_q;
            if (!exception) mseg_d = alu_result[$bits(mseg_q)-1:0];
          end
          // Privleged Extension:
          CSR_MSTATUS: begin
            automatic snitch_pkg::status_rv32_t mstatus, mstatus_d;
            mstatus = '0;
            if (FP_EN) begin
              mstatus.fs = snitch_pkg::XDirty;
              mstatus.sd = 1'b1;
            end
            mstatus.mpp = mpp_q;
            mstatus.spp = spp_q;
            mstatus.mie = ie_q[M];
            mstatus.mpie = pie_q[M];
            csr_rvalue = mstatus;
            if (!exception) begin
              mstatus_d = snitch_pkg::status_rv32_t'(alu_result);
              mpp_d = mstatus_d.mpp;
              spp_d = mstatus_d.spp;
              ie_d[M] = mstatus_d.mie;
              pie_d[M] = mstatus_d.mpie;
            end
          end
          CSR_MEPC: begin
            csr_rvalue = epc_q[M];
            if (!exception) epc_d[M] = alu_result[31:0];
          end
          CSR_MIP: begin
            csr_rvalue[MEI] = irq_i.meip;
            csr_rvalue[MTI] = irq_i.mtip;
            csr_rvalue[MSI] = irq_i.msip;
            csr_rvalue[MCI] = irq_i.mcip;
            csr_rvalue[MXI] = irq_i.mxip;
            csr_rvalue[SEI] = seip_q;
            csr_rvalue[STI] = stip_q;
            csr_rvalue[SSI] = ssip_q;
            csr_rvalue[SCI] = scip_q;
            if (!exception) begin
              seip_d = alu_result[SEI];
              stip_d = alu_result[STI];
              ssip_d = alu_result[SSI];
              scip_d = alu_result[SCI];
            end
          end
          CSR_MIE: begin
            csr_rvalue[MEI] = eie_q[M];
            csr_rvalue[MTI] = tie_q[M];
            csr_rvalue[MSI] = sie_q[M];
            csr_rvalue[MCI] = cie_q[M];
            csr_rvalue[MXI] = xie_q[M];
            csr_rvalue[SEI] = eie_q[S];
            csr_rvalue[STI] = tie_q[S];
            csr_rvalue[SSI] = sie_q[S];
            csr_rvalue[SCI] = cie_q[S];
            if (!exception) begin
              eie_d[M] = alu_result[MEI];
              tie_d[M] = alu_result[MTI];
              sie_d[M] = alu_result[MSI];
              cie_d[M] = alu_result[MCI];
              xie_d[M] = alu_result[MXI];
              eie_d[S] = alu_result[SEI];
              tie_d[S] = alu_result[STI];
              sie_d[S] = alu_result[SSI];
              cie_d[S] = alu_result[SCI];
            end
          end
          CSR_MCAUSE: begin
            csr_rvalue = cause_q[M];
            csr_rvalue[31] = cause_irq_q[M];
            if (!exception) begin
              cause_d[M] = alu_result[4:0];
              cause_irq_d[M] = alu_result[31];
            end
          end
          CSR_MTVAL:; // tied-off
          CSR_MTVEC: begin
            csr_rvalue = {tvec_q[M], 2'b0};
            if (!exception) tvec_d[M] = alu_result[31:2];
          end
          CSR_MSCRATCH: begin
            csr_rvalue = scratch_q[M];
            if (!exception) scratch_d[M] = alu_result[31:0];
          end
          CSR_MEDELEG:; // we currently don't support delegation
          CSR_SSTATUS: begin
            automatic snitch_pkg::status_rv32_t mstatus;
            mstatus = '0;
            mstatus.spp = spp_q;
            csr_rvalue = mstatus;
            if (!exception) spp_d = mstatus.spp;
          end
          CSR_SSCRATCH: begin
            csr_rvalue = scratch_q[S];
            if (!exception) scratch_d[S] = alu_result[31:0];
          end
          CSR_SEPC: begin
            csr_rvalue = epc_q[S];
            if (!exception) epc_d[S] = alu_result[31:0];
          end
          CSR_SIP, CSR_SIE:; //tied-off - no delegation
          // Enable if we want to support delegation.
          CSR_SCAUSE:; // tied-off - no delegation
          CSR_STVAL:; // tied-off - no delegation
          CSR_STVEC:; // tied-off - no delegation
          CSR_SATP: begin
            csr_rvalue = satp_q;
            if (!exception) begin
              satp_d.ppn = alu_result[21:0];
              satp_d.mode = VMSupport ? alu_result[31] : 1'b0;
            end
          end
          // F/D Extension
          CSR_FFLAGS: begin
            if (FP_EN) begin
              csr_rvalue = {27'b0, fcsr_q.fflags};
              if (!exception) fcsr_d.fflags = fpnew_pkg::status_t'(alu_result[4:0]);
            end else illegal_csr = 1'b1;
          end
          CSR_FRM: begin
            if (FP_EN) begin
              csr_rvalue = {29'b0, fcsr_q.frm};
              if (!exception) fcsr_d.frm = fpnew_pkg::roundmode_e'(alu_result[2:0]);
            end else illegal_csr = 1'b1;
          end
          CSR_FMODE: begin
            if (FP_EN) begin
              csr_rvalue = {30'b0, fcsr_q.fmode};
              if (!exception) fcsr_d.fmode = fpnew_pkg::fmt_mode_t'(alu_result[1:0]);
            end else illegal_csr = 1'b1;
          end
          CSR_FCSR: begin
            if (FP_EN) begin
              csr_rvalue = {22'b0, fcsr_q};
              if (!exception) fcsr_d = fcsr_t'(alu_result[9:0]);
            end else illegal_csr = 1'b1;
          end
          // HW cluster barrier
          CSR_BARRIER: begin
            barrier_o = 1'b1;
            csr_stall_d = 1'b1;
          end
          // Multicast mask
          CSR_USER_LOW: begin
            csr_rvalue = csr_mcast_q;
            csr_mcast_d = alu_result[31:0];
          end
          CSR_COPIFT: begin
            csr_rvalue = {31'b0, csr_copift_q};
            if (!exception) csr_copift_d = alu_result[0];
          end
          CSR_DUMP: begin
            csr_rvalue = '0;
            csr_dump = 1'b1;
          end
          default: begin
            csr_rvalue = '0;
          end
        endcase
      end else illegal_csr = 1'b1;
    end

    // Manipulate CSRs / Privilege Stack
    if (valid_instr) begin
      // Exceptions
      // Illegal Instructions.
      if (illegal_inst || illegal_csr) cause_d[M] = IllegalInstr;
      // Environment Calls.
      if (ecall) begin
        unique case (priv_lvl_q)
          PrivLvlM: cause_d[M] = EnvCallMMode;
          PrivLvlS: cause_d[M] = EnvCallSMode;
          PrivLvlU: cause_d[M] = EnvCallUMode;
          default: cause_d[M] = EnvCallMMode;
        endcase
      end

      if (ebreak) cause_d[M] = Breakpoint;
      // Page faults.
      if (dtlb_trans_valid && dtlb_page_fault) begin
        if (is_store) cause_d[M] = StorePageFault;
        if (is_load)  cause_d[M] = LoadPageFault;
      end
      if (itlb_trans_valid && itlb_page_fault) cause_d[M] = InstrPageFault;
      if (inst_addr_misaligned) cause_d[M] = InstrAddrMisaligned;
      // Misaligned load/stores
      if (ld_addr_misaligned) cause_d[M] = LoadAddrMisaligned;
      if (st_addr_misaligned) cause_d[M] = StoreAddrMisaligned;

      // Interrupts.
      if (interrupt) begin
        // Priortize interrupts.
        if (meip)      cause_d[M] = MEI;
        else if (mtip) cause_d[M] = MTI;
        else if (msip) cause_d[M] = MSI;
        else if (mcip) cause_d[M] = MCI;
        else if (mxip) cause_d[M] = MXI;
        else if (seip) cause_d[M] = SEI;
        else if (stip) cause_d[M] = STI;
        else if (ssip) cause_d[M] = SSI;
        else if (scip) cause_d[M] = SCI;
      end

      if (exception) begin
        epc_d[M] = pc_q;
        cause_irq_d[M] = interrupt;
        priv_lvl_d = PrivLvlM;

        // Manipulate exception stack.
        mpp_d = priv_lvl_q;
        pie_d[M] = ie_q[M];
        ie_d[M] = 1'b0;
      end

      // Return from Environment.
      if (inst_data_i == riscv_instr::MRET) begin
        priv_lvl_d = mpp_q;
        ie_d[M] = pie_q[M];
        pie_d[M] = 1'b1;
        mpp_d = snitch_pkg::PrivLvlU; // set default back to U-Mode
      end

      if (inst_data_i == riscv_instr::SRET) begin
        priv_lvl_d = snitch_pkg::priv_lvl_t'({1'b0, spp_q});
        spp_d = 1'b0;
      end
    end
    // static fields
    dcsr_d.xdebugver = 4;
    dcsr_d.zero2 = 0;
    dcsr_d.zero1 = 0;
    dcsr_d.zero0 = 0;
    dcsr_d.ebreaks = 0;
    dcsr_d.ebreaku = 0;
    dcsr_d.stepie = 0;
    dcsr_d.stopcount = 0;
    dcsr_d.stoptime = 0;
    dcsr_d.mprven = 0;
    dcsr_d.nmip = 0;
    dcsr_d.prv = dm::priv_lvl_t'(dm::PRIV_LVL_M);
  end

  // pragma translate_off
  always_ff @(posedge clk_i or posedge rst_i) begin
    // Display writes to CSR_DUMP
    if (!rst_i && csr_dump && inst_valid_o && inst_ready_i && !stall) begin
      // $timeformat(-9, 0, " ns", 0);
      $display("[Dump Core %0d] %t 0x%3h = 0x%08h, %d, %f", hart_id_i,
               $time, inst_data_i[31:20], alu_result, alu_result, $bitstoshortreal(alu_result));
    end
  end
  // pragma translate_on

  // --------------------
  // COPIFT Queue
  // --------------------

  // Common enable signal for the I2F and F2I queues
  assign en_copift_o = csr_copift_q;

  // Is an instruction a FP instruction (i.e. an instruction executed in the FPSS)
  assign is_fp_inst = is_acc_inst && (acc_qreq_o.addr == FP_SS);

  // Read from F2I if rs==x31, queues are enabled and the instruction is an integer instruction (not a FP instruction).
  assign rs1_is_f2i = (rs1 == 'd31) & en_copift_o & ~is_fp_inst;
  assign rs2_is_f2i = (rs2 == 'd31) & en_copift_o & ~is_fp_inst;
  assign f2i_rready = valid_instr && (((opa_select == RegRs1) && rs1_is_f2i) || ((opb_select == RegRs2) && rs2_is_f2i) || ((opc_select == RegRs2) && rs2_is_f2i));

  // Write to I2F if rd==x31 and queues are enabled
  assign rd_is_i2f = (rd == 'd31) & en_copift_o;

  // Integer-to-FP COPIFT queue
  stream_fifo #(
    .FALL_THROUGH(1'b0),
    .DATA_WIDTH  (32),
    .DEPTH       (16)
  ) i_i2f_queue (
    .clk_i     (clk_i),
    .rst_ni    (~rst_i),
    .flush_i   ('0),
    .testmode_i('0),
    .usage_o   (),
    .data_i    (i2f_wdata),
    .valid_i   (i2f_wvalid),
    .ready_o   (i2f_wready),
    .data_o    (i2f_rdata_o),
    .valid_o   (i2f_rvalid_o),
    .ready_i   (i2f_rready_i)
  );

  // FP-to-integer COPIFT queue
  stream_fifo #(
    .FALL_THROUGH(1'b0),
    .DATA_WIDTH  (32),
    .DEPTH       (16)
  ) i_f2i_queue (
    .clk_i     (clk_i),
    .rst_ni    (~rst_i),
    .flush_i   ('0),
    .testmode_i('0),
    .usage_o   (),
    .data_i    (f2i_wdata_i),
    .valid_i   (f2i_wvalid_i),
    .ready_o   (f2i_wready_o),
    .data_o    (f2i_rdata),
    .valid_o   (f2i_rvalid),
    .ready_i   (f2i_rready)
  );

  snitch_regfile #(
    .DataWidth    ( 32             ),
    .NrReadPorts  ( NumRfReadPorts ),
    .NrWritePorts ( 1              ),
    .ZeroRegZero  ( 1              ),
    .AddrWidth    ( RegWidth       )
  ) i_snitch_regfile (
    .clk_i,
    .rst_ni    ( ~rst_i    ),
    .raddr_i   ( gpr_raddr ),
    .rdata_o   ( gpr_rdata ),
    .waddr_i   ( gpr_waddr ),
    .wdata_i   ( gpr_wdata ),
    .we_i      ( gpr_we    )
  );

  // --------------------
  // Operand Select
  // --------------------
  // opa, opb and opc are tied to FU operands (1st, 2nd and 3rd, respectively).
  // rs1, rs2, rs3 and rd are tied to the instruction encoding.
  // Finally, gpr_r[addr|data][i] identify the i-th RF read port.
  // An operand (op*) is read from a register ([rs1, rs2, rs3, rd]), through a RF read port (gpr_raddr[i]).
  //
  // op*_select specifies which RF port (if any) an operand accesses.
  // gpr_raddr[i] specifies which register the i-th read port accesses.

  always_comb begin
    unique case (opa_select)
      None: opa = '0;
      RegRs1: opa = rs1_is_f2i ? f2i_rdata : gpr_rdata[0];
      UImmediate: opa = uimm;
      JImmediate: opa = jimm;
      CSRImmmediate: opa = {{{32-RegWidth}{1'b0}}, rs1};
      default: opa = '0;
    endcase
  end

  always_comb begin
    unique case (opb_select)
      None: opb = '0;
      RegRs2: opb = rs2_is_f2i ? f2i_rdata : gpr_rdata[1];
      RegRd: opb = (NumRfReadPorts > 2) ? gpr_rdata[2] : '0;
      IImmediate: opb = iimm;
      SFImmediate, SImmediate: opb = simm;
      PC: opb = pc_q;
      CSR: opb = csr_rvalue;
      PBImmediate: opb = pbimm;
      default: opb = '0;
    endcase
  end

  always_comb begin
    unique case (opc_select)
      None: opc = '0;
      RegRs2: opc = gpr_rdata[1];
      RegRs3, RegRd: opc = (NumRfReadPorts > 2) ? gpr_rdata[2] : '0;
      default: opc = '0;
    endcase
  end

  assign gpr_raddr[0] = rs1;  // Read port 1 always accesses rs1
  assign gpr_raddr[1] = rs2;  // Read port 2 always accesses rs2
  if (NumRfReadPorts > 2) begin : gen_third_read_port
    // Read port 3 can access either rs3 or rd
    assign gpr_raddr[2] = ((opb_select == RegRd) || (opc_select == RegRd)) ? rd : rs3;
  end

  // --------------------
  // ALU
  // --------------------
  // Main Shifter
  logic [31:0] shift_opa, shift_opa_reversed;
  logic [31:0] shift_right_result, shift_left_result;
  logic [32:0] shift_opa_ext, shift_right_result_ext;
  logic shift_left, shift_arithmetic; // shift control
  for (genvar i = 0; i < 32; i++) begin : gen_reverse_opa
    assign shift_opa_reversed[i] = opa[31-i];
    assign shift_left_result[i] = shift_right_result[31-i];
  end
  assign shift_opa = shift_left ? shift_opa_reversed : opa;
  assign shift_opa_ext = {shift_opa[31] & shift_arithmetic, shift_opa};
  assign shift_right_result_ext = $unsigned($signed(shift_opa_ext) >>> opb[4:0]);
  assign shift_right_result = shift_right_result_ext[31:0];

  // Main Adder
  logic [32:0] alu_opa, alu_opb;
  assign adder_result = alu_opa + alu_opb;

  // ALU
  /* verilator lint_off WIDTH */
  always_comb begin
    alu_opa = $signed(opa);
    alu_opb = $signed(opb);

    alu_result = adder_result[31:0];
    shift_left = 1'b0;
    shift_arithmetic = 1'b0;

    unique case (alu_op)
      Sub: alu_opb = -$signed(opb);
      Slt: begin
        alu_opb = -$signed(opb);
        alu_result = {30'b0, adder_result[32]};
      end
      Ge: begin
        alu_opb = -$signed(opb);
        alu_result = {30'b0, ~adder_result[32]};
      end
      Sltu: begin
        alu_opa = $unsigned(opa);
        alu_opb = -$unsigned(opb);
        alu_result = {30'b0, adder_result[32]};
      end
      Geu: begin
        alu_opa = $unsigned(opa);
        alu_opb = -$unsigned(opb);
        alu_result = {30'b0, ~adder_result[32]};
      end
      Sll: begin
        shift_left = 1'b1;
        alu_result = shift_left_result;
      end
      Srl: alu_result = shift_right_result;
      Sra: begin
        shift_arithmetic = 1'b1;
        alu_result = shift_right_result;
      end
      LXor: alu_result = opa ^ opb;
      LAnd: alu_result = opa & opb;
      LNAnd: alu_result = (~opa) & opb;
      LOr: alu_result = opa | opb;
      Eq: begin
        alu_opb = -$signed(opb);
        alu_result = ~|adder_result;
      end
      Neq: begin
        alu_opb = -$signed(opb);
        alu_result = |adder_result;
      end
      BypassA: begin
        alu_result = opa;
      end
      default: alu_result = adder_result[31:0];
    endcase
  end
  /* verilator lint_on WIDTH */

  // --------------------
  // L0 DTLB
  // --------------------
  assign dtlb_va = va_t'(is_postincr ? gpr_rdata[0][31:PageShift] : alu_result[31:PageShift]);

  if (VMSupport) begin : gen_dtlb
    snitch_l0_tlb #(
      .pa_t (pa_t),
      .l0_pte_t (l0_pte_t),
      .NrEntries ( NumDTLBEntries )
    ) i_snitch_l0_tlb_data (
      .clk_i,
      .rst_i,
      .flush_i ( tlb_flush ),
      .priv_lvl_i ( priv_lvl_q ),
      .valid_i ( dtlb_valid ),
      .ready_o ( dtlb_ready ),
      .va_i ( dtlb_va ),
      .write_i ( is_store ),
      .read_i ( is_load ),
      .execute_i ( 1'b0 ),
      .page_fault_o ( dtlb_page_fault ),
      .pa_o ( dtlb_pa ),
      // Refill port
      .valid_o ( ptw_valid_o [1] ),
      .ready_i ( ptw_ready_i [1] ),
      .va_o ( ptw_va_o [1] ),
      .pte_i ( ptw_pte_i [1] ),
      .is_4mega_i ( ptw_is_4mega_i [1] )
    );
  end else begin : gen_no_dtlb
    // Tie off core-side interface (dtlb_pa unused as trans_active == '0)
    assign dtlb_pa          = pa_t'(dtlb_va);
    assign dtlb_ready       = 1'b0;
    assign dtlb_page_fault  = 1'b0;
    // Tie off TLB refill request
    assign ptw_valid_o[1] = 1'b0;
    assign ptw_va_o[1]    = '0;
  end

  assign ptw_ppn_o[0] = $unsigned(satp_q.ppn);
  assign ptw_ppn_o[1] = $unsigned(satp_q.ppn);

  // Translation is active if it is set in SATP and we are not in machine mode or debug mode.
  assign trans_active = satp_q.mode & (priv_lvl_q != PrivLvlM) & ~debug_q;
  assign dtlb_trans_valid = trans_active & dtlb_valid & dtlb_ready;
  assign trans_active_exp = {{PPNSize}{trans_active}};
  assign trans_ready = ((trans_active & dtlb_ready) | ~trans_active);

  assign dtlb_valid = (lsu_tlb_qvalid & trans_active) | ((is_fp_load | is_fp_store) & trans_active);

  // Mulitplexer using and/or as this signal is likely timing critical.
  // Without virtual memory, address can be alu_result (i.e. rs1 + iimm/simm) or rs1 (for post-increment load/stores)
  // TODO(colluca): do not hardcode gpr_rdata[0] here
  assign ls_paddr[PPNSize+PageShift-1:PageShift] =
          ({(PPNSize){trans_active}} & dtlb_pa) |
          (~{(PPNSize){trans_active}} & {mseg_q, (is_postincr ? gpr_rdata[0][31:PageShift] : alu_result[31:PageShift])});
  assign ls_paddr[PageShift-1:0] = is_postincr ? gpr_rdata[0][PageShift-1:0] : alu_result[PageShift-1:0];

  assign lsu_qvalid = lsu_tlb_qvalid & trans_ready;
  assign lsu_tlb_qready = lsu_qready & trans_ready;

  // --------------------
  // LSU
  // --------------------
  data_t lsu_qdata;
  // sign exten to appropriate length
  assign lsu_qdata = $unsigned((ls_amo == reqrsp_pkg::AMONone) ? opc : opb);

  // Consider CAQ in accelerator handshake when offloading an FPU load or store.
  assign caq_ena = is_fp_load | is_fp_store;
  // Make request to CAQ when offloading access and accelerator interface ready.
  // Do *not* issue request when a non-accelerator (CAQ-unrelated) stall is blocking progress.
  assign caq_qvalid = caq_ena & acc_qready_i & ~nonacc_stall;

  snitch_lsu #(
    .AddrWidth (AddrWidth),
    .DataWidth (DataWidth),
    .dreq_t (dreq_t),
    .drsp_t (drsp_t),
    .tag_t (logic[RegWidth-1:0]),
    .NumOutstandingMem (NumIntOutstandingMem),
    .NumOutstandingLoads (NumIntOutstandingLoads),
    .Caq (FP_EN),
    .CaqDepth (CaqDepth),
    .CaqTagWidth (CaqTagWidth),
    .CaqRespTrackSeq (1'b0)
  ) i_snitch_lsu (
    .clk_i (clk_i),
    .rst_i (rst_i),
    .lsu_qtag_i (rd),
    .lsu_qwrite_i (is_store),
    .lsu_qsigned_i (is_signed),
    .lsu_qaddr_i (ls_paddr),
    .lsu_qdata_i (lsu_qdata),
    .lsu_qsize_i (ls_size),
    .lsu_qamo_i (ls_amo),
    .lsu_qrepd_i (1'b0),
    .lsu_qmcast_i (addr_t'(csr_mcast_q)),
    .lsu_qvalid_i (lsu_qvalid),
    .lsu_qready_o (lsu_qready),
    .lsu_pdata_o (ld_result),
    .lsu_ptag_o (lsu_rd),
    .lsu_perror_o (/* ignored for the moment */),
    .lsu_pvalid_o (lsu_pvalid),
    .lsu_pready_i (lsu_pready),
    .lsu_empty_o (lsu_empty),
    .caq_qaddr_i (ls_paddr),
    .caq_qwrite_i (is_fp_store),
    .caq_qvalid_i (caq_qvalid),
    .caq_qready_o (caq_qready),
    .caq_pvalid_i,
    .caq_pvalid_o ( ),
    .caq_empty_o (caq_empty),
    .data_req_o,
    .data_rsp_i
  );

  assign lsu_tlb_qvalid = valid_instr & (is_load | is_store)
                                      & ~(ld_addr_misaligned | st_addr_misaligned);

  // NOTE: write-backs "on rd from non-load or non-acc instructions" and "on rs1 from
  // post-increment instructions" in the same cycle should be mutually exclusive (currently valid
  // assumption since write-back to rs1 happens on the cycle in which the post-increment load/store
  // is issued, if that cycle is not a stall, and it is not postponed like offloaded instructions,
  // so no other instructions writing back on rd can be issued in the same cycle)
  // retire post-incremented address on rs1 if valid postincr instruction and LSU not stalling
  assign retire_p = write_rs1 & ~stall & (rs1 != 0);
  // we can retire if we are not stalling and if the instruction is writing a register
  assign retire_i = write_rd & valid_instr & (rd != 0);

  // -----------------------
  // Unaligned Address Check
  // -----------------------
  always_comb begin
    ls_misaligned = 1'b0;
    unique case (ls_size)
      HalfWord: if (alu_result[0] != 1'b0) ls_misaligned = 1'b1;
      Word: if (alu_result[1:0] != 2'b00) ls_misaligned = 1'b1;
      Double: if (alu_result[2:0] != 3'b000) ls_misaligned = 1'b1;
      default: ls_misaligned = 1'b0;
    endcase
  end

  assign st_addr_misaligned = ls_misaligned & (is_store | is_fp_store);
  assign ld_addr_misaligned = ls_misaligned & (is_load | is_fp_load);

  // pragma translate_off
  always_ff @(posedge clk_i) begin
    if (!rst_i && (ld_addr_misaligned || st_addr_misaligned) && valid_instr) begin
      $info("[Misaligned Load/Store Core %0d] PC: %h Data: %h Addr: %h",
            hart_id_i, inst_addr_o, inst_data_i, alu_result);
    end
  end
  // pragma translate_on

  // --------------------
  // Write-Back
  // --------------------
  // Write-back data, can come from:
  // 1. ALU/Jump Target/Bypass
  // 2. LSU
  // 3. Accelerator Bus
  logic [31:0] alu_writeback;
  always_comb begin
    casez (rd_select)
      RdAlu: alu_writeback = alu_result;
      RdConsecPC: alu_writeback = consec_pc;
      RdBypass: alu_writeback = rd_bypass;
      default: alu_writeback = alu_result;
    endcase
  end

  // Writeback can be to GPR or to I2F queue
  always_comb begin
    gpr_we[0] = 1'b0;
      // NOTE: this works because write-backs on rd and rs1 in the same cycle are mutually
      // exclusive; if this should change, the following statement has to be written in another form
    gpr_waddr[0] = retire_p ? rs1 : rd; // choose whether to writeback at RF[rs1] for post-increment load/stores
    gpr_wdata[0] = alu_writeback;

    i2f_wvalid = 1'b0;
    i2f_wdata = alu_writeback;
    
    // external interfaces
    lsu_pready = 1'b0;
    acc_pready_o = 1'b0;
    // Always assert x_result_ready if the coprocessor does not request a write
    x_result_ready_o = ~x_result_i.we;
    retire_acc = 1'b0;
    retire_load = 1'b0;
    retire_x = 1'b0;

    if (retire_i | retire_p) begin
      gpr_we[0] = ~rd_is_i2f;
      i2f_wvalid = rd_is_i2f;
    // if we are not retiring another instruction retire the load now
    end else if (lsu_pvalid) begin
      retire_load = 1'b1;
      gpr_we[0] = ~((lsu_rd =='d31) & en_copift_o);
      gpr_waddr[0] = lsu_rd;
      gpr_wdata[0] = ld_result[31:0];

      i2f_wvalid = (lsu_rd =='d31) & en_copift_o;
      i2f_wdata = ld_result[31:0];

      lsu_pready = ((lsu_rd =='d31) & en_copift_o) ? i2f_wready : 1'b1;
    end else if (acc_pvalid_i) begin
      retire_acc = 1'b1;
      gpr_we[0] = ~((acc_prsp_i.id =='d31) & en_copift_o);
      gpr_waddr[0] = acc_prsp_i.id;
      gpr_wdata[0] = acc_prsp_i.data[31:0];

      i2f_wvalid = ((acc_prsp_i.id =='d31) & en_copift_o);
      i2f_wdata = acc_prsp_i.data[31:0];

      acc_pready_o = en_copift_o ? i2f_wready : 1'b1;
    end else if (EnableXif & x_result_valid_i & x_result_i.we) begin
      retire_x = 1'b1;
      gpr_we[0] = 1'b1;
      gpr_waddr[0] = x_result_i.rd;
      gpr_wdata[0] = x_result_i.data[31:0];
      x_result_ready_o = 1'b1;
    end
  end

  assign inst_addr_misaligned = (inst_data_i inside {
    JAL,
    JALR,
    BEQ,
    BNE,
    BLT,
    BLTU,
    BGE,
    BGEU
  }) && (consec_pc[1:0] != 2'b0);

  // ----------
  // Assertions
  // ----------
  // Make sure the instruction interface is stable. Otherwise, Snitch might violate the protocol at
  // the LSU or accelerator interface by withdrawing the valid signal.
  // TODO: Remove cacheability attribute, that should hold true for all instruction fetch transacitons.
  `ASSERT(InstructionInterfaceStable,
      (inst_valid_o && inst_ready_i && inst_cacheable_o) ##1 (inst_valid_o && $stable(inst_addr_o))
      |-> inst_ready_i && $stable(inst_data_i), clk_i, rst_i)

  // Make sure that we never write back an unknown value to the register file
  `ASSERT(RegWriteKnown, gpr_we & (gpr_waddr != 0) |-> !$isunknown(gpr_wdata), clk_i, rst_i)

  // Check that PMA rule counts do not exceed maximum number of rules
  `ASSERT_INIT(CheckPMANonIdempotent,
    SnitchPMACfg.NrNonIdempotentRegionRules <= snitch_pma_pkg::NrMaxRules);
  `ASSERT_INIT(CheckPMAExecute, SnitchPMACfg.NrExecuteRegionRules <= snitch_pma_pkg::NrMaxRules);
  `ASSERT_INIT(CheckPMACached, SnitchPMACfg.NrCachedRegionRules <= snitch_pma_pkg::NrMaxRules);
  `ASSERT_INIT(CheckPMAAMORegion, SnitchPMACfg.NrAMORegionRules <= snitch_pma_pkg::NrMaxRules);

  // Make sure that without virtual memory support, translation is never enabled
  `ASSERT(NoVMSupportNoTranslation, (~VMSupport |-> ~trans_active), clk_i, rst_i)

  // Make sure debug IRQ line is not raised when debug mode is not supported
  `ASSERT(DebugModeUnsupported, irq_i.debug == 1'b1 |-> DebugSupport == 1, clk_i, rst_i)

  // Both rd and rs3 reads share the third read port to the RF, so they can't be simultaneously accessed
  `ASSERT(NoMixedRdRs3,
    !((opb_select == RegRd && opc_select == RegRs3) ||
    (opb_select == RegRs3 && opc_select == RegRd)), clk_i, rst_i)


endmodule
