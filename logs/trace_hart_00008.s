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
            479000    0x800000f8 auipc gp, 5                    #; (wrb) gp  <-- 0x800050f8
#; snrt.crt0.init_fp_registers (start.S:79)
#;   fcvt.d.w f31, zero
                      0x800000f4 fcvt.d.w ft11, zero            #; ac1  = 0, (f:fpu) ft9  <-- 0.0
#; .Ltmp1 (start.S:89)
#;   addi    gp, gp, %pcrel_lo(1b)
            480000    0x800000fc addi gp, gp, 1520              #; gp  = 0x800050f8, (wrb) gp  <-- 0x800056e8
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
            497000    0x80000130 auipc t0, 5                    #; (wrb) t0  <-- 0x80005130
            498000    0x80000134 addi t0, t0, -600              #; t0  = 0x80005130, (wrb) t0  <-- 0x80004ed8
#; .Lpcrel_hi1 (start.S:122)
#;   la        t1, __cdata_start
            499000    0x80000138 auipc t1, 5                    #; (wrb) t1  <-- 0x80005138
            500000    0x8000013c addi t1, t1, -608              #; t1  = 0x80005138, (wrb) t1  <-- 0x80004ed8
#; .Lpcrel_hi1 (start.S:123)
#;   sub       t0, t0, t1
            501000    0x80000140 sub t0, t0, t1                 #; t0  = 0x80004ed8, t1  = 0x80004ed8, (wrb) t0  <-- 0
#; .Lpcrel_hi1 (start.S:124)
#;   sub       a2, a2, t0
            502000    0x80000144 sub a2, a2, t0                 #; a2  = 0x10020000, t0  = 0, (wrb) a2  <-- 0x10020000
#; .Lpcrel_hi2 (start.S:125)
#;   la        t0, __cbss_end
            503000    0x80000148 auipc t0, 5                    #; (wrb) t0  <-- 0x80005148
            504000    0x8000014c addi t0, t0, -592              #; t0  = 0x80005148, (wrb) t0  <-- 0x80004ef8
#; .Lpcrel_hi3 (start.S:126)
#;   la        t1, __cbss_start
            505000    0x80000150 auipc t1, 5                    #; (wrb) t1  <-- 0x80005150
            506000    0x80000154 addi t1, t1, -632              #; t1  = 0x80005150, (wrb) t1  <-- 0x80004ed8
#; .Lpcrel_hi3 (start.S:127)
#;   sub       t0, t0, t1
            507000    0x80000158 sub t0, t0, t1                 #; t0  = 0x80004ef8, t1  = 0x80004ed8, (wrb) t0  <-- 32
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
            517000    0x80000180 auipc t0, 5                    #; (wrb) t0  <-- 0x80005180
            518000    0x80000184 addi t0, t0, -748              #; t0  = 0x80005180, (wrb) t0  <-- 0x80004e94
#; .Lpcrel_hi5 (start.S:156)
#;   la        t1, __tdata_start
            519000    0x80000188 auipc t1, 5                    #; (wrb) t1  <-- 0x80005188
            520000    0x8000018c addi t1, t1, -768              #; t1  = 0x80005188, (wrb) t1  <-- 0x80004e88
#; .Lpcrel_hi5 (start.S:157)
#;   sub       t0, t0, t1
            521000    0x80000190 sub t0, t0, t1                 #; t0  = 0x80004e94, t1  = 0x80004e88, (wrb) t0  <-- 12
#; .Lpcrel_hi5 (start.S:158)
#;   sub       sp, sp, t0
            522000    0x80000194 sub sp, sp, t0                 #; sp  = 0x1001df98, t0  = 12, (wrb) sp  <-- 0x1001df8c
#; .Lpcrel_hi6 (start.S:159)
#;   la        t0, __tbss_end
            523000    0x80000198 auipc t0, 5                    #; (wrb) t0  <-- 0x80005198
            524000    0x8000019c addi t0, t0, -704              #; t0  = 0x80005198, (wrb) t0  <-- 0x80004ed8
#; .Lpcrel_hi7 (start.S:160)
#;   la        t1, __tbss_start
            525000    0x800001a0 auipc t1, 5                    #; (wrb) t1  <-- 0x800051a0
            526000    0x800001a4 addi t1, t1, -776              #; t1  = 0x800051a0, (wrb) t1  <-- 0x80004e98
#; .Lpcrel_hi7 (start.S:161)
#;   sub       t0, t0, t1
            527000    0x800001a8 sub t0, t0, t1                 #; t0  = 0x80004ed8, t1  = 0x80004e98, (wrb) t0  <-- 64
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
            532000    0x800001bc auipc ra, 3                    #; (wrb) ra  <-- 0x800031bc
            533000    0x800001c0 jalr -616(ra)                  #; ra  = 0x800031bc, (wrb) ra  <-- 0x800001c4, goto 0x80002f54
