// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
#include <snrt.h>

// Note: operands are passed to the asm blocks below through ordinary "r"
// constraints and referenced in the templates via %N placeholders, rather
// than being pinned to fixed hardware registers (e.g. via GCC/Clang's
// local register variable extension). Pinning operands to fixed
// registers is unreliable under Clang: the compiler does not guarantee
// that a register bound this way keeps its assigned value up to the
// point where an asm block reads it, even when the assignment and the
// asm are adjacent in the source, since intervening (from the compiler's
// point of view unrelated) code is free to reuse that same physical
// register as scratch space in between, silently corrupting the
// operand before the asm block ever sees it.

int main() {
#ifdef SNRT_SUPPORTS_PULP
    uint32_t i = snrt_global_core_idx();
    snrt_cluster_hw_barrier();
    if (i == 0) {
        int errs = 0;
        int32_t rd, rs1, rs2;
        ///////////////////////////
        // P_LB_IRPOST
        int8_t *lb_irpost = snrt_l1_alloc_cluster_local<int8_t>(1);
        *lb_irpost = 0x21;
        rs1 = (int32_t)(uintptr_t)lb_irpost;
        asm volatile("cv.lb %1, (%0), 4\n" : "+r"(rs1), "=r"(rd));
        if (!((rd == 0x21) && (rs1 == (int32_t)((uintptr_t)lb_irpost + 4)))) {
            errs = errs + 1;
        }
        ///////////////////////////
        // P_LBU_IRPOST
        uint8_t *lbu_irpost = snrt_l1_alloc_cluster_local<uint8_t>(1);
        *lbu_irpost = 0x78;
        rs1 = (int32_t)(uintptr_t)lbu_irpost;
        asm volatile("cv.lbu %1, (%0), 4\n" : "+r"(rs1), "=r"(rd));
        if (!((rd == 0x78) && (rs1 == (int32_t)((uintptr_t)lbu_irpost + 4)))) {
            errs = errs + 1;
        }
        ////////////////////
        // P_LH_IRPOST
        int16_t *lh_irpost = snrt_l1_alloc_cluster_local<int16_t>(1);
        *lh_irpost = 0x231;
        rs1 = (int32_t)(uintptr_t)lh_irpost;
        asm volatile(  //incr +4 to rs1
            "cv.lh %1, (%0), 4\n"
            : "+r"(rs1), "=r"(rd));
        if (!((rd == 0x231) && (rs1 == (int32_t)((uintptr_t)lh_irpost + 4)))) {
            errs = errs + 1;
        }
        /////////////////
        // P_LHU_IRPOST
        uint16_t *lhu_irpost = snrt_l1_alloc_cluster_local<uint16_t>(1);
        *lhu_irpost = 0x34;
        rs1 = (int32_t)(uintptr_t)lhu_irpost;
        asm volatile(  //incr +4 to rs1
            "cv.lhu %1, (%0), 4\n"
            : "+r"(rs1), "=r"(rd));
        if (!((rd == 0x34) && (rs1 == (int32_t)((uintptr_t)lhu_irpost + 4)))) {
            errs = errs + 1;
        }
        /////////////////
        // P_LW_IRPOST
        int32_t *lw_irpost = snrt_l1_alloc_cluster_local<int32_t>(1);
        *lw_irpost = 0x23;
        rs1 = (int32_t)(uintptr_t)lw_irpost;
        asm volatile(  //incr +4 to rs1
            "cv.lw   %1, (%0), 4\n"
            : "+r"(rs1), "=r"(rd));
        if (!((rd == 0x23) && (rs1 == (int32_t)((uintptr_t)lw_irpost + 4)))) {
            errs = errs + 1;
        }
        //////////////////
        // P_LB_RRPOST
        int8_t *lb_rrpost = snrt_l1_alloc_cluster_local<int8_t>(1);
        *lb_rrpost = 0x23;
        rs1 = (int32_t)(uintptr_t)lb_rrpost;
        rs2 = 8;
        asm volatile(  //incr +rs2 to rs1
            "cv.lb   %1, (%0), %2\n"
            : "+r"(rs1), "=r"(rd)
            : "r"(rs2));
        if (!((rd == 0x23) && (rs1 == (int32_t)(uintptr_t)lb_rrpost + rs2))) {
            errs = errs + 1;
        }
        //////////////////
        // P_LBU_RRPOST
        uint8_t *lbu_rrpost = snrt_l1_alloc_cluster_local<uint8_t>(1);
        *lbu_rrpost = 0x57;
        rs1 = (int32_t)(uintptr_t)lbu_rrpost;
        rs2 = 4;
        asm volatile(  //incr +rs2 to rs1
            "cv.lbu  %1, (%0), %2\n"
            : "+r"(rs1), "=r"(rd)
            : "r"(rs2));
        if (!((rd == 0x57) && (rs1 == (int32_t)(uintptr_t)lbu_rrpost + rs2))) {
            errs = errs + 1;
        }
        ////////////////////
        // P_LH_RRPOST
        int16_t *lh_rrpost = snrt_l1_alloc_cluster_local<int16_t>(1);
        *lh_rrpost = 0x12;
        rs1 = (int32_t)(uintptr_t)lh_rrpost;
        rs2 = 8;
        asm volatile(  //incr +rs2 to rs1
            "cv.lh   %1, (%0), %2\n"
            : "+r"(rs1), "=r"(rd)
            : "r"(rs2));
        if (!((rd == 0x12) && (rs1 == (int32_t)(uintptr_t)lh_rrpost + rs2))) {
            errs = errs + 1;
        }
        //////////////////
        // P_LHU_RRPOST
        uint16_t *lhu_rrpost = snrt_l1_alloc_cluster_local<uint16_t>(1);
        *lhu_rrpost = 0x41;
        rs1 = (int32_t)(uintptr_t)lhu_rrpost;
        rs2 = 10;
        asm volatile(  //incr +rs2 to rs1
            "cv.lhu  %1, (%0), %2\n"
            : "+r"(rs1), "=r"(rd)
            : "r"(rs2));
        if (!((rd == 0x41) && (rs1 == (int32_t)(uintptr_t)lhu_rrpost + rs2))) {
            errs = errs + 1;
        }
        ///////////////
        // P_LW_RRPOST
        int32_t *lw_rrpost = snrt_l1_alloc_cluster_local<int32_t>(1);
        *lw_rrpost = 0x9;
        rs1 = (int32_t)(uintptr_t)lw_rrpost;
        rs2 = 20;
        asm volatile(  //incr +rs2 to rs1
            "cv.lw   %1, (%0), %2\n"
            : "+r"(rs1), "=r"(rd)
            : "r"(rs2));
        if (!((rd == 0x9) && (rs1 == (int32_t)(uintptr_t)lw_rrpost + rs2))) {
            errs = errs + 1;
        }
        /////////////
        // P_LB_RR: access at rs1 + rs2 (rs2=10)
        int8_t *lb_rr = snrt_l1_alloc_cluster_local<int8_t>(11);
        rs2 = 10;
        lb_rr[rs2] = 0x49;
        rs1 = (int32_t)(uintptr_t)lb_rr;
        asm volatile(  //read from rs1 + rs2
            "cv.lb   %0, %2(%1)\n"
            : "=r"(rd)
            : "r"(rs1), "r"(rs2));
        if (!((rd == 0x49) && (rs1 == (int32_t)(uintptr_t)lb_rr))) {
            errs = errs + 1;
        }
        ////////////
        // P_LBU_RR: access at rs1 + rs2 (rs2=10)
        uint8_t *lbu_rr = snrt_l1_alloc_cluster_local<uint8_t>(11);
        rs2 = 10;
        lbu_rr[rs2] = 0x69;
        rs1 = (int32_t)(uintptr_t)lbu_rr;
        asm volatile(  //read from rs1 + rs2
            "cv.lbu  %0, %2(%1)\n"
            : "=r"(rd)
            : "r"(rs1), "r"(rs2));
        if (!((rd == 0x69) && (rs1 == (int32_t)(uintptr_t)lbu_rr))) {
            errs = errs + 1;
        }
        ////////////
        // P_LH_RR: access at rs1 + rs2 (rs2=4, i.e. element index 2)
        int16_t *lh_rr = snrt_l1_alloc_cluster_local<int16_t>(3);
        rs2 = 4;
        lh_rr[rs2 / sizeof(int16_t)] = 0x25;
        rs1 = (int32_t)(uintptr_t)lh_rr;
        asm volatile(  //read from rs1 + rs2
            "cv.lh   %0, %2(%1)\n"
            : "=r"(rd)
            : "r"(rs1), "r"(rs2));
        if (!((rd == 0x25) && (rs1 == (int32_t)(uintptr_t)lh_rr))) {
            errs = errs + 1;
        }
        ////////////
        // P_LHU_RR: access at rs1 + rs2 (rs2=8, i.e. element index 4)
        uint16_t *lhu_rr = snrt_l1_alloc_cluster_local<uint16_t>(5);
        rs2 = 8;
        lhu_rr[rs2 / sizeof(uint16_t)] = 0x11;
        rs1 = (int32_t)(uintptr_t)lhu_rr;
        asm volatile(  //read from rs1 + rs2
            "cv.lhu  %0, %2(%1)\n"
            : "=r"(rd)
            : "r"(rs1), "r"(rs2));
        if (!((rd == 0x11) && (rs1 == (int32_t)(uintptr_t)lhu_rr))) {
            errs = errs + 1;
        }
        ///////////
        // P_LW_RR: access at rs1 + rs2 (rs2=4, i.e. element index 1)
        int32_t *lw_rr = snrt_l1_alloc_cluster_local<int32_t>(2);
        rs2 = 4;
        lw_rr[rs2 / sizeof(int32_t)] = 0x33;
        rs1 = (int32_t)(uintptr_t)lw_rr;
        asm volatile(  //read from rs1 + rs2
            "cv.lw   %0, %2(%1)\n"
            : "=r"(rd)
            : "r"(rs1), "r"(rs2));
        if (!((rd == 0x33) && (rs1 == (int32_t)(uintptr_t)lw_rr))) {
            errs = errs + 1;
        }
        ////////////
        // P_SB_IRPOST
        int8_t *sb_irpost = snrt_l1_alloc_cluster_local<int8_t>(1);
        rs2 = 0x76;
        rs1 = (int32_t)(uintptr_t)sb_irpost;
        asm volatile(  //write rs2 value to rs1, increment rs1
            "cv.sb   %1, (%0), 4\n"
            : "+r"(rs1)
            : "r"(rs2));
        if (!((*sb_irpost == 0x76) &&
              (rs1 == (int32_t)((uintptr_t)sb_irpost + 4)))) {
            errs = errs + 1;
        }
        //////////
        // P_SH_IRPOST
        int16_t *sh_irpost = snrt_l1_alloc_cluster_local<int16_t>(1);
        rs2 = 0x99;
        rs1 = (int32_t)(uintptr_t)sh_irpost;
        asm volatile(  //write rs2 value to rs1, increment rs1
            "cv.sh   %1, (%0), 4\n"
            : "+r"(rs1)
            : "r"(rs2));
        if (!((*sh_irpost == 0x99) &&
              (rs1 == (int32_t)((uintptr_t)sh_irpost + 4)))) {
            errs = errs + 1;
        }
        //////////
        // P_SW_IRPOST
        int32_t *sw_irpost = snrt_l1_alloc_cluster_local<int32_t>(1);
        rs2 = 0x71;
        rs1 = (int32_t)(uintptr_t)sw_irpost;
        asm volatile(  //write rs2 value to rs1, increment rs1
            "cv.sw   %1, (%0), 4\n"
            : "+r"(rs1)
            : "r"(rs2));
        if (!((*sw_irpost == 0x71) &&
              (rs1 == (int32_t)((uintptr_t)sw_irpost + 4)))) {
            errs = errs + 1;
        }
        //////////
        // P_SB_RRPOST
        int8_t *sb_rrpost = snrt_l1_alloc_cluster_local<int8_t>(1);
        rs2 = 0x21;
        rs1 = (int32_t)(uintptr_t)sb_rrpost;
        rd = 0x4;
        asm volatile(  //write rs2 value to rs1, increment rs1 by rd
            "cv.sb   %1, (%0), %2\n"
            : "+r"(rs1)
            : "r"(rs2), "r"(rd));
        if (!((*sb_rrpost == 0x21) &&
              (rs1 == (int32_t)(uintptr_t)sb_rrpost + rd))) {
            errs = errs + 1;
        }
        //////////
        // P_SH_RRPOST
        int16_t *sh_rrpost = snrt_l1_alloc_cluster_local<int16_t>(1);
        rs2 = 0x15;
        rs1 = (int32_t)(uintptr_t)sh_rrpost;
        rd = 0x8;
        asm volatile(  //write rs2 value to rs1, increment rs1 by rd
            "cv.sh   %1, (%0), %2\n"
            : "+r"(rs1)
            : "r"(rs2), "r"(rd));
        if (!((*sh_rrpost == 0x15) &&
              (rs1 == (int32_t)(uintptr_t)sh_rrpost + rd))) {
            errs = errs + 1;
        }
        /////////
        // P_SW_RRPOST
        int32_t *sw_rrpost = snrt_l1_alloc_cluster_local<int32_t>(1);
        rs2 = 0x57;
        rs1 = (int32_t)(uintptr_t)sw_rrpost;
        rd = 0x100;
        asm volatile(  //write rs2 value to rs1, increment rs1 by rd
            "cv.sw   %1, (%0), %2\n"
            : "+r"(rs1)
            : "r"(rs2), "r"(rd));
        if (!((*sw_rrpost == 0x57) &&
              (rs1 == (int32_t)(uintptr_t)sw_rrpost + rd))) {
            errs = errs + 1;
        }
        /////////
        // P_SB_RR: write to rs1 + rd (rd=0x100)
        int8_t *sb_rr = snrt_l1_alloc_cluster_local<int8_t>(0x101);
        rs2 = 0x23;
        rs1 = (int32_t)(uintptr_t)sb_rr;
        rd = 0x100;
        asm volatile(  //write rs2 value to rs1 + rd
            "cv.sb   %0, %2(%1)\n"
            :
            : "r"(rs2), "r"(rs1), "r"(rd));
        if (!((sb_rr[rd] == 0x23) && (rs1 == (int32_t)(uintptr_t)sb_rr))) {
            errs = errs + 1;
        }
        /////////
        // P_SH_RR: write to rs1 + rd (rd=0x80, i.e. element index 0x40)
        int16_t *sh_rr = snrt_l1_alloc_cluster_local<int16_t>(0x41);
        rs2 = 0x18;
        rs1 = (int32_t)(uintptr_t)sh_rr;
        rd = 0x80;
        asm volatile(  //write rs2 value to rs1 + rd
            "cv.sh   %0, %2(%1)\n"
            :
            : "r"(rs2), "r"(rs1), "r"(rd));
        if (!((sh_rr[rd / sizeof(int16_t)] == 0x18) &&
              (rs1 == (int32_t)(uintptr_t)sh_rr))) {
            errs = errs + 1;
        }
        /////////
        // P_SW_RR: write to rs1 + rd (rd=0x20, i.e. element index 8)
        int32_t *sw_rr = snrt_l1_alloc_cluster_local<int32_t>(9);
        rs2 = 0x98;
        rs1 = (int32_t)(uintptr_t)sw_rr;
        rd = 0x20;
        asm volatile(  //write rs2 value to rs1 + rd
            "cv.sw   %0, %2(%1)\n"
            :
            : "r"(rs2), "r"(rs1), "r"(rd));
        if (!((sw_rr[rd / sizeof(int32_t)] == 0x98) &&
              (rs1 == (int32_t)(uintptr_t)sw_rr))) {
            errs = errs + 1;
        }

        return errs;
    }
    return 0;
#else
    return 1;
#endif
}
