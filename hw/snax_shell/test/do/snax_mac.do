onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider inputs
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/clk_i
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/clk_d2_i
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/rst_ni
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/rst_int_ss_ni
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/rst_fp_ss_ni
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/hart_id_i
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/irq_i
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/hive_rsp_i
add wave -noupdate -expand /tb_snax_mac_wb/i_snax_shell/data_rsp_i
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/tcdm_rsp_i
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/axi_dma_res_i
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/tcdm_addr_base_i
add wave -noupdate -divider outputs
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/hive_req_o
add wave -noupdate -expand /tb_snax_mac_wb/i_snax_shell/data_req_o
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/tcdm_req_o
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/axi_dma_req_o
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/axi_dma_busy_o
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/axi_dma_perf_o
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/axi_dma_events_o
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/core_events_o
add wave -noupdate -divider snitch_regfile
add wave -noupdate -expand /tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem
add wave -noupdate -divider snax_hwpe_ctrl
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_snax_hwpe_ctrl/clk_i
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_snax_hwpe_ctrl/rst_ni
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_snax_hwpe_ctrl/req_i
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_snax_hwpe_ctrl/req_valid_i
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_snax_hwpe_ctrl/req_ready_o
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_snax_hwpe_ctrl/resp_o
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_snax_hwpe_ctrl/resp_valid_o
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_snax_hwpe_ctrl/resp_ready_i
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_snax_hwpe_ctrl/periph/clk
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_snax_hwpe_ctrl/periph/req
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_snax_hwpe_ctrl/periph/gnt
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_snax_hwpe_ctrl/periph/add
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_snax_hwpe_ctrl/periph/wen
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_snax_hwpe_ctrl/periph/be
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_snax_hwpe_ctrl/periph/data
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_snax_hwpe_ctrl/periph/id
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_snax_hwpe_ctrl/periph/r_data
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_snax_hwpe_ctrl/periph/r_valid
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_snax_hwpe_ctrl/periph/r_id
add wave -noupdate -divider mac_engine
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_mac_top/periph/clk
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_mac_top/periph/req
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_mac_top/periph/gnt
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_mac_top/periph/add
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_mac_top/periph/wen
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_mac_top/periph/be
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_mac_top/periph/data
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_mac_top/periph/id
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_mac_top/periph/r_data
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_mac_top/periph/r_valid
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_mac_top/periph/r_id
add wave -noupdate -divider mac_regfile
add wave -noupdate -expand /tb_snax_mac_wb/i_snax_shell/gen_mac/i_mac_top/i_ctrl/i_slave/reg_file
add wave -noupdate -divider hwpe_to_reqrsp
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[3]/i_snax_hwpe_to_reqrsp/clk_i}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[3]/i_snax_hwpe_to_reqrsp/rst_ni}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[3]/i_snax_hwpe_to_reqrsp/tcdm_req_o}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[3]/i_snax_hwpe_to_reqrsp/tcdm_rsp_i}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[2]/i_snax_hwpe_to_reqrsp/clk_i}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[2]/i_snax_hwpe_to_reqrsp/rst_ni}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[2]/i_snax_hwpe_to_reqrsp/tcdm_req_o}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[2]/i_snax_hwpe_to_reqrsp/tcdm_rsp_i}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[1]/i_snax_hwpe_to_reqrsp/clk_i}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[1]/i_snax_hwpe_to_reqrsp/rst_ni}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[1]/i_snax_hwpe_to_reqrsp/tcdm_req_o}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[1]/i_snax_hwpe_to_reqrsp/tcdm_rsp_i}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/clk_i}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/rst_ni}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/tcdm_req_o}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/tcdm_rsp_i}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1040000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 607
configure wave -valuecolwidth 147
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
WaveRestoreZoom {0 ps} {1238563 ps}
