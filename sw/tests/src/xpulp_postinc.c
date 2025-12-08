// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
#include <snrt.h>

int main() {
#ifdef SNRT_SUPPORTS_XPULP
    uint32_t i = snrt_global_core_idx();
    snrt_cluster_hw_barrier();
    if (i == 2) {
        int errs = 0;
        int32_t result_rd;
        int32_t result_rs1;
        int8_t *mem8 = (int8_t *)0x10000000;
        mem8[0] = 0x21;
        register int32_t rd asm("a3") = 1;
        register int32_t rs1 asm("a4") = 0x10000000;  // rs1, data source
        asm volatile("p.lb a3, 4(a4!)\n" : "+r"(rs1), "=r"(rd) : : "a3", "a4");
        result_rd = rd;
        result_rs1 = rs1;
        if (!((result_rd == 0x21) && (result_rs1 == 0x10000004))) {
            errs = errs + 1;
        }
        ///////////////////////////
        // P_LBU_IRPOST
        *(uint8_t *)(0x10002000) = 0x78;
        rs1 = 0x10002000;
        asm volatile("p.lbu a3, 4(a4!)\n" : "+r"(rs1), "=r"(rd) : : "a3", "a4");
        result_rd = rd;
        result_rs1 = rs1;
        if (!((result_rd == 0x78) && (result_rs1 == 0x10002004))) {
            errs = errs + 1;
        }
        ////////////////////
        //P_LH_IRPOST
        *(int16_t *)(0x10000000) = 0x231;
        rs1 = 0x10000000;
        asm volatile(  //incr +4 to rs1
            "p.lh a3, 4(a4!)\n"
            : "+r"(rs1), "=r"(rd)
            :
            : "a3", "a4");
        result_rd = rd;
        result_rs1 = rs1;
        if (!((result_rd == 0x231) && (result_rs1 == 0x10000004))) {
            errs = errs + 1;
        }
        /////////////////
        //P_LHU_IRPOST
        *(uint16_t *)(0x10001000) = 0x34;
        rs1 = 0x10001000;
        asm volatile(  //incr +4 to rs1
            "p.lhu a3, 4(a4!)\n"
            : "+r"(rs1), "=r"(rd)
            :
            : "a3", "a4");
        result_rd = rd;
        result_rs1 = rs1;
        if (!((result_rd == 0x34) && (result_rs1 == 0x10001004))) {
            errs = errs + 1;
        }
        /////////////////
        //P_LW_IRPOST
        *(int32_t *)(0x10000000) = 0x23;
        rs1 = 0x10000000;
        asm volatile(  //incr +4 to rs1
            "p.lw   a3, 4(a4!)\n"
            : "+r"(rs1), "=r"(rd)
            :
            : "a3", "a4");
        result_rd = rd;
        result_rs1 = rs1;
        if (!((result_rd == 0x23) && (result_rs1 == 0x10000004))) {
            errs = errs + 1;
        }

        //////////////////
        //P_LB_RRPOST
        *(int8_t *)(0x10001000) = 0x23;
        register int32_t rs2 asm("a5") = 8;
        rs1 = 0x10001000;
        asm volatile(  //incr +rs2 to rs1
            "p.lb   a3, a5(a4!)\n"
            : "+r"(rs1), "=r"(rd)
            : "r"(rs2)
            : "a3", "a4", "a5");
        result_rd = rd;
        result_rs1 = rs1;
        if (!((result_rd == 0x23) && (result_rs1 == 0x10001000 + rs2))) {
            errs = errs + 1;
        }
        //////////////////
        //P_LBU_RRPOST
        *(uint8_t *)(0x10001800) = 0x57;
        rs2 = 4;
        rs1 = 0x10001800;
        asm volatile(  //incr +rs2 to rs1
            "p.lbu  a3, a5(a4!)\n"
            : "+r"(rs1), "=r"(rd)
            : "r"(rs2)
            : "a3", "a4", "a5");
        result_rd = rd;
        result_rs1 = rs1;
        if (!((result_rd == 0x57) && (result_rs1 == 0x10001800 + rs2))) {
            errs = errs + 1;
        }
        ////////////////////
        //P_LH_RRPOST
        *(int16_t *)(0x10001400) = 0x12;
        rs2 = 8;
        rs1 = 0x10001400;
        asm volatile(  //incr +rs2 to rs1
            "p.lh   a3, a5(a4!)\n"
            : "+r"(rs1), "=r"(rd)
            : "r"(rs2)
            : "a3", "a4", "a5");
        result_rd = rd;
        result_rs1 = rs1;
        if (!((result_rd == 0x12) && (result_rs1 == 0x10001400 + rs2))) {
            errs = errs + 1;
        }
        //////////////////
        //P_LHU_RRPOST
        *(uint16_t *)(0x10002400) = 0x41;
        rs2 = 10;
        rs1 = 0x10002400;
        asm volatile(  //incr +rs2 to rs1
            "p.lhu  a3, a5(a4!)\n"
            : "+r"(rs1), "=r"(rd)
            : "r"(rs2)
            : "a3", "a4", "a5");
        result_rd = rd;
        result_rs1 = rs1;
        if (!((result_rd == 0x41) && (result_rs1 == 0x10002400 + rs2))) {
            errs = errs + 1;
        }
        ///////////////
        //P_LW_RRPOST
        *(int32_t *)(0x10002100) = 0x9;
        rs2 = 20;
        rs1 = 0x10002100;
        asm volatile(  //incr +rs2 to rs1
            "p.lw   a3, a5(a4!)\n"
            : "+r"(rs1), "=r"(rd)
            : "r"(rs2)
            : "a3", "a4", "a5");
        result_rd = rd;
        result_rs1 = rs1;
        if (!((result_rd == 0x9) && (result_rs1 == 0x10002100 + rs2))) {
            errs = errs + 1;
        }
        /////////////
        //P_LB_RR
        *(int8_t *)(0x1000200a) = 0x49;
        rs2 = 10;
        rs1 = 0x10002000;
        asm volatile(  //read from rs1 + rs2
            "p.lb   a3, a5(a4)\n"
            : "=r"(rd)
            : "r"(rs1), "r"(rs2)
            : "a3", "a4", "a5");
        result_rd = rd;
        result_rs1 = rs1;
        if (!((result_rd == 0x49) && (result_rs1 == 0x10002000))) {
            errs = errs + 1;
        }
        ////////////
        //P_LBU_RR
        *(uint8_t *)(0x1000300a) = 0x69;
        rs2 = 10;
        rs1 = 0x10003000;
        asm volatile(  //read from rs1 + rs2
            "p.lbu  a3, a5(a4)\n"
            : "=r"(rd)
            : "r"(rs1), "r"(rs2)
            : "a3", "a4", "a5");
        result_rd = rd;
        result_rs1 = rs1;
        if (!((result_rd == 0x69) && (result_rs1 == 0x10003000))) {
            errs = errs + 1;
        }
        ////////////
        //P_LH_RR
        *(int16_t *)(0x10004004) = 0x25;
        rs2 = 4;
        rs1 = 0x10004000;
        asm volatile(  //read from rs1 + rs2
            "p.lh   a3, a5(a4)\n"
            : "=r"(rd)
            : "r"(rs1), "r"(rs2)
            : "a3", "a4", "a5");
        result_rd = rd;
        result_rs1 = rs1;
        if (!((result_rd == 0x25) && (result_rs1 == 0x10004000))) {
            errs = errs + 1;
        }
        ////////////
        //P_LHU_RR
        *(uint16_t *)(0x10003008) = 0x11;
        rs2 = 8;
        rs1 = 0x10003000;
        asm volatile(  //read from rs1 + rs2
            "p.lhu  a3, a5(a4)\n"
            : "=r"(rd)
            : "r"(rs1), "r"(rs2)
            : "a3", "a4", "a5");
        result_rd = rd;
        result_rs1 = rs1;
        if (!((result_rd == 0x11) && (result_rs1 == 0x10003000))) {
            errs = errs + 1;
        }
        ///////////
        //P_LW_RR
        *(int32_t *)(0x10009004) = 0x33;
        rs2 = 4;
        rs1 = 0x10009000;
        asm volatile(  //read from rs1 + rs2
            "p.lw   a3, a5(a4)\n"
            : "=r"(rd)
            : "r"(rs1), "r"(rs2)
            : "a3", "a4", "a5");
        result_rd = rd;
        result_rs1 = rs1;
        if (!((result_rd == 0x33) && (result_rs1 == 0x10009000))) {
            errs = errs + 1;
        }
        ////////////
        //P_SB_IRPOST
        rs2 = 0x76;
        rs1 = 0x10000000;
        asm volatile(  //write rs2 value to rs1, increment rs1
            "p.sb   a5, 4(a4!)\n"
            : "+r"(rs1)
            : "r"(rs2)
            : "a3", "a4");
        result_rd = *(int8_t *)(0x10000000);
        result_rs1 = rs1;
        if (!((result_rd == 0x76) && (result_rs1 == 0x10000004))) {
            errs = errs + 1;
        }
        //////////
        //P_SH_IRPOST
        rs2 = 0x99;
        rs1 = 0x10001000;
        asm volatile(  //write rs2 value to rs1, increment rs1
            "p.sh   a5, 4(a4!)\n"
            : "+r"(rs1)
            : "r"(rs2)
            : "a3", "a4");
        result_rd = *(int16_t *)(0x10001000);
        result_rs1 = rs1;
        if (!((result_rd == 0x99) && (result_rs1 == 0x10001004))) {
            errs = errs + 1;
        }
        //////////
        //P_SW_IRPOST
        rs2 = 0x71;
        rs1 = 0x10001100;
        asm volatile(  //write rs2 value to rs1, increment rs1
            "p.sw   a5, 4(a4!)\n"
            : "+r"(rs1)
            : "r"(rs2)
            : "a4", "a5");
        result_rd = *(int32_t *)(0x10001100);
        result_rs1 = rs1;
        if (!((result_rd == 0x71) && (result_rs1 == 0x10001104))) {
            errs = errs + 1;
        }
        //////////
        //P_SB_RRPOST
        rs2 = 0x21;
        rs1 = 0x10001300;
        rd = 0x4;
        asm volatile(  //write rs2 value to rs1, increment rs1 by rs3
            "p.sb   a5, a3(a4!)\n"
            : "+r"(rs1)
            : "r"(rs2), "r"(rd)
            : "a3", "a4", "a5");
        result_rd = *(int8_t *)(0x10001300);
        result_rs1 = rs1;
        if (!((result_rd == 0x21) && (result_rs1 == 0x10001300 + rd))) {
            errs = errs + 1;
        }
        //////////
        //P_SH_RRPOST
        rs2 = 0x15;
        rs1 = 0x10002000;
        rd = 0x8;
        asm volatile(  //write rs2 value to rs1, increment rs1 by rs3
            "p.sh   a5, a3(a4!)\n"
            : "+r"(rs1)
            : "r"(rs2), "r"(rd)
            : "a3", "a4", "a5");
        result_rd = *(int16_t *)(0x10002000);
        result_rs1 = rs1;
        if (!((result_rd == 0x15) && (result_rs1 == 0x10002000 + rd))) {
            errs = errs + 1;
        }
        /////////
        //P_SW_RRPOST
        rs2 = 0x57;
        rs1 = 0x10002500;
        rd = 0x100;
        asm volatile(  //write rs2 value to rs1, increment rs1 by rs3
            "p.sw   a5, a3(a4!)\n"
            : "+r"(rs1)
            : "r"(rs2), "r"(rd)
            : "a3", "a4", "a5");
        result_rd = *(int32_t *)(0x10002500);
        result_rs1 = rs1;
        if (!((result_rd == 0x57) && (result_rs1 == 0x10002500 + rd))) {
            errs = errs + 1;
        }
        /////////
        //P_SB_RR
        rs2 = 0x23;
        rs1 = 0x10002800;
        rd = 0x100;
        asm volatile(  //write rs2 value to rs1, increment rs1 by rs3
            "p.sb   a5, a3(a4)\n"
            :
            : "r"(rs2), "+r"(rs1), "r"(rd)
            : "a3", "a4", "a5");
        result_rd = *(int8_t *)(0x10002900);
        result_rs1 = rs1;
        if (!((result_rd == 0x23) && (result_rs1 == 0x10002800))) {
            errs = errs + 1;
        }
        /////////
        //P_SH_RR
        rs2 = 0x18;
        rs1 = 0x10002000;
        rd = 0x80;
        asm volatile(  //write rs2 value to rs1, increment rs1 by rs3
            "p.sh   a5, a3(a4)\n"
            :
            : "r"(rs2), "+r"(rs1), "r"(rd)
            : "a3", "a4", "a5");
        result_rd = *(int16_t *)(0x10002080);
        result_rs1 = rs1;
        if (!((result_rd == 0x18) && (result_rs1 == 0x10002000))) {
            errs = errs + 1;
        }
        /////////
        //P_SW_RR
        rs2 = 0x98;
        rs1 = 0x10009000;
        rd = 0x20;
        asm volatile(  //write rs2 value to rs1, increment rs1 by rs3
            "p.sw   a5, a3(a4)\n"
            :
            : "r"(rs2), "+r"(rs1), "r"(rd)
            : "a3", "a4", "a5");
        result_rd = *(int32_t *)(0x10009020);
        result_rs1 = rs1;
        if (!((result_rd == 0x98) && (result_rs1 == 0x10009000))) {
            errs = errs + 1;
        }

        return errs;
    } else
        return 0;
    snrt_cluster_hw_barrier();
#endif
    return 0;
}
