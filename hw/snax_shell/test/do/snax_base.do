onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider inputs
add wave -noupdate /tb_snax_shell/i_snitch_cc/clk_i
add wave -noupdate /tb_snax_shell/i_snitch_cc/clk_d2_i
add wave -noupdate /tb_snax_shell/i_snitch_cc/rst_ni
add wave -noupdate /tb_snax_shell/i_snitch_cc/rst_int_ss_ni
add wave -noupdate /tb_snax_shell/i_snitch_cc/rst_fp_ss_ni
add wave -noupdate /tb_snax_shell/i_snitch_cc/hart_id_i
add wave -noupdate /tb_snax_shell/i_snitch_cc/irq_i
add wave -noupdate -expand /tb_snax_shell/i_snitch_cc/hive_rsp_i
add wave -noupdate -expand -subitemconfig {/tb_snax_shell/i_snitch_cc/data_rsp_i.p -expand} /tb_snax_shell/i_snitch_cc/data_rsp_i
add wave -noupdate /tb_snax_shell/i_snitch_cc/tcdm_rsp_i
add wave -noupdate /tb_snax_shell/i_snitch_cc/axi_dma_res_i
add wave -noupdate /tb_snax_shell/i_snitch_cc/tcdm_addr_base_i
add wave -noupdate -divider outputs
add wave -noupdate -expand /tb_snax_shell/i_snitch_cc/hive_req_o
add wave -noupdate -expand -subitemconfig {/tb_snax_shell/i_snitch_cc/data_req_o.q -expand} /tb_snax_shell/i_snitch_cc/data_req_o
add wave -noupdate /tb_snax_shell/i_snitch_cc/tcdm_req_o
add wave -noupdate /tb_snax_shell/i_snitch_cc/axi_dma_req_o
add wave -noupdate /tb_snax_shell/i_snitch_cc/axi_dma_busy_o
add wave -noupdate /tb_snax_shell/i_snitch_cc/axi_dma_perf_o
add wave -noupdate /tb_snax_shell/i_snitch_cc/axi_dma_events_o
add wave -noupdate /tb_snax_shell/i_snitch_cc/core_events_o
add wave -noupdate -divider snitch
add wave -noupdate /tb_snax_shell/data_mem
add wave -noupdate /tb_snax_shell/start_mem
add wave -noupdate -radix unsigned /tb_snax_shell/data_addr_offset
add wave -noupdate /tb_snax_shell/next_data_mem
add wave -noupdate -expand -subitemconfig {/tb_snax_shell/i_snitch_cc/i_snitch/data_req_o.q {-height 16 -childformat {{addr -radix unsigned}} -expand} /tb_snax_shell/i_snitch_cc/i_snitch/data_req_o.q.addr {-radix unsigned}} /tb_snax_shell/i_snitch_cc/i_snitch/data_req_o
add wave -noupdate -expand -subitemconfig {/tb_snax_shell/i_snitch_cc/i_snitch/data_rsp_i.p -expand} /tb_snax_shell/i_snitch_cc/i_snitch/data_rsp_i
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/inst_addr_o
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/next_pc
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/pc_q
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/consec_pc
add wave -noupdate -divider exception
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/exception
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/illegal_inst
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/interrupt
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/ld_addr_misaligned
add wave -noupdate -divider snitch_rf
add wave -noupdate -childformat {{{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[31]} -radix unsigned} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[30]} -radix unsigned} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[29]} -radix unsigned} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[28]} -radix unsigned} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[27]} -radix unsigned} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[26]} -radix unsigned} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[25]} -radix unsigned} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[24]} -radix unsigned} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[23]} -radix unsigned} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[22]} -radix unsigned} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[21]} -radix unsigned} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[20]} -radix unsigned} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[19]} -radix unsigned} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[18]} -radix unsigned} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[17]} -radix unsigned} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[16]} -radix unsigned} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[15]} -radix unsigned} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[14]} -radix hexadecimal} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[13]} -radix hexadecimal} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[12]} -radix hexadecimal} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[11]} -radix hexadecimal} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[10]} -radix hexadecimal} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[9]} -radix hexadecimal} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[8]} -radix hexadecimal} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[7]} -radix hexadecimal} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[6]} -radix hexadecimal} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[5]} -radix hexadecimal} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[4]} -radix hexadecimal} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[3]} -radix hexadecimal} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[2]} -radix hexadecimal} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[1]} -radix hexadecimal} {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[0]} -radix unsigned}} -expand -subitemconfig {{/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[31]} {-height 16 -radix unsigned} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[30]} {-height 16 -radix unsigned} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[29]} {-height 16 -radix unsigned} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[28]} {-height 16 -radix unsigned} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[27]} {-height 16 -radix unsigned} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[26]} {-height 16 -radix unsigned} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[25]} {-height 16 -radix unsigned} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[24]} {-height 16 -radix unsigned} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[23]} {-height 16 -radix unsigned} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[22]} {-height 16 -radix unsigned} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[21]} {-height 16 -radix unsigned} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[20]} {-height 16 -radix unsigned} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[19]} {-height 16 -radix unsigned} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[18]} {-height 16 -radix unsigned} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[17]} {-height 16 -radix unsigned} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[16]} {-height 16 -radix unsigned} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[15]} {-height 16 -radix unsigned} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[14]} {-height 16 -radix hexadecimal} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[13]} {-height 16 -radix hexadecimal} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[12]} {-height 16 -radix hexadecimal} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[11]} {-height 16 -radix hexadecimal} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[10]} {-height 16 -radix hexadecimal} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[9]} {-height 16 -radix hexadecimal} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[8]} {-height 16 -radix hexadecimal} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[7]} {-height 16 -radix hexadecimal} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[6]} {-height 16 -radix hexadecimal} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[5]} {-height 16 -radix hexadecimal} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[4]} {-height 16 -radix hexadecimal} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[3]} {-height 16 -radix hexadecimal} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[2]} {-height 16 -radix hexadecimal} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[1]} {-height 16 -radix hexadecimal} {/tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem[0]} {-height 16 -radix unsigned}} /tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_regfile/mem
add wave -noupdate -divider snitch_lsu
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_lsu/clk_i
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_lsu/rst_i
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_lsu/lsu_qtag_i
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_lsu/lsu_qwrite_i
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_lsu/lsu_qsigned_i
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_lsu/lsu_qaddr_i
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_lsu/lsu_qdata_i
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_lsu/lsu_qsize_i
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_lsu/lsu_qamo_i
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_lsu/lsu_qvalid_i
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_lsu/lsu_qready_o
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_lsu/lsu_pdata_o
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_lsu/lsu_ptag_o
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_lsu/lsu_perror_o
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_lsu/lsu_pvalid_o
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_lsu/lsu_pready_i
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_lsu/lsu_empty_o
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_lsu/data_req_o
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_lsu/data_rsp_i
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_lsu/mem_out
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/i_snitch_lsu/lsu_pvalid_o
add wave -noupdate -divider snitch_cc
add wave -noupdate /tb_snax_shell/i_snitch_cc/slave_select
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider others
add wave -noupdate /tb_snax_shell/start_mem
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/valid_instr
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/stall
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/lsu_stall
add wave -noupdate /tb_snax_shell/i_snitch_cc/i_snitch/acc_stall
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {263 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 495
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ns} {1575 ns}
