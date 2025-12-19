# Copyright (c) 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Authors:
# - Philippe Sauter <phsauter@iis.ee.ethz.ch>
set ROOT [pwd]
set WORK_LIB "$ROOT/target/sim/build/work-vsim"

if {[catch { vlog -work $WORK_LIB -incr -sv \
    +define+FUNCTIONAL \
    "$ROOT/target/asic/ihp13/pdk/ihp-sg13g2/libs.ref/sg13g2_stdcell/verilog/sg13g2_stdcell.v" \
    "$ROOT/target/asic/ihp13/pdk/ihp-sg13g2/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_core_behavioral_bm_bist.v" \
    "$ROOT/target/asic/ihp13/pdk/ihp-sg13g2/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_64x64_c2_bm_bist.v" \
    "$ROOT/target/asic/ihp13/pdk/ihp-sg13g2/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_256x64_c2_bm_bist.v" \
    "$ROOT/target/asic/ihp13/pdk/ihp-sg13g2/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_512x64_c2_bm_bist.v" \
    "$ROOT/target/asic/ihp13/pdk/ihp-sg13g2/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_1024x64_c2_bm_bist.v" \
    "$ROOT/target/asic/ihp13/pdk/ihp-sg13g2/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_2048x64_c2_bm_bist.v" \
    "$ROOT/target/asic/ihp13/pdk/ihp-sg13g2/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_256x48_c2_bm_bist.v" \
    "$ROOT/target/asic/ihp13/pdk/ihp-sg13g2/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_256x48_c2_bm_bist.v" \
    "$ROOT/target/asic/ihp13/tc_sram_impl.sv" \
    "$ROOT/target/asic/ihp13/tc_clk.sv" \
}]} {return 1}
