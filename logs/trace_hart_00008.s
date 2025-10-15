             22000    0x18020000 auipc t0, 0                    #; (wrb) t0  <-- 0x18020000
             35000    0x18020004 addi t0, t0, 32                #; t0  = 0x18020000, (wrb) t0  <-- 0x18020020
             48000    0x18020008 csrw mtvec, t0                 #; t0  = 0x18020020
             61000    0x1802000c csrsi mstatus, 8               #; mstatus = 0x80006000
             76000    0x18020010 lui t0, 128                    #; (wrb) t0  <-- 0x00080000
             89000    0x18020014 addi t0, t0, 8                 #; t0  = 0x00080000, (wrb) t0  <-- 0x00080008
            102000    0x18020018 csrw mie, t0                   #; t0  = 0x00080008
            115000    0x1802001c wfi                            #; 
            323000    0x18020020 auipc t0, 0                    #; exception, goto 0x18020020
            336000    0x18020020 auipc t0, 0                    #; (wrb) t0  <-- 0x18020020
            349000    0x18020024 lui t1, 1                      #; (wrb) t1  <-- 4096
            362000    0x18020028 addi t1, t1, 360               #; t1  = 4096, (wrb) t1  <-- 4456
            377000    0x1802002c add t0, t0, t1                 #; t0  = 0x18020020, t1  = 4456, (wrb) t0  <-- 0x18021188
            390000    0x18020030 lw t0, 0(t0)                   #; t0  = 0x18021188, t0  <~~ Word[0x18021188]
            397000                                              #; (lsu) t0  <-- 0x80000000
            403000    0x18020034 jalr t0                        #; t0  = 0x80000000, (wrb) ra  <-- 0x18020038, goto 0x80000000
#; _start (start.S:12)
#;   mv t0, x0
            417000    0x80000000 li t0, 0                       #; (wrb) t0  <-- 0
#; _start (start.S:13)
#;   mv t1, x0
            418000    0x80000004 li t1, 0                       #; (wrb) t1  <-- 0
#; _start (start.S:14)
#;   mv t2, x0
            419000    0x80000008 li t2, 0                       #; (wrb) t2  <-- 0
#; _start (start.S:15)
#;   mv t3, x0
            420000    0x8000000c li t3, 0                       #; (wrb) t3  <-- 0
#; _start (start.S:16)
#;   mv t4, x0
            421000    0x80000010 li t4, 0                       #; (wrb) t4  <-- 0
#; _start (start.S:17)
#;   mv t5, x0
            422000    0x80000014 li t5, 0                       #; (wrb) t5  <-- 0
#; _start (start.S:18)
#;   mv t6, x0
            423000    0x80000018 li t6, 0                       #; (wrb) t6  <-- 0
#; _start (start.S:19)
#;   mv a0, x0
            424000    0x8000001c li a0, 0                       #; (wrb) a0  <-- 0
#; _start (start.S:20)
#;   mv a1, x0
            425000    0x80000020 li a1, 0                       #; (wrb) a1  <-- 0
#; _start (start.S:21)
#;   mv a2, x0
            426000    0x80000024 li a2, 0                       #; (wrb) a2  <-- 0
#; _start (start.S:22)
#;   mv a3, x0
            427000    0x80000028 li a3, 0                       #; (wrb) a3  <-- 0
#; _start (start.S:23)
#;   mv a4, x0
            428000    0x8000002c li a4, 0                       #; (wrb) a4  <-- 0
#; _start (start.S:24)
#;   mv a5, x0
            429000    0x80000030 li a5, 0                       #; (wrb) a5  <-- 0
#; _start (start.S:25)
#;   mv a6, x0
            430000    0x80000034 li a6, 0                       #; (wrb) a6  <-- 0
#; _start (start.S:26)
#;   mv a7, x0
            431000    0x80000038 li a7, 0                       #; (wrb) a7  <-- 0
#; _start (start.S:27)
#;   mv s0, x0
            432000    0x8000003c li s0, 0                       #; (wrb) s0  <-- 0
#; _start (start.S:28)
#;   mv s1, x0
            433000    0x80000040 li s1, 0                       #; (wrb) s1  <-- 0
#; _start (start.S:29)
#;   mv s2, x0
            434000    0x80000044 li s2, 0                       #; (wrb) s2  <-- 0
#; _start (start.S:30)
#;   mv s3, x0
            435000    0x80000048 li s3, 0                       #; (wrb) s3  <-- 0
#; _start (start.S:31)
#;   mv s4, x0
            436000    0x8000004c li s4, 0                       #; (wrb) s4  <-- 0
#; _start (start.S:32)
#;   mv s5, x0
            437000    0x80000050 li s5, 0                       #; (wrb) s5  <-- 0
#; _start (start.S:33)
#;   mv s6, x0
            438000    0x80000054 li s6, 0                       #; (wrb) s6  <-- 0
#; _start (start.S:34)
#;   mv s7, x0
            439000    0x80000058 li s7, 0                       #; (wrb) s7  <-- 0
#; _start (start.S:35)
#;   mv s8, x0
            440000    0x8000005c li s8, 0                       #; (wrb) s8  <-- 0
#; _start (start.S:36)
#;   mv s9, x0
            441000    0x80000060 li s9, 0                       #; (wrb) s9  <-- 0
#; _start (start.S:37)
#;   mv s10, x0
            442000    0x80000064 li s10, 0                      #; (wrb) s10 <-- 0
#; _start (start.S:38)
#;   mv s11, x0
            443000    0x80000068 li s11, 0                      #; (wrb) s11 <-- 0
#; snrt.crt0.init_fp_registers (start.S:44)
#;   csrr    t0, misa
            444000    0x8000006c csrr t0, misa                  #; misa = 0x40801129, (wrb) t0  <-- 0x40801129
#; snrt.crt0.init_fp_registers (start.S:45)
#;   andi    t0, t0, (1 << 3) | (1 << 5) # D/F - single/double precision float extension
            445000    0x80000070 andi t0, t0, 40                #; t0  = 0x40801129, (wrb) t0  <-- 40
#; snrt.crt0.init_fp_registers (start.S:46)
#;   beqz    t0, 3f
            446000    0x80000074 beqz t0, 132                   #; t0  = 40, not taken
#; snrt.crt0.init_fp_registers (start.S:48)
#;   fcvt.d.w f0, zero
            448000    0x80000078 fcvt.d.w ft0, zero             #; ac1  = 0
#; snrt.crt0.init_fp_registers (start.S:49)
#;   fcvt.d.w f1, zero
            449000    0x8000007c fcvt.d.w ft1, zero             #; ac1  = 0
#; snrt.crt0.init_fp_registers (start.S:50)
#;   fcvt.d.w f2, zero
            450000    0x80000080 fcvt.d.w ft2, zero             #; ac1  = 0, (f:fpu) ft0  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:51)
#;   fcvt.d.w f3, zero
            451000    0x80000084 fcvt.d.w ft3, zero             #; ac1  = 0, (f:fpu) ft1  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:52)
#;   fcvt.d.w f4, zero
            452000    0x80000088 fcvt.d.w ft4, zero             #; ac1  = 0, (f:fpu) ft2  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:53)
#;   fcvt.d.w f5, zero
            453000    0x8000008c fcvt.d.w ft5, zero             #; ac1  = 0, (f:fpu) ft3  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:54)
#;   fcvt.d.w f6, zero
            454000    0x80000090 fcvt.d.w ft6, zero             #; ac1  = 0, (f:fpu) ft4  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:55)
#;   fcvt.d.w f7, zero
            455000    0x80000094 fcvt.d.w ft7, zero             #; ac1  = 0, (f:fpu) ft5  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:56)
#;   fcvt.d.w f8, zero
            456000    0x80000098 fcvt.d.w fs0, zero             #; ac1  = 0, (f:fpu) ft6  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:57)
#;   fcvt.d.w f9, zero
            457000    0x8000009c fcvt.d.w fs1, zero             #; ac1  = 0, (f:fpu) ft7  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:58)
#;   fcvt.d.w f10, zero
            458000    0x800000a0 fcvt.d.w fa0, zero             #; ac1  = 0, (f:fpu) fs0  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:59)
#;   fcvt.d.w f11, zero
            459000    0x800000a4 fcvt.d.w fa1, zero             #; ac1  = 0, (f:fpu) fs1  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:60)
#;   fcvt.d.w f12, zero
            460000    0x800000a8 fcvt.d.w fa2, zero             #; ac1  = 0, (f:fpu) fa0  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:61)
#;   fcvt.d.w f13, zero
            461000    0x800000ac fcvt.d.w fa3, zero             #; ac1  = 0, (f:fpu) fa1  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:62)
#;   fcvt.d.w f14, zero
            462000    0x800000b0 fcvt.d.w fa4, zero             #; ac1  = 0, (f:fpu) fa2  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:63)
#;   fcvt.d.w f15, zero
            463000    0x800000b4 fcvt.d.w fa5, zero             #; ac1  = 0, (f:fpu) fa3  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:64)
#;   fcvt.d.w f16, zero
            464000    0x800000b8 fcvt.d.w fa6, zero             #; ac1  = 0, (f:fpu) fa4  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:65)
#;   fcvt.d.w f17, zero
            465000    0x800000bc fcvt.d.w fa7, zero             #; ac1  = 0, (f:fpu) fa5  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:66)
#;   fcvt.d.w f18, zero
            466000    0x800000c0 fcvt.d.w fs2, zero             #; ac1  = 0, (f:fpu) fa6  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:67)
#;   fcvt.d.w f19, zero
            467000    0x800000c4 fcvt.d.w fs3, zero             #; ac1  = 0, (f:fpu) fa7  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:68)
#;   fcvt.d.w f20, zero
            468000    0x800000c8 fcvt.d.w fs4, zero             #; ac1  = 0, (f:fpu) fs2  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:69)
#;   fcvt.d.w f21, zero
            469000    0x800000cc fcvt.d.w fs5, zero             #; ac1  = 0, (f:fpu) fs3  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:70)
#;   fcvt.d.w f22, zero
            470000    0x800000d0 fcvt.d.w fs6, zero             #; ac1  = 0, (f:fpu) fs4  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:71)
#;   fcvt.d.w f23, zero
            471000    0x800000d4 fcvt.d.w fs7, zero             #; ac1  = 0, (f:fpu) fs5  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:72)
#;   fcvt.d.w f24, zero
            472000    0x800000d8 fcvt.d.w fs8, zero             #; ac1  = 0, (f:fpu) fs6  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:73)
#;   fcvt.d.w f25, zero
            473000    0x800000dc fcvt.d.w fs9, zero             #; ac1  = 0, (f:fpu) fs7  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:74)
#;   fcvt.d.w f26, zero
            474000    0x800000e0 fcvt.d.w fs10, zero            #; ac1  = 0, (f:fpu) fs8  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:75)
#;   fcvt.d.w f27, zero
            475000    0x800000e4 fcvt.d.w fs11, zero            #; ac1  = 0, (f:fpu) fs9  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:76)
#;   fcvt.d.w f28, zero
            476000    0x800000e8 fcvt.d.w ft8, zero             #; ac1  = 0, (f:fpu) fs10 <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:77)
#;   fcvt.d.w f29, zero
            477000    0x800000ec fcvt.d.w ft9, zero             #; ac1  = 0, (f:fpu) fs11 <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:78)
#;   fcvt.d.w f30, zero
            478000    0x800000f0 fcvt.d.w ft10, zero            #; ac1  = 0, (f:fpu) ft8  <-- 0.0
#; .Ltmp1 (start.S:88)
#;   1:  auipc   gp, %pcrel_hi(__global_pointer$)
            479000    0x800000f8 auipc gp, 6                    #; (wrb) gp  <-- 0x800060f8
#; snrt.crt0.init_fp_registers (start.S:79)
#;   fcvt.d.w f31, zero
                      0x800000f4 fcvt.d.w ft11, zero            #; ac1  = 0, (f:fpu) ft9  <-- 0.0
#; .Ltmp1 (start.S:89)
#;   addi    gp, gp, %pcrel_lo(1b)
            480000    0x800000fc addi gp, gp, 1520              #; gp  = 0x800060f8, (wrb) gp  <-- 0x800066e8
                                                                #; (f:fpu) ft10 <-- 0.0
#; snrt.crt0.init_core_info (start.S:98)
#;   csrr a0, mhartid
            481000    0x80000100 csrr a0, mhartid               #; mhartid = 8, (wrb) a0  <-- 8
                                                                #; (f:fpu) ft11 <-- 0.0
#; snrt.crt0.init_core_info (start.S:99)
#;   li   t0, SNRT_BASE_HARTID
            482000    0x80000104 li t0, 0                       #; (wrb) t0  <-- 0
#; snrt.crt0.init_core_info (start.S:100)
#;   sub  a0, a0, t0
            483000    0x80000108 sub a0, a0, t0                 #; a0  = 8, t0  = 0, (wrb) a0  <-- 8
#; snrt.crt0.init_core_info (start.S:101)
#;   li   a1, SNRT_CLUSTER_CORE_NUM
            484000    0x8000010c li a1, 9                       #; (wrb) a1  <-- 9
#; snrt.crt0.init_core_info (start.S:102)
#;   div  t0, a0, a1
            485000    0x80000110 div t0, a0, a1                 #; a0  = 8, a1  = 9
#; snrt.crt0.init_core_info (start.S:105)
#;   remu a0, a0, a1
            486000    0x80000114 remu a0, a0, a1                #; a0  = 8, a1  = 9
#; snrt.crt0.init_core_info (start.S:108)
#;   li   a2, SNRT_TCDM_START_ADDR
            487000    0x80000118 lui a2, 65536                  #; (wrb) a2  <-- 0x10000000
#; snrt.crt0.init_core_info (start.S:109)
#;   li   t1, SNRT_CLUSTER_OFFSET
            488000    0x8000011c li t1, 0                       #; (wrb) t1  <-- 0
            489000                                              #; (acc) t0  <-- 0
#; snrt.crt0.init_core_info (start.S:110)
#;   mul  t0, t1, t0
            490000    0x80000120 mul t0, t1, t0                 #; t1  = 0, t0  = 0
            492000                                              #; (acc) a0  <-- 8
            493000                                              #; (acc) t0  <-- 0
#; snrt.crt0.init_core_info (start.S:111)
#;   add  a2, a2, t0
            494000    0x80000124 add a2, a2, t0                 #; a2  = 0x10000000, t0  = 0, (wrb) a2  <-- 0x10000000
#; snrt.crt0.init_core_info (start.S:114)
#;   li   t0, SNRT_TCDM_SIZE
            495000    0x80000128 lui t0, 32                     #; (wrb) t0  <-- 0x00020000
#; snrt.crt0.init_core_info (start.S:115)
#;   add  a2, a2, t0
            496000    0x8000012c add a2, a2, t0                 #; a2  = 0x10000000, t0  = 0x00020000, (wrb) a2  <-- 0x10020000
#; .Lpcrel_hi0 (start.S:121)
#;   la        t0, __cdata_end
            497000    0x80000130 auipc t0, 6                    #; (wrb) t0  <-- 0x80006130
            498000    0x80000134 addi t0, t0, -600              #; t0  = 0x80006130, (wrb) t0  <-- 0x80005ed8
#; .Lpcrel_hi1 (start.S:122)
#;   la        t1, __cdata_start
            499000    0x80000138 auipc t1, 6                    #; (wrb) t1  <-- 0x80006138
            500000    0x8000013c addi t1, t1, -608              #; t1  = 0x80006138, (wrb) t1  <-- 0x80005ed8
#; .Lpcrel_hi1 (start.S:123)
#;   sub       t0, t0, t1
            501000    0x80000140 sub t0, t0, t1                 #; t0  = 0x80005ed8, t1  = 0x80005ed8, (wrb) t0  <-- 0
#; .Lpcrel_hi1 (start.S:124)
#;   sub       a2, a2, t0
            502000    0x80000144 sub a2, a2, t0                 #; a2  = 0x10020000, t0  = 0, (wrb) a2  <-- 0x10020000
#; .Lpcrel_hi2 (start.S:125)
#;   la        t0, __cbss_end
            503000    0x80000148 auipc t0, 6                    #; (wrb) t0  <-- 0x80006148
            504000    0x8000014c addi t0, t0, -592              #; t0  = 0x80006148, (wrb) t0  <-- 0x80005ef8
#; .Lpcrel_hi3 (start.S:126)
#;   la        t1, __cbss_start
            505000    0x80000150 auipc t1, 6                    #; (wrb) t1  <-- 0x80006150
            506000    0x80000154 addi t1, t1, -632              #; t1  = 0x80006150, (wrb) t1  <-- 0x80005ed8
#; .Lpcrel_hi3 (start.S:127)
#;   sub       t0, t0, t1
            507000    0x80000158 sub t0, t0, t1                 #; t0  = 0x80005ef8, t1  = 0x80005ed8, (wrb) t0  <-- 32
#; .Lpcrel_hi3 (start.S:128)
#;   sub       a2, a2, t0
            508000    0x8000015c sub a2, a2, t0                 #; a2  = 0x10020000, t0  = 32, (wrb) a2  <-- 0x1001ffe0
#; snrt.crt0.init_stack (start.S:135)
#;   addi      a2, a2, -8
            509000    0x80000160 addi a2, a2, -8                #; a2  = 0x1001ffe0, (wrb) a2  <-- 0x1001ffd8
#; snrt.crt0.init_stack (start.S:136)
#;   sw        zero, 0(a2)
            510000    0x80000164 sw zero, 0(a2)                 #; a2  = 0x1001ffd8, 0 ~~> Word[0x1001ffd8]
#; snrt.crt0.init_stack (start.S:140)
#;   sll       t0, a0, SNRT_LOG2_STACK_SIZE
            511000    0x80000168 slli t0, a0, 10                #; a0  = 8, (wrb) t0  <-- 8192
#; snrt.crt0.init_stack (start.S:143)
#;   sub       sp, a2, t0
            512000    0x8000016c sub sp, a2, t0                 #; a2  = 0x1001ffd8, t0  = 8192, (wrb) sp  <-- 0x1001dfd8
#; snrt.crt0.init_stack (start.S:146)
#;   slli      t0, a0, 3  # this hart
            513000    0x80000170 slli t0, a0, 3                 #; a0  = 8, (wrb) t0  <-- 64
#; snrt.crt0.init_stack (start.S:147)
#;   slli      t1, a1, 3  # all harts
            514000    0x80000174 slli t1, a1, 3                 #; a1  = 9, (wrb) t1  <-- 72
#; snrt.crt0.init_stack (start.S:148)
#;   sub       sp, sp, t0
            515000    0x80000178 sub sp, sp, t0                 #; sp  = 0x1001dfd8, t0  = 64, (wrb) sp  <-- 0x1001df98
#; snrt.crt0.init_stack (start.S:149)
#;   sub       a2, a2, t1
            516000    0x8000017c sub a2, a2, t1                 #; a2  = 0x1001ffd8, t1  = 72, (wrb) a2  <-- 0x1001ff90
#; .Lpcrel_hi4 (start.S:155)
#;   la        t0, __tdata_end
            517000    0x80000180 auipc t0, 6                    #; (wrb) t0  <-- 0x80006180
            518000    0x80000184 addi t0, t0, -748              #; t0  = 0x80006180, (wrb) t0  <-- 0x80005e94
#; .Lpcrel_hi5 (start.S:156)
#;   la        t1, __tdata_start
            519000    0x80000188 auipc t1, 6                    #; (wrb) t1  <-- 0x80006188
            520000    0x8000018c addi t1, t1, -768              #; t1  = 0x80006188, (wrb) t1  <-- 0x80005e88
#; .Lpcrel_hi5 (start.S:157)
#;   sub       t0, t0, t1
            521000    0x80000190 sub t0, t0, t1                 #; t0  = 0x80005e94, t1  = 0x80005e88, (wrb) t0  <-- 12
#; .Lpcrel_hi5 (start.S:158)
#;   sub       sp, sp, t0
            522000    0x80000194 sub sp, sp, t0                 #; sp  = 0x1001df98, t0  = 12, (wrb) sp  <-- 0x1001df8c
#; .Lpcrel_hi6 (start.S:159)
#;   la        t0, __tbss_end
            523000    0x80000198 auipc t0, 6                    #; (wrb) t0  <-- 0x80006198
            524000    0x8000019c addi t0, t0, -704              #; t0  = 0x80006198, (wrb) t0  <-- 0x80005ed8
#; .Lpcrel_hi7 (start.S:160)
#;   la        t1, __tbss_start
            525000    0x800001a0 auipc t1, 6                    #; (wrb) t1  <-- 0x800061a0
            526000    0x800001a4 addi t1, t1, -776              #; t1  = 0x800061a0, (wrb) t1  <-- 0x80005e98
#; .Lpcrel_hi7 (start.S:161)
#;   sub       t0, t0, t1
            527000    0x800001a8 sub t0, t0, t1                 #; t0  = 0x80005ed8, t1  = 0x80005e98, (wrb) t0  <-- 64
#; .Lpcrel_hi7 (start.S:162)
#;   sub       sp, sp, t0
            528000    0x800001ac sub sp, sp, t0                 #; sp  = 0x1001df8c, t0  = 64, (wrb) sp  <-- 0x1001df4c
#; .Lpcrel_hi7 (start.S:163)
#;   andi      sp, sp, ~0x7 # align to 8B
            529000    0x800001b0 andi sp, sp, -8                #; sp  = 0x1001df4c, (wrb) sp  <-- 0x1001df48
#; .Lpcrel_hi7 (start.S:165)
#;   mv        tp, sp
            530000    0x800001b4 mv tp, sp                      #; sp  = 0x1001df48, (wrb) tp  <-- 0x1001df48
#; .Lpcrel_hi7 (start.S:167)
#;   andi      sp, sp, ~0x7 # align stack to 8B
            531000    0x800001b8 andi sp, sp, -8                #; sp  = 0x1001df48, (wrb) sp  <-- 0x1001df48
#; snrt.crt0.main (start.S:178)
#;   call snrt_main
            532000    0x800001bc auipc ra, 4                    #; (wrb) ra  <-- 0x800041bc
            533000    0x800001c0 jalr -1312(ra)                 #; ra  = 0x800041bc, (wrb) ra  <-- 0x800001c4, goto 0x80003c9c
#; snrt_main (start.c:204)
#;   EXTERN_C void snrt_main() {
            543000    0x80003c9c addi sp, sp, -64               #; sp  = 0x1001df48, (wrb) sp  <-- 0x1001df08
            544000    0x80003ca0 sw ra, 60(sp)                  #; sp  = 0x1001df08, 0x800001c4 ~~> Word[0x1001df44]
            545000    0x80003ca4 sw s0, 56(sp)                  #; sp  = 0x1001df08, 0 ~~> Word[0x1001df40]
            546000    0x80003ca8 sw s1, 52(sp)                  #; sp  = 0x1001df08, 0 ~~> Word[0x1001df3c]
            547000    0x80003cac sw s2, 48(sp)                  #; sp  = 0x1001df08, 0 ~~> Word[0x1001df38]
            548000    0x80003cb0 sw s3, 44(sp)                  #; sp  = 0x1001df08, 0 ~~> Word[0x1001df34]
            549000    0x80003cb4 sw s4, 40(sp)                  #; sp  = 0x1001df08, 0 ~~> Word[0x1001df30]
            550000    0x80003cb8 sw s5, 36(sp)                  #; sp  = 0x1001df08, 0 ~~> Word[0x1001df2c]
            551000    0x80003cbc sw s6, 32(sp)                  #; sp  = 0x1001df08, 0 ~~> Word[0x1001df28]
            556000    0x80003cc0 sw s7, 28(sp)                  #; sp  = 0x1001df08, 0 ~~> Word[0x1001df24]
            557000    0x80003cc4 sw s8, 24(sp)                  #; sp  = 0x1001df08, 0 ~~> Word[0x1001df20]
            558000    0x80003cc8 sw s9, 20(sp)                  #; sp  = 0x1001df08, 0 ~~> Word[0x1001df1c]
            559000    0x80003ccc sw s10, 16(sp)                 #; sp  = 0x1001df08, 0 ~~> Word[0x1001df18]
            560000    0x80003cd0 sw s11, 12(sp)                 #; sp  = 0x1001df08, 0 ~~> Word[0x1001df14]
            561000    0x80003cd4 li s0, -1                      #; (wrb) s0  <-- -1
#; snrt_main (start.c:206:9)
#;   snrt_cluster_idx (team.h:99:12)
#;     snrt_global_core_idx (team.h:80:12)
#;       snrt_hartid (team.h:25:5)
#;         asm("csrr %0, mhartid" : "=r"(hartid));
#;         ^
            562000    0x80003cd8 csrr s2, mhartid               #; mhartid = 8, (wrb) s2  <-- 8
            563000    0x80003cdc lui a0, 233017                 #; (wrb) a0  <-- 0x38e39000
            564000    0x80003ce0 addi a0, a0, -455              #; a0  = 0x38e39000, (wrb) a0  <-- 0x38e38e39
#; snrt_main (start.c:206:9)
#;   snrt_cluster_idx (team.h:99:35)
#;     return snrt_global_core_idx() / snrt_cluster_core_num();
#;                                   ^
            565000    0x80003ce4 mulhu a0, s2, a0               #; s2  = 8, a0  = 0x38e38e39
            567000                                              #; (acc) a0  <-- 1
            568000    0x80003ce8 srli a0, a0, 1                 #; a0  = 1, (wrb) a0  <-- 0
            569000    0x80003cec li a1, 8                       #; (wrb) a1  <-- 8
            570000    0x80003cf0 slli s3, a0, 18                #; a0  = 0, (wrb) s3  <-- 0
#; snrt_main (start.c:206:9)
#;   if (snrt_cluster_idx() == 0) {
#;       ^
            571000    0x80003cf4 bltu a1, s2, 184               #; a1  = 8, s2  = 8, not taken
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:31)
#;       snrt_cluster_core_idx (team.h:108:35)
#;         return snrt_global_core_idx() % snrt_cluster_core_num();
#;                                       ^
            572000    0x80003cf8 p.extbz s1, s2                 #; s2  = 8
            573000    0x80003cfc li a1, 57                      #; (wrb) a1  <-- 57
            574000                                              #; (acc) s1  <-- 8
            575000    0x80003d00 mul a1, s1, a1                 #; s1  = 8, a1  = 57
            577000                                              #; (acc) a1  <-- 456
            578000    0x80003d04 srli a1, a1, 9                 #; a1  = 456, (wrb) a1  <-- 0
            579000    0x80003d08 slli a2, a1, 3                 #; a1  = 0, (wrb) a2  <-- 0
            580000    0x80003d0c add a1, a2, a1                 #; a2  = 0, a1  = 0, (wrb) a1  <-- 0
            581000    0x80003d10 lui a2, 65569                  #; (wrb) a2  <-- 0x10021000
            582000    0x80003d14 addi a2, a2, 424               #; a2  = 0x10021000, (wrb) a2  <-- 0x100211a8
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:5)
#;       snrt_int_cluster_clr (cluster_interrupts.h:22:53)
#;         snrt_cluster()->peripheral_reg.cl_clint_clear.f.cl_clint_clear = mask;
#;                                                         ^
            583000    0x80003d18 add a2, s3, a2                 #; s3  = 0, a2  = 0x100211a8, (wrb) a2  <-- 0x100211a8
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:5)
#;       snrt_int_cluster_clr (cluster_interrupts.h:22:68)
#;         snrt_cluster()->peripheral_reg.cl_clint_clear.f.cl_clint_clear = mask;
#;                                                                        ^
            584000    0x80003d1c lw a3, 0(a2)                   #; a2  = 0x100211a8, a3  <~~ Word[0x100211a8]
            593000                                              #; (lsu) a3  <-- 0
            594000    0x80003d20 ori a3, a2, 4                  #; a2  = 0x100211a8, (wrb) a3  <-- 0x100211ac
            595000    0x80003d24 lw a4, 0(a3)                   #; a3  = 0x100211ac, a4  <~~ Word[0x100211ac]
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:31)
#;       snrt_cluster_core_idx (team.h:108:35)
#;         return snrt_global_core_idx() % snrt_cluster_core_num();
#;                                       ^
            596000    0x80003d28 sub a1, s2, a1                 #; s2  = 8, a1  = 0, (wrb) a1  <-- 8
            597000    0x80003d2c li a5, 1                       #; (wrb) a5  <-- 1
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:28)
#;       snrt_int_cluster_clr(1 << snrt_cluster_core_idx());
#;                              ^
            598000    0x80003d30 sll a1, a5, a1                 #; a5  = 1, a1  = 8, (wrb) a1  <-- 256
            621000                                              #; (lsu) a4  <-- 0
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:5)
#;       snrt_int_cluster_clr (cluster_interrupts.h:22:68)
#;         snrt_cluster()->peripheral_reg.cl_clint_clear.f.cl_clint_clear = mask;
#;                                                                        ^
            622000    0x80003d34 and a4, a4, s0                 #; a4  = 0, s0  = -1, (wrb) a4  <-- 0
            623000    0x80003d38 sw a4, 0(a3)                   #; a3  = 0x100211ac, 0 ~~> Word[0x100211ac]
            624000    0x80003d3c sw a1, 0(a2)                   #; a2  = 0x100211a8, 256 ~~> Word[0x100211a8]
            625000    0x80003d40 lui a1, 128                    #; (wrb) a1  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            626000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            627000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            628000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            629000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            630000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            631000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            632000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            633000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            634000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            635000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            636000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            637000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            638000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            639000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            640000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            641000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            642000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            643000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            644000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            645000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            646000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            647000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            648000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            649000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            650000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            651000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            652000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            653000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            654000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            655000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            656000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            657000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            658000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            659000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            660000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            661000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            662000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            663000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            664000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            665000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            666000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            667000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            668000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            669000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            670000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            671000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            672000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            673000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            674000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            675000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            676000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            677000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            678000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            679000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            680000    0x80003d44 csrr a2, mip                   #; mip = 0, (wrb) a2  <-- 0
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            681000    0x80003d48 and a2, a2, a1                 #; a2  = 0, a1  = 0x00080000, (wrb) a2  <-- 0
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            682000    0x80003d4c bnez a2, -8                    #; a2  = 0, not taken
            683000    0x80003d50 li a1, 9                       #; (wrb) a1  <-- 9
#; .LBB25_2 (start.c:215:5)
#;   snrt_init_bss (start.c:110:9)
#;     if (snrt_cluster_idx() == 0) {
#;         ^
            684000    0x80003d54 bgeu s2, a1, 88                #; s2  = 8, a1  = 9, not taken
#; .LBB25_21 (start.c:215:5)
#;   snrt_init_bss (start.c:112:9)
#;     memset((void*)&__bss_start, 0, size);
#;     ^
            685000    0x80003d58 auipc a0, 2                    #; (wrb) a0  <-- 0x80005d58
            686000    0x80003d5c addi a0, a0, 592               #; a0  = 0x80005d58, (wrb) a0  <-- 0x80005fa8