#; snrt_main (start.c:204)
#;   EXTERN_C void snrt_main() {
            543000    0x80002f54 addi sp, sp, -48               #; sp  = 0x1001df48, (wrb) sp  <-- 0x1001df18
            544000    0x80002f58 sw ra, 44(sp)                  #; sp  = 0x1001df18, 0x800001c4 ~~> Word[0x1001df44]
            545000    0x80002f5c sw s0, 40(sp)                  #; sp  = 0x1001df18, 0 ~~> Word[0x1001df40]
            546000    0x80002f60 sw s1, 36(sp)                  #; sp  = 0x1001df18, 0 ~~> Word[0x1001df3c]
            547000    0x80002f64 sw s2, 32(sp)                  #; sp  = 0x1001df18, 0 ~~> Word[0x1001df38]
            548000    0x80002f68 sw s3, 28(sp)                  #; sp  = 0x1001df18, 0 ~~> Word[0x1001df34]
            549000    0x80002f6c sw s4, 24(sp)                  #; sp  = 0x1001df18, 0 ~~> Word[0x1001df30]
            550000    0x80002f70 sw s5, 20(sp)                  #; sp  = 0x1001df18, 0 ~~> Word[0x1001df2c]
            551000    0x80002f74 sw s6, 16(sp)                  #; sp  = 0x1001df18, 0 ~~> Word[0x1001df28]
            552000    0x80002f78 sw s7, 12(sp)                  #; sp  = 0x1001df18, 0 ~~> Word[0x1001df24]
            553000    0x80002f7c sw s8, 8(sp)                   #; sp  = 0x1001df18, 0 ~~> Word[0x1001df20]
            556000    0x80002f80 sw s9, 4(sp)                   #; sp  = 0x1001df18, 0 ~~> Word[0x1001df1c]
            557000    0x80002f84 sw s10, 0(sp)                  #; sp  = 0x1001df18, 0 ~~> Word[0x1001df18]
            558000    0x80002f88 li s3, -1                      #; (wrb) s3  <-- -1
#; snrt_main (start.c:206:9)
#;   snrt_cluster_idx (team.h:99:12)
#;     snrt_global_core_idx (team.h:80:12)
#;       snrt_hartid (team.h:25:5)
#;         asm("csrr %0, mhartid" : "=r"(hartid));
#;         ^
            559000    0x80002f8c csrr s2, mhartid               #; mhartid = 8, (wrb) s2  <-- 8
            560000    0x80002f90 lui a0, 233017                 #; (wrb) a0  <-- 0x38e39000
            561000    0x80002f94 addi a0, a0, -455              #; a0  = 0x38e39000, (wrb) a0  <-- 0x38e38e39
#; snrt_main (start.c:206:9)
#;   snrt_cluster_idx (team.h:99:35)
#;     return snrt_global_core_idx() / snrt_cluster_core_num();
#;                                   ^
            562000    0x80002f98 mulhu a0, s2, a0               #; s2  = 8, a0  = 0x38e38e39
            564000                                              #; (acc) a0  <-- 1
            565000    0x80002f9c srli a0, a0, 1                 #; a0  = 1, (wrb) a0  <-- 0
            566000    0x80002fa0 li a1, 9                       #; (wrb) a1  <-- 9
            567000    0x80002fa4 slli s6, a0, 18                #; a0  = 0, (wrb) s6  <-- 0
