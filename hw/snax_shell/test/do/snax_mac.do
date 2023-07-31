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
add wave -noupdate -expand /tb_snax_mac_wb/i_snax_shell/hive_rsp_i
add wave -noupdate -expand -subitemconfig {/tb_snax_mac_wb/i_snax_shell/data_rsp_i.p -expand} /tb_snax_mac_wb/i_snax_shell/data_rsp_i
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
add wave -noupdate -radix unsigned -childformat {{{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[31]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[30]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[29]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[28]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[27]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[26]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[25]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[24]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[23]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[22]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[21]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[20]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[19]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[18]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[17]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[16]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[15]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[14]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[13]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[12]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[11]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[10]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[9]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[8]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[7]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[6]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[5]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[4]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[3]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[2]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[1]} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[0]} -radix unsigned}} -expand -subitemconfig {{/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[31]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[30]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[29]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[28]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[27]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[26]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[25]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[24]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[23]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[22]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[21]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[20]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[19]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[18]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[17]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[16]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[15]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[14]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[13]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[12]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[11]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[10]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[9]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[8]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[7]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[6]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[5]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[4]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[3]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[2]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[1]} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem[0]} {-height 16 -radix unsigned}} /tb_snax_mac_wb/i_snax_shell/i_snitch/i_snitch_regfile/mem
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
add wave -noupdate -expand /tb_snax_mac_wb/i_snax_shell/gen_mac/i_snax_hwpe_ctrl/periph/be
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_snax_hwpe_ctrl/periph/data
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_snax_hwpe_ctrl/periph/id
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_snax_hwpe_ctrl/periph/r_data
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_snax_hwpe_ctrl/periph/r_valid
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_snax_hwpe_ctrl/periph/r_id
add wave -noupdate -divider mac_engine
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_mac_top/periph/clk
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_mac_top/periph/req
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_mac_top/periph/gnt
add wave -noupdate -radix unsigned /tb_snax_mac_wb/i_snax_shell/gen_mac/i_mac_top/periph/add
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_mac_top/periph/wen
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_mac_top/periph/be
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_mac_top/periph/data
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_mac_top/periph/id
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_mac_top/periph/r_data
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_mac_top/periph/r_valid
add wave -noupdate /tb_snax_mac_wb/i_snax_shell/gen_mac/i_mac_top/periph/r_id
add wave -noupdate -divider mac_regfile
add wave -noupdate -expand -subitemconfig {/tb_snax_mac_wb/i_snax_shell/gen_mac/i_mac_top/i_ctrl/i_slave/reg_file.hwpe_params -expand /tb_snax_mac_wb/i_snax_shell/gen_mac/i_mac_top/i_ctrl/i_slave/reg_file.generic_params -expand} /tb_snax_mac_wb/i_snax_shell/gen_mac/i_mac_top/i_ctrl/i_slave/reg_file
add wave -noupdate -divider hwpe_to_reqrsp
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[3]/i_snax_hwpe_to_reqrsp/clk_i}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[3]/i_snax_hwpe_to_reqrsp/rst_ni}
add wave -noupdate -subitemconfig {{/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[3]/i_snax_hwpe_to_reqrsp/tcdm_req_o.q} {-height 16 -childformat {{addr -radix unsigned} {data -radix unsigned}} -expand} {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[3]/i_snax_hwpe_to_reqrsp/tcdm_req_o.q.addr} {-radix unsigned} {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[3]/i_snax_hwpe_to_reqrsp/tcdm_req_o.q.data} {-radix unsigned}} {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[3]/i_snax_hwpe_to_reqrsp/tcdm_req_o}
add wave -noupdate -subitemconfig {{/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[3]/i_snax_hwpe_to_reqrsp/tcdm_rsp_i.p} {-height 16 -childformat {{data -radix unsigned}} -expand} {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[3]/i_snax_hwpe_to_reqrsp/tcdm_rsp_i.p.data} {-radix unsigned}} {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[3]/i_snax_hwpe_to_reqrsp/tcdm_rsp_i}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[2]/i_snax_hwpe_to_reqrsp/clk_i}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[2]/i_snax_hwpe_to_reqrsp/rst_ni}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[2]/i_snax_hwpe_to_reqrsp/tcdm_req_o}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[2]/i_snax_hwpe_to_reqrsp/tcdm_rsp_i}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[1]/i_snax_hwpe_to_reqrsp/clk_i}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[1]/i_snax_hwpe_to_reqrsp/rst_ni}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[1]/i_snax_hwpe_to_reqrsp/tcdm_req_o}
add wave -noupdate -subitemconfig {{/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[1]/i_snax_hwpe_to_reqrsp/tcdm_rsp_i.p} {-height 16 -childformat {{data -radix unsigned}} -expand} {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[1]/i_snax_hwpe_to_reqrsp/tcdm_rsp_i.p.data} {-radix unsigned}} {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[1]/i_snax_hwpe_to_reqrsp/tcdm_rsp_i}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/clk_i}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/rst_ni}
add wave -noupdate -subitemconfig {{/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/tcdm_req_o.q} -expand} {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/tcdm_req_o}
add wave -noupdate -subitemconfig {{/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/tcdm_rsp_i.p} {-height 16 -childformat {{data -radix unsigned}} -expand} {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/tcdm_rsp_i.p.data} {-radix unsigned}} {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/tcdm_rsp_i}
add wave -noupdate -divider hwpe_to_reqrsp_0
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/push_hwpe_tcdm}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/pop_hwpe_tcdm}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/hwpe_tcdm_slave/clk}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/hwpe_tcdm_slave/req}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/hwpe_tcdm_slave/gnt}
add wave -noupdate -radix unsigned {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/hwpe_tcdm_slave/add}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/hwpe_tcdm_slave/wen}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/hwpe_tcdm_slave/be}
add wave -noupdate -radix unsigned {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/hwpe_tcdm_slave/data}
add wave -noupdate -radix unsigned {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/hwpe_tcdm_slave/r_data}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/hwpe_tcdm_slave/r_valid}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/fifo_hwpe_tcdm_full}
add wave -noupdate {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/fifo_hwpe_tcdm_empty}
add wave -noupdate -childformat {{{/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/fifo_hwpe_tcdm_data_in.add} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/fifo_hwpe_tcdm_data_in.data} -radix unsigned}} -subitemconfig {{/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/fifo_hwpe_tcdm_data_in.add} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/fifo_hwpe_tcdm_data_in.data} {-height 16 -radix unsigned}} {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/fifo_hwpe_tcdm_data_in}
add wave -noupdate -childformat {{{/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/fifo_hwpe_tcdm_data_out.add} -radix unsigned} {{/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/fifo_hwpe_tcdm_data_out.data} -radix unsigned}} -subitemconfig {{/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/fifo_hwpe_tcdm_data_out.add} {-height 16 -radix unsigned} {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/fifo_hwpe_tcdm_data_out.data} {-height 16 -radix unsigned}} {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/fifo_hwpe_tcdm_data_out}
add wave -noupdate -divider {New Divider}
add wave -noupdate -expand {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/tcdm_req_o}
add wave -noupdate -expand -subitemconfig {{/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/tcdm_rsp_i.p} {-height 16 -childformat {{data -radix unsigned}} -expand} {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/tcdm_rsp_i.p.data} {-radix unsigned}} {/tb_snax_mac_wb/i_snax_shell/gen_mac/genblk1[0]/i_snax_hwpe_to_reqrsp/tcdm_rsp_i}
add wave -noupdate -divider control_states
add wave -noupdate -divider {New Divider}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {690000 ps} 0} {{Cursor 2} {1392219 ps} 0} {{Cursor 3} {50000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 603
configure wave -valuecolwidth 117
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
WaveRestoreZoom {308027 ps} {1562735 ps}