#; .LBB25_22 (start.c:215:5)
#;   snrt_init_bss (start.c:112:9)
#;     memset((void*)&__bss_start, 0, size);
#;     ^
            687000    0x80003d60 auipc a1, 2                    #; (wrb) a1  <-- 0x80005d60
            688000    0x80003d64 addi a1, a1, 1408              #; a1  = 0x80005d60, (wrb) a1  <-- 0x800062e0
            689000    0x80003d68 sub a2, a1, a0                 #; a1  = 0x800062e0, a0  = 0x80005fa8, (wrb) a2  <-- 824
            690000    0x80003d6c li a1, 0                       #; (wrb) a1  <-- 0
            691000    0x80003d70 auipc ra, 0                    #; (wrb) ra  <-- 0x80003d70
            692000    0x80003d74 jalr 1220(ra)                  #; ra  = 0x80003d70, (wrb) ra  <-- 0x80003d78, goto 0x80004234
#; memset (memset.S:30)
#;   li t1, 15
            700000    0x80004234 li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
            701000    0x80004238 mv a4, a0                      #; a0  = 0x80005fa8, (wrb) a4  <-- 0x80005fa8
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
            702000    0x8000423c bgeu t1, a2, 60                #; t1  = 15, a2  = 824, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
            711000    0x80004240 andi a5, a4, 15                #; a4  = 0x80005fa8, (wrb) a5  <-- 8
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
            712000    0x80004244 bnez a5, 160                   #; a5  = 8, taken, goto 0x800042e4
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
            725000    0x800042e4 slli a3, a5, 2                 #; a5  = 8, (wrb) a3  <-- 32
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
            726000    0x800042e8 auipc t0, 0                    #; (wrb) t0  <-- 0x800042e8
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
            727000    0x800042ec add a3, a3, t0                 #; a3  = 32, t0  = 0x800042e8, (wrb) a3  <-- 0x80004308
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
            728000    0x800042f0 mv t0, ra                      #; ra  = 0x80003d78, (wrb) t0  <-- 0x80003d78
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
            729000    0x800042f4 jalr -96(a3)                   #; a3  = 0x80004308, (wrb) ra  <-- 0x800042f8, goto 0x800042a8
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
            750000    0x800042a8 sb a1, 7(a4)                   #; a4  = 0x80005fa8, 0 ~~> Byte[0x80005faf]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
            751000    0x800042ac sb a1, 6(a4)                   #; a4  = 0x80005fa8, 0 ~~> Byte[0x80005fae]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
            762000    0x800042b0 sb a1, 5(a4)                   #; a4  = 0x80005fa8, 0 ~~> Byte[0x80005fad]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
            803000    0x800042b4 sb a1, 4(a4)                   #; a4  = 0x80005fa8, 0 ~~> Byte[0x80005fac]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
            852000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x80005fa8, 0 ~~> Byte[0x80005fab]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
            893000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x80005fa8, 0 ~~> Byte[0x80005faa]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
            942000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x80005fa8, 0 ~~> Byte[0x80005fa9]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
            983000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x80005fa8, 0 ~~> Byte[0x80005fa8]
