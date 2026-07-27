// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>
//
// Simulation-only instruction tracer for the Snitch Core Complex (CC).
// Emits one DASM trace line per retired/stalled Snitch, FPU, FPU-sequencer,
// and DCA event to `logs/trace_hart_<hart_id>.dasm`.

// pragma translate_off
module snitch_tracer #(
  parameter bit FpEn      = 0,
  parameter bit Xfrep     = 0,
  parameter bit EnableDca = 0
) (
  input logic clk_i,
  input logic rst_ni,
  input snitch_pkg::hart_id_t hart_id_i,
  input snitch_pkg::snitch_trace_t trace_port_i,
  input snitch_pkg::fpss_trace_t fpss_trace_i,
  input snitch_pkg::fpu_sequencer_trace_t fpu_sequencer_trace_i,
  input snitch_pkg::dca_trace_t dca_trace_i
);

  int f;
  string fn;
  logic [63:0] cycle;
  initial begin
    // We need to schedule the assignment into a safe region, otherwise
    // `hart_id_i` won't have a value assigned at the beginning of the first
    // delta cycle.
`ifndef VERILATOR
    #0;
`endif
    $system("mkdir logs -p");
    $sformat(fn, "logs/trace_hart_%05x.dasm", hart_id_i);
    f = $fopen(fn, "w");
    $display("[Tracer] Logging Hart %d to %s", hart_id_i, fn);
  end

  // verilog_lint: waive-start always-ff-non-blocking
  always_ff @(posedge clk_i or negedge rst_ni) begin
    automatic string trace_entry;

    if (rst_ni) begin
      cycle++;
      // Trace snitch iff:
      // we are not stalled <==> we have issued and processed an instruction (including offloads)
      // OR we are retiring (issuing a writeback from) a load or accelerator instruction
      if (
          !trace_port_i.extras.stall || trace_port_i.extras.retire_load
          || trace_port_i.extras.retire_acc
      ) begin
        $sformat(trace_entry, "%t %1d %8d 0x%h DASM(%h) #; %s\n",
            $time, cycle, trace_port_i.priv_lvl_q, trace_port_i.pc_q, trace_port_i.instr,
            snitch_pkg::print_snitch_extras(trace_port_i.extras));
        $fwrite(f, trace_entry);
`ifdef DEBUG
        $fflush(f);
`endif
      end
      if (FpEn) begin
        // Trace FPU iff:
        // an incoming handshake on the accelerator bus occurs <==> an instruction was issued
        // OR an FPU result is ready to be written back to an FPR register or the bus
        // OR an LSU result is ready to be written back to an FPR register or the bus
        // OR an FPU result, LSU result or bus value is ready to be written back to an FPR register
        if (fpss_trace_i.acc_q_hs || fpss_trace_i.fpu_out_hs
        || fpss_trace_i.lsu_q_hs || fpss_trace_i.fpr_we) begin
          $sformat(trace_entry, "%t %1d %8d 0x%h DASM(%h) #; %s\n",
              $time, cycle, trace_port_i.priv_lvl_q, 32'hz, fpss_trace_i.op_in,
              snitch_pkg::print_fpss_extras(fpss_trace_i));
          $fwrite(f, trace_entry);
`ifdef DEBUG
          $fflush(f);
`endif
        end
        // sequencer instructions
        if (Xfrep) begin
          if (fpu_sequencer_trace_i.cbuf_push) begin
            $sformat(trace_entry, "%t %1d %8d 0x%h DASM(%h) #; %s\n",
                $time, cycle, trace_port_i.priv_lvl_q, 32'hz, 64'hz,
                snitch_pkg::print_fpu_sequencer_extras(fpu_sequencer_trace_i));
            $fwrite(f, trace_entry);
`ifdef DEBUG
            $fflush(f);
`endif
          end
        end
      end
      if (EnableDca) begin
        // Trace DCA iff a request or response handshake occurs
        if (dca_trace_i.req_hs || dca_trace_i.rsp_hs) begin
          $sformat(trace_entry, "%t %1d %8d 0x%h DASM(%h) #; %s\n",
              $time, cycle, trace_port_i.priv_lvl_q, 32'hz, dca_trace_i.op,
              snitch_pkg::print_dca_extras(dca_trace_i));
          $fwrite(f, trace_entry);
`ifdef DEBUG
          $fflush(f);
`endif
        end
      end
    end else begin
      cycle = '0;
    end
  end

  final begin
    $fclose(f);
  end
  // verilog_lint: waive-stop always-ff-non-blocking

endmodule
// pragma translate_on