#; snrt_main (start.c:206:9)
#;   if (snrt_cluster_idx() == 0) {
#;       ^
            568000    0x80002fa8 bgeu s2, a1, 136               #; s2  = 8, a1  = 9, not taken
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:31)
#;       snrt_cluster_core_idx (team.h:108:35)
#;         return snrt_global_core_idx() % snrt_cluster_core_num();
#;                                       ^
            569000    0x80002fac .text                          #; s2  = 8
            570000    0x80002fb0 li a1, 57                      #; (wrb) a1  <-- 57
            571000                                              #; (acc) a0  <-- 8
            572000    0x80002fb4 mul a0, a0, a1                 #; a0  = 8, a1  = 57
            574000                                              #; (acc) a0  <-- 456
            575000    0x80002fb8 srli a0, a0, 9                 #; a0  = 456, (wrb) a0  <-- 0
            576000    0x80002fbc slli a1, a0, 3                 #; a0  = 0, (wrb) a1  <-- 0
            577000    0x80002fc0 add a0, a1, a0                 #; a1  = 0, a0  = 0, (wrb) a0  <-- 0
            578000    0x80002fc4 sub a1, s2, a0                 #; s2  = 8, a0  = 0, (wrb) a1  <-- 8
            579000    0x80002fc8 lui a0, 65569                  #; (wrb) a0  <-- 0x10021000
            580000    0x80002fcc addi a0, a0, 424               #; a0  = 0x10021000, (wrb) a0  <-- 0x100211a8
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:5)
#;       snrt_int_cluster_clr (cluster_interrupts.h:22:53)
#;         snrt_cluster()->peripheral_reg.cl_clint_clear.f.cl_clint_clear = mask;
#;                                                         ^
            581000    0x80002fd0 add a2, s6, a0                 #; s6  = 0, a0  = 0x100211a8, (wrb) a2  <-- 0x100211a8
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:5)
#;       snrt_int_cluster_clr (cluster_interrupts.h:22:68)
#;         snrt_cluster()->peripheral_reg.cl_clint_clear.f.cl_clint_clear = mask;
#;                                                                        ^
            582000    0x80002fd4 lw a0, 0(a2)                   #; a2  = 0x100211a8, a0  <~~ Word[0x100211a8]
            583000    0x80002fd8 ori a3, a2, 4                  #; a2  = 0x100211a8, (wrb) a3  <-- 0x100211ac
            584000    0x80002fdc lw a4, 0(a3)                   #; a3  = 0x100211ac, a4  <~~ Word[0x100211ac]
            591000                                              #; (lsu) a0  <-- 0
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:31)
#;       snrt_cluster_core_idx (team.h:108:35)
#;         return snrt_global_core_idx() % snrt_cluster_core_num();
#;                                       ^
            592000    0x80002fe0 .text                          #; a1  = 8
            593000    0x80002fe4 li a5, 1                       #; (wrb) a5  <-- 1
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:28)
#;       snrt_int_cluster_clr(1 << snrt_cluster_core_idx());
#;                              ^
            594000    0x80002fe8 sll a5, a5, a1                 #; a5  = 1, a1  = 8, (wrb) a5  <-- 256
            595000                                              #; (acc) a0  <-- 8
            619000                                              #; (lsu) a4  <-- 0
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:5)
#;       snrt_int_cluster_clr (cluster_interrupts.h:22:68)
#;         snrt_cluster()->peripheral_reg.cl_clint_clear.f.cl_clint_clear = mask;
#;                                                                        ^
            620000    0x80002fec and a4, a4, s3                 #; a4  = 0, s3  = -1, (wrb) a4  <-- 0
            621000    0x80002ff0 sw a4, 0(a3)                   #; a3  = 0x100211ac, 0 ~~> Word[0x100211ac]
            622000    0x80002ff4 sw a5, 0(a2)                   #; a2  = 0x100211a8, 256 ~~> Word[0x100211a8]
            623000    0x80002ff8 lui a2, 128                    #; (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            624000    0x80002ffc csrr a3, mip                   #; mip = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            625000    0x80003000 and a3, a3, a2                 #; a3  = 0x00080000, a2  = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            626000    0x80003004 bnez a3, -8                    #; a3  = 0x00080000, taken, goto 0x80002ffc
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            627000    0x80002ffc csrr a3, mip                   #; mip = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            628000    0x80003000 and a3, a3, a2                 #; a3  = 0x00080000, a2  = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            629000    0x80003004 bnez a3, -8                    #; a3  = 0x00080000, taken, goto 0x80002ffc
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            630000    0x80002ffc csrr a3, mip                   #; mip = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            631000    0x80003000 and a3, a3, a2                 #; a3  = 0x00080000, a2  = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            632000    0x80003004 bnez a3, -8                    #; a3  = 0x00080000, taken, goto 0x80002ffc
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            633000    0x80002ffc csrr a3, mip                   #; mip = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            634000    0x80003000 and a3, a3, a2                 #; a3  = 0x00080000, a2  = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            635000    0x80003004 bnez a3, -8                    #; a3  = 0x00080000, taken, goto 0x80002ffc
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            636000    0x80002ffc csrr a3, mip                   #; mip = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            637000    0x80003000 and a3, a3, a2                 #; a3  = 0x00080000, a2  = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            638000    0x80003004 bnez a3, -8                    #; a3  = 0x00080000, taken, goto 0x80002ffc
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            639000    0x80002ffc csrr a3, mip                   #; mip = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            640000    0x80003000 and a3, a3, a2                 #; a3  = 0x00080000, a2  = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            641000    0x80003004 bnez a3, -8                    #; a3  = 0x00080000, taken, goto 0x80002ffc
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            642000    0x80002ffc csrr a3, mip                   #; mip = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            643000    0x80003000 and a3, a3, a2                 #; a3  = 0x00080000, a2  = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            644000    0x80003004 bnez a3, -8                    #; a3  = 0x00080000, taken, goto 0x80002ffc
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            645000    0x80002ffc csrr a3, mip                   #; mip = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            646000    0x80003000 and a3, a3, a2                 #; a3  = 0x00080000, a2  = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            647000    0x80003004 bnez a3, -8                    #; a3  = 0x00080000, taken, goto 0x80002ffc
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            648000    0x80002ffc csrr a3, mip                   #; mip = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            649000    0x80003000 and a3, a3, a2                 #; a3  = 0x00080000, a2  = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            650000    0x80003004 bnez a3, -8                    #; a3  = 0x00080000, taken, goto 0x80002ffc
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            651000    0x80002ffc csrr a3, mip                   #; mip = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            652000    0x80003000 and a3, a3, a2                 #; a3  = 0x00080000, a2  = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            653000    0x80003004 bnez a3, -8                    #; a3  = 0x00080000, taken, goto 0x80002ffc
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            654000    0x80002ffc csrr a3, mip                   #; mip = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            655000    0x80003000 and a3, a3, a2                 #; a3  = 0x00080000, a2  = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            656000    0x80003004 bnez a3, -8                    #; a3  = 0x00080000, taken, goto 0x80002ffc
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            657000    0x80002ffc csrr a3, mip                   #; mip = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            658000    0x80003000 and a3, a3, a2                 #; a3  = 0x00080000, a2  = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            659000    0x80003004 bnez a3, -8                    #; a3  = 0x00080000, taken, goto 0x80002ffc
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            660000    0x80002ffc csrr a3, mip                   #; mip = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            661000    0x80003000 and a3, a3, a2                 #; a3  = 0x00080000, a2  = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            662000    0x80003004 bnez a3, -8                    #; a3  = 0x00080000, taken, goto 0x80002ffc
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            663000    0x80002ffc csrr a3, mip                   #; mip = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            664000    0x80003000 and a3, a3, a2                 #; a3  = 0x00080000, a2  = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            665000    0x80003004 bnez a3, -8                    #; a3  = 0x00080000, taken, goto 0x80002ffc
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            666000    0x80002ffc csrr a3, mip                   #; mip = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            667000    0x80003000 and a3, a3, a2                 #; a3  = 0x00080000, a2  = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            668000    0x80003004 bnez a3, -8                    #; a3  = 0x00080000, taken, goto 0x80002ffc
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            669000    0x80002ffc csrr a3, mip                   #; mip = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            670000    0x80003000 and a3, a3, a2                 #; a3  = 0x00080000, a2  = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            671000    0x80003004 bnez a3, -8                    #; a3  = 0x00080000, taken, goto 0x80002ffc
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            672000    0x80002ffc csrr a3, mip                   #; mip = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            673000    0x80003000 and a3, a3, a2                 #; a3  = 0x00080000, a2  = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            674000    0x80003004 bnez a3, -8                    #; a3  = 0x00080000, taken, goto 0x80002ffc
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            675000    0x80002ffc csrr a3, mip                   #; mip = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            676000    0x80003000 and a3, a3, a2                 #; a3  = 0x00080000, a2  = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            677000    0x80003004 bnez a3, -8                    #; a3  = 0x00080000, taken, goto 0x80002ffc
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            678000    0x80002ffc csrr a3, mip                   #; mip = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            679000    0x80003000 and a3, a3, a2                 #; a3  = 0x00080000, a2  = 0x00080000, (wrb) a3  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            680000    0x80003004 bnez a3, -8                    #; a3  = 0x00080000, taken, goto 0x80002ffc
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            681000    0x80002ffc csrr a3, mip                   #; mip = 0, (wrb) a3  <-- 0
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            682000    0x80003000 and a3, a3, a2                 #; a3  = 0, a2  = 0x00080000, (wrb) a3  <-- 0
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            683000    0x80003004 bnez a3, -8                    #; a3  = 0, not taken
            684000    0x80003008 li a2, 8                       #; (wrb) a2  <-- 8
