onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Snitch Cores}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/clk_i}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/rst_i}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/hart_id_i}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/irq_i}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/flush_i_valid_o}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/flush_i_ready_i}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/inst_addr_o}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/inst_cacheable_o}
add wave -noupdate -expand -group {Core 0} -radix hexadecimal {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/inst_data_i}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/inst_valid_o}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/inst_ready_i}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/acc_qreq_o}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/acc_qvalid_o}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/acc_qready_i}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/acc_prsp_i}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/acc_pvalid_i}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/acc_pready_o}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/data_req_o}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/data_rsp_i}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/ptw_valid_o}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/ptw_ready_i}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/ptw_va_o}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/ptw_ppn_o}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/ptw_pte_i}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/ptw_is_4mega_i}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/fpu_rnd_mode_o}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/fpu_fmt_mode_o}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/fpu_status_i}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/caq_pvalid_i}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/core_events_o}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/barrier_o}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/barrier_i}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/illegal_inst}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/illegal_csr}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/interrupt}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/ecall}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/ebreak}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/zero_lsb}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/meip}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/mtip}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/msip}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/mcip}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/seip}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/stip}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/ssip}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/scip}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/interrupts_enabled}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/any_interrupt_pending}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/pc_d}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/pc_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/wfi_d}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/wfi_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/consec_pc}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/iimm}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/uimm}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/jimm}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/bimm}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/simm}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/opa}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/opb}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/adder_result}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/alu_result}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/shuffle}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/rd}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/rs1}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/rs2}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/stall}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/lsu_stall}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/nonacc_stall}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/gpr_raddr}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/gpr_rdata}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/gpr_waddr}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/gpr_wdata}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/gpr_we}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/sb_d}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/sb_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/is_load}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/is_store}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/is_signed}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/is_fp_load}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/is_fp_store}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/ls_misaligned}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/ld_addr_misaligned}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/st_addr_misaligned}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/inst_addr_misaligned}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/caq_qvalid}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/caq_qready}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/caq_ena}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/itlb_valid}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/itlb_ready}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/itlb_va}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/itlb_page_fault}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/itlb_pa}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/dtlb_valid}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/dtlb_ready}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/dtlb_va}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/dtlb_page_fault}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/dtlb_pa}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/trans_ready}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/trans_active}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/itlb_trans_valid}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/dtlb_trans_valid}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/trans_active_exp}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/tlb_flush}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/ls_size}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/ls_amo}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/ld_result}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/lsu_qready}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/lsu_qvalid}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/lsu_tlb_qready}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/lsu_tlb_qvalid}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/lsu_pvalid}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/lsu_pready}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/lsu_empty}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/ls_paddr}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/lsu_rd}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/retire_load}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/retire_i}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/retire_acc}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/acc_stall}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/valid_instr}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/exception}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/alu_op}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/opa_select}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/opb_select}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/write_rd}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/uses_rd}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/next_pc}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/rd_select}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/rd_bypass}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/is_branch}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/csr_rvalue}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/csr_en}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/csr_dump}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/csr_stall_d}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/csr_stall_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/scratch_d}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/scratch_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/epc_d}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/epc_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/tvec_d}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/tvec_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/cause_d}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/cause_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/cause_irq_d}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/cause_irq_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/spp_d}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/spp_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/mpp_d}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/mpp_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/ie_d}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/ie_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/pie_d}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/pie_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/eie_d}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/eie_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/tie_d}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/tie_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/sie_d}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/sie_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/cie_d}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/cie_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/seip_d}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/seip_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/stip_d}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/stip_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/ssip_d}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/ssip_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/scip_d}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/scip_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/priv_lvl_d}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/priv_lvl_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/satp_d}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/satp_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/dcsr_d}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/dcsr_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/dpc_d}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/dpc_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/dscratch_d}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/dscratch_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/debug_d}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/debug_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/fcsr_d}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/fcsr_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/cycle_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/instret_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/retired_instr_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/retired_load_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/retired_i_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/retired_acc_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/mseg_q}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/mseg_d}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/acc_register_rd}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/operands_ready}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/dst_ready}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/opa_ready}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/opb_ready}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/npc}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/shift_opa}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/shift_opa_reversed}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/shift_right_result}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/shift_left_result}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/shift_opa_ext}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/shift_right_result_ext}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/shift_left}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/shift_arithmetic}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/alu_opa}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/alu_opb}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/lsu_qdata}
add wave -noupdate -expand -group {Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/i_snitch/alu_writeback}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/clk_i}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rst_i}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/trace_port_o}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/sequencer_tracer_port_o}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/hart_id_i}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_i}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_valid_i}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_ready_o}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_resp_o}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_resp_valid_o}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_resp_ready_i}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/data_req_o}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/data_rsp_i}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_rnd_mode_i}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_fmt_mode_i}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_status_o}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_raddr_o}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rdata_i}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rvalid_o}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rready_i}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rdone_o}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_waddr_o}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wdata_o}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wvalid_o}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wready_i}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wdone_o}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/streamctl_done_i}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/streamctl_valid_i}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/streamctl_ready_o}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/caq_pvalid_o}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/core_events_o}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_op}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_rnd_mode}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/src_fmt}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/dst_fmt}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/int_fmt}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/vectorial_op}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/set_dyn_rm}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_raddr}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_rdata}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_we}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_waddr}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_wdata}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_wvalid}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_wready}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_active_d}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_active_q}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_active_ena}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_tag_in}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_tag_out}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/use_fpu}
add wave -noupdate -expand -group {FPU Core 0} -expand {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op}
add wave -noupdate -expand -group {FPU Core 0} -expand {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op_ready}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_qready}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_qvalid}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ld_result}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_rd}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_pvalid}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_pready}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/is_store}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/is_load}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/sb_d}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/sb_q}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rd_is_fp}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/csr_instr}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/use_shfl}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_wready}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_valid}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_result}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_rd}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/reg_mask}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/byte_mask}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_out_valid}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_out_ready}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_in_valid}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_in_ready}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op_select}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/result_select}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op_mode}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rs1}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rs2}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rs3}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rd}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ls_size}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/dst_ready}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_q}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_repd_q}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_valid}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_valid_q}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_ready}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_ready_q}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_result}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/is_rd_ssr}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/byte_msk}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rA}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rD}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/indx}
add wave -noupdate -expand -group {FPU Core 0} -expand {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_qdata}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/nan_boxed_arga}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/issue_fpu}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/issue_core_to_fpu}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/issue_fpu_seq}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/clk_i}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/rst_ni}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/hart_id_i}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/operands_i}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/rnd_mode_i}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/op_i}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/op_mod_i}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/src_fmt_i}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/dst_fmt_i}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/int_fmt_i}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/vectorial_op_i}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/tag_i}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_valid_i}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_ready_o}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/result_o}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/status_o}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/tag_o}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_valid_o}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_ready_i}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_in_q}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_in}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_out_q}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_out}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_valid_q}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_ready_q}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_valid}
add wave -noupdate -expand -group {FPU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_ready}
add wave -noupdate -group {LSU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_snitch_lsu/data_req_o}
add wave -noupdate -group {LSU Core 0} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[0]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_snitch_lsu/data_rsp_i}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/clk_i}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/rst_i}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/hart_id_i}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/irq_i}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/flush_i_valid_o}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/flush_i_ready_i}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/inst_addr_o}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/inst_cacheable_o}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/inst_data_i}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/inst_valid_o}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/inst_ready_i}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/acc_qreq_o}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/acc_qvalid_o}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/acc_qready_i}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/acc_prsp_i}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/acc_pvalid_i}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/acc_pready_o}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/data_req_o}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/data_rsp_i}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/ptw_valid_o}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/ptw_ready_i}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/ptw_va_o}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/ptw_ppn_o}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/ptw_pte_i}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/ptw_is_4mega_i}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/fpu_rnd_mode_o}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/fpu_fmt_mode_o}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/fpu_status_i}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/caq_pvalid_i}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/core_events_o}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/barrier_o}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/barrier_i}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/illegal_inst}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/illegal_csr}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/interrupt}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/ecall}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/ebreak}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/zero_lsb}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/meip}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/mtip}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/msip}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/mcip}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/seip}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/stip}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/ssip}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/scip}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/interrupts_enabled}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/any_interrupt_pending}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/pc_d}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/pc_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/wfi_d}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/wfi_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/consec_pc}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/iimm}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/uimm}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/jimm}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/bimm}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/simm}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/opa}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/opb}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/adder_result}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/alu_result}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/shuffle}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/rd}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/rs1}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/rs2}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/stall}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/lsu_stall}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/nonacc_stall}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/gpr_raddr}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/gpr_rdata}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/gpr_waddr}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/gpr_wdata}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/gpr_we}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/sb_d}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/sb_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/is_load}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/is_store}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/is_signed}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/is_fp_load}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/is_fp_store}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/ls_misaligned}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/ld_addr_misaligned}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/st_addr_misaligned}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/inst_addr_misaligned}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/caq_qvalid}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/caq_qready}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/caq_ena}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/itlb_valid}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/itlb_ready}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/itlb_va}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/itlb_page_fault}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/itlb_pa}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/dtlb_valid}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/dtlb_ready}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/dtlb_va}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/dtlb_page_fault}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/dtlb_pa}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/trans_ready}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/trans_active}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/itlb_trans_valid}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/dtlb_trans_valid}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/trans_active_exp}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/tlb_flush}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/ls_size}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/ls_amo}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/ld_result}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/lsu_qready}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/lsu_qvalid}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/lsu_tlb_qready}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/lsu_tlb_qvalid}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/lsu_pvalid}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/lsu_pready}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/lsu_empty}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/ls_paddr}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/lsu_rd}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/retire_load}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/retire_i}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/retire_acc}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/acc_stall}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/valid_instr}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/exception}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/alu_op}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/opa_select}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/opb_select}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/write_rd}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/uses_rd}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/next_pc}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/rd_select}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/rd_bypass}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/is_branch}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/csr_rvalue}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/csr_en}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/csr_dump}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/csr_stall_d}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/csr_stall_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/scratch_d}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/scratch_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/epc_d}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/epc_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/tvec_d}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/tvec_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/cause_d}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/cause_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/cause_irq_d}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/cause_irq_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/spp_d}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/spp_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/mpp_d}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/mpp_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/ie_d}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/ie_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/pie_d}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/pie_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/eie_d}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/eie_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/tie_d}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/tie_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/sie_d}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/sie_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/cie_d}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/cie_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/seip_d}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/seip_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/stip_d}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/stip_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/ssip_d}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/ssip_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/scip_d}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/scip_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/priv_lvl_d}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/priv_lvl_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/satp_d}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/satp_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/dcsr_d}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/dcsr_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/dpc_d}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/dpc_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/dscratch_d}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/dscratch_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/debug_d}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/debug_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/fcsr_d}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/fcsr_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/cycle_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/instret_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/retired_instr_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/retired_load_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/retired_i_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/retired_acc_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/mseg_q}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/mseg_d}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/acc_register_rd}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/operands_ready}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/dst_ready}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/opa_ready}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/opb_ready}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/npc}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/shift_opa}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/shift_opa_reversed}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/shift_right_result}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/shift_left_result}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/shift_opa_ext}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/shift_right_result_ext}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/shift_left}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/shift_arithmetic}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/alu_opa}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/alu_opb}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/lsu_qdata}
add wave -noupdate -group {Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/i_snitch/alu_writeback}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/clk_i}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rst_i}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/trace_port_o}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/sequencer_tracer_port_o}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/hart_id_i}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_i}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_valid_i}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_ready_o}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_resp_o}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_resp_valid_o}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_resp_ready_i}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/data_req_o}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/data_rsp_i}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_rnd_mode_i}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_fmt_mode_i}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_status_o}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_raddr_o}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rdata_i}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rvalid_o}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rready_i}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rdone_o}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_waddr_o}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wdata_o}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wvalid_o}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wready_i}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wdone_o}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/streamctl_done_i}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/streamctl_valid_i}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/streamctl_ready_o}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/caq_pvalid_o}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/core_events_o}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_op}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_rnd_mode}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/src_fmt}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/dst_fmt}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/int_fmt}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/vectorial_op}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/set_dyn_rm}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_raddr}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_rdata}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_we}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_waddr}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_wdata}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_wvalid}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_wready}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_active_d}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_active_q}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_active_ena}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_tag_in}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_tag_out}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/use_fpu}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op_ready}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_qready}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_qvalid}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ld_result}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_rd}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_pvalid}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_pready}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/is_store}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/is_load}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/sb_d}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/sb_q}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rd_is_fp}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/csr_instr}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/use_shfl}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_wready}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_valid}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_result}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_rd}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/reg_mask}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/byte_mask}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_out_valid}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_out_ready}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_in_valid}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_in_ready}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op_select}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/result_select}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op_mode}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rs1}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rs2}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rs3}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rd}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ls_size}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/dst_ready}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_q}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_repd_q}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_valid}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_valid_q}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_ready}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_ready_q}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_result}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/is_rd_ssr}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/byte_msk}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rA}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rD}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/indx}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_qdata}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/nan_boxed_arga}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/issue_fpu}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/issue_core_to_fpu}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/issue_fpu_seq}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/clk_i}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/rst_ni}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/hart_id_i}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/operands_i}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/rnd_mode_i}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/op_i}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/op_mod_i}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/src_fmt_i}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/dst_fmt_i}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/int_fmt_i}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/vectorial_op_i}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/tag_i}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_valid_i}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_ready_o}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/result_o}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/status_o}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/tag_o}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_valid_o}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_ready_i}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_in_q}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_in}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_out_q}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_out}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_valid_q}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_ready_q}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_valid}
add wave -noupdate -group {FPU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_ready}
add wave -noupdate -group {LSU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_snitch_lsu/data_req_o}
add wave -noupdate -group {LSU Core 1} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[1]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_snitch_lsu/data_rsp_i}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/clk_i}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/rst_i}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/hart_id_i}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/irq_i}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/flush_i_valid_o}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/flush_i_ready_i}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/inst_addr_o}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/inst_cacheable_o}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/inst_data_i}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/inst_valid_o}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/inst_ready_i}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/acc_qreq_o}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/acc_qvalid_o}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/acc_qready_i}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/acc_prsp_i}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/acc_pvalid_i}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/acc_pready_o}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/data_req_o}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/data_rsp_i}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/ptw_valid_o}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/ptw_ready_i}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/ptw_va_o}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/ptw_ppn_o}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/ptw_pte_i}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/ptw_is_4mega_i}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/fpu_rnd_mode_o}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/fpu_fmt_mode_o}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/fpu_status_i}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/caq_pvalid_i}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/core_events_o}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/barrier_o}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/barrier_i}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/illegal_inst}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/illegal_csr}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/interrupt}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/ecall}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/ebreak}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/zero_lsb}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/meip}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/mtip}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/msip}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/mcip}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/seip}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/stip}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/ssip}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/scip}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/interrupts_enabled}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/any_interrupt_pending}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/pc_d}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/pc_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/wfi_d}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/wfi_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/consec_pc}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/iimm}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/uimm}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/jimm}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/bimm}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/simm}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/opa}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/opb}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/adder_result}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/alu_result}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/shuffle}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/rd}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/rs1}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/rs2}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/stall}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/lsu_stall}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/nonacc_stall}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/gpr_raddr}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/gpr_rdata}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/gpr_waddr}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/gpr_wdata}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/gpr_we}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/sb_d}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/sb_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/is_load}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/is_store}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/is_signed}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/is_fp_load}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/is_fp_store}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/ls_misaligned}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/ld_addr_misaligned}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/st_addr_misaligned}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/inst_addr_misaligned}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/caq_qvalid}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/caq_qready}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/caq_ena}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/itlb_valid}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/itlb_ready}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/itlb_va}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/itlb_page_fault}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/itlb_pa}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/dtlb_valid}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/dtlb_ready}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/dtlb_va}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/dtlb_page_fault}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/dtlb_pa}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/trans_ready}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/trans_active}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/itlb_trans_valid}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/dtlb_trans_valid}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/trans_active_exp}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/tlb_flush}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/ls_size}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/ls_amo}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/ld_result}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/lsu_qready}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/lsu_qvalid}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/lsu_tlb_qready}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/lsu_tlb_qvalid}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/lsu_pvalid}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/lsu_pready}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/lsu_empty}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/ls_paddr}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/lsu_rd}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/retire_load}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/retire_i}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/retire_acc}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/acc_stall}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/valid_instr}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/exception}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/alu_op}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/opa_select}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/opb_select}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/write_rd}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/uses_rd}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/next_pc}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/rd_select}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/rd_bypass}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/is_branch}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/csr_rvalue}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/csr_en}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/csr_dump}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/csr_stall_d}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/csr_stall_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/scratch_d}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/scratch_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/epc_d}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/epc_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/tvec_d}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/tvec_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/cause_d}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/cause_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/cause_irq_d}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/cause_irq_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/spp_d}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/spp_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/mpp_d}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/mpp_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/ie_d}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/ie_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/pie_d}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/pie_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/eie_d}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/eie_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/tie_d}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/tie_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/sie_d}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/sie_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/cie_d}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/cie_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/seip_d}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/seip_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/stip_d}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/stip_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/ssip_d}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/ssip_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/scip_d}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/scip_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/priv_lvl_d}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/priv_lvl_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/satp_d}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/satp_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/dcsr_d}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/dcsr_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/dpc_d}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/dpc_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/dscratch_d}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/dscratch_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/debug_d}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/debug_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/fcsr_d}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/fcsr_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/cycle_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/instret_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/retired_instr_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/retired_load_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/retired_i_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/retired_acc_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/mseg_q}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/mseg_d}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/acc_register_rd}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/operands_ready}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/dst_ready}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/opa_ready}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/opb_ready}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/npc}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/shift_opa}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/shift_opa_reversed}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/shift_right_result}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/shift_left_result}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/shift_opa_ext}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/shift_right_result_ext}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/shift_left}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/shift_arithmetic}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/alu_opa}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/alu_opb}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/lsu_qdata}
add wave -noupdate -group {Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/i_snitch/alu_writeback}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/clk_i}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rst_i}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/trace_port_o}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/sequencer_tracer_port_o}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/hart_id_i}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_i}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_valid_i}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_ready_o}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_resp_o}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_resp_valid_o}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_resp_ready_i}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/data_req_o}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/data_rsp_i}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_rnd_mode_i}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_fmt_mode_i}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_status_o}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_raddr_o}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rdata_i}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rvalid_o}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rready_i}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rdone_o}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_waddr_o}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wdata_o}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wvalid_o}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wready_i}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wdone_o}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/streamctl_done_i}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/streamctl_valid_i}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/streamctl_ready_o}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/caq_pvalid_o}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/core_events_o}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_op}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_rnd_mode}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/src_fmt}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/dst_fmt}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/int_fmt}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/vectorial_op}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/set_dyn_rm}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_raddr}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_rdata}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_we}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_waddr}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_wdata}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_wvalid}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_wready}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_active_d}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_active_q}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_active_ena}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_tag_in}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_tag_out}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/use_fpu}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op_ready}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_qready}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_qvalid}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ld_result}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_rd}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_pvalid}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_pready}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/is_store}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/is_load}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/sb_d}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/sb_q}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rd_is_fp}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/csr_instr}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/use_shfl}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_wready}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_valid}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_result}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_rd}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/reg_mask}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/byte_mask}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_out_valid}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_out_ready}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_in_valid}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_in_ready}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op_select}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/result_select}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op_mode}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rs1}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rs2}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rs3}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rd}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ls_size}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/dst_ready}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_q}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_repd_q}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_valid}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_valid_q}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_ready}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_ready_q}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_result}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/is_rd_ssr}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/byte_msk}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rA}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rD}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/indx}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_qdata}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/nan_boxed_arga}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/issue_fpu}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/issue_core_to_fpu}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/issue_fpu_seq}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/clk_i}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/rst_ni}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/hart_id_i}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/operands_i}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/rnd_mode_i}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/op_i}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/op_mod_i}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/src_fmt_i}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/dst_fmt_i}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/int_fmt_i}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/vectorial_op_i}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/tag_i}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_valid_i}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_ready_o}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/result_o}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/status_o}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/tag_o}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_valid_o}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_ready_i}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_in_q}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_in}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_out_q}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_out}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_valid_q}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_ready_q}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_valid}
add wave -noupdate -group {FPU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_ready}
add wave -noupdate -group {LSU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_snitch_lsu/data_req_o}
add wave -noupdate -group {LSU Core 2} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[2]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_snitch_lsu/data_rsp_i}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/clk_i}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/rst_i}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/hart_id_i}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/irq_i}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/flush_i_valid_o}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/flush_i_ready_i}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/inst_addr_o}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/inst_cacheable_o}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/inst_data_i}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/inst_valid_o}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/inst_ready_i}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/acc_qreq_o}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/acc_qvalid_o}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/acc_qready_i}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/acc_prsp_i}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/acc_pvalid_i}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/acc_pready_o}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/data_req_o}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/data_rsp_i}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/ptw_valid_o}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/ptw_ready_i}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/ptw_va_o}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/ptw_ppn_o}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/ptw_pte_i}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/ptw_is_4mega_i}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/fpu_rnd_mode_o}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/fpu_fmt_mode_o}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/fpu_status_i}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/caq_pvalid_i}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/core_events_o}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/barrier_o}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/barrier_i}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/illegal_inst}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/illegal_csr}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/interrupt}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/ecall}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/ebreak}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/zero_lsb}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/meip}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/mtip}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/msip}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/mcip}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/seip}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/stip}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/ssip}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/scip}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/interrupts_enabled}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/any_interrupt_pending}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/pc_d}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/pc_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/wfi_d}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/wfi_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/consec_pc}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/iimm}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/uimm}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/jimm}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/bimm}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/simm}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/opa}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/opb}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/adder_result}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/alu_result}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/shuffle}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/rd}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/rs1}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/rs2}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/stall}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/lsu_stall}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/nonacc_stall}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/gpr_raddr}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/gpr_rdata}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/gpr_waddr}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/gpr_wdata}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/gpr_we}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/sb_d}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/sb_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/is_load}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/is_store}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/is_signed}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/is_fp_load}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/is_fp_store}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/ls_misaligned}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/ld_addr_misaligned}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/st_addr_misaligned}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/inst_addr_misaligned}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/caq_qvalid}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/caq_qready}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/caq_ena}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/itlb_valid}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/itlb_ready}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/itlb_va}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/itlb_page_fault}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/itlb_pa}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/dtlb_valid}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/dtlb_ready}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/dtlb_va}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/dtlb_page_fault}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/dtlb_pa}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/trans_ready}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/trans_active}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/itlb_trans_valid}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/dtlb_trans_valid}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/trans_active_exp}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/tlb_flush}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/ls_size}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/ls_amo}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/ld_result}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/lsu_qready}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/lsu_qvalid}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/lsu_tlb_qready}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/lsu_tlb_qvalid}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/lsu_pvalid}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/lsu_pready}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/lsu_empty}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/ls_paddr}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/lsu_rd}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/retire_load}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/retire_i}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/retire_acc}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/acc_stall}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/valid_instr}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/exception}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/alu_op}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/opa_select}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/opb_select}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/write_rd}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/uses_rd}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/next_pc}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/rd_select}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/rd_bypass}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/is_branch}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/csr_rvalue}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/csr_en}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/csr_dump}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/csr_stall_d}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/csr_stall_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/scratch_d}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/scratch_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/epc_d}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/epc_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/tvec_d}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/tvec_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/cause_d}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/cause_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/cause_irq_d}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/cause_irq_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/spp_d}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/spp_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/mpp_d}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/mpp_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/ie_d}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/ie_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/pie_d}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/pie_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/eie_d}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/eie_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/tie_d}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/tie_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/sie_d}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/sie_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/cie_d}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/cie_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/seip_d}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/seip_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/stip_d}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/stip_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/ssip_d}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/ssip_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/scip_d}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/scip_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/priv_lvl_d}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/priv_lvl_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/satp_d}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/satp_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/dcsr_d}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/dcsr_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/dpc_d}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/dpc_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/dscratch_d}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/dscratch_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/debug_d}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/debug_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/fcsr_d}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/fcsr_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/cycle_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/instret_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/retired_instr_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/retired_load_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/retired_i_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/retired_acc_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/mseg_q}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/mseg_d}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/acc_register_rd}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/operands_ready}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/dst_ready}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/opa_ready}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/opb_ready}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/npc}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/shift_opa}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/shift_opa_reversed}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/shift_right_result}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/shift_left_result}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/shift_opa_ext}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/shift_right_result_ext}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/shift_left}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/shift_arithmetic}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/alu_opa}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/alu_opb}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/lsu_qdata}
add wave -noupdate -group {Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/i_snitch/alu_writeback}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/clk_i}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rst_i}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/trace_port_o}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/sequencer_tracer_port_o}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/hart_id_i}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_i}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_valid_i}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_ready_o}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_resp_o}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_resp_valid_o}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_resp_ready_i}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/data_req_o}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/data_rsp_i}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_rnd_mode_i}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_fmt_mode_i}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_status_o}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_raddr_o}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rdata_i}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rvalid_o}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rready_i}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rdone_o}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_waddr_o}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wdata_o}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wvalid_o}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wready_i}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wdone_o}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/streamctl_done_i}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/streamctl_valid_i}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/streamctl_ready_o}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/caq_pvalid_o}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/core_events_o}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_op}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_rnd_mode}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/src_fmt}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/dst_fmt}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/int_fmt}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/vectorial_op}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/set_dyn_rm}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_raddr}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_rdata}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_we}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_waddr}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_wdata}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_wvalid}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_wready}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_active_d}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_active_q}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_active_ena}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_tag_in}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_tag_out}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/use_fpu}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op_ready}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_qready}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_qvalid}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ld_result}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_rd}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_pvalid}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_pready}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/is_store}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/is_load}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/sb_d}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/sb_q}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rd_is_fp}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/csr_instr}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/use_shfl}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_wready}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_valid}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_result}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_rd}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/reg_mask}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/byte_mask}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_out_valid}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_out_ready}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_in_valid}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_in_ready}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op_select}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/result_select}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op_mode}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rs1}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rs2}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rs3}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rd}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ls_size}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/dst_ready}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_q}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_repd_q}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_valid}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_valid_q}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_ready}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_ready_q}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_result}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/is_rd_ssr}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/byte_msk}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rA}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rD}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/indx}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_qdata}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/nan_boxed_arga}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/issue_fpu}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/issue_core_to_fpu}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/issue_fpu_seq}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/clk_i}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/rst_ni}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/hart_id_i}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/operands_i}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/rnd_mode_i}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/op_i}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/op_mod_i}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/src_fmt_i}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/dst_fmt_i}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/int_fmt_i}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/vectorial_op_i}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/tag_i}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_valid_i}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_ready_o}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/result_o}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/status_o}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/tag_o}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_valid_o}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_ready_i}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_in_q}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_in}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_out_q}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_out}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_valid_q}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_ready_q}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_valid}
add wave -noupdate -group {FPU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_ready}
add wave -noupdate -group {LSU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_snitch_lsu/data_req_o}
add wave -noupdate -group {LSU Core 3} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[3]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_snitch_lsu/data_rsp_i}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/clk_i}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/rst_i}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/hart_id_i}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/irq_i}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/flush_i_valid_o}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/flush_i_ready_i}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/inst_addr_o}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/inst_cacheable_o}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/inst_data_i}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/inst_valid_o}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/inst_ready_i}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/acc_qreq_o}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/acc_qvalid_o}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/acc_qready_i}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/acc_prsp_i}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/acc_pvalid_i}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/acc_pready_o}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/data_req_o}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/data_rsp_i}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/ptw_valid_o}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/ptw_ready_i}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/ptw_va_o}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/ptw_ppn_o}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/ptw_pte_i}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/ptw_is_4mega_i}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/fpu_rnd_mode_o}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/fpu_fmt_mode_o}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/fpu_status_i}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/caq_pvalid_i}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/core_events_o}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/barrier_o}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/barrier_i}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/illegal_inst}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/illegal_csr}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/interrupt}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/ecall}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/ebreak}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/zero_lsb}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/meip}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/mtip}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/msip}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/mcip}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/seip}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/stip}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/ssip}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/scip}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/interrupts_enabled}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/any_interrupt_pending}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/pc_d}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/pc_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/wfi_d}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/wfi_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/consec_pc}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/iimm}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/uimm}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/jimm}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/bimm}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/simm}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/opa}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/opb}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/adder_result}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/alu_result}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/shuffle}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/rd}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/rs1}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/rs2}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/stall}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/lsu_stall}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/nonacc_stall}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/gpr_raddr}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/gpr_rdata}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/gpr_waddr}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/gpr_wdata}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/gpr_we}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/sb_d}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/sb_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/is_load}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/is_store}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/is_signed}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/is_fp_load}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/is_fp_store}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/ls_misaligned}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/ld_addr_misaligned}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/st_addr_misaligned}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/inst_addr_misaligned}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/caq_qvalid}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/caq_qready}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/caq_ena}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/itlb_valid}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/itlb_ready}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/itlb_va}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/itlb_page_fault}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/itlb_pa}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/dtlb_valid}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/dtlb_ready}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/dtlb_va}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/dtlb_page_fault}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/dtlb_pa}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/trans_ready}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/trans_active}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/itlb_trans_valid}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/dtlb_trans_valid}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/trans_active_exp}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/tlb_flush}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/ls_size}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/ls_amo}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/ld_result}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/lsu_qready}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/lsu_qvalid}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/lsu_tlb_qready}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/lsu_tlb_qvalid}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/lsu_pvalid}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/lsu_pready}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/lsu_empty}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/ls_paddr}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/lsu_rd}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/retire_load}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/retire_i}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/retire_acc}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/acc_stall}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/valid_instr}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/exception}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/alu_op}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/opa_select}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/opb_select}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/write_rd}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/uses_rd}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/next_pc}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/rd_select}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/rd_bypass}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/is_branch}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/csr_rvalue}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/csr_en}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/csr_dump}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/csr_stall_d}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/csr_stall_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/scratch_d}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/scratch_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/epc_d}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/epc_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/tvec_d}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/tvec_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/cause_d}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/cause_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/cause_irq_d}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/cause_irq_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/spp_d}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/spp_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/mpp_d}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/mpp_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/ie_d}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/ie_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/pie_d}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/pie_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/eie_d}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/eie_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/tie_d}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/tie_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/sie_d}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/sie_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/cie_d}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/cie_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/seip_d}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/seip_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/stip_d}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/stip_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/ssip_d}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/ssip_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/scip_d}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/scip_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/priv_lvl_d}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/priv_lvl_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/satp_d}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/satp_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/dcsr_d}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/dcsr_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/dpc_d}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/dpc_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/dscratch_d}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/dscratch_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/debug_d}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/debug_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/fcsr_d}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/fcsr_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/cycle_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/instret_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/retired_instr_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/retired_load_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/retired_i_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/retired_acc_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/mseg_q}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/mseg_d}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/acc_register_rd}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/operands_ready}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/dst_ready}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/opa_ready}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/opb_ready}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/npc}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/shift_opa}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/shift_opa_reversed}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/shift_right_result}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/shift_left_result}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/shift_opa_ext}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/shift_right_result_ext}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/shift_left}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/shift_arithmetic}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/alu_opa}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/alu_opb}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/lsu_qdata}
add wave -noupdate -group {Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/i_snitch/alu_writeback}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/clk_i}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rst_i}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/trace_port_o}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/sequencer_tracer_port_o}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/hart_id_i}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_i}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_valid_i}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_ready_o}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_resp_o}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_resp_valid_o}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_resp_ready_i}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/data_req_o}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/data_rsp_i}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_rnd_mode_i}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_fmt_mode_i}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_status_o}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_raddr_o}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rdata_i}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rvalid_o}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rready_i}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rdone_o}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_waddr_o}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wdata_o}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wvalid_o}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wready_i}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wdone_o}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/streamctl_done_i}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/streamctl_valid_i}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/streamctl_ready_o}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/caq_pvalid_o}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/core_events_o}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_op}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_rnd_mode}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/src_fmt}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/dst_fmt}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/int_fmt}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/vectorial_op}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/set_dyn_rm}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_raddr}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_rdata}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_we}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_waddr}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_wdata}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_wvalid}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_wready}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_active_d}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_active_q}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_active_ena}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_tag_in}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_tag_out}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/use_fpu}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op_ready}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_qready}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_qvalid}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ld_result}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_rd}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_pvalid}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_pready}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/is_store}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/is_load}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/sb_d}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/sb_q}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rd_is_fp}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/csr_instr}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/use_shfl}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_wready}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_valid}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_result}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_rd}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/reg_mask}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/byte_mask}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_out_valid}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_out_ready}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_in_valid}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_in_ready}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op_select}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/result_select}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op_mode}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rs1}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rs2}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rs3}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rd}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ls_size}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/dst_ready}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_q}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_repd_q}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_valid}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_valid_q}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_ready}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_ready_q}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_result}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/is_rd_ssr}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/byte_msk}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rA}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rD}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/indx}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_qdata}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/nan_boxed_arga}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/issue_fpu}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/issue_core_to_fpu}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/issue_fpu_seq}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/clk_i}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/rst_ni}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/hart_id_i}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/operands_i}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/rnd_mode_i}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/op_i}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/op_mod_i}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/src_fmt_i}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/dst_fmt_i}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/int_fmt_i}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/vectorial_op_i}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/tag_i}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_valid_i}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_ready_o}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/result_o}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/status_o}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/tag_o}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_valid_o}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_ready_i}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_in_q}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_in}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_out_q}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_out}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_valid_q}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_ready_q}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_valid}
add wave -noupdate -group {FPU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_ready}
add wave -noupdate -group {LSU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_snitch_lsu/data_req_o}
add wave -noupdate -group {LSU Core 4} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[4]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_snitch_lsu/data_rsp_i}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/clk_i}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/rst_i}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/hart_id_i}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/irq_i}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/flush_i_valid_o}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/flush_i_ready_i}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/inst_addr_o}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/inst_cacheable_o}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/inst_data_i}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/inst_valid_o}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/inst_ready_i}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/acc_qreq_o}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/acc_qvalid_o}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/acc_qready_i}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/acc_prsp_i}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/acc_pvalid_i}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/acc_pready_o}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/data_req_o}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/data_rsp_i}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/ptw_valid_o}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/ptw_ready_i}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/ptw_va_o}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/ptw_ppn_o}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/ptw_pte_i}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/ptw_is_4mega_i}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/fpu_rnd_mode_o}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/fpu_fmt_mode_o}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/fpu_status_i}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/caq_pvalid_i}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/core_events_o}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/barrier_o}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/barrier_i}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/illegal_inst}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/illegal_csr}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/interrupt}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/ecall}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/ebreak}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/zero_lsb}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/meip}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/mtip}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/msip}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/mcip}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/seip}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/stip}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/ssip}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/scip}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/interrupts_enabled}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/any_interrupt_pending}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/pc_d}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/pc_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/wfi_d}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/wfi_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/consec_pc}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/iimm}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/uimm}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/jimm}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/bimm}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/simm}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/opa}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/opb}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/adder_result}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/alu_result}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/shuffle}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/rd}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/rs1}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/rs2}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/stall}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/lsu_stall}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/nonacc_stall}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/gpr_raddr}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/gpr_rdata}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/gpr_waddr}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/gpr_wdata}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/gpr_we}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/sb_d}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/sb_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/is_load}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/is_store}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/is_signed}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/is_fp_load}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/is_fp_store}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/ls_misaligned}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/ld_addr_misaligned}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/st_addr_misaligned}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/inst_addr_misaligned}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/caq_qvalid}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/caq_qready}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/caq_ena}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/itlb_valid}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/itlb_ready}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/itlb_va}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/itlb_page_fault}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/itlb_pa}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/dtlb_valid}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/dtlb_ready}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/dtlb_va}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/dtlb_page_fault}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/dtlb_pa}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/trans_ready}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/trans_active}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/itlb_trans_valid}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/dtlb_trans_valid}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/trans_active_exp}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/tlb_flush}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/ls_size}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/ls_amo}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/ld_result}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/lsu_qready}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/lsu_qvalid}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/lsu_tlb_qready}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/lsu_tlb_qvalid}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/lsu_pvalid}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/lsu_pready}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/lsu_empty}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/ls_paddr}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/lsu_rd}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/retire_load}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/retire_i}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/retire_acc}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/acc_stall}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/valid_instr}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/exception}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/alu_op}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/opa_select}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/opb_select}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/write_rd}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/uses_rd}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/next_pc}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/rd_select}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/rd_bypass}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/is_branch}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/csr_rvalue}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/csr_en}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/csr_dump}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/csr_stall_d}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/csr_stall_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/scratch_d}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/scratch_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/epc_d}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/epc_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/tvec_d}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/tvec_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/cause_d}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/cause_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/cause_irq_d}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/cause_irq_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/spp_d}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/spp_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/mpp_d}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/mpp_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/ie_d}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/ie_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/pie_d}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/pie_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/eie_d}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/eie_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/tie_d}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/tie_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/sie_d}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/sie_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/cie_d}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/cie_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/seip_d}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/seip_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/stip_d}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/stip_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/ssip_d}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/ssip_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/scip_d}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/scip_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/priv_lvl_d}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/priv_lvl_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/satp_d}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/satp_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/dcsr_d}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/dcsr_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/dpc_d}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/dpc_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/dscratch_d}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/dscratch_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/debug_d}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/debug_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/fcsr_d}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/fcsr_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/cycle_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/instret_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/retired_instr_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/retired_load_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/retired_i_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/retired_acc_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/mseg_q}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/mseg_d}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/acc_register_rd}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/operands_ready}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/dst_ready}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/opa_ready}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/opb_ready}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/npc}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/shift_opa}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/shift_opa_reversed}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/shift_right_result}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/shift_left_result}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/shift_opa_ext}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/shift_right_result_ext}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/shift_left}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/shift_arithmetic}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/alu_opa}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/alu_opb}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/lsu_qdata}
add wave -noupdate -group {Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/i_snitch/alu_writeback}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/clk_i}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rst_i}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/trace_port_o}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/sequencer_tracer_port_o}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/hart_id_i}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_i}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_valid_i}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_ready_o}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_resp_o}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_resp_valid_o}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_resp_ready_i}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/data_req_o}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/data_rsp_i}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_rnd_mode_i}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_fmt_mode_i}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_status_o}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_raddr_o}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rdata_i}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rvalid_o}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rready_i}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rdone_o}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_waddr_o}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wdata_o}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wvalid_o}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wready_i}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wdone_o}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/streamctl_done_i}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/streamctl_valid_i}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/streamctl_ready_o}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/caq_pvalid_o}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/core_events_o}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_op}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_rnd_mode}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/src_fmt}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/dst_fmt}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/int_fmt}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/vectorial_op}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/set_dyn_rm}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_raddr}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_rdata}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_we}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_waddr}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_wdata}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_wvalid}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_wready}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_active_d}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_active_q}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_active_ena}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_tag_in}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_tag_out}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/use_fpu}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op_ready}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_qready}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_qvalid}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ld_result}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_rd}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_pvalid}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_pready}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/is_store}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/is_load}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/sb_d}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/sb_q}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rd_is_fp}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/csr_instr}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/use_shfl}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_wready}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_valid}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_result}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_rd}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/reg_mask}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/byte_mask}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_out_valid}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_out_ready}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_in_valid}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_in_ready}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op_select}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/result_select}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op_mode}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rs1}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rs2}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rs3}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rd}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ls_size}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/dst_ready}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_q}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_repd_q}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_valid}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_valid_q}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_ready}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_ready_q}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_result}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/is_rd_ssr}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/byte_msk}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rA}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rD}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/indx}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_qdata}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/nan_boxed_arga}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/issue_fpu}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/issue_core_to_fpu}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/issue_fpu_seq}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/clk_i}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/rst_ni}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/hart_id_i}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/operands_i}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/rnd_mode_i}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/op_i}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/op_mod_i}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/src_fmt_i}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/dst_fmt_i}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/int_fmt_i}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/vectorial_op_i}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/tag_i}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_valid_i}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_ready_o}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/result_o}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/status_o}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/tag_o}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_valid_o}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_ready_i}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_in_q}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_in}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_out_q}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_out}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_valid_q}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_ready_q}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_valid}
add wave -noupdate -group {FPU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_ready}
add wave -noupdate -group {LSU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_snitch_lsu/data_req_o}
add wave -noupdate -group {LSU Core 5} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[5]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_snitch_lsu/data_rsp_i}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/clk_i}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/rst_i}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/hart_id_i}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/irq_i}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/flush_i_valid_o}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/flush_i_ready_i}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/inst_addr_o}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/inst_cacheable_o}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/inst_data_i}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/inst_valid_o}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/inst_ready_i}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/acc_qreq_o}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/acc_qvalid_o}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/acc_qready_i}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/acc_prsp_i}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/acc_pvalid_i}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/acc_pready_o}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/data_req_o}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/data_rsp_i}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/ptw_valid_o}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/ptw_ready_i}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/ptw_va_o}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/ptw_ppn_o}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/ptw_pte_i}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/ptw_is_4mega_i}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/fpu_rnd_mode_o}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/fpu_fmt_mode_o}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/fpu_status_i}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/caq_pvalid_i}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/core_events_o}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/barrier_o}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/barrier_i}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/illegal_inst}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/illegal_csr}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/interrupt}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/ecall}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/ebreak}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/zero_lsb}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/meip}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/mtip}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/msip}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/mcip}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/seip}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/stip}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/ssip}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/scip}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/interrupts_enabled}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/any_interrupt_pending}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/pc_d}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/pc_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/wfi_d}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/wfi_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/consec_pc}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/iimm}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/uimm}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/jimm}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/bimm}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/simm}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/opa}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/opb}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/adder_result}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/alu_result}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/shuffle}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/rd}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/rs1}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/rs2}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/stall}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/lsu_stall}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/nonacc_stall}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/gpr_raddr}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/gpr_rdata}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/gpr_waddr}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/gpr_wdata}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/gpr_we}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/sb_d}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/sb_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/is_load}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/is_store}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/is_signed}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/is_fp_load}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/is_fp_store}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/ls_misaligned}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/ld_addr_misaligned}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/st_addr_misaligned}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/inst_addr_misaligned}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/caq_qvalid}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/caq_qready}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/caq_ena}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/itlb_valid}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/itlb_ready}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/itlb_va}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/itlb_page_fault}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/itlb_pa}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/dtlb_valid}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/dtlb_ready}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/dtlb_va}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/dtlb_page_fault}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/dtlb_pa}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/trans_ready}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/trans_active}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/itlb_trans_valid}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/dtlb_trans_valid}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/trans_active_exp}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/tlb_flush}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/ls_size}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/ls_amo}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/ld_result}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/lsu_qready}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/lsu_qvalid}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/lsu_tlb_qready}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/lsu_tlb_qvalid}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/lsu_pvalid}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/lsu_pready}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/lsu_empty}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/ls_paddr}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/lsu_rd}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/retire_load}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/retire_i}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/retire_acc}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/acc_stall}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/valid_instr}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/exception}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/alu_op}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/opa_select}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/opb_select}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/write_rd}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/uses_rd}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/next_pc}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/rd_select}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/rd_bypass}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/is_branch}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/csr_rvalue}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/csr_en}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/csr_dump}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/csr_stall_d}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/csr_stall_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/scratch_d}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/scratch_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/epc_d}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/epc_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/tvec_d}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/tvec_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/cause_d}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/cause_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/cause_irq_d}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/cause_irq_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/spp_d}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/spp_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/mpp_d}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/mpp_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/ie_d}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/ie_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/pie_d}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/pie_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/eie_d}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/eie_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/tie_d}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/tie_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/sie_d}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/sie_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/cie_d}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/cie_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/seip_d}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/seip_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/stip_d}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/stip_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/ssip_d}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/ssip_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/scip_d}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/scip_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/priv_lvl_d}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/priv_lvl_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/satp_d}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/satp_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/dcsr_d}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/dcsr_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/dpc_d}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/dpc_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/dscratch_d}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/dscratch_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/debug_d}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/debug_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/fcsr_d}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/fcsr_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/cycle_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/instret_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/retired_instr_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/retired_load_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/retired_i_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/retired_acc_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/mseg_q}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/mseg_d}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/acc_register_rd}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/operands_ready}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/dst_ready}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/opa_ready}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/opb_ready}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/npc}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/shift_opa}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/shift_opa_reversed}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/shift_right_result}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/shift_left_result}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/shift_opa_ext}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/shift_right_result_ext}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/shift_left}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/shift_arithmetic}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/alu_opa}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/alu_opb}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/lsu_qdata}
add wave -noupdate -group {Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/i_snitch/alu_writeback}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/clk_i}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rst_i}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/trace_port_o}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/sequencer_tracer_port_o}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/hart_id_i}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_i}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_valid_i}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_ready_o}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_resp_o}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_resp_valid_o}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_resp_ready_i}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/data_req_o}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/data_rsp_i}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_rnd_mode_i}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_fmt_mode_i}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_status_o}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_raddr_o}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rdata_i}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rvalid_o}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rready_i}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rdone_o}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_waddr_o}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wdata_o}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wvalid_o}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wready_i}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wdone_o}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/streamctl_done_i}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/streamctl_valid_i}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/streamctl_ready_o}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/caq_pvalid_o}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/core_events_o}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_op}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_rnd_mode}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/src_fmt}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/dst_fmt}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/int_fmt}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/vectorial_op}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/set_dyn_rm}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_raddr}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_rdata}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_we}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_waddr}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_wdata}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_wvalid}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_wready}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_active_d}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_active_q}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_active_ena}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_tag_in}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_tag_out}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/use_fpu}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op_ready}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_qready}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_qvalid}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ld_result}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_rd}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_pvalid}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_pready}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/is_store}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/is_load}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/sb_d}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/sb_q}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rd_is_fp}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/csr_instr}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/use_shfl}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_wready}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_valid}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_result}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_rd}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/reg_mask}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/byte_mask}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_out_valid}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_out_ready}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_in_valid}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_in_ready}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op_select}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/result_select}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op_mode}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rs1}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rs2}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rs3}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rd}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ls_size}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/dst_ready}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_q}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_repd_q}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_valid}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_valid_q}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_ready}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_ready_q}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_result}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/is_rd_ssr}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/byte_msk}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rA}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rD}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/indx}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_qdata}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/nan_boxed_arga}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/issue_fpu}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/issue_core_to_fpu}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/issue_fpu_seq}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/clk_i}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/rst_ni}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/hart_id_i}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/operands_i}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/rnd_mode_i}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/op_i}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/op_mod_i}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/src_fmt_i}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/dst_fmt_i}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/int_fmt_i}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/vectorial_op_i}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/tag_i}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_valid_i}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_ready_o}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/result_o}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/status_o}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/tag_o}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_valid_o}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_ready_i}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_in_q}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_in}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_out_q}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_out}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_valid_q}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_ready_q}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_valid}
add wave -noupdate -group {FPU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_ready}
add wave -noupdate -group {LSU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_snitch_lsu/data_req_o}
add wave -noupdate -group {LSU Core 6} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[6]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_snitch_lsu/data_rsp_i}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/clk_i}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/rst_i}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/hart_id_i}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/irq_i}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/flush_i_valid_o}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/flush_i_ready_i}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/inst_addr_o}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/inst_cacheable_o}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/inst_data_i}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/inst_valid_o}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/inst_ready_i}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/acc_qreq_o}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/acc_qvalid_o}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/acc_qready_i}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/acc_prsp_i}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/acc_pvalid_i}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/acc_pready_o}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/data_req_o}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/data_rsp_i}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/ptw_valid_o}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/ptw_ready_i}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/ptw_va_o}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/ptw_ppn_o}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/ptw_pte_i}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/ptw_is_4mega_i}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/fpu_rnd_mode_o}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/fpu_fmt_mode_o}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/fpu_status_i}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/caq_pvalid_i}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/core_events_o}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/barrier_o}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/barrier_i}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/illegal_inst}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/illegal_csr}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/interrupt}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/ecall}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/ebreak}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/zero_lsb}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/meip}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/mtip}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/msip}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/mcip}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/seip}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/stip}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/ssip}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/scip}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/interrupts_enabled}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/any_interrupt_pending}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/pc_d}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/pc_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/wfi_d}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/wfi_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/consec_pc}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/iimm}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/uimm}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/jimm}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/bimm}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/simm}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/opa}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/opb}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/adder_result}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/alu_result}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/shuffle}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/rd}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/rs1}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/rs2}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/stall}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/lsu_stall}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/nonacc_stall}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/gpr_raddr}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/gpr_rdata}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/gpr_waddr}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/gpr_wdata}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/gpr_we}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/sb_d}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/sb_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/is_load}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/is_store}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/is_signed}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/is_fp_load}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/is_fp_store}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/ls_misaligned}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/ld_addr_misaligned}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/st_addr_misaligned}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/inst_addr_misaligned}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/caq_qvalid}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/caq_qready}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/caq_ena}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/itlb_valid}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/itlb_ready}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/itlb_va}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/itlb_page_fault}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/itlb_pa}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/dtlb_valid}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/dtlb_ready}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/dtlb_va}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/dtlb_page_fault}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/dtlb_pa}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/trans_ready}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/trans_active}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/itlb_trans_valid}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/dtlb_trans_valid}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/trans_active_exp}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/tlb_flush}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/ls_size}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/ls_amo}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/ld_result}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/lsu_qready}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/lsu_qvalid}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/lsu_tlb_qready}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/lsu_tlb_qvalid}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/lsu_pvalid}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/lsu_pready}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/lsu_empty}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/ls_paddr}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/lsu_rd}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/retire_load}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/retire_i}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/retire_acc}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/acc_stall}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/valid_instr}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/exception}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/alu_op}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/opa_select}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/opb_select}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/write_rd}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/uses_rd}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/next_pc}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/rd_select}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/rd_bypass}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/is_branch}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/csr_rvalue}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/csr_en}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/csr_dump}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/csr_stall_d}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/csr_stall_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/scratch_d}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/scratch_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/epc_d}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/epc_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/tvec_d}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/tvec_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/cause_d}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/cause_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/cause_irq_d}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/cause_irq_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/spp_d}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/spp_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/mpp_d}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/mpp_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/ie_d}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/ie_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/pie_d}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/pie_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/eie_d}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/eie_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/tie_d}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/tie_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/sie_d}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/sie_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/cie_d}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/cie_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/seip_d}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/seip_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/stip_d}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/stip_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/ssip_d}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/ssip_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/scip_d}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/scip_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/priv_lvl_d}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/priv_lvl_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/satp_d}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/satp_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/dcsr_d}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/dcsr_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/dpc_d}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/dpc_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/dscratch_d}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/dscratch_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/debug_d}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/debug_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/fcsr_d}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/fcsr_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/cycle_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/instret_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/retired_instr_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/retired_load_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/retired_i_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/retired_acc_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/mseg_q}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/mseg_d}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/acc_register_rd}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/operands_ready}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/dst_ready}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/opa_ready}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/opb_ready}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/npc}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/shift_opa}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/shift_opa_reversed}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/shift_right_result}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/shift_left_result}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/shift_opa_ext}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/shift_right_result_ext}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/shift_left}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/shift_arithmetic}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/alu_opa}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/alu_opb}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/lsu_qdata}
add wave -noupdate -group {Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/i_snitch/alu_writeback}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/clk_i}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rst_i}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/trace_port_o}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/sequencer_tracer_port_o}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/hart_id_i}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_i}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_valid_i}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_ready_o}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_resp_o}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_resp_valid_o}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_resp_ready_i}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/data_req_o}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/data_rsp_i}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_rnd_mode_i}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_fmt_mode_i}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_status_o}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_raddr_o}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rdata_i}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rvalid_o}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rready_i}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rdone_o}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_waddr_o}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wdata_o}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wvalid_o}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wready_i}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wdone_o}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/streamctl_done_i}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/streamctl_valid_i}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/streamctl_ready_o}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/caq_pvalid_o}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/core_events_o}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_op}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_rnd_mode}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/src_fmt}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/dst_fmt}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/int_fmt}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/vectorial_op}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/set_dyn_rm}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_raddr}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_rdata}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_we}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_waddr}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_wdata}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_wvalid}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_wready}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_active_d}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_active_q}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_active_ena}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_tag_in}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_tag_out}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/use_fpu}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op_ready}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_qready}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_qvalid}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ld_result}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_rd}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_pvalid}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_pready}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/is_store}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/is_load}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/sb_d}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/sb_q}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rd_is_fp}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/csr_instr}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/use_shfl}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_wready}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_valid}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_result}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_rd}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/reg_mask}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/byte_mask}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_out_valid}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_out_ready}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_in_valid}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_in_ready}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op_select}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/result_select}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op_mode}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rs1}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rs2}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rs3}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rd}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ls_size}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/dst_ready}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_q}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_repd_q}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_valid}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_valid_q}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_ready}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_ready_q}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_result}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/is_rd_ssr}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/byte_msk}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rA}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rD}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/indx}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_qdata}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/nan_boxed_arga}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/issue_fpu}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/issue_core_to_fpu}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/issue_fpu_seq}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/clk_i}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/rst_ni}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/hart_id_i}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/operands_i}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/rnd_mode_i}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/op_i}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/op_mod_i}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/src_fmt_i}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/dst_fmt_i}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/int_fmt_i}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/vectorial_op_i}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/tag_i}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_valid_i}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_ready_o}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/result_o}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/status_o}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/tag_o}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_valid_o}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_ready_i}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_in_q}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_in}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_out_q}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_out}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_valid_q}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_ready_q}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_valid}
add wave -noupdate -group {FPU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_ready}
add wave -noupdate -group {LSU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_snitch_lsu/data_req_o}
add wave -noupdate -group {LSU Core 7} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[7]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_snitch_lsu/data_rsp_i}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/clk_i}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/rst_i}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/hart_id_i}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/irq_i}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/flush_i_valid_o}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/flush_i_ready_i}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/inst_addr_o}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/inst_cacheable_o}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/inst_data_i}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/inst_valid_o}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/inst_ready_i}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/acc_qreq_o}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/acc_qvalid_o}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/acc_qready_i}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/acc_prsp_i}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/acc_pvalid_i}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/acc_pready_o}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/data_req_o}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/data_rsp_i}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/ptw_valid_o}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/ptw_ready_i}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/ptw_va_o}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/ptw_ppn_o}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/ptw_pte_i}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/ptw_is_4mega_i}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/fpu_rnd_mode_o}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/fpu_fmt_mode_o}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/fpu_status_i}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/caq_pvalid_i}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/core_events_o}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/barrier_o}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/barrier_i}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/illegal_inst}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/illegal_csr}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/interrupt}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/ecall}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/ebreak}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/zero_lsb}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/meip}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/mtip}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/msip}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/mcip}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/seip}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/stip}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/ssip}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/scip}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/interrupts_enabled}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/any_interrupt_pending}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/pc_d}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/pc_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/wfi_d}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/wfi_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/consec_pc}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/iimm}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/uimm}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/jimm}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/bimm}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/simm}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/opa}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/opb}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/adder_result}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/alu_result}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/shuffle}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/rd}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/rs1}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/rs2}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/stall}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/lsu_stall}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/nonacc_stall}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/gpr_raddr}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/gpr_rdata}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/gpr_waddr}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/gpr_wdata}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/gpr_we}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/sb_d}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/sb_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/is_load}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/is_store}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/is_signed}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/is_fp_load}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/is_fp_store}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/ls_misaligned}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/ld_addr_misaligned}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/st_addr_misaligned}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/inst_addr_misaligned}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/caq_qvalid}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/caq_qready}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/caq_ena}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/itlb_valid}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/itlb_ready}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/itlb_va}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/itlb_page_fault}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/itlb_pa}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/dtlb_valid}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/dtlb_ready}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/dtlb_va}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/dtlb_page_fault}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/dtlb_pa}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/trans_ready}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/trans_active}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/itlb_trans_valid}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/dtlb_trans_valid}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/trans_active_exp}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/tlb_flush}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/ls_size}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/ls_amo}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/ld_result}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/lsu_qready}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/lsu_qvalid}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/lsu_tlb_qready}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/lsu_tlb_qvalid}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/lsu_pvalid}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/lsu_pready}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/lsu_empty}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/ls_paddr}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/lsu_rd}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/retire_load}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/retire_i}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/retire_acc}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/acc_stall}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/valid_instr}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/exception}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/alu_op}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/opa_select}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/opb_select}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/write_rd}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/uses_rd}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/next_pc}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/rd_select}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/rd_bypass}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/is_branch}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/csr_rvalue}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/csr_en}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/csr_dump}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/csr_stall_d}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/csr_stall_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/scratch_d}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/scratch_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/epc_d}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/epc_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/tvec_d}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/tvec_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/cause_d}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/cause_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/cause_irq_d}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/cause_irq_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/spp_d}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/spp_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/mpp_d}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/mpp_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/ie_d}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/ie_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/pie_d}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/pie_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/eie_d}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/eie_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/tie_d}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/tie_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/sie_d}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/sie_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/cie_d}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/cie_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/seip_d}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/seip_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/stip_d}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/stip_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/ssip_d}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/ssip_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/scip_d}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/scip_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/priv_lvl_d}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/priv_lvl_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/satp_d}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/satp_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/dcsr_d}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/dcsr_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/dpc_d}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/dpc_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/dscratch_d}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/dscratch_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/debug_d}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/debug_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/fcsr_d}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/fcsr_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/cycle_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/instret_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/retired_instr_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/retired_load_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/retired_i_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/retired_acc_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/mseg_q}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/mseg_d}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/acc_register_rd}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/operands_ready}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/dst_ready}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/opa_ready}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/opb_ready}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/npc}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/shift_opa}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/shift_opa_reversed}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/shift_right_result}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/shift_left_result}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/shift_opa_ext}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/shift_right_result_ext}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/shift_left}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/shift_arithmetic}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/alu_opa}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/alu_opb}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/lsu_qdata}
add wave -noupdate -group {Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/i_snitch/alu_writeback}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/clk_i}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rst_i}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/trace_port_o}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/sequencer_tracer_port_o}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/hart_id_i}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_i}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_valid_i}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_ready_o}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_resp_o}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_resp_valid_o}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_resp_ready_i}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/data_req_o}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/data_rsp_i}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_rnd_mode_i}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_fmt_mode_i}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_status_o}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_raddr_o}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rdata_i}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rvalid_o}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rready_i}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_rdone_o}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_waddr_o}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wdata_o}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wvalid_o}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wready_i}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_wdone_o}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/streamctl_done_i}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/streamctl_valid_i}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/streamctl_ready_o}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/caq_pvalid_o}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/core_events_o}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_op}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_rnd_mode}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/src_fmt}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/dst_fmt}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/int_fmt}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/vectorial_op}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/set_dyn_rm}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_raddr}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_rdata}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_we}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_waddr}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_wdata}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_wvalid}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpr_wready}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_active_d}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_active_q}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ssr_active_ena}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_tag_in}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_tag_out}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/use_fpu}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op_ready}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_qready}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_qvalid}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ld_result}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_rd}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_pvalid}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/lsu_pready}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/is_store}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/is_load}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/sb_d}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/sb_q}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rd_is_fp}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/csr_instr}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/use_shfl}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_wready}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_valid}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_result}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/shfl_rd}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/reg_mask}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/byte_mask}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_out_valid}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_out_ready}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_in_valid}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_in_ready}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op_select}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/result_select}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/op_mode}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rs1}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rs2}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rs3}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rd}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/ls_size}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/dst_ready}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_q}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_repd_q}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_valid}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_valid_q}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_ready}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_req_ready_q}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/fpu_result}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/is_rd_ssr}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/byte_msk}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rA}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/rD}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/indx}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/acc_qdata}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/nan_boxed_arga}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/issue_fpu}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/issue_core_to_fpu}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/issue_fpu_seq}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/clk_i}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/rst_ni}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/hart_id_i}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/operands_i}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/rnd_mode_i}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/op_i}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/op_mod_i}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/src_fmt_i}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/dst_fmt_i}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/int_fmt_i}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/vectorial_op_i}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/tag_i}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_valid_i}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_ready_o}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/result_o}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/status_o}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/tag_o}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_valid_o}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_ready_i}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_in_q}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_in}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_out_q}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/fpu_out}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_valid_q}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/in_ready_q}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_valid}
add wave -noupdate -group {FPU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/out_ready}
add wave -noupdate -group {LSU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_snitch_lsu/data_req_o}
add wave -noupdate -group {LSU Core 8} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[8]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_snitch_lsu/data_rsp_i}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {998000 ps} 1} {{Cursor 2} {984000 ps} 1} {{Cursor 3} {999000 ps} 1} {{Cursor 4} {1000000 ps} 0}
quietly wave cursor active 3
configure wave -namecolwidth 151
configure wave -valuecolwidth 204
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {997747 ps} {1001430 ps}
