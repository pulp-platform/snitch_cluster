# Copyright 2020 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

set NR_QUADRANTS 1
set NR_CLUSTERS 1
set NR_CORES 9

set DMA_CORE_ID 8

config wave -signalnamewidth 1

add wave -noupdate -divider "Snitch Cores"

for {set CORE_ID 0} {$CORE_ID < $NR_CORES} {incr CORE_ID} {
    eval "add wave -noupdate -group {Core $CORE_ID} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[$CORE_ID]/i_snitch_cc/i_snitch/*}"
    eval "add wave -noupdate -group {FPU Core $CORE_ID} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[$CORE_ID]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/*}"
    eval "add wave -noupdate -group {FPU Core $CORE_ID} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[$CORE_ID]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_fpu/*}"
    eval "add wave -noupdate -group {LSU Core $CORE_ID} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[$CORE_ID]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_snitch_lsu/data_req_o}"
    eval "add wave -noupdate -group {LSU Core $CORE_ID} {/tb_bin/i_dut/i_snitch_cluster/i_cluster/gen_core[$CORE_ID]/i_snitch_cc/gen_fpu/i_snitch_fp_ss/i_snitch_lsu/data_rsp_i}"
    }