#; .LBB25_2 (start.c:206:28)
#;   if (snrt_cluster_idx() == 0) {
#;                          ^
            685000    0x8000300c sltu a2, a2, s2                #; a2  = 8, s2  = 8, (wrb) a2  <-- 0
            686000    0x80003010 .text                          #; a1  = 8
            688000                                              #; (acc) a1  <-- 8
            689000    0x80003014 snez a3, a1                    #; a1  = 8, (wrb) a3  <-- 1
#; .LBB25_2 (start.c:221:5)
#;   snrt_wake_up (start.c:124:33)
#;     if (snrt_cluster_idx() == 0 && snrt_cluster_core_idx() == 0) {
#;                                 ^
            690000    0x80003018 or a2, a2, a3                  #; a2  = 0, a3  = 1, (wrb) a2  <-- 1
            691000    0x8000301c seqz s5, a1                    #; a1  = 8, (wrb) s5  <-- 0
            692000    0x80003020 bnez a2, 32                    #; a2  = 1, taken, goto 0x80003040
#; .LBB25_6 (start.c:221:5)
#;   snrt_wake_up (start.c:137:5)
#;     snrt_cluster_hw_barrier (sync.h:174:5)
#;       asm volatile("csrr x0, 0x7C2" ::: "memory");
#;       ^
            693000    0x80003040 csrr zero, 1986                #; csr@7c2 = 0
            722000    0x80003044 lui a1, 65569                  #; (wrb) a1  <-- 0x10021000
            723000    0x80003048 addi a1, a1, 424               #; a1  = 0x10021000, (wrb) a1  <-- 0x100211a8
#; .LBB25_6 (start.c:221:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;       snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:5)
#;         snrt_int_cluster_clr (cluster_interrupts.h:22:53)
#;           snrt_cluster()->peripheral_reg.cl_clint_clear.f.cl_clint_clear = mask;
#;                                                           ^
            724000    0x8000304c add s4, s6, a1                 #; s6  = 0, a1  = 0x100211a8, (wrb) s4  <-- 0x100211a8
#; .LBB25_6 (start.c:221:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;       snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:5)
#;         snrt_int_cluster_clr (cluster_interrupts.h:22:68)
#;           snrt_cluster()->peripheral_reg.cl_clint_clear.f.cl_clint_clear = mask;
#;                                                                          ^
            725000    0x80003050 lw a1, 0(s4)                   #; s4  = 0x100211a8, a1  <~~ Word[0x100211a8]
            734000                                              #; (lsu) a1  <-- 0
            735000    0x80003054 ori a1, s4, 4                  #; s4  = 0x100211a8, (wrb) a1  <-- 0x100211ac
            736000    0x80003058 lw a2, 0(a1)                   #; a1  = 0x100211ac, a2  <~~ Word[0x100211ac]
            737000    0x8000305c li a3, 1                       #; (wrb) a3  <-- 1
#; .LBB25_6 (start.c:221:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;       snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:28)
#;         snrt_int_cluster_clr(1 << snrt_cluster_core_idx());
#;                                ^
            738000    0x80003060 sll a3, a3, a0                 #; a3  = 1, a0  = 8, (wrb) a3  <-- 256
            762000                                              #; (lsu) a2  <-- 0
#; .LBB25_6 (start.c:221:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;       snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:5)
#;         snrt_int_cluster_clr (cluster_interrupts.h:22:68)
#;           snrt_cluster()->peripheral_reg.cl_clint_clear.f.cl_clint_clear = mask;
#;                                                                          ^
            763000    0x80003064 and a2, a2, s3                 #; a2  = 0, s3  = -1, (wrb) a2  <-- 0
            764000    0x80003068 sw a3, 0(s4)                   #; s4  = 0x100211a8, 256 ~~> Word[0x100211a8]
            765000    0x8000306c sw a2, 0(a1)                   #; a1  = 0x100211ac, 0 ~~> Word[0x100211ac]
            766000    0x80003070 lui a1, 128                    #; (wrb) a1  <-- 0x00080000