#; .Ltable (memset.S:85)
#;   ret
            984000    0x800042c8 ret                            #; ra  = 0x800042f8, goto 0x800042f8
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
            985000    0x800042f8 mv ra, t0                      #; t0  = 0x80003d78, (wrb) ra  <-- 0x80003d78
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
            986000    0x800042fc addi a5, a5, -16               #; a5  = 8, (wrb) a5  <-- -8
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
            987000    0x80004300 sub a4, a4, a5                 #; a4  = 0x80005fa8, a5  = -8, (wrb) a4  <-- 0x80005fb0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
            988000    0x80004304 add a2, a2, a5                 #; a2  = 824, a5  = -8, (wrb) a2  <-- 816
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
            989000    0x80004308 bgeu t1, a2, -144              #; t1  = 15, a2  = 816, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
            990000    0x8000430c j -196                         #; goto 0x80004248
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
            991000    0x80004248 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
            992000    0x8000424c andi a3, a2, -16               #; a2  = 816, (wrb) a3  <-- 816
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
            993000    0x80004250 andi a2, a2, 15                #; a2  = 816, (wrb) a2  <-- 0
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
            994000    0x80004254 add a3, a3, a4                 #; a3  = 816, a4  = 0x80005fb0, (wrb) a3  <-- 0x800062e0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           1032000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80005fb0, 0 ~~> Word[0x80005fb0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           1073000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80005fb0, 0 ~~> Word[0x80005fb4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           1122000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80005fb0, 0 ~~> Word[0x80005fb8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           1163000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80005fb0, 0 ~~> Word[0x80005fbc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           1164000    0x80004268 addi a4, a4, 16                #; a4  = 0x80005fb0, (wrb) a4  <-- 0x80005fc0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           1165000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80005fc0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           1212000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80005fc0, 0 ~~> Word[0x80005fc0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           1253000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80005fc0, 0 ~~> Word[0x80005fc4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           1302000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80005fc0, 0 ~~> Word[0x80005fc8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           1343000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80005fc0, 0 ~~> Word[0x80005fcc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           1344000    0x80004268 addi a4, a4, 16                #; a4  = 0x80005fc0, (wrb) a4  <-- 0x80005fd0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           1345000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80005fd0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           1392000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80005fd0, 0 ~~> Word[0x80005fd0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           1433000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80005fd0, 0 ~~> Word[0x80005fd4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           1482000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80005fd0, 0 ~~> Word[0x80005fd8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           1523000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80005fd0, 0 ~~> Word[0x80005fdc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           1524000    0x80004268 addi a4, a4, 16                #; a4  = 0x80005fd0, (wrb) a4  <-- 0x80005fe0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           1525000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80005fe0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           1572000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80005fe0, 0 ~~> Word[0x80005fe0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           1613000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80005fe0, 0 ~~> Word[0x80005fe4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           1662000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80005fe0, 0 ~~> Word[0x80005fe8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           1703000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80005fe0, 0 ~~> Word[0x80005fec]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           1704000    0x80004268 addi a4, a4, 16                #; a4  = 0x80005fe0, (wrb) a4  <-- 0x80005ff0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           1705000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80005ff0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           1752000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80005ff0, 0 ~~> Word[0x80005ff0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           1793000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80005ff0, 0 ~~> Word[0x80005ff4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           1842000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80005ff0, 0 ~~> Word[0x80005ff8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           1883000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80005ff0, 0 ~~> Word[0x80005ffc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           1884000    0x80004268 addi a4, a4, 16                #; a4  = 0x80005ff0, (wrb) a4  <-- 0x80006000
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           1885000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006000, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           1932000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006000, 0 ~~> Word[0x80006000]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           1973000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006000, 0 ~~> Word[0x80006004]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2022000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006000, 0 ~~> Word[0x80006008]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2063000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006000, 0 ~~> Word[0x8000600c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2064000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006000, (wrb) a4  <-- 0x80006010
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2065000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006010, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2112000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006010, 0 ~~> Word[0x80006010]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2153000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006010, 0 ~~> Word[0x80006014]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2202000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006010, 0 ~~> Word[0x80006018]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2243000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006010, 0 ~~> Word[0x8000601c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2244000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006010, (wrb) a4  <-- 0x80006020
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2245000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006020, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2292000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006020, 0 ~~> Word[0x80006020]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2333000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006020, 0 ~~> Word[0x80006024]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2382000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006020, 0 ~~> Word[0x80006028]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2423000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006020, 0 ~~> Word[0x8000602c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2424000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006020, (wrb) a4  <-- 0x80006030
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2425000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006030, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2472000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006030, 0 ~~> Word[0x80006030]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2513000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006030, 0 ~~> Word[0x80006034]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2562000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006030, 0 ~~> Word[0x80006038]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2603000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006030, 0 ~~> Word[0x8000603c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2604000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006030, (wrb) a4  <-- 0x80006040
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2605000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006040, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2652000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006040, 0 ~~> Word[0x80006040]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2693000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006040, 0 ~~> Word[0x80006044]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2742000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006040, 0 ~~> Word[0x80006048]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2783000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006040, 0 ~~> Word[0x8000604c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2784000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006040, (wrb) a4  <-- 0x80006050
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2785000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006050, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2832000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006050, 0 ~~> Word[0x80006050]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2873000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006050, 0 ~~> Word[0x80006054]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2922000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006050, 0 ~~> Word[0x80006058]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2963000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006050, 0 ~~> Word[0x8000605c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2964000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006050, (wrb) a4  <-- 0x80006060
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2965000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006060, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           3012000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006060, 0 ~~> Word[0x80006060]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           3053000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006060, 0 ~~> Word[0x80006064]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           3102000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006060, 0 ~~> Word[0x80006068]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           3143000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006060, 0 ~~> Word[0x8000606c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           3144000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006060, (wrb) a4  <-- 0x80006070
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           3145000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006070, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           3192000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006070, 0 ~~> Word[0x80006070]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           3233000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006070, 0 ~~> Word[0x80006074]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           3282000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006070, 0 ~~> Word[0x80006078]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           3323000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006070, 0 ~~> Word[0x8000607c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           3324000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006070, (wrb) a4  <-- 0x80006080
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           3325000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006080, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           3372000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006080, 0 ~~> Word[0x80006080]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           3413000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006080, 0 ~~> Word[0x80006084]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           3462000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006080, 0 ~~> Word[0x80006088]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           3503000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006080, 0 ~~> Word[0x8000608c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           3504000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006080, (wrb) a4  <-- 0x80006090
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           3505000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006090, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           3552000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006090, 0 ~~> Word[0x80006090]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           3593000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006090, 0 ~~> Word[0x80006094]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           3642000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006090, 0 ~~> Word[0x80006098]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           3683000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006090, 0 ~~> Word[0x8000609c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           3684000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006090, (wrb) a4  <-- 0x800060a0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           3685000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800060a0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           3732000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800060a0, 0 ~~> Word[0x800060a0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           3773000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800060a0, 0 ~~> Word[0x800060a4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           3822000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800060a0, 0 ~~> Word[0x800060a8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           3863000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800060a0, 0 ~~> Word[0x800060ac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           3864000    0x80004268 addi a4, a4, 16                #; a4  = 0x800060a0, (wrb) a4  <-- 0x800060b0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           3865000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800060b0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           3912000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800060b0, 0 ~~> Word[0x800060b0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           3953000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800060b0, 0 ~~> Word[0x800060b4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           4002000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800060b0, 0 ~~> Word[0x800060b8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           4043000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800060b0, 0 ~~> Word[0x800060bc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           4044000    0x80004268 addi a4, a4, 16                #; a4  = 0x800060b0, (wrb) a4  <-- 0x800060c0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           4045000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800060c0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           4092000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800060c0, 0 ~~> Word[0x800060c0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           4133000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800060c0, 0 ~~> Word[0x800060c4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           4182000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800060c0, 0 ~~> Word[0x800060c8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           4223000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800060c0, 0 ~~> Word[0x800060cc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           4224000    0x80004268 addi a4, a4, 16                #; a4  = 0x800060c0, (wrb) a4  <-- 0x800060d0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           4225000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800060d0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           4272000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800060d0, 0 ~~> Word[0x800060d0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           4313000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800060d0, 0 ~~> Word[0x800060d4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           4362000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800060d0, 0 ~~> Word[0x800060d8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           4403000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800060d0, 0 ~~> Word[0x800060dc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           4404000    0x80004268 addi a4, a4, 16                #; a4  = 0x800060d0, (wrb) a4  <-- 0x800060e0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           4405000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800060e0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           4452000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800060e0, 0 ~~> Word[0x800060e0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           4493000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800060e0, 0 ~~> Word[0x800060e4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           4542000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800060e0, 0 ~~> Word[0x800060e8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           4583000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800060e0, 0 ~~> Word[0x800060ec]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           4584000    0x80004268 addi a4, a4, 16                #; a4  = 0x800060e0, (wrb) a4  <-- 0x800060f0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           4585000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800060f0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           4632000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800060f0, 0 ~~> Word[0x800060f0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           4673000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800060f0, 0 ~~> Word[0x800060f4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           4722000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800060f0, 0 ~~> Word[0x800060f8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           4763000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800060f0, 0 ~~> Word[0x800060fc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           4764000    0x80004268 addi a4, a4, 16                #; a4  = 0x800060f0, (wrb) a4  <-- 0x80006100
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           4765000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006100, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           4812000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006100, 0 ~~> Word[0x80006100]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           4853000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006100, 0 ~~> Word[0x80006104]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           4902000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006100, 0 ~~> Word[0x80006108]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           4943000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006100, 0 ~~> Word[0x8000610c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           4944000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006100, (wrb) a4  <-- 0x80006110
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           4945000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006110, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           4992000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006110, 0 ~~> Word[0x80006110]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           5033000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006110, 0 ~~> Word[0x80006114]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           5082000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006110, 0 ~~> Word[0x80006118]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           5123000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006110, 0 ~~> Word[0x8000611c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           5124000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006110, (wrb) a4  <-- 0x80006120
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           5125000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006120, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           5172000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006120, 0 ~~> Word[0x80006120]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           5213000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006120, 0 ~~> Word[0x80006124]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           5262000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006120, 0 ~~> Word[0x80006128]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           5303000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006120, 0 ~~> Word[0x8000612c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           5304000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006120, (wrb) a4  <-- 0x80006130
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           5305000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006130, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           5352000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006130, 0 ~~> Word[0x80006130]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           5393000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006130, 0 ~~> Word[0x80006134]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           5442000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006130, 0 ~~> Word[0x80006138]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           5483000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006130, 0 ~~> Word[0x8000613c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           5484000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006130, (wrb) a4  <-- 0x80006140
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           5485000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006140, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           5532000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006140, 0 ~~> Word[0x80006140]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           5573000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006140, 0 ~~> Word[0x80006144]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           5622000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006140, 0 ~~> Word[0x80006148]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           5663000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006140, 0 ~~> Word[0x8000614c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           5664000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006140, (wrb) a4  <-- 0x80006150
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           5665000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006150, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           5712000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006150, 0 ~~> Word[0x80006150]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           5753000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006150, 0 ~~> Word[0x80006154]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           5802000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006150, 0 ~~> Word[0x80006158]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           5843000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006150, 0 ~~> Word[0x8000615c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           5844000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006150, (wrb) a4  <-- 0x80006160
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           5845000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006160, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           5892000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006160, 0 ~~> Word[0x80006160]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           5933000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006160, 0 ~~> Word[0x80006164]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           5982000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006160, 0 ~~> Word[0x80006168]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6023000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006160, 0 ~~> Word[0x8000616c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6024000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006160, (wrb) a4  <-- 0x80006170
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6025000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006170, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6072000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006170, 0 ~~> Word[0x80006170]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           6113000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006170, 0 ~~> Word[0x80006174]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           6162000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006170, 0 ~~> Word[0x80006178]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6203000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006170, 0 ~~> Word[0x8000617c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6204000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006170, (wrb) a4  <-- 0x80006180
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6205000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006180, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6252000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006180, 0 ~~> Word[0x80006180]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           6293000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006180, 0 ~~> Word[0x80006184]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           6342000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006180, 0 ~~> Word[0x80006188]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6383000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006180, 0 ~~> Word[0x8000618c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6384000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006180, (wrb) a4  <-- 0x80006190
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6385000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006190, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6432000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006190, 0 ~~> Word[0x80006190]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           6473000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006190, 0 ~~> Word[0x80006194]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           6522000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006190, 0 ~~> Word[0x80006198]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6563000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006190, 0 ~~> Word[0x8000619c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6564000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006190, (wrb) a4  <-- 0x800061a0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6565000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800061a0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6612000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800061a0, 0 ~~> Word[0x800061a0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           6653000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800061a0, 0 ~~> Word[0x800061a4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           6702000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800061a0, 0 ~~> Word[0x800061a8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6743000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800061a0, 0 ~~> Word[0x800061ac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6744000    0x80004268 addi a4, a4, 16                #; a4  = 0x800061a0, (wrb) a4  <-- 0x800061b0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6745000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800061b0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6792000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800061b0, 0 ~~> Word[0x800061b0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           6833000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800061b0, 0 ~~> Word[0x800061b4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           6882000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800061b0, 0 ~~> Word[0x800061b8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6923000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800061b0, 0 ~~> Word[0x800061bc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6924000    0x80004268 addi a4, a4, 16                #; a4  = 0x800061b0, (wrb) a4  <-- 0x800061c0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6925000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800061c0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6972000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800061c0, 0 ~~> Word[0x800061c0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           7013000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800061c0, 0 ~~> Word[0x800061c4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           7062000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800061c0, 0 ~~> Word[0x800061c8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           7103000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800061c0, 0 ~~> Word[0x800061cc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           7104000    0x80004268 addi a4, a4, 16                #; a4  = 0x800061c0, (wrb) a4  <-- 0x800061d0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           7105000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800061d0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           7152000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800061d0, 0 ~~> Word[0x800061d0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           7193000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800061d0, 0 ~~> Word[0x800061d4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           7242000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800061d0, 0 ~~> Word[0x800061d8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           7283000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800061d0, 0 ~~> Word[0x800061dc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           7284000    0x80004268 addi a4, a4, 16                #; a4  = 0x800061d0, (wrb) a4  <-- 0x800061e0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           7285000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800061e0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           7332000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800061e0, 0 ~~> Word[0x800061e0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           7373000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800061e0, 0 ~~> Word[0x800061e4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           7422000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800061e0, 0 ~~> Word[0x800061e8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           7463000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800061e0, 0 ~~> Word[0x800061ec]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           7464000    0x80004268 addi a4, a4, 16                #; a4  = 0x800061e0, (wrb) a4  <-- 0x800061f0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           7465000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800061f0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           7512000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800061f0, 0 ~~> Word[0x800061f0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           7553000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800061f0, 0 ~~> Word[0x800061f4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           7602000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800061f0, 0 ~~> Word[0x800061f8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           7643000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800061f0, 0 ~~> Word[0x800061fc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           7644000    0x80004268 addi a4, a4, 16                #; a4  = 0x800061f0, (wrb) a4  <-- 0x80006200
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           7645000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006200, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           7692000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006200, 0 ~~> Word[0x80006200]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           7733000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006200, 0 ~~> Word[0x80006204]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           7782000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006200, 0 ~~> Word[0x80006208]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           7823000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006200, 0 ~~> Word[0x8000620c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           7824000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006200, (wrb) a4  <-- 0x80006210
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           7825000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006210, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           7872000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006210, 0 ~~> Word[0x80006210]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           7913000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006210, 0 ~~> Word[0x80006214]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           7962000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006210, 0 ~~> Word[0x80006218]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           8003000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006210, 0 ~~> Word[0x8000621c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           8004000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006210, (wrb) a4  <-- 0x80006220
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           8005000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006220, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           8052000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006220, 0 ~~> Word[0x80006220]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           8093000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006220, 0 ~~> Word[0x80006224]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           8142000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006220, 0 ~~> Word[0x80006228]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           8183000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006220, 0 ~~> Word[0x8000622c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           8184000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006220, (wrb) a4  <-- 0x80006230
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           8185000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006230, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           8232000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006230, 0 ~~> Word[0x80006230]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           8273000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006230, 0 ~~> Word[0x80006234]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           8322000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006230, 0 ~~> Word[0x80006238]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           8363000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006230, 0 ~~> Word[0x8000623c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           8364000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006230, (wrb) a4  <-- 0x80006240
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           8365000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006240, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           8412000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006240, 0 ~~> Word[0x80006240]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           8453000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006240, 0 ~~> Word[0x80006244]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           8502000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006240, 0 ~~> Word[0x80006248]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           8543000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006240, 0 ~~> Word[0x8000624c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           8544000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006240, (wrb) a4  <-- 0x80006250
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           8545000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006250, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           8592000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006250, 0 ~~> Word[0x80006250]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           8633000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006250, 0 ~~> Word[0x80006254]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           8682000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006250, 0 ~~> Word[0x80006258]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           8723000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006250, 0 ~~> Word[0x8000625c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           8724000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006250, (wrb) a4  <-- 0x80006260
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           8725000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006260, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           8772000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006260, 0 ~~> Word[0x80006260]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           8813000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006260, 0 ~~> Word[0x80006264]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           8862000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006260, 0 ~~> Word[0x80006268]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           8903000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006260, 0 ~~> Word[0x8000626c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           8904000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006260, (wrb) a4  <-- 0x80006270
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           8905000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006270, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           8952000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006270, 0 ~~> Word[0x80006270]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           8993000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006270, 0 ~~> Word[0x80006274]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           9042000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006270, 0 ~~> Word[0x80006278]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           9083000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006270, 0 ~~> Word[0x8000627c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           9084000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006270, (wrb) a4  <-- 0x80006280
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           9085000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006280, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           9132000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006280, 0 ~~> Word[0x80006280]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           9173000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006280, 0 ~~> Word[0x80006284]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           9222000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006280, 0 ~~> Word[0x80006288]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           9263000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006280, 0 ~~> Word[0x8000628c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           9264000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006280, (wrb) a4  <-- 0x80006290
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           9265000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006290, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           9312000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006290, 0 ~~> Word[0x80006290]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           9353000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006290, 0 ~~> Word[0x80006294]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           9402000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006290, 0 ~~> Word[0x80006298]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           9443000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006290, 0 ~~> Word[0x8000629c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           9444000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006290, (wrb) a4  <-- 0x800062a0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           9445000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800062a0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           9492000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800062a0, 0 ~~> Word[0x800062a0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           9533000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800062a0, 0 ~~> Word[0x800062a4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           9582000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800062a0, 0 ~~> Word[0x800062a8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           9623000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800062a0, 0 ~~> Word[0x800062ac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           9624000    0x80004268 addi a4, a4, 16                #; a4  = 0x800062a0, (wrb) a4  <-- 0x800062b0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           9625000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800062b0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           9672000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800062b0, 0 ~~> Word[0x800062b0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           9713000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800062b0, 0 ~~> Word[0x800062b4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           9762000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800062b0, 0 ~~> Word[0x800062b8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           9803000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800062b0, 0 ~~> Word[0x800062bc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           9804000    0x80004268 addi a4, a4, 16                #; a4  = 0x800062b0, (wrb) a4  <-- 0x800062c0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           9805000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800062c0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           9852000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800062c0, 0 ~~> Word[0x800062c0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           9893000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800062c0, 0 ~~> Word[0x800062c4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           9942000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800062c0, 0 ~~> Word[0x800062c8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           9983000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800062c0, 0 ~~> Word[0x800062cc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           9984000    0x80004268 addi a4, a4, 16                #; a4  = 0x800062c0, (wrb) a4  <-- 0x800062d0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           9985000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800062d0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          10032000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800062d0, 0 ~~> Word[0x800062d0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          10073000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800062d0, 0 ~~> Word[0x800062d4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          10122000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800062d0, 0 ~~> Word[0x800062d8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          10163000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800062d0, 0 ~~> Word[0x800062dc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          10164000    0x80004268 addi a4, a4, 16                #; a4  = 0x800062d0, (wrb) a4  <-- 0x800062e0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          10165000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800062e0, a3  = 0x800062e0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
          10166000    0x80004270 bnez a2, 8                     #; a2  = 0, not taken
#; .Ltmp0 (memset.S:57)
#;   ret
          10167000    0x80004274 ret                            #; ra  = 0x80003d78, goto 0x80003d78
#; .LBB25_22 (start.c:215:5)
#;   snrt_init_bss (start.c:115:9)
#;     snrt_cluster_hw_barrier (sync.h:174:5)
#;       asm volatile("csrr x0, 0x7C2" ::: "memory");
#;       ^
          10168000    0x80003d78 csrr zero, 1986                #; csr@7c2 = 0
          10209000    0x80003d7c li a0, 57                      #; (wrb) a0  <-- 57
          10210000    0x80003d80 mul a0, s1, a0                 #; s1  = 8, a0  = 57
          10212000                                              #; (acc) a0  <-- 456
          10213000    0x80003d84 srli a0, a0, 9                 #; a0  = 456, (wrb) a0  <-- 0
          10214000    0x80003d88 slli a1, a0, 3                 #; a0  = 0, (wrb) a1  <-- 0
          10215000    0x80003d8c add a0, a1, a0                 #; a1  = 0, a0  = 0, (wrb) a0  <-- 0
          10216000    0x80003d90 sub a0, s2, a0                 #; s2  = 8, a0  = 0, (wrb) a0  <-- 8
          10217000    0x80003d94 p.extbz s5, a0                 #; a0  = 8
          10218000    0x80003d98 li s4, 0                       #; (wrb) s4  <-- 0
          10219000                                              #; (acc) s5  <-- 8
#; .LBB25_22 (start.c:219:5)
#;   snrt_wake_up (start.c:124:33)
#;     if (snrt_cluster_idx() == 0 && snrt_cluster_core_idx() == 0) {
#;                                 ^
          10220000    0x80003d9c bnez s5, 32                    #; s5  = 8, taken, goto 0x80003dbc
#; .LBB25_7 (start.c:219:5)
#;   snrt_wake_up (start.c:137:5)
#;     snrt_cluster_hw_barrier (sync.h:174:5)
#;       asm volatile("csrr x0, 0x7C2" ::: "memory");
#;       ^
          10221000    0x80003dbc csrr zero, 1986                #; csr@7c2 = 0
          10268000    0x80003dc0 lui a0, 65569                  #; (wrb) a0  <-- 0x10021000
          10269000    0x80003dc4 addi a0, a0, 424               #; a0  = 0x10021000, (wrb) a0  <-- 0x100211a8
#; .LBB25_7 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;       snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:5)
#;         snrt_int_cluster_clr (cluster_interrupts.h:22:53)
#;           snrt_cluster()->peripheral_reg.cl_clint_clear.f.cl_clint_clear = mask;
#;                                                           ^
          10270000    0x80003dc8 add a0, s3, a0                 #; s3  = 0, a0  = 0x100211a8, (wrb) a0  <-- 0x100211a8
#; .LBB25_7 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;       snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:5)
#;         snrt_int_cluster_clr (cluster_interrupts.h:22:68)
#;           snrt_cluster()->peripheral_reg.cl_clint_clear.f.cl_clint_clear = mask;
#;                                                                          ^
          10271000    0x80003dcc lw a1, 0(a0)                   #; a0  = 0x100211a8, a1  <~~ Word[0x100211a8]
          10299000                                              #; (lsu) a1  <-- 0
          10300000    0x80003dd0 ori a1, a0, 4                  #; a0  = 0x100211a8, (wrb) a1  <-- 0x100211ac
          10301000    0x80003dd4 lw a2, 0(a1)                   #; a1  = 0x100211ac, a2  <~~ Word[0x100211ac]
          10302000    0x80003dd8 li a3, 1                       #; (wrb) a3  <-- 1
#; .LBB25_7 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;       snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:28)
#;         snrt_int_cluster_clr(1 << snrt_cluster_core_idx());
#;                                ^
          10303000    0x80003ddc sll a3, a3, s5                 #; a3  = 1, s5  = 8, (wrb) a3  <-- 256
          10327000                                              #; (lsu) a2  <-- 0
#; .LBB25_7 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;       snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:5)
#;         snrt_int_cluster_clr (cluster_interrupts.h:22:68)
#;           snrt_cluster()->peripheral_reg.cl_clint_clear.f.cl_clint_clear = mask;
#;                                                                          ^
          10328000    0x80003de0 and a2, a2, s0                 #; a2  = 0, s0  = -1, (wrb) a2  <-- 0
          10329000    0x80003de4 sw a3, 0(a0)                   #; a0  = 0x100211a8, 256 ~~> Word[0x100211a8]
          10330000    0x80003de8 sw a2, 0(a1)                   #; a1  = 0x100211ac, 0 ~~> Word[0x100211ac]
          10331000    0x80003dec lui a0, 128                    #; (wrb) a0  <-- 0x00080000
#; .LBB25_8 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;       snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;         while (read_csr(mip) & MIP_MCIP)
#;                ^
          10332000    0x80003df0 csrr a1, mip                   #; mip = 0, (wrb) a1  <-- 0
#; .LBB25_8 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;       snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;         while (read_csr(mip) & MIP_MCIP)
#;                              ^
          10333000    0x80003df4 and a1, a1, a0                 #; a1  = 0, a0  = 0x00080000, (wrb) a1  <-- 0
#; .LBB25_8 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;       snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;         while (read_csr(mip) & MIP_MCIP)
#;         ^
          10334000    0x80003df8 bnez a1, -8                    #; a1  = 0, not taken
#; .LBB25_8 (start.c:227:5)
#;   snrt_init_tls (start.c:66:5)
#;     asm volatile("mv %0, tp" : "=r"(tls_ptr) : :);
#;     ^
          10335000    0x80003dfc mv a0, tp                      #; tp  = 0x1001df48, (wrb) a0  <-- 0x1001df48
          10348000    0x80003e00 sw a0, 8(sp)                   #; sp  = 0x1001df08, 0x1001df48 ~~> Word[0x1001df10]
#; .LBB25_8 (start.c:227:5)
#;   snrt_init_tls (start.c:67:19)
#;     memcpy((void*)tls_ptr, (const void*)&__tdata_start, size);
#;                   ^
          10382000    0x80003e04 lw a0, 8(sp)                   #; sp  = 0x1001df08, a0  <~~ Word[0x1001df10]
#; .LBB25_23 (start.c:227:5)
#;   snrt_init_tls (start.c:67:5)
#;     memcpy((void*)tls_ptr, (const void*)&__tdata_start, size);
#;     ^
          10383000    0x80003e08 auipc a1, 2                    #; (wrb) a1  <-- 0x80005e08
          10384000    0x80003e0c addi a1, a1, 128               #; a1  = 0x80005e08, (wrb) a1  <-- 0x80005e88
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:67:5)
#;     memcpy((void*)tls_ptr, (const void*)&__tdata_start, size);
#;     ^
          10385000    0x80003e10 auipc a2, 2                    #; (wrb) a2  <-- 0x80005e10
          10386000    0x80003e14 addi a2, a2, 132               #; a2  = 0x80005e10, (wrb) a2  <-- 0x80005e94
          10387000    0x80003e18 sub s0, a2, a1                 #; a2  = 0x80005e94, a1  = 0x80005e88, (wrb) s0  <-- 12
          10388000    0x80003e1c mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
          10389000    0x80003e20 auipc ra, 0                    #; (wrb) ra  <-- 0x80003e20
          10390000    0x80003e24 jalr 1264(ra)                  #; ra  = 0x80003e20, (wrb) ra  <-- 0x80003e28, goto 0x80004310
#; memcpy (memcpy.c:25)
#;   {
          10391000    0x80004310 addi sp, sp, -16               #; sp  = 0x1001df08, (wrb) sp  <-- 0x1001def8
          10392000    0x80004314 sw s0, 12(sp)                  #; sp  = 0x1001def8, 12 ~~> Word[0x1001df04], (lsu) a0  <-- 0x1001df48
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10393000    0x80004318 andi a3, a0, 3                 #; a0  = 0x1001df48, (wrb) a3  <-- 0
          10394000    0x8000431c andi a4, a1, 3                 #; a1  = 0x80005e88, (wrb) a4  <-- 0
          10395000    0x80004320 xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
          10396000    0x80004324 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
          10397000    0x80004328 li a5, 3                       #; (wrb) a5  <-- 3
          10398000    0x8000432c sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
          10399000    0x80004330 and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
          10400000    0x80004334 add a2, a0, a2                 #; a0  = 0x1001df48, a2  = 12, (wrb) a2  <-- 0x1001df54
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10401000    0x80004338 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
          10402000    0x8000433c bnez a3, 116                   #; a3  = 0, not taken
          10403000    0x80004340 mv a4, a0                      #; a0  = 0x1001df48, (wrb) a4  <-- 0x1001df48
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
          10404000    0x80004344 andi a3, a2, -4                #; a2  = 0x1001df54, (wrb) a3  <-- 0x1001df54
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
          10405000    0x80004348 sub a5, a3, a4                 #; a3  = 0x1001df54, a4  = 0x1001df48, (wrb) a5  <-- 12
          10406000    0x8000434c li a6, 33                      #; (wrb) a6  <-- 33
          10407000    0x80004350 bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10408000    0x80004354 bgeu a4, a3, 32                #; a4  = 0x1001df48, a3  = 0x1001df54, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10409000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x80005e88, a6  <~~ Word[0x80005e88]
          10410000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001df48, (wrb) a5  <-- 0x1001df4c
          10411000    0x80004360 addi a1, a1, 4                 #; a1  = 0x80005e88, (wrb) a1  <-- 0x80005e8c
          10420000                                              #; (lsu) a6  <-- 0x80005fc0
          10421000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001df48, 0x80005fc0 ~~> Word[0x1001df48]
          10422000    0x80004368 mv a4, a5                      #; a5  = 0x1001df4c, (wrb) a4  <-- 0x1001df4c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10423000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001df4c, a3  = 0x1001df54, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10424000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x80005e8c, a6  <~~ Word[0x80005e8c]
          10425000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001df4c, (wrb) a5  <-- 0x1001df50
          10426000    0x80004360 addi a1, a1, 4                 #; a1  = 0x80005e8c, (wrb) a1  <-- 0x80005e90
          10464000                                              #; (lsu) a6  <-- 1
          10465000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001df4c, 1 ~~> Word[0x1001df4c]
          10466000    0x80004368 mv a4, a5                      #; a5  = 0x1001df50, (wrb) a4  <-- 0x1001df50
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10467000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001df50, a3  = 0x1001df54, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10468000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x80005e90, a6  <~~ Word[0x80005e90]
          10469000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001df50, (wrb) a5  <-- 0x1001df54
          10470000    0x80004360 addi a1, a1, 4                 #; a1  = 0x80005e90, (wrb) a1  <-- 0x80005e94
          10501000                                              #; (lsu) a6  <-- 1
          10502000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001df50, 1 ~~> Word[0x1001df50]
          10503000    0x80004368 mv a4, a5                      #; a5  = 0x1001df54, (wrb) a4  <-- 0x1001df54
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10504000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001df54, a3  = 0x1001df54, not taken
          10505000    0x80004370 j 8                            #; goto 0x80004378
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
          10506000    0x80004378 bltu a5, a2, 20                #; a5  = 0x1001df54, a2  = 0x1001df54, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
          10507000    0x8000437c lw s0, 12(sp)                  #; sp  = 0x1001def8, s0  <~~ Word[0x1001df04]
          10510000                                              #; (lsu) s0  <-- 12
          10516000    0x80004380 addi sp, sp, 16                #; sp  = 0x1001def8, (wrb) sp  <-- 0x1001df08
          10517000    0x80004384 ret                            #; ra  = 0x80003e28, goto 0x80003e28
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
          10518000    0x80003e28 lw a0, 8(sp)                   #; sp  = 0x1001df08, a0  <~~ Word[0x1001df10]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
          10519000    0x80003e2c lw a1, 8(sp)                   #; sp  = 0x1001df08, a1  <~~ Word[0x1001df10]
          10521000                                              #; (lsu) a0  <-- 0x1001df48
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
          10522000    0x80003e30 addi a0, a0, 1032              #; a0  = 0x1001df48, (wrb) a0  <-- 0x1001e350
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
          10523000    0x80003e34 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
          10524000    0x80003e38 auipc ra, 0                    #; (wrb) ra  <-- 0x80003e38
          10525000    0x80003e3c jalr 1240(ra)                  #; ra  = 0x80003e38, (wrb) ra  <-- 0x80003e40, goto 0x80004310
#; memcpy (memcpy.c:25)
#;   {
          10526000    0x80004310 addi sp, sp, -16               #; sp  = 0x1001df08, (wrb) sp  <-- 0x1001def8
          10527000    0x80004314 sw s0, 12(sp)                  #; sp  = 0x1001def8, 12 ~~> Word[0x1001df04], (lsu) a1  <-- 0x1001df48
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10528000    0x80004318 andi a3, a0, 3                 #; a0  = 0x1001e350, (wrb) a3  <-- 0
          10529000    0x8000431c andi a4, a1, 3                 #; a1  = 0x1001df48, (wrb) a4  <-- 0
          10530000    0x80004320 xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
          10531000    0x80004324 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
          10532000    0x80004328 li a5, 3                       #; (wrb) a5  <-- 3
          10533000    0x8000432c sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
          10534000    0x80004330 and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
          10535000    0x80004334 add a2, a0, a2                 #; a0  = 0x1001e350, a2  = 12, (wrb) a2  <-- 0x1001e35c
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10536000    0x80004338 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
          10537000    0x8000433c bnez a3, 116                   #; a3  = 0, not taken
          10538000    0x80004340 mv a4, a0                      #; a0  = 0x1001e350, (wrb) a4  <-- 0x1001e350
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
          10539000    0x80004344 andi a3, a2, -4                #; a2  = 0x1001e35c, (wrb) a3  <-- 0x1001e35c
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
          10540000    0x80004348 sub a5, a3, a4                 #; a3  = 0x1001e35c, a4  = 0x1001e350, (wrb) a5  <-- 12
          10541000    0x8000434c li a6, 33                      #; (wrb) a6  <-- 33
          10542000    0x80004350 bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10543000    0x80004354 bgeu a4, a3, 32                #; a4  = 0x1001e350, a3  = 0x1001e35c, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10544000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001df48, a6  <~~ Word[0x1001df48]
          10545000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001e350, (wrb) a5  <-- 0x1001e354
          10546000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001df48, (wrb) a1  <-- 0x1001df4c
          10547000                                              #; (lsu) a6  <-- 0x80005fc0
          10548000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001e350, 0x80005fc0 ~~> Word[0x1001e350]
          10549000    0x80004368 mv a4, a5                      #; a5  = 0x1001e354, (wrb) a4  <-- 0x1001e354
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10550000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001e354, a3  = 0x1001e35c, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10551000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001df4c, a6  <~~ Word[0x1001df4c]
          10552000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001e354, (wrb) a5  <-- 0x1001e358
          10553000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001df4c, (wrb) a1  <-- 0x1001df50
          10554000                                              #; (lsu) a6  <-- 1
          10555000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001e354, 1 ~~> Word[0x1001e354]
          10556000    0x80004368 mv a4, a5                      #; a5  = 0x1001e358, (wrb) a4  <-- 0x1001e358
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10557000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001e358, a3  = 0x1001e35c, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10558000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001df50, a6  <~~ Word[0x1001df50]
          10559000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001e358, (wrb) a5  <-- 0x1001e35c
          10560000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001df50, (wrb) a1  <-- 0x1001df54
          10561000                                              #; (lsu) a6  <-- 1
          10562000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001e358, 1 ~~> Word[0x1001e358]
          10563000    0x80004368 mv a4, a5                      #; a5  = 0x1001e35c, (wrb) a4  <-- 0x1001e35c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10564000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001e35c, a3  = 0x1001e35c, not taken
          10565000    0x80004370 j 8                            #; goto 0x80004378
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
          10566000    0x80004378 bltu a5, a2, 20                #; a5  = 0x1001e35c, a2  = 0x1001e35c, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
          10567000    0x8000437c lw s0, 12(sp)                  #; sp  = 0x1001def8, s0  <~~ Word[0x1001df04]
          10568000    0x80004380 addi sp, sp, 16                #; sp  = 0x1001def8, (wrb) sp  <-- 0x1001df08
          10569000    0x80004384 ret                            #; ra  = 0x80003e40, goto 0x80003e40
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
          10570000    0x80003e40 lw a0, 8(sp)                   #; sp  = 0x1001df08, a0  <~~ Word[0x1001df10], (lsu) s0  <-- 12
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
          10571000    0x80003e44 lw a1, 8(sp)                   #; sp  = 0x1001df08, a1  <~~ Word[0x1001df10]
          10572000    0x80003e48 lui s7, 1                      #; (wrb) s7  <-- 4096
          10573000    0x80003e4c addi s1, s7, -2032             #; s7  = 4096, (wrb) s1  <-- 2064
          10574000                                              #; (lsu) a0  <-- 0x1001df48
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
          10575000    0x80003e50 add a0, a0, s1                 #; a0  = 0x1001df48, s1  = 2064, (wrb) a0  <-- 0x1001e758
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
          10576000    0x80003e54 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
          10577000    0x80003e58 auipc ra, 0                    #; (wrb) ra  <-- 0x80003e58
          10578000    0x80003e5c jalr 1208(ra)                  #; ra  = 0x80003e58, (wrb) ra  <-- 0x80003e60, goto 0x80004310
#; memcpy (memcpy.c:25)
#;   {
          10579000    0x80004310 addi sp, sp, -16               #; sp  = 0x1001df08, (wrb) sp  <-- 0x1001def8
          10580000    0x80004314 sw s0, 12(sp)                  #; sp  = 0x1001def8, 12 ~~> Word[0x1001df04], (lsu) a1  <-- 0x1001df48
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10581000    0x80004318 andi a3, a0, 3                 #; a0  = 0x1001e758, (wrb) a3  <-- 0
          10582000    0x8000431c andi a4, a1, 3                 #; a1  = 0x1001df48, (wrb) a4  <-- 0
          10583000    0x80004320 xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
          10584000    0x80004324 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
          10585000    0x80004328 li a5, 3                       #; (wrb) a5  <-- 3
          10586000    0x8000432c sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
          10587000    0x80004330 and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
          10588000    0x80004334 add a2, a0, a2                 #; a0  = 0x1001e758, a2  = 12, (wrb) a2  <-- 0x1001e764
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10589000    0x80004338 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
          10590000    0x8000433c bnez a3, 116                   #; a3  = 0, not taken
          10591000    0x80004340 mv a4, a0                      #; a0  = 0x1001e758, (wrb) a4  <-- 0x1001e758
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
          10592000    0x80004344 andi a3, a2, -4                #; a2  = 0x1001e764, (wrb) a3  <-- 0x1001e764
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
          10593000    0x80004348 sub a5, a3, a4                 #; a3  = 0x1001e764, a4  = 0x1001e758, (wrb) a5  <-- 12
          10594000    0x8000434c li a6, 33                      #; (wrb) a6  <-- 33
          10595000    0x80004350 bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10596000    0x80004354 bgeu a4, a3, 32                #; a4  = 0x1001e758, a3  = 0x1001e764, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10597000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001df48, a6  <~~ Word[0x1001df48]
          10598000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001e758, (wrb) a5  <-- 0x1001e75c
          10599000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001df48, (wrb) a1  <-- 0x1001df4c
          10600000                                              #; (lsu) a6  <-- 0x80005fc0
          10601000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001e758, 0x80005fc0 ~~> Word[0x1001e758]
          10602000    0x80004368 mv a4, a5                      #; a5  = 0x1001e75c, (wrb) a4  <-- 0x1001e75c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10603000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001e75c, a3  = 0x1001e764, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10604000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001df4c, a6  <~~ Word[0x1001df4c]
          10605000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001e75c, (wrb) a5  <-- 0x1001e760
          10606000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001df4c, (wrb) a1  <-- 0x1001df50
          10607000                                              #; (lsu) a6  <-- 1
          10608000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001e75c, 1 ~~> Word[0x1001e75c]
          10609000    0x80004368 mv a4, a5                      #; a5  = 0x1001e760, (wrb) a4  <-- 0x1001e760
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10610000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001e760, a3  = 0x1001e764, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10611000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001df50, a6  <~~ Word[0x1001df50]
          10612000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001e760, (wrb) a5  <-- 0x1001e764
          10613000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001df50, (wrb) a1  <-- 0x1001df54
          10614000                                              #; (lsu) a6  <-- 1
          10615000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001e760, 1 ~~> Word[0x1001e760]
          10616000    0x80004368 mv a4, a5                      #; a5  = 0x1001e764, (wrb) a4  <-- 0x1001e764
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10617000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001e764, a3  = 0x1001e764, not taken
          10618000    0x80004370 j 8                            #; goto 0x80004378
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
          10619000    0x80004378 bltu a5, a2, 20                #; a5  = 0x1001e764, a2  = 0x1001e764, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
          10620000    0x8000437c lw s0, 12(sp)                  #; sp  = 0x1001def8, s0  <~~ Word[0x1001df04]
          10621000    0x80004380 addi sp, sp, 16                #; sp  = 0x1001def8, (wrb) sp  <-- 0x1001df08
          10622000    0x80004384 ret                            #; ra  = 0x80003e60, goto 0x80003e60
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
          10623000    0x80003e60 lw a0, 8(sp)                   #; sp  = 0x1001df08, a0  <~~ Word[0x1001df10], (lsu) s0  <-- 12
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
          10624000    0x80003e64 lw a1, 8(sp)                   #; sp  = 0x1001df08, a1  <~~ Word[0x1001df10]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
          10625000    0x80003e68 ori s6, s1, 1032               #; s1  = 2064, (wrb) s6  <-- 3096
          10626000                                              #; (lsu) a0  <-- 0x1001df48
          10627000    0x80003e6c add a0, a0, s6                 #; a0  = 0x1001df48, s6  = 3096, (wrb) a0  <-- 0x1001eb60
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
          10628000    0x80003e70 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
          10629000    0x80003e74 auipc ra, 0                    #; (wrb) ra  <-- 0x80003e74
          10630000    0x80003e78 jalr 1180(ra)                  #; ra  = 0x80003e74, (wrb) ra  <-- 0x80003e7c, goto 0x80004310
#; memcpy (memcpy.c:25)
#;   {
          10631000    0x80004310 addi sp, sp, -16               #; sp  = 0x1001df08, (wrb) sp  <-- 0x1001def8
          10632000    0x80004314 sw s0, 12(sp)                  #; sp  = 0x1001def8, 12 ~~> Word[0x1001df04], (lsu) a1  <-- 0x1001df48
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10633000    0x80004318 andi a3, a0, 3                 #; a0  = 0x1001eb60, (wrb) a3  <-- 0
          10634000    0x8000431c andi a4, a1, 3                 #; a1  = 0x1001df48, (wrb) a4  <-- 0
          10635000    0x80004320 xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
          10636000    0x80004324 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
          10637000    0x80004328 li a5, 3                       #; (wrb) a5  <-- 3
          10638000    0x8000432c sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
          10639000    0x80004330 and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
          10640000    0x80004334 add a2, a0, a2                 #; a0  = 0x1001eb60, a2  = 12, (wrb) a2  <-- 0x1001eb6c
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10641000    0x80004338 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
          10642000    0x8000433c bnez a3, 116                   #; a3  = 0, not taken
          10643000    0x80004340 mv a4, a0                      #; a0  = 0x1001eb60, (wrb) a4  <-- 0x1001eb60
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
          10644000    0x80004344 andi a3, a2, -4                #; a2  = 0x1001eb6c, (wrb) a3  <-- 0x1001eb6c
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
          10645000    0x80004348 sub a5, a3, a4                 #; a3  = 0x1001eb6c, a4  = 0x1001eb60, (wrb) a5  <-- 12
          10646000    0x8000434c li a6, 33                      #; (wrb) a6  <-- 33
          10647000    0x80004350 bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10648000    0x80004354 bgeu a4, a3, 32                #; a4  = 0x1001eb60, a3  = 0x1001eb6c, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10649000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001df48, a6  <~~ Word[0x1001df48]
          10650000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001eb60, (wrb) a5  <-- 0x1001eb64
          10651000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001df48, (wrb) a1  <-- 0x1001df4c
          10652000                                              #; (lsu) a6  <-- 0x80005fc0
          10653000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001eb60, 0x80005fc0 ~~> Word[0x1001eb60]
          10654000    0x80004368 mv a4, a5                      #; a5  = 0x1001eb64, (wrb) a4  <-- 0x1001eb64
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10655000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001eb64, a3  = 0x1001eb6c, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10656000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001df4c, a6  <~~ Word[0x1001df4c]
          10657000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001eb64, (wrb) a5  <-- 0x1001eb68
          10658000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001df4c, (wrb) a1  <-- 0x1001df50
          10659000                                              #; (lsu) a6  <-- 1
          10660000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001eb64, 1 ~~> Word[0x1001eb64]
          10661000    0x80004368 mv a4, a5                      #; a5  = 0x1001eb68, (wrb) a4  <-- 0x1001eb68
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10662000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001eb68, a3  = 0x1001eb6c, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10663000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001df50, a6  <~~ Word[0x1001df50]
          10664000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001eb68, (wrb) a5  <-- 0x1001eb6c
          10665000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001df50, (wrb) a1  <-- 0x1001df54
          10666000                                              #; (lsu) a6  <-- 1
          10667000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001eb68, 1 ~~> Word[0x1001eb68]
          10668000    0x80004368 mv a4, a5                      #; a5  = 0x1001eb6c, (wrb) a4  <-- 0x1001eb6c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10669000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001eb6c, a3  = 0x1001eb6c, not taken
          10670000    0x80004370 j 8                            #; goto 0x80004378
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
          10671000    0x80004378 bltu a5, a2, 20                #; a5  = 0x1001eb6c, a2  = 0x1001eb6c, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
          10672000    0x8000437c lw s0, 12(sp)                  #; sp  = 0x1001def8, s0  <~~ Word[0x1001df04]
          10673000    0x80004380 addi sp, sp, 16                #; sp  = 0x1001def8, (wrb) sp  <-- 0x1001df08
          10674000    0x80004384 ret                            #; ra  = 0x80003e7c, goto 0x80003e7c
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
          10675000    0x80003e7c lw a0, 8(sp)                   #; sp  = 0x1001df08, a0  <~~ Word[0x1001df10], (lsu) s0  <-- 12
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
          10676000    0x80003e80 lw a1, 8(sp)                   #; sp  = 0x1001df08, a1  <~~ Word[0x1001df10]
          10677000    0x80003e84 addi s7, s7, 32                #; s7  = 4096, (wrb) s7  <-- 4128
          10678000                                              #; (lsu) a0  <-- 0x1001df48
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
          10679000    0x80003e88 add a0, a0, s7                 #; a0  = 0x1001df48, s7  = 4128, (wrb) a0  <-- 0x1001ef68
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
          10680000    0x80003e8c mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
          10681000    0x80003e90 auipc ra, 0                    #; (wrb) ra  <-- 0x80003e90
          10682000    0x80003e94 jalr 1152(ra)                  #; ra  = 0x80003e90, (wrb) ra  <-- 0x80003e98, goto 0x80004310
          10683000                                              #; (lsu) a1  <-- 0x1001df48
#; memcpy (memcpy.c:25)
#;   {
          10689000    0x80004310 addi sp, sp, -16               #; sp  = 0x1001df08, (wrb) sp  <-- 0x1001def8
          10690000    0x80004314 sw s0, 12(sp)                  #; sp  = 0x1001def8, 12 ~~> Word[0x1001df04]
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10691000    0x80004318 andi a3, a0, 3                 #; a0  = 0x1001ef68, (wrb) a3  <-- 0
          10692000    0x8000431c andi a4, a1, 3                 #; a1  = 0x1001df48, (wrb) a4  <-- 0
          10693000    0x80004320 xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
          10694000    0x80004324 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
          10695000    0x80004328 li a5, 3                       #; (wrb) a5  <-- 3
          10696000    0x8000432c sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
          10697000    0x80004330 and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
          10698000    0x80004334 add a2, a0, a2                 #; a0  = 0x1001ef68, a2  = 12, (wrb) a2  <-- 0x1001ef74
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10699000    0x80004338 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
          10700000    0x8000433c bnez a3, 116                   #; a3  = 0, not taken
          10701000    0x80004340 mv a4, a0                      #; a0  = 0x1001ef68, (wrb) a4  <-- 0x1001ef68
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
          10702000    0x80004344 andi a3, a2, -4                #; a2  = 0x1001ef74, (wrb) a3  <-- 0x1001ef74
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
          10703000    0x80004348 sub a5, a3, a4                 #; a3  = 0x1001ef74, a4  = 0x1001ef68, (wrb) a5  <-- 12
          10704000    0x8000434c li a6, 33                      #; (wrb) a6  <-- 33
          10705000    0x80004350 bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10706000    0x80004354 bgeu a4, a3, 32                #; a4  = 0x1001ef68, a3  = 0x1001ef74, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10707000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001df48, a6  <~~ Word[0x1001df48]
          10708000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001ef68, (wrb) a5  <-- 0x1001ef6c
          10709000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001df48, (wrb) a1  <-- 0x1001df4c
          10710000                                              #; (lsu) a6  <-- 0x80005fc0
          10711000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001ef68, 0x80005fc0 ~~> Word[0x1001ef68]
          10712000    0x80004368 mv a4, a5                      #; a5  = 0x1001ef6c, (wrb) a4  <-- 0x1001ef6c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10713000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001ef6c, a3  = 0x1001ef74, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10714000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001df4c, a6  <~~ Word[0x1001df4c]
          10715000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001ef6c, (wrb) a5  <-- 0x1001ef70
          10716000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001df4c, (wrb) a1  <-- 0x1001df50
          10717000                                              #; (lsu) a6  <-- 1
          10718000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001ef6c, 1 ~~> Word[0x1001ef6c]
          10719000    0x80004368 mv a4, a5                      #; a5  = 0x1001ef70, (wrb) a4  <-- 0x1001ef70
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10720000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001ef70, a3  = 0x1001ef74, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10721000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001df50, a6  <~~ Word[0x1001df50]
          10722000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001ef70, (wrb) a5  <-- 0x1001ef74
          10723000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001df50, (wrb) a1  <-- 0x1001df54
          10724000                                              #; (lsu) a6  <-- 1
          10725000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001ef70, 1 ~~> Word[0x1001ef70]
          10726000    0x80004368 mv a4, a5                      #; a5  = 0x1001ef74, (wrb) a4  <-- 0x1001ef74
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10727000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001ef74, a3  = 0x1001ef74, not taken
          10728000    0x80004370 j 8                            #; goto 0x80004378
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
          10729000    0x80004378 bltu a5, a2, 20                #; a5  = 0x1001ef74, a2  = 0x1001ef74, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
          10730000    0x8000437c lw s0, 12(sp)                  #; sp  = 0x1001def8, s0  <~~ Word[0x1001df04]
          10731000    0x80004380 addi sp, sp, 16                #; sp  = 0x1001def8, (wrb) sp  <-- 0x1001df08
          10732000    0x80004384 ret                            #; ra  = 0x80003e98, goto 0x80003e98
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
          10733000    0x80003e98 lw a0, 8(sp)                   #; sp  = 0x1001df08, a0  <~~ Word[0x1001df10], (lsu) s0  <-- 12
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
          10734000    0x80003e9c lw a1, 8(sp)                   #; sp  = 0x1001df08, a1  <~~ Word[0x1001df10]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
          10735000    0x80003ea0 ori s8, s7, 1032               #; s7  = 4128, (wrb) s8  <-- 5160
          10736000                                              #; (lsu) a0  <-- 0x1001df48
          10737000    0x80003ea4 add a0, a0, s8                 #; a0  = 0x1001df48, s8  = 5160, (wrb) a0  <-- 0x1001f370
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
          10738000    0x80003ea8 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
          10739000    0x80003eac auipc ra, 0                    #; (wrb) ra  <-- 0x80003eac
          10740000    0x80003eb0 jalr 1124(ra)                  #; ra  = 0x80003eac, (wrb) ra  <-- 0x80003eb4, goto 0x80004310
#; memcpy (memcpy.c:25)
#;   {
          10741000    0x80004310 addi sp, sp, -16               #; sp  = 0x1001df08, (wrb) sp  <-- 0x1001def8
          10742000    0x80004314 sw s0, 12(sp)                  #; sp  = 0x1001def8, 12 ~~> Word[0x1001df04], (lsu) a1  <-- 0x1001df48
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10743000    0x80004318 andi a3, a0, 3                 #; a0  = 0x1001f370, (wrb) a3  <-- 0
          10744000    0x8000431c andi a4, a1, 3                 #; a1  = 0x1001df48, (wrb) a4  <-- 0
          10745000    0x80004320 xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
          10746000    0x80004324 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
          10747000    0x80004328 li a5, 3                       #; (wrb) a5  <-- 3
          10748000    0x8000432c sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
          10749000    0x80004330 and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
          10750000    0x80004334 add a2, a0, a2                 #; a0  = 0x1001f370, a2  = 12, (wrb) a2  <-- 0x1001f37c
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10751000    0x80004338 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
          10752000    0x8000433c bnez a3, 116                   #; a3  = 0, not taken
          10753000    0x80004340 mv a4, a0                      #; a0  = 0x1001f370, (wrb) a4  <-- 0x1001f370
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
          10754000    0x80004344 andi a3, a2, -4                #; a2  = 0x1001f37c, (wrb) a3  <-- 0x1001f37c
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
          10755000    0x80004348 sub a5, a3, a4                 #; a3  = 0x1001f37c, a4  = 0x1001f370, (wrb) a5  <-- 12
          10756000    0x8000434c li a6, 33                      #; (wrb) a6  <-- 33
          10757000    0x80004350 bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10758000    0x80004354 bgeu a4, a3, 32                #; a4  = 0x1001f370, a3  = 0x1001f37c, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10759000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001df48, a6  <~~ Word[0x1001df48]
          10760000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001f370, (wrb) a5  <-- 0x1001f374
          10761000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001df48, (wrb) a1  <-- 0x1001df4c
          10762000                                              #; (lsu) a6  <-- 0x80005fc0
          10763000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001f370, 0x80005fc0 ~~> Word[0x1001f370]
          10764000    0x80004368 mv a4, a5                      #; a5  = 0x1001f374, (wrb) a4  <-- 0x1001f374
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10765000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001f374, a3  = 0x1001f37c, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10766000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001df4c, a6  <~~ Word[0x1001df4c]
          10767000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001f374, (wrb) a5  <-- 0x1001f378
          10768000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001df4c, (wrb) a1  <-- 0x1001df50
          10769000                                              #; (lsu) a6  <-- 1
          10770000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001f374, 1 ~~> Word[0x1001f374]
          10771000    0x80004368 mv a4, a5                      #; a5  = 0x1001f378, (wrb) a4  <-- 0x1001f378
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10772000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001f378, a3  = 0x1001f37c, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10773000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001df50, a6  <~~ Word[0x1001df50]
          10774000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001f378, (wrb) a5  <-- 0x1001f37c
          10775000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001df50, (wrb) a1  <-- 0x1001df54
          10776000                                              #; (lsu) a6  <-- 1
          10777000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001f378, 1 ~~> Word[0x1001f378]
          10778000    0x80004368 mv a4, a5                      #; a5  = 0x1001f37c, (wrb) a4  <-- 0x1001f37c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10779000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001f37c, a3  = 0x1001f37c, not taken
          10780000    0x80004370 j 8                            #; goto 0x80004378
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
          10781000    0x80004378 bltu a5, a2, 20                #; a5  = 0x1001f37c, a2  = 0x1001f37c, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
          10782000    0x8000437c lw s0, 12(sp)                  #; sp  = 0x1001def8, s0  <~~ Word[0x1001df04]
          10783000    0x80004380 addi sp, sp, 16                #; sp  = 0x1001def8, (wrb) sp  <-- 0x1001df08
          10784000    0x80004384 ret                            #; ra  = 0x80003eb4, goto 0x80003eb4
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
          10785000    0x80003eb4 lw a0, 8(sp)                   #; sp  = 0x1001df08, a0  <~~ Word[0x1001df10], (lsu) s0  <-- 12
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
          10786000    0x80003eb8 lw a1, 8(sp)                   #; sp  = 0x1001df08, a1  <~~ Word[0x1001df10]
          10787000    0x80003ebc lui s11, 2                     #; (wrb) s11 <-- 8192
          10788000    0x80003ec0 addi s9, s11, -2000            #; s11 = 8192, (wrb) s9  <-- 6192
          10789000                                              #; (lsu) a0  <-- 0x1001df48
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
          10790000    0x80003ec4 add a0, a0, s9                 #; a0  = 0x1001df48, s9  = 6192, (wrb) a0  <-- 0x1001f778
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
          10791000    0x80003ec8 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
          10792000    0x80003ecc auipc ra, 0                    #; (wrb) ra  <-- 0x80003ecc
          10793000    0x80003ed0 jalr 1092(ra)                  #; ra  = 0x80003ecc, (wrb) ra  <-- 0x80003ed4, goto 0x80004310
#; memcpy (memcpy.c:25)
#;   {
          10794000    0x80004310 addi sp, sp, -16               #; sp  = 0x1001df08, (wrb) sp  <-- 0x1001def8
          10795000    0x80004314 sw s0, 12(sp)                  #; sp  = 0x1001def8, 12 ~~> Word[0x1001df04], (lsu) a1  <-- 0x1001df48
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10796000    0x80004318 andi a3, a0, 3                 #; a0  = 0x1001f778, (wrb) a3  <-- 0
          10797000    0x8000431c andi a4, a1, 3                 #; a1  = 0x1001df48, (wrb) a4  <-- 0
          10798000    0x80004320 xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
          10799000    0x80004324 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
          10800000    0x80004328 li a5, 3                       #; (wrb) a5  <-- 3
          10801000    0x8000432c sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
          10802000    0x80004330 and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
          10803000    0x80004334 add a2, a0, a2                 #; a0  = 0x1001f778, a2  = 12, (wrb) a2  <-- 0x1001f784
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10804000    0x80004338 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
          10805000    0x8000433c bnez a3, 116                   #; a3  = 0, not taken
          10806000    0x80004340 mv a4, a0                      #; a0  = 0x1001f778, (wrb) a4  <-- 0x1001f778
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
          10807000    0x80004344 andi a3, a2, -4                #; a2  = 0x1001f784, (wrb) a3  <-- 0x1001f784
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
          10808000    0x80004348 sub a5, a3, a4                 #; a3  = 0x1001f784, a4  = 0x1001f778, (wrb) a5  <-- 12
          10809000    0x8000434c li a6, 33                      #; (wrb) a6  <-- 33
          10810000    0x80004350 bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10811000    0x80004354 bgeu a4, a3, 32                #; a4  = 0x1001f778, a3  = 0x1001f784, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10812000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001df48, a6  <~~ Word[0x1001df48]
          10813000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001f778, (wrb) a5  <-- 0x1001f77c
          10814000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001df48, (wrb) a1  <-- 0x1001df4c
          10815000                                              #; (lsu) a6  <-- 0x80005fc0
          10816000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001f778, 0x80005fc0 ~~> Word[0x1001f778]
          10817000    0x80004368 mv a4, a5                      #; a5  = 0x1001f77c, (wrb) a4  <-- 0x1001f77c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10818000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001f77c, a3  = 0x1001f784, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10819000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001df4c, a6  <~~ Word[0x1001df4c]
          10820000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001f77c, (wrb) a5  <-- 0x1001f780
          10821000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001df4c, (wrb) a1  <-- 0x1001df50
          10822000                                              #; (lsu) a6  <-- 1
          10823000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001f77c, 1 ~~> Word[0x1001f77c]
          10824000    0x80004368 mv a4, a5                      #; a5  = 0x1001f780, (wrb) a4  <-- 0x1001f780
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10825000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001f780, a3  = 0x1001f784, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10826000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001df50, a6  <~~ Word[0x1001df50]
          10827000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001f780, (wrb) a5  <-- 0x1001f784
          10828000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001df50, (wrb) a1  <-- 0x1001df54
          10829000                                              #; (lsu) a6  <-- 1
          10830000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001f780, 1 ~~> Word[0x1001f780]
          10831000    0x80004368 mv a4, a5                      #; a5  = 0x1001f784, (wrb) a4  <-- 0x1001f784
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10832000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001f784, a3  = 0x1001f784, not taken
          10833000    0x80004370 j 8                            #; goto 0x80004378
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
          10834000    0x80004378 bltu a5, a2, 20                #; a5  = 0x1001f784, a2  = 0x1001f784, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
          10835000    0x8000437c lw s0, 12(sp)                  #; sp  = 0x1001def8, s0  <~~ Word[0x1001df04]
          10836000    0x80004380 addi sp, sp, 16                #; sp  = 0x1001def8, (wrb) sp  <-- 0x1001df08
          10837000    0x80004384 ret                            #; ra  = 0x80003ed4, goto 0x80003ed4
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
          10838000    0x80003ed4 lw a0, 8(sp)                   #; sp  = 0x1001df08, a0  <~~ Word[0x1001df10], (lsu) s0  <-- 12
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
          10839000    0x80003ed8 lw a1, 8(sp)                   #; sp  = 0x1001df08, a1  <~~ Word[0x1001df10]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
          10840000    0x80003edc ori s10, s9, 1032              #; s9  = 6192, (wrb) s10 <-- 7224
          10841000                                              #; (lsu) a0  <-- 0x1001df48
          10842000    0x80003ee0 add a0, a0, s10                #; a0  = 0x1001df48, s10 = 7224, (wrb) a0  <-- 0x1001fb80
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
          10843000    0x80003ee4 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
          10844000    0x80003ee8 auipc ra, 0                    #; (wrb) ra  <-- 0x80003ee8
          10845000    0x80003eec jalr 1064(ra)                  #; ra  = 0x80003ee8, (wrb) ra  <-- 0x80003ef0, goto 0x80004310
#; memcpy (memcpy.c:25)
#;   {
          10846000    0x80004310 addi sp, sp, -16               #; sp  = 0x1001df08, (wrb) sp  <-- 0x1001def8
          10847000    0x80004314 sw s0, 12(sp)                  #; sp  = 0x1001def8, 12 ~~> Word[0x1001df04], (lsu) a1  <-- 0x1001df48
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10848000    0x80004318 andi a3, a0, 3                 #; a0  = 0x1001fb80, (wrb) a3  <-- 0
          10849000    0x8000431c andi a4, a1, 3                 #; a1  = 0x1001df48, (wrb) a4  <-- 0
          10850000    0x80004320 xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
          10851000    0x80004324 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
          10852000    0x80004328 li a5, 3                       #; (wrb) a5  <-- 3
          10853000    0x8000432c sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
          10854000    0x80004330 and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
          10855000    0x80004334 add a2, a0, a2                 #; a0  = 0x1001fb80, a2  = 12, (wrb) a2  <-- 0x1001fb8c
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10856000    0x80004338 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
          10857000    0x8000433c bnez a3, 116                   #; a3  = 0, not taken
          10858000    0x80004340 mv a4, a0                      #; a0  = 0x1001fb80, (wrb) a4  <-- 0x1001fb80
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
          10859000    0x80004344 andi a3, a2, -4                #; a2  = 0x1001fb8c, (wrb) a3  <-- 0x1001fb8c
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
          10860000    0x80004348 sub a5, a3, a4                 #; a3  = 0x1001fb8c, a4  = 0x1001fb80, (wrb) a5  <-- 12
          10861000    0x8000434c li a6, 33                      #; (wrb) a6  <-- 33
          10862000    0x80004350 bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10863000    0x80004354 bgeu a4, a3, 32                #; a4  = 0x1001fb80, a3  = 0x1001fb8c, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10864000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001df48, a6  <~~ Word[0x1001df48]
          10865000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001fb80, (wrb) a5  <-- 0x1001fb84
          10866000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001df48, (wrb) a1  <-- 0x1001df4c
          10867000                                              #; (lsu) a6  <-- 0x80005fc0
          10868000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001fb80, 0x80005fc0 ~~> Word[0x1001fb80]
          10869000    0x80004368 mv a4, a5                      #; a5  = 0x1001fb84, (wrb) a4  <-- 0x1001fb84
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10870000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001fb84, a3  = 0x1001fb8c, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10871000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001df4c, a6  <~~ Word[0x1001df4c]
          10872000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001fb84, (wrb) a5  <-- 0x1001fb88
          10873000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001df4c, (wrb) a1  <-- 0x1001df50
          10874000                                              #; (lsu) a6  <-- 1
          10875000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001fb84, 1 ~~> Word[0x1001fb84]
          10876000    0x80004368 mv a4, a5                      #; a5  = 0x1001fb88, (wrb) a4  <-- 0x1001fb88
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10877000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001fb88, a3  = 0x1001fb8c, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10878000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001df50, a6  <~~ Word[0x1001df50]
          10879000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001fb88, (wrb) a5  <-- 0x1001fb8c
          10880000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001df50, (wrb) a1  <-- 0x1001df54
          10881000                                              #; (lsu) a6  <-- 1
          10882000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001fb88, 1 ~~> Word[0x1001fb88]
          10883000    0x80004368 mv a4, a5                      #; a5  = 0x1001fb8c, (wrb) a4  <-- 0x1001fb8c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10884000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001fb8c, a3  = 0x1001fb8c, not taken
          10885000    0x80004370 j 8                            #; goto 0x80004378
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
          10886000    0x80004378 bltu a5, a2, 20                #; a5  = 0x1001fb8c, a2  = 0x1001fb8c, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
          10887000    0x8000437c lw s0, 12(sp)                  #; sp  = 0x1001def8, s0  <~~ Word[0x1001df04]
          10888000    0x80004380 addi sp, sp, 16                #; sp  = 0x1001def8, (wrb) sp  <-- 0x1001df08
          10889000    0x80004384 ret                            #; ra  = 0x80003ef0, goto 0x80003ef0
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
          10890000    0x80003ef0 lw a0, 8(sp)                   #; sp  = 0x1001df08, a0  <~~ Word[0x1001df10], (lsu) s0  <-- 12
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
          10891000    0x80003ef4 lw a1, 8(sp)                   #; sp  = 0x1001df08, a1  <~~ Word[0x1001df10]
          10892000    0x80003ef8 addi s11, s11, 64              #; s11 = 8192, (wrb) s11 <-- 8256
          10893000                                              #; (lsu) a0  <-- 0x1001df48
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
          10894000    0x80003efc add a0, a0, s11                #; a0  = 0x1001df48, s11 = 8256, (wrb) a0  <-- 0x1001ff88
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
          10895000    0x80003f00 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
          10896000    0x80003f04 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f04
          10897000    0x80003f08 jalr 1036(ra)                  #; ra  = 0x80003f04, (wrb) ra  <-- 0x80003f0c, goto 0x80004310
#; memcpy (memcpy.c:25)
#;   {
          10898000    0x80004310 addi sp, sp, -16               #; sp  = 0x1001df08, (wrb) sp  <-- 0x1001def8
          10899000    0x80004314 sw s0, 12(sp)                  #; sp  = 0x1001def8, 12 ~~> Word[0x1001df04], (lsu) a1  <-- 0x1001df48
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10900000    0x80004318 andi a3, a0, 3                 #; a0  = 0x1001ff88, (wrb) a3  <-- 0
          10901000    0x8000431c andi a4, a1, 3                 #; a1  = 0x1001df48, (wrb) a4  <-- 0
          10902000    0x80004320 xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
          10903000    0x80004324 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
          10904000    0x80004328 li a5, 3                       #; (wrb) a5  <-- 3
          10905000    0x8000432c sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
          10906000    0x80004330 and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
          10907000    0x80004334 add a2, a0, a2                 #; a0  = 0x1001ff88, a2  = 12, (wrb) a2  <-- 0x1001ff94
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10908000    0x80004338 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
          10909000    0x8000433c bnez a3, 116                   #; a3  = 0, not taken
          10910000    0x80004340 mv a4, a0                      #; a0  = 0x1001ff88, (wrb) a4  <-- 0x1001ff88
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
          10911000    0x80004344 andi a3, a2, -4                #; a2  = 0x1001ff94, (wrb) a3  <-- 0x1001ff94
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
          10912000    0x80004348 sub a5, a3, a4                 #; a3  = 0x1001ff94, a4  = 0x1001ff88, (wrb) a5  <-- 12
          10913000    0x8000434c li a6, 33                      #; (wrb) a6  <-- 33
          10914000    0x80004350 bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10915000    0x80004354 bgeu a4, a3, 32                #; a4  = 0x1001ff88, a3  = 0x1001ff94, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10916000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001df48, a6  <~~ Word[0x1001df48]
          10917000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001ff88, (wrb) a5  <-- 0x1001ff8c
          10918000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001df48, (wrb) a1  <-- 0x1001df4c
          10919000                                              #; (lsu) a6  <-- 0x80005fc0
          10920000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001ff88, 0x80005fc0 ~~> Word[0x1001ff88]
          10921000    0x80004368 mv a4, a5                      #; a5  = 0x1001ff8c, (wrb) a4  <-- 0x1001ff8c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10922000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001ff8c, a3  = 0x1001ff94, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10923000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001df4c, a6  <~~ Word[0x1001df4c]
          10924000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001ff8c, (wrb) a5  <-- 0x1001ff90
          10925000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001df4c, (wrb) a1  <-- 0x1001df50
          10926000                                              #; (lsu) a6  <-- 1
          10927000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001ff8c, 1 ~~> Word[0x1001ff8c]
          10928000    0x80004368 mv a4, a5                      #; a5  = 0x1001ff90, (wrb) a4  <-- 0x1001ff90
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10929000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001ff90, a3  = 0x1001ff94, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10930000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001df50, a6  <~~ Word[0x1001df50]
          10931000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001ff90, (wrb) a5  <-- 0x1001ff94
          10932000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001df50, (wrb) a1  <-- 0x1001df54
          10933000                                              #; (lsu) a6  <-- 1
          10934000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001ff90, 1 ~~> Word[0x1001ff90]
          10935000    0x80004368 mv a4, a5                      #; a5  = 0x1001ff94, (wrb) a4  <-- 0x1001ff94
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10936000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001ff94, a3  = 0x1001ff94, not taken
          10937000    0x80004370 j 8                            #; goto 0x80004378
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
          10938000    0x80004378 bltu a5, a2, 20                #; a5  = 0x1001ff94, a2  = 0x1001ff94, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
          10939000    0x8000437c lw s0, 12(sp)                  #; sp  = 0x1001def8, s0  <~~ Word[0x1001df04]
          10940000    0x80004380 addi sp, sp, 16                #; sp  = 0x1001def8, (wrb) sp  <-- 0x1001df08
          10941000    0x80004384 ret                            #; ra  = 0x80003f0c, goto 0x80003f0c
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:79:17)
#;     tls_ptr += size;
#;             ^
          10942000    0x80003f0c lw a0, 8(sp)                   #; sp  = 0x1001df08, a0  <~~ Word[0x1001df10], (lsu) s0  <-- 12
          10945000                                              #; (lsu) a0  <-- 0x1001df48
          10946000    0x80003f10 add a0, a0, s0                 #; a0  = 0x1001df48, s0  = 12, (wrb) a0  <-- 0x1001df54
          10947000    0x80003f14 sw a0, 8(sp)                   #; sp  = 0x1001df08, 0x1001df54 ~~> Word[0x1001df10]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
          10948000    0x80003f18 lw a0, 8(sp)                   #; sp  = 0x1001df08, a0  <~~ Word[0x1001df10]
#; .LBB25_25 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
          10949000    0x80003f1c auipc a1, 2                    #; (wrb) a1  <-- 0x80005f1c
          10950000    0x80003f20 addi a1, a1, -132              #; a1  = 0x80005f1c, (wrb) a1  <-- 0x80005e98
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
          10951000    0x80003f24 auipc a2, 2                    #; (wrb) a2  <-- 0x80005f24
          10952000    0x80003f28 addi a2, a2, -76               #; a2  = 0x80005f24, (wrb) a2  <-- 0x80005ed8
          10953000    0x80003f2c sub s0, a2, a1                 #; a2  = 0x80005ed8, a1  = 0x80005e98, (wrb) s0  <-- 64
          10954000    0x80003f30 li a1, 0                       #; (wrb) a1  <-- 0
          10955000    0x80003f34 mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
          10956000    0x80003f38 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f38
          10957000    0x80003f3c jalr 764(ra)                   #; ra  = 0x80003f38, (wrb) ra  <-- 0x80003f40, goto 0x80004234
          10958000                                              #; (lsu) a0  <-- 0x1001df54
#; memset (memset.S:30)
#;   li t1, 15
          10960000    0x80004234 li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
          10961000    0x80004238 mv a4, a0                      #; a0  = 0x1001df54, (wrb) a4  <-- 0x1001df54
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
          10962000    0x8000423c bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
          10965000    0x80004240 andi a5, a4, 15                #; a4  = 0x1001df54, (wrb) a5  <-- 4
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
          10966000    0x80004244 bnez a5, 160                   #; a5  = 4, taken, goto 0x800042e4
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
          10969000    0x800042e4 slli a3, a5, 2                 #; a5  = 4, (wrb) a3  <-- 16
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
          10970000    0x800042e8 auipc t0, 0                    #; (wrb) t0  <-- 0x800042e8
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
          10971000    0x800042ec add a3, a3, t0                 #; a3  = 16, t0  = 0x800042e8, (wrb) a3  <-- 0x800042f8
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
          10972000    0x800042f0 mv t0, ra                      #; ra  = 0x80003f40, (wrb) t0  <-- 0x80003f40
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
          10973000    0x800042f4 jalr -96(a3)                   #; a3  = 0x800042f8, (wrb) ra  <-- 0x800042f8, goto 0x80004298
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
          10976000    0x80004298 sb a1, 11(a4)                  #; a4  = 0x1001df54, 0 ~~> Byte[0x1001df5f]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
          10977000    0x8000429c sb a1, 10(a4)                  #; a4  = 0x1001df54, 0 ~~> Byte[0x1001df5e]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
          10978000    0x800042a0 sb a1, 9(a4)                   #; a4  = 0x1001df54, 0 ~~> Byte[0x1001df5d]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
          10979000    0x800042a4 sb a1, 8(a4)                   #; a4  = 0x1001df54, 0 ~~> Byte[0x1001df5c]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
          10980000    0x800042a8 sb a1, 7(a4)                   #; a4  = 0x1001df54, 0 ~~> Byte[0x1001df5b]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
          10981000    0x800042ac sb a1, 6(a4)                   #; a4  = 0x1001df54, 0 ~~> Byte[0x1001df5a]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
          10982000    0x800042b0 sb a1, 5(a4)                   #; a4  = 0x1001df54, 0 ~~> Byte[0x1001df59]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
          10983000    0x800042b4 sb a1, 4(a4)                   #; a4  = 0x1001df54, 0 ~~> Byte[0x1001df58]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          10984000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x1001df54, 0 ~~> Byte[0x1001df57]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          10985000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x1001df54, 0 ~~> Byte[0x1001df56]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          10986000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x1001df54, 0 ~~> Byte[0x1001df55]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          10987000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x1001df54, 0 ~~> Byte[0x1001df54]
#; .Ltable (memset.S:85)
#;   ret
          10988000    0x800042c8 ret                            #; ra  = 0x800042f8, goto 0x800042f8
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
          10989000    0x800042f8 mv ra, t0                      #; t0  = 0x80003f40, (wrb) ra  <-- 0x80003f40
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
          10990000    0x800042fc addi a5, a5, -16               #; a5  = 4, (wrb) a5  <-- -12
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
          10991000    0x80004300 sub a4, a4, a5                 #; a4  = 0x1001df54, a5  = -12, (wrb) a4  <-- 0x1001df60
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
          10992000    0x80004304 add a2, a2, a5                 #; a2  = 64, a5  = -12, (wrb) a2  <-- 52
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
          10993000    0x80004308 bgeu t1, a2, -144              #; t1  = 15, a2  = 52, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
          10994000    0x8000430c j -196                         #; goto 0x80004248
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
          10995000    0x80004248 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
          10996000    0x8000424c andi a3, a2, -16               #; a2  = 52, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
          10997000    0x80004250 andi a2, a2, 15                #; a2  = 52, (wrb) a2  <-- 4
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
          10998000    0x80004254 add a3, a3, a4                 #; a3  = 48, a4  = 0x1001df60, (wrb) a3  <-- 0x1001df90
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          10999000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001df60, 0 ~~> Word[0x1001df60]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11000000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001df60, 0 ~~> Word[0x1001df64]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11001000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001df60, 0 ~~> Word[0x1001df68]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11002000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001df60, 0 ~~> Word[0x1001df6c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11003000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001df60, (wrb) a4  <-- 0x1001df70
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11004000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001df70, a3  = 0x1001df90, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11005000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001df70, 0 ~~> Word[0x1001df70]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11006000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001df70, 0 ~~> Word[0x1001df74]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11007000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001df70, 0 ~~> Word[0x1001df78]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11008000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001df70, 0 ~~> Word[0x1001df7c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11009000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001df70, (wrb) a4  <-- 0x1001df80
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11010000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001df80, a3  = 0x1001df90, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11011000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001df80, 0 ~~> Word[0x1001df80]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11012000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001df80, 0 ~~> Word[0x1001df84]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11013000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001df80, 0 ~~> Word[0x1001df88]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11014000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001df80, 0 ~~> Word[0x1001df8c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11015000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001df80, (wrb) a4  <-- 0x1001df90
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11016000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001df90, a3  = 0x1001df90, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
          11017000    0x80004270 bnez a2, 8                     #; a2  = 4, taken, goto 0x80004278
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
          11018000    0x80004278 sub a3, t1, a2                 #; t1  = 15, a2  = 4, (wrb) a3  <-- 11
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
          11019000    0x8000427c slli a3, a3, 2                 #; a3  = 11, (wrb) a3  <-- 44
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
          11020000    0x80004280 auipc t0, 0                    #; (wrb) t0  <-- 0x80004280
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
          11021000    0x80004284 add a3, a3, t0                 #; a3  = 44, t0  = 0x80004280, (wrb) a3  <-- 0x800042ac
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
          11022000    0x80004288 jr 12(a3)                      #; a3  = 0x800042ac, goto 0x800042b8
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          11023000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x1001df90, 0 ~~> Byte[0x1001df93]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          11024000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x1001df90, 0 ~~> Byte[0x1001df92]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          11025000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x1001df90, 0 ~~> Byte[0x1001df91]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          11026000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x1001df90, 0 ~~> Byte[0x1001df90]
#; .Ltable (memset.S:85)
#;   ret
          11027000    0x800042c8 ret                            #; ra  = 0x80003f40, goto 0x80003f40
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
          11038000    0x80003f40 lw a0, 8(sp)                   #; sp  = 0x1001df08, a0  <~~ Word[0x1001df10]
          11041000                                              #; (lsu) a0  <-- 0x1001df54
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
          11042000    0x80003f44 addi a0, a0, 1032              #; a0  = 0x1001df54, (wrb) a0  <-- 0x1001e35c
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
          11043000    0x80003f48 li a1, 0                       #; (wrb) a1  <-- 0
          11044000    0x80003f4c mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
          11045000    0x80003f50 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f50
          11046000    0x80003f54 jalr 740(ra)                   #; ra  = 0x80003f50, (wrb) ra  <-- 0x80003f58, goto 0x80004234
#; memset (memset.S:30)
#;   li t1, 15
          11047000    0x80004234 li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
          11048000    0x80004238 mv a4, a0                      #; a0  = 0x1001e35c, (wrb) a4  <-- 0x1001e35c
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
          11049000    0x8000423c bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
          11050000    0x80004240 andi a5, a4, 15                #; a4  = 0x1001e35c, (wrb) a5  <-- 12
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
          11051000    0x80004244 bnez a5, 160                   #; a5  = 12, taken, goto 0x800042e4
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
          11052000    0x800042e4 slli a3, a5, 2                 #; a5  = 12, (wrb) a3  <-- 48
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
          11053000    0x800042e8 auipc t0, 0                    #; (wrb) t0  <-- 0x800042e8
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
          11054000    0x800042ec add a3, a3, t0                 #; a3  = 48, t0  = 0x800042e8, (wrb) a3  <-- 0x80004318
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
          11055000    0x800042f0 mv t0, ra                      #; ra  = 0x80003f58, (wrb) t0  <-- 0x80003f58
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
          11056000    0x800042f4 jalr -96(a3)                   #; a3  = 0x80004318, (wrb) ra  <-- 0x800042f8, goto 0x800042b8
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          11057000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x1001e35c, 0 ~~> Byte[0x1001e35f]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          11058000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x1001e35c, 0 ~~> Byte[0x1001e35e]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          11059000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x1001e35c, 0 ~~> Byte[0x1001e35d]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          11060000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x1001e35c, 0 ~~> Byte[0x1001e35c]
#; .Ltable (memset.S:85)
#;   ret
          11061000    0x800042c8 ret                            #; ra  = 0x800042f8, goto 0x800042f8
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
          11062000    0x800042f8 mv ra, t0                      #; t0  = 0x80003f58, (wrb) ra  <-- 0x80003f58
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
          11063000    0x800042fc addi a5, a5, -16               #; a5  = 12, (wrb) a5  <-- -4
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
          11064000    0x80004300 sub a4, a4, a5                 #; a4  = 0x1001e35c, a5  = -4, (wrb) a4  <-- 0x1001e360
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
          11065000    0x80004304 add a2, a2, a5                 #; a2  = 64, a5  = -4, (wrb) a2  <-- 60
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
          11066000    0x80004308 bgeu t1, a2, -144              #; t1  = 15, a2  = 60, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
          11067000    0x8000430c j -196                         #; goto 0x80004248
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
          11068000    0x80004248 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
          11069000    0x8000424c andi a3, a2, -16               #; a2  = 60, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
          11070000    0x80004250 andi a2, a2, 15                #; a2  = 60, (wrb) a2  <-- 12
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
          11071000    0x80004254 add a3, a3, a4                 #; a3  = 48, a4  = 0x1001e360, (wrb) a3  <-- 0x1001e390
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11072000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001e360, 0 ~~> Word[0x1001e360]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11073000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001e360, 0 ~~> Word[0x1001e364]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11074000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001e360, 0 ~~> Word[0x1001e368]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11075000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001e360, 0 ~~> Word[0x1001e36c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11076000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001e360, (wrb) a4  <-- 0x1001e370
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11077000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001e370, a3  = 0x1001e390, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11078000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001e370, 0 ~~> Word[0x1001e370]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11079000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001e370, 0 ~~> Word[0x1001e374]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11080000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001e370, 0 ~~> Word[0x1001e378]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11081000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001e370, 0 ~~> Word[0x1001e37c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11082000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001e370, (wrb) a4  <-- 0x1001e380
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11083000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001e380, a3  = 0x1001e390, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11084000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001e380, 0 ~~> Word[0x1001e380]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11085000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001e380, 0 ~~> Word[0x1001e384]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11086000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001e380, 0 ~~> Word[0x1001e388]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11087000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001e380, 0 ~~> Word[0x1001e38c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11088000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001e380, (wrb) a4  <-- 0x1001e390
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11089000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001e390, a3  = 0x1001e390, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
          11090000    0x80004270 bnez a2, 8                     #; a2  = 12, taken, goto 0x80004278
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
          11091000    0x80004278 sub a3, t1, a2                 #; t1  = 15, a2  = 12, (wrb) a3  <-- 3
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
          11092000    0x8000427c slli a3, a3, 2                 #; a3  = 3, (wrb) a3  <-- 12
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
          11093000    0x80004280 auipc t0, 0                    #; (wrb) t0  <-- 0x80004280
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
          11094000    0x80004284 add a3, a3, t0                 #; a3  = 12, t0  = 0x80004280, (wrb) a3  <-- 0x8000428c
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
          11095000    0x80004288 jr 12(a3)                      #; a3  = 0x8000428c, goto 0x80004298
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
          11096000    0x80004298 sb a1, 11(a4)                  #; a4  = 0x1001e390, 0 ~~> Byte[0x1001e39b]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
          11097000    0x8000429c sb a1, 10(a4)                  #; a4  = 0x1001e390, 0 ~~> Byte[0x1001e39a]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
          11098000    0x800042a0 sb a1, 9(a4)                   #; a4  = 0x1001e390, 0 ~~> Byte[0x1001e399]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
          11099000    0x800042a4 sb a1, 8(a4)                   #; a4  = 0x1001e390, 0 ~~> Byte[0x1001e398]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
          11100000    0x800042a8 sb a1, 7(a4)                   #; a4  = 0x1001e390, 0 ~~> Byte[0x1001e397]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
          11101000    0x800042ac sb a1, 6(a4)                   #; a4  = 0x1001e390, 0 ~~> Byte[0x1001e396]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
          11102000    0x800042b0 sb a1, 5(a4)                   #; a4  = 0x1001e390, 0 ~~> Byte[0x1001e395]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
          11103000    0x800042b4 sb a1, 4(a4)                   #; a4  = 0x1001e390, 0 ~~> Byte[0x1001e394]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          11104000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x1001e390, 0 ~~> Byte[0x1001e393]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          11105000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x1001e390, 0 ~~> Byte[0x1001e392]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          11106000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x1001e390, 0 ~~> Byte[0x1001e391]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          11107000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x1001e390, 0 ~~> Byte[0x1001e390]
#; .Ltable (memset.S:85)
#;   ret
          11108000    0x800042c8 ret                            #; ra  = 0x80003f58, goto 0x80003f58
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
          11109000    0x80003f58 lw a0, 8(sp)                   #; sp  = 0x1001df08, a0  <~~ Word[0x1001df10]
          11112000                                              #; (lsu) a0  <-- 0x1001df54
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
          11113000    0x80003f5c add a0, a0, s1                 #; a0  = 0x1001df54, s1  = 2064, (wrb) a0  <-- 0x1001e764
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
          11114000    0x80003f60 li a1, 0                       #; (wrb) a1  <-- 0
          11115000    0x80003f64 mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
          11116000    0x80003f68 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f68
          11117000    0x80003f6c jalr 716(ra)                   #; ra  = 0x80003f68, (wrb) ra  <-- 0x80003f70, goto 0x80004234
#; memset (memset.S:30)
#;   li t1, 15
          11118000    0x80004234 li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
          11119000    0x80004238 mv a4, a0                      #; a0  = 0x1001e764, (wrb) a4  <-- 0x1001e764
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
          11120000    0x8000423c bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
          11121000    0x80004240 andi a5, a4, 15                #; a4  = 0x1001e764, (wrb) a5  <-- 4
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
          11122000    0x80004244 bnez a5, 160                   #; a5  = 4, taken, goto 0x800042e4
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
          11123000    0x800042e4 slli a3, a5, 2                 #; a5  = 4, (wrb) a3  <-- 16
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
          11124000    0x800042e8 auipc t0, 0                    #; (wrb) t0  <-- 0x800042e8
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
          11125000    0x800042ec add a3, a3, t0                 #; a3  = 16, t0  = 0x800042e8, (wrb) a3  <-- 0x800042f8
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
          11126000    0x800042f0 mv t0, ra                      #; ra  = 0x80003f70, (wrb) t0  <-- 0x80003f70
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
          11127000    0x800042f4 jalr -96(a3)                   #; a3  = 0x800042f8, (wrb) ra  <-- 0x800042f8, goto 0x80004298
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
          11128000    0x80004298 sb a1, 11(a4)                  #; a4  = 0x1001e764, 0 ~~> Byte[0x1001e76f]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
          11129000    0x8000429c sb a1, 10(a4)                  #; a4  = 0x1001e764, 0 ~~> Byte[0x1001e76e]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
          11132000    0x800042a0 sb a1, 9(a4)                   #; a4  = 0x1001e764, 0 ~~> Byte[0x1001e76d]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
          11134000    0x800042a4 sb a1, 8(a4)                   #; a4  = 0x1001e764, 0 ~~> Byte[0x1001e76c]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
          11135000    0x800042a8 sb a1, 7(a4)                   #; a4  = 0x1001e764, 0 ~~> Byte[0x1001e76b]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
          11136000    0x800042ac sb a1, 6(a4)                   #; a4  = 0x1001e764, 0 ~~> Byte[0x1001e76a]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
          11137000    0x800042b0 sb a1, 5(a4)                   #; a4  = 0x1001e764, 0 ~~> Byte[0x1001e769]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
          11138000    0x800042b4 sb a1, 4(a4)                   #; a4  = 0x1001e764, 0 ~~> Byte[0x1001e768]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          11139000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x1001e764, 0 ~~> Byte[0x1001e767]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          11140000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x1001e764, 0 ~~> Byte[0x1001e766]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          11141000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x1001e764, 0 ~~> Byte[0x1001e765]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          11142000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x1001e764, 0 ~~> Byte[0x1001e764]
#; .Ltable (memset.S:85)
#;   ret
          11143000    0x800042c8 ret                            #; ra  = 0x800042f8, goto 0x800042f8
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
          11144000    0x800042f8 mv ra, t0                      #; t0  = 0x80003f70, (wrb) ra  <-- 0x80003f70
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
          11145000    0x800042fc addi a5, a5, -16               #; a5  = 4, (wrb) a5  <-- -12
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
          11146000    0x80004300 sub a4, a4, a5                 #; a4  = 0x1001e764, a5  = -12, (wrb) a4  <-- 0x1001e770
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
          11147000    0x80004304 add a2, a2, a5                 #; a2  = 64, a5  = -12, (wrb) a2  <-- 52
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
          11148000    0x80004308 bgeu t1, a2, -144              #; t1  = 15, a2  = 52, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
          11149000    0x8000430c j -196                         #; goto 0x80004248
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
          11150000    0x80004248 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
          11151000    0x8000424c andi a3, a2, -16               #; a2  = 52, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
          11152000    0x80004250 andi a2, a2, 15                #; a2  = 52, (wrb) a2  <-- 4
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
          11153000    0x80004254 add a3, a3, a4                 #; a3  = 48, a4  = 0x1001e770, (wrb) a3  <-- 0x1001e7a0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11154000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001e770, 0 ~~> Word[0x1001e770]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11155000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001e770, 0 ~~> Word[0x1001e774]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11156000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001e770, 0 ~~> Word[0x1001e778]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11157000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001e770, 0 ~~> Word[0x1001e77c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11158000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001e770, (wrb) a4  <-- 0x1001e780
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11159000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001e780, a3  = 0x1001e7a0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11160000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001e780, 0 ~~> Word[0x1001e780]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11161000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001e780, 0 ~~> Word[0x1001e784]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11162000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001e780, 0 ~~> Word[0x1001e788]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11163000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001e780, 0 ~~> Word[0x1001e78c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11164000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001e780, (wrb) a4  <-- 0x1001e790
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11165000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001e790, a3  = 0x1001e7a0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11166000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001e790, 0 ~~> Word[0x1001e790]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11167000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001e790, 0 ~~> Word[0x1001e794]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11168000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001e790, 0 ~~> Word[0x1001e798]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11169000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001e790, 0 ~~> Word[0x1001e79c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11170000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001e790, (wrb) a4  <-- 0x1001e7a0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11171000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001e7a0, a3  = 0x1001e7a0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
          11172000    0x80004270 bnez a2, 8                     #; a2  = 4, taken, goto 0x80004278
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
          11173000    0x80004278 sub a3, t1, a2                 #; t1  = 15, a2  = 4, (wrb) a3  <-- 11
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
          11174000    0x8000427c slli a3, a3, 2                 #; a3  = 11, (wrb) a3  <-- 44
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
          11175000    0x80004280 auipc t0, 0                    #; (wrb) t0  <-- 0x80004280
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
          11176000    0x80004284 add a3, a3, t0                 #; a3  = 44, t0  = 0x80004280, (wrb) a3  <-- 0x800042ac
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
          11177000    0x80004288 jr 12(a3)                      #; a3  = 0x800042ac, goto 0x800042b8
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          11178000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x1001e7a0, 0 ~~> Byte[0x1001e7a3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          11179000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x1001e7a0, 0 ~~> Byte[0x1001e7a2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          11180000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x1001e7a0, 0 ~~> Byte[0x1001e7a1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          11181000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x1001e7a0, 0 ~~> Byte[0x1001e7a0]
#; .Ltable (memset.S:85)
#;   ret
          11182000    0x800042c8 ret                            #; ra  = 0x80003f70, goto 0x80003f70
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
          11183000    0x80003f70 lw a0, 8(sp)                   #; sp  = 0x1001df08, a0  <~~ Word[0x1001df10]
          11186000                                              #; (lsu) a0  <-- 0x1001df54
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
          11187000    0x80003f74 add a0, a0, s6                 #; a0  = 0x1001df54, s6  = 3096, (wrb) a0  <-- 0x1001eb6c
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
          11188000    0x80003f78 li a1, 0                       #; (wrb) a1  <-- 0
          11189000    0x80003f7c mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
          11203000    0x80003f80 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f80
          11204000    0x80003f84 jalr 692(ra)                   #; ra  = 0x80003f80, (wrb) ra  <-- 0x80003f88, goto 0x80004234
#; memset (memset.S:30)
#;   li t1, 15
          11205000    0x80004234 li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
          11206000    0x80004238 mv a4, a0                      #; a0  = 0x1001eb6c, (wrb) a4  <-- 0x1001eb6c
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
          11207000    0x8000423c bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
          11208000    0x80004240 andi a5, a4, 15                #; a4  = 0x1001eb6c, (wrb) a5  <-- 12
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
          11209000    0x80004244 bnez a5, 160                   #; a5  = 12, taken, goto 0x800042e4
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
          11210000    0x800042e4 slli a3, a5, 2                 #; a5  = 12, (wrb) a3  <-- 48
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
          11211000    0x800042e8 auipc t0, 0                    #; (wrb) t0  <-- 0x800042e8
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
          11212000    0x800042ec add a3, a3, t0                 #; a3  = 48, t0  = 0x800042e8, (wrb) a3  <-- 0x80004318
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
          11213000    0x800042f0 mv t0, ra                      #; ra  = 0x80003f88, (wrb) t0  <-- 0x80003f88
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
          11214000    0x800042f4 jalr -96(a3)                   #; a3  = 0x80004318, (wrb) ra  <-- 0x800042f8, goto 0x800042b8
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          11215000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x1001eb6c, 0 ~~> Byte[0x1001eb6f]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          11216000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x1001eb6c, 0 ~~> Byte[0x1001eb6e]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          11217000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x1001eb6c, 0 ~~> Byte[0x1001eb6d]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          11218000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x1001eb6c, 0 ~~> Byte[0x1001eb6c]
#; .Ltable (memset.S:85)
#;   ret
          11219000    0x800042c8 ret                            #; ra  = 0x800042f8, goto 0x800042f8
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
          11220000    0x800042f8 mv ra, t0                      #; t0  = 0x80003f88, (wrb) ra  <-- 0x80003f88
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
          11221000    0x800042fc addi a5, a5, -16               #; a5  = 12, (wrb) a5  <-- -4
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
          11222000    0x80004300 sub a4, a4, a5                 #; a4  = 0x1001eb6c, a5  = -4, (wrb) a4  <-- 0x1001eb70
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
          11223000    0x80004304 add a2, a2, a5                 #; a2  = 64, a5  = -4, (wrb) a2  <-- 60
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
          11224000    0x80004308 bgeu t1, a2, -144              #; t1  = 15, a2  = 60, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
          11225000    0x8000430c j -196                         #; goto 0x80004248
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
          11226000    0x80004248 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
          11227000    0x8000424c andi a3, a2, -16               #; a2  = 60, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
          11228000    0x80004250 andi a2, a2, 15                #; a2  = 60, (wrb) a2  <-- 12
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
          11229000    0x80004254 add a3, a3, a4                 #; a3  = 48, a4  = 0x1001eb70, (wrb) a3  <-- 0x1001eba0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11230000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001eb70, 0 ~~> Word[0x1001eb70]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11231000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001eb70, 0 ~~> Word[0x1001eb74]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11232000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001eb70, 0 ~~> Word[0x1001eb78]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11233000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001eb70, 0 ~~> Word[0x1001eb7c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11234000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001eb70, (wrb) a4  <-- 0x1001eb80
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11235000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001eb80, a3  = 0x1001eba0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11236000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001eb80, 0 ~~> Word[0x1001eb80]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11237000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001eb80, 0 ~~> Word[0x1001eb84]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11238000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001eb80, 0 ~~> Word[0x1001eb88]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11239000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001eb80, 0 ~~> Word[0x1001eb8c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11240000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001eb80, (wrb) a4  <-- 0x1001eb90
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11241000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001eb90, a3  = 0x1001eba0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11242000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001eb90, 0 ~~> Word[0x1001eb90]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11243000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001eb90, 0 ~~> Word[0x1001eb94]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11244000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001eb90, 0 ~~> Word[0x1001eb98]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11245000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001eb90, 0 ~~> Word[0x1001eb9c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11246000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001eb90, (wrb) a4  <-- 0x1001eba0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11247000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001eba0, a3  = 0x1001eba0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
          11248000    0x80004270 bnez a2, 8                     #; a2  = 12, taken, goto 0x80004278
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
          11249000    0x80004278 sub a3, t1, a2                 #; t1  = 15, a2  = 12, (wrb) a3  <-- 3
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
          11250000    0x8000427c slli a3, a3, 2                 #; a3  = 3, (wrb) a3  <-- 12
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
          11251000    0x80004280 auipc t0, 0                    #; (wrb) t0  <-- 0x80004280
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
          11252000    0x80004284 add a3, a3, t0                 #; a3  = 12, t0  = 0x80004280, (wrb) a3  <-- 0x8000428c
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
          11253000    0x80004288 jr 12(a3)                      #; a3  = 0x8000428c, goto 0x80004298
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
          11254000    0x80004298 sb a1, 11(a4)                  #; a4  = 0x1001eba0, 0 ~~> Byte[0x1001ebab]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
          11255000    0x8000429c sb a1, 10(a4)                  #; a4  = 0x1001eba0, 0 ~~> Byte[0x1001ebaa]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
          11256000    0x800042a0 sb a1, 9(a4)                   #; a4  = 0x1001eba0, 0 ~~> Byte[0x1001eba9]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
          11257000    0x800042a4 sb a1, 8(a4)                   #; a4  = 0x1001eba0, 0 ~~> Byte[0x1001eba8]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
          11258000    0x800042a8 sb a1, 7(a4)                   #; a4  = 0x1001eba0, 0 ~~> Byte[0x1001eba7]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
          11259000    0x800042ac sb a1, 6(a4)                   #; a4  = 0x1001eba0, 0 ~~> Byte[0x1001eba6]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
          11260000    0x800042b0 sb a1, 5(a4)                   #; a4  = 0x1001eba0, 0 ~~> Byte[0x1001eba5]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
          11261000    0x800042b4 sb a1, 4(a4)                   #; a4  = 0x1001eba0, 0 ~~> Byte[0x1001eba4]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          11262000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x1001eba0, 0 ~~> Byte[0x1001eba3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          11263000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x1001eba0, 0 ~~> Byte[0x1001eba2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          11264000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x1001eba0, 0 ~~> Byte[0x1001eba1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          11265000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x1001eba0, 0 ~~> Byte[0x1001eba0]
#; .Ltable (memset.S:85)
#;   ret
          11266000    0x800042c8 ret                            #; ra  = 0x80003f88, goto 0x80003f88
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
          11267000    0x80003f88 lw a0, 8(sp)                   #; sp  = 0x1001df08, a0  <~~ Word[0x1001df10]
          11270000                                              #; (lsu) a0  <-- 0x1001df54
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
          11271000    0x80003f8c add a0, a0, s7                 #; a0  = 0x1001df54, s7  = 4128, (wrb) a0  <-- 0x1001ef74
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
          11272000    0x80003f90 li a1, 0                       #; (wrb) a1  <-- 0
          11273000    0x80003f94 mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
          11274000    0x80003f98 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f98
          11275000    0x80003f9c jalr 668(ra)                   #; ra  = 0x80003f98, (wrb) ra  <-- 0x80003fa0, goto 0x80004234
#; memset (memset.S:30)
#;   li t1, 15
          11276000    0x80004234 li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
          11277000    0x80004238 mv a4, a0                      #; a0  = 0x1001ef74, (wrb) a4  <-- 0x1001ef74
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
          11278000    0x8000423c bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
          11279000    0x80004240 andi a5, a4, 15                #; a4  = 0x1001ef74, (wrb) a5  <-- 4
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
          11280000    0x80004244 bnez a5, 160                   #; a5  = 4, taken, goto 0x800042e4
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
          11281000    0x800042e4 slli a3, a5, 2                 #; a5  = 4, (wrb) a3  <-- 16
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
          11282000    0x800042e8 auipc t0, 0                    #; (wrb) t0  <-- 0x800042e8
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
          11283000    0x800042ec add a3, a3, t0                 #; a3  = 16, t0  = 0x800042e8, (wrb) a3  <-- 0x800042f8
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
          11284000    0x800042f0 mv t0, ra                      #; ra  = 0x80003fa0, (wrb) t0  <-- 0x80003fa0
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
          11285000    0x800042f4 jalr -96(a3)                   #; a3  = 0x800042f8, (wrb) ra  <-- 0x800042f8, goto 0x80004298
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
          11286000    0x80004298 sb a1, 11(a4)                  #; a4  = 0x1001ef74, 0 ~~> Byte[0x1001ef7f]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
          11287000    0x8000429c sb a1, 10(a4)                  #; a4  = 0x1001ef74, 0 ~~> Byte[0x1001ef7e]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
          11289000    0x800042a0 sb a1, 9(a4)                   #; a4  = 0x1001ef74, 0 ~~> Byte[0x1001ef7d]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
          11291000    0x800042a4 sb a1, 8(a4)                   #; a4  = 0x1001ef74, 0 ~~> Byte[0x1001ef7c]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
          11292000    0x800042a8 sb a1, 7(a4)                   #; a4  = 0x1001ef74, 0 ~~> Byte[0x1001ef7b]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
          11293000    0x800042ac sb a1, 6(a4)                   #; a4  = 0x1001ef74, 0 ~~> Byte[0x1001ef7a]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
          11294000    0x800042b0 sb a1, 5(a4)                   #; a4  = 0x1001ef74, 0 ~~> Byte[0x1001ef79]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
          11295000    0x800042b4 sb a1, 4(a4)                   #; a4  = 0x1001ef74, 0 ~~> Byte[0x1001ef78]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          11296000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x1001ef74, 0 ~~> Byte[0x1001ef77]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          11297000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x1001ef74, 0 ~~> Byte[0x1001ef76]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          11298000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x1001ef74, 0 ~~> Byte[0x1001ef75]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          11299000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x1001ef74, 0 ~~> Byte[0x1001ef74]
#; .Ltable (memset.S:85)
#;   ret
          11300000    0x800042c8 ret                            #; ra  = 0x800042f8, goto 0x800042f8
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
          11301000    0x800042f8 mv ra, t0                      #; t0  = 0x80003fa0, (wrb) ra  <-- 0x80003fa0
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
          11302000    0x800042fc addi a5, a5, -16               #; a5  = 4, (wrb) a5  <-- -12
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
          11303000    0x80004300 sub a4, a4, a5                 #; a4  = 0x1001ef74, a5  = -12, (wrb) a4  <-- 0x1001ef80
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
          11304000    0x80004304 add a2, a2, a5                 #; a2  = 64, a5  = -12, (wrb) a2  <-- 52
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
          11305000    0x80004308 bgeu t1, a2, -144              #; t1  = 15, a2  = 52, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
          11306000    0x8000430c j -196                         #; goto 0x80004248
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
          11307000    0x80004248 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
          11308000    0x8000424c andi a3, a2, -16               #; a2  = 52, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
          11309000    0x80004250 andi a2, a2, 15                #; a2  = 52, (wrb) a2  <-- 4
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
          11310000    0x80004254 add a3, a3, a4                 #; a3  = 48, a4  = 0x1001ef80, (wrb) a3  <-- 0x1001efb0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11311000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001ef80, 0 ~~> Word[0x1001ef80]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11312000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001ef80, 0 ~~> Word[0x1001ef84]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11313000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001ef80, 0 ~~> Word[0x1001ef88]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11314000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001ef80, 0 ~~> Word[0x1001ef8c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11315000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001ef80, (wrb) a4  <-- 0x1001ef90
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11316000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001ef90, a3  = 0x1001efb0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11317000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001ef90, 0 ~~> Word[0x1001ef90]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11318000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001ef90, 0 ~~> Word[0x1001ef94]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11319000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001ef90, 0 ~~> Word[0x1001ef98]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11320000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001ef90, 0 ~~> Word[0x1001ef9c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11321000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001ef90, (wrb) a4  <-- 0x1001efa0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11322000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001efa0, a3  = 0x1001efb0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11323000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001efa0, 0 ~~> Word[0x1001efa0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11324000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001efa0, 0 ~~> Word[0x1001efa4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11325000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001efa0, 0 ~~> Word[0x1001efa8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11326000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001efa0, 0 ~~> Word[0x1001efac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11327000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001efa0, (wrb) a4  <-- 0x1001efb0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11328000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001efb0, a3  = 0x1001efb0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
          11329000    0x80004270 bnez a2, 8                     #; a2  = 4, taken, goto 0x80004278
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
          11330000    0x80004278 sub a3, t1, a2                 #; t1  = 15, a2  = 4, (wrb) a3  <-- 11
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
          11331000    0x8000427c slli a3, a3, 2                 #; a3  = 11, (wrb) a3  <-- 44
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
          11332000    0x80004280 auipc t0, 0                    #; (wrb) t0  <-- 0x80004280
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
          11333000    0x80004284 add a3, a3, t0                 #; a3  = 44, t0  = 0x80004280, (wrb) a3  <-- 0x800042ac
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
          11334000    0x80004288 jr 12(a3)                      #; a3  = 0x800042ac, goto 0x800042b8
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          11335000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x1001efb0, 0 ~~> Byte[0x1001efb3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          11336000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x1001efb0, 0 ~~> Byte[0x1001efb2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          11337000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x1001efb0, 0 ~~> Byte[0x1001efb1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          11338000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x1001efb0, 0 ~~> Byte[0x1001efb0]
#; .Ltable (memset.S:85)
#;   ret
          11339000    0x800042c8 ret                            #; ra  = 0x80003fa0, goto 0x80003fa0
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
          11340000    0x80003fa0 lw a0, 8(sp)                   #; sp  = 0x1001df08, a0  <~~ Word[0x1001df10]
          11343000                                              #; (lsu) a0  <-- 0x1001df54
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
          11344000    0x80003fa4 add a0, a0, s8                 #; a0  = 0x1001df54, s8  = 5160, (wrb) a0  <-- 0x1001f37c
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
          11345000    0x80003fa8 li a1, 0                       #; (wrb) a1  <-- 0
          11346000    0x80003fac mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
          11347000    0x80003fb0 auipc ra, 0                    #; (wrb) ra  <-- 0x80003fb0
          11348000    0x80003fb4 jalr 644(ra)                   #; ra  = 0x80003fb0, (wrb) ra  <-- 0x80003fb8, goto 0x80004234
#; memset (memset.S:30)
#;   li t1, 15
          11349000    0x80004234 li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
          11350000    0x80004238 mv a4, a0                      #; a0  = 0x1001f37c, (wrb) a4  <-- 0x1001f37c
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
          11351000    0x8000423c bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
          11352000    0x80004240 andi a5, a4, 15                #; a4  = 0x1001f37c, (wrb) a5  <-- 12
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
          11353000    0x80004244 bnez a5, 160                   #; a5  = 12, taken, goto 0x800042e4
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
          11354000    0x800042e4 slli a3, a5, 2                 #; a5  = 12, (wrb) a3  <-- 48
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
          11355000    0x800042e8 auipc t0, 0                    #; (wrb) t0  <-- 0x800042e8
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
          11356000    0x800042ec add a3, a3, t0                 #; a3  = 48, t0  = 0x800042e8, (wrb) a3  <-- 0x80004318
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
          11357000    0x800042f0 mv t0, ra                      #; ra  = 0x80003fb8, (wrb) t0  <-- 0x80003fb8
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
          11358000    0x800042f4 jalr -96(a3)                   #; a3  = 0x80004318, (wrb) ra  <-- 0x800042f8, goto 0x800042b8
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          11359000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x1001f37c, 0 ~~> Byte[0x1001f37f]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          11360000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x1001f37c, 0 ~~> Byte[0x1001f37e]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          11361000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x1001f37c, 0 ~~> Byte[0x1001f37d]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          11362000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x1001f37c, 0 ~~> Byte[0x1001f37c]
#; .Ltable (memset.S:85)
#;   ret
          11363000    0x800042c8 ret                            #; ra  = 0x800042f8, goto 0x800042f8
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
          11364000    0x800042f8 mv ra, t0                      #; t0  = 0x80003fb8, (wrb) ra  <-- 0x80003fb8
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
          11365000    0x800042fc addi a5, a5, -16               #; a5  = 12, (wrb) a5  <-- -4
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
          11366000    0x80004300 sub a4, a4, a5                 #; a4  = 0x1001f37c, a5  = -4, (wrb) a4  <-- 0x1001f380
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
          11367000    0x80004304 add a2, a2, a5                 #; a2  = 64, a5  = -4, (wrb) a2  <-- 60
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
          11368000    0x80004308 bgeu t1, a2, -144              #; t1  = 15, a2  = 60, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
          11369000    0x8000430c j -196                         #; goto 0x80004248
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
          11370000    0x80004248 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
          11371000    0x8000424c andi a3, a2, -16               #; a2  = 60, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
          11372000    0x80004250 andi a2, a2, 15                #; a2  = 60, (wrb) a2  <-- 12
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
          11373000    0x80004254 add a3, a3, a4                 #; a3  = 48, a4  = 0x1001f380, (wrb) a3  <-- 0x1001f3b0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11374000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001f380, 0 ~~> Word[0x1001f380]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11375000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001f380, 0 ~~> Word[0x1001f384]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11376000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001f380, 0 ~~> Word[0x1001f388]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11377000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001f380, 0 ~~> Word[0x1001f38c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11378000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001f380, (wrb) a4  <-- 0x1001f390
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11379000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001f390, a3  = 0x1001f3b0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11380000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001f390, 0 ~~> Word[0x1001f390]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11381000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001f390, 0 ~~> Word[0x1001f394]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11382000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001f390, 0 ~~> Word[0x1001f398]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11383000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001f390, 0 ~~> Word[0x1001f39c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11384000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001f390, (wrb) a4  <-- 0x1001f3a0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11385000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001f3a0, a3  = 0x1001f3b0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11386000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001f3a0, 0 ~~> Word[0x1001f3a0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11387000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001f3a0, 0 ~~> Word[0x1001f3a4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11388000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001f3a0, 0 ~~> Word[0x1001f3a8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11389000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001f3a0, 0 ~~> Word[0x1001f3ac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11390000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001f3a0, (wrb) a4  <-- 0x1001f3b0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11391000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001f3b0, a3  = 0x1001f3b0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
          11392000    0x80004270 bnez a2, 8                     #; a2  = 12, taken, goto 0x80004278
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
          11393000    0x80004278 sub a3, t1, a2                 #; t1  = 15, a2  = 12, (wrb) a3  <-- 3
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
          11394000    0x8000427c slli a3, a3, 2                 #; a3  = 3, (wrb) a3  <-- 12
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
          11395000    0x80004280 auipc t0, 0                    #; (wrb) t0  <-- 0x80004280
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
          11396000    0x80004284 add a3, a3, t0                 #; a3  = 12, t0  = 0x80004280, (wrb) a3  <-- 0x8000428c
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
          11397000    0x80004288 jr 12(a3)                      #; a3  = 0x8000428c, goto 0x80004298
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
          11398000    0x80004298 sb a1, 11(a4)                  #; a4  = 0x1001f3b0, 0 ~~> Byte[0x1001f3bb]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
          11399000    0x8000429c sb a1, 10(a4)                  #; a4  = 0x1001f3b0, 0 ~~> Byte[0x1001f3ba]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
          11400000    0x800042a0 sb a1, 9(a4)                   #; a4  = 0x1001f3b0, 0 ~~> Byte[0x1001f3b9]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
          11401000    0x800042a4 sb a1, 8(a4)                   #; a4  = 0x1001f3b0, 0 ~~> Byte[0x1001f3b8]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
          11402000    0x800042a8 sb a1, 7(a4)                   #; a4  = 0x1001f3b0, 0 ~~> Byte[0x1001f3b7]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
          11403000    0x800042ac sb a1, 6(a4)                   #; a4  = 0x1001f3b0, 0 ~~> Byte[0x1001f3b6]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
          11405000    0x800042b0 sb a1, 5(a4)                   #; a4  = 0x1001f3b0, 0 ~~> Byte[0x1001f3b5]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
          11407000    0x800042b4 sb a1, 4(a4)                   #; a4  = 0x1001f3b0, 0 ~~> Byte[0x1001f3b4]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          11408000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x1001f3b0, 0 ~~> Byte[0x1001f3b3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          11409000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x1001f3b0, 0 ~~> Byte[0x1001f3b2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          11410000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x1001f3b0, 0 ~~> Byte[0x1001f3b1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          11411000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x1001f3b0, 0 ~~> Byte[0x1001f3b0]
#; .Ltable (memset.S:85)
#;   ret
          11412000    0x800042c8 ret                            #; ra  = 0x80003fb8, goto 0x80003fb8
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
          11413000    0x80003fb8 lw a0, 8(sp)                   #; sp  = 0x1001df08, a0  <~~ Word[0x1001df10]
          11416000                                              #; (lsu) a0  <-- 0x1001df54
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
          11417000    0x80003fbc add a0, a0, s9                 #; a0  = 0x1001df54, s9  = 6192, (wrb) a0  <-- 0x1001f784
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
          11428000    0x80003fc0 li a1, 0                       #; (wrb) a1  <-- 0
          11429000    0x80003fc4 mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
          11430000    0x80003fc8 auipc ra, 0                    #; (wrb) ra  <-- 0x80003fc8
          11431000    0x80003fcc jalr 620(ra)                   #; ra  = 0x80003fc8, (wrb) ra  <-- 0x80003fd0, goto 0x80004234
#; memset (memset.S:30)
#;   li t1, 15
          11432000    0x80004234 li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
          11433000    0x80004238 mv a4, a0                      #; a0  = 0x1001f784, (wrb) a4  <-- 0x1001f784
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
          11434000    0x8000423c bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
          11435000    0x80004240 andi a5, a4, 15                #; a4  = 0x1001f784, (wrb) a5  <-- 4
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
          11436000    0x80004244 bnez a5, 160                   #; a5  = 4, taken, goto 0x800042e4
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
          11437000    0x800042e4 slli a3, a5, 2                 #; a5  = 4, (wrb) a3  <-- 16
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
          11438000    0x800042e8 auipc t0, 0                    #; (wrb) t0  <-- 0x800042e8
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
          11439000    0x800042ec add a3, a3, t0                 #; a3  = 16, t0  = 0x800042e8, (wrb) a3  <-- 0x800042f8
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
          11440000    0x800042f0 mv t0, ra                      #; ra  = 0x80003fd0, (wrb) t0  <-- 0x80003fd0
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
          11441000    0x800042f4 jalr -96(a3)                   #; a3  = 0x800042f8, (wrb) ra  <-- 0x800042f8, goto 0x80004298
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
          11442000    0x80004298 sb a1, 11(a4)                  #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f78f]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
          11443000    0x8000429c sb a1, 10(a4)                  #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f78e]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
          11444000    0x800042a0 sb a1, 9(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f78d]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
          11445000    0x800042a4 sb a1, 8(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f78c]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
          11446000    0x800042a8 sb a1, 7(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f78b]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
          11447000    0x800042ac sb a1, 6(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f78a]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
          11448000    0x800042b0 sb a1, 5(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f789]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
          11449000    0x800042b4 sb a1, 4(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f788]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          11450000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f787]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          11451000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f786]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          11452000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f785]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          11453000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f784]
#; .Ltable (memset.S:85)
#;   ret
          11454000    0x800042c8 ret                            #; ra  = 0x800042f8, goto 0x800042f8
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
          11455000    0x800042f8 mv ra, t0                      #; t0  = 0x80003fd0, (wrb) ra  <-- 0x80003fd0
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
          11456000    0x800042fc addi a5, a5, -16               #; a5  = 4, (wrb) a5  <-- -12
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
          11459000    0x80004300 sub a4, a4, a5                 #; a4  = 0x1001f784, a5  = -12, (wrb) a4  <-- 0x1001f790
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
          11460000    0x80004304 add a2, a2, a5                 #; a2  = 64, a5  = -12, (wrb) a2  <-- 52
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
          11461000    0x80004308 bgeu t1, a2, -144              #; t1  = 15, a2  = 52, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
          11462000    0x8000430c j -196                         #; goto 0x80004248
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
          11463000    0x80004248 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
          11464000    0x8000424c andi a3, a2, -16               #; a2  = 52, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
          11465000    0x80004250 andi a2, a2, 15                #; a2  = 52, (wrb) a2  <-- 4
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
          11466000    0x80004254 add a3, a3, a4                 #; a3  = 48, a4  = 0x1001f790, (wrb) a3  <-- 0x1001f7c0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11467000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001f790, 0 ~~> Word[0x1001f790]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11468000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001f790, 0 ~~> Word[0x1001f794]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11470000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001f790, 0 ~~> Word[0x1001f798]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11472000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001f790, 0 ~~> Word[0x1001f79c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11473000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001f790, (wrb) a4  <-- 0x1001f7a0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11474000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001f7a0, a3  = 0x1001f7c0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11475000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001f7a0, 0 ~~> Word[0x1001f7a0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11476000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001f7a0, 0 ~~> Word[0x1001f7a4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11478000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001f7a0, 0 ~~> Word[0x1001f7a8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11479000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001f7a0, 0 ~~> Word[0x1001f7ac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11480000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001f7a0, (wrb) a4  <-- 0x1001f7b0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11481000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001f7b0, a3  = 0x1001f7c0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11482000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001f7b0, 0 ~~> Word[0x1001f7b0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11483000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001f7b0, 0 ~~> Word[0x1001f7b4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11484000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001f7b0, 0 ~~> Word[0x1001f7b8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11485000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001f7b0, 0 ~~> Word[0x1001f7bc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11486000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001f7b0, (wrb) a4  <-- 0x1001f7c0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11487000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001f7c0, a3  = 0x1001f7c0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
          11488000    0x80004270 bnez a2, 8                     #; a2  = 4, taken, goto 0x80004278
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
          11489000    0x80004278 sub a3, t1, a2                 #; t1  = 15, a2  = 4, (wrb) a3  <-- 11
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
          11490000    0x8000427c slli a3, a3, 2                 #; a3  = 11, (wrb) a3  <-- 44
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
          11491000    0x80004280 auipc t0, 0                    #; (wrb) t0  <-- 0x80004280
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
          11492000    0x80004284 add a3, a3, t0                 #; a3  = 44, t0  = 0x80004280, (wrb) a3  <-- 0x800042ac
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
          11493000    0x80004288 jr 12(a3)                      #; a3  = 0x800042ac, goto 0x800042b8
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          11494000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x1001f7c0, 0 ~~> Byte[0x1001f7c3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          11495000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x1001f7c0, 0 ~~> Byte[0x1001f7c2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          11496000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x1001f7c0, 0 ~~> Byte[0x1001f7c1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          11497000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x1001f7c0, 0 ~~> Byte[0x1001f7c0]
#; .Ltable (memset.S:85)
#;   ret
          11498000    0x800042c8 ret                            #; ra  = 0x80003fd0, goto 0x80003fd0
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
          11499000    0x80003fd0 lw a0, 8(sp)                   #; sp  = 0x1001df08, a0  <~~ Word[0x1001df10]
          11502000                                              #; (lsu) a0  <-- 0x1001df54
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
          11503000    0x80003fd4 add a0, a0, s10                #; a0  = 0x1001df54, s10 = 7224, (wrb) a0  <-- 0x1001fb8c
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
          11504000    0x80003fd8 li a1, 0                       #; (wrb) a1  <-- 0
          11505000    0x80003fdc mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
          11506000    0x80003fe0 auipc ra, 0                    #; (wrb) ra  <-- 0x80003fe0
          11507000    0x80003fe4 jalr 596(ra)                   #; ra  = 0x80003fe0, (wrb) ra  <-- 0x80003fe8, goto 0x80004234
#; memset (memset.S:30)
#;   li t1, 15
          11508000    0x80004234 li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
          11509000    0x80004238 mv a4, a0                      #; a0  = 0x1001fb8c, (wrb) a4  <-- 0x1001fb8c
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
          11510000    0x8000423c bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
          11511000    0x80004240 andi a5, a4, 15                #; a4  = 0x1001fb8c, (wrb) a5  <-- 12
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
          11512000    0x80004244 bnez a5, 160                   #; a5  = 12, taken, goto 0x800042e4
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
          11513000    0x800042e4 slli a3, a5, 2                 #; a5  = 12, (wrb) a3  <-- 48
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
          11514000    0x800042e8 auipc t0, 0                    #; (wrb) t0  <-- 0x800042e8
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
          11515000    0x800042ec add a3, a3, t0                 #; a3  = 48, t0  = 0x800042e8, (wrb) a3  <-- 0x80004318
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
          11516000    0x800042f0 mv t0, ra                      #; ra  = 0x80003fe8, (wrb) t0  <-- 0x80003fe8
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
          11517000    0x800042f4 jalr -96(a3)                   #; a3  = 0x80004318, (wrb) ra  <-- 0x800042f8, goto 0x800042b8
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          11518000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x1001fb8c, 0 ~~> Byte[0x1001fb8f]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          11519000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x1001fb8c, 0 ~~> Byte[0x1001fb8e]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          11520000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x1001fb8c, 0 ~~> Byte[0x1001fb8d]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          11521000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x1001fb8c, 0 ~~> Byte[0x1001fb8c]
#; .Ltable (memset.S:85)
#;   ret
          11522000    0x800042c8 ret                            #; ra  = 0x800042f8, goto 0x800042f8
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
          11523000    0x800042f8 mv ra, t0                      #; t0  = 0x80003fe8, (wrb) ra  <-- 0x80003fe8
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
          11524000    0x800042fc addi a5, a5, -16               #; a5  = 12, (wrb) a5  <-- -4
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
          11525000    0x80004300 sub a4, a4, a5                 #; a4  = 0x1001fb8c, a5  = -4, (wrb) a4  <-- 0x1001fb90
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
          11526000    0x80004304 add a2, a2, a5                 #; a2  = 64, a5  = -4, (wrb) a2  <-- 60
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
          11527000    0x80004308 bgeu t1, a2, -144              #; t1  = 15, a2  = 60, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
          11528000    0x8000430c j -196                         #; goto 0x80004248
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
          11529000    0x80004248 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
          11530000    0x8000424c andi a3, a2, -16               #; a2  = 60, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
          11531000    0x80004250 andi a2, a2, 15                #; a2  = 60, (wrb) a2  <-- 12
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
          11532000    0x80004254 add a3, a3, a4                 #; a3  = 48, a4  = 0x1001fb90, (wrb) a3  <-- 0x1001fbc0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11533000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001fb90, 0 ~~> Word[0x1001fb90]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11534000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001fb90, 0 ~~> Word[0x1001fb94]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11535000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001fb90, 0 ~~> Word[0x1001fb98]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11536000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001fb90, 0 ~~> Word[0x1001fb9c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11537000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001fb90, (wrb) a4  <-- 0x1001fba0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11538000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001fba0, a3  = 0x1001fbc0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11539000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001fba0, 0 ~~> Word[0x1001fba0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11540000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001fba0, 0 ~~> Word[0x1001fba4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11541000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001fba0, 0 ~~> Word[0x1001fba8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11542000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001fba0, 0 ~~> Word[0x1001fbac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11543000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001fba0, (wrb) a4  <-- 0x1001fbb0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11544000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001fbb0, a3  = 0x1001fbc0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11545000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001fbb0, 0 ~~> Word[0x1001fbb0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11546000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001fbb0, 0 ~~> Word[0x1001fbb4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11547000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001fbb0, 0 ~~> Word[0x1001fbb8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11548000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001fbb0, 0 ~~> Word[0x1001fbbc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11549000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001fbb0, (wrb) a4  <-- 0x1001fbc0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11550000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001fbc0, a3  = 0x1001fbc0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
          11551000    0x80004270 bnez a2, 8                     #; a2  = 12, taken, goto 0x80004278
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
          11552000    0x80004278 sub a3, t1, a2                 #; t1  = 15, a2  = 12, (wrb) a3  <-- 3
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
          11553000    0x8000427c slli a3, a3, 2                 #; a3  = 3, (wrb) a3  <-- 12
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
          11554000    0x80004280 auipc t0, 0                    #; (wrb) t0  <-- 0x80004280
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
          11555000    0x80004284 add a3, a3, t0                 #; a3  = 12, t0  = 0x80004280, (wrb) a3  <-- 0x8000428c
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
          11556000    0x80004288 jr 12(a3)                      #; a3  = 0x8000428c, goto 0x80004298
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
          11557000    0x80004298 sb a1, 11(a4)                  #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbcb]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
          11558000    0x8000429c sb a1, 10(a4)                  #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbca]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
          11559000    0x800042a0 sb a1, 9(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc9]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
          11560000    0x800042a4 sb a1, 8(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc8]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
          11561000    0x800042a8 sb a1, 7(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc7]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
          11562000    0x800042ac sb a1, 6(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc6]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
          11563000    0x800042b0 sb a1, 5(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc5]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
          11564000    0x800042b4 sb a1, 4(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc4]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          11566000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          11568000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          11569000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          11570000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc0]
#; .Ltable (memset.S:85)
#;   ret
          11571000    0x800042c8 ret                            #; ra  = 0x80003fe8, goto 0x80003fe8
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
          11572000    0x80003fe8 lw a0, 8(sp)                   #; sp  = 0x1001df08, a0  <~~ Word[0x1001df10]
          11575000                                              #; (lsu) a0  <-- 0x1001df54
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
          11576000    0x80003fec add a0, a0, s11                #; a0  = 0x1001df54, s11 = 8256, (wrb) a0  <-- 0x1001ff94
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
          11577000    0x80003ff0 li a1, 0                       #; (wrb) a1  <-- 0
          11578000    0x80003ff4 mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
          11579000    0x80003ff8 auipc ra, 0                    #; (wrb) ra  <-- 0x80003ff8
          11580000    0x80003ffc jalr 572(ra)                   #; ra  = 0x80003ff8, (wrb) ra  <-- 0x80004000, goto 0x80004234
#; memset (memset.S:30)
#;   li t1, 15
          11581000    0x80004234 li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
          11582000    0x80004238 mv a4, a0                      #; a0  = 0x1001ff94, (wrb) a4  <-- 0x1001ff94
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
          11583000    0x8000423c bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
          11584000    0x80004240 andi a5, a4, 15                #; a4  = 0x1001ff94, (wrb) a5  <-- 4
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
          11585000    0x80004244 bnez a5, 160                   #; a5  = 4, taken, goto 0x800042e4
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
          11586000    0x800042e4 slli a3, a5, 2                 #; a5  = 4, (wrb) a3  <-- 16
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
          11587000    0x800042e8 auipc t0, 0                    #; (wrb) t0  <-- 0x800042e8
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
          11588000    0x800042ec add a3, a3, t0                 #; a3  = 16, t0  = 0x800042e8, (wrb) a3  <-- 0x800042f8
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
          11589000    0x800042f0 mv t0, ra                      #; ra  = 0x80004000, (wrb) t0  <-- 0x80004000
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
          11590000    0x800042f4 jalr -96(a3)                   #; a3  = 0x800042f8, (wrb) ra  <-- 0x800042f8, goto 0x80004298
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
          11591000    0x80004298 sb a1, 11(a4)                  #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9f]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
          11592000    0x8000429c sb a1, 10(a4)                  #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9e]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
          11593000    0x800042a0 sb a1, 9(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9d]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
          11594000    0x800042a4 sb a1, 8(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9c]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
          11595000    0x800042a8 sb a1, 7(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9b]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
          11596000    0x800042ac sb a1, 6(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9a]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
          11597000    0x800042b0 sb a1, 5(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff99]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
          11598000    0x800042b4 sb a1, 4(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff98]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          11599000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff97]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          11600000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff96]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          11601000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff95]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          11602000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff94]
#; .Ltable (memset.S:85)
#;   ret
          11603000    0x800042c8 ret                            #; ra  = 0x800042f8, goto 0x800042f8
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
          11604000    0x800042f8 mv ra, t0                      #; t0  = 0x80004000, (wrb) ra  <-- 0x80004000
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
          11605000    0x800042fc addi a5, a5, -16               #; a5  = 4, (wrb) a5  <-- -12
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
          11606000    0x80004300 sub a4, a4, a5                 #; a4  = 0x1001ff94, a5  = -12, (wrb) a4  <-- 0x1001ffa0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
          11607000    0x80004304 add a2, a2, a5                 #; a2  = 64, a5  = -12, (wrb) a2  <-- 52
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
          11608000    0x80004308 bgeu t1, a2, -144              #; t1  = 15, a2  = 52, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
          11609000    0x8000430c j -196                         #; goto 0x80004248
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
          11610000    0x80004248 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
          11611000    0x8000424c andi a3, a2, -16               #; a2  = 52, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
          11612000    0x80004250 andi a2, a2, 15                #; a2  = 52, (wrb) a2  <-- 4
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
          11613000    0x80004254 add a3, a3, a4                 #; a3  = 48, a4  = 0x1001ffa0, (wrb) a3  <-- 0x1001ffd0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11614000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001ffa0, 0 ~~> Word[0x1001ffa0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11615000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001ffa0, 0 ~~> Word[0x1001ffa4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11616000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001ffa0, 0 ~~> Word[0x1001ffa8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11617000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001ffa0, 0 ~~> Word[0x1001ffac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11618000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001ffa0, (wrb) a4  <-- 0x1001ffb0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11619000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001ffb0, a3  = 0x1001ffd0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11620000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001ffb0, 0 ~~> Word[0x1001ffb0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11621000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001ffb0, 0 ~~> Word[0x1001ffb4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11622000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001ffb0, 0 ~~> Word[0x1001ffb8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11623000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001ffb0, 0 ~~> Word[0x1001ffbc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11624000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001ffb0, (wrb) a4  <-- 0x1001ffc0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11625000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001ffc0, a3  = 0x1001ffd0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11626000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001ffc0, 0 ~~> Word[0x1001ffc0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11627000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001ffc0, 0 ~~> Word[0x1001ffc4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11628000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001ffc0, 0 ~~> Word[0x1001ffc8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11629000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001ffc0, 0 ~~> Word[0x1001ffcc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11630000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001ffc0, (wrb) a4  <-- 0x1001ffd0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11631000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001ffd0, a3  = 0x1001ffd0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
          11632000    0x80004270 bnez a2, 8                     #; a2  = 4, taken, goto 0x80004278
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
          11633000    0x80004278 sub a3, t1, a2                 #; t1  = 15, a2  = 4, (wrb) a3  <-- 11
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
          11634000    0x8000427c slli a3, a3, 2                 #; a3  = 11, (wrb) a3  <-- 44
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
          11635000    0x80004280 auipc t0, 0                    #; (wrb) t0  <-- 0x80004280
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
          11636000    0x80004284 add a3, a3, t0                 #; a3  = 44, t0  = 0x80004280, (wrb) a3  <-- 0x800042ac
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
          11637000    0x80004288 jr 12(a3)                      #; a3  = 0x800042ac, goto 0x800042b8
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          11638000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x1001ffd0, 0 ~~> Byte[0x1001ffd3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          11639000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x1001ffd0, 0 ~~> Byte[0x1001ffd2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          11640000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x1001ffd0, 0 ~~> Byte[0x1001ffd1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          11641000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x1001ffd0, 0 ~~> Byte[0x1001ffd0]
#; .Ltable (memset.S:85)
#;   ret
          11642000    0x800042c8 ret                            #; ra  = 0x80004000, goto 0x80004000
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:85:5)
#;     snrt_cluster_hw_barrier (sync.h:174:5)
#;       asm volatile("csrr x0, 0x7C2" ::: "memory");
#;       ^
          11653000    0x80004000 csrr zero, 1986                #; csr@7c2 = 0
          15959000    0x80004004 auipc s0, 2                    #; (wrb) s0  <-- 0x80006004
          15960000    0x80004008 addi s0, s0, -300              #; s0  = 0x80006004, (wrb) s0  <-- 0x80005ed8
          15961000    0x8000400c auipc s7, 2                    #; (wrb) s7  <-- 0x8000600c
          15962000    0x80004010 addi s7, s7, -308              #; s7  = 0x8000600c, (wrb) s7  <-- 0x80005ed8
          15963000    0x80004014 auipc s6, 2                    #; (wrb) s6  <-- 0x80006014
          15964000    0x80004018 addi s6, s6, -316              #; s6  = 0x80006014, (wrb) s6  <-- 0x80005ed8
          15965000    0x8000401c auipc s8, 2                    #; (wrb) s8  <-- 0x8000601c
          15966000    0x80004020 addi s8, s8, -292              #; s8  = 0x8000601c, (wrb) s8  <-- 0x80005ef8
#; .LBB25_30 (start.c:235:5)
#;   snrt_init_cls (start.c:166:13)
#;     if (snrt_cluster_core_idx() == 0) {
#;         ^
          15967000    0x80004024 beqz s4, 84                    #; s4  = 0, taken, goto 0x80004078
#; .LBB25_14 (start.c:235:5)
#;   snrt_init_cls (start.c:182:14)
#;     _cls_ptr = (cls_t*)snrt_cls_base_addr();
#;              ^
          15978000    0x80004078 sub a0, s7, s0                 #; s7  = 0x80005ed8, s0  = 0x80005ed8, (wrb) a0  <-- 0
          15979000    0x8000407c add a0, a0, s8                 #; a0  = 0, s8  = 0x80005ef8, (wrb) a0  <-- 0x80005ef8
          15991000    0x80004080 sub a0, s6, a0                 #; s6  = 0x80005ed8, a0  = 0x80005ef8, (wrb) a0  <-- -32
          15992000    0x80004084 lui a2, 65568                  #; (wrb) a2  <-- 0x10020000
          15993000    0x80004088 add a1, a0, a2                 #; a0  = -32, a2  = 0x10020000, (wrb) a1  <-- 0x1001ffe0
          15994000    0x8000408c lui a3, 0                      #; (wrb) a3  <-- 0
          15995000    0x80004090 add s0, a3, tp                 #; a3  = 0, tp  = 0x1001df48, (wrb) s0  <-- 0x1001df48
          15996000    0x80004094 sw a1, 64(s0)                  #; s0  = 0x1001df48, 0x1001ffe0 ~~> Word[0x1001df88]
#; .LBB25_14 (start.c:235:5)
#;   snrt_init_cls (start.c:183:5)
#;     snrt_cluster_hw_barrier (sync.h:174:5)
#;       asm volatile("csrr x0, 0x7C2" ::: "memory");
#;       ^
          15997000    0x80004098 csrr zero, 1986                #; csr@7c2 = 0
          16027000    0x8000409c li a3, 8                       #; (wrb) a3  <-- 8
          16028000    0x800040a0 auipc a1, 5                    #; (wrb) a1  <-- 0x800090a0
          16029000    0x800040a4 addi a1, a1, -1848             #; a1  = 0x800090a0, (wrb) a1  <-- 0x80008968
#; .LBB25_31 (start.c:243:5)
#;   snrt_init_libs (start.c:189:5)
#;     snrt_alloc_init (alloc.h:113:9)
#;       if (snrt_is_dm_core()) {
#;           ^
          16030000    0x800040a8 bltu s5, a3, 84                #; s5  = 8, a3  = 8, not taken
#; .LBB25_31 (start.c:243:5)
#;   snrt_init_libs (start.c:189:5)
#;     snrt_alloc_init (alloc.h:119:9)
#;       snrt_l1_allocator (alloc.h:47:34)
#;         cls (cls.h:9:30)
#;           inline cls_t* cls() { return _cls_ptr; }
#;                                        ^
          16031000    0x800040ac lw a3, 64(s0)                  #; s0  = 0x1001df48, a3  <~~ Word[0x1001df88]
          16032000    0x800040b0 lui a4, 65536                  #; (wrb) a4  <-- 0x10000000
#; .LBB25_31 (start.c:243:5)
#;   snrt_init_libs (start.c:189:5)
#;     snrt_alloc_init (alloc.h:118:47)
#;       snrt_cluster (snitch_cluster_memory.h:23:46)
#;         return &(snitch_cluster_addrmap.cluster) + snrt_cluster_idx();
#;                                                  ^
          16033000    0x800040b4 add a4, s3, a4                 #; s3  = 0, a4  = 0x10000000, (wrb) a4  <-- 0x10000000
          16034000                                              #; (lsu) a3  <-- 0x1001ffe0
#; .LBB25_31 (start.c:243:5)
#;   snrt_init_libs (start.c:189:5)
#;     snrt_alloc_init (alloc.h:119:35)
#;       snrt_l1_allocator()->base =
#;                                 ^
          16035000    0x800040b8 sw a4, 8(a3)                   #; a3  = 0x1001ffe0, 0x10000000 ~~> Word[0x1001ffe8]
          16036000    0x800040bc sw zero, 12(a3)                #; a3  = 0x1001ffe0, 0 ~~> Word[0x1001ffec]
#; .LBB25_31 (start.c:243:5)
#;   snrt_init_libs (start.c:189:5)
#;     snrt_alloc_init (alloc.h:121:50)
#;       snrt_l1_allocator()->end = l1_start_addr + SNRT_TCDM_SIZE;
#;                                                ^
          16041000    0x800040c0 add a2, s3, a2                 #; s3  = 0, a2  = 0x10020000, (wrb) a2  <-- 0x10020000
#; .LBB25_31 (start.c:243:5)
#;   snrt_init_libs (start.c:189:5)
#;     snrt_alloc_init (alloc.h:121:34)
#;       snrt_l1_allocator()->end = l1_start_addr + SNRT_TCDM_SIZE;
#;                                ^
          16042000    0x800040c4 sw a2, 16(a3)                  #; a3  = 0x1001ffe0, 0x10020000 ~~> Word[0x1001fff0]
          16043000    0x800040c8 sw zero, 20(a3)                #; a3  = 0x1001ffe0, 0 ~~> Word[0x1001fff4]
#; .LBB25_31 (start.c:243:5)
#;   snrt_init_libs (start.c:189:5)
#;     snrt_alloc_init (alloc.h:122:35)
#;       snrt_l1_allocator()->next = snrt_l1_allocator()->base;
#;                                 ^
          16044000    0x800040cc sw a4, 24(a3)                  #; a3  = 0x1001ffe0, 0x10000000 ~~> Word[0x1001fff8]
          16045000    0x800040d0 sw zero, 28(a3)                #; a3  = 0x1001ffe0, 0 ~~> Word[0x1001fffc]
          16046000    0x800040d4 addi a2, a1, 7                 #; a1  = 0x80008968, (wrb) a2  <-- 0x8000896f
#; .LBB25_31 (start.c:243:5)
#;   snrt_init_libs (start.c:189:5)
#;     snrt_alloc_init (alloc.h:125:35)
#;       snrt_l3_allocator()->base =
#;                                 ^
          16047000    0x800040d8 andi a2, a2, -8                #; a2  = 0x8000896f, (wrb) a2  <-- 0x80008968
          16048000    0x800040dc auipc a3, 2                    #; (wrb) a3  <-- 0x800060dc
          16049000    0x800040e0 addi a3, a3, 492               #; a3  = 0x800060dc, (wrb) a3  <-- 0x800062c8
#; .LBB25_32 (start.c:243:5)
#;   snrt_init_libs (start.c:189:5)
#;     snrt_alloc_init (alloc.h:125:35)
#;       snrt_l3_allocator()->base =
#;                                 ^
          16050000    0x800040e4 sw a2, 0(a3)                   #; a3  = 0x800062c8, 0x80008968 ~~> Word[0x800062c8]
          16051000    0x800040e8 sw zero, 4(a3)                 #; a3  = 0x800062c8, 0 ~~> Word[0x800062cc]
#; .LBB25_32 (start.c:243:5)
#;   snrt_init_libs (start.c:189:5)
#;     snrt_alloc_init (alloc.h:127:34)
#;       snrt_l3_allocator()->end = snrt_l3_allocator()->base;
#;                                ^
          16052000    0x800040ec sw a2, 8(a3)                   #; a3  = 0x800062c8, 0x80008968 ~~> Word[0x800062d0]
          16053000    0x800040f0 sw zero, 12(a3)                #; a3  = 0x800062c8, 0 ~~> Word[0x800062d4]
#; .LBB25_32 (start.c:243:5)
#;   snrt_init_libs (start.c:189:5)
#;     snrt_alloc_init (alloc.h:128:35)
#;       snrt_l3_allocator()->next = snrt_l3_allocator()->base;
#;                                 ^
          16062000    0x800040f4 sw a2, 16(a3)                  #; a3  = 0x800062c8, 0x80008968 ~~> Word[0x800062d8]
          16063000    0x800040f8 sw zero, 20(a3)                #; a3  = 0x800062c8, 0 ~~> Word[0x800062dc]
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:189:5)
#;     snrt_alloc_init (alloc.h:131:5)
#;       snrt_cluster_hw_barrier (sync.h:174:5)
#;         asm volatile("csrr x0, 0x7C2" ::: "memory");
#;         ^
          16064000    0x800040fc csrr zero, 1986                #; csr@7c2 = 0
          16076000    0x80004100 lui a2, 65536                  #; (wrb) a2  <-- 0x10000000
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:190:5)
#;     snrt_l1_init (alloc_v2.h:117:43)
#;       snrt_cluster (snitch_cluster_memory.h:23:46)
#;         return &(snitch_cluster_addrmap.cluster) + snrt_cluster_idx();
#;                                                  ^
          16077000    0x80004104 add a2, s3, a2                 #; s3  = 0, a2  = 0x10000000, (wrb) a2  <-- 0x10000000
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:190:5)
#;     snrt_l1_init (alloc_v2.h:118:34)
#;       snrt_l1_allocator_v2()->base = snrt_align_up(l1_start_addr, MIN_CHUNK_SIZE);
#;                                    ^
          16078000    0x80004108 lui a3, 0                      #; (wrb) a3  <-- 0
          16079000    0x8000410c add a3, a3, tp                 #; a3  = 0, tp  = 0x1001df48, (wrb) a3  <-- 0x1001df48
          16080000    0x80004110 sw zero, 20(a3)                #; a3  = 0x1001df48, 0 ~~> Word[0x1001df5c]
          16081000    0x80004114 sw a2, 16(a3)                  #; a3  = 0x1001df48, 0x10000000 ~~> Word[0x1001df58]
          16082000    0x80004118 addi a3, a3, 16                #; a3  = 0x1001df48, (wrb) a3  <-- 0x1001df58
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:190:5)
#;     snrt_l1_init (alloc_v2.h:119:33)
#;       snrt_l1_allocator_v2()->end = heap_end_addr;
#;                                   ^
          16083000    0x8000411c sw zero, 12(a3)                #; a3  = 0x1001df58, 0 ~~> Word[0x1001df64]
          16084000    0x80004120 lui a4, 65566                  #; (wrb) a4  <-- 0x1001e000
          16085000    0x80004124 addi a4, a4, -1152             #; a4  = 0x1001e000, (wrb) a4  <-- 0x1001db80
          16086000    0x80004128 add a0, a0, a4                 #; a0  = -32, a4  = 0x1001db80, (wrb) a0  <-- 0x1001db60
          16087000    0x8000412c sw a0, 8(a3)                   #; a3  = 0x1001df58, 0x1001db60 ~~> Word[0x1001df60]
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:190:5)
#;     snrt_l1_init (alloc_v2.h:120:34)
#;       snrt_l1_allocator_v2()->next = snrt_l1_allocator_v2()->base;
#;                                    ^
          16088000    0x80004130 sw zero, 20(a3)                #; a3  = 0x1001df58, 0 ~~> Word[0x1001df6c]
          16089000    0x80004134 sw a2, 16(a3)                  #; a3  = 0x1001df58, 0x10000000 ~~> Word[0x1001df68]
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:191:5)
#;     snrt_l3_init (alloc_v2.h:184:34)
#;       snrt_l3_allocator_v2()->base =
#;                                    ^
          16090000    0x80004138 lui a0, 0                      #; (wrb) a0  <-- 0
          16091000    0x8000413c add a0, a0, tp                 #; a0  = 0, tp  = 0x1001df48, (wrb) a0  <-- 0x1001df48
          16102000    0x80004140 sw zero, 44(a0)                #; a0  = 0x1001df48, 0 ~~> Word[0x1001df74]
          16103000    0x80004144 addi a1, a1, 7                 #; a1  = 0x80008968, (wrb) a1  <-- 0x8000896f
          16104000    0x80004148 andi a1, a1, -8                #; a1  = 0x8000896f, (wrb) a1  <-- 0x80008968
          16105000    0x8000414c sw a1, 40(a0)                  #; a0  = 0x1001df48, 0x80008968 ~~> Word[0x1001df70]
          16106000    0x80004150 addi a0, a0, 40                #; a0  = 0x1001df48, (wrb) a0  <-- 0x1001df70
          16107000    0x80004154 li a2, 1                       #; (wrb) a2  <-- 1
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:191:5)
#;     snrt_l3_init (alloc_v2.h:186:33)
#;       snrt_l3_allocator_v2()->end = SNRT_L3_END_ADDR;
#;                                   ^
          16108000    0x80004158 sw a2, 12(a0)                  #; a0  = 0x1001df70, 1 ~~> Word[0x1001df7c]
          16109000    0x8000415c sw zero, 8(a0)                 #; a0  = 0x1001df70, 0 ~~> Word[0x1001df78]
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:191:5)
#;     snrt_l3_init (alloc_v2.h:187:34)
#;       snrt_l3_allocator_v2()->next = snrt_l3_allocator_v2()->base;
#;                                    ^
          16110000    0x80004160 sw zero, 20(a0)                #; a0  = 0x1001df70, 0 ~~> Word[0x1001df84]
          16111000    0x80004164 sw a1, 16(a0)                  #; a0  = 0x1001df70, 0x80008968 ~~> Word[0x1001df80]
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:192:5)
#;     snrt_comm_init (sync.h:37:48)
#;       inline void snrt_comm_init() { snrt_comm_world = &snrt_comm_world_info; }
#;                                                      ^
          16112000    0x80004168 lui a0, 0                      #; (wrb) a0  <-- 0
          16113000    0x8000416c add a0, a0, tp                 #; a0  = 0, tp  = 0x1001df48, (wrb) a0  <-- 0x1001df48
          16114000    0x80004170 lui a1, 0                      #; (wrb) a1  <-- 0
          16115000    0x80004174 add a1, a1, tp                 #; a1  = 0, tp  = 0x1001df48, (wrb) a1  <-- 0x1001df48
          16116000    0x80004178 mv a1, a1                      #; a1  = 0x1001df48, (wrb) a1  <-- 0x1001df48
          16117000    0x8000417c sw a1, 76(a0)                  #; a0  = 0x1001df48, 0x1001df48 ~~> Word[0x1001df94]
#; .LBB25_16 (start.c:251:5)
#;   snrt_cluster_hw_barrier (sync.h:174:5)
#;     asm volatile("csrr x0, 0x7C2" ::: "memory");
#;     ^
          16128000    0x80004180 csrr zero, 1986                #; csr@7c2 = 0
#; .LBB25_16 (start.c:260:17)
#;   exit_code = main();
#;               ^
          16130000    0x80004184 auipc ra, 1048572              #; (wrb) ra  <-- 0x80000184
          16131000    0x80004188 jalr 1300(ra)                  #; ra  = 0x80000184, (wrb) ra  <-- 0x8000418c, goto 0x80000698
#; main (matmul_i32.c:75)
#;   int main() {
          16142000    0x80000698 addi sp, sp, -80               #; sp  = 0x1001df08, (wrb) sp  <-- 0x1001deb8
#; main (matmul_i32.c:76:26)
#;   snrt_cluster_core_idx (team.h:108:12)
#;     snrt_global_core_idx (team.h:80:12)
#;       snrt_hartid (team.h:25:5)
#;         asm("csrr %0, mhartid" : "=r"(hartid));
#;         ^
          16143000    0x8000069c sw ra, 76(sp)                  #; sp  = 0x1001deb8, 0x8000418c ~~> Word[0x1001df04]
          16144000    0x800006a0 sw s0, 72(sp)                  #; sp  = 0x1001deb8, 0x1001df48 ~~> Word[0x1001df00]
          16145000    0x800006a4 sw s1, 68(sp)                  #; sp  = 0x1001deb8, 2064 ~~> Word[0x1001defc]
          16146000    0x800006a8 sw s2, 64(sp)                  #; sp  = 0x1001deb8, 8 ~~> Word[0x1001def8]
          16147000    0x800006ac sw s3, 60(sp)                  #; sp  = 0x1001deb8, 0 ~~> Word[0x1001def4]
          16148000    0x800006b0 sw s4, 56(sp)                  #; sp  = 0x1001deb8, 0 ~~> Word[0x1001def0]
          16149000    0x800006b4 sw s5, 52(sp)                  #; sp  = 0x1001deb8, 8 ~~> Word[0x1001deec]
          16150000    0x800006b8 sw s6, 48(sp)                  #; sp  = 0x1001deb8, 0x80005ed8 ~~> Word[0x1001dee8]
          16151000    0x800006bc sw s7, 44(sp)                  #; sp  = 0x1001deb8, 0x80005ed8 ~~> Word[0x1001dee4]
          16162000    0x800006c0 sw s8, 40(sp)                  #; sp  = 0x1001deb8, 0x80005ef8 ~~> Word[0x1001dee0]
          16163000    0x800006c4 sw s9, 36(sp)                  #; sp  = 0x1001deb8, 6192 ~~> Word[0x1001dedc]
          16164000    0x800006c8 sw s10, 32(sp)                 #; sp  = 0x1001deb8, 7224 ~~> Word[0x1001ded8]
          16165000    0x800006cc sw s11, 28(sp)                 #; sp  = 0x1001deb8, 8256 ~~> Word[0x1001ded4]
          16166000    0x800006d0 csrr a0, mhartid               #; mhartid = 8, (wrb) a0  <-- 8
          16167000    0x800006d4 lui a1, 233017                 #; (wrb) a1  <-- 0x38e39000
          16168000    0x800006d8 addi a1, a1, -455              #; a1  = 0x38e39000, (wrb) a1  <-- 0x38e38e39
#; main (matmul_i32.c:107:9)
#;   snrt_stop_perf_counter (perf_cnt.h:54:5)
#;     snrt_perf_counters (perf_cnt.h:23:14)
#;       snrt_cluster (snitch_cluster_memory.h:23:48)
#;         snrt_cluster_idx (team.h:99:35)
#;           return snrt_global_core_idx() / snrt_cluster_core_num();
#;                                         ^
          16169000    0x800006dc mulhu a1, a0, a1               #; a0  = 8, a1  = 0x38e38e39
          16171000                                              #; (acc) a1  <-- 1
          16172000    0x800006e0 srli s2, a1, 1                 #; a1  = 1, (wrb) s2  <-- 0
          16173000    0x800006e4 slli a1, s2, 3                 #; s2  = 0, (wrb) a1  <-- 0
          16174000    0x800006e8 add a1, a1, s2                 #; a1  = 0, s2  = 0, (wrb) a1  <-- 0
          16175000    0x800006ec sub a0, a0, a1                 #; a0  = 8, a1  = 0, (wrb) a0  <-- 8
#; main (matmul_i32.c:80:5)
#;   snrt_cluster_hw_barrier (sync.h:174:5)
#;     asm volatile("csrr x0, 0x7C2" ::: "memory");
#;     ^
          16176000    0x800006f0 csrr zero, 1986                #; csr@7c2 = 0
          16178000    0x800006f4 auipc s0, 6                    #; (wrb) s0  <-- 0x800066f4
          16179000    0x800006f8 addi s0, s0, -1836             #; s0  = 0x800066f4, (wrb) s0  <-- 0x80005fc8
          16180000    0x800006fc auipc s1, 6                    #; (wrb) s1  <-- 0x800066fc
          16191000    0x80000700 addi s1, s1, -1588             #; s1  = 0x800066fc, (wrb) s1  <-- 0x800060c8
          16192000    0x80000704 auipc s4, 6                    #; (wrb) s4  <-- 0x80006704
          16193000    0x80000708 addi s4, s4, -1340             #; s4  = 0x80006704, (wrb) s4  <-- 0x800061c8
#; .LBB2_46 (matmul_i32.c:81:9)
#;   if (core_id == 0) {
#;       ^
          16194000    0x8000070c sw s1, 16(sp)                  #; sp  = 0x1001deb8, 0x800060c8 ~~> Word[0x1001dec8]
          16195000    0x80000710 sw s2, 12(sp)                  #; sp  = 0x1001deb8, 0 ~~> Word[0x1001dec4]
          16196000    0x80000714 sw a0, 20(sp)                  #; sp  = 0x1001deb8, 8 ~~> Word[0x1001decc]
          16197000    0x80000718 beqz a0, 432                   #; a0  = 8, not taken
#; .LBB2_46 (matmul_i32.c:87:5)
#;   snrt_cluster_hw_barrier (sync.h:174:5)
#;     asm volatile("csrr x0, 0x7C2" ::: "memory");
#;     ^
          16198000    0x8000071c csrr zero, 1986                #; csr@7c2 = 0
#; .LBB2_46 (matmul_i32.c:93:5)
#;   snrt_cluster_hw_barrier (sync.h:174:5)
#;     asm volatile("csrr x0, 0x7C2" ::: "memory");
#;     ^
          22528000    0x80000720 csrr zero, 1986                #; csr@7c2 = 0
#; .LBB2_46 (matmul_i32.c:99:5)
#;   snrt_cluster_hw_barrier (sync.h:174:5)
#;     asm volatile("csrr x0, 0x7C2" ::: "memory");
#;     ^
          22530000    0x80000724 csrr zero, 1986                #; csr@7c2 = 0
#; .LBB2_46 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:82:42)
#;     uint32_t const c_start = (P / c) * (id % c);
#;                                            ^
          22632000    0x80000728 andi a2, a0, 7                 #; a0  = 8, (wrb) a2  <-- 0
#; .LBB2_46 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:88:23)
#;     for (uint32_t i = 2 * (id / c); i < M; i += 2 * (numThreads / c)) {
#;                         ^
          22633000    0x8000072c srli a1, a0, 2                 #; a0  = 8, (wrb) a1  <-- 2
          22634000    0x80000730 andi a5, a1, 2                 #; a1  = 2, (wrb) a5  <-- 2
          22635000    0x80000734 sw a2, 24(sp)                  #; sp  = 0x1001deb8, 0 ~~> Word[0x1001ded0]
          22636000    0x80000738 slli a1, a2, 2                 #; a2  = 0, (wrb) a1  <-- 0
          22637000    0x8000073c add a1, a1, s4                 #; a1  = 0, s4  = 0x800061c8, (wrb) a1  <-- 0x800061c8
          22648000    0x80000740 addi a2, a1, 64                #; a1  = 0x800061c8, (wrb) a2  <-- 0x80006208
          22649000    0x80000744 addi a3, a1, 128               #; a1  = 0x800061c8, (wrb) a3  <-- 0x80006248
          22650000    0x80000748 addi a4, a1, 192               #; a1  = 0x800061c8, (wrb) a4  <-- 0x80006288
          22651000    0x8000074c addi a5, a5, -2                #; a5  = 2, (wrb) a5  <-- 0
          22652000    0x80000750 srli a6, a0, 3                 #; a0  = 8, (wrb) a6  <-- 1
          22653000    0x80000754 andi a7, a6, 1                 #; a6  = 1, (wrb) a7  <-- 1
          22654000    0x80000758 slli a6, a7, 4                 #; a7  = 1, (wrb) a6  <-- 16
          22655000    0x8000075c slli a7, a7, 6                 #; a7  = 1, (wrb) a7  <-- 64
          22656000    0x80000760 add a7, a7, s1                 #; a7  = 64, s1  = 0x800060c8, (wrb) a7  <-- 0x80006108
          22657000    0x80000764 li t0, 28                      #; (wrb) t0  <-- 28
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          22658000    0x80000768 mv t2, a7                      #; a7  = 0x80006108, (wrb) t2  <-- 0x80006108
          22659000    0x8000076c mv t3, a1                      #; a1  = 0x800061c8, (wrb) t3  <-- 0x800061c8
          22660000    0x80000770 p.lw t4, 4(t2!)                #; t2  = 0x80006108, t4  <~~ Word[0x8000610c]
          22661000    0x80000774 p.lw t5, t0(t2!)               #; t2  = 0x8000610c, t0  = 28, t5  <~~ Word[0x80006128]
          22704000    0x80000778 p.lw t6, 4(t2!)                #; t2  = 0x80006128, t6  <~~ Word[0x8000612c]
          22712000                                              #; (lsu) t4  <-- 3
          22741000    0x8000077c p.lw s1, 0(t2!)                #; t2  = 0x8000612c, s1  <~~ Word[0x8000612c]
          22749000                                              #; (lsu) t5  <-- 6
          22785000    0x80000780 p.lw s4, 4(t3!)                #; t3  = 0x800061c8, s4  <~~ Word[0x800061cc]
          22793000                                              #; (lsu) t6  <-- 4
          22822000    0x80000784 p.lw s5, t0(t3!)               #; t3  = 0x800061cc, t0  = 28, s5  <~~ Word[0x800061e8]
          22830000                                              #; (lsu) s1  <-- 8
          22866000    0x80000788 p.lw s6, 4(t3!)                #; t3  = 0x800061e8, s6  <~~ Word[0x800061ec]
          22874000                                              #; (lsu) s4  <-- 1
          22903000    0x8000078c p.lw s7, 0(t3!)                #; t3  = 0x800061ec, s7  <~~ Word[0x800061ec]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:24)
#;     c00 += val_a00 * val_b00;
#;                    ^
          22904000    0x80000790 mul t2, t4, s4                 #; t4  = 3, s4  = 1
          22906000                                              #; (acc) t2  <-- 3
          22911000                                              #; (lsu) s5  <-- 0
          22955000                                              #; (lsu) s6  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          22956000    0x80000794 p.mac t2, t5, s6               #; t5  = 6, s6  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:24)
#;     c01 += val_a00 * val_b01;
#;                    ^
          22957000    0x80000798 mul t3, t4, s5                 #; t4  = 3, s5  = 0
          22958000                                              #; (acc) t2  <-- 3
          22959000                                              #; (acc) t3  <-- 0
          22992000                                              #; (lsu) s7  <-- 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          22993000    0x8000079c p.mac t3, t5, s7               #; t5  = 6, s7  = 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:24)
#;     c10 += val_a10 * val_b00;
#;                    ^
          22994000    0x800007a0 mul t4, t6, s4                 #; t6  = 4, s4  = 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          22995000    0x800007a4 addi t5, a7, 8                 #; a7  = 0x80006108, (wrb) t5  <-- 0x80006110
          22996000    0x800007a8 mv s4, a2                      #; a2  = 0x80006208, (wrb) s4  <-- 0x80006208
          22997000    0x800007ac mv a0, s0                      #; s0  = 0x80005fc8, (wrb) a0  <-- 0x80005fc8
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          22998000    0x800007b0 p.lw s8, 4(t5!)                #; t5  = 0x80006110, s8  <~~ Word[0x80006114]
          22999000    0x800007b4 p.lw s9, t0(t5!)               #; t5  = 0x80006114, t0  = 28, s9  <~~ Word[0x80006130]
          23000000                                              #; (acc) t3  <-- 6
          23001000                                              #; (acc) t4  <-- 4
          23028000    0x800007b8 p.lw s10, 4(t5!)               #; t5  = 0x80006130, s10 <~~ Word[0x80006134]
          23036000                                              #; (lsu) s8  <-- 9
          23065000    0x800007bc p.lw s11, 0(t5!)               #; t5  = 0x80006134, s11 <~~ Word[0x80006134]
          23073000                                              #; (lsu) s9  <-- 12
          23109000    0x800007c0 p.lw ra, 4(s4!)                #; s4  = 0x80006208, ra  <~~ Word[0x8000620c]
          23117000                                              #; (lsu) s10 <-- 12
          23146000    0x800007c4 p.lw s2, t0(s4!)               #; s4  = 0x8000620c, t0  = 28, s2  <~~ Word[0x80006228]
          23154000                                              #; (lsu) s11 <-- 16
          23190000    0x800007c8 p.lw s0, 4(s4!)                #; s4  = 0x80006228, s0  <~~ Word[0x8000622c]
          23198000                                              #; (lsu) ra  <-- 0
          23227000    0x800007cc p.lw s3, 0(s4!)                #; s4  = 0x8000622c, s3  <~~ Word[0x8000622c]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          23228000    0x800007d0 p.mac t4, s1, s6               #; s1  = 8, s6  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:24)
#;     c11 += val_a10 * val_b01;
#;                    ^
          23229000    0x800007d4 mul t5, t6, s5                 #; t6  = 4, s5  = 0
          23230000                                              #; (acc) t4  <-- 4
          23231000                                              #; (acc) t5  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          23232000    0x800007d8 p.mac t5, s1, s7               #; s1  = 8, s7  = 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          23233000    0x800007dc p.mac t2, s8, ra               #; s8  = 9, ra  = 0
          23234000                                              #; (acc) t5  <-- 8
          23235000                                              #; (lsu) s2  <-- 0
          23236000                                              #; (acc) t2  <-- 3
          23279000                                              #; (lsu) s0  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          23280000    0x800007e0 p.mac t2, s9, s0               #; s9  = 12, s0  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          23281000    0x800007e4 p.mac t3, s8, s2               #; s8  = 9, s2  = 0
          23282000                                              #; (acc) t2  <-- 3
          23283000                                              #; (acc) t3  <-- 6
          23316000                                              #; (lsu) s3  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          23317000    0x800007e8 p.mac t3, s9, s3               #; s9  = 12, s3  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          23318000    0x800007ec p.mac t4, s10, ra              #; s10 = 12, ra  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          23319000    0x800007f0 addi t6, a7, 16                #; a7  = 0x80006108, (wrb) t6  <-- 0x80006118
          23320000    0x800007f4 mv s1, a3                      #; a3  = 0x80006248, (wrb) s1  <-- 0x80006248
          23321000    0x800007f8 p.lw s4, 4(t6!)                #; t6  = 0x80006118, s4  <~~ Word[0x8000611c]
          23322000    0x800007fc p.lw s5, t0(t6!)               #; t6  = 0x8000611c, t0  = 28, s5  <~~ Word[0x80006138]
          23323000                                              #; (acc) t3  <-- 6
          23324000                                              #; (acc) t4  <-- 4
          23352000    0x80000800 p.lw s6, 4(t6!)                #; t6  = 0x80006138, s6  <~~ Word[0x8000613c]
          23360000                                              #; (lsu) s4  <-- 15
          23389000    0x80000804 p.lw s7, 0(t6!)                #; t6  = 0x8000613c, s7  <~~ Word[0x8000613c]
          23397000                                              #; (lsu) s5  <-- 18
          23433000    0x80000808 p.lw s8, 4(s1!)                #; s1  = 0x80006248, s8  <~~ Word[0x8000624c]
          23441000                                              #; (lsu) s6  <-- 20
          23470000    0x8000080c p.lw s9, t0(s1!)               #; s1  = 0x8000624c, t0  = 28, s9  <~~ Word[0x80006268]
          23478000                                              #; (lsu) s7  <-- 24
          23514000    0x80000810 p.lw ra, 4(s1!)                #; s1  = 0x80006268, ra  <~~ Word[0x8000626c]
          23522000                                              #; (lsu) s8  <-- 0
          23551000    0x80000814 p.lw t1, 0(s1!)                #; s1  = 0x8000626c, t1  <~~ Word[0x8000626c]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          23552000    0x80000818 p.mac t4, s11, s0              #; s11 = 16, s0  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          23553000    0x8000081c p.mac t5, s10, s2              #; s10 = 12, s2  = 0
          23554000                                              #; (acc) t4  <-- 4
          23555000                                              #; (acc) t5  <-- 8
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          23556000    0x80000820 p.mac t5, s11, s3              #; s11 = 16, s3  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          23557000    0x80000824 p.mac t2, s4, s8               #; s4  = 15, s8  = 0
          23558000                                              #; (acc) t5  <-- 8
          23559000                                              #; (lsu) s9  <-- 0
          23560000                                              #; (acc) t2  <-- 3
          23603000                                              #; (lsu) ra  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          23604000    0x80000828 p.mac t2, s5, ra               #; s5  = 18, ra  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          23605000    0x8000082c p.mac t3, s4, s9               #; s4  = 15, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          23606000    0x80000830 p.mac t4, s6, s8               #; s6  = 20, s8  = 0, (acc) t2  <-- 3
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          23607000    0x80000834 p.mac t5, s6, s9               #; s6  = 20, s9  = 0, (acc) t3  <-- 6
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          23608000    0x80000838 addi t6, a7, 24                #; a7  = 0x80006108, (wrb) t6  <-- 0x80006120
          23609000    0x8000083c mv s0, a4                      #; a4  = 0x80006288, (wrb) s0  <-- 0x80006288
          23610000                                              #; (acc) t4  <-- 4
          23611000                                              #; (acc) t5  <-- 8
          23612000    0x80000840 p.lw s1, 4(t6!)                #; t6  = 0x80006120, s1  <~~ Word[0x80006124]
          23632000    0x80000844 p.lw s2, t0(t6!)               #; t6  = 0x80006124, t0  = 28, s2  <~~ Word[0x80006140]
          23640000                                              #; (lsu) t1  <-- 0
          23676000    0x80000848 p.lw s3, 4(t6!)                #; t6  = 0x80006140, s3  <~~ Word[0x80006144]
          23684000                                              #; (lsu) s1  <-- 21
          23713000    0x8000084c p.lw s4, 0(t6!)                #; t6  = 0x80006144, s4  <~~ Word[0x80006144]
          23721000                                              #; (lsu) s2  <-- 24
          23757000    0x80000850 p.lw s6, 4(s0!)                #; s0  = 0x80006288, s6  <~~ Word[0x8000628c]
          23765000                                              #; (lsu) s3  <-- 28
          23794000    0x80000854 p.lw s8, t0(s0!)               #; s0  = 0x8000628c, t0  = 28, s8  <~~ Word[0x800062a8]
          23802000                                              #; (lsu) s4  <-- 32
          23839000    0x80000858 p.lw s9, 4(s0!)                #; s0  = 0x800062a8, s9  <~~ Word[0x800062ac]
          23847000                                              #; (lsu) s6  <-- 0
          23884000    0x8000085c p.lw s10, 0(s0!)               #; s0  = 0x800062ac, s10 <~~ Word[0x800062ac]
          23885000    0x80000860 mv s0, a0                      #; a0  = 0x80005fc8, (wrb) s0  <-- 0x80005fc8
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          23886000    0x80000864 p.mac t3, s5, t1               #; s5  = 18, t1  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          23887000    0x80000868 p.mac t4, s7, ra               #; s7  = 24, ra  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          23888000    0x8000086c p.mac t5, s7, t1               #; s7  = 24, t1  = 0, (acc) t3  <-- 6
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          23889000    0x80000870 p.mac t2, s1, s6               #; s1  = 21, s6  = 0, (acc) t4  <-- 4
          23890000                                              #; (acc) t5  <-- 8
          23891000                                              #; (acc) t2  <-- 3
          23892000                                              #; (lsu) s8  <-- 0
          23937000                                              #; (lsu) s9  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          23938000    0x80000874 p.mac t2, s2, s9               #; s2  = 24, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          23939000    0x80000878 p.mac t3, s1, s8               #; s1  = 21, s8  = 0
          23940000                                              #; (acc) t2  <-- 3
          23941000                                              #; (acc) t3  <-- 6
          23982000                                              #; (lsu) s10 <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          23983000    0x8000087c p.mac t3, s2, s10              #; s2  = 24, s10 = 0
          23985000                                              #; (acc) t3  <-- 6
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          23986000    0x80000880 p.mac t4, s3, s6               #; s3  = 28, s6  = 0
          23988000                                              #; (acc) t4  <-- 4
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          23989000    0x80000884 p.mac t4, s4, s9               #; s4  = 32, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          23990000    0x80000888 p.mac t5, s3, s8               #; s3  = 28, s8  = 0
          23991000                                              #; (acc) t4  <-- 4
          23992000                                              #; (acc) t5  <-- 8
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          23993000    0x8000088c p.mac t5, s4, s10              #; s4  = 32, s10 = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:133:33)
#;     int32_t *idx_c = &C[i * P + j];
#;                               ^
          23994000    0x80000890 lw a0, 24(sp)                  #; sp  = 0x1001deb8, a0  <~~ Word[0x1001ded0]
          23995000                                              #; (acc) t5  <-- 8
          23997000                                              #; (lsu) a0  <-- 0
          23998000    0x80000894 or t1, a0, a6                  #; a0  = 0, a6  = 16, (wrb) t1  <-- 16
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:133:25)
#;     int32_t *idx_c = &C[i * P + j];
#;                       ^
          23999000    0x80000898 slli t1, t1, 2                 #; t1  = 16, (wrb) t1  <-- 64
          24000000    0x8000089c add t1, t1, s0                 #; t1  = 64, s0  = 0x80005fc8, (wrb) t1  <-- 0x80006008
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:134:7)
#;     __asm__ volatile("p.sw %[s00], 4(%[addr_c]!) \n"
#;     ^
          24001000    0x800008a0 p.sw t2, 4(t1!)                #; t1  = 0x80006008, 3 ~~> Word[0x8000600c]
          24002000    0x800008a4 p.sw t3, t0(t1!)               #; t1  = 0x8000600c, 6 ~~> Word[0x80006028]
          24022000    0x800008a8 p.sw t4, 4(t1!)                #; t1  = 0x80006028, 4 ~~> Word[0x8000602c]
          24070000    0x800008ac p.sw t5, 0(t1!)                #; t1  = 0x8000602c, 8 ~~> Word[0x8000602c]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:88:37)
#;     for (uint32_t i = 2 * (id / c); i < M; i += 2 * (numThreads / c)) {
#;                                       ^
          24071000    0x800008b0 addi a5, a5, 2                 #; a5  = 0, (wrb) a5  <-- 2
          24072000    0x800008b4 addi a6, a6, 16                #; a6  = 16, (wrb) a6  <-- 32
          24073000    0x800008b8 addi a7, a7, 64                #; a7  = 0x80006108, (wrb) a7  <-- 0x80006148
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:88:3)
#;     for (uint32_t i = 2 * (id / c); i < M; i += 2 * (numThreads / c)) {
#;     ^
          24074000    0x800008bc li a0, 6                       #; (wrb) a0  <-- 6
          24077000    0x800008c0 bltu a5, a0, -344              #; a5  = 2, a0  = 6, taken, goto 0x80000768
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          24078000    0x80000768 mv t2, a7                      #; a7  = 0x80006148, (wrb) t2  <-- 0x80006148
          24079000    0x8000076c mv t3, a1                      #; a1  = 0x800061c8, (wrb) t3  <-- 0x800061c8
          24118000    0x80000770 p.lw t4, 4(t2!)                #; t2  = 0x80006148, t4  <~~ Word[0x8000614c]
          24166000    0x80000774 p.lw t5, t0(t2!)               #; t2  = 0x8000614c, t0  = 28, t5  <~~ Word[0x80006168]
          24211000    0x80000778 p.lw t6, 4(t2!)                #; t2  = 0x80006168, t6  <~~ Word[0x8000616c]
          24219000                                              #; (lsu) t4  <-- 5
          24248000    0x8000077c p.lw s1, 0(t2!)                #; t2  = 0x8000616c, s1  <~~ Word[0x8000616c]
          24256000                                              #; (lsu) t5  <-- 10
          24292000    0x80000780 p.lw s4, 4(t3!)                #; t3  = 0x800061c8, s4  <~~ Word[0x800061cc]
          24300000                                              #; (lsu) t6  <-- 6
          24329000    0x80000784 p.lw s5, t0(t3!)               #; t3  = 0x800061cc, t0  = 28, s5  <~~ Word[0x800061e8]
          24337000                                              #; (lsu) s1  <-- 12
          24373000    0x80000788 p.lw s6, 4(t3!)                #; t3  = 0x800061e8, s6  <~~ Word[0x800061ec]
          24381000                                              #; (lsu) s4  <-- 1
          24410000    0x8000078c p.lw s7, 0(t3!)                #; t3  = 0x800061ec, s7  <~~ Word[0x800061ec]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:24)
#;     c00 += val_a00 * val_b00;
#;                    ^
          24411000    0x80000790 mul t2, t4, s4                 #; t4  = 5, s4  = 1
          24413000                                              #; (acc) t2  <-- 5
          24418000                                              #; (lsu) s5  <-- 0
          24462000                                              #; (lsu) s6  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          24463000    0x80000794 p.mac t2, t5, s6               #; t5  = 10, s6  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:24)
#;     c01 += val_a00 * val_b01;
#;                    ^
          24464000    0x80000798 mul t3, t4, s5                 #; t4  = 5, s5  = 0
          24465000                                              #; (acc) t2  <-- 5
          24466000                                              #; (acc) t3  <-- 0
          24499000                                              #; (lsu) s7  <-- 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          24500000    0x8000079c p.mac t3, t5, s7               #; t5  = 10, s7  = 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:24)
#;     c10 += val_a10 * val_b00;
#;                    ^
          24501000    0x800007a0 mul t4, t6, s4                 #; t6  = 6, s4  = 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          24502000    0x800007a4 addi t5, a7, 8                 #; a7  = 0x80006148, (wrb) t5  <-- 0x80006150
          24503000    0x800007a8 mv s4, a2                      #; a2  = 0x80006208, (wrb) s4  <-- 0x80006208
          24504000    0x800007ac mv a0, s0                      #; s0  = 0x80005fc8, (wrb) a0  <-- 0x80005fc8
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          24505000    0x800007b0 p.lw s8, 4(t5!)                #; t5  = 0x80006150, s8  <~~ Word[0x80006154]
          24506000    0x800007b4 p.lw s9, t0(t5!)               #; t5  = 0x80006154, t0  = 28, s9  <~~ Word[0x80006170]
          24507000                                              #; (acc) t3  <-- 10
          24508000                                              #; (acc) t4  <-- 6
          24535000    0x800007b8 p.lw s10, 4(t5!)               #; t5  = 0x80006170, s10 <~~ Word[0x80006174]
          24543000                                              #; (lsu) s8  <-- 15
          24572000    0x800007bc p.lw s11, 0(t5!)               #; t5  = 0x80006174, s11 <~~ Word[0x80006174]
          24580000                                              #; (lsu) s9  <-- 20
          24616000    0x800007c0 p.lw ra, 4(s4!)                #; s4  = 0x80006208, ra  <~~ Word[0x8000620c]
          24624000                                              #; (lsu) s10 <-- 18
          24653000    0x800007c4 p.lw s2, t0(s4!)               #; s4  = 0x8000620c, t0  = 28, s2  <~~ Word[0x80006228]
          24661000                                              #; (lsu) s11 <-- 24
          24697000    0x800007c8 p.lw s0, 4(s4!)                #; s4  = 0x80006228, s0  <~~ Word[0x8000622c]
          24705000                                              #; (lsu) ra  <-- 0
          24734000    0x800007cc p.lw s3, 0(s4!)                #; s4  = 0x8000622c, s3  <~~ Word[0x8000622c]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          24735000    0x800007d0 p.mac t4, s1, s6               #; s1  = 12, s6  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:24)
#;     c11 += val_a10 * val_b01;
#;                    ^
          24736000    0x800007d4 mul t5, t6, s5                 #; t6  = 6, s5  = 0
          24737000                                              #; (acc) t4  <-- 6
          24738000                                              #; (acc) t5  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          24739000    0x800007d8 p.mac t5, s1, s7               #; s1  = 12, s7  = 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          24740000    0x800007dc p.mac t2, s8, ra               #; s8  = 15, ra  = 0
          24741000                                              #; (acc) t5  <-- 12
          24742000                                              #; (lsu) s2  <-- 0
          24743000                                              #; (acc) t2  <-- 5
          24786000                                              #; (lsu) s0  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          24787000    0x800007e0 p.mac t2, s9, s0               #; s9  = 20, s0  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          24788000    0x800007e4 p.mac t3, s8, s2               #; s8  = 15, s2  = 0
          24789000                                              #; (acc) t2  <-- 5
          24790000                                              #; (acc) t3  <-- 10
          24823000                                              #; (lsu) s3  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          24824000    0x800007e8 p.mac t3, s9, s3               #; s9  = 20, s3  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          24825000    0x800007ec p.mac t4, s10, ra              #; s10 = 18, ra  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          24826000    0x800007f0 addi t6, a7, 16                #; a7  = 0x80006148, (wrb) t6  <-- 0x80006158
          24827000    0x800007f4 mv s1, a3                      #; a3  = 0x80006248, (wrb) s1  <-- 0x80006248
          24828000    0x800007f8 p.lw s4, 4(t6!)                #; t6  = 0x80006158, s4  <~~ Word[0x8000615c]
          24829000    0x800007fc p.lw s5, t0(t6!)               #; t6  = 0x8000615c, t0  = 28, s5  <~~ Word[0x80006178]
          24830000                                              #; (acc) t3  <-- 10
          24831000                                              #; (acc) t4  <-- 6
          24859000    0x80000800 p.lw s6, 4(t6!)                #; t6  = 0x80006178, s6  <~~ Word[0x8000617c]
          24867000                                              #; (lsu) s4  <-- 25
          24896000    0x80000804 p.lw s7, 0(t6!)                #; t6  = 0x8000617c, s7  <~~ Word[0x8000617c]
          24904000                                              #; (lsu) s5  <-- 30
          24940000    0x80000808 p.lw s8, 4(s1!)                #; s1  = 0x80006248, s8  <~~ Word[0x8000624c]
          24948000                                              #; (lsu) s6  <-- 30
          24977000    0x8000080c p.lw s9, t0(s1!)               #; s1  = 0x8000624c, t0  = 28, s9  <~~ Word[0x80006268]
          24985000                                              #; (lsu) s7  <-- 36
          25021000    0x80000810 p.lw ra, 4(s1!)                #; s1  = 0x80006268, ra  <~~ Word[0x8000626c]
          25029000                                              #; (lsu) s8  <-- 0
          25058000    0x80000814 p.lw t1, 0(s1!)                #; s1  = 0x8000626c, t1  <~~ Word[0x8000626c]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          25059000    0x80000818 p.mac t4, s11, s0              #; s11 = 24, s0  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          25060000    0x8000081c p.mac t5, s10, s2              #; s10 = 18, s2  = 0
          25061000                                              #; (acc) t4  <-- 6
          25062000                                              #; (acc) t5  <-- 12
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          25063000    0x80000820 p.mac t5, s11, s3              #; s11 = 24, s3  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          25064000    0x80000824 p.mac t2, s4, s8               #; s4  = 25, s8  = 0
          25065000                                              #; (acc) t5  <-- 12
          25066000                                              #; (lsu) s9  <-- 0
          25067000                                              #; (acc) t2  <-- 5
          25110000                                              #; (lsu) ra  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          25111000    0x80000828 p.mac t2, s5, ra               #; s5  = 30, ra  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          25112000    0x8000082c p.mac t3, s4, s9               #; s4  = 25, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          25113000    0x80000830 p.mac t4, s6, s8               #; s6  = 30, s8  = 0, (acc) t2  <-- 5
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          25114000    0x80000834 p.mac t5, s6, s9               #; s6  = 30, s9  = 0, (acc) t3  <-- 10
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          25115000    0x80000838 addi t6, a7, 24                #; a7  = 0x80006148, (wrb) t6  <-- 0x80006160
          25116000    0x8000083c mv s0, a4                      #; a4  = 0x80006288, (wrb) s0  <-- 0x80006288
          25117000    0x80000840 p.lw s1, 4(t6!)                #; t6  = 0x80006160, s1  <~~ Word[0x80006164]
          25118000                                              #; (acc) t4  <-- 6
          25119000                                              #; (acc) t5  <-- 12
          25139000    0x80000844 p.lw s2, t0(t6!)               #; t6  = 0x80006164, t0  = 28, s2  <~~ Word[0x80006180]
          25147000                                              #; (lsu) t1  <-- 0
          25183000    0x80000848 p.lw s3, 4(t6!)                #; t6  = 0x80006180, s3  <~~ Word[0x80006184]
          25191000                                              #; (lsu) s1  <-- 35
          25220000    0x8000084c p.lw s4, 0(t6!)                #; t6  = 0x80006184, s4  <~~ Word[0x80006184]
          25228000                                              #; (lsu) s2  <-- 40
          25264000    0x80000850 p.lw s6, 4(s0!)                #; s0  = 0x80006288, s6  <~~ Word[0x8000628c]
          25272000                                              #; (lsu) s3  <-- 42
          25309000    0x80000854 p.lw s8, t0(s0!)               #; s0  = 0x8000628c, t0  = 28, s8  <~~ Word[0x800062a8]
          25317000                                              #; (lsu) s4  <-- 48
          25354000    0x80000858 p.lw s9, 4(s0!)                #; s0  = 0x800062a8, s9  <~~ Word[0x800062ac]
          25362000                                              #; (lsu) s6  <-- 0
          25399000    0x8000085c p.lw s10, 0(s0!)               #; s0  = 0x800062ac, s10 <~~ Word[0x800062ac]
          25400000    0x80000860 mv s0, a0                      #; a0  = 0x80005fc8, (wrb) s0  <-- 0x80005fc8
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          25401000    0x80000864 p.mac t3, s5, t1               #; s5  = 30, t1  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          25402000    0x80000868 p.mac t4, s7, ra               #; s7  = 36, ra  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          25403000    0x8000086c p.mac t5, s7, t1               #; s7  = 36, t1  = 0, (acc) t3  <-- 10
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          25404000    0x80000870 p.mac t2, s1, s6               #; s1  = 35, s6  = 0, (acc) t4  <-- 6
          25405000                                              #; (acc) t5  <-- 12
          25406000                                              #; (acc) t2  <-- 5
          25407000                                              #; (lsu) s8  <-- 0
          25452000                                              #; (lsu) s9  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          25453000    0x80000874 p.mac t2, s2, s9               #; s2  = 40, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          25454000    0x80000878 p.mac t3, s1, s8               #; s1  = 35, s8  = 0
          25455000                                              #; (acc) t2  <-- 5
          25456000                                              #; (acc) t3  <-- 10
          25496000                                              #; (lsu) s10 <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          25497000    0x8000087c p.mac t3, s2, s10              #; s2  = 40, s10 = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          25498000    0x80000880 p.mac t4, s3, s6               #; s3  = 42, s6  = 0
          25499000                                              #; (acc) t3  <-- 10
          25500000                                              #; (acc) t4  <-- 6
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          25501000    0x80000884 p.mac t4, s4, s9               #; s4  = 48, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          25502000    0x80000888 p.mac t5, s3, s8               #; s3  = 42, s8  = 0
          25503000                                              #; (acc) t4  <-- 6
          25504000                                              #; (acc) t5  <-- 12
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          25505000    0x8000088c p.mac t5, s4, s10              #; s4  = 48, s10 = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:133:33)
#;     int32_t *idx_c = &C[i * P + j];
#;                               ^
          25506000    0x80000890 lw a0, 24(sp)                  #; sp  = 0x1001deb8, a0  <~~ Word[0x1001ded0]
          25507000                                              #; (acc) t5  <-- 12
          25509000                                              #; (lsu) a0  <-- 0
          25510000    0x80000894 or t1, a0, a6                  #; a0  = 0, a6  = 32, (wrb) t1  <-- 32
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:133:25)
#;     int32_t *idx_c = &C[i * P + j];
#;                       ^
          25511000    0x80000898 slli t1, t1, 2                 #; t1  = 32, (wrb) t1  <-- 128
          25512000    0x8000089c add t1, t1, s0                 #; t1  = 128, s0  = 0x80005fc8, (wrb) t1  <-- 0x80006048
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:134:7)
#;     __asm__ volatile("p.sw %[s00], 4(%[addr_c]!) \n"
#;     ^
          25513000    0x800008a0 p.sw t2, 4(t1!)                #; t1  = 0x80006048, 5 ~~> Word[0x8000604c]
          25514000    0x800008a4 p.sw t3, t0(t1!)               #; t1  = 0x8000604c, 10 ~~> Word[0x80006068]
          25528000    0x800008a8 p.sw t4, 4(t1!)                #; t1  = 0x80006068, 6 ~~> Word[0x8000606c]
          25576000    0x800008ac p.sw t5, 0(t1!)                #; t1  = 0x8000606c, 12 ~~> Word[0x8000606c]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:88:37)
#;     for (uint32_t i = 2 * (id / c); i < M; i += 2 * (numThreads / c)) {
#;                                       ^
          25577000    0x800008b0 addi a5, a5, 2                 #; a5  = 2, (wrb) a5  <-- 4
          25578000    0x800008b4 addi a6, a6, 16                #; a6  = 32, (wrb) a6  <-- 48
          25579000    0x800008b8 addi a7, a7, 64                #; a7  = 0x80006148, (wrb) a7  <-- 0x80006188
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:88:3)
#;     for (uint32_t i = 2 * (id / c); i < M; i += 2 * (numThreads / c)) {
#;     ^
          25580000    0x800008bc li a0, 6                       #; (wrb) a0  <-- 6
          25581000    0x800008c0 bltu a5, a0, -344              #; a5  = 4, a0  = 6, taken, goto 0x80000768
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          25582000    0x80000768 mv t2, a7                      #; a7  = 0x80006188, (wrb) t2  <-- 0x80006188
          25583000    0x8000076c mv t3, a1                      #; a1  = 0x800061c8, (wrb) t3  <-- 0x800061c8
          25624000    0x80000770 p.lw t4, 4(t2!)                #; t2  = 0x80006188, t4  <~~ Word[0x8000618c]
          25672000    0x80000774 p.lw t5, t0(t2!)               #; t2  = 0x8000618c, t0  = 28, t5  <~~ Word[0x800061a8]
          25717000    0x80000778 p.lw t6, 4(t2!)                #; t2  = 0x800061a8, t6  <~~ Word[0x800061ac]
          25725000                                              #; (lsu) t4  <-- 7
          25754000    0x8000077c p.lw s1, 0(t2!)                #; t2  = 0x800061ac, s1  <~~ Word[0x800061ac]
          25762000                                              #; (lsu) t5  <-- 14
          25798000    0x80000780 p.lw s4, 4(t3!)                #; t3  = 0x800061c8, s4  <~~ Word[0x800061cc]
          25806000                                              #; (lsu) t6  <-- 8
          25835000    0x80000784 p.lw s5, t0(t3!)               #; t3  = 0x800061cc, t0  = 28, s5  <~~ Word[0x800061e8]
          25843000                                              #; (lsu) s1  <-- 16
          25879000    0x80000788 p.lw s6, 4(t3!)                #; t3  = 0x800061e8, s6  <~~ Word[0x800061ec]
          25887000                                              #; (lsu) s4  <-- 1
          25916000    0x8000078c p.lw s7, 0(t3!)                #; t3  = 0x800061ec, s7  <~~ Word[0x800061ec]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:24)
#;     c00 += val_a00 * val_b00;
#;                    ^
          25917000    0x80000790 mul t2, t4, s4                 #; t4  = 7, s4  = 1
          25919000                                              #; (acc) t2  <-- 7
          25924000                                              #; (lsu) s5  <-- 0
          25968000                                              #; (lsu) s6  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          25969000    0x80000794 p.mac t2, t5, s6               #; t5  = 14, s6  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:24)
#;     c01 += val_a00 * val_b01;
#;                    ^
          25970000    0x80000798 mul t3, t4, s5                 #; t4  = 7, s5  = 0
          25971000                                              #; (acc) t2  <-- 7
          25972000                                              #; (acc) t3  <-- 0
          26005000                                              #; (lsu) s7  <-- 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          26006000    0x8000079c p.mac t3, t5, s7               #; t5  = 14, s7  = 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:24)
#;     c10 += val_a10 * val_b00;
#;                    ^
          26007000    0x800007a0 mul t4, t6, s4                 #; t6  = 8, s4  = 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          26008000    0x800007a4 addi t5, a7, 8                 #; a7  = 0x80006188, (wrb) t5  <-- 0x80006190
          26009000    0x800007a8 mv s4, a2                      #; a2  = 0x80006208, (wrb) s4  <-- 0x80006208
          26010000    0x800007ac mv a0, s0                      #; s0  = 0x80005fc8, (wrb) a0  <-- 0x80005fc8
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          26011000    0x800007b0 p.lw s8, 4(t5!)                #; t5  = 0x80006190, s8  <~~ Word[0x80006194]
          26012000    0x800007b4 p.lw s9, t0(t5!)               #; t5  = 0x80006194, t0  = 28, s9  <~~ Word[0x800061b0]
          26013000                                              #; (acc) t3  <-- 14
          26014000                                              #; (acc) t4  <-- 8
          26041000    0x800007b8 p.lw s10, 4(t5!)               #; t5  = 0x800061b0, s10 <~~ Word[0x800061b4]
          26049000                                              #; (lsu) s8  <-- 21
          26078000    0x800007bc p.lw s11, 0(t5!)               #; t5  = 0x800061b4, s11 <~~ Word[0x800061b4]
          26086000                                              #; (lsu) s9  <-- 28
          26122000    0x800007c0 p.lw ra, 4(s4!)                #; s4  = 0x80006208, ra  <~~ Word[0x8000620c]
          26130000                                              #; (lsu) s10 <-- 24
          26159000    0x800007c4 p.lw s2, t0(s4!)               #; s4  = 0x8000620c, t0  = 28, s2  <~~ Word[0x80006228]
          26167000                                              #; (lsu) s11 <-- 32
          26203000    0x800007c8 p.lw s0, 4(s4!)                #; s4  = 0x80006228, s0  <~~ Word[0x8000622c]
          26211000                                              #; (lsu) ra  <-- 0
          26240000    0x800007cc p.lw s3, 0(s4!)                #; s4  = 0x8000622c, s3  <~~ Word[0x8000622c]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          26241000    0x800007d0 p.mac t4, s1, s6               #; s1  = 16, s6  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:24)
#;     c11 += val_a10 * val_b01;
#;                    ^
          26242000    0x800007d4 mul t5, t6, s5                 #; t6  = 8, s5  = 0
          26243000                                              #; (acc) t4  <-- 8
          26244000                                              #; (acc) t5  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          26245000    0x800007d8 p.mac t5, s1, s7               #; s1  = 16, s7  = 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          26246000    0x800007dc p.mac t2, s8, ra               #; s8  = 21, ra  = 0
          26247000                                              #; (acc) t5  <-- 16
          26248000                                              #; (lsu) s2  <-- 0
          26249000                                              #; (acc) t2  <-- 7
          26292000                                              #; (lsu) s0  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          26293000    0x800007e0 p.mac t2, s9, s0               #; s9  = 28, s0  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          26294000    0x800007e4 p.mac t3, s8, s2               #; s8  = 21, s2  = 0
          26295000                                              #; (acc) t2  <-- 7
          26296000                                              #; (acc) t3  <-- 14
          26329000                                              #; (lsu) s3  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          26330000    0x800007e8 p.mac t3, s9, s3               #; s9  = 28, s3  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          26331000    0x800007ec p.mac t4, s10, ra              #; s10 = 24, ra  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          26332000    0x800007f0 addi t6, a7, 16                #; a7  = 0x80006188, (wrb) t6  <-- 0x80006198
          26333000    0x800007f4 mv s1, a3                      #; a3  = 0x80006248, (wrb) s1  <-- 0x80006248
          26334000    0x800007f8 p.lw s4, 4(t6!)                #; t6  = 0x80006198, s4  <~~ Word[0x8000619c]
          26335000    0x800007fc p.lw s5, t0(t6!)               #; t6  = 0x8000619c, t0  = 28, s5  <~~ Word[0x800061b8]
          26336000                                              #; (acc) t3  <-- 14
          26337000                                              #; (acc) t4  <-- 8
          26365000    0x80000800 p.lw s6, 4(t6!)                #; t6  = 0x800061b8, s6  <~~ Word[0x800061bc]
          26373000                                              #; (lsu) s4  <-- 35
          26402000    0x80000804 p.lw s7, 0(t6!)                #; t6  = 0x800061bc, s7  <~~ Word[0x800061bc]
          26410000                                              #; (lsu) s5  <-- 42
          26446000    0x80000808 p.lw s8, 4(s1!)                #; s1  = 0x80006248, s8  <~~ Word[0x8000624c]
          26454000                                              #; (lsu) s6  <-- 40
          26483000    0x8000080c p.lw s9, t0(s1!)               #; s1  = 0x8000624c, t0  = 28, s9  <~~ Word[0x80006268]
          26491000                                              #; (lsu) s7  <-- 48
          26527000    0x80000810 p.lw ra, 4(s1!)                #; s1  = 0x80006268, ra  <~~ Word[0x8000626c]
          26535000                                              #; (lsu) s8  <-- 0
          26564000    0x80000814 p.lw t1, 0(s1!)                #; s1  = 0x8000626c, t1  <~~ Word[0x8000626c]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          26565000    0x80000818 p.mac t4, s11, s0              #; s11 = 32, s0  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          26566000    0x8000081c p.mac t5, s10, s2              #; s10 = 24, s2  = 0
          26567000                                              #; (acc) t4  <-- 8
          26568000                                              #; (acc) t5  <-- 16
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          26569000    0x80000820 p.mac t5, s11, s3              #; s11 = 32, s3  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          26570000    0x80000824 p.mac t2, s4, s8               #; s4  = 35, s8  = 0
          26571000                                              #; (acc) t5  <-- 16
          26572000                                              #; (lsu) s9  <-- 0
          26573000                                              #; (acc) t2  <-- 7
          26616000                                              #; (lsu) ra  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          26617000    0x80000828 p.mac t2, s5, ra               #; s5  = 42, ra  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          26618000    0x8000082c p.mac t3, s4, s9               #; s4  = 35, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          26619000    0x80000830 p.mac t4, s6, s8               #; s6  = 40, s8  = 0, (acc) t2  <-- 7
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          26620000    0x80000834 p.mac t5, s6, s9               #; s6  = 40, s9  = 0, (acc) t3  <-- 14
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          26621000    0x80000838 addi t6, a7, 24                #; a7  = 0x80006188, (wrb) t6  <-- 0x800061a0
          26622000    0x8000083c mv s0, a4                      #; a4  = 0x80006288, (wrb) s0  <-- 0x80006288
          26623000    0x80000840 p.lw s1, 4(t6!)                #; t6  = 0x800061a0, s1  <~~ Word[0x800061a4]
          26624000                                              #; (acc) t4  <-- 8
          26625000                                              #; (acc) t5  <-- 16
          26645000    0x80000844 p.lw s2, t0(t6!)               #; t6  = 0x800061a4, t0  = 28, s2  <~~ Word[0x800061c0]
          26653000                                              #; (lsu) t1  <-- 0
          26689000    0x80000848 p.lw s3, 4(t6!)                #; t6  = 0x800061c0, s3  <~~ Word[0x800061c4]
          26697000                                              #; (lsu) s1  <-- 49
          26726000    0x8000084c p.lw s4, 0(t6!)                #; t6  = 0x800061c4, s4  <~~ Word[0x800061c4]
          26734000                                              #; (lsu) s2  <-- 56
          26770000    0x80000850 p.lw s6, 4(s0!)                #; s0  = 0x80006288, s6  <~~ Word[0x8000628c]
          26778000                                              #; (lsu) s3  <-- 56
          26815000    0x80000854 p.lw s8, t0(s0!)               #; s0  = 0x8000628c, t0  = 28, s8  <~~ Word[0x800062a8]
          26823000                                              #; (lsu) s4  <-- 64
          26860000    0x80000858 p.lw s9, 4(s0!)                #; s0  = 0x800062a8, s9  <~~ Word[0x800062ac]
          26868000                                              #; (lsu) s6  <-- 0
          26905000    0x8000085c p.lw s10, 0(s0!)               #; s0  = 0x800062ac, s10 <~~ Word[0x800062ac]
          26906000    0x80000860 mv s0, a0                      #; a0  = 0x80005fc8, (wrb) s0  <-- 0x80005fc8
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          26907000    0x80000864 p.mac t3, s5, t1               #; s5  = 42, t1  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          26908000    0x80000868 p.mac t4, s7, ra               #; s7  = 48, ra  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          26909000    0x8000086c p.mac t5, s7, t1               #; s7  = 48, t1  = 0, (acc) t3  <-- 14
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          26910000    0x80000870 p.mac t2, s1, s6               #; s1  = 49, s6  = 0, (acc) t4  <-- 8
          26911000                                              #; (acc) t5  <-- 16
          26912000                                              #; (acc) t2  <-- 7
          26913000                                              #; (lsu) s8  <-- 0
          26958000                                              #; (lsu) s9  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          26959000    0x80000874 p.mac t2, s2, s9               #; s2  = 56, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          26960000    0x80000878 p.mac t3, s1, s8               #; s1  = 49, s8  = 0
          26961000                                              #; (acc) t2  <-- 7
          26962000                                              #; (acc) t3  <-- 14
          27002000                                              #; (lsu) s10 <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          27003000    0x8000087c p.mac t3, s2, s10              #; s2  = 56, s10 = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          27004000    0x80000880 p.mac t4, s3, s6               #; s3  = 56, s6  = 0
          27005000                                              #; (acc) t3  <-- 14
          27006000                                              #; (acc) t4  <-- 8
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          27007000    0x80000884 p.mac t4, s4, s9               #; s4  = 64, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          27008000    0x80000888 p.mac t5, s3, s8               #; s3  = 56, s8  = 0
          27009000                                              #; (acc) t4  <-- 8
          27010000                                              #; (acc) t5  <-- 16
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          27011000    0x8000088c p.mac t5, s4, s10              #; s4  = 64, s10 = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:133:33)
#;     int32_t *idx_c = &C[i * P + j];
#;                               ^
          27012000    0x80000890 lw a0, 24(sp)                  #; sp  = 0x1001deb8, a0  <~~ Word[0x1001ded0]
          27013000                                              #; (acc) t5  <-- 16
          27015000                                              #; (lsu) a0  <-- 0
          27016000    0x80000894 or t1, a0, a6                  #; a0  = 0, a6  = 48, (wrb) t1  <-- 48
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:133:25)
#;     int32_t *idx_c = &C[i * P + j];
#;                       ^
          27017000    0x80000898 slli t1, t1, 2                 #; t1  = 48, (wrb) t1  <-- 192
          27018000    0x8000089c add t1, t1, s0                 #; t1  = 192, s0  = 0x80005fc8, (wrb) t1  <-- 0x80006088
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:134:7)
#;     __asm__ volatile("p.sw %[s00], 4(%[addr_c]!) \n"
#;     ^
          27019000    0x800008a0 p.sw t2, 4(t1!)                #; t1  = 0x80006088, 7 ~~> Word[0x8000608c]
          27020000    0x800008a4 p.sw t3, t0(t1!)               #; t1  = 0x8000608c, 14 ~~> Word[0x800060a8]
          27034000    0x800008a8 p.sw t4, 4(t1!)                #; t1  = 0x800060a8, 8 ~~> Word[0x800060ac]
          27082000    0x800008ac p.sw t5, 0(t1!)                #; t1  = 0x800060ac, 16 ~~> Word[0x800060ac]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:88:37)
#;     for (uint32_t i = 2 * (id / c); i < M; i += 2 * (numThreads / c)) {
#;                                       ^
          27083000    0x800008b0 addi a5, a5, 2                 #; a5  = 4, (wrb) a5  <-- 6
          27084000    0x800008b4 addi a6, a6, 16                #; a6  = 48, (wrb) a6  <-- 64
          27085000    0x800008b8 addi a7, a7, 64                #; a7  = 0x80006188, (wrb) a7  <-- 0x800061c8
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:88:3)
#;     for (uint32_t i = 2 * (id / c); i < M; i += 2 * (numThreads / c)) {
#;     ^
          27086000    0x800008bc li a0, 6                       #; (wrb) a0  <-- 6
          27087000    0x800008c0 bltu a5, a0, -344              #; a5  = 6, a0  = 6, not taken
          27088000    0x800008c4 j 1152                         #; goto 0x80000d44
#; .LBB2_5 (matmul_i32.c:105:5)
#;   snrt_cluster_hw_barrier (sync.h:174:5)
#;     asm volatile("csrr x0, 0x7C2" ::: "memory");
#;     ^
          27091000    0x80000d44 csrr zero, 1986                #; csr@7c2 = 0
#; .LBB2_5 (matmul_i32.c:106:9)
#;   if (core_id == 0) {
#;       ^
          28435000    0x80000d48 lw a0, 20(sp)                  #; sp  = 0x1001deb8, a0  <~~ Word[0x1001decc]
          28438000                                              #; (lsu) a0  <-- 8
          28439000    0x80000d4c bnez a0, 584                   #; a0  = 8, taken, goto 0x80000f94
#; .LBB2_43 (matmul_i32.c:150:5)
#;   snrt_cluster_hw_barrier (sync.h:174:5)
#;     asm volatile("csrr x0, 0x7C2" ::: "memory");
#;     ^
          28450000    0x80000f94 csrr zero, 1986                #; csr@7c2 = 0
#; .LBB2_43 (matmul_i32.c:151:5)
#;   return 0;
#;   ^
          45700000    0x80000f98 li a0, 0                       #; (wrb) a0  <-- 0
          45701000    0x80000f9c lw ra, 76(sp)                  #; sp  = 0x1001deb8, ra  <~~ Word[0x1001df04]
          45702000    0x80000fa0 lw s0, 72(sp)                  #; sp  = 0x1001deb8, s0  <~~ Word[0x1001df00]
          45703000    0x80000fa4 lw s1, 68(sp)                  #; sp  = 0x1001deb8, s1  <~~ Word[0x1001defc]
          45704000    0x80000fa8 lw s2, 64(sp)                  #; sp  = 0x1001deb8, s2  <~~ Word[0x1001def8], (lsu) ra  <-- 0x8000418c
          45705000    0x80000fac lw s3, 60(sp)                  #; sp  = 0x1001deb8, s3  <~~ Word[0x1001def4], (lsu) s0  <-- 0x1001df48
          45706000    0x80000fb0 lw s4, 56(sp)                  #; sp  = 0x1001deb8, s4  <~~ Word[0x1001def0], (lsu) s1  <-- 2064
          45707000    0x80000fb4 lw s5, 52(sp)                  #; sp  = 0x1001deb8, s5  <~~ Word[0x1001deec], (lsu) s2  <-- 8
          45708000    0x80000fb8 lw s6, 48(sp)                  #; sp  = 0x1001deb8, s6  <~~ Word[0x1001dee8], (lsu) s3  <-- 0
          45709000    0x80000fbc lw s7, 44(sp)                  #; sp  = 0x1001deb8, s7  <~~ Word[0x1001dee4], (lsu) s4  <-- 0
          45710000                                              #; (lsu) s5  <-- 8
          45711000                                              #; (lsu) s6  <-- 0x80005ed8
          45712000                                              #; (lsu) s7  <-- 0x80005ed8
          45720000    0x80000fc0 lw s8, 40(sp)                  #; sp  = 0x1001deb8, s8  <~~ Word[0x1001dee0]
          45721000    0x80000fc4 lw s9, 36(sp)                  #; sp  = 0x1001deb8, s9  <~~ Word[0x1001dedc]
          45722000    0x80000fc8 lw s10, 32(sp)                 #; sp  = 0x1001deb8, s10 <~~ Word[0x1001ded8]
          45723000    0x80000fcc lw s11, 28(sp)                 #; sp  = 0x1001deb8, s11 <~~ Word[0x1001ded4], (lsu) s8  <-- 0x80005ef8
          45724000    0x80000fd0 addi sp, sp, 80                #; sp  = 0x1001deb8, (wrb) sp  <-- 0x1001df08
          45725000    0x80000fd4 ret                            #; ra  = 0x8000418c, (lsu) s9  <-- 6192, goto 0x8000418c
          45726000                                              #; (lsu) s10 <-- 7224
          45727000                                              #; (lsu) s11 <-- 8256
#; .LBB25_16 (start.c:268:5)
#;   snrt_cluster_hw_barrier (sync.h:174:5)
#;     asm volatile("csrr x0, 0x7C2" ::: "memory");
#;     ^
          45728000    0x8000418c csrr zero, 1986                #; csr@7c2 = 0
#; .LBB25_16 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:293:34)
#;         cls (cls.h:9:30)
#;           inline cls_t* cls() { return _cls_ptr; }
#;                                        ^
          45738000    0x80004190 lw a1, 64(s0)                  #; s0  = 0x1001df48, a1  <~~ Word[0x1001df88]
          45741000                                              #; (lsu) a1  <-- 0x1001ffe0
#; .LBB25_16 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:293:41)
#;         uint32_t *cluster_result = &(cls()->reduction);
#;                                             ^
          45742000    0x80004194 addi a2, a1, 4                 #; a1  = 0x1001ffe0, (wrb) a2  <-- 0x1001ffe4
#; .LBB25_16 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:294:20)
#;         uint32_t tmp = __atomic_fetch_add(cluster_result, value, __ATOMIC_RELAXED);
#;                        ^
          45743000    0x80004198 amoadd.w a0, a0, (a2)          #; a2  = 0x1001ffe4, a0  = 0, a0  <~~ Word[0x1001ffe4]
          45752000                                              #; (lsu) a0  <-- 0
#; .LBB25_16 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:297:5)
#;         snrt_wait_writeback (sync.h:404:5)
#;           asm volatile("mv %0, %0" : "+r"(val)::);
#;           ^
          45753000    0x8000419c mv a0, a0                      #; a0  = 0, (wrb) a0  <-- 0
#; .LBB25_16 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:298:5)
#;         snrt_cluster_hw_barrier (sync.h:174:5)
#;           asm volatile("csrr x0, 0x7C2" ::: "memory");
#;           ^
          45754000    0x800041a0 csrr zero, 1986                #; csr@7c2 = 0
#; .LBB25_16 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:300:9)
#;         if (snrt_cluster_core_idx() == 0) {
#;             ^
          45774000    0x800041a4 beqz s4, 72                    #; s4  = 0, taken, goto 0x800041ec
#; .LBB25_19 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:304:5)
#;         snrt_global_barrier (sync.h:218:5)
#;           snrt_cluster_hw_barrier (sync.h:174:5)
#;             asm volatile("csrr x0, 0x7C2" ::: "memory");
#;             ^
          45785000    0x800041ec csrr zero, 1986                #; csr@7c2 = 0
#; .LBB25_19 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:304:5)
#;         snrt_global_barrier (sync.h:230:5)
#;           snrt_cluster_hw_barrier (sync.h:174:5)
#;             asm volatile("csrr x0, 0x7C2" ::: "memory");
#;             ^
          45787000    0x800041f0 csrr zero, 1986                #; csr@7c2 = 0
#; .LBB25_19 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:308:5)
#;         snrt_cluster_hw_barrier (sync.h:174:5)
#;           asm volatile("csrr x0, 0x7C2" ::: "memory");
#;           ^
          45789000    0x800041f4 csrr zero, 1986                #; csr@7c2 = 0
#; .LBB25_20 (start.c:282:1)
#;   }
#;   ^
          45810000    0x800041f8 lw ra, 60(sp)                  #; sp  = 0x1001df08, ra  <~~ Word[0x1001df44]
          45811000    0x800041fc lw s0, 56(sp)                  #; sp  = 0x1001df08, s0  <~~ Word[0x1001df40]
          45813000                                              #; (lsu) ra  <-- 0x800001c4
          45814000                                              #; (lsu) s0  <-- 0
          45821000    0x80004200 lw s1, 52(sp)                  #; sp  = 0x1001df08, s1  <~~ Word[0x1001df3c]
          45822000    0x80004204 lw s2, 48(sp)                  #; sp  = 0x1001df08, s2  <~~ Word[0x1001df38]
          45823000    0x80004208 lw s3, 44(sp)                  #; sp  = 0x1001df08, s3  <~~ Word[0x1001df34]
          45824000    0x8000420c lw s4, 40(sp)                  #; sp  = 0x1001df08, s4  <~~ Word[0x1001df30], (lsu) s1  <-- 0
          45825000    0x80004210 lw s5, 36(sp)                  #; sp  = 0x1001df08, s5  <~~ Word[0x1001df2c], (lsu) s2  <-- 0
          45826000    0x80004214 lw s6, 32(sp)                  #; sp  = 0x1001df08, s6  <~~ Word[0x1001df28], (lsu) s3  <-- 0
          45827000    0x80004218 lw s7, 28(sp)                  #; sp  = 0x1001df08, s7  <~~ Word[0x1001df24], (lsu) s4  <-- 0
          45828000    0x8000421c lw s8, 24(sp)                  #; sp  = 0x1001df08, s8  <~~ Word[0x1001df20], (lsu) s5  <-- 0
          45829000    0x80004220 lw s9, 20(sp)                  #; sp  = 0x1001df08, s9  <~~ Word[0x1001df1c], (lsu) s6  <-- 0
          45830000    0x80004224 lw s10, 16(sp)                 #; sp  = 0x1001df08, s10 <~~ Word[0x1001df18], (lsu) s7  <-- 0
          45831000    0x80004228 lw s11, 12(sp)                 #; sp  = 0x1001df08, s11 <~~ Word[0x1001df14], (lsu) s8  <-- 0
          45832000    0x8000422c addi sp, sp, 64                #; sp  = 0x1001df08, (wrb) sp  <-- 0x1001df48
          45833000    0x80004230 ret                            #; ra  = 0x800001c4, (lsu) s9  <-- 0, goto 0x800001c4
          45834000                                              #; (lsu) s10 <-- 0
          45835000                                              #; (lsu) s11 <-- 0
#; .Ltmp2 (start.S:183)
#;   wfi
          45840000    0x800001c4 wfi                            #; 

## Performance metrics

Performance metrics for section 0 @ (20, 45838):
tstart                                          22
snitch_loads                                   197
snitch_stores                                  575
tend                                         45840
fpss_loads                                       0
snitch_avg_load_latency                      44.35
snitch_occupancy                           0.04502
snitch_fseq_rel_offloads                   0.01527
fseq_yield                                     1.0
fseq_fpu_yield                                 1.0
fpss_section_latency                             0
fpss_avg_fpu_latency                           2.0
fpss_avg_load_latency                            0
fpss_occupancy                           0.0006984
fpss_fpu_occupancy                       0.0006984
fpss_fpu_rel_occupancy                         1.0
cycles                                       45819
total_ipc                                  0.04572
