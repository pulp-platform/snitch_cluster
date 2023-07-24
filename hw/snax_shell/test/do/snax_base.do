onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_snax_shell/i_snitch_cc/clk_i
add wave -noupdate /tb_snax_shell/i_snitch_cc/clk_d2_i
add wave -noupdate /tb_snax_shell/i_snitch_cc/rst_ni
add wave -noupdate /tb_snax_shell/i_snitch_cc/rst_int_ss_ni
add wave -noupdate /tb_snax_shell/i_snitch_cc/rst_fp_ss_ni
add wave -noupdate /tb_snax_shell/i_snitch_cc/hart_id_i
add wave -noupdate /tb_snax_shell/i_snitch_cc/irq_i
add wave -noupdate /tb_snax_shell/i_snitch_cc/hive_req_o
add wave -noupdate /tb_snax_shell/i_snitch_cc/hive_rsp_i
add wave -noupdate /tb_snax_shell/i_snitch_cc/data_req_o
add wave -noupdate /tb_snax_shell/i_snitch_cc/data_rsp_i
add wave -noupdate /tb_snax_shell/i_snitch_cc/tcdm_req_o
add wave -noupdate /tb_snax_shell/i_snitch_cc/tcdm_rsp_i
add wave -noupdate /tb_snax_shell/i_snitch_cc/axi_dma_req_o
add wave -noupdate /tb_snax_shell/i_snitch_cc/axi_dma_res_i
add wave -noupdate /tb_snax_shell/i_snitch_cc/axi_dma_busy_o
add wave -noupdate /tb_snax_shell/i_snitch_cc/axi_dma_perf_o
add wave -noupdate /tb_snax_shell/i_snitch_cc/axi_dma_events_o
add wave -noupdate /tb_snax_shell/i_snitch_cc/core_events_o
add wave -noupdate /tb_snax_shell/i_snitch_cc/tcdm_addr_base_i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {238 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 337
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
WaveRestoreZoom {501 ns} {816 ns}