#; .LBB25_7 (start.c:221:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;       snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;         while (read_csr(mip) & MIP_MCIP)
#;                ^
            767000    0x80003074 csrr a2, mip                   #; mip = 0, (wrb) a2  <-- 0
#; .LBB25_7 (start.c:221:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;       snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;         while (read_csr(mip) & MIP_MCIP)
#;                              ^
            768000    0x80003078 and a2, a2, a1                 #; a2  = 0, a1  = 0x00080000, (wrb) a2  <-- 0
#; .LBB25_7 (start.c:221:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;       snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;         while (read_csr(mip) & MIP_MCIP)
#;         ^
            769000    0x8000307c bnez a2, -8                    #; a2  = 0, not taken
            776000    0x80003080 auipc s0, 2                    #; (wrb) s0  <-- 0x80005080
            777000    0x80003084 addi s0, s0, -424              #; s0  = 0x80005080, (wrb) s0  <-- 0x80004ed8
            778000    0x80003088 auipc s8, 2                    #; (wrb) s8  <-- 0x80005088
            779000    0x8000308c addi s8, s8, -432              #; s8  = 0x80005088, (wrb) s8  <-- 0x80004ed8
            780000    0x80003090 auipc s9, 2                    #; (wrb) s9  <-- 0x80005090
            781000    0x80003094 addi s9, s9, -408              #; s9  = 0x80005090, (wrb) s9  <-- 0x80004ef8
            782000    0x80003098 auipc s10, 2                   #; (wrb) s10 <-- 0x80005098
            783000    0x8000309c addi s10, s10, -448            #; s10 = 0x80005098, (wrb) s10 <-- 0x80004ed8
            784000    0x800030a0 auipc s7, 4                    #; (wrb) s7  <-- 0x800070a0
            785000    0x800030a4 addi s7, s7, 1480              #; s7  = 0x800070a0, (wrb) s7  <-- 0x80007668
#; .LBB25_33 (start.c:239:5)
#;   snrt_init_cls (start.c:166:13)
#;     if (snrt_cluster_core_idx() == 0) {
#;         ^
            786000    0x800030a8 beqz s5, 120                   #; s5  = 0, taken, goto 0x80003120
#; .LBB25_14 (start.c:239:5)
#;   snrt_init_cls (start.c:182:14)
#;     _cls_ptr = (cls_t*)snrt_cls_base_addr();
#;              ^
            798000    0x80003120 sub a1, s8, s0                 #; s8  = 0x80004ed8, s0  = 0x80004ed8, (wrb) a1  <-- 0
            799000    0x80003124 add a1, a1, s9                 #; a1  = 0, s9  = 0x80004ef8, (wrb) a1  <-- 0x80004ef8
            800000    0x80003128 sub a2, s10, a1                #; s10 = 0x80004ed8, a1  = 0x80004ef8, (wrb) a2  <-- -32
            801000    0x8000312c lui a1, 65568                  #; (wrb) a1  <-- 0x10020000
            802000    0x80003130 add a3, a2, a1                 #; a2  = -32, a1  = 0x10020000, (wrb) a3  <-- 0x1001ffe0
            803000    0x80003134 lui a2, 0                      #; (wrb) a2  <-- 0
            804000    0x80003138 add a2, a2, tp                 #; a2  = 0, tp  = 0x1001df48, (wrb) a2  <-- 0x1001df48
            805000    0x8000313c sw a3, 64(a2)                  #; a2  = 0x1001df48, 0x1001ffe0 ~~> Word[0x1001df88]
#; .LBB25_14 (start.c:239:5)
#;   snrt_init_cls (start.c:183:5)
#;     snrt_cluster_hw_barrier (sync.h:174:5)
#;       asm volatile("csrr x0, 0x7C2" ::: "memory");
#;       ^
            811000    0x80003140 csrr zero, 1986                #; csr@7c2 = 0
            851000    0x80003144 li a3, 8                       #; (wrb) a3  <-- 8
#; .LBB25_14 (start.c:247:5)
#;   snrt_init_libs (start.c:189:5)
#;     snrt_alloc_init (alloc.h:113:9)
#;       if (snrt_is_dm_core()) {
#;           ^
            852000    0x80003148 bltu a0, a3, 84                #; a0  = 8, a3  = 8, not taken
#; .LBB25_14 (start.c:247:5)
#;   snrt_init_libs (start.c:189:5)
#;     snrt_alloc_init (alloc.h:119:9)
#;       snrt_l1_allocator (alloc.h:47:34)
#;         cls (cls.h:9:30)
#;           inline cls_t* cls() { return _cls_ptr; }
#;                                        ^
            853000    0x8000314c lw a0, 64(a2)                  #; a2  = 0x1001df48, a0  <~~ Word[0x1001df88]
            854000    0x80003150 lui a2, 65536                  #; (wrb) a2  <-- 0x10000000
#; .LBB25_14 (start.c:247:5)
#;   snrt_init_libs (start.c:189:5)
#;     snrt_alloc_init (alloc.h:118:47)
#;       snrt_cluster (snitch_cluster_memory.h:23:46)
#;         return &(snitch_cluster_addrmap.cluster) + snrt_cluster_idx();
#;                                                  ^
            855000    0x80003154 add a2, s6, a2                 #; s6  = 0, a2  = 0x10000000, (wrb) a2  <-- 0x10000000
            856000                                              #; (lsu) a0  <-- 0x1001ffe0
