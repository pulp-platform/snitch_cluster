onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider inputs
add wave -noupdate /tb_snax_wb/i_snax_shell/clk_i
add wave -noupdate /tb_snax_wb/i_snax_shell/clk_d2_i
add wave -noupdate /tb_snax_wb/i_snax_shell/rst_ni
add wave -noupdate /tb_snax_wb/i_snax_shell/rst_int_ss_ni
add wave -noupdate /tb_snax_wb/i_snax_shell/rst_fp_ss_ni
add wave -noupdate /tb_snax_wb/i_snax_shell/hart_id_i
add wave -noupdate /tb_snax_wb/i_snax_shell/irq_i
add wave -noupdate /tb_snax_wb/i_snax_shell/hive_rsp_i
add wave -noupdate /tb_snax_wb/i_snax_shell/data_rsp_i
add wave -noupdate /tb_snax_wb/i_snax_shell/tcdm_rsp_i
add wave -noupdate /tb_snax_wb/i_snax_shell/hwpe_tcdm_rsp_i
add wave -noupdate /tb_snax_wb/i_snax_shell/axi_dma_res_i
add wave -noupdate /tb_snax_wb/i_snax_shell/tcdm_addr_base_i
add wave -noupdate -divider outputs
add wave -noupdate /tb_snax_wb/i_snax_shell/hive_req_o
add wave -noupdate /tb_snax_wb/i_snax_shell/data_req_o
add wave -noupdate /tb_snax_wb/i_snax_shell/tcdm_req_o
add wave -noupdate /tb_snax_wb/i_snax_shell/hwpe_tcdm_req_o
add wave -noupdate /tb_snax_wb/i_snax_shell/axi_dma_req_o
add wave -noupdate /tb_snax_wb/i_snax_shell/axi_dma_busy_o
add wave -noupdate /tb_snax_wb/i_snax_shell/axi_dma_perf_o
add wave -noupdate /tb_snax_wb/i_snax_shell/axi_dma_events_o
add wave -noupdate /tb_snax_wb/i_snax_shell/core_events_o
add wave -noupdate -divider snitch_regfile
add wave -noupdate /tb_snax_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem
add wave -noupdate -divider ne16_regfile
add wave -noupdate -expand -subitemconfig {/tb_snax_wb/i_snax_shell/gen_hwpe_ctrl/gen_hwpe_ne16/i_ne16_top_wrap/i_ne16_top/i_ctrl/i_slave/reg_file.hwpe_params -expand /tb_snax_wb/i_snax_shell/gen_hwpe_ctrl/gen_hwpe_ne16/i_ne16_top_wrap/i_ne16_top/i_ctrl/i_slave/reg_file.generic_params -expand} /tb_snax_wb/i_snax_shell/gen_hwpe_ctrl/gen_hwpe_ne16/i_ne16_top_wrap/i_ne16_top/i_ctrl/i_slave/reg_file
add wave -noupdate -divider ne16_tcdm_in
add wave -noupdate /tb_snax_wb/i_snax_shell/gen_hwpe_ctrl/gen_hwpe_ne16/i_ne16_top_wrap/tcdm_req
add wave -noupdate /tb_snax_wb/i_snax_shell/gen_hwpe_ctrl/gen_hwpe_ne16/i_ne16_top_wrap/tcdm_gnt
add wave -noupdate /tb_snax_wb/i_snax_shell/gen_hwpe_ctrl/gen_hwpe_ne16/i_ne16_top_wrap/tcdm_add
add wave -noupdate /tb_snax_wb/i_snax_shell/gen_hwpe_ctrl/gen_hwpe_ne16/i_ne16_top_wrap/tcdm_wen
add wave -noupdate /tb_snax_wb/i_snax_shell/gen_hwpe_ctrl/gen_hwpe_ne16/i_ne16_top_wrap/tcdm_be
add wave -noupdate /tb_snax_wb/i_snax_shell/gen_hwpe_ctrl/gen_hwpe_ne16/i_ne16_top_wrap/tcdm_data
add wave -noupdate /tb_snax_wb/i_snax_shell/gen_hwpe_ctrl/gen_hwpe_ne16/i_ne16_top_wrap/tcdm_r_data
add wave -noupdate /tb_snax_wb/i_snax_shell/gen_hwpe_ctrl/gen_hwpe_ne16/i_ne16_top_wrap/tcdm_r_valid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {764435 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 377
configure wave -valuecolwidth 109
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
WaveRestoreZoom {0 ps} {2100 ns}