#; .LBB25_14 (start.c:247:5)
#;   snrt_init_libs (start.c:189:5)
#;     snrt_alloc_init (alloc.h:119:35)
#;       snrt_l1_allocator()->base =
#;                                 ^
            857000    0x80003158 sw a2, 8(a0)                   #; a0  = 0x1001ffe0, 0x10000000 ~~> Word[0x1001ffe8]
            858000    0x8000315c sw zero, 12(a0)                #; a0  = 0x1001ffe0, 0 ~~> Word[0x1001ffec]
#; .LBB25_14 (start.c:247:5)
#;   snrt_init_libs (start.c:189:5)
#;     snrt_alloc_init (alloc.h:121:50)
#;       snrt_l1_allocator()->end = l1_start_addr + SNRT_TCDM_SIZE;
#;                                                ^
            859000    0x80003160 add a1, s6, a1                 #; s6  = 0, a1  = 0x10020000, (wrb) a1  <-- 0x10020000
#; .LBB25_14 (start.c:247:5)
#;   snrt_init_libs (start.c:189:5)
#;     snrt_alloc_init (alloc.h:121:34)
#;       snrt_l1_allocator()->end = l1_start_addr + SNRT_TCDM_SIZE;
#;                                ^
            860000    0x80003164 sw a1, 16(a0)                  #; a0  = 0x1001ffe0, 0x10020000 ~~> Word[0x1001fff0]
            861000    0x80003168 sw zero, 20(a0)                #; a0  = 0x1001ffe0, 0 ~~> Word[0x1001fff4]
#; .LBB25_14 (start.c:247:5)
#;   snrt_init_libs (start.c:189:5)
#;     snrt_alloc_init (alloc.h:122:35)
#;       snrt_l1_allocator()->next = snrt_l1_allocator()->base;
#;                                 ^
            862000    0x8000316c sw a2, 24(a0)                  #; a0  = 0x1001ffe0, 0x10000000 ~~> Word[0x1001fff8]
            863000    0x80003170 sw zero, 28(a0)                #; a0  = 0x1001ffe0, 0 ~~> Word[0x1001fffc]
            864000    0x80003174 addi a0, s7, 7                 #; s7  = 0x80007668, (wrb) a0  <-- 0x8000766f
#; .LBB25_14 (start.c:247:5)
#;   snrt_init_libs (start.c:189:5)
#;     snrt_alloc_init (alloc.h:125:35)
#;       snrt_l3_allocator()->base =
#;                                 ^
            865000    0x80003178 andi a0, a0, -8                #; a0  = 0x8000766f, (wrb) a0  <-- 0x80007668
            866000    0x8000317c auipc a1, 2                    #; (wrb) a1  <-- 0x8000517c
            867000    0x80003180 addi a1, a1, -436              #; a1  = 0x8000517c, (wrb) a1  <-- 0x80004fc8
#; .LBB25_34 (start.c:247:5)
#;   snrt_init_libs (start.c:189:5)
#;     snrt_alloc_init (alloc.h:125:35)
#;       snrt_l3_allocator()->base =
#;                                 ^
            868000    0x80003184 sw a0, 0(a1)                   #; a1  = 0x80004fc8, 0x80007668 ~~> Word[0x80004fc8]
            869000    0x80003188 sw zero, 4(a1)                 #; a1  = 0x80004fc8, 0 ~~> Word[0x80004fcc]
#; .LBB25_34 (start.c:247:5)
#;   snrt_init_libs (start.c:189:5)
#;     snrt_alloc_init (alloc.h:127:34)
#;       snrt_l3_allocator()->end = snrt_l3_allocator()->base;
#;                                ^
            870000    0x8000318c sw a0, 8(a1)                   #; a1  = 0x80004fc8, 0x80007668 ~~> Word[0x80004fd0]
            871000    0x80003190 sw zero, 12(a1)                #; a1  = 0x80004fc8, 0 ~~> Word[0x80004fd4]
#; .LBB25_34 (start.c:247:5)
#;   snrt_init_libs (start.c:189:5)
#;     snrt_alloc_init (alloc.h:128:35)
#;       snrt_l3_allocator()->next = snrt_l3_allocator()->base;
#;                                 ^
            880000    0x80003194 sw a0, 16(a1)                  #; a1  = 0x80004fc8, 0x80007668 ~~> Word[0x80004fd8]
            881000    0x80003198 sw zero, 20(a1)                #; a1  = 0x80004fc8, 0 ~~> Word[0x80004fdc]
#; .LBB25_16 (start.c:247:5)
#;   snrt_init_libs (start.c:189:5)
#;     snrt_alloc_init (alloc.h:131:5)
#;       snrt_cluster_hw_barrier (sync.h:174:5)
#;         asm volatile("csrr x0, 0x7C2" ::: "memory");
#;         ^
            882000    0x8000319c csrr zero, 1986                #; csr@7c2 = 0
            884000    0x800031a0 lui a0, 65536                  #; (wrb) a0  <-- 0x10000000
#; .LBB25_16 (start.c:247:5)
#;   snrt_init_libs (start.c:190:5)
#;     snrt_l1_init (alloc_v2.h:117:43)
#;       snrt_cluster (snitch_cluster_memory.h:23:46)
#;         return &(snitch_cluster_addrmap.cluster) + snrt_cluster_idx();
#;                                                  ^
            885000    0x800031a4 add a0, s6, a0                 #; s6  = 0, a0  = 0x10000000, (wrb) a0  <-- 0x10000000
#; .LBB25_16 (start.c:247:5)
#;   snrt_init_libs (start.c:190:5)
#;     snrt_l1_init (alloc_v2.h:118:34)
#;       snrt_l1_allocator_v2()->base = snrt_align_up(l1_start_addr, MIN_CHUNK_SIZE);
#;                                    ^
            886000    0x800031a8 lui a1, 0                      #; (wrb) a1  <-- 0
            887000    0x800031ac add a1, a1, tp                 #; a1  = 0, tp  = 0x1001df48, (wrb) a1  <-- 0x1001df48
            890000    0x800031b0 sw zero, 20(a1)                #; a1  = 0x1001df48, 0 ~~> Word[0x1001df5c]
            891000    0x800031b4 sw a0, 16(a1)                  #; a1  = 0x1001df48, 0x10000000 ~~> Word[0x1001df58]
            892000    0x800031b8 addi a1, a1, 16                #; a1  = 0x1001df48, (wrb) a1  <-- 0x1001df58
#; .LBB25_16 (start.c:247:5)
#;   snrt_init_libs (start.c:190:5)
#;     snrt_l1_init (alloc_v2.h:119:33)
#;       snrt_l1_allocator_v2()->end = heap_end_addr;
#;                                   ^
            900000    0x800031bc sw zero, 12(a1)                #; a1  = 0x1001df58, 0 ~~> Word[0x1001df64]
            901000    0x800031c0 sub a2, s8, s0                 #; s8  = 0x80004ed8, s0  = 0x80004ed8, (wrb) a2  <-- 0
            902000    0x800031c4 add a2, a2, s9                 #; a2  = 0, s9  = 0x80004ef8, (wrb) a2  <-- 0x80004ef8
            903000    0x800031c8 sub a2, s10, a2                #; s10 = 0x80004ed8, a2  = 0x80004ef8, (wrb) a2  <-- -32
            904000    0x800031cc lui a3, 65566                  #; (wrb) a3  <-- 0x1001e000
            905000    0x800031d0 addi a3, a3, -1152             #; a3  = 0x1001e000, (wrb) a3  <-- 0x1001db80
            906000    0x800031d4 add a2, a2, a3                 #; a2  = -32, a3  = 0x1001db80, (wrb) a2  <-- 0x1001db60
            907000    0x800031d8 sw a2, 8(a1)                   #; a1  = 0x1001df58, 0x1001db60 ~~> Word[0x1001df60]
#; .LBB25_16 (start.c:247:5)
#;   snrt_init_libs (start.c:190:5)
#;     snrt_l1_init (alloc_v2.h:120:34)
#;       snrt_l1_allocator_v2()->next = snrt_l1_allocator_v2()->base;
#;                                    ^
            908000    0x800031dc sw zero, 20(a1)                #; a1  = 0x1001df58, 0 ~~> Word[0x1001df6c]
            909000    0x800031e0 sw a0, 16(a1)                  #; a1  = 0x1001df58, 0x10000000 ~~> Word[0x1001df68]
#; .LBB25_16 (start.c:247:5)
#;   snrt_init_libs (start.c:191:5)
#;     snrt_l3_init (alloc_v2.h:184:34)
#;       snrt_l3_allocator_v2()->base =
#;                                    ^
            910000    0x800031e4 lui a0, 0                      #; (wrb) a0  <-- 0
            911000    0x800031e8 add a0, a0, tp                 #; a0  = 0, tp  = 0x1001df48, (wrb) a0  <-- 0x1001df48
            912000    0x800031ec sw zero, 44(a0)                #; a0  = 0x1001df48, 0 ~~> Word[0x1001df74]
            913000    0x800031f0 addi a1, s7, 7                 #; s7  = 0x80007668, (wrb) a1  <-- 0x8000766f
            914000    0x800031f4 andi a1, a1, -8                #; a1  = 0x8000766f, (wrb) a1  <-- 0x80007668
            915000    0x800031f8 sw a1, 40(a0)                  #; a0  = 0x1001df48, 0x80007668 ~~> Word[0x1001df70]
            916000    0x800031fc addi a0, a0, 40                #; a0  = 0x1001df48, (wrb) a0  <-- 0x1001df70
            917000    0x80003200 li a2, 1                       #; (wrb) a2  <-- 1
#; .LBB25_16 (start.c:247:5)
#;   snrt_init_libs (start.c:191:5)
#;     snrt_l3_init (alloc_v2.h:186:33)
#;       snrt_l3_allocator_v2()->end = SNRT_L3_END_ADDR;
#;                                   ^
            918000    0x80003204 sw a2, 12(a0)                  #; a0  = 0x1001df70, 1 ~~> Word[0x1001df7c]
            919000    0x80003208 sw zero, 8(a0)                 #; a0  = 0x1001df70, 0 ~~> Word[0x1001df78]
#; .LBB25_16 (start.c:247:5)
#;   snrt_init_libs (start.c:191:5)
#;     snrt_l3_init (alloc_v2.h:187:34)
#;       snrt_l3_allocator_v2()->next = snrt_l3_allocator_v2()->base;
#;                                    ^
            920000    0x8000320c sw zero, 20(a0)                #; a0  = 0x1001df70, 0 ~~> Word[0x1001df84]
            921000    0x80003210 sw a1, 16(a0)                  #; a0  = 0x1001df70, 0x80007668 ~~> Word[0x1001df80]
#; .LBB25_16 (start.c:247:5)
#;   snrt_init_libs (start.c:192:5)
#;     snrt_comm_init (sync.h:37:48)
#;       inline void snrt_comm_init() { snrt_comm_world = &snrt_comm_world_info; }
#;                                                      ^
            922000    0x80003214 lui a0, 0                      #; (wrb) a0  <-- 0
            923000    0x80003218 add s0, a0, tp                 #; a0  = 0, tp  = 0x1001df48, (wrb) s0  <-- 0x1001df48
            924000    0x8000321c lui a0, 0                      #; (wrb) a0  <-- 0
            925000    0x80003220 add a0, a0, tp                 #; a0  = 0, tp  = 0x1001df48, (wrb) a0  <-- 0x1001df48
            926000    0x80003224 mv a0, a0                      #; a0  = 0x1001df48, (wrb) a0  <-- 0x1001df48
            927000    0x80003228 sw a0, 76(s0)                  #; s0  = 0x1001df48, 0x1001df48 ~~> Word[0x1001df94]
#; .LBB25_16 (start.c:255:5)
#;   snrt_cluster_hw_barrier (sync.h:174:5)
#;     asm volatile("csrr x0, 0x7C2" ::: "memory");
#;     ^
            928000    0x8000322c csrr zero, 1986                #; csr@7c2 = 0
#; .LBB25_16 (start.c:264:17)
#;   exit_code = main();
#;               ^
            930000    0x80003230 auipc ra, 1048573              #; (wrb) ra  <-- 0x80000230
            931000    0x80003234 jalr -100(ra)                  #; ra  = 0x80000230, (wrb) ra  <-- 0x80003238, goto 0x800001cc
#; main (xpulp_abs.c:7:2)
#;   snrt_cluster_hw_barrier (sync.h:174:5)
#;     asm volatile("csrr x0, 0x7C2" ::: "memory");
#;     ^
            942000    0x800001cc csrr zero, 1986                #; csr@7c2 = 0
#; main (xpulp_abs.c:6:15)
#;   snrt_global_core_idx (team.h:80:12)
#;     snrt_hartid (team.h:25:5)
#;       asm("csrr %0, mhartid" : "=r"(hartid));
#;       ^
            944000    0x800001d0 csrr a0, mhartid               #; mhartid = 8, (wrb) a0  <-- 8
            945000    0x800001d4 li a1, 2                       #; (wrb) a1  <-- 2
#; main (xpulp_abs.c:8:8)
#;   if (i == 2) {
#;       ^
            946000    0x800001d8 bne a0, a1, 24                 #; a0  = 8, a1  = 2, taken, goto 0x800001f0
            947000    0x800001f0 li a0, 0                       #; (wrb) a0  <-- 0
#; .LBB0_2 (xpulp_abs.c:30:1)
#;   }
#;   ^
            948000    0x800001f4 ret                            #; ra  = 0x80003238, goto 0x80003238
#; .LBB25_16 (start.c:272:5)
#;   snrt_cluster_hw_barrier (sync.h:174:5)
#;     asm volatile("csrr x0, 0x7C2" ::: "memory");
#;     ^
            949000    0x80003238 csrr zero, 1986                #; csr@7c2 = 0
#; .LBB25_16 (start.c:280:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:293:34)
#;         cls (cls.h:9:30)
#;           inline cls_t* cls() { return _cls_ptr; }
#;                                        ^
            956000    0x8000323c lui a1, 0                      #; (wrb) a1  <-- 0
            957000    0x80003240 add a1, a1, tp                 #; a1  = 0, tp  = 0x1001df48, (wrb) a1  <-- 0x1001df48
            958000    0x80003244 lw a1, 64(a1)                  #; a1  = 0x1001df48, a1  <~~ Word[0x1001df88]
            961000                                              #; (lsu) a1  <-- 0x1001ffe0
#; .LBB25_16 (start.c:280:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:293:41)
#;         uint32_t *cluster_result = &(cls()->reduction);
#;                                             ^
            962000    0x80003248 addi a2, a1, 4                 #; a1  = 0x1001ffe0, (wrb) a2  <-- 0x1001ffe4
#; .LBB25_16 (start.c:280:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:294:20)
#;         uint32_t tmp = __atomic_fetch_add(cluster_result, value, __ATOMIC_RELAXED);
#;                        ^
            963000    0x8000324c amoadd.w a0, a0, (a2)          #; a2  = 0x1001ffe4, a0  = 0, a0  <~~ Word[0x1001ffe4]
            990000                                              #; (lsu) a0  <-- 0
#; .LBB25_16 (start.c:280:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:297:5)
#;         snrt_wait_writeback (sync.h:404:5)
#;           asm volatile("mv %0, %0" : "+r"(val)::);
#;           ^
            991000    0x80003250 DASM(00050513                 

## Performance metrics

Performance metrics for section 0 @ (20, 989):
tstart                                          22
snitch_loads                                     8
snitch_stores                                   43
tend                                           991
fpss_loads                                       0
snitch_avg_load_latency                      14.88
snitch_occupancy                            0.3237
snitch_fseq_rel_offloads                   0.09249
fseq_yield                                     1.0
fseq_fpu_yield                                 1.0
fpss_section_latency                             0
fpss_avg_fpu_latency                           2.0
fpss_avg_load_latency                            0
fpss_occupancy                             0.03299
fpss_fpu_occupancy                         0.03299
fpss_fpu_rel_occupancy                         1.0
cycles                                         970
total_ipc                                   0.3567
