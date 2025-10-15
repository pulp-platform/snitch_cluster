             11000    0x18020000 auipc t0, 0                    #; (wrb) t0  <-- 0x18020000
             24000    0x18020004 addi t0, t0, 32                #; t0  = 0x18020000, (wrb) t0  <-- 0x18020020
             37000    0x18020008 csrw mtvec, t0                 #; t0  = 0x18020020
             52000    0x1802000c csrsi mstatus, 8               #; mstatus = 0x80006000
             65000    0x18020010 lui t0, 128                    #; (wrb) t0  <-- 0x00080000
             78000    0x18020014 addi t0, t0, 8                 #; t0  = 0x00080000, (wrb) t0  <-- 0x00080008
             91000    0x18020018 csrw mie, t0                   #; t0  = 0x00080008
            106000    0x1802001c wfi                            #; 
            325000    0x18020020 auipc t0, 0                    #; exception, goto 0x18020020
            338000    0x18020020 auipc t0, 0                    #; (wrb) t0  <-- 0x18020020
            353000    0x18020024 lui t1, 1                      #; (wrb) t1  <-- 4096
            366000    0x18020028 addi t1, t1, 360               #; t1  = 4096, (wrb) t1  <-- 4456
            379000    0x1802002c add t0, t0, t1                 #; t0  = 0x18020020, t1  = 4456, (wrb) t0  <-- 0x18021188
            392000    0x18020030 lw t0, 0(t0)                   #; t0  = 0x18021188, t0  <~~ Word[0x18021188]
            403000                                              #; (lsu) t0  <-- 0x80000000
            407000    0x18020034 jalr t0                        #; t0  = 0x80000000, (wrb) ra  <-- 0x18020038, goto 0x80000000
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
            481000    0x80000100 csrr a0, mhartid               #; mhartid = 1, (wrb) a0  <-- 1
                                                                #; (f:fpu) ft11 <-- 0.0
#; snrt.crt0.init_core_info (start.S:99)
#;   li   t0, SNRT_BASE_HARTID
            482000    0x80000104 li t0, 0                       #; (wrb) t0  <-- 0
#; snrt.crt0.init_core_info (start.S:100)
#;   sub  a0, a0, t0
            483000    0x80000108 sub a0, a0, t0                 #; a0  = 1, t0  = 0, (wrb) a0  <-- 1
#; snrt.crt0.init_core_info (start.S:101)
#;   li   a1, SNRT_CLUSTER_CORE_NUM
            484000    0x8000010c li a1, 9                       #; (wrb) a1  <-- 9
#; snrt.crt0.init_core_info (start.S:102)
#;   div  t0, a0, a1
            485000    0x80000110 div t0, a0, a1                 #; a0  = 1, a1  = 9
#; snrt.crt0.init_core_info (start.S:105)
#;   remu a0, a0, a1
            486000    0x80000114 remu a0, a0, a1                #; a0  = 1, a1  = 9
#; snrt.crt0.init_core_info (start.S:108)
#;   li   a2, SNRT_TCDM_START_ADDR
            487000    0x80000118 lui a2, 65536                  #; (wrb) a2  <-- 0x10000000
#; snrt.crt0.init_core_info (start.S:109)
#;   li   t1, SNRT_CLUSTER_OFFSET
            488000    0x8000011c li t1, 0                       #; (wrb) t1  <-- 0
            489000                                              #; (acc) t0  <-- 0
#; snrt.crt0.init_core_info (start.S:110)
#;   mul  t0, t1, t0
            490000    0x80000120 mul t0, t1, t0                 #; t1  = 0, t0  = 0, (acc) a0  <-- 1
            492000                                              #; (acc) t0  <-- 0
#; snrt.crt0.init_core_info (start.S:111)
#;   add  a2, a2, t0
            493000    0x80000124 add a2, a2, t0                 #; a2  = 0x10000000, t0  = 0, (wrb) a2  <-- 0x10000000
#; snrt.crt0.init_core_info (start.S:114)
#;   li   t0, SNRT_TCDM_SIZE
            494000    0x80000128 lui t0, 32                     #; (wrb) t0  <-- 0x00020000
#; snrt.crt0.init_core_info (start.S:115)
#;   add  a2, a2, t0
            495000    0x8000012c add a2, a2, t0                 #; a2  = 0x10000000, t0  = 0x00020000, (wrb) a2  <-- 0x10020000
#; .Lpcrel_hi0 (start.S:121)
#;   la        t0, __cdata_end
            496000    0x80000130 auipc t0, 6                    #; (wrb) t0  <-- 0x80006130
            497000    0x80000134 addi t0, t0, -600              #; t0  = 0x80006130, (wrb) t0  <-- 0x80005ed8
#; .Lpcrel_hi1 (start.S:122)
#;   la        t1, __cdata_start
            498000    0x80000138 auipc t1, 6                    #; (wrb) t1  <-- 0x80006138
            499000    0x8000013c addi t1, t1, -608              #; t1  = 0x80006138, (wrb) t1  <-- 0x80005ed8
#; .Lpcrel_hi1 (start.S:123)
#;   sub       t0, t0, t1
            500000    0x80000140 sub t0, t0, t1                 #; t0  = 0x80005ed8, t1  = 0x80005ed8, (wrb) t0  <-- 0
#; .Lpcrel_hi1 (start.S:124)
#;   sub       a2, a2, t0
            501000    0x80000144 sub a2, a2, t0                 #; a2  = 0x10020000, t0  = 0, (wrb) a2  <-- 0x10020000
#; .Lpcrel_hi2 (start.S:125)
#;   la        t0, __cbss_end
            502000    0x80000148 auipc t0, 6                    #; (wrb) t0  <-- 0x80006148
            503000    0x8000014c addi t0, t0, -592              #; t0  = 0x80006148, (wrb) t0  <-- 0x80005ef8
#; .Lpcrel_hi3 (start.S:126)
#;   la        t1, __cbss_start
            504000    0x80000150 auipc t1, 6                    #; (wrb) t1  <-- 0x80006150
            505000    0x80000154 addi t1, t1, -632              #; t1  = 0x80006150, (wrb) t1  <-- 0x80005ed8
#; .Lpcrel_hi3 (start.S:127)
#;   sub       t0, t0, t1
            506000    0x80000158 sub t0, t0, t1                 #; t0  = 0x80005ef8, t1  = 0x80005ed8, (wrb) t0  <-- 32
#; .Lpcrel_hi3 (start.S:128)
#;   sub       a2, a2, t0
            507000    0x8000015c sub a2, a2, t0                 #; a2  = 0x10020000, t0  = 32, (wrb) a2  <-- 0x1001ffe0
#; snrt.crt0.init_stack (start.S:135)
#;   addi      a2, a2, -8
            508000    0x80000160 addi a2, a2, -8                #; a2  = 0x1001ffe0, (wrb) a2  <-- 0x1001ffd8
#; snrt.crt0.init_stack (start.S:136)
#;   sw        zero, 0(a2)
            509000    0x80000164 sw zero, 0(a2)                 #; a2  = 0x1001ffd8, 0 ~~> Word[0x1001ffd8]
#; snrt.crt0.init_stack (start.S:140)
#;   sll       t0, a0, SNRT_LOG2_STACK_SIZE
            510000    0x80000168 slli t0, a0, 10                #; a0  = 1, (wrb) t0  <-- 1024
#; snrt.crt0.init_stack (start.S:143)
#;   sub       sp, a2, t0
            511000    0x8000016c sub sp, a2, t0                 #; a2  = 0x1001ffd8, t0  = 1024, (wrb) sp  <-- 0x1001fbd8
#; snrt.crt0.init_stack (start.S:146)
#;   slli      t0, a0, 3  # this hart
            512000    0x80000170 slli t0, a0, 3                 #; a0  = 1, (wrb) t0  <-- 8
#; snrt.crt0.init_stack (start.S:147)
#;   slli      t1, a1, 3  # all harts
            513000    0x80000174 slli t1, a1, 3                 #; a1  = 9, (wrb) t1  <-- 72
#; snrt.crt0.init_stack (start.S:148)
#;   sub       sp, sp, t0
            514000    0x80000178 sub sp, sp, t0                 #; sp  = 0x1001fbd8, t0  = 8, (wrb) sp  <-- 0x1001fbd0
#; snrt.crt0.init_stack (start.S:149)
#;   sub       a2, a2, t1
            515000    0x8000017c sub a2, a2, t1                 #; a2  = 0x1001ffd8, t1  = 72, (wrb) a2  <-- 0x1001ff90
#; .Lpcrel_hi4 (start.S:155)
#;   la        t0, __tdata_end
            516000    0x80000180 auipc t0, 6                    #; (wrb) t0  <-- 0x80006180
            517000    0x80000184 addi t0, t0, -748              #; t0  = 0x80006180, (wrb) t0  <-- 0x80005e94
#; .Lpcrel_hi5 (start.S:156)
#;   la        t1, __tdata_start
            518000    0x80000188 auipc t1, 6                    #; (wrb) t1  <-- 0x80006188
            519000    0x8000018c addi t1, t1, -768              #; t1  = 0x80006188, (wrb) t1  <-- 0x80005e88
#; .Lpcrel_hi5 (start.S:157)
#;   sub       t0, t0, t1
            520000    0x80000190 sub t0, t0, t1                 #; t0  = 0x80005e94, t1  = 0x80005e88, (wrb) t0  <-- 12
#; .Lpcrel_hi5 (start.S:158)
#;   sub       sp, sp, t0
            521000    0x80000194 sub sp, sp, t0                 #; sp  = 0x1001fbd0, t0  = 12, (wrb) sp  <-- 0x1001fbc4
#; .Lpcrel_hi6 (start.S:159)
#;   la        t0, __tbss_end
            522000    0x80000198 auipc t0, 6                    #; (wrb) t0  <-- 0x80006198
            523000    0x8000019c addi t0, t0, -704              #; t0  = 0x80006198, (wrb) t0  <-- 0x80005ed8
#; .Lpcrel_hi7 (start.S:160)
#;   la        t1, __tbss_start
            524000    0x800001a0 auipc t1, 6                    #; (wrb) t1  <-- 0x800061a0
            525000    0x800001a4 addi t1, t1, -776              #; t1  = 0x800061a0, (wrb) t1  <-- 0x80005e98
#; .Lpcrel_hi7 (start.S:161)
#;   sub       t0, t0, t1
            526000    0x800001a8 sub t0, t0, t1                 #; t0  = 0x80005ed8, t1  = 0x80005e98, (wrb) t0  <-- 64
#; .Lpcrel_hi7 (start.S:162)
#;   sub       sp, sp, t0
            527000    0x800001ac sub sp, sp, t0                 #; sp  = 0x1001fbc4, t0  = 64, (wrb) sp  <-- 0x1001fb84
#; .Lpcrel_hi7 (start.S:163)
#;   andi      sp, sp, ~0x7 # align to 8B
            528000    0x800001b0 andi sp, sp, -8                #; sp  = 0x1001fb84, (wrb) sp  <-- 0x1001fb80
#; .Lpcrel_hi7 (start.S:165)
#;   mv        tp, sp
            529000    0x800001b4 mv tp, sp                      #; sp  = 0x1001fb80, (wrb) tp  <-- 0x1001fb80
#; .Lpcrel_hi7 (start.S:167)
#;   andi      sp, sp, ~0x7 # align stack to 8B
            530000    0x800001b8 andi sp, sp, -8                #; sp  = 0x1001fb80, (wrb) sp  <-- 0x1001fb80
#; snrt.crt0.main (start.S:178)
#;   call snrt_main
            531000    0x800001bc auipc ra, 4                    #; (wrb) ra  <-- 0x800041bc
            532000    0x800001c0 jalr -1312(ra)                 #; ra  = 0x800041bc, (wrb) ra  <-- 0x800001c4, goto 0x80003c9c
#; snrt_main (start.c:204)
#;   EXTERN_C void snrt_main() {
            543000    0x80003c9c addi sp, sp, -64               #; sp  = 0x1001fb80, (wrb) sp  <-- 0x1001fb40
            544000    0x80003ca0 sw ra, 60(sp)                  #; sp  = 0x1001fb40, 0x800001c4 ~~> Word[0x1001fb7c]
            545000    0x80003ca4 sw s0, 56(sp)                  #; sp  = 0x1001fb40, 0 ~~> Word[0x1001fb78]
            546000    0x80003ca8 sw s1, 52(sp)                  #; sp  = 0x1001fb40, 0 ~~> Word[0x1001fb74]
            547000    0x80003cac sw s2, 48(sp)                  #; sp  = 0x1001fb40, 0 ~~> Word[0x1001fb70]
            548000    0x80003cb0 sw s3, 44(sp)                  #; sp  = 0x1001fb40, 0 ~~> Word[0x1001fb6c]
            549000    0x80003cb4 sw s4, 40(sp)                  #; sp  = 0x1001fb40, 0 ~~> Word[0x1001fb68]
            550000    0x80003cb8 sw s5, 36(sp)                  #; sp  = 0x1001fb40, 0 ~~> Word[0x1001fb64]
            551000    0x80003cbc sw s6, 32(sp)                  #; sp  = 0x1001fb40, 0 ~~> Word[0x1001fb60]
            556000    0x80003cc0 sw s7, 28(sp)                  #; sp  = 0x1001fb40, 0 ~~> Word[0x1001fb5c]
            557000    0x80003cc4 sw s8, 24(sp)                  #; sp  = 0x1001fb40, 0 ~~> Word[0x1001fb58]
            558000    0x80003cc8 sw s9, 20(sp)                  #; sp  = 0x1001fb40, 0 ~~> Word[0x1001fb54]
            559000    0x80003ccc sw s10, 16(sp)                 #; sp  = 0x1001fb40, 0 ~~> Word[0x1001fb50]
            560000    0x80003cd0 sw s11, 12(sp)                 #; sp  = 0x1001fb40, 0 ~~> Word[0x1001fb4c]
            561000    0x80003cd4 li s0, -1                      #; (wrb) s0  <-- -1
#; snrt_main (start.c:206:9)
#;   snrt_cluster_idx (team.h:99:12)
#;     snrt_global_core_idx (team.h:80:12)
#;       snrt_hartid (team.h:25:5)
#;         asm("csrr %0, mhartid" : "=r"(hartid));
#;         ^
            562000    0x80003cd8 csrr s2, mhartid               #; mhartid = 1, (wrb) s2  <-- 1
            563000    0x80003cdc lui a0, 233017                 #; (wrb) a0  <-- 0x38e39000
            564000    0x80003ce0 addi a0, a0, -455              #; a0  = 0x38e39000, (wrb) a0  <-- 0x38e38e39
#; snrt_main (start.c:206:9)
#;   snrt_cluster_idx (team.h:99:35)
#;     return snrt_global_core_idx() / snrt_cluster_core_num();
#;                                   ^
            565000    0x80003ce4 mulhu a0, s2, a0               #; s2  = 1, a0  = 0x38e38e39
            567000                                              #; (acc) a0  <-- 0
            568000    0x80003ce8 srli a0, a0, 1                 #; a0  = 0, (wrb) a0  <-- 0
            569000    0x80003cec li a1, 8                       #; (wrb) a1  <-- 8
            570000    0x80003cf0 slli s3, a0, 18                #; a0  = 0, (wrb) s3  <-- 0
#; snrt_main (start.c:206:9)
#;   if (snrt_cluster_idx() == 0) {
#;       ^
            571000    0x80003cf4 bltu a1, s2, 184               #; a1  = 8, s2  = 1, not taken
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:31)
#;       snrt_cluster_core_idx (team.h:108:35)
#;         return snrt_global_core_idx() % snrt_cluster_core_num();
#;                                       ^
            572000    0x80003cf8 p.extbz s1, s2                 #; s2  = 1
            573000    0x80003cfc li a1, 57                      #; (wrb) a1  <-- 57
            574000                                              #; (acc) s1  <-- 1
            575000    0x80003d00 mul a1, s1, a1                 #; s1  = 1, a1  = 57
            577000                                              #; (acc) a1  <-- 57
            578000    0x80003d04 srli a1, a1, 9                 #; a1  = 57, (wrb) a1  <-- 0
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
            599000                                              #; (lsu) a3  <-- 0
            600000    0x80003d20 ori a3, a2, 4                  #; a2  = 0x100211a8, (wrb) a3  <-- 0x100211ac
            601000    0x80003d24 lw a4, 0(a3)                   #; a3  = 0x100211ac, a4  <~~ Word[0x100211ac]
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:31)
#;       snrt_cluster_core_idx (team.h:108:35)
#;         return snrt_global_core_idx() % snrt_cluster_core_num();
#;                                       ^
            602000    0x80003d28 sub a1, s2, a1                 #; s2  = 1, a1  = 0, (wrb) a1  <-- 1
            603000    0x80003d2c li a5, 1                       #; (wrb) a5  <-- 1
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:28)
#;       snrt_int_cluster_clr(1 << snrt_cluster_core_idx());
#;                              ^
            604000    0x80003d30 sll a1, a5, a1                 #; a5  = 1, a1  = 1, (wrb) a1  <-- 2
            627000                                              #; (lsu) a4  <-- 0
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:5)
#;       snrt_int_cluster_clr (cluster_interrupts.h:22:68)
#;         snrt_cluster()->peripheral_reg.cl_clint_clear.f.cl_clint_clear = mask;
#;                                                                        ^
            628000    0x80003d34 and a4, a4, s0                 #; a4  = 0, s0  = -1, (wrb) a4  <-- 0
            629000    0x80003d38 sw a4, 0(a3)                   #; a3  = 0x100211ac, 0 ~~> Word[0x100211ac]
            630000    0x80003d3c sw a1, 0(a2)                   #; a2  = 0x100211a8, 2 ~~> Word[0x100211a8]
            631000    0x80003d40 lui a1, 128                    #; (wrb) a1  <-- 0x00080000
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
            680000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            681000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            682000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            683000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            684000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            685000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            686000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            687000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            688000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            689000    0x80003d44 csrr a2, mip                   #; mip = 0, (wrb) a2  <-- 0
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            690000    0x80003d48 and a2, a2, a1                 #; a2  = 0, a1  = 0x00080000, (wrb) a2  <-- 0
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            691000    0x80003d4c bnez a2, -8                    #; a2  = 0, not taken
            692000    0x80003d50 li a1, 9                       #; (wrb) a1  <-- 9
#; .LBB25_2 (start.c:215:5)
#;   snrt_init_bss (start.c:110:9)
#;     if (snrt_cluster_idx() == 0) {
#;         ^
            693000    0x80003d54 bgeu s2, a1, 88                #; s2  = 1, a1  = 9, not taken
#; .LBB25_21 (start.c:215:5)
#;   snrt_init_bss (start.c:112:9)
#;     memset((void*)&__bss_start, 0, size);
#;     ^
            694000    0x80003d58 auipc a0, 2                    #; (wrb) a0  <-- 0x80005d58
            695000    0x80003d5c addi a0, a0, 592               #; a0  = 0x80005d58, (wrb) a0  <-- 0x80005fa8
#; .LBB25_22 (start.c:215:5)
#;   snrt_init_bss (start.c:112:9)
#;     memset((void*)&__bss_start, 0, size);
#;     ^
            696000    0x80003d60 auipc a1, 2                    #; (wrb) a1  <-- 0x80005d60
            697000    0x80003d64 addi a1, a1, 1408              #; a1  = 0x80005d60, (wrb) a1  <-- 0x800062e0
            698000    0x80003d68 sub a2, a1, a0                 #; a1  = 0x800062e0, a0  = 0x80005fa8, (wrb) a2  <-- 824
            699000    0x80003d6c li a1, 0                       #; (wrb) a1  <-- 0
            700000    0x80003d70 auipc ra, 0                    #; (wrb) ra  <-- 0x80003d70
            701000    0x80003d74 jalr 1220(ra)                  #; ra  = 0x80003d70, (wrb) ra  <-- 0x80003d78, goto 0x80004234
#; memset (memset.S:30)
#;   li t1, 15
            707000    0x80004234 li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
            708000    0x80004238 mv a4, a0                      #; a0  = 0x80005fa8, (wrb) a4  <-- 0x80005fa8
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
            709000    0x8000423c bgeu t1, a2, 60                #; t1  = 15, a2  = 824, not taken
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
            772000    0x800042b0 sb a1, 5(a4)                   #; a4  = 0x80005fa8, 0 ~~> Byte[0x80005fad]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
            813000    0x800042b4 sb a1, 4(a4)                   #; a4  = 0x80005fa8, 0 ~~> Byte[0x80005fac]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
            862000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x80005fa8, 0 ~~> Byte[0x80005fab]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
            903000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x80005fa8, 0 ~~> Byte[0x80005faa]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
            952000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x80005fa8, 0 ~~> Byte[0x80005fa9]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
            993000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x80005fa8, 0 ~~> Byte[0x80005fa8]
#; .Ltable (memset.S:85)
#;   ret
            994000    0x800042c8 ret                            #; ra  = 0x800042f8, goto 0x800042f8
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
            995000    0x800042f8 mv ra, t0                      #; t0  = 0x80003d78, (wrb) ra  <-- 0x80003d78
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
            996000    0x800042fc addi a5, a5, -16               #; a5  = 8, (wrb) a5  <-- -8
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
            997000    0x80004300 sub a4, a4, a5                 #; a4  = 0x80005fa8, a5  = -8, (wrb) a4  <-- 0x80005fb0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
            998000    0x80004304 add a2, a2, a5                 #; a2  = 824, a5  = -8, (wrb) a2  <-- 816
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
            999000    0x80004308 bgeu t1, a2, -144              #; t1  = 15, a2  = 816, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           1000000    0x8000430c j -196                         #; goto 0x80004248
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           1001000    0x80004248 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           1002000    0x8000424c andi a3, a2, -16               #; a2  = 816, (wrb) a3  <-- 816
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           1003000    0x80004250 andi a2, a2, 15                #; a2  = 816, (wrb) a2  <-- 0
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           1004000    0x80004254 add a3, a3, a4                 #; a3  = 816, a4  = 0x80005fb0, (wrb) a3  <-- 0x800062e0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           1042000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80005fb0, 0 ~~> Word[0x80005fb0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           1083000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80005fb0, 0 ~~> Word[0x80005fb4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           1132000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80005fb0, 0 ~~> Word[0x80005fb8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           1173000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80005fb0, 0 ~~> Word[0x80005fbc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           1174000    0x80004268 addi a4, a4, 16                #; a4  = 0x80005fb0, (wrb) a4  <-- 0x80005fc0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           1175000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80005fc0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           1222000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80005fc0, 0 ~~> Word[0x80005fc0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           1263000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80005fc0, 0 ~~> Word[0x80005fc4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           1312000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80005fc0, 0 ~~> Word[0x80005fc8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           1353000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80005fc0, 0 ~~> Word[0x80005fcc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           1354000    0x80004268 addi a4, a4, 16                #; a4  = 0x80005fc0, (wrb) a4  <-- 0x80005fd0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           1355000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80005fd0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           1402000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80005fd0, 0 ~~> Word[0x80005fd0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           1443000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80005fd0, 0 ~~> Word[0x80005fd4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           1492000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80005fd0, 0 ~~> Word[0x80005fd8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           1533000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80005fd0, 0 ~~> Word[0x80005fdc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           1534000    0x80004268 addi a4, a4, 16                #; a4  = 0x80005fd0, (wrb) a4  <-- 0x80005fe0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           1535000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80005fe0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           1582000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80005fe0, 0 ~~> Word[0x80005fe0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           1623000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80005fe0, 0 ~~> Word[0x80005fe4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           1672000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80005fe0, 0 ~~> Word[0x80005fe8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           1713000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80005fe0, 0 ~~> Word[0x80005fec]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           1714000    0x80004268 addi a4, a4, 16                #; a4  = 0x80005fe0, (wrb) a4  <-- 0x80005ff0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           1715000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80005ff0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           1762000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80005ff0, 0 ~~> Word[0x80005ff0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           1803000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80005ff0, 0 ~~> Word[0x80005ff4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           1852000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80005ff0, 0 ~~> Word[0x80005ff8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           1893000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80005ff0, 0 ~~> Word[0x80005ffc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           1894000    0x80004268 addi a4, a4, 16                #; a4  = 0x80005ff0, (wrb) a4  <-- 0x80006000
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           1895000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006000, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           1942000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006000, 0 ~~> Word[0x80006000]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           1983000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006000, 0 ~~> Word[0x80006004]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2032000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006000, 0 ~~> Word[0x80006008]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2073000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006000, 0 ~~> Word[0x8000600c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2074000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006000, (wrb) a4  <-- 0x80006010
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2075000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006010, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2122000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006010, 0 ~~> Word[0x80006010]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2163000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006010, 0 ~~> Word[0x80006014]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2212000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006010, 0 ~~> Word[0x80006018]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2253000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006010, 0 ~~> Word[0x8000601c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2254000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006010, (wrb) a4  <-- 0x80006020
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2255000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006020, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2302000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006020, 0 ~~> Word[0x80006020]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2343000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006020, 0 ~~> Word[0x80006024]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2392000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006020, 0 ~~> Word[0x80006028]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2433000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006020, 0 ~~> Word[0x8000602c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2434000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006020, (wrb) a4  <-- 0x80006030
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2435000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006030, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2482000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006030, 0 ~~> Word[0x80006030]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2523000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006030, 0 ~~> Word[0x80006034]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2572000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006030, 0 ~~> Word[0x80006038]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2613000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006030, 0 ~~> Word[0x8000603c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2614000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006030, (wrb) a4  <-- 0x80006040
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2615000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006040, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2662000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006040, 0 ~~> Word[0x80006040]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2703000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006040, 0 ~~> Word[0x80006044]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2752000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006040, 0 ~~> Word[0x80006048]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2793000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006040, 0 ~~> Word[0x8000604c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2794000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006040, (wrb) a4  <-- 0x80006050
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2795000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006050, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2842000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006050, 0 ~~> Word[0x80006050]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2883000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006050, 0 ~~> Word[0x80006054]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2932000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006050, 0 ~~> Word[0x80006058]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2973000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006050, 0 ~~> Word[0x8000605c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2974000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006050, (wrb) a4  <-- 0x80006060
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2975000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006060, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           3022000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006060, 0 ~~> Word[0x80006060]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           3063000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006060, 0 ~~> Word[0x80006064]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           3112000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006060, 0 ~~> Word[0x80006068]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           3153000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006060, 0 ~~> Word[0x8000606c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           3154000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006060, (wrb) a4  <-- 0x80006070
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           3155000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006070, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           3202000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006070, 0 ~~> Word[0x80006070]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           3243000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006070, 0 ~~> Word[0x80006074]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           3292000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006070, 0 ~~> Word[0x80006078]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           3333000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006070, 0 ~~> Word[0x8000607c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           3334000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006070, (wrb) a4  <-- 0x80006080
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           3335000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006080, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           3382000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006080, 0 ~~> Word[0x80006080]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           3423000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006080, 0 ~~> Word[0x80006084]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           3472000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006080, 0 ~~> Word[0x80006088]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           3513000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006080, 0 ~~> Word[0x8000608c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           3514000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006080, (wrb) a4  <-- 0x80006090
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           3515000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006090, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           3562000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006090, 0 ~~> Word[0x80006090]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           3603000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006090, 0 ~~> Word[0x80006094]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           3652000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006090, 0 ~~> Word[0x80006098]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           3693000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006090, 0 ~~> Word[0x8000609c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           3694000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006090, (wrb) a4  <-- 0x800060a0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           3695000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800060a0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           3742000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800060a0, 0 ~~> Word[0x800060a0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           3783000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800060a0, 0 ~~> Word[0x800060a4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           3832000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800060a0, 0 ~~> Word[0x800060a8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           3873000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800060a0, 0 ~~> Word[0x800060ac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           3874000    0x80004268 addi a4, a4, 16                #; a4  = 0x800060a0, (wrb) a4  <-- 0x800060b0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           3875000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800060b0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           3922000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800060b0, 0 ~~> Word[0x800060b0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           3963000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800060b0, 0 ~~> Word[0x800060b4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           4012000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800060b0, 0 ~~> Word[0x800060b8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           4053000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800060b0, 0 ~~> Word[0x800060bc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           4054000    0x80004268 addi a4, a4, 16                #; a4  = 0x800060b0, (wrb) a4  <-- 0x800060c0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           4055000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800060c0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           4102000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800060c0, 0 ~~> Word[0x800060c0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           4143000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800060c0, 0 ~~> Word[0x800060c4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           4192000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800060c0, 0 ~~> Word[0x800060c8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           4233000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800060c0, 0 ~~> Word[0x800060cc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           4234000    0x80004268 addi a4, a4, 16                #; a4  = 0x800060c0, (wrb) a4  <-- 0x800060d0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           4235000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800060d0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           4282000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800060d0, 0 ~~> Word[0x800060d0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           4323000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800060d0, 0 ~~> Word[0x800060d4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           4372000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800060d0, 0 ~~> Word[0x800060d8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           4413000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800060d0, 0 ~~> Word[0x800060dc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           4414000    0x80004268 addi a4, a4, 16                #; a4  = 0x800060d0, (wrb) a4  <-- 0x800060e0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           4415000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800060e0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           4462000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800060e0, 0 ~~> Word[0x800060e0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           4503000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800060e0, 0 ~~> Word[0x800060e4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           4552000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800060e0, 0 ~~> Word[0x800060e8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           4593000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800060e0, 0 ~~> Word[0x800060ec]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           4594000    0x80004268 addi a4, a4, 16                #; a4  = 0x800060e0, (wrb) a4  <-- 0x800060f0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           4595000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800060f0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           4642000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800060f0, 0 ~~> Word[0x800060f0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           4683000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800060f0, 0 ~~> Word[0x800060f4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           4732000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800060f0, 0 ~~> Word[0x800060f8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           4773000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800060f0, 0 ~~> Word[0x800060fc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           4774000    0x80004268 addi a4, a4, 16                #; a4  = 0x800060f0, (wrb) a4  <-- 0x80006100
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           4775000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006100, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           4822000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006100, 0 ~~> Word[0x80006100]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           4863000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006100, 0 ~~> Word[0x80006104]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           4912000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006100, 0 ~~> Word[0x80006108]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           4953000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006100, 0 ~~> Word[0x8000610c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           4954000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006100, (wrb) a4  <-- 0x80006110
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           4955000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006110, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           5002000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006110, 0 ~~> Word[0x80006110]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           5043000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006110, 0 ~~> Word[0x80006114]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           5092000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006110, 0 ~~> Word[0x80006118]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           5133000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006110, 0 ~~> Word[0x8000611c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           5134000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006110, (wrb) a4  <-- 0x80006120
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           5135000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006120, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           5182000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006120, 0 ~~> Word[0x80006120]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           5223000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006120, 0 ~~> Word[0x80006124]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           5272000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006120, 0 ~~> Word[0x80006128]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           5313000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006120, 0 ~~> Word[0x8000612c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           5314000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006120, (wrb) a4  <-- 0x80006130
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           5315000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006130, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           5362000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006130, 0 ~~> Word[0x80006130]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           5403000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006130, 0 ~~> Word[0x80006134]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           5452000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006130, 0 ~~> Word[0x80006138]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           5493000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006130, 0 ~~> Word[0x8000613c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           5494000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006130, (wrb) a4  <-- 0x80006140
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           5495000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006140, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           5542000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006140, 0 ~~> Word[0x80006140]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           5583000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006140, 0 ~~> Word[0x80006144]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           5632000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006140, 0 ~~> Word[0x80006148]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           5673000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006140, 0 ~~> Word[0x8000614c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           5674000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006140, (wrb) a4  <-- 0x80006150
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           5675000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006150, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           5722000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006150, 0 ~~> Word[0x80006150]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           5763000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006150, 0 ~~> Word[0x80006154]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           5812000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006150, 0 ~~> Word[0x80006158]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           5853000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006150, 0 ~~> Word[0x8000615c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           5854000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006150, (wrb) a4  <-- 0x80006160
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           5855000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006160, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           5902000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006160, 0 ~~> Word[0x80006160]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           5943000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006160, 0 ~~> Word[0x80006164]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           5992000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006160, 0 ~~> Word[0x80006168]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6033000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006160, 0 ~~> Word[0x8000616c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6034000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006160, (wrb) a4  <-- 0x80006170
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6035000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006170, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6082000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006170, 0 ~~> Word[0x80006170]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           6123000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006170, 0 ~~> Word[0x80006174]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           6172000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006170, 0 ~~> Word[0x80006178]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6213000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006170, 0 ~~> Word[0x8000617c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6214000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006170, (wrb) a4  <-- 0x80006180
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6215000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006180, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6262000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006180, 0 ~~> Word[0x80006180]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           6303000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006180, 0 ~~> Word[0x80006184]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           6352000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006180, 0 ~~> Word[0x80006188]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6393000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006180, 0 ~~> Word[0x8000618c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6394000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006180, (wrb) a4  <-- 0x80006190
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6395000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006190, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6442000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006190, 0 ~~> Word[0x80006190]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           6483000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006190, 0 ~~> Word[0x80006194]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           6532000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006190, 0 ~~> Word[0x80006198]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6573000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006190, 0 ~~> Word[0x8000619c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6574000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006190, (wrb) a4  <-- 0x800061a0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6575000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800061a0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6622000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800061a0, 0 ~~> Word[0x800061a0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           6663000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800061a0, 0 ~~> Word[0x800061a4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           6712000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800061a0, 0 ~~> Word[0x800061a8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6753000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800061a0, 0 ~~> Word[0x800061ac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6754000    0x80004268 addi a4, a4, 16                #; a4  = 0x800061a0, (wrb) a4  <-- 0x800061b0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6755000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800061b0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6802000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800061b0, 0 ~~> Word[0x800061b0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           6843000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800061b0, 0 ~~> Word[0x800061b4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           6892000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800061b0, 0 ~~> Word[0x800061b8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6933000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800061b0, 0 ~~> Word[0x800061bc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6934000    0x80004268 addi a4, a4, 16                #; a4  = 0x800061b0, (wrb) a4  <-- 0x800061c0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6935000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800061c0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6982000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800061c0, 0 ~~> Word[0x800061c0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           7023000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800061c0, 0 ~~> Word[0x800061c4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           7072000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800061c0, 0 ~~> Word[0x800061c8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           7113000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800061c0, 0 ~~> Word[0x800061cc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           7114000    0x80004268 addi a4, a4, 16                #; a4  = 0x800061c0, (wrb) a4  <-- 0x800061d0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           7115000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800061d0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           7162000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800061d0, 0 ~~> Word[0x800061d0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           7203000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800061d0, 0 ~~> Word[0x800061d4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           7252000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800061d0, 0 ~~> Word[0x800061d8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           7293000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800061d0, 0 ~~> Word[0x800061dc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           7294000    0x80004268 addi a4, a4, 16                #; a4  = 0x800061d0, (wrb) a4  <-- 0x800061e0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           7295000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800061e0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           7342000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800061e0, 0 ~~> Word[0x800061e0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           7383000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800061e0, 0 ~~> Word[0x800061e4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           7432000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800061e0, 0 ~~> Word[0x800061e8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           7473000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800061e0, 0 ~~> Word[0x800061ec]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           7474000    0x80004268 addi a4, a4, 16                #; a4  = 0x800061e0, (wrb) a4  <-- 0x800061f0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           7475000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800061f0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           7522000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800061f0, 0 ~~> Word[0x800061f0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           7563000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800061f0, 0 ~~> Word[0x800061f4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           7612000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800061f0, 0 ~~> Word[0x800061f8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           7653000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800061f0, 0 ~~> Word[0x800061fc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           7654000    0x80004268 addi a4, a4, 16                #; a4  = 0x800061f0, (wrb) a4  <-- 0x80006200
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           7655000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006200, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           7702000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006200, 0 ~~> Word[0x80006200]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           7743000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006200, 0 ~~> Word[0x80006204]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           7792000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006200, 0 ~~> Word[0x80006208]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           7833000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006200, 0 ~~> Word[0x8000620c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           7834000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006200, (wrb) a4  <-- 0x80006210
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           7835000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006210, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           7882000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006210, 0 ~~> Word[0x80006210]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           7923000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006210, 0 ~~> Word[0x80006214]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           7972000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006210, 0 ~~> Word[0x80006218]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           8013000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006210, 0 ~~> Word[0x8000621c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           8014000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006210, (wrb) a4  <-- 0x80006220
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           8015000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006220, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           8062000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006220, 0 ~~> Word[0x80006220]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           8103000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006220, 0 ~~> Word[0x80006224]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           8152000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006220, 0 ~~> Word[0x80006228]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           8193000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006220, 0 ~~> Word[0x8000622c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           8194000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006220, (wrb) a4  <-- 0x80006230
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           8195000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006230, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           8242000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006230, 0 ~~> Word[0x80006230]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           8283000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006230, 0 ~~> Word[0x80006234]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           8332000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006230, 0 ~~> Word[0x80006238]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           8373000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006230, 0 ~~> Word[0x8000623c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           8374000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006230, (wrb) a4  <-- 0x80006240
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           8375000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006240, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           8422000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006240, 0 ~~> Word[0x80006240]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           8463000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006240, 0 ~~> Word[0x80006244]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           8512000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006240, 0 ~~> Word[0x80006248]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           8553000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006240, 0 ~~> Word[0x8000624c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           8554000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006240, (wrb) a4  <-- 0x80006250
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           8555000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006250, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           8602000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006250, 0 ~~> Word[0x80006250]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           8643000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006250, 0 ~~> Word[0x80006254]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           8692000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006250, 0 ~~> Word[0x80006258]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           8733000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006250, 0 ~~> Word[0x8000625c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           8734000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006250, (wrb) a4  <-- 0x80006260
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           8735000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006260, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           8782000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006260, 0 ~~> Word[0x80006260]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           8823000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006260, 0 ~~> Word[0x80006264]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           8872000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006260, 0 ~~> Word[0x80006268]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           8913000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006260, 0 ~~> Word[0x8000626c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           8914000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006260, (wrb) a4  <-- 0x80006270
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           8915000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006270, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           8962000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006270, 0 ~~> Word[0x80006270]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           9003000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006270, 0 ~~> Word[0x80006274]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           9052000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006270, 0 ~~> Word[0x80006278]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           9093000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006270, 0 ~~> Word[0x8000627c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           9094000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006270, (wrb) a4  <-- 0x80006280
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           9095000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006280, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           9142000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006280, 0 ~~> Word[0x80006280]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           9183000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006280, 0 ~~> Word[0x80006284]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           9232000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006280, 0 ~~> Word[0x80006288]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           9273000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006280, 0 ~~> Word[0x8000628c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           9274000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006280, (wrb) a4  <-- 0x80006290
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           9275000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006290, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           9322000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006290, 0 ~~> Word[0x80006290]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           9363000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006290, 0 ~~> Word[0x80006294]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           9412000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006290, 0 ~~> Word[0x80006298]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           9453000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006290, 0 ~~> Word[0x8000629c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           9454000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006290, (wrb) a4  <-- 0x800062a0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           9455000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800062a0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           9502000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800062a0, 0 ~~> Word[0x800062a0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           9543000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800062a0, 0 ~~> Word[0x800062a4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           9592000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800062a0, 0 ~~> Word[0x800062a8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           9633000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800062a0, 0 ~~> Word[0x800062ac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           9634000    0x80004268 addi a4, a4, 16                #; a4  = 0x800062a0, (wrb) a4  <-- 0x800062b0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           9635000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800062b0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           9682000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800062b0, 0 ~~> Word[0x800062b0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           9723000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800062b0, 0 ~~> Word[0x800062b4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           9772000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800062b0, 0 ~~> Word[0x800062b8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           9813000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800062b0, 0 ~~> Word[0x800062bc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           9814000    0x80004268 addi a4, a4, 16                #; a4  = 0x800062b0, (wrb) a4  <-- 0x800062c0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           9815000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800062c0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           9862000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800062c0, 0 ~~> Word[0x800062c0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           9903000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800062c0, 0 ~~> Word[0x800062c4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           9952000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800062c0, 0 ~~> Word[0x800062c8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           9993000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800062c0, 0 ~~> Word[0x800062cc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           9994000    0x80004268 addi a4, a4, 16                #; a4  = 0x800062c0, (wrb) a4  <-- 0x800062d0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           9995000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800062d0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          10042000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800062d0, 0 ~~> Word[0x800062d0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          10083000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800062d0, 0 ~~> Word[0x800062d4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          10132000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800062d0, 0 ~~> Word[0x800062d8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          10173000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800062d0, 0 ~~> Word[0x800062dc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          10174000    0x80004268 addi a4, a4, 16                #; a4  = 0x800062d0, (wrb) a4  <-- 0x800062e0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          10175000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800062e0, a3  = 0x800062e0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
          10176000    0x80004270 bnez a2, 8                     #; a2  = 0, not taken
#; .Ltmp0 (memset.S:57)
#;   ret
          10177000    0x80004274 ret                            #; ra  = 0x80003d78, goto 0x80003d78
#; .LBB25_22 (start.c:215:5)
#;   snrt_init_bss (start.c:115:9)
#;     snrt_cluster_hw_barrier (sync.h:174:5)
#;       asm volatile("csrr x0, 0x7C2" ::: "memory");
#;       ^
          10178000    0x80003d78 csrr zero, 1986                #; csr@7c2 = 0
          10209000    0x80003d7c li a0, 57                      #; (wrb) a0  <-- 57
          10210000    0x80003d80 mul a0, s1, a0                 #; s1  = 1, a0  = 57
          10212000                                              #; (acc) a0  <-- 57
          10213000    0x80003d84 srli a0, a0, 9                 #; a0  = 57, (wrb) a0  <-- 0
          10214000    0x80003d88 slli a1, a0, 3                 #; a0  = 0, (wrb) a1  <-- 0
          10215000    0x80003d8c add a0, a1, a0                 #; a1  = 0, a0  = 0, (wrb) a0  <-- 0
          10216000    0x80003d90 sub a0, s2, a0                 #; s2  = 1, a0  = 0, (wrb) a0  <-- 1
          10217000    0x80003d94 p.extbz s5, a0                 #; a0  = 1
          10218000    0x80003d98 li s4, 0                       #; (wrb) s4  <-- 0
          10219000                                              #; (acc) s5  <-- 1
#; .LBB25_22 (start.c:219:5)
#;   snrt_wake_up (start.c:124:33)
#;     if (snrt_cluster_idx() == 0 && snrt_cluster_core_idx() == 0) {
#;                                 ^
          10220000    0x80003d9c bnez s5, 32                    #; s5  = 1, taken, goto 0x80003dbc
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
          10305000                                              #; (lsu) a1  <-- 0
          10306000    0x80003dd0 ori a1, a0, 4                  #; a0  = 0x100211a8, (wrb) a1  <-- 0x100211ac
          10307000    0x80003dd4 lw a2, 0(a1)                   #; a1  = 0x100211ac, a2  <~~ Word[0x100211ac]
          10308000    0x80003dd8 li a3, 1                       #; (wrb) a3  <-- 1
#; .LBB25_7 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;       snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:28)
#;         snrt_int_cluster_clr(1 << snrt_cluster_core_idx());
#;                                ^
          10309000    0x80003ddc sll a3, a3, s5                 #; a3  = 1, s5  = 1, (wrb) a3  <-- 2
          10333000                                              #; (lsu) a2  <-- 0
#; .LBB25_7 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;       snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:5)
#;         snrt_int_cluster_clr (cluster_interrupts.h:22:68)
#;           snrt_cluster()->peripheral_reg.cl_clint_clear.f.cl_clint_clear = mask;
#;                                                                          ^
          10334000    0x80003de0 and a2, a2, s0                 #; a2  = 0, s0  = -1, (wrb) a2  <-- 0
          10335000    0x80003de4 sw a3, 0(a0)                   #; a0  = 0x100211a8, 2 ~~> Word[0x100211a8]
          10336000    0x80003de8 sw a2, 0(a1)                   #; a1  = 0x100211ac, 0 ~~> Word[0x100211ac]
          10337000    0x80003dec lui a0, 128                    #; (wrb) a0  <-- 0x00080000
#; .LBB25_8 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;       snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;         while (read_csr(mip) & MIP_MCIP)
#;                ^
          10338000    0x80003df0 csrr a1, mip                   #; mip = 0, (wrb) a1  <-- 0
#; .LBB25_8 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;       snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;         while (read_csr(mip) & MIP_MCIP)
#;                              ^
          10339000    0x80003df4 and a1, a1, a0                 #; a1  = 0, a0  = 0x00080000, (wrb) a1  <-- 0
#; .LBB25_8 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;       snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;         while (read_csr(mip) & MIP_MCIP)
#;         ^
          10340000    0x80003df8 bnez a1, -8                    #; a1  = 0, not taken
#; .LBB25_8 (start.c:227:5)
#;   snrt_init_tls (start.c:66:5)
#;     asm volatile("mv %0, tp" : "=r"(tls_ptr) : :);
#;     ^
          10341000    0x80003dfc mv a0, tp                      #; tp  = 0x1001fb80, (wrb) a0  <-- 0x1001fb80
          10356000    0x80003e00 sw a0, 8(sp)                   #; sp  = 0x1001fb40, 0x1001fb80 ~~> Word[0x1001fb48]
#; .LBB25_8 (start.c:227:5)
#;   snrt_init_tls (start.c:67:19)
#;     memcpy((void*)tls_ptr, (const void*)&__tdata_start, size);
#;                   ^
          10389000    0x80003e04 lw a0, 8(sp)                   #; sp  = 0x1001fb40, a0  <~~ Word[0x1001fb48]
#; .LBB25_23 (start.c:227:5)
#;   snrt_init_tls (start.c:67:5)
#;     memcpy((void*)tls_ptr, (const void*)&__tdata_start, size);
#;     ^
          10390000    0x80003e08 auipc a1, 2                    #; (wrb) a1  <-- 0x80005e08
          10391000    0x80003e0c addi a1, a1, 128               #; a1  = 0x80005e08, (wrb) a1  <-- 0x80005e88
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:67:5)
#;     memcpy((void*)tls_ptr, (const void*)&__tdata_start, size);
#;     ^
          10392000    0x80003e10 auipc a2, 2                    #; (wrb) a2  <-- 0x80005e10
          10393000    0x80003e14 addi a2, a2, 132               #; a2  = 0x80005e10, (wrb) a2  <-- 0x80005e94
          10394000    0x80003e18 sub s0, a2, a1                 #; a2  = 0x80005e94, a1  = 0x80005e88, (wrb) s0  <-- 12
          10395000    0x80003e1c mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
          10396000    0x80003e20 auipc ra, 0                    #; (wrb) ra  <-- 0x80003e20
          10397000    0x80003e24 jalr 1264(ra)                  #; ra  = 0x80003e20, (wrb) ra  <-- 0x80003e28, goto 0x80004310
#; memcpy (memcpy.c:25)
#;   {
          10398000    0x80004310 addi sp, sp, -16               #; sp  = 0x1001fb40, (wrb) sp  <-- 0x1001fb30
          10399000    0x80004314 sw s0, 12(sp)                  #; sp  = 0x1001fb30, 12 ~~> Word[0x1001fb3c], (lsu) a0  <-- 0x1001fb80
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10400000    0x80004318 andi a3, a0, 3                 #; a0  = 0x1001fb80, (wrb) a3  <-- 0
          10401000    0x8000431c andi a4, a1, 3                 #; a1  = 0x80005e88, (wrb) a4  <-- 0
          10402000    0x80004320 xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
          10403000    0x80004324 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
          10404000    0x80004328 li a5, 3                       #; (wrb) a5  <-- 3
          10405000    0x8000432c sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
          10406000    0x80004330 and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
          10407000    0x80004334 add a2, a0, a2                 #; a0  = 0x1001fb80, a2  = 12, (wrb) a2  <-- 0x1001fb8c
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10408000    0x80004338 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
          10409000    0x8000433c bnez a3, 116                   #; a3  = 0, not taken
          10410000    0x80004340 mv a4, a0                      #; a0  = 0x1001fb80, (wrb) a4  <-- 0x1001fb80
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
          10411000    0x80004344 andi a3, a2, -4                #; a2  = 0x1001fb8c, (wrb) a3  <-- 0x1001fb8c
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
          10412000    0x80004348 sub a5, a3, a4                 #; a3  = 0x1001fb8c, a4  = 0x1001fb80, (wrb) a5  <-- 12
          10413000    0x8000434c li a6, 33                      #; (wrb) a6  <-- 33
          10414000    0x80004350 bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10415000    0x80004354 bgeu a4, a3, 32                #; a4  = 0x1001fb80, a3  = 0x1001fb8c, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10416000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x80005e88, a6  <~~ Word[0x80005e88]
          10417000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001fb80, (wrb) a5  <-- 0x1001fb84
          10418000    0x80004360 addi a1, a1, 4                 #; a1  = 0x80005e88, (wrb) a1  <-- 0x80005e8c
          10429000                                              #; (lsu) a6  <-- 0x80005fc0
          10430000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001fb80, 0x80005fc0 ~~> Word[0x1001fb80]
          10431000    0x80004368 mv a4, a5                      #; a5  = 0x1001fb84, (wrb) a4  <-- 0x1001fb84
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10432000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001fb84, a3  = 0x1001fb8c, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10433000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x80005e8c, a6  <~~ Word[0x80005e8c]
          10434000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001fb84, (wrb) a5  <-- 0x1001fb88
          10435000    0x80004360 addi a1, a1, 4                 #; a1  = 0x80005e8c, (wrb) a1  <-- 0x80005e90
          10473000                                              #; (lsu) a6  <-- 1
          10474000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001fb84, 1 ~~> Word[0x1001fb84]
          10475000    0x80004368 mv a4, a5                      #; a5  = 0x1001fb88, (wrb) a4  <-- 0x1001fb88
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10476000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001fb88, a3  = 0x1001fb8c, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10477000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x80005e90, a6  <~~ Word[0x80005e90]
          10478000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001fb88, (wrb) a5  <-- 0x1001fb8c
          10479000    0x80004360 addi a1, a1, 4                 #; a1  = 0x80005e90, (wrb) a1  <-- 0x80005e94
          10510000                                              #; (lsu) a6  <-- 1
          10511000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001fb88, 1 ~~> Word[0x1001fb88]
          10512000    0x80004368 mv a4, a5                      #; a5  = 0x1001fb8c, (wrb) a4  <-- 0x1001fb8c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10513000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001fb8c, a3  = 0x1001fb8c, not taken
          10514000    0x80004370 j 8                            #; goto 0x80004378
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
          10515000    0x80004378 bltu a5, a2, 20                #; a5  = 0x1001fb8c, a2  = 0x1001fb8c, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
          10516000    0x8000437c lw s0, 12(sp)                  #; sp  = 0x1001fb30, s0  <~~ Word[0x1001fb3c]
          10519000    0x80004380 addi sp, sp, 16                #; sp  = 0x1001fb30, (wrb) sp  <-- 0x1001fb40
          10520000    0x80004384 ret                            #; ra  = 0x80003e28, (lsu) s0  <-- 12, goto 0x80003e28
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
          10521000    0x80003e28 lw a0, 8(sp)                   #; sp  = 0x1001fb40, a0  <~~ Word[0x1001fb48]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
          10522000    0x80003e2c lw a1, 8(sp)                   #; sp  = 0x1001fb40, a1  <~~ Word[0x1001fb48]
          10524000                                              #; (lsu) a0  <-- 0x1001fb80
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
          10525000    0x80003e30 addi a0, a0, 1032              #; a0  = 0x1001fb80, (wrb) a0  <-- 0x1001ff88
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
          10526000    0x80003e34 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
          10527000    0x80003e38 auipc ra, 0                    #; (wrb) ra  <-- 0x80003e38
          10528000    0x80003e3c jalr 1240(ra)                  #; ra  = 0x80003e38, (wrb) ra  <-- 0x80003e40, goto 0x80004310
#; memcpy (memcpy.c:25)
#;   {
          10529000    0x80004310 addi sp, sp, -16               #; sp  = 0x1001fb40, (wrb) sp  <-- 0x1001fb30
          10530000    0x80004314 sw s0, 12(sp)                  #; sp  = 0x1001fb30, 12 ~~> Word[0x1001fb3c], (lsu) a1  <-- 0x1001fb80
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10531000    0x80004318 andi a3, a0, 3                 #; a0  = 0x1001ff88, (wrb) a3  <-- 0
          10532000    0x8000431c andi a4, a1, 3                 #; a1  = 0x1001fb80, (wrb) a4  <-- 0
          10533000    0x80004320 xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
          10534000    0x80004324 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
          10535000    0x80004328 li a5, 3                       #; (wrb) a5  <-- 3
          10536000    0x8000432c sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
          10537000    0x80004330 and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
          10538000    0x80004334 add a2, a0, a2                 #; a0  = 0x1001ff88, a2  = 12, (wrb) a2  <-- 0x1001ff94
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10539000    0x80004338 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
          10540000    0x8000433c bnez a3, 116                   #; a3  = 0, not taken
          10541000    0x80004340 mv a4, a0                      #; a0  = 0x1001ff88, (wrb) a4  <-- 0x1001ff88
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
          10542000    0x80004344 andi a3, a2, -4                #; a2  = 0x1001ff94, (wrb) a3  <-- 0x1001ff94
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
          10543000    0x80004348 sub a5, a3, a4                 #; a3  = 0x1001ff94, a4  = 0x1001ff88, (wrb) a5  <-- 12
          10544000    0x8000434c li a6, 33                      #; (wrb) a6  <-- 33
          10545000    0x80004350 bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10546000    0x80004354 bgeu a4, a3, 32                #; a4  = 0x1001ff88, a3  = 0x1001ff94, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10547000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001fb80, a6  <~~ Word[0x1001fb80]
          10548000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001ff88, (wrb) a5  <-- 0x1001ff8c
          10549000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001fb80, (wrb) a1  <-- 0x1001fb84
          10550000                                              #; (lsu) a6  <-- 0x80005fc0
          10551000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001ff88, 0x80005fc0 ~~> Word[0x1001ff88]
          10552000    0x80004368 mv a4, a5                      #; a5  = 0x1001ff8c, (wrb) a4  <-- 0x1001ff8c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10553000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001ff8c, a3  = 0x1001ff94, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10554000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001fb84, a6  <~~ Word[0x1001fb84]
          10555000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001ff8c, (wrb) a5  <-- 0x1001ff90
          10556000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001fb84, (wrb) a1  <-- 0x1001fb88
          10557000                                              #; (lsu) a6  <-- 1
          10558000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001ff8c, 1 ~~> Word[0x1001ff8c]
          10559000    0x80004368 mv a4, a5                      #; a5  = 0x1001ff90, (wrb) a4  <-- 0x1001ff90
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10560000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001ff90, a3  = 0x1001ff94, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10561000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001fb88, a6  <~~ Word[0x1001fb88]
          10562000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001ff90, (wrb) a5  <-- 0x1001ff94
          10563000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001fb88, (wrb) a1  <-- 0x1001fb8c
          10564000                                              #; (lsu) a6  <-- 1
          10565000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001ff90, 1 ~~> Word[0x1001ff90]
          10566000    0x80004368 mv a4, a5                      #; a5  = 0x1001ff94, (wrb) a4  <-- 0x1001ff94
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10567000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001ff94, a3  = 0x1001ff94, not taken
          10568000    0x80004370 j 8                            #; goto 0x80004378
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
          10569000    0x80004378 bltu a5, a2, 20                #; a5  = 0x1001ff94, a2  = 0x1001ff94, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
          10570000    0x8000437c lw s0, 12(sp)                  #; sp  = 0x1001fb30, s0  <~~ Word[0x1001fb3c]
          10571000    0x80004380 addi sp, sp, 16                #; sp  = 0x1001fb30, (wrb) sp  <-- 0x1001fb40
          10572000    0x80004384 ret                            #; ra  = 0x80003e40, goto 0x80003e40
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
          10573000    0x80003e40 lw a0, 8(sp)                   #; sp  = 0x1001fb40, a0  <~~ Word[0x1001fb48], (lsu) s0  <-- 12
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
          10574000    0x80003e44 lw a1, 8(sp)                   #; sp  = 0x1001fb40, a1  <~~ Word[0x1001fb48]
          10575000    0x80003e48 lui s7, 1                      #; (wrb) s7  <-- 4096
          10576000    0x80003e4c addi s1, s7, -2032             #; s7  = 4096, (wrb) s1  <-- 2064
          10577000                                              #; (lsu) a0  <-- 0x1001fb80
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
          10578000    0x80003e50 add a0, a0, s1                 #; a0  = 0x1001fb80, s1  = 2064, (wrb) a0  <-- 0x10020390
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
          10579000    0x80003e54 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
          10580000    0x80003e58 auipc ra, 0                    #; (wrb) ra  <-- 0x80003e58
          10581000    0x80003e5c jalr 1208(ra)                  #; ra  = 0x80003e58, (wrb) ra  <-- 0x80003e60, goto 0x80004310
#; memcpy (memcpy.c:25)
#;   {
          10582000    0x80004310 addi sp, sp, -16               #; sp  = 0x1001fb40, (wrb) sp  <-- 0x1001fb30
          10583000    0x80004314 sw s0, 12(sp)                  #; sp  = 0x1001fb30, 12 ~~> Word[0x1001fb3c], (lsu) a1  <-- 0x1001fb80
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10584000    0x80004318 andi a3, a0, 3                 #; a0  = 0x10020390, (wrb) a3  <-- 0
          10585000    0x8000431c andi a4, a1, 3                 #; a1  = 0x1001fb80, (wrb) a4  <-- 0
          10586000    0x80004320 xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
          10587000    0x80004324 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
          10588000    0x80004328 li a5, 3                       #; (wrb) a5  <-- 3
          10589000    0x8000432c sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
          10590000    0x80004330 and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
          10591000    0x80004334 add a2, a0, a2                 #; a0  = 0x10020390, a2  = 12, (wrb) a2  <-- 0x1002039c
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10592000    0x80004338 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
          10593000    0x8000433c bnez a3, 116                   #; a3  = 0, not taken
          10594000    0x80004340 mv a4, a0                      #; a0  = 0x10020390, (wrb) a4  <-- 0x10020390
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
          10595000    0x80004344 andi a3, a2, -4                #; a2  = 0x1002039c, (wrb) a3  <-- 0x1002039c
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
          10596000    0x80004348 sub a5, a3, a4                 #; a3  = 0x1002039c, a4  = 0x10020390, (wrb) a5  <-- 12
          10597000    0x8000434c li a6, 33                      #; (wrb) a6  <-- 33
          10598000    0x80004350 bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10599000    0x80004354 bgeu a4, a3, 32                #; a4  = 0x10020390, a3  = 0x1002039c, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10600000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001fb80, a6  <~~ Word[0x1001fb80]
          10601000    0x8000435c addi a5, a4, 4                 #; a4  = 0x10020390, (wrb) a5  <-- 0x10020394
          10602000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001fb80, (wrb) a1  <-- 0x1001fb84
          10603000                                              #; (lsu) a6  <-- 0x80005fc0
          10604000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x10020390, 0x80005fc0 ~~> Word[0x10020390]
          10605000    0x80004368 mv a4, a5                      #; a5  = 0x10020394, (wrb) a4  <-- 0x10020394
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10606000    0x8000436c bltu a5, a3, -20               #; a5  = 0x10020394, a3  = 0x1002039c, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10607000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001fb84, a6  <~~ Word[0x1001fb84]
          10608000    0x8000435c addi a5, a4, 4                 #; a4  = 0x10020394, (wrb) a5  <-- 0x10020398
          10609000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001fb84, (wrb) a1  <-- 0x1001fb88
          10616000                                              #; (lsu) a6  <-- 1
          10617000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x10020394, 1 ~~> Word[0x10020394]
          10618000    0x80004368 mv a4, a5                      #; a5  = 0x10020398, (wrb) a4  <-- 0x10020398
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10619000    0x8000436c bltu a5, a3, -20               #; a5  = 0x10020398, a3  = 0x1002039c, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10620000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001fb88, a6  <~~ Word[0x1001fb88]
          10621000    0x8000435c addi a5, a4, 4                 #; a4  = 0x10020398, (wrb) a5  <-- 0x1002039c
          10622000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001fb88, (wrb) a1  <-- 0x1001fb8c
          10629000                                              #; (lsu) a6  <-- 1
          10630000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x10020398, 1 ~~> Word[0x10020398]
          10631000    0x80004368 mv a4, a5                      #; a5  = 0x1002039c, (wrb) a4  <-- 0x1002039c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10632000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1002039c, a3  = 0x1002039c, not taken
          10633000    0x80004370 j 8                            #; goto 0x80004378
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
          10634000    0x80004378 bltu a5, a2, 20                #; a5  = 0x1002039c, a2  = 0x1002039c, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
          10635000    0x8000437c lw s0, 12(sp)                  #; sp  = 0x1001fb30, s0  <~~ Word[0x1001fb3c]
          10636000    0x80004380 addi sp, sp, 16                #; sp  = 0x1001fb30, (wrb) sp  <-- 0x1001fb40
          10637000    0x80004384 ret                            #; ra  = 0x80003e60, goto 0x80003e60
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
          10638000    0x80003e60 lw a0, 8(sp)                   #; sp  = 0x1001fb40, a0  <~~ Word[0x1001fb48]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
          10639000    0x80003e64 lw a1, 8(sp)                   #; sp  = 0x1001fb40, a1  <~~ Word[0x1001fb48]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
          10640000    0x80003e68 ori s6, s1, 1032               #; s1  = 2064, (wrb) s6  <-- 3096
          10642000                                              #; (lsu) s0  <-- 12
          10643000                                              #; (lsu) a0  <-- 0x1001fb80
          10644000    0x80003e6c add a0, a0, s6                 #; a0  = 0x1001fb80, s6  = 3096, (wrb) a0  <-- 0x10020798
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
          10645000    0x80003e70 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
          10646000    0x80003e74 auipc ra, 0                    #; (wrb) ra  <-- 0x80003e74
          10647000    0x80003e78 jalr 1180(ra)                  #; ra  = 0x80003e74, (wrb) ra  <-- 0x80003e7c, goto 0x80004310
#; memcpy (memcpy.c:25)
#;   {
          10648000    0x80004310 addi sp, sp, -16               #; sp  = 0x1001fb40, (wrb) sp  <-- 0x1001fb30
          10649000    0x80004314 sw s0, 12(sp)                  #; sp  = 0x1001fb30, 12 ~~> Word[0x1001fb3c], (lsu) a1  <-- 0x1001fb80
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10650000    0x80004318 andi a3, a0, 3                 #; a0  = 0x10020798, (wrb) a3  <-- 0
          10651000    0x8000431c andi a4, a1, 3                 #; a1  = 0x1001fb80, (wrb) a4  <-- 0
          10652000    0x80004320 xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
          10653000    0x80004324 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
          10654000    0x80004328 li a5, 3                       #; (wrb) a5  <-- 3
          10655000    0x8000432c sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
          10656000    0x80004330 and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
          10657000    0x80004334 add a2, a0, a2                 #; a0  = 0x10020798, a2  = 12, (wrb) a2  <-- 0x100207a4
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10658000    0x80004338 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
          10659000    0x8000433c bnez a3, 116                   #; a3  = 0, not taken
          10660000    0x80004340 mv a4, a0                      #; a0  = 0x10020798, (wrb) a4  <-- 0x10020798
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
          10661000    0x80004344 andi a3, a2, -4                #; a2  = 0x100207a4, (wrb) a3  <-- 0x100207a4
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
          10662000    0x80004348 sub a5, a3, a4                 #; a3  = 0x100207a4, a4  = 0x10020798, (wrb) a5  <-- 12
          10663000    0x8000434c li a6, 33                      #; (wrb) a6  <-- 33
          10664000    0x80004350 bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10665000    0x80004354 bgeu a4, a3, 32                #; a4  = 0x10020798, a3  = 0x100207a4, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10666000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001fb80, a6  <~~ Word[0x1001fb80]
          10667000    0x8000435c addi a5, a4, 4                 #; a4  = 0x10020798, (wrb) a5  <-- 0x1002079c
          10668000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001fb80, (wrb) a1  <-- 0x1001fb84
          10669000                                              #; (lsu) a6  <-- 0x80005fc0
          10670000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x10020798, 0x80005fc0 ~~> Word[0x10020798]
          10671000    0x80004368 mv a4, a5                      #; a5  = 0x1002079c, (wrb) a4  <-- 0x1002079c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10672000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1002079c, a3  = 0x100207a4, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10673000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001fb84, a6  <~~ Word[0x1001fb84]
          10674000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1002079c, (wrb) a5  <-- 0x100207a0
          10675000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001fb84, (wrb) a1  <-- 0x1001fb88
          10682000                                              #; (lsu) a6  <-- 1
          10683000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1002079c, 1 ~~> Word[0x1002079c]
          10684000    0x80004368 mv a4, a5                      #; a5  = 0x100207a0, (wrb) a4  <-- 0x100207a0
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10685000    0x8000436c bltu a5, a3, -20               #; a5  = 0x100207a0, a3  = 0x100207a4, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10686000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001fb88, a6  <~~ Word[0x1001fb88]
          10687000    0x8000435c addi a5, a4, 4                 #; a4  = 0x100207a0, (wrb) a5  <-- 0x100207a4
          10688000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001fb88, (wrb) a1  <-- 0x1001fb8c
          10698000                                              #; (lsu) a6  <-- 1
          10699000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x100207a0, 1 ~~> Word[0x100207a0]
          10700000    0x80004368 mv a4, a5                      #; a5  = 0x100207a4, (wrb) a4  <-- 0x100207a4
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10701000    0x8000436c bltu a5, a3, -20               #; a5  = 0x100207a4, a3  = 0x100207a4, not taken
          10702000    0x80004370 j 8                            #; goto 0x80004378
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
          10703000    0x80004378 bltu a5, a2, 20                #; a5  = 0x100207a4, a2  = 0x100207a4, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
          10704000    0x8000437c lw s0, 12(sp)                  #; sp  = 0x1001fb30, s0  <~~ Word[0x1001fb3c]
          10705000    0x80004380 addi sp, sp, 16                #; sp  = 0x1001fb30, (wrb) sp  <-- 0x1001fb40
          10706000    0x80004384 ret                            #; ra  = 0x80003e7c, goto 0x80003e7c
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
          10707000    0x80003e7c lw a0, 8(sp)                   #; sp  = 0x1001fb40, a0  <~~ Word[0x1001fb48]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
          10708000    0x80003e80 lw a1, 8(sp)                   #; sp  = 0x1001fb40, a1  <~~ Word[0x1001fb48]
          10709000    0x80003e84 addi s7, s7, 32                #; s7  = 4096, (wrb) s7  <-- 4128
          10715000                                              #; (lsu) s0  <-- 12
          10716000                                              #; (lsu) a0  <-- 0x1001fb80
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
          10717000    0x80003e88 add a0, a0, s7                 #; a0  = 0x1001fb80, s7  = 4128, (wrb) a0  <-- 0x10020ba0
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
          10718000    0x80003e8c mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
          10719000    0x80003e90 auipc ra, 0                    #; (wrb) ra  <-- 0x80003e90
          10720000    0x80003e94 jalr 1152(ra)                  #; ra  = 0x80003e90, (wrb) ra  <-- 0x80003e98, goto 0x80004310
          10721000                                              #; (lsu) a1  <-- 0x1001fb80
#; memcpy (memcpy.c:25)
#;   {
          10723000    0x80004310 addi sp, sp, -16               #; sp  = 0x1001fb40, (wrb) sp  <-- 0x1001fb30
          10724000    0x80004314 sw s0, 12(sp)                  #; sp  = 0x1001fb30, 12 ~~> Word[0x1001fb3c]
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10725000    0x80004318 andi a3, a0, 3                 #; a0  = 0x10020ba0, (wrb) a3  <-- 0
          10726000    0x8000431c andi a4, a1, 3                 #; a1  = 0x1001fb80, (wrb) a4  <-- 0
          10727000    0x80004320 xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
          10728000    0x80004324 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
          10729000    0x80004328 li a5, 3                       #; (wrb) a5  <-- 3
          10730000    0x8000432c sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
          10731000    0x80004330 and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
          10732000    0x80004334 add a2, a0, a2                 #; a0  = 0x10020ba0, a2  = 12, (wrb) a2  <-- 0x10020bac
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10733000    0x80004338 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
          10734000    0x8000433c bnez a3, 116                   #; a3  = 0, not taken
          10735000    0x80004340 mv a4, a0                      #; a0  = 0x10020ba0, (wrb) a4  <-- 0x10020ba0
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
          10736000    0x80004344 andi a3, a2, -4                #; a2  = 0x10020bac, (wrb) a3  <-- 0x10020bac
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
          10737000    0x80004348 sub a5, a3, a4                 #; a3  = 0x10020bac, a4  = 0x10020ba0, (wrb) a5  <-- 12
          10738000    0x8000434c li a6, 33                      #; (wrb) a6  <-- 33
          10739000    0x80004350 bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10740000    0x80004354 bgeu a4, a3, 32                #; a4  = 0x10020ba0, a3  = 0x10020bac, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10741000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001fb80, a6  <~~ Word[0x1001fb80]
          10742000    0x8000435c addi a5, a4, 4                 #; a4  = 0x10020ba0, (wrb) a5  <-- 0x10020ba4
          10743000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001fb80, (wrb) a1  <-- 0x1001fb84
          10744000                                              #; (lsu) a6  <-- 0x80005fc0
          10745000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x10020ba0, 0x80005fc0 ~~> Word[0x10020ba0]
          10746000    0x80004368 mv a4, a5                      #; a5  = 0x10020ba4, (wrb) a4  <-- 0x10020ba4
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10747000    0x8000436c bltu a5, a3, -20               #; a5  = 0x10020ba4, a3  = 0x10020bac, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10748000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001fb84, a6  <~~ Word[0x1001fb84]
          10749000    0x8000435c addi a5, a4, 4                 #; a4  = 0x10020ba4, (wrb) a5  <-- 0x10020ba8
          10750000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001fb84, (wrb) a1  <-- 0x1001fb88
          10758000                                              #; (lsu) a6  <-- 1
          10759000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x10020ba4, 1 ~~> Word[0x10020ba4]
          10760000    0x80004368 mv a4, a5                      #; a5  = 0x10020ba8, (wrb) a4  <-- 0x10020ba8
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10761000    0x8000436c bltu a5, a3, -20               #; a5  = 0x10020ba8, a3  = 0x10020bac, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10762000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001fb88, a6  <~~ Word[0x1001fb88]
          10763000    0x8000435c addi a5, a4, 4                 #; a4  = 0x10020ba8, (wrb) a5  <-- 0x10020bac
          10764000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001fb88, (wrb) a1  <-- 0x1001fb8c
          10777000                                              #; (lsu) a6  <-- 1
          10778000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x10020ba8, 1 ~~> Word[0x10020ba8]
          10779000    0x80004368 mv a4, a5                      #; a5  = 0x10020bac, (wrb) a4  <-- 0x10020bac
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10780000    0x8000436c bltu a5, a3, -20               #; a5  = 0x10020bac, a3  = 0x10020bac, not taken
          10781000    0x80004370 j 8                            #; goto 0x80004378
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
          10782000    0x80004378 bltu a5, a2, 20                #; a5  = 0x10020bac, a2  = 0x10020bac, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
          10783000    0x8000437c lw s0, 12(sp)                  #; sp  = 0x1001fb30, s0  <~~ Word[0x1001fb3c]
          10784000    0x80004380 addi sp, sp, 16                #; sp  = 0x1001fb30, (wrb) sp  <-- 0x1001fb40
          10785000    0x80004384 ret                            #; ra  = 0x80003e98, goto 0x80003e98
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
          10786000    0x80003e98 lw a0, 8(sp)                   #; sp  = 0x1001fb40, a0  <~~ Word[0x1001fb48]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
          10787000    0x80003e9c lw a1, 8(sp)                   #; sp  = 0x1001fb40, a1  <~~ Word[0x1001fb48]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
          10788000    0x80003ea0 ori s8, s7, 1032               #; s7  = 4128, (wrb) s8  <-- 5160
          10790000                                              #; (lsu) s0  <-- 12
          10791000                                              #; (lsu) a0  <-- 0x1001fb80
          10792000    0x80003ea4 add a0, a0, s8                 #; a0  = 0x1001fb80, s8  = 5160, (wrb) a0  <-- 0x10020fa8
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
          10793000    0x80003ea8 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
          10794000    0x80003eac auipc ra, 0                    #; (wrb) ra  <-- 0x80003eac
          10795000    0x80003eb0 jalr 1124(ra)                  #; ra  = 0x80003eac, (wrb) ra  <-- 0x80003eb4, goto 0x80004310
#; memcpy (memcpy.c:25)
#;   {
          10796000    0x80004310 addi sp, sp, -16               #; sp  = 0x1001fb40, (wrb) sp  <-- 0x1001fb30
          10797000    0x80004314 sw s0, 12(sp)                  #; sp  = 0x1001fb30, 12 ~~> Word[0x1001fb3c], (lsu) a1  <-- 0x1001fb80
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10798000    0x80004318 andi a3, a0, 3                 #; a0  = 0x10020fa8, (wrb) a3  <-- 0
          10799000    0x8000431c andi a4, a1, 3                 #; a1  = 0x1001fb80, (wrb) a4  <-- 0
          10800000    0x80004320 xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
          10801000    0x80004324 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
          10802000    0x80004328 li a5, 3                       #; (wrb) a5  <-- 3
          10803000    0x8000432c sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
          10804000    0x80004330 and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
          10805000    0x80004334 add a2, a0, a2                 #; a0  = 0x10020fa8, a2  = 12, (wrb) a2  <-- 0x10020fb4
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10806000    0x80004338 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
          10807000    0x8000433c bnez a3, 116                   #; a3  = 0, not taken
          10808000    0x80004340 mv a4, a0                      #; a0  = 0x10020fa8, (wrb) a4  <-- 0x10020fa8
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
          10809000    0x80004344 andi a3, a2, -4                #; a2  = 0x10020fb4, (wrb) a3  <-- 0x10020fb4
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
          10810000    0x80004348 sub a5, a3, a4                 #; a3  = 0x10020fb4, a4  = 0x10020fa8, (wrb) a5  <-- 12
          10811000    0x8000434c li a6, 33                      #; (wrb) a6  <-- 33
          10812000    0x80004350 bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10813000    0x80004354 bgeu a4, a3, 32                #; a4  = 0x10020fa8, a3  = 0x10020fb4, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10814000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001fb80, a6  <~~ Word[0x1001fb80]
          10815000    0x8000435c addi a5, a4, 4                 #; a4  = 0x10020fa8, (wrb) a5  <-- 0x10020fac
          10816000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001fb80, (wrb) a1  <-- 0x1001fb84
          10817000                                              #; (lsu) a6  <-- 0x80005fc0
          10818000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x10020fa8, 0x80005fc0 ~~> Word[0x10020fa8]
          10819000    0x80004368 mv a4, a5                      #; a5  = 0x10020fac, (wrb) a4  <-- 0x10020fac
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10820000    0x8000436c bltu a5, a3, -20               #; a5  = 0x10020fac, a3  = 0x10020fb4, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10821000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001fb84, a6  <~~ Word[0x1001fb84]
          10822000    0x8000435c addi a5, a4, 4                 #; a4  = 0x10020fac, (wrb) a5  <-- 0x10020fb0
          10823000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001fb84, (wrb) a1  <-- 0x1001fb88
          10837000                                              #; (lsu) a6  <-- 1
          10838000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x10020fac, 1 ~~> Word[0x10020fac]
          10839000    0x80004368 mv a4, a5                      #; a5  = 0x10020fb0, (wrb) a4  <-- 0x10020fb0
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10840000    0x8000436c bltu a5, a3, -20               #; a5  = 0x10020fb0, a3  = 0x10020fb4, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10841000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001fb88, a6  <~~ Word[0x1001fb88]
          10842000    0x8000435c addi a5, a4, 4                 #; a4  = 0x10020fb0, (wrb) a5  <-- 0x10020fb4
          10843000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001fb88, (wrb) a1  <-- 0x1001fb8c
          10863000                                              #; (lsu) a6  <-- 1
          10864000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x10020fb0, 1 ~~> Word[0x10020fb0]
          10865000    0x80004368 mv a4, a5                      #; a5  = 0x10020fb4, (wrb) a4  <-- 0x10020fb4
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10866000    0x8000436c bltu a5, a3, -20               #; a5  = 0x10020fb4, a3  = 0x10020fb4, not taken
          10867000    0x80004370 j 8                            #; goto 0x80004378
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
          10868000    0x80004378 bltu a5, a2, 20                #; a5  = 0x10020fb4, a2  = 0x10020fb4, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
          10869000    0x8000437c lw s0, 12(sp)                  #; sp  = 0x1001fb30, s0  <~~ Word[0x1001fb3c]
          10870000    0x80004380 addi sp, sp, 16                #; sp  = 0x1001fb30, (wrb) sp  <-- 0x1001fb40
          10871000    0x80004384 ret                            #; ra  = 0x80003eb4, goto 0x80003eb4
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
          10876000    0x80003eb4 lw a0, 8(sp)                   #; sp  = 0x1001fb40, a0  <~~ Word[0x1001fb48]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
          10877000    0x80003eb8 lw a1, 8(sp)                   #; sp  = 0x1001fb40, a1  <~~ Word[0x1001fb48]
          10878000    0x80003ebc lui s11, 2                     #; (wrb) s11 <-- 8192
          10879000    0x80003ec0 addi s9, s11, -2000            #; s11 = 8192, (wrb) s9  <-- 6192
          10886000                                              #; (lsu) s0  <-- 12
          10887000                                              #; (lsu) a0  <-- 0x1001fb80
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
          10888000    0x80003ec4 add a0, a0, s9                 #; a0  = 0x1001fb80, s9  = 6192, (wrb) a0  <-- 0x100213b0
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
          10889000    0x80003ec8 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
          10890000    0x80003ecc auipc ra, 0                    #; (wrb) ra  <-- 0x80003ecc
          10891000    0x80003ed0 jalr 1092(ra)                  #; ra  = 0x80003ecc, (wrb) ra  <-- 0x80003ed4, goto 0x80004310
#; memcpy (memcpy.c:25)
#;   {
          10892000    0x80004310 addi sp, sp, -16               #; sp  = 0x1001fb40, (wrb) sp  <-- 0x1001fb30
          10893000    0x80004314 sw s0, 12(sp)                  #; sp  = 0x1001fb30, 12 ~~> Word[0x1001fb3c], (lsu) a1  <-- 0x1001fb80
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10894000    0x80004318 andi a3, a0, 3                 #; a0  = 0x100213b0, (wrb) a3  <-- 0
          10895000    0x8000431c andi a4, a1, 3                 #; a1  = 0x1001fb80, (wrb) a4  <-- 0
          10896000    0x80004320 xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
          10897000    0x80004324 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
          10898000    0x80004328 li a5, 3                       #; (wrb) a5  <-- 3
          10899000    0x8000432c sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
          10900000    0x80004330 and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
          10901000    0x80004334 add a2, a0, a2                 #; a0  = 0x100213b0, a2  = 12, (wrb) a2  <-- 0x100213bc
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10902000    0x80004338 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
          10903000    0x8000433c bnez a3, 116                   #; a3  = 0, not taken
          10904000    0x80004340 mv a4, a0                      #; a0  = 0x100213b0, (wrb) a4  <-- 0x100213b0
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
          10905000    0x80004344 andi a3, a2, -4                #; a2  = 0x100213bc, (wrb) a3  <-- 0x100213bc
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
          10906000    0x80004348 sub a5, a3, a4                 #; a3  = 0x100213bc, a4  = 0x100213b0, (wrb) a5  <-- 12
          10907000    0x8000434c li a6, 33                      #; (wrb) a6  <-- 33
          10908000    0x80004350 bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10909000    0x80004354 bgeu a4, a3, 32                #; a4  = 0x100213b0, a3  = 0x100213bc, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10910000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001fb80, a6  <~~ Word[0x1001fb80]
          10911000    0x8000435c addi a5, a4, 4                 #; a4  = 0x100213b0, (wrb) a5  <-- 0x100213b4
          10912000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001fb80, (wrb) a1  <-- 0x1001fb84
          10913000                                              #; (lsu) a6  <-- 0x80005fc0
          10914000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x100213b0, 0x80005fc0 ~~> Word[0x100213b0]
          10915000    0x80004368 mv a4, a5                      #; a5  = 0x100213b4, (wrb) a4  <-- 0x100213b4
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10916000    0x8000436c bltu a5, a3, -20               #; a5  = 0x100213b4, a3  = 0x100213bc, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10917000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001fb84, a6  <~~ Word[0x1001fb84]
          10918000    0x8000435c addi a5, a4, 4                 #; a4  = 0x100213b4, (wrb) a5  <-- 0x100213b8
          10919000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001fb84, (wrb) a1  <-- 0x1001fb88
          10956000                                              #; (lsu) a6  <-- 1
          10957000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x100213b4, 1 ~~> Word[0x100213b4]
          10958000    0x80004368 mv a4, a5                      #; a5  = 0x100213b8, (wrb) a4  <-- 0x100213b8
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10959000    0x8000436c bltu a5, a3, -20               #; a5  = 0x100213b8, a3  = 0x100213bc, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10960000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001fb88, a6  <~~ Word[0x1001fb88]
          10961000    0x8000435c addi a5, a4, 4                 #; a4  = 0x100213b8, (wrb) a5  <-- 0x100213bc
          10962000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001fb88, (wrb) a1  <-- 0x1001fb8c
          10983000                                              #; (lsu) a6  <-- 1
          10984000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x100213b8, 1 ~~> Word[0x100213b8]
          10985000    0x80004368 mv a4, a5                      #; a5  = 0x100213bc, (wrb) a4  <-- 0x100213bc
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10986000    0x8000436c bltu a5, a3, -20               #; a5  = 0x100213bc, a3  = 0x100213bc, not taken
          10987000    0x80004370 j 8                            #; goto 0x80004378
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
          10988000    0x80004378 bltu a5, a2, 20                #; a5  = 0x100213bc, a2  = 0x100213bc, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
          10989000    0x8000437c lw s0, 12(sp)                  #; sp  = 0x1001fb30, s0  <~~ Word[0x1001fb3c]
          10990000    0x80004380 addi sp, sp, 16                #; sp  = 0x1001fb30, (wrb) sp  <-- 0x1001fb40
          10991000    0x80004384 ret                            #; ra  = 0x80003ed4, goto 0x80003ed4
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
          11011000    0x80003ed4 lw a0, 8(sp)                   #; sp  = 0x1001fb40, a0  <~~ Word[0x1001fb48]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
          11012000    0x80003ed8 lw a1, 8(sp)                   #; sp  = 0x1001fb40, a1  <~~ Word[0x1001fb48]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
          11013000    0x80003edc ori s10, s9, 1032              #; s9  = 6192, (wrb) s10 <-- 7224
          11018000                                              #; (lsu) s0  <-- 12
          11019000                                              #; (lsu) a0  <-- 0x1001fb80
          11020000    0x80003ee0 add a0, a0, s10                #; a0  = 0x1001fb80, s10 = 7224, (wrb) a0  <-- 0x100217b8
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
          11021000    0x80003ee4 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
          11022000    0x80003ee8 auipc ra, 0                    #; (wrb) ra  <-- 0x80003ee8
          11023000    0x80003eec jalr 1064(ra)                  #; ra  = 0x80003ee8, (wrb) ra  <-- 0x80003ef0, goto 0x80004310
#; memcpy (memcpy.c:25)
#;   {
          11024000    0x80004310 addi sp, sp, -16               #; sp  = 0x1001fb40, (wrb) sp  <-- 0x1001fb30
          11025000    0x80004314 sw s0, 12(sp)                  #; sp  = 0x1001fb30, 12 ~~> Word[0x1001fb3c], (lsu) a1  <-- 0x1001fb80
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          11026000    0x80004318 andi a3, a0, 3                 #; a0  = 0x100217b8, (wrb) a3  <-- 0
          11027000    0x8000431c andi a4, a1, 3                 #; a1  = 0x1001fb80, (wrb) a4  <-- 0
          11028000    0x80004320 xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
          11029000    0x80004324 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
          11030000    0x80004328 li a5, 3                       #; (wrb) a5  <-- 3
          11031000    0x8000432c sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
          11032000    0x80004330 and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
          11033000    0x80004334 add a2, a0, a2                 #; a0  = 0x100217b8, a2  = 12, (wrb) a2  <-- 0x100217c4
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          11034000    0x80004338 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
          11035000    0x8000433c bnez a3, 116                   #; a3  = 0, not taken
          11036000    0x80004340 mv a4, a0                      #; a0  = 0x100217b8, (wrb) a4  <-- 0x100217b8
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
          11037000    0x80004344 andi a3, a2, -4                #; a2  = 0x100217c4, (wrb) a3  <-- 0x100217c4
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
          11038000    0x80004348 sub a5, a3, a4                 #; a3  = 0x100217c4, a4  = 0x100217b8, (wrb) a5  <-- 12
          11039000    0x8000434c li a6, 33                      #; (wrb) a6  <-- 33
          11040000    0x80004350 bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          11041000    0x80004354 bgeu a4, a3, 32                #; a4  = 0x100217b8, a3  = 0x100217c4, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          11042000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001fb80, a6  <~~ Word[0x1001fb80]
          11043000    0x8000435c addi a5, a4, 4                 #; a4  = 0x100217b8, (wrb) a5  <-- 0x100217bc
          11044000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001fb80, (wrb) a1  <-- 0x1001fb84
          11045000                                              #; (lsu) a6  <-- 0x80005fc0
          11046000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x100217b8, 0x80005fc0 ~~> Word[0x100217b8]
          11047000    0x80004368 mv a4, a5                      #; a5  = 0x100217bc, (wrb) a4  <-- 0x100217bc
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          11048000    0x8000436c bltu a5, a3, -20               #; a5  = 0x100217bc, a3  = 0x100217c4, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          11049000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001fb84, a6  <~~ Word[0x1001fb84]
          11050000    0x8000435c addi a5, a4, 4                 #; a4  = 0x100217bc, (wrb) a5  <-- 0x100217c0
          11051000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001fb84, (wrb) a1  <-- 0x1001fb88
          11068000                                              #; (lsu) a6  <-- 1
          11069000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x100217bc, 1 ~~> Word[0x100217bc]
          11070000    0x80004368 mv a4, a5                      #; a5  = 0x100217c0, (wrb) a4  <-- 0x100217c0
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          11071000    0x8000436c bltu a5, a3, -20               #; a5  = 0x100217c0, a3  = 0x100217c4, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          11072000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001fb88, a6  <~~ Word[0x1001fb88]
          11073000    0x8000435c addi a5, a4, 4                 #; a4  = 0x100217c0, (wrb) a5  <-- 0x100217c4
          11074000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001fb88, (wrb) a1  <-- 0x1001fb8c
          11090000                                              #; (lsu) a6  <-- 1
          11091000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x100217c0, 1 ~~> Word[0x100217c0]
          11092000    0x80004368 mv a4, a5                      #; a5  = 0x100217c4, (wrb) a4  <-- 0x100217c4
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          11093000    0x8000436c bltu a5, a3, -20               #; a5  = 0x100217c4, a3  = 0x100217c4, not taken
          11094000    0x80004370 j 8                            #; goto 0x80004378
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
          11095000    0x80004378 bltu a5, a2, 20                #; a5  = 0x100217c4, a2  = 0x100217c4, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
          11096000    0x8000437c lw s0, 12(sp)                  #; sp  = 0x1001fb30, s0  <~~ Word[0x1001fb3c]
          11097000    0x80004380 addi sp, sp, 16                #; sp  = 0x1001fb30, (wrb) sp  <-- 0x1001fb40
          11098000    0x80004384 ret                            #; ra  = 0x80003ef0, goto 0x80003ef0
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
          11107000    0x80003ef0 lw a0, 8(sp)                   #; sp  = 0x1001fb40, a0  <~~ Word[0x1001fb48]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
          11108000    0x80003ef4 lw a1, 8(sp)                   #; sp  = 0x1001fb40, a1  <~~ Word[0x1001fb48]
          11109000    0x80003ef8 addi s11, s11, 64              #; s11 = 8192, (wrb) s11 <-- 8256
          11114000                                              #; (lsu) s0  <-- 12
          11115000                                              #; (lsu) a0  <-- 0x1001fb80
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
          11116000    0x80003efc add a0, a0, s11                #; a0  = 0x1001fb80, s11 = 8256, (wrb) a0  <-- 0x10021bc0
          11117000                                              #; (lsu) a1  <-- 0x1001fb80
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
          11119000    0x80003f00 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
          11120000    0x80003f04 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f04
          11121000    0x80003f08 jalr 1036(ra)                  #; ra  = 0x80003f04, (wrb) ra  <-- 0x80003f0c, goto 0x80004310
#; memcpy (memcpy.c:25)
#;   {
          11122000    0x80004310 addi sp, sp, -16               #; sp  = 0x1001fb40, (wrb) sp  <-- 0x1001fb30
          11123000    0x80004314 sw s0, 12(sp)                  #; sp  = 0x1001fb30, 12 ~~> Word[0x1001fb3c]
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          11124000    0x80004318 andi a3, a0, 3                 #; a0  = 0x10021bc0, (wrb) a3  <-- 0
          11125000    0x8000431c andi a4, a1, 3                 #; a1  = 0x1001fb80, (wrb) a4  <-- 0
          11126000    0x80004320 xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
          11127000    0x80004324 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
          11128000    0x80004328 li a5, 3                       #; (wrb) a5  <-- 3
          11129000    0x8000432c sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
          11130000    0x80004330 and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
          11131000    0x80004334 add a2, a0, a2                 #; a0  = 0x10021bc0, a2  = 12, (wrb) a2  <-- 0x10021bcc
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          11132000    0x80004338 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
          11133000    0x8000433c bnez a3, 116                   #; a3  = 0, not taken
          11134000    0x80004340 mv a4, a0                      #; a0  = 0x10021bc0, (wrb) a4  <-- 0x10021bc0
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
          11135000    0x80004344 andi a3, a2, -4                #; a2  = 0x10021bcc, (wrb) a3  <-- 0x10021bcc
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
          11136000    0x80004348 sub a5, a3, a4                 #; a3  = 0x10021bcc, a4  = 0x10021bc0, (wrb) a5  <-- 12
          11137000    0x8000434c li a6, 33                      #; (wrb) a6  <-- 33
          11138000    0x80004350 bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          11139000    0x80004354 bgeu a4, a3, 32                #; a4  = 0x10021bc0, a3  = 0x10021bcc, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          11140000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001fb80, a6  <~~ Word[0x1001fb80]
          11141000    0x8000435c addi a5, a4, 4                 #; a4  = 0x10021bc0, (wrb) a5  <-- 0x10021bc4
          11142000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001fb80, (wrb) a1  <-- 0x1001fb84
          11143000                                              #; (lsu) a6  <-- 0x80005fc0
          11144000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x10021bc0, 0x80005fc0 ~~> Word[0x10021bc0]
          11145000    0x80004368 mv a4, a5                      #; a5  = 0x10021bc4, (wrb) a4  <-- 0x10021bc4
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          11146000    0x8000436c bltu a5, a3, -20               #; a5  = 0x10021bc4, a3  = 0x10021bcc, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          11147000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001fb84, a6  <~~ Word[0x1001fb84]
          11148000    0x8000435c addi a5, a4, 4                 #; a4  = 0x10021bc4, (wrb) a5  <-- 0x10021bc8
          11149000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001fb84, (wrb) a1  <-- 0x1001fb88
          11156000                                              #; (lsu) a6  <-- 1
          11157000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x10021bc4, 1 ~~> Word[0x10021bc4]
          11158000    0x80004368 mv a4, a5                      #; a5  = 0x10021bc8, (wrb) a4  <-- 0x10021bc8
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          11159000    0x8000436c bltu a5, a3, -20               #; a5  = 0x10021bc8, a3  = 0x10021bcc, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          11160000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001fb88, a6  <~~ Word[0x1001fb88]
          11161000    0x8000435c addi a5, a4, 4                 #; a4  = 0x10021bc8, (wrb) a5  <-- 0x10021bcc
          11162000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001fb88, (wrb) a1  <-- 0x1001fb8c
          11166000                                              #; (lsu) a6  <-- 1
          11167000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x10021bc8, 1 ~~> Word[0x10021bc8]
          11168000    0x80004368 mv a4, a5                      #; a5  = 0x10021bcc, (wrb) a4  <-- 0x10021bcc
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          11169000    0x8000436c bltu a5, a3, -20               #; a5  = 0x10021bcc, a3  = 0x10021bcc, not taken
          11170000    0x80004370 j 8                            #; goto 0x80004378
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
          11171000    0x80004378 bltu a5, a2, 20                #; a5  = 0x10021bcc, a2  = 0x10021bcc, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
          11172000    0x8000437c lw s0, 12(sp)                  #; sp  = 0x1001fb30, s0  <~~ Word[0x1001fb3c]
          11173000    0x80004380 addi sp, sp, 16                #; sp  = 0x1001fb30, (wrb) sp  <-- 0x1001fb40
          11174000    0x80004384 ret                            #; ra  = 0x80003f0c, goto 0x80003f0c
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:79:17)
#;     tls_ptr += size;
#;             ^
          11175000    0x80003f0c lw a0, 8(sp)                   #; sp  = 0x1001fb40, a0  <~~ Word[0x1001fb48]
          11176000                                              #; (lsu) s0  <-- 12
          11178000                                              #; (lsu) a0  <-- 0x1001fb80
          11179000    0x80003f10 add a0, a0, s0                 #; a0  = 0x1001fb80, s0  = 12, (wrb) a0  <-- 0x1001fb8c
          11180000    0x80003f14 sw a0, 8(sp)                   #; sp  = 0x1001fb40, 0x1001fb8c ~~> Word[0x1001fb48]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
          11181000    0x80003f18 lw a0, 8(sp)                   #; sp  = 0x1001fb40, a0  <~~ Word[0x1001fb48]
#; .LBB25_25 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
          11182000    0x80003f1c auipc a1, 2                    #; (wrb) a1  <-- 0x80005f1c
          11183000    0x80003f20 addi a1, a1, -132              #; a1  = 0x80005f1c, (wrb) a1  <-- 0x80005e98
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
          11184000    0x80003f24 auipc a2, 2                    #; (wrb) a2  <-- 0x80005f24
          11185000    0x80003f28 addi a2, a2, -76               #; a2  = 0x80005f24, (wrb) a2  <-- 0x80005ed8
          11186000    0x80003f2c sub s0, a2, a1                 #; a2  = 0x80005ed8, a1  = 0x80005e98, (wrb) s0  <-- 64
          11187000    0x80003f30 li a1, 0                       #; (wrb) a1  <-- 0
          11188000    0x80003f34 mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
          11189000    0x80003f38 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f38
          11190000    0x80003f3c jalr 764(ra)                   #; ra  = 0x80003f38, (wrb) ra  <-- 0x80003f40, goto 0x80004234
          11191000                                              #; (lsu) a0  <-- 0x1001fb8c
#; memset (memset.S:30)
#;   li t1, 15
          11193000    0x80004234 li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
          11194000    0x80004238 mv a4, a0                      #; a0  = 0x1001fb8c, (wrb) a4  <-- 0x1001fb8c
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
          11195000    0x8000423c bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
          11198000    0x80004240 andi a5, a4, 15                #; a4  = 0x1001fb8c, (wrb) a5  <-- 12
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
          11199000    0x80004244 bnez a5, 160                   #; a5  = 12, taken, goto 0x800042e4
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
          11202000    0x800042e4 slli a3, a5, 2                 #; a5  = 12, (wrb) a3  <-- 48
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
          11203000    0x800042e8 auipc t0, 0                    #; (wrb) t0  <-- 0x800042e8
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
          11204000    0x800042ec add a3, a3, t0                 #; a3  = 48, t0  = 0x800042e8, (wrb) a3  <-- 0x80004318
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
          11205000    0x800042f0 mv t0, ra                      #; ra  = 0x80003f40, (wrb) t0  <-- 0x80003f40
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
          11206000    0x800042f4 jalr -96(a3)                   #; a3  = 0x80004318, (wrb) ra  <-- 0x800042f8, goto 0x800042b8
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          11209000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x1001fb8c, 0 ~~> Byte[0x1001fb8f]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          11210000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x1001fb8c, 0 ~~> Byte[0x1001fb8e]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          11211000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x1001fb8c, 0 ~~> Byte[0x1001fb8d]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          11212000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x1001fb8c, 0 ~~> Byte[0x1001fb8c]
#; .Ltable (memset.S:85)
#;   ret
          11213000    0x800042c8 ret                            #; ra  = 0x800042f8, goto 0x800042f8
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
          11214000    0x800042f8 mv ra, t0                      #; t0  = 0x80003f40, (wrb) ra  <-- 0x80003f40
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
          11215000    0x800042fc addi a5, a5, -16               #; a5  = 12, (wrb) a5  <-- -4
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
          11216000    0x80004300 sub a4, a4, a5                 #; a4  = 0x1001fb8c, a5  = -4, (wrb) a4  <-- 0x1001fb90
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
          11217000    0x80004304 add a2, a2, a5                 #; a2  = 64, a5  = -4, (wrb) a2  <-- 60
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
          11218000    0x80004308 bgeu t1, a2, -144              #; t1  = 15, a2  = 60, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
          11219000    0x8000430c j -196                         #; goto 0x80004248
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
          11220000    0x80004248 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
          11221000    0x8000424c andi a3, a2, -16               #; a2  = 60, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
          11222000    0x80004250 andi a2, a2, 15                #; a2  = 60, (wrb) a2  <-- 12
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
          11223000    0x80004254 add a3, a3, a4                 #; a3  = 48, a4  = 0x1001fb90, (wrb) a3  <-- 0x1001fbc0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11224000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001fb90, 0 ~~> Word[0x1001fb90]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11225000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001fb90, 0 ~~> Word[0x1001fb94]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11226000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001fb90, 0 ~~> Word[0x1001fb98]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11227000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001fb90, 0 ~~> Word[0x1001fb9c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11228000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001fb90, (wrb) a4  <-- 0x1001fba0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11229000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001fba0, a3  = 0x1001fbc0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11230000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001fba0, 0 ~~> Word[0x1001fba0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11231000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001fba0, 0 ~~> Word[0x1001fba4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11234000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001fba0, 0 ~~> Word[0x1001fba8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11235000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001fba0, 0 ~~> Word[0x1001fbac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11236000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001fba0, (wrb) a4  <-- 0x1001fbb0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11237000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001fbb0, a3  = 0x1001fbc0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11238000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001fbb0, 0 ~~> Word[0x1001fbb0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11239000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001fbb0, 0 ~~> Word[0x1001fbb4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11240000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001fbb0, 0 ~~> Word[0x1001fbb8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11241000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001fbb0, 0 ~~> Word[0x1001fbbc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11242000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001fbb0, (wrb) a4  <-- 0x1001fbc0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11243000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001fbc0, a3  = 0x1001fbc0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
          11244000    0x80004270 bnez a2, 8                     #; a2  = 12, taken, goto 0x80004278
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
          11245000    0x80004278 sub a3, t1, a2                 #; t1  = 15, a2  = 12, (wrb) a3  <-- 3
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
          11246000    0x8000427c slli a3, a3, 2                 #; a3  = 3, (wrb) a3  <-- 12
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
          11247000    0x80004280 auipc t0, 0                    #; (wrb) t0  <-- 0x80004280
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
          11248000    0x80004284 add a3, a3, t0                 #; a3  = 12, t0  = 0x80004280, (wrb) a3  <-- 0x8000428c
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
          11249000    0x80004288 jr 12(a3)                      #; a3  = 0x8000428c, goto 0x80004298
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
          11250000    0x80004298 sb a1, 11(a4)                  #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbcb]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
          11251000    0x8000429c sb a1, 10(a4)                  #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbca]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
          11252000    0x800042a0 sb a1, 9(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc9]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
          11253000    0x800042a4 sb a1, 8(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc8]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
          11254000    0x800042a8 sb a1, 7(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc7]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
          11255000    0x800042ac sb a1, 6(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc6]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
          11256000    0x800042b0 sb a1, 5(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc5]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
          11257000    0x800042b4 sb a1, 4(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc4]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          11258000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          11259000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          11260000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          11261000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc0]
#; .Ltable (memset.S:85)
#;   ret
          11262000    0x800042c8 ret                            #; ra  = 0x80003f40, goto 0x80003f40
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
          11265000    0x80003f40 lw a0, 8(sp)                   #; sp  = 0x1001fb40, a0  <~~ Word[0x1001fb48]
          11268000                                              #; (lsu) a0  <-- 0x1001fb8c
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
          11269000    0x80003f44 addi a0, a0, 1032              #; a0  = 0x1001fb8c, (wrb) a0  <-- 0x1001ff94
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
          11270000    0x80003f48 li a1, 0                       #; (wrb) a1  <-- 0
          11271000    0x80003f4c mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
          11272000    0x80003f50 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f50
          11273000    0x80003f54 jalr 740(ra)                   #; ra  = 0x80003f50, (wrb) ra  <-- 0x80003f58, goto 0x80004234
#; memset (memset.S:30)
#;   li t1, 15
          11274000    0x80004234 li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
          11275000    0x80004238 mv a4, a0                      #; a0  = 0x1001ff94, (wrb) a4  <-- 0x1001ff94
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
          11276000    0x8000423c bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
          11277000    0x80004240 andi a5, a4, 15                #; a4  = 0x1001ff94, (wrb) a5  <-- 4
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
          11278000    0x80004244 bnez a5, 160                   #; a5  = 4, taken, goto 0x800042e4
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
          11279000    0x800042e4 slli a3, a5, 2                 #; a5  = 4, (wrb) a3  <-- 16
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
          11280000    0x800042e8 auipc t0, 0                    #; (wrb) t0  <-- 0x800042e8
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
          11281000    0x800042ec add a3, a3, t0                 #; a3  = 16, t0  = 0x800042e8, (wrb) a3  <-- 0x800042f8
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
          11282000    0x800042f0 mv t0, ra                      #; ra  = 0x80003f58, (wrb) t0  <-- 0x80003f58
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
          11283000    0x800042f4 jalr -96(a3)                   #; a3  = 0x800042f8, (wrb) ra  <-- 0x800042f8, goto 0x80004298
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
          11284000    0x80004298 sb a1, 11(a4)                  #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9f]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
          11285000    0x8000429c sb a1, 10(a4)                  #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9e]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
          11286000    0x800042a0 sb a1, 9(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9d]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
          11287000    0x800042a4 sb a1, 8(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9c]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
          11288000    0x800042a8 sb a1, 7(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9b]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
          11289000    0x800042ac sb a1, 6(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9a]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
          11291000    0x800042b0 sb a1, 5(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff99]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
          11293000    0x800042b4 sb a1, 4(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff98]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          11294000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff97]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          11295000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff96]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          11296000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff95]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          11297000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff94]
#; .Ltable (memset.S:85)
#;   ret
          11298000    0x800042c8 ret                            #; ra  = 0x800042f8, goto 0x800042f8
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
          11299000    0x800042f8 mv ra, t0                      #; t0  = 0x80003f58, (wrb) ra  <-- 0x80003f58
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
          11300000    0x800042fc addi a5, a5, -16               #; a5  = 4, (wrb) a5  <-- -12
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
          11301000    0x80004300 sub a4, a4, a5                 #; a4  = 0x1001ff94, a5  = -12, (wrb) a4  <-- 0x1001ffa0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
          11302000    0x80004304 add a2, a2, a5                 #; a2  = 64, a5  = -12, (wrb) a2  <-- 52
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
          11303000    0x80004308 bgeu t1, a2, -144              #; t1  = 15, a2  = 52, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
          11304000    0x8000430c j -196                         #; goto 0x80004248
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
          11305000    0x80004248 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
          11306000    0x8000424c andi a3, a2, -16               #; a2  = 52, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
          11307000    0x80004250 andi a2, a2, 15                #; a2  = 52, (wrb) a2  <-- 4
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
          11308000    0x80004254 add a3, a3, a4                 #; a3  = 48, a4  = 0x1001ffa0, (wrb) a3  <-- 0x1001ffd0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11309000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001ffa0, 0 ~~> Word[0x1001ffa0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11310000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001ffa0, 0 ~~> Word[0x1001ffa4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11311000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001ffa0, 0 ~~> Word[0x1001ffa8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11312000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001ffa0, 0 ~~> Word[0x1001ffac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11313000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001ffa0, (wrb) a4  <-- 0x1001ffb0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11314000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001ffb0, a3  = 0x1001ffd0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11315000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001ffb0, 0 ~~> Word[0x1001ffb0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11316000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001ffb0, 0 ~~> Word[0x1001ffb4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11317000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001ffb0, 0 ~~> Word[0x1001ffb8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11318000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001ffb0, 0 ~~> Word[0x1001ffbc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11319000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001ffb0, (wrb) a4  <-- 0x1001ffc0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11320000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001ffc0, a3  = 0x1001ffd0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11321000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001ffc0, 0 ~~> Word[0x1001ffc0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11322000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001ffc0, 0 ~~> Word[0x1001ffc4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11324000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001ffc0, 0 ~~> Word[0x1001ffc8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11326000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001ffc0, 0 ~~> Word[0x1001ffcc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11327000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001ffc0, (wrb) a4  <-- 0x1001ffd0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11328000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001ffd0, a3  = 0x1001ffd0, not taken
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
          11335000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x1001ffd0, 0 ~~> Byte[0x1001ffd3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          11336000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x1001ffd0, 0 ~~> Byte[0x1001ffd2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          11337000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x1001ffd0, 0 ~~> Byte[0x1001ffd1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          11338000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x1001ffd0, 0 ~~> Byte[0x1001ffd0]
#; .Ltable (memset.S:85)
#;   ret
          11339000    0x800042c8 ret                            #; ra  = 0x80003f58, goto 0x80003f58
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
          11340000    0x80003f58 lw a0, 8(sp)                   #; sp  = 0x1001fb40, a0  <~~ Word[0x1001fb48]
          11343000                                              #; (lsu) a0  <-- 0x1001fb8c
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
          11344000    0x80003f5c add a0, a0, s1                 #; a0  = 0x1001fb8c, s1  = 2064, (wrb) a0  <-- 0x1002039c
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
          11345000    0x80003f60 li a1, 0                       #; (wrb) a1  <-- 0
          11346000    0x80003f64 mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
          11347000    0x80003f68 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f68
          11348000    0x80003f6c jalr 716(ra)                   #; ra  = 0x80003f68, (wrb) ra  <-- 0x80003f70, goto 0x80004234
#; memset (memset.S:30)
#;   li t1, 15
          11349000    0x80004234 li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
          11350000    0x80004238 mv a4, a0                      #; a0  = 0x1002039c, (wrb) a4  <-- 0x1002039c
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
          11351000    0x8000423c bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
          11352000    0x80004240 andi a5, a4, 15                #; a4  = 0x1002039c, (wrb) a5  <-- 12
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
          11357000    0x800042f0 mv t0, ra                      #; ra  = 0x80003f70, (wrb) t0  <-- 0x80003f70
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
          11358000    0x800042f4 jalr -96(a3)                   #; a3  = 0x80004318, (wrb) ra  <-- 0x800042f8, goto 0x800042b8
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          11359000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x1002039c, 0 ~~> Byte[0x1002039f]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          11360000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x1002039c, 0 ~~> Byte[0x1002039e]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          11363000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x1002039c, 0 ~~> Byte[0x1002039d]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          11373000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x1002039c, 0 ~~> Byte[0x1002039c]
#; .Ltable (memset.S:85)
#;   ret
          11374000    0x800042c8 ret                            #; ra  = 0x800042f8, goto 0x800042f8
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
          11375000    0x800042f8 mv ra, t0                      #; t0  = 0x80003f70, (wrb) ra  <-- 0x80003f70
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
          11376000    0x800042fc addi a5, a5, -16               #; a5  = 12, (wrb) a5  <-- -4
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
          11377000    0x80004300 sub a4, a4, a5                 #; a4  = 0x1002039c, a5  = -4, (wrb) a4  <-- 0x100203a0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
          11378000    0x80004304 add a2, a2, a5                 #; a2  = 64, a5  = -4, (wrb) a2  <-- 60
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
          11379000    0x80004308 bgeu t1, a2, -144              #; t1  = 15, a2  = 60, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
          11380000    0x8000430c j -196                         #; goto 0x80004248
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
          11381000    0x80004248 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
          11382000    0x8000424c andi a3, a2, -16               #; a2  = 60, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
          11383000    0x80004250 andi a2, a2, 15                #; a2  = 60, (wrb) a2  <-- 12
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
          11384000    0x80004254 add a3, a3, a4                 #; a3  = 48, a4  = 0x100203a0, (wrb) a3  <-- 0x100203d0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11385000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x100203a0, 0 ~~> Word[0x100203a0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11393000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x100203a0, 0 ~~> Word[0x100203a4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11403000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x100203a0, 0 ~~> Word[0x100203a8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11413000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x100203a0, 0 ~~> Word[0x100203ac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11414000    0x80004268 addi a4, a4, 16                #; a4  = 0x100203a0, (wrb) a4  <-- 0x100203b0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11415000    0x8000426c bltu a4, a3, -20               #; a4  = 0x100203b0, a3  = 0x100203d0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11423000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x100203b0, 0 ~~> Word[0x100203b0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11442000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x100203b0, 0 ~~> Word[0x100203b4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11453000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x100203b0, 0 ~~> Word[0x100203b8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11473000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x100203b0, 0 ~~> Word[0x100203bc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11474000    0x80004268 addi a4, a4, 16                #; a4  = 0x100203b0, (wrb) a4  <-- 0x100203c0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11475000    0x8000426c bltu a4, a3, -20               #; a4  = 0x100203c0, a3  = 0x100203d0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11493000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x100203c0, 0 ~~> Word[0x100203c0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11513000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x100203c0, 0 ~~> Word[0x100203c4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11532000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x100203c0, 0 ~~> Word[0x100203c8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11552000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x100203c0, 0 ~~> Word[0x100203cc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11553000    0x80004268 addi a4, a4, 16                #; a4  = 0x100203c0, (wrb) a4  <-- 0x100203d0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11554000    0x8000426c bltu a4, a3, -20               #; a4  = 0x100203d0, a3  = 0x100203d0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
          11555000    0x80004270 bnez a2, 8                     #; a2  = 12, taken, goto 0x80004278
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
          11556000    0x80004278 sub a3, t1, a2                 #; t1  = 15, a2  = 12, (wrb) a3  <-- 3
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
          11557000    0x8000427c slli a3, a3, 2                 #; a3  = 3, (wrb) a3  <-- 12
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
          11558000    0x80004280 auipc t0, 0                    #; (wrb) t0  <-- 0x80004280
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
          11559000    0x80004284 add a3, a3, t0                 #; a3  = 12, t0  = 0x80004280, (wrb) a3  <-- 0x8000428c
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
          11560000    0x80004288 jr 12(a3)                      #; a3  = 0x8000428c, goto 0x80004298
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
          11573000    0x80004298 sb a1, 11(a4)                  #; a4  = 0x100203d0, 0 ~~> Byte[0x100203db]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
          11602000    0x8000429c sb a1, 10(a4)                  #; a4  = 0x100203d0, 0 ~~> Byte[0x100203da]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
          11632000    0x800042a0 sb a1, 9(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d9]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
          11672000    0x800042a4 sb a1, 8(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d8]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
          11712000    0x800042a8 sb a1, 7(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d7]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
          11752000    0x800042ac sb a1, 6(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d6]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
          11792000    0x800042b0 sb a1, 5(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d5]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
          11832000    0x800042b4 sb a1, 4(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d4]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          11872000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          11912000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          11952000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          11992000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d0]
#; .Ltable (memset.S:85)
#;   ret
          11993000    0x800042c8 ret                            #; ra  = 0x80003f70, goto 0x80003f70
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
          12032000    0x80003f70 lw a0, 8(sp)                   #; sp  = 0x1001fb40, a0  <~~ Word[0x1001fb48]
          12082000                                              #; (lsu) a0  <-- 0x1001fb8c
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
          12083000    0x80003f74 add a0, a0, s6                 #; a0  = 0x1001fb8c, s6  = 3096, (wrb) a0  <-- 0x100207a4
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
          12084000    0x80003f78 li a1, 0                       #; (wrb) a1  <-- 0
          12085000    0x80003f7c mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
          12088000    0x80003f80 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f80
          12089000    0x80003f84 jalr 692(ra)                   #; ra  = 0x80003f80, (wrb) ra  <-- 0x80003f88, goto 0x80004234
#; memset (memset.S:30)
#;   li t1, 15
          12090000    0x80004234 li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
          12091000    0x80004238 mv a4, a0                      #; a0  = 0x100207a4, (wrb) a4  <-- 0x100207a4
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
          12092000    0x8000423c bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
          12093000    0x80004240 andi a5, a4, 15                #; a4  = 0x100207a4, (wrb) a5  <-- 4
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
          12094000    0x80004244 bnez a5, 160                   #; a5  = 4, taken, goto 0x800042e4
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
          12095000    0x800042e4 slli a3, a5, 2                 #; a5  = 4, (wrb) a3  <-- 16
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
          12096000    0x800042e8 auipc t0, 0                    #; (wrb) t0  <-- 0x800042e8
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
          12097000    0x800042ec add a3, a3, t0                 #; a3  = 16, t0  = 0x800042e8, (wrb) a3  <-- 0x800042f8
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
          12098000    0x800042f0 mv t0, ra                      #; ra  = 0x80003f88, (wrb) t0  <-- 0x80003f88
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
          12099000    0x800042f4 jalr -96(a3)                   #; a3  = 0x800042f8, (wrb) ra  <-- 0x800042f8, goto 0x80004298
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
          12100000    0x80004298 sb a1, 11(a4)                  #; a4  = 0x100207a4, 0 ~~> Byte[0x100207af]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
          12101000    0x8000429c sb a1, 10(a4)                  #; a4  = 0x100207a4, 0 ~~> Byte[0x100207ae]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
          12112000    0x800042a0 sb a1, 9(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207ad]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
          12152000    0x800042a4 sb a1, 8(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207ac]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
          12192000    0x800042a8 sb a1, 7(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207ab]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
          12232000    0x800042ac sb a1, 6(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207aa]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
          12272000    0x800042b0 sb a1, 5(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207a9]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
          12312000    0x800042b4 sb a1, 4(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207a8]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          12352000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207a7]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          12392000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207a6]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          12432000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207a5]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          12472000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207a4]
#; .Ltable (memset.S:85)
#;   ret
          12473000    0x800042c8 ret                            #; ra  = 0x800042f8, goto 0x800042f8
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
          12474000    0x800042f8 mv ra, t0                      #; t0  = 0x80003f88, (wrb) ra  <-- 0x80003f88
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
          12475000    0x800042fc addi a5, a5, -16               #; a5  = 4, (wrb) a5  <-- -12
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
          12476000    0x80004300 sub a4, a4, a5                 #; a4  = 0x100207a4, a5  = -12, (wrb) a4  <-- 0x100207b0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
          12477000    0x80004304 add a2, a2, a5                 #; a2  = 64, a5  = -12, (wrb) a2  <-- 52
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
          12478000    0x80004308 bgeu t1, a2, -144              #; t1  = 15, a2  = 52, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
          12479000    0x8000430c j -196                         #; goto 0x80004248
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
          12480000    0x80004248 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
          12481000    0x8000424c andi a3, a2, -16               #; a2  = 52, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
          12482000    0x80004250 andi a2, a2, 15                #; a2  = 52, (wrb) a2  <-- 4
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
          12483000    0x80004254 add a3, a3, a4                 #; a3  = 48, a4  = 0x100207b0, (wrb) a3  <-- 0x100207e0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          12512000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x100207b0, 0 ~~> Word[0x100207b0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          12552000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x100207b0, 0 ~~> Word[0x100207b4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          12592000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x100207b0, 0 ~~> Word[0x100207b8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          12632000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x100207b0, 0 ~~> Word[0x100207bc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          12633000    0x80004268 addi a4, a4, 16                #; a4  = 0x100207b0, (wrb) a4  <-- 0x100207c0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          12634000    0x8000426c bltu a4, a3, -20               #; a4  = 0x100207c0, a3  = 0x100207e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          12672000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x100207c0, 0 ~~> Word[0x100207c0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          12712000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x100207c0, 0 ~~> Word[0x100207c4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          12752000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x100207c0, 0 ~~> Word[0x100207c8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          12783000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x100207c0, 0 ~~> Word[0x100207cc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          12784000    0x80004268 addi a4, a4, 16                #; a4  = 0x100207c0, (wrb) a4  <-- 0x100207d0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          12785000    0x8000426c bltu a4, a3, -20               #; a4  = 0x100207d0, a3  = 0x100207e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          12822000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x100207d0, 0 ~~> Word[0x100207d0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          12853000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x100207d0, 0 ~~> Word[0x100207d4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          12892000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x100207d0, 0 ~~> Word[0x100207d8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          12923000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x100207d0, 0 ~~> Word[0x100207dc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          12924000    0x80004268 addi a4, a4, 16                #; a4  = 0x100207d0, (wrb) a4  <-- 0x100207e0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          12925000    0x8000426c bltu a4, a3, -20               #; a4  = 0x100207e0, a3  = 0x100207e0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
          12926000    0x80004270 bnez a2, 8                     #; a2  = 4, taken, goto 0x80004278
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
          12927000    0x80004278 sub a3, t1, a2                 #; t1  = 15, a2  = 4, (wrb) a3  <-- 11
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
          12928000    0x8000427c slli a3, a3, 2                 #; a3  = 11, (wrb) a3  <-- 44
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
          12929000    0x80004280 auipc t0, 0                    #; (wrb) t0  <-- 0x80004280
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
          12930000    0x80004284 add a3, a3, t0                 #; a3  = 44, t0  = 0x80004280, (wrb) a3  <-- 0x800042ac
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
          12931000    0x80004288 jr 12(a3)                      #; a3  = 0x800042ac, goto 0x800042b8
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          12962000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x100207e0, 0 ~~> Byte[0x100207e3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          12993000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x100207e0, 0 ~~> Byte[0x100207e2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          13032000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x100207e0, 0 ~~> Byte[0x100207e1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          13063000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x100207e0, 0 ~~> Byte[0x100207e0]
#; .Ltable (memset.S:85)
#;   ret
          13064000    0x800042c8 ret                            #; ra  = 0x80003f88, goto 0x80003f88
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
          13102000    0x80003f88 lw a0, 8(sp)                   #; sp  = 0x1001fb40, a0  <~~ Word[0x1001fb48]
          13143000                                              #; (lsu) a0  <-- 0x1001fb8c
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
          13144000    0x80003f8c add a0, a0, s7                 #; a0  = 0x1001fb8c, s7  = 4128, (wrb) a0  <-- 0x10020bac
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
          13145000    0x80003f90 li a1, 0                       #; (wrb) a1  <-- 0
          13146000    0x80003f94 mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
          13147000    0x80003f98 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f98
          13148000    0x80003f9c jalr 668(ra)                   #; ra  = 0x80003f98, (wrb) ra  <-- 0x80003fa0, goto 0x80004234
#; memset (memset.S:30)
#;   li t1, 15
          13149000    0x80004234 li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
          13150000    0x80004238 mv a4, a0                      #; a0  = 0x10020bac, (wrb) a4  <-- 0x10020bac
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
          13151000    0x8000423c bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
          13152000    0x80004240 andi a5, a4, 15                #; a4  = 0x10020bac, (wrb) a5  <-- 12
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
          13153000    0x80004244 bnez a5, 160                   #; a5  = 12, taken, goto 0x800042e4
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
          13154000    0x800042e4 slli a3, a5, 2                 #; a5  = 12, (wrb) a3  <-- 48
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
          13155000    0x800042e8 auipc t0, 0                    #; (wrb) t0  <-- 0x800042e8
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
          13156000    0x800042ec add a3, a3, t0                 #; a3  = 48, t0  = 0x800042e8, (wrb) a3  <-- 0x80004318
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
          13157000    0x800042f0 mv t0, ra                      #; ra  = 0x80003fa0, (wrb) t0  <-- 0x80003fa0
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
          13158000    0x800042f4 jalr -96(a3)                   #; a3  = 0x80004318, (wrb) ra  <-- 0x800042f8, goto 0x800042b8
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          13159000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x10020bac, 0 ~~> Byte[0x10020baf]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          13160000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x10020bac, 0 ~~> Byte[0x10020bae]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          13172000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x10020bac, 0 ~~> Byte[0x10020bad]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          13203000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x10020bac, 0 ~~> Byte[0x10020bac]
#; .Ltable (memset.S:85)
#;   ret
          13204000    0x800042c8 ret                            #; ra  = 0x800042f8, goto 0x800042f8
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
          13205000    0x800042f8 mv ra, t0                      #; t0  = 0x80003fa0, (wrb) ra  <-- 0x80003fa0
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
          13206000    0x800042fc addi a5, a5, -16               #; a5  = 12, (wrb) a5  <-- -4
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
          13207000    0x80004300 sub a4, a4, a5                 #; a4  = 0x10020bac, a5  = -4, (wrb) a4  <-- 0x10020bb0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
          13208000    0x80004304 add a2, a2, a5                 #; a2  = 64, a5  = -4, (wrb) a2  <-- 60
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
          13209000    0x80004308 bgeu t1, a2, -144              #; t1  = 15, a2  = 60, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
          13210000    0x8000430c j -196                         #; goto 0x80004248
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
          13211000    0x80004248 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
          13212000    0x8000424c andi a3, a2, -16               #; a2  = 60, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
          13213000    0x80004250 andi a2, a2, 15                #; a2  = 60, (wrb) a2  <-- 12
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
          13214000    0x80004254 add a3, a3, a4                 #; a3  = 48, a4  = 0x10020bb0, (wrb) a3  <-- 0x10020be0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          13242000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x10020bb0, 0 ~~> Word[0x10020bb0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          13273000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x10020bb0, 0 ~~> Word[0x10020bb4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          13312000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x10020bb0, 0 ~~> Word[0x10020bb8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          13343000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x10020bb0, 0 ~~> Word[0x10020bbc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          13344000    0x80004268 addi a4, a4, 16                #; a4  = 0x10020bb0, (wrb) a4  <-- 0x10020bc0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          13345000    0x8000426c bltu a4, a3, -20               #; a4  = 0x10020bc0, a3  = 0x10020be0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          13382000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x10020bc0, 0 ~~> Word[0x10020bc0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          13413000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x10020bc0, 0 ~~> Word[0x10020bc4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          13452000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x10020bc0, 0 ~~> Word[0x10020bc8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          13483000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x10020bc0, 0 ~~> Word[0x10020bcc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          13484000    0x80004268 addi a4, a4, 16                #; a4  = 0x10020bc0, (wrb) a4  <-- 0x10020bd0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          13485000    0x8000426c bltu a4, a3, -20               #; a4  = 0x10020bd0, a3  = 0x10020be0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          13522000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x10020bd0, 0 ~~> Word[0x10020bd0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          13553000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x10020bd0, 0 ~~> Word[0x10020bd4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          13592000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x10020bd0, 0 ~~> Word[0x10020bd8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          13623000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x10020bd0, 0 ~~> Word[0x10020bdc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          13624000    0x80004268 addi a4, a4, 16                #; a4  = 0x10020bd0, (wrb) a4  <-- 0x10020be0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          13625000    0x8000426c bltu a4, a3, -20               #; a4  = 0x10020be0, a3  = 0x10020be0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
          13626000    0x80004270 bnez a2, 8                     #; a2  = 12, taken, goto 0x80004278
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
          13627000    0x80004278 sub a3, t1, a2                 #; t1  = 15, a2  = 12, (wrb) a3  <-- 3
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
          13628000    0x8000427c slli a3, a3, 2                 #; a3  = 3, (wrb) a3  <-- 12
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
          13629000    0x80004280 auipc t0, 0                    #; (wrb) t0  <-- 0x80004280
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
          13630000    0x80004284 add a3, a3, t0                 #; a3  = 12, t0  = 0x80004280, (wrb) a3  <-- 0x8000428c
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
          13631000    0x80004288 jr 12(a3)                      #; a3  = 0x8000428c, goto 0x80004298
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
          13662000    0x80004298 sb a1, 11(a4)                  #; a4  = 0x10020be0, 0 ~~> Byte[0x10020beb]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
          13693000    0x8000429c sb a1, 10(a4)                  #; a4  = 0x10020be0, 0 ~~> Byte[0x10020bea]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
          13732000    0x800042a0 sb a1, 9(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be9]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
          13762000    0x800042a4 sb a1, 8(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be8]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
          13792000    0x800042a8 sb a1, 7(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be7]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
          13822000    0x800042ac sb a1, 6(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be6]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
          13852000    0x800042b0 sb a1, 5(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be5]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
          13882000    0x800042b4 sb a1, 4(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be4]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          13912000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          13942000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          13972000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          14002000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be0]
#; .Ltable (memset.S:85)
#;   ret
          14003000    0x800042c8 ret                            #; ra  = 0x80003fa0, goto 0x80003fa0
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
          14032000    0x80003fa0 lw a0, 8(sp)                   #; sp  = 0x1001fb40, a0  <~~ Word[0x1001fb48]
          14072000                                              #; (lsu) a0  <-- 0x1001fb8c
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
          14073000    0x80003fa4 add a0, a0, s8                 #; a0  = 0x1001fb8c, s8  = 5160, (wrb) a0  <-- 0x10020fb4
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
          14074000    0x80003fa8 li a1, 0                       #; (wrb) a1  <-- 0
          14075000    0x80003fac mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
          14076000    0x80003fb0 auipc ra, 0                    #; (wrb) ra  <-- 0x80003fb0
          14077000    0x80003fb4 jalr 644(ra)                   #; ra  = 0x80003fb0, (wrb) ra  <-- 0x80003fb8, goto 0x80004234
#; memset (memset.S:30)
#;   li t1, 15
          14078000    0x80004234 li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
          14079000    0x80004238 mv a4, a0                      #; a0  = 0x10020fb4, (wrb) a4  <-- 0x10020fb4
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
          14080000    0x8000423c bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
          14081000    0x80004240 andi a5, a4, 15                #; a4  = 0x10020fb4, (wrb) a5  <-- 4
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
          14082000    0x80004244 bnez a5, 160                   #; a5  = 4, taken, goto 0x800042e4
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
          14083000    0x800042e4 slli a3, a5, 2                 #; a5  = 4, (wrb) a3  <-- 16
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
          14084000    0x800042e8 auipc t0, 0                    #; (wrb) t0  <-- 0x800042e8
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
          14085000    0x800042ec add a3, a3, t0                 #; a3  = 16, t0  = 0x800042e8, (wrb) a3  <-- 0x800042f8
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
          14086000    0x800042f0 mv t0, ra                      #; ra  = 0x80003fb8, (wrb) t0  <-- 0x80003fb8
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
          14087000    0x800042f4 jalr -96(a3)                   #; a3  = 0x800042f8, (wrb) ra  <-- 0x800042f8, goto 0x80004298
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
          14088000    0x80004298 sb a1, 11(a4)                  #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fbf]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
          14089000    0x8000429c sb a1, 10(a4)                  #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fbe]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
          14113000    0x800042a0 sb a1, 9(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fbd]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
          14143000    0x800042a4 sb a1, 8(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fbc]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
          14173000    0x800042a8 sb a1, 7(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fbb]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
          14203000    0x800042ac sb a1, 6(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fba]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
          14233000    0x800042b0 sb a1, 5(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fb9]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
          14263000    0x800042b4 sb a1, 4(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fb8]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          14292000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fb7]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          14322000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fb6]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          14343000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fb5]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          14373000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fb4]
#; .Ltable (memset.S:85)
#;   ret
          14374000    0x800042c8 ret                            #; ra  = 0x800042f8, goto 0x800042f8
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
          14375000    0x800042f8 mv ra, t0                      #; t0  = 0x80003fb8, (wrb) ra  <-- 0x80003fb8
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
          14376000    0x800042fc addi a5, a5, -16               #; a5  = 4, (wrb) a5  <-- -12
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
          14377000    0x80004300 sub a4, a4, a5                 #; a4  = 0x10020fb4, a5  = -12, (wrb) a4  <-- 0x10020fc0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
          14378000    0x80004304 add a2, a2, a5                 #; a2  = 64, a5  = -12, (wrb) a2  <-- 52
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
          14379000    0x80004308 bgeu t1, a2, -144              #; t1  = 15, a2  = 52, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
          14380000    0x8000430c j -196                         #; goto 0x80004248
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
          14381000    0x80004248 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
          14382000    0x8000424c andi a3, a2, -16               #; a2  = 52, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
          14383000    0x80004250 andi a2, a2, 15                #; a2  = 52, (wrb) a2  <-- 4
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
          14384000    0x80004254 add a3, a3, a4                 #; a3  = 48, a4  = 0x10020fc0, (wrb) a3  <-- 0x10020ff0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          14403000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x10020fc0, 0 ~~> Word[0x10020fc0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          14433000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x10020fc0, 0 ~~> Word[0x10020fc4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          14462000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x10020fc0, 0 ~~> Word[0x10020fc8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          14483000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x10020fc0, 0 ~~> Word[0x10020fcc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          14484000    0x80004268 addi a4, a4, 16                #; a4  = 0x10020fc0, (wrb) a4  <-- 0x10020fd0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          14485000    0x8000426c bltu a4, a3, -20               #; a4  = 0x10020fd0, a3  = 0x10020ff0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          14517000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x10020fd0, 0 ~~> Word[0x10020fd0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          14542000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x10020fd0, 0 ~~> Word[0x10020fd4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          14567000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x10020fd0, 0 ~~> Word[0x10020fd8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          14592000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x10020fd0, 0 ~~> Word[0x10020fdc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          14593000    0x80004268 addi a4, a4, 16                #; a4  = 0x10020fd0, (wrb) a4  <-- 0x10020fe0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          14594000    0x8000426c bltu a4, a3, -20               #; a4  = 0x10020fe0, a3  = 0x10020ff0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          14617000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x10020fe0, 0 ~~> Word[0x10020fe0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          14642000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x10020fe0, 0 ~~> Word[0x10020fe4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          14667000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x10020fe0, 0 ~~> Word[0x10020fe8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          14692000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x10020fe0, 0 ~~> Word[0x10020fec]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          14693000    0x80004268 addi a4, a4, 16                #; a4  = 0x10020fe0, (wrb) a4  <-- 0x10020ff0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          14694000    0x8000426c bltu a4, a3, -20               #; a4  = 0x10020ff0, a3  = 0x10020ff0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
          14695000    0x80004270 bnez a2, 8                     #; a2  = 4, taken, goto 0x80004278
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
          14696000    0x80004278 sub a3, t1, a2                 #; t1  = 15, a2  = 4, (wrb) a3  <-- 11
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
          14697000    0x8000427c slli a3, a3, 2                 #; a3  = 11, (wrb) a3  <-- 44
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
          14698000    0x80004280 auipc t0, 0                    #; (wrb) t0  <-- 0x80004280
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
          14699000    0x80004284 add a3, a3, t0                 #; a3  = 44, t0  = 0x80004280, (wrb) a3  <-- 0x800042ac
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
          14700000    0x80004288 jr 12(a3)                      #; a3  = 0x800042ac, goto 0x800042b8
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          14717000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x10020ff0, 0 ~~> Byte[0x10020ff3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          14742000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x10020ff0, 0 ~~> Byte[0x10020ff2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          14767000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x10020ff0, 0 ~~> Byte[0x10020ff1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          14792000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x10020ff0, 0 ~~> Byte[0x10020ff0]
#; .Ltable (memset.S:85)
#;   ret
          14793000    0x800042c8 ret                            #; ra  = 0x80003fb8, goto 0x80003fb8
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
          14817000    0x80003fb8 lw a0, 8(sp)                   #; sp  = 0x1001fb40, a0  <~~ Word[0x1001fb48]
          14855000                                              #; (lsu) a0  <-- 0x1001fb8c
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
          14856000    0x80003fbc add a0, a0, s9                 #; a0  = 0x1001fb8c, s9  = 6192, (wrb) a0  <-- 0x100213bc
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
          14859000    0x80003fc0 li a1, 0                       #; (wrb) a1  <-- 0
          14860000    0x80003fc4 mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
          14861000    0x80003fc8 auipc ra, 0                    #; (wrb) ra  <-- 0x80003fc8
          14862000    0x80003fcc jalr 620(ra)                   #; ra  = 0x80003fc8, (wrb) ra  <-- 0x80003fd0, goto 0x80004234
#; memset (memset.S:30)
#;   li t1, 15
          14863000    0x80004234 li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
          14864000    0x80004238 mv a4, a0                      #; a0  = 0x100213bc, (wrb) a4  <-- 0x100213bc
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
          14865000    0x8000423c bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
          14866000    0x80004240 andi a5, a4, 15                #; a4  = 0x100213bc, (wrb) a5  <-- 12
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
          14867000    0x80004244 bnez a5, 160                   #; a5  = 12, taken, goto 0x800042e4
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
          14868000    0x800042e4 slli a3, a5, 2                 #; a5  = 12, (wrb) a3  <-- 48
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
          14869000    0x800042e8 auipc t0, 0                    #; (wrb) t0  <-- 0x800042e8
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
          14870000    0x800042ec add a3, a3, t0                 #; a3  = 48, t0  = 0x800042e8, (wrb) a3  <-- 0x80004318
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
          14871000    0x800042f0 mv t0, ra                      #; ra  = 0x80003fd0, (wrb) t0  <-- 0x80003fd0
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
          14872000    0x800042f4 jalr -96(a3)                   #; a3  = 0x80004318, (wrb) ra  <-- 0x800042f8, goto 0x800042b8
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          14873000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x100213bc, 0 ~~> Byte[0x100213bf]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          14874000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x100213bc, 0 ~~> Byte[0x100213be]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          14890000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x100213bc, 0 ~~> Byte[0x100213bd]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          14915000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x100213bc, 0 ~~> Byte[0x100213bc]
#; .Ltable (memset.S:85)
#;   ret
          14916000    0x800042c8 ret                            #; ra  = 0x800042f8, goto 0x800042f8
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
          14917000    0x800042f8 mv ra, t0                      #; t0  = 0x80003fd0, (wrb) ra  <-- 0x80003fd0
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
          14918000    0x800042fc addi a5, a5, -16               #; a5  = 12, (wrb) a5  <-- -4
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
          14921000    0x80004300 sub a4, a4, a5                 #; a4  = 0x100213bc, a5  = -4, (wrb) a4  <-- 0x100213c0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
          14922000    0x80004304 add a2, a2, a5                 #; a2  = 64, a5  = -4, (wrb) a2  <-- 60
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
          14923000    0x80004308 bgeu t1, a2, -144              #; t1  = 15, a2  = 60, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
          14924000    0x8000430c j -196                         #; goto 0x80004248
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
          14925000    0x80004248 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
          14926000    0x8000424c andi a3, a2, -16               #; a2  = 60, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
          14927000    0x80004250 andi a2, a2, 15                #; a2  = 60, (wrb) a2  <-- 12
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
          14928000    0x80004254 add a3, a3, a4                 #; a3  = 48, a4  = 0x100213c0, (wrb) a3  <-- 0x100213f0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          14940000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x100213c0, 0 ~~> Word[0x100213c0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          14965000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x100213c0, 0 ~~> Word[0x100213c4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          14990000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x100213c0, 0 ~~> Word[0x100213c8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          15015000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x100213c0, 0 ~~> Word[0x100213cc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          15016000    0x80004268 addi a4, a4, 16                #; a4  = 0x100213c0, (wrb) a4  <-- 0x100213d0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          15017000    0x8000426c bltu a4, a3, -20               #; a4  = 0x100213d0, a3  = 0x100213f0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          15032000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x100213d0, 0 ~~> Word[0x100213d0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          15054000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x100213d0, 0 ~~> Word[0x100213d4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          15074000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x100213d0, 0 ~~> Word[0x100213d8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          15096000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x100213d0, 0 ~~> Word[0x100213dc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          15097000    0x80004268 addi a4, a4, 16                #; a4  = 0x100213d0, (wrb) a4  <-- 0x100213e0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          15098000    0x8000426c bltu a4, a3, -20               #; a4  = 0x100213e0, a3  = 0x100213f0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          15118000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x100213e0, 0 ~~> Word[0x100213e0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          15140000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x100213e0, 0 ~~> Word[0x100213e4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          15154000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x100213e0, 0 ~~> Word[0x100213e8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          15174000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x100213e0, 0 ~~> Word[0x100213ec]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          15175000    0x80004268 addi a4, a4, 16                #; a4  = 0x100213e0, (wrb) a4  <-- 0x100213f0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          15176000    0x8000426c bltu a4, a3, -20               #; a4  = 0x100213f0, a3  = 0x100213f0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
          15177000    0x80004270 bnez a2, 8                     #; a2  = 12, taken, goto 0x80004278
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
          15178000    0x80004278 sub a3, t1, a2                 #; t1  = 15, a2  = 12, (wrb) a3  <-- 3
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
          15179000    0x8000427c slli a3, a3, 2                 #; a3  = 3, (wrb) a3  <-- 12
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
          15180000    0x80004280 auipc t0, 0                    #; (wrb) t0  <-- 0x80004280
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
          15181000    0x80004284 add a3, a3, t0                 #; a3  = 12, t0  = 0x80004280, (wrb) a3  <-- 0x8000428c
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
          15182000    0x80004288 jr 12(a3)                      #; a3  = 0x8000428c, goto 0x80004298
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
          15188000    0x80004298 sb a1, 11(a4)                  #; a4  = 0x100213f0, 0 ~~> Byte[0x100213fb]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
          15202000    0x8000429c sb a1, 10(a4)                  #; a4  = 0x100213f0, 0 ~~> Byte[0x100213fa]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
          15216000    0x800042a0 sb a1, 9(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f9]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
          15230000    0x800042a4 sb a1, 8(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f8]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
          15244000    0x800042a8 sb a1, 7(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f7]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
          15258000    0x800042ac sb a1, 6(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f6]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
          15272000    0x800042b0 sb a1, 5(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f5]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
          15286000    0x800042b4 sb a1, 4(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f4]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          15300000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          15314000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          15328000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          15342000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f0]
#; .Ltable (memset.S:85)
#;   ret
          15343000    0x800042c8 ret                            #; ra  = 0x80003fd0, goto 0x80003fd0
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
          15356000    0x80003fd0 lw a0, 8(sp)                   #; sp  = 0x1001fb40, a0  <~~ Word[0x1001fb48]
          15377000                                              #; (lsu) a0  <-- 0x1001fb8c
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
          15378000    0x80003fd4 add a0, a0, s10                #; a0  = 0x1001fb8c, s10 = 7224, (wrb) a0  <-- 0x100217c4
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
          15379000    0x80003fd8 li a1, 0                       #; (wrb) a1  <-- 0
          15380000    0x80003fdc mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
          15381000    0x80003fe0 auipc ra, 0                    #; (wrb) ra  <-- 0x80003fe0
          15382000    0x80003fe4 jalr 596(ra)                   #; ra  = 0x80003fe0, (wrb) ra  <-- 0x80003fe8, goto 0x80004234
#; memset (memset.S:30)
#;   li t1, 15
          15383000    0x80004234 li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
          15384000    0x80004238 mv a4, a0                      #; a0  = 0x100217c4, (wrb) a4  <-- 0x100217c4
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
          15385000    0x8000423c bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
          15386000    0x80004240 andi a5, a4, 15                #; a4  = 0x100217c4, (wrb) a5  <-- 4
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
          15387000    0x80004244 bnez a5, 160                   #; a5  = 4, taken, goto 0x800042e4
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
          15388000    0x800042e4 slli a3, a5, 2                 #; a5  = 4, (wrb) a3  <-- 16
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
          15389000    0x800042e8 auipc t0, 0                    #; (wrb) t0  <-- 0x800042e8
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
          15390000    0x800042ec add a3, a3, t0                 #; a3  = 16, t0  = 0x800042e8, (wrb) a3  <-- 0x800042f8
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
          15391000    0x800042f0 mv t0, ra                      #; ra  = 0x80003fe8, (wrb) t0  <-- 0x80003fe8
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
          15392000    0x800042f4 jalr -96(a3)                   #; a3  = 0x800042f8, (wrb) ra  <-- 0x800042f8, goto 0x80004298
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
          15393000    0x80004298 sb a1, 11(a4)                  #; a4  = 0x100217c4, 0 ~~> Byte[0x100217cf]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
          15394000    0x8000429c sb a1, 10(a4)                  #; a4  = 0x100217c4, 0 ~~> Byte[0x100217ce]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
          15405000    0x800042a0 sb a1, 9(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217cd]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
          15419000    0x800042a4 sb a1, 8(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217cc]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
          15433000    0x800042a8 sb a1, 7(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217cb]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
          15447000    0x800042ac sb a1, 6(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217ca]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
          15461000    0x800042b0 sb a1, 5(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217c9]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
          15470000    0x800042b4 sb a1, 4(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217c8]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          15482000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217c7]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          15491000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217c6]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          15503000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217c5]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          15512000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217c4]
#; .Ltable (memset.S:85)
#;   ret
          15513000    0x800042c8 ret                            #; ra  = 0x800042f8, goto 0x800042f8
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
          15514000    0x800042f8 mv ra, t0                      #; t0  = 0x80003fe8, (wrb) ra  <-- 0x80003fe8
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
          15515000    0x800042fc addi a5, a5, -16               #; a5  = 4, (wrb) a5  <-- -12
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
          15516000    0x80004300 sub a4, a4, a5                 #; a4  = 0x100217c4, a5  = -12, (wrb) a4  <-- 0x100217d0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
          15517000    0x80004304 add a2, a2, a5                 #; a2  = 64, a5  = -12, (wrb) a2  <-- 52
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
          15518000    0x80004308 bgeu t1, a2, -144              #; t1  = 15, a2  = 52, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
          15519000    0x8000430c j -196                         #; goto 0x80004248
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
          15520000    0x80004248 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
          15521000    0x8000424c andi a3, a2, -16               #; a2  = 52, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
          15522000    0x80004250 andi a2, a2, 15                #; a2  = 52, (wrb) a2  <-- 4
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
          15523000    0x80004254 add a3, a3, a4                 #; a3  = 48, a4  = 0x100217d0, (wrb) a3  <-- 0x10021800
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          15524000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x100217d0, 0 ~~> Word[0x100217d0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          15531000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x100217d0, 0 ~~> Word[0x100217d4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          15538000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x100217d0, 0 ~~> Word[0x100217d8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          15545000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x100217d0, 0 ~~> Word[0x100217dc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          15546000    0x80004268 addi a4, a4, 16                #; a4  = 0x100217d0, (wrb) a4  <-- 0x100217e0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          15547000    0x8000426c bltu a4, a3, -20               #; a4  = 0x100217e0, a3  = 0x10021800, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          15554000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x100217e0, 0 ~~> Word[0x100217e0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          15566000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x100217e0, 0 ~~> Word[0x100217e4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          15575000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x100217e0, 0 ~~> Word[0x100217e8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          15587000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x100217e0, 0 ~~> Word[0x100217ec]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          15588000    0x80004268 addi a4, a4, 16                #; a4  = 0x100217e0, (wrb) a4  <-- 0x100217f0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          15589000    0x8000426c bltu a4, a3, -20               #; a4  = 0x100217f0, a3  = 0x10021800, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          15596000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x100217f0, 0 ~~> Word[0x100217f0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          15608000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x100217f0, 0 ~~> Word[0x100217f4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          15617000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x100217f0, 0 ~~> Word[0x100217f8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          15629000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x100217f0, 0 ~~> Word[0x100217fc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          15630000    0x80004268 addi a4, a4, 16                #; a4  = 0x100217f0, (wrb) a4  <-- 0x10021800
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          15631000    0x8000426c bltu a4, a3, -20               #; a4  = 0x10021800, a3  = 0x10021800, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
          15632000    0x80004270 bnez a2, 8                     #; a2  = 4, taken, goto 0x80004278
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
          15633000    0x80004278 sub a3, t1, a2                 #; t1  = 15, a2  = 4, (wrb) a3  <-- 11
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
          15634000    0x8000427c slli a3, a3, 2                 #; a3  = 11, (wrb) a3  <-- 44
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
          15635000    0x80004280 auipc t0, 0                    #; (wrb) t0  <-- 0x80004280
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
          15636000    0x80004284 add a3, a3, t0                 #; a3  = 44, t0  = 0x80004280, (wrb) a3  <-- 0x800042ac
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
          15637000    0x80004288 jr 12(a3)                      #; a3  = 0x800042ac, goto 0x800042b8
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          15638000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x10021800, 0 ~~> Byte[0x10021803]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          15650000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x10021800, 0 ~~> Byte[0x10021802]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          15659000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x10021800, 0 ~~> Byte[0x10021801]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          15671000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x10021800, 0 ~~> Byte[0x10021800]
#; .Ltable (memset.S:85)
#;   ret
          15672000    0x800042c8 ret                            #; ra  = 0x80003fe8, goto 0x80003fe8
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
          15680000    0x80003fe8 lw a0, 8(sp)                   #; sp  = 0x1001fb40, a0  <~~ Word[0x1001fb48]
          15699000                                              #; (lsu) a0  <-- 0x1001fb8c
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
          15700000    0x80003fec add a0, a0, s11                #; a0  = 0x1001fb8c, s11 = 8256, (wrb) a0  <-- 0x10021bcc
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
          15701000    0x80003ff0 li a1, 0                       #; (wrb) a1  <-- 0
          15702000    0x80003ff4 mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
          15703000    0x80003ff8 auipc ra, 0                    #; (wrb) ra  <-- 0x80003ff8
          15704000    0x80003ffc jalr 572(ra)                   #; ra  = 0x80003ff8, (wrb) ra  <-- 0x80004000, goto 0x80004234
#; memset (memset.S:30)
#;   li t1, 15
          15705000    0x80004234 li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
          15706000    0x80004238 mv a4, a0                      #; a0  = 0x10021bcc, (wrb) a4  <-- 0x10021bcc
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
          15707000    0x8000423c bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
          15708000    0x80004240 andi a5, a4, 15                #; a4  = 0x10021bcc, (wrb) a5  <-- 12
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
          15709000    0x80004244 bnez a5, 160                   #; a5  = 12, taken, goto 0x800042e4
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
          15710000    0x800042e4 slli a3, a5, 2                 #; a5  = 12, (wrb) a3  <-- 48
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
          15711000    0x800042e8 auipc t0, 0                    #; (wrb) t0  <-- 0x800042e8
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
          15712000    0x800042ec add a3, a3, t0                 #; a3  = 48, t0  = 0x800042e8, (wrb) a3  <-- 0x80004318
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
          15713000    0x800042f0 mv t0, ra                      #; ra  = 0x80004000, (wrb) t0  <-- 0x80004000
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
          15714000    0x800042f4 jalr -96(a3)                   #; a3  = 0x80004318, (wrb) ra  <-- 0x800042f8, goto 0x800042b8
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          15715000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x10021bcc, 0 ~~> Byte[0x10021bcf]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          15716000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x10021bcc, 0 ~~> Byte[0x10021bce]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          15722000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x10021bcc, 0 ~~> Byte[0x10021bcd]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          15734000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x10021bcc, 0 ~~> Byte[0x10021bcc]
#; .Ltable (memset.S:85)
#;   ret
          15735000    0x800042c8 ret                            #; ra  = 0x800042f8, goto 0x800042f8
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
          15736000    0x800042f8 mv ra, t0                      #; t0  = 0x80004000, (wrb) ra  <-- 0x80004000
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
          15737000    0x800042fc addi a5, a5, -16               #; a5  = 12, (wrb) a5  <-- -4
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
          15738000    0x80004300 sub a4, a4, a5                 #; a4  = 0x10021bcc, a5  = -4, (wrb) a4  <-- 0x10021bd0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
          15739000    0x80004304 add a2, a2, a5                 #; a2  = 64, a5  = -4, (wrb) a2  <-- 60
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
          15740000    0x80004308 bgeu t1, a2, -144              #; t1  = 15, a2  = 60, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
          15741000    0x8000430c j -196                         #; goto 0x80004248
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
          15742000    0x80004248 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
          15743000    0x8000424c andi a3, a2, -16               #; a2  = 60, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
          15744000    0x80004250 andi a2, a2, 15                #; a2  = 60, (wrb) a2  <-- 12
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
          15745000    0x80004254 add a3, a3, a4                 #; a3  = 48, a4  = 0x10021bd0, (wrb) a3  <-- 0x10021c00
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          15746000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x10021bd0, 0 ~~> Word[0x10021bd0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          15755000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x10021bd0, 0 ~~> Word[0x10021bd4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          15762000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x10021bd0, 0 ~~> Word[0x10021bd8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          15769000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x10021bd0, 0 ~~> Word[0x10021bdc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          15770000    0x80004268 addi a4, a4, 16                #; a4  = 0x10021bd0, (wrb) a4  <-- 0x10021be0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          15771000    0x8000426c bltu a4, a3, -20               #; a4  = 0x10021be0, a3  = 0x10021c00, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          15776000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x10021be0, 0 ~~> Word[0x10021be0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          15783000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x10021be0, 0 ~~> Word[0x10021be4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          15790000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x10021be0, 0 ~~> Word[0x10021be8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          15797000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x10021be0, 0 ~~> Word[0x10021bec]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          15798000    0x80004268 addi a4, a4, 16                #; a4  = 0x10021be0, (wrb) a4  <-- 0x10021bf0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          15799000    0x8000426c bltu a4, a3, -20               #; a4  = 0x10021bf0, a3  = 0x10021c00, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          15804000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x10021bf0, 0 ~~> Word[0x10021bf0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          15806000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x10021bf0, 0 ~~> Word[0x10021bf4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          15811000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x10021bf0, 0 ~~> Word[0x10021bf8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          15813000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x10021bf0, 0 ~~> Word[0x10021bfc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          15814000    0x80004268 addi a4, a4, 16                #; a4  = 0x10021bf0, (wrb) a4  <-- 0x10021c00
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          15815000    0x8000426c bltu a4, a3, -20               #; a4  = 0x10021c00, a3  = 0x10021c00, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
          15816000    0x80004270 bnez a2, 8                     #; a2  = 12, taken, goto 0x80004278
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
          15817000    0x80004278 sub a3, t1, a2                 #; t1  = 15, a2  = 12, (wrb) a3  <-- 3
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
          15818000    0x8000427c slli a3, a3, 2                 #; a3  = 3, (wrb) a3  <-- 12
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
          15819000    0x80004280 auipc t0, 0                    #; (wrb) t0  <-- 0x80004280
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
          15820000    0x80004284 add a3, a3, t0                 #; a3  = 12, t0  = 0x80004280, (wrb) a3  <-- 0x8000428c
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
          15821000    0x80004288 jr 12(a3)                      #; a3  = 0x8000428c, goto 0x80004298
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
          15822000    0x80004298 sb a1, 11(a4)                  #; a4  = 0x10021c00, 0 ~~> Byte[0x10021c0b]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
          15823000    0x8000429c sb a1, 10(a4)                  #; a4  = 0x10021c00, 0 ~~> Byte[0x10021c0a]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
          15825000    0x800042a0 sb a1, 9(a4)                   #; a4  = 0x10021c00, 0 ~~> Byte[0x10021c09]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
          15832000    0x800042a4 sb a1, 8(a4)                   #; a4  = 0x10021c00, 0 ~~> Byte[0x10021c08]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
          15839000    0x800042a8 sb a1, 7(a4)                   #; a4  = 0x10021c00, 0 ~~> Byte[0x10021c07]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
          15846000    0x800042ac sb a1, 6(a4)                   #; a4  = 0x10021c00, 0 ~~> Byte[0x10021c06]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
          15853000    0x800042b0 sb a1, 5(a4)                   #; a4  = 0x10021c00, 0 ~~> Byte[0x10021c05]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
          15860000    0x800042b4 sb a1, 4(a4)                   #; a4  = 0x10021c00, 0 ~~> Byte[0x10021c04]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          15867000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x10021c00, 0 ~~> Byte[0x10021c03]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          15874000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x10021c00, 0 ~~> Byte[0x10021c02]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          15881000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x10021c00, 0 ~~> Byte[0x10021c01]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          15888000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x10021c00, 0 ~~> Byte[0x10021c00]
#; .Ltable (memset.S:85)
#;   ret
          15889000    0x800042c8 ret                            #; ra  = 0x80004000, goto 0x80004000
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:85:5)
#;     snrt_cluster_hw_barrier (sync.h:174:5)
#;       asm volatile("csrr x0, 0x7C2" ::: "memory");
#;       ^
          15892000    0x80004000 csrr zero, 1986                #; csr@7c2 = 0
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
          15995000    0x80004090 add s0, a3, tp                 #; a3  = 0, tp  = 0x1001fb80, (wrb) s0  <-- 0x1001fb80
          15996000    0x80004094 sw a1, 64(s0)                  #; s0  = 0x1001fb80, 0x1001ffe0 ~~> Word[0x1001fbc0]
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
          16030000    0x800040a8 bltu s5, a3, 84                #; s5  = 1, a3  = 8, taken, goto 0x800040fc
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:189:5)
#;     snrt_alloc_init (alloc.h:131:5)
#;       snrt_cluster_hw_barrier (sync.h:174:5)
#;         asm volatile("csrr x0, 0x7C2" ::: "memory");
#;         ^
          16041000    0x800040fc csrr zero, 1986                #; csr@7c2 = 0
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
          16079000    0x8000410c add a3, a3, tp                 #; a3  = 0, tp  = 0x1001fb80, (wrb) a3  <-- 0x1001fb80
          16080000    0x80004110 sw zero, 20(a3)                #; a3  = 0x1001fb80, 0 ~~> Word[0x1001fb94]
          16081000    0x80004114 sw a2, 16(a3)                  #; a3  = 0x1001fb80, 0x10000000 ~~> Word[0x1001fb90]
          16082000    0x80004118 addi a3, a3, 16                #; a3  = 0x1001fb80, (wrb) a3  <-- 0x1001fb90
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:190:5)
#;     snrt_l1_init (alloc_v2.h:119:33)
#;       snrt_l1_allocator_v2()->end = heap_end_addr;
#;                                   ^
          16083000    0x8000411c sw zero, 12(a3)                #; a3  = 0x1001fb90, 0 ~~> Word[0x1001fb9c]
          16084000    0x80004120 lui a4, 65566                  #; (wrb) a4  <-- 0x1001e000
          16085000    0x80004124 addi a4, a4, -1152             #; a4  = 0x1001e000, (wrb) a4  <-- 0x1001db80
          16086000    0x80004128 add a0, a0, a4                 #; a0  = -32, a4  = 0x1001db80, (wrb) a0  <-- 0x1001db60
          16087000    0x8000412c sw a0, 8(a3)                   #; a3  = 0x1001fb90, 0x1001db60 ~~> Word[0x1001fb98]
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:190:5)
#;     snrt_l1_init (alloc_v2.h:120:34)
#;       snrt_l1_allocator_v2()->next = snrt_l1_allocator_v2()->base;
#;                                    ^
          16088000    0x80004130 sw zero, 20(a3)                #; a3  = 0x1001fb90, 0 ~~> Word[0x1001fba4]
          16089000    0x80004134 sw a2, 16(a3)                  #; a3  = 0x1001fb90, 0x10000000 ~~> Word[0x1001fba0]
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:191:5)
#;     snrt_l3_init (alloc_v2.h:184:34)
#;       snrt_l3_allocator_v2()->base =
#;                                    ^
          16090000    0x80004138 lui a0, 0                      #; (wrb) a0  <-- 0
          16091000    0x8000413c add a0, a0, tp                 #; a0  = 0, tp  = 0x1001fb80, (wrb) a0  <-- 0x1001fb80
          16102000    0x80004140 sw zero, 44(a0)                #; a0  = 0x1001fb80, 0 ~~> Word[0x1001fbac]
          16103000    0x80004144 addi a1, a1, 7                 #; a1  = 0x80008968, (wrb) a1  <-- 0x8000896f
          16104000    0x80004148 andi a1, a1, -8                #; a1  = 0x8000896f, (wrb) a1  <-- 0x80008968
          16105000    0x8000414c sw a1, 40(a0)                  #; a0  = 0x1001fb80, 0x80008968 ~~> Word[0x1001fba8]
          16106000    0x80004150 addi a0, a0, 40                #; a0  = 0x1001fb80, (wrb) a0  <-- 0x1001fba8
          16107000    0x80004154 li a2, 1                       #; (wrb) a2  <-- 1
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:191:5)
#;     snrt_l3_init (alloc_v2.h:186:33)
#;       snrt_l3_allocator_v2()->end = SNRT_L3_END_ADDR;
#;                                   ^
          16108000    0x80004158 sw a2, 12(a0)                  #; a0  = 0x1001fba8, 1 ~~> Word[0x1001fbb4]
          16109000    0x8000415c sw zero, 8(a0)                 #; a0  = 0x1001fba8, 0 ~~> Word[0x1001fbb0]
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:191:5)
#;     snrt_l3_init (alloc_v2.h:187:34)
#;       snrt_l3_allocator_v2()->next = snrt_l3_allocator_v2()->base;
#;                                    ^
          16110000    0x80004160 sw zero, 20(a0)                #; a0  = 0x1001fba8, 0 ~~> Word[0x1001fbbc]
          16111000    0x80004164 sw a1, 16(a0)                  #; a0  = 0x1001fba8, 0x80008968 ~~> Word[0x1001fbb8]
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:192:5)
#;     snrt_comm_init (sync.h:37:48)
#;       inline void snrt_comm_init() { snrt_comm_world = &snrt_comm_world_info; }
#;                                                      ^
          16112000    0x80004168 lui a0, 0                      #; (wrb) a0  <-- 0
          16113000    0x8000416c add a0, a0, tp                 #; a0  = 0, tp  = 0x1001fb80, (wrb) a0  <-- 0x1001fb80
          16114000    0x80004170 lui a1, 0                      #; (wrb) a1  <-- 0
          16115000    0x80004174 add a1, a1, tp                 #; a1  = 0, tp  = 0x1001fb80, (wrb) a1  <-- 0x1001fb80
          16116000    0x80004178 mv a1, a1                      #; a1  = 0x1001fb80, (wrb) a1  <-- 0x1001fb80
          16117000    0x8000417c sw a1, 76(a0)                  #; a0  = 0x1001fb80, 0x1001fb80 ~~> Word[0x1001fbcc]
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
          16142000    0x80000698 addi sp, sp, -80               #; sp  = 0x1001fb40, (wrb) sp  <-- 0x1001faf0
#; main (matmul_i32.c:76:26)
#;   snrt_cluster_core_idx (team.h:108:12)
#;     snrt_global_core_idx (team.h:80:12)
#;       snrt_hartid (team.h:25:5)
#;         asm("csrr %0, mhartid" : "=r"(hartid));
#;         ^
          16143000    0x8000069c sw ra, 76(sp)                  #; sp  = 0x1001faf0, 0x8000418c ~~> Word[0x1001fb3c]
          16144000    0x800006a0 sw s0, 72(sp)                  #; sp  = 0x1001faf0, 0x1001fb80 ~~> Word[0x1001fb38]
          16145000    0x800006a4 sw s1, 68(sp)                  #; sp  = 0x1001faf0, 2064 ~~> Word[0x1001fb34]
          16146000    0x800006a8 sw s2, 64(sp)                  #; sp  = 0x1001faf0, 1 ~~> Word[0x1001fb30]
          16147000    0x800006ac sw s3, 60(sp)                  #; sp  = 0x1001faf0, 0 ~~> Word[0x1001fb2c]
          16148000    0x800006b0 sw s4, 56(sp)                  #; sp  = 0x1001faf0, 0 ~~> Word[0x1001fb28]
          16149000    0x800006b4 sw s5, 52(sp)                  #; sp  = 0x1001faf0, 1 ~~> Word[0x1001fb24]
          16150000    0x800006b8 sw s6, 48(sp)                  #; sp  = 0x1001faf0, 0x80005ed8 ~~> Word[0x1001fb20]
          16151000    0x800006bc sw s7, 44(sp)                  #; sp  = 0x1001faf0, 0x80005ed8 ~~> Word[0x1001fb1c]
          16162000    0x800006c0 sw s8, 40(sp)                  #; sp  = 0x1001faf0, 0x80005ef8 ~~> Word[0x1001fb18]
          16163000    0x800006c4 sw s9, 36(sp)                  #; sp  = 0x1001faf0, 6192 ~~> Word[0x1001fb14]
          16164000    0x800006c8 sw s10, 32(sp)                 #; sp  = 0x1001faf0, 7224 ~~> Word[0x1001fb10]
          16165000    0x800006cc sw s11, 28(sp)                 #; sp  = 0x1001faf0, 8256 ~~> Word[0x1001fb0c]
          16166000    0x800006d0 csrr a0, mhartid               #; mhartid = 1, (wrb) a0  <-- 1
          16167000    0x800006d4 lui a1, 233017                 #; (wrb) a1  <-- 0x38e39000
          16168000    0x800006d8 addi a1, a1, -455              #; a1  = 0x38e39000, (wrb) a1  <-- 0x38e38e39
#; main (matmul_i32.c:107:9)
#;   snrt_stop_perf_counter (perf_cnt.h:54:5)
#;     snrt_perf_counters (perf_cnt.h:23:14)
#;       snrt_cluster (snitch_cluster_memory.h:23:48)
#;         snrt_cluster_idx (team.h:99:35)
#;           return snrt_global_core_idx() / snrt_cluster_core_num();
#;                                         ^
          16169000    0x800006dc mulhu a1, a0, a1               #; a0  = 1, a1  = 0x38e38e39
          16171000                                              #; (acc) a1  <-- 0
          16172000    0x800006e0 srli s2, a1, 1                 #; a1  = 0, (wrb) s2  <-- 0
          16173000    0x800006e4 slli a1, s2, 3                 #; s2  = 0, (wrb) a1  <-- 0
          16174000    0x800006e8 add a1, a1, s2                 #; a1  = 0, s2  = 0, (wrb) a1  <-- 0
          16175000    0x800006ec sub a0, a0, a1                 #; a0  = 1, a1  = 0, (wrb) a0  <-- 1
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
          16194000    0x8000070c sw s1, 16(sp)                  #; sp  = 0x1001faf0, 0x800060c8 ~~> Word[0x1001fb00]
          16195000    0x80000710 sw s2, 12(sp)                  #; sp  = 0x1001faf0, 0 ~~> Word[0x1001fafc]
          16196000    0x80000714 sw a0, 20(sp)                  #; sp  = 0x1001faf0, 1 ~~> Word[0x1001fb04]
          16197000    0x80000718 beqz a0, 432                   #; a0  = 1, not taken
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
          22632000    0x80000728 andi a2, a0, 7                 #; a0  = 1, (wrb) a2  <-- 1
#; .LBB2_46 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:88:23)
#;     for (uint32_t i = 2 * (id / c); i < M; i += 2 * (numThreads / c)) {
#;                         ^
          22633000    0x8000072c srli a1, a0, 2                 #; a0  = 1, (wrb) a1  <-- 0
          22634000    0x80000730 andi a5, a1, 2                 #; a1  = 0, (wrb) a5  <-- 0
          22635000    0x80000734 sw a2, 24(sp)                  #; sp  = 0x1001faf0, 1 ~~> Word[0x1001fb08]
          22636000    0x80000738 slli a1, a2, 2                 #; a2  = 1, (wrb) a1  <-- 4
          22637000    0x8000073c add a1, a1, s4                 #; a1  = 4, s4  = 0x800061c8, (wrb) a1  <-- 0x800061cc
          22648000    0x80000740 addi a2, a1, 64                #; a1  = 0x800061cc, (wrb) a2  <-- 0x8000620c
          22649000    0x80000744 addi a3, a1, 128               #; a1  = 0x800061cc, (wrb) a3  <-- 0x8000624c
          22650000    0x80000748 addi a4, a1, 192               #; a1  = 0x800061cc, (wrb) a4  <-- 0x8000628c
          22651000    0x8000074c addi a5, a5, -2                #; a5  = 0, (wrb) a5  <-- -2
          22652000    0x80000750 srli a6, a0, 3                 #; a0  = 1, (wrb) a6  <-- 0
          22653000    0x80000754 andi a7, a6, 1                 #; a6  = 0, (wrb) a7  <-- 0
          22654000    0x80000758 slli a6, a7, 4                 #; a7  = 0, (wrb) a6  <-- 0
          22655000    0x8000075c slli a7, a7, 6                 #; a7  = 0, (wrb) a7  <-- 0
          22656000    0x80000760 add a7, a7, s1                 #; a7  = 0, s1  = 0x800060c8, (wrb) a7  <-- 0x800060c8
          22657000    0x80000764 li t0, 28                      #; (wrb) t0  <-- 28
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          22658000    0x80000768 mv t2, a7                      #; a7  = 0x800060c8, (wrb) t2  <-- 0x800060c8
          22659000    0x8000076c mv t3, a1                      #; a1  = 0x800061cc, (wrb) t3  <-- 0x800061cc
          22660000    0x80000770 p.lw t4, 4(t2!)                #; t2  = 0x800060c8, t4  <~~ Word[0x800060cc]
          22661000    0x80000774 p.lw t5, t0(t2!)               #; t2  = 0x800060cc, t0  = 28, t5  <~~ Word[0x800060e8]
          22669000    0x80000778 p.lw t6, 4(t2!)                #; t2  = 0x800060e8, t6  <~~ Word[0x800060ec]
          22677000                                              #; (lsu) t4  <-- 1
          22713000    0x8000077c p.lw s1, 0(t2!)                #; t2  = 0x800060ec, s1  <~~ Word[0x800060ec]
          22721000                                              #; (lsu) t5  <-- 2
          22750000    0x80000780 p.lw s4, 4(t3!)                #; t3  = 0x800061cc, s4  <~~ Word[0x800061d0]
          22758000                                              #; (lsu) t6  <-- 2
          22794000    0x80000784 p.lw s5, t0(t3!)               #; t3  = 0x800061d0, t0  = 28, s5  <~~ Word[0x800061ec]
          22802000                                              #; (lsu) s1  <-- 4
          22831000    0x80000788 p.lw s6, 4(t3!)                #; t3  = 0x800061ec, s6  <~~ Word[0x800061f0]
          22839000                                              #; (lsu) s4  <-- 0
          22875000    0x8000078c p.lw s7, 0(t3!)                #; t3  = 0x800061f0, s7  <~~ Word[0x800061f0]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:24)
#;     c00 += val_a00 * val_b00;
#;                    ^
          22876000    0x80000790 mul t2, t4, s4                 #; t4  = 1, s4  = 0
          22878000                                              #; (acc) t2  <-- 0
          22883000                                              #; (lsu) s5  <-- 0
          22920000                                              #; (lsu) s6  <-- 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          22921000    0x80000794 p.mac t2, t5, s6               #; t5  = 2, s6  = 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:24)
#;     c01 += val_a00 * val_b01;
#;                    ^
          22922000    0x80000798 mul t3, t4, s5                 #; t4  = 1, s5  = 0
          22923000                                              #; (acc) t2  <-- 2
          22924000                                              #; (acc) t3  <-- 0
          22964000                                              #; (lsu) s7  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          22965000    0x8000079c p.mac t3, t5, s7               #; t5  = 2, s7  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:24)
#;     c10 += val_a10 * val_b00;
#;                    ^
          22966000    0x800007a0 mul t4, t6, s4                 #; t6  = 2, s4  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          22967000    0x800007a4 addi t5, a7, 8                 #; a7  = 0x800060c8, (wrb) t5  <-- 0x800060d0
          22968000    0x800007a8 mv s4, a2                      #; a2  = 0x8000620c, (wrb) s4  <-- 0x8000620c
          22969000    0x800007ac mv a0, s0                      #; s0  = 0x80005fc8, (wrb) a0  <-- 0x80005fc8
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          22970000    0x800007b0 p.lw s8, 4(t5!)                #; t5  = 0x800060d0, s8  <~~ Word[0x800060d4]
          22971000    0x800007b4 p.lw s9, t0(t5!)               #; t5  = 0x800060d4, t0  = 28, s9  <~~ Word[0x800060f0]
          22972000                                              #; (acc) t3  <-- 0
          22973000                                              #; (acc) t4  <-- 0
          22993000    0x800007b8 p.lw s10, 4(t5!)               #; t5  = 0x800060f0, s10 <~~ Word[0x800060f4]
          23001000                                              #; (lsu) s8  <-- 3
          23037000    0x800007bc p.lw s11, 0(t5!)               #; t5  = 0x800060f4, s11 <~~ Word[0x800060f4]
          23045000                                              #; (lsu) s9  <-- 4
          23074000    0x800007c0 p.lw ra, 4(s4!)                #; s4  = 0x8000620c, ra  <~~ Word[0x80006210]
          23082000                                              #; (lsu) s10 <-- 6
          23118000    0x800007c4 p.lw s2, t0(s4!)               #; s4  = 0x80006210, t0  = 28, s2  <~~ Word[0x8000622c]
          23126000                                              #; (lsu) s11 <-- 8
          23155000    0x800007c8 p.lw s0, 4(s4!)                #; s4  = 0x8000622c, s0  <~~ Word[0x80006230]
          23163000                                              #; (lsu) ra  <-- 0
          23199000    0x800007cc p.lw s3, 0(s4!)                #; s4  = 0x80006230, s3  <~~ Word[0x80006230]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          23200000    0x800007d0 p.mac t4, s1, s6               #; s1  = 4, s6  = 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:24)
#;     c11 += val_a10 * val_b01;
#;                    ^
          23201000    0x800007d4 mul t5, t6, s5                 #; t6  = 2, s5  = 0
          23202000                                              #; (acc) t4  <-- 4
          23203000                                              #; (acc) t5  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          23204000    0x800007d8 p.mac t5, s1, s7               #; s1  = 4, s7  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          23205000    0x800007dc p.mac t2, s8, ra               #; s8  = 3, ra  = 0
          23206000                                              #; (acc) t5  <-- 0
          23207000                                              #; (lsu) s2  <-- 1
          23208000                                              #; (acc) t2  <-- 2
          23244000                                              #; (lsu) s0  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          23245000    0x800007e0 p.mac t2, s9, s0               #; s9  = 4, s0  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          23246000    0x800007e4 p.mac t3, s8, s2               #; s8  = 3, s2  = 1
          23247000                                              #; (acc) t2  <-- 2
          23248000                                              #; (acc) t3  <-- 3
          23288000                                              #; (lsu) s3  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          23289000    0x800007e8 p.mac t3, s9, s3               #; s9  = 4, s3  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          23290000    0x800007ec p.mac t4, s10, ra              #; s10 = 6, ra  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          23291000    0x800007f0 addi t6, a7, 16                #; a7  = 0x800060c8, (wrb) t6  <-- 0x800060d8
          23292000    0x800007f4 mv s1, a3                      #; a3  = 0x8000624c, (wrb) s1  <-- 0x8000624c
          23293000    0x800007f8 p.lw s4, 4(t6!)                #; t6  = 0x800060d8, s4  <~~ Word[0x800060dc]
          23294000    0x800007fc p.lw s5, t0(t6!)               #; t6  = 0x800060dc, t0  = 28, s5  <~~ Word[0x800060f8]
          23295000                                              #; (acc) t3  <-- 3
          23296000                                              #; (acc) t4  <-- 4
          23317000    0x80000800 p.lw s6, 4(t6!)                #; t6  = 0x800060f8, s6  <~~ Word[0x800060fc]
          23325000                                              #; (lsu) s4  <-- 5
          23361000    0x80000804 p.lw s7, 0(t6!)                #; t6  = 0x800060fc, s7  <~~ Word[0x800060fc]
          23369000                                              #; (lsu) s5  <-- 6
          23398000    0x80000808 p.lw s8, 4(s1!)                #; s1  = 0x8000624c, s8  <~~ Word[0x80006250]
          23406000                                              #; (lsu) s6  <-- 10
          23442000    0x8000080c p.lw s9, t0(s1!)               #; s1  = 0x80006250, t0  = 28, s9  <~~ Word[0x8000626c]
          23450000                                              #; (lsu) s7  <-- 12
          23479000    0x80000810 p.lw ra, 4(s1!)                #; s1  = 0x8000626c, ra  <~~ Word[0x80006270]
          23487000                                              #; (lsu) s8  <-- 0
          23523000    0x80000814 p.lw t1, 0(s1!)                #; s1  = 0x80006270, t1  <~~ Word[0x80006270]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          23524000    0x80000818 p.mac t4, s11, s0              #; s11 = 8, s0  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          23525000    0x8000081c p.mac t5, s10, s2              #; s10 = 6, s2  = 1
          23526000                                              #; (acc) t4  <-- 4
          23527000                                              #; (acc) t5  <-- 6
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          23528000    0x80000820 p.mac t5, s11, s3              #; s11 = 8, s3  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          23529000    0x80000824 p.mac t2, s4, s8               #; s4  = 5, s8  = 0
          23530000                                              #; (acc) t5  <-- 6
          23531000                                              #; (lsu) s9  <-- 0
          23532000                                              #; (acc) t2  <-- 2
          23568000                                              #; (lsu) ra  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          23569000    0x80000828 p.mac t2, s5, ra               #; s5  = 6, ra  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          23570000    0x8000082c p.mac t3, s4, s9               #; s4  = 5, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          23571000    0x80000830 p.mac t4, s6, s8               #; s6  = 10, s8  = 0, (acc) t2  <-- 2
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          23572000    0x80000834 p.mac t5, s6, s9               #; s6  = 10, s9  = 0, (acc) t3  <-- 3
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          23573000    0x80000838 addi t6, a7, 24                #; a7  = 0x800060c8, (wrb) t6  <-- 0x800060e0
          23574000    0x8000083c mv s0, a4                      #; a4  = 0x8000628c, (wrb) s0  <-- 0x8000628c
          23575000                                              #; (acc) t4  <-- 4
          23576000                                              #; (acc) t5  <-- 6
          23585000    0x80000840 p.lw s1, 4(t6!)                #; t6  = 0x800060e0, s1  <~~ Word[0x800060e4]
          23604000    0x80000844 p.lw s2, t0(t6!)               #; t6  = 0x800060e4, t0  = 28, s2  <~~ Word[0x80006100]
          23612000                                              #; (lsu) t1  <-- 0
          23641000    0x80000848 p.lw s3, 4(t6!)                #; t6  = 0x80006100, s3  <~~ Word[0x80006104]
          23649000                                              #; (lsu) s1  <-- 7
          23685000    0x8000084c p.lw s4, 0(t6!)                #; t6  = 0x80006104, s4  <~~ Word[0x80006104]
          23693000                                              #; (lsu) s2  <-- 8
          23722000    0x80000850 p.lw s6, 4(s0!)                #; s0  = 0x8000628c, s6  <~~ Word[0x80006290]
          23730000                                              #; (lsu) s3  <-- 14
          23766000    0x80000854 p.lw s8, t0(s0!)               #; s0  = 0x80006290, t0  = 28, s8  <~~ Word[0x800062ac]
          23774000                                              #; (lsu) s4  <-- 16
          23811000    0x80000858 p.lw s9, 4(s0!)                #; s0  = 0x800062ac, s9  <~~ Word[0x800062b0]
          23819000                                              #; (lsu) s6  <-- 0
          23856000    0x8000085c p.lw s10, 0(s0!)               #; s0  = 0x800062b0, s10 <~~ Word[0x800062b0]
          23857000    0x80000860 mv s0, a0                      #; a0  = 0x80005fc8, (wrb) s0  <-- 0x80005fc8
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          23858000    0x80000864 p.mac t3, s5, t1               #; s5  = 6, t1  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          23859000    0x80000868 p.mac t4, s7, ra               #; s7  = 12, ra  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          23860000    0x8000086c p.mac t5, s7, t1               #; s7  = 12, t1  = 0, (acc) t3  <-- 3
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          23861000    0x80000870 p.mac t2, s1, s6               #; s1  = 7, s6  = 0, (acc) t4  <-- 4
          23862000                                              #; (acc) t5  <-- 6
          23863000                                              #; (acc) t2  <-- 2
          23864000                                              #; (lsu) s8  <-- 0
          23909000                                              #; (lsu) s9  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          23910000    0x80000874 p.mac t2, s2, s9               #; s2  = 8, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          23911000    0x80000878 p.mac t3, s1, s8               #; s1  = 7, s8  = 0
          23912000                                              #; (acc) t2  <-- 2
          23913000                                              #; (acc) t3  <-- 3
          23954000                                              #; (lsu) s10 <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          23955000    0x8000087c p.mac t3, s2, s10              #; s2  = 8, s10 = 0
          23957000                                              #; (acc) t3  <-- 3
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          23966000    0x80000880 p.mac t4, s3, s6               #; s3  = 14, s6  = 0
          23968000                                              #; (acc) t4  <-- 4
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          23969000    0x80000884 p.mac t4, s4, s9               #; s4  = 16, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          23970000    0x80000888 p.mac t5, s3, s8               #; s3  = 14, s8  = 0
          23971000                                              #; (acc) t4  <-- 4
          23972000                                              #; (acc) t5  <-- 6
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          23973000    0x8000088c p.mac t5, s4, s10              #; s4  = 16, s10 = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:133:33)
#;     int32_t *idx_c = &C[i * P + j];
#;                               ^
          23974000    0x80000890 lw a0, 24(sp)                  #; sp  = 0x1001faf0, a0  <~~ Word[0x1001fb08]
          23975000                                              #; (acc) t5  <-- 6
          23977000                                              #; (lsu) a0  <-- 1
          23978000    0x80000894 or t1, a0, a6                  #; a0  = 1, a6  = 0, (wrb) t1  <-- 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:133:25)
#;     int32_t *idx_c = &C[i * P + j];
#;                       ^
          23979000    0x80000898 slli t1, t1, 2                 #; t1  = 1, (wrb) t1  <-- 4
          23980000    0x8000089c add t1, t1, s0                 #; t1  = 4, s0  = 0x80005fc8, (wrb) t1  <-- 0x80005fcc
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:134:7)
#;     __asm__ volatile("p.sw %[s00], 4(%[addr_c]!) \n"
#;     ^
          23981000    0x800008a0 p.sw t2, 4(t1!)                #; t1  = 0x80005fcc, 2 ~~> Word[0x80005fd0]
          23982000    0x800008a4 p.sw t3, t0(t1!)               #; t1  = 0x80005fd0, 3 ~~> Word[0x80005fec]
          23991000    0x800008a8 p.sw t4, 4(t1!)                #; t1  = 0x80005fec, 4 ~~> Word[0x80005ff0]
          24039000    0x800008ac p.sw t5, 0(t1!)                #; t1  = 0x80005ff0, 6 ~~> Word[0x80005ff0]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:88:37)
#;     for (uint32_t i = 2 * (id / c); i < M; i += 2 * (numThreads / c)) {
#;                                       ^
          24040000    0x800008b0 addi a5, a5, 2                 #; a5  = -2, (wrb) a5  <-- 0
          24041000    0x800008b4 addi a6, a6, 16                #; a6  = 0, (wrb) a6  <-- 16
          24042000    0x800008b8 addi a7, a7, 64                #; a7  = 0x800060c8, (wrb) a7  <-- 0x80006108
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:88:3)
#;     for (uint32_t i = 2 * (id / c); i < M; i += 2 * (numThreads / c)) {
#;     ^
          24043000    0x800008bc li a0, 6                       #; (wrb) a0  <-- 6
          24046000    0x800008c0 bltu a5, a0, -344              #; a5  = 0, a0  = 6, taken, goto 0x80000768
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          24047000    0x80000768 mv t2, a7                      #; a7  = 0x80006108, (wrb) t2  <-- 0x80006108
          24048000    0x8000076c mv t3, a1                      #; a1  = 0x800061cc, (wrb) t3  <-- 0x800061cc
          24087000    0x80000770 p.lw t4, 4(t2!)                #; t2  = 0x80006108, t4  <~~ Word[0x8000610c]
          24135000    0x80000774 p.lw t5, t0(t2!)               #; t2  = 0x8000610c, t0  = 28, t5  <~~ Word[0x80006128]
          24176000    0x80000778 p.lw t6, 4(t2!)                #; t2  = 0x80006128, t6  <~~ Word[0x8000612c]
          24184000                                              #; (lsu) t4  <-- 3
          24220000    0x8000077c p.lw s1, 0(t2!)                #; t2  = 0x8000612c, s1  <~~ Word[0x8000612c]
          24228000                                              #; (lsu) t5  <-- 6
          24257000    0x80000780 p.lw s4, 4(t3!)                #; t3  = 0x800061cc, s4  <~~ Word[0x800061d0]
          24265000                                              #; (lsu) t6  <-- 4
          24301000    0x80000784 p.lw s5, t0(t3!)               #; t3  = 0x800061d0, t0  = 28, s5  <~~ Word[0x800061ec]
          24309000                                              #; (lsu) s1  <-- 8
          24338000    0x80000788 p.lw s6, 4(t3!)                #; t3  = 0x800061ec, s6  <~~ Word[0x800061f0]
          24346000                                              #; (lsu) s4  <-- 0
          24382000    0x8000078c p.lw s7, 0(t3!)                #; t3  = 0x800061f0, s7  <~~ Word[0x800061f0]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:24)
#;     c00 += val_a00 * val_b00;
#;                    ^
          24383000    0x80000790 mul t2, t4, s4                 #; t4  = 3, s4  = 0
          24385000                                              #; (acc) t2  <-- 0
          24390000                                              #; (lsu) s5  <-- 0
          24427000                                              #; (lsu) s6  <-- 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          24428000    0x80000794 p.mac t2, t5, s6               #; t5  = 6, s6  = 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:24)
#;     c01 += val_a00 * val_b01;
#;                    ^
          24429000    0x80000798 mul t3, t4, s5                 #; t4  = 3, s5  = 0
          24430000                                              #; (acc) t2  <-- 6
          24431000                                              #; (acc) t3  <-- 0
          24471000                                              #; (lsu) s7  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          24472000    0x8000079c p.mac t3, t5, s7               #; t5  = 6, s7  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:24)
#;     c10 += val_a10 * val_b00;
#;                    ^
          24473000    0x800007a0 mul t4, t6, s4                 #; t6  = 4, s4  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          24474000    0x800007a4 addi t5, a7, 8                 #; a7  = 0x80006108, (wrb) t5  <-- 0x80006110
          24475000    0x800007a8 mv s4, a2                      #; a2  = 0x8000620c, (wrb) s4  <-- 0x8000620c
          24476000    0x800007ac mv a0, s0                      #; s0  = 0x80005fc8, (wrb) a0  <-- 0x80005fc8
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          24477000    0x800007b0 p.lw s8, 4(t5!)                #; t5  = 0x80006110, s8  <~~ Word[0x80006114]
          24478000    0x800007b4 p.lw s9, t0(t5!)               #; t5  = 0x80006114, t0  = 28, s9  <~~ Word[0x80006130]
          24479000                                              #; (acc) t3  <-- 0
          24480000                                              #; (acc) t4  <-- 0
          24500000    0x800007b8 p.lw s10, 4(t5!)               #; t5  = 0x80006130, s10 <~~ Word[0x80006134]
          24508000                                              #; (lsu) s8  <-- 9
          24544000    0x800007bc p.lw s11, 0(t5!)               #; t5  = 0x80006134, s11 <~~ Word[0x80006134]
          24552000                                              #; (lsu) s9  <-- 12
          24581000    0x800007c0 p.lw ra, 4(s4!)                #; s4  = 0x8000620c, ra  <~~ Word[0x80006210]
          24589000                                              #; (lsu) s10 <-- 12
          24625000    0x800007c4 p.lw s2, t0(s4!)               #; s4  = 0x80006210, t0  = 28, s2  <~~ Word[0x8000622c]
          24633000                                              #; (lsu) s11 <-- 16
          24662000    0x800007c8 p.lw s0, 4(s4!)                #; s4  = 0x8000622c, s0  <~~ Word[0x80006230]
          24670000                                              #; (lsu) ra  <-- 0
          24706000    0x800007cc p.lw s3, 0(s4!)                #; s4  = 0x80006230, s3  <~~ Word[0x80006230]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          24707000    0x800007d0 p.mac t4, s1, s6               #; s1  = 8, s6  = 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:24)
#;     c11 += val_a10 * val_b01;
#;                    ^
          24708000    0x800007d4 mul t5, t6, s5                 #; t6  = 4, s5  = 0
          24709000                                              #; (acc) t4  <-- 8
          24710000                                              #; (acc) t5  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          24711000    0x800007d8 p.mac t5, s1, s7               #; s1  = 8, s7  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          24712000    0x800007dc p.mac t2, s8, ra               #; s8  = 9, ra  = 0
          24713000                                              #; (acc) t5  <-- 0
          24714000                                              #; (lsu) s2  <-- 1
          24715000                                              #; (acc) t2  <-- 6
          24751000                                              #; (lsu) s0  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          24752000    0x800007e0 p.mac t2, s9, s0               #; s9  = 12, s0  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          24753000    0x800007e4 p.mac t3, s8, s2               #; s8  = 9, s2  = 1
          24754000                                              #; (acc) t2  <-- 6
          24755000                                              #; (acc) t3  <-- 9
          24795000                                              #; (lsu) s3  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          24796000    0x800007e8 p.mac t3, s9, s3               #; s9  = 12, s3  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          24797000    0x800007ec p.mac t4, s10, ra              #; s10 = 12, ra  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          24798000    0x800007f0 addi t6, a7, 16                #; a7  = 0x80006108, (wrb) t6  <-- 0x80006118
          24799000    0x800007f4 mv s1, a3                      #; a3  = 0x8000624c, (wrb) s1  <-- 0x8000624c
          24800000    0x800007f8 p.lw s4, 4(t6!)                #; t6  = 0x80006118, s4  <~~ Word[0x8000611c]
          24801000    0x800007fc p.lw s5, t0(t6!)               #; t6  = 0x8000611c, t0  = 28, s5  <~~ Word[0x80006138]
          24802000                                              #; (acc) t3  <-- 9
          24803000                                              #; (acc) t4  <-- 8
          24824000    0x80000800 p.lw s6, 4(t6!)                #; t6  = 0x80006138, s6  <~~ Word[0x8000613c]
          24832000                                              #; (lsu) s4  <-- 15
          24868000    0x80000804 p.lw s7, 0(t6!)                #; t6  = 0x8000613c, s7  <~~ Word[0x8000613c]
          24876000                                              #; (lsu) s5  <-- 18
          24905000    0x80000808 p.lw s8, 4(s1!)                #; s1  = 0x8000624c, s8  <~~ Word[0x80006250]
          24913000                                              #; (lsu) s6  <-- 20
          24949000    0x8000080c p.lw s9, t0(s1!)               #; s1  = 0x80006250, t0  = 28, s9  <~~ Word[0x8000626c]
          24957000                                              #; (lsu) s7  <-- 24
          24986000    0x80000810 p.lw ra, 4(s1!)                #; s1  = 0x8000626c, ra  <~~ Word[0x80006270]
          24994000                                              #; (lsu) s8  <-- 0
          25030000    0x80000814 p.lw t1, 0(s1!)                #; s1  = 0x80006270, t1  <~~ Word[0x80006270]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          25031000    0x80000818 p.mac t4, s11, s0              #; s11 = 16, s0  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          25032000    0x8000081c p.mac t5, s10, s2              #; s10 = 12, s2  = 1
          25033000                                              #; (acc) t4  <-- 8
          25034000                                              #; (acc) t5  <-- 12
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          25035000    0x80000820 p.mac t5, s11, s3              #; s11 = 16, s3  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          25036000    0x80000824 p.mac t2, s4, s8               #; s4  = 15, s8  = 0
          25037000                                              #; (acc) t5  <-- 12
          25038000                                              #; (lsu) s9  <-- 0
          25039000                                              #; (acc) t2  <-- 6
          25075000                                              #; (lsu) ra  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          25076000    0x80000828 p.mac t2, s5, ra               #; s5  = 18, ra  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          25077000    0x8000082c p.mac t3, s4, s9               #; s4  = 15, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          25078000    0x80000830 p.mac t4, s6, s8               #; s6  = 20, s8  = 0, (acc) t2  <-- 6
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          25079000    0x80000834 p.mac t5, s6, s9               #; s6  = 20, s9  = 0, (acc) t3  <-- 9
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          25080000    0x80000838 addi t6, a7, 24                #; a7  = 0x80006108, (wrb) t6  <-- 0x80006120
          25081000    0x8000083c mv s0, a4                      #; a4  = 0x8000628c, (wrb) s0  <-- 0x8000628c
          25082000    0x80000840 p.lw s1, 4(t6!)                #; t6  = 0x80006120, s1  <~~ Word[0x80006124]
          25083000                                              #; (acc) t4  <-- 8
          25084000                                              #; (acc) t5  <-- 12
          25111000    0x80000844 p.lw s2, t0(t6!)               #; t6  = 0x80006124, t0  = 28, s2  <~~ Word[0x80006140]
          25119000                                              #; (lsu) t1  <-- 0
          25148000    0x80000848 p.lw s3, 4(t6!)                #; t6  = 0x80006140, s3  <~~ Word[0x80006144]
          25156000                                              #; (lsu) s1  <-- 21
          25192000    0x8000084c p.lw s4, 0(t6!)                #; t6  = 0x80006144, s4  <~~ Word[0x80006144]
          25200000                                              #; (lsu) s2  <-- 24
          25229000    0x80000850 p.lw s6, 4(s0!)                #; s0  = 0x8000628c, s6  <~~ Word[0x80006290]
          25237000                                              #; (lsu) s3  <-- 28
          25281000    0x80000854 p.lw s8, t0(s0!)               #; s0  = 0x80006290, t0  = 28, s8  <~~ Word[0x800062ac]
          25289000                                              #; (lsu) s4  <-- 32
          25326000    0x80000858 p.lw s9, 4(s0!)                #; s0  = 0x800062ac, s9  <~~ Word[0x800062b0]
          25334000                                              #; (lsu) s6  <-- 0
          25371000    0x8000085c p.lw s10, 0(s0!)               #; s0  = 0x800062b0, s10 <~~ Word[0x800062b0]
          25372000    0x80000860 mv s0, a0                      #; a0  = 0x80005fc8, (wrb) s0  <-- 0x80005fc8
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          25373000    0x80000864 p.mac t3, s5, t1               #; s5  = 18, t1  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          25374000    0x80000868 p.mac t4, s7, ra               #; s7  = 24, ra  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          25375000    0x8000086c p.mac t5, s7, t1               #; s7  = 24, t1  = 0, (acc) t3  <-- 9
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          25376000    0x80000870 p.mac t2, s1, s6               #; s1  = 21, s6  = 0, (acc) t4  <-- 8
          25377000                                              #; (acc) t5  <-- 12
          25378000                                              #; (acc) t2  <-- 6
          25379000                                              #; (lsu) s8  <-- 0
          25424000                                              #; (lsu) s9  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          25425000    0x80000874 p.mac t2, s2, s9               #; s2  = 24, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          25426000    0x80000878 p.mac t3, s1, s8               #; s1  = 21, s8  = 0
          25427000                                              #; (acc) t2  <-- 6
          25428000                                              #; (acc) t3  <-- 9
          25461000                                              #; (lsu) s10 <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          25462000    0x8000087c p.mac t3, s2, s10              #; s2  = 24, s10 = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          25463000    0x80000880 p.mac t4, s3, s6               #; s3  = 28, s6  = 0
          25464000                                              #; (acc) t3  <-- 9
          25465000                                              #; (acc) t4  <-- 8
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          25466000    0x80000884 p.mac t4, s4, s9               #; s4  = 32, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          25467000    0x80000888 p.mac t5, s3, s8               #; s3  = 28, s8  = 0
          25468000                                              #; (acc) t4  <-- 8
          25469000                                              #; (acc) t5  <-- 12
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          25470000    0x8000088c p.mac t5, s4, s10              #; s4  = 32, s10 = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:133:33)
#;     int32_t *idx_c = &C[i * P + j];
#;                               ^
          25471000    0x80000890 lw a0, 24(sp)                  #; sp  = 0x1001faf0, a0  <~~ Word[0x1001fb08]
          25472000                                              #; (acc) t5  <-- 12
          25474000                                              #; (lsu) a0  <-- 1
          25475000    0x80000894 or t1, a0, a6                  #; a0  = 1, a6  = 16, (wrb) t1  <-- 17
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:133:25)
#;     int32_t *idx_c = &C[i * P + j];
#;                       ^
          25476000    0x80000898 slli t1, t1, 2                 #; t1  = 17, (wrb) t1  <-- 68
          25477000    0x8000089c add t1, t1, s0                 #; t1  = 68, s0  = 0x80005fc8, (wrb) t1  <-- 0x8000600c
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:134:7)
#;     __asm__ volatile("p.sw %[s00], 4(%[addr_c]!) \n"
#;     ^
          25478000    0x800008a0 p.sw t2, 4(t1!)                #; t1  = 0x8000600c, 6 ~~> Word[0x80006010]
          25479000    0x800008a4 p.sw t3, t0(t1!)               #; t1  = 0x80006010, 9 ~~> Word[0x8000602c]
          25497000    0x800008a8 p.sw t4, 4(t1!)                #; t1  = 0x8000602c, 8 ~~> Word[0x80006030]
          25545000    0x800008ac p.sw t5, 0(t1!)                #; t1  = 0x80006030, 12 ~~> Word[0x80006030]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:88:37)
#;     for (uint32_t i = 2 * (id / c); i < M; i += 2 * (numThreads / c)) {
#;                                       ^
          25546000    0x800008b0 addi a5, a5, 2                 #; a5  = 0, (wrb) a5  <-- 2
          25547000    0x800008b4 addi a6, a6, 16                #; a6  = 16, (wrb) a6  <-- 32
          25548000    0x800008b8 addi a7, a7, 64                #; a7  = 0x80006108, (wrb) a7  <-- 0x80006148
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:88:3)
#;     for (uint32_t i = 2 * (id / c); i < M; i += 2 * (numThreads / c)) {
#;     ^
          25549000    0x800008bc li a0, 6                       #; (wrb) a0  <-- 6
          25550000    0x800008c0 bltu a5, a0, -344              #; a5  = 2, a0  = 6, taken, goto 0x80000768
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          25551000    0x80000768 mv t2, a7                      #; a7  = 0x80006148, (wrb) t2  <-- 0x80006148
          25552000    0x8000076c mv t3, a1                      #; a1  = 0x800061cc, (wrb) t3  <-- 0x800061cc
          25593000    0x80000770 p.lw t4, 4(t2!)                #; t2  = 0x80006148, t4  <~~ Word[0x8000614c]
          25641000    0x80000774 p.lw t5, t0(t2!)               #; t2  = 0x8000614c, t0  = 28, t5  <~~ Word[0x80006168]
          25682000    0x80000778 p.lw t6, 4(t2!)                #; t2  = 0x80006168, t6  <~~ Word[0x8000616c]
          25690000                                              #; (lsu) t4  <-- 5
          25726000    0x8000077c p.lw s1, 0(t2!)                #; t2  = 0x8000616c, s1  <~~ Word[0x8000616c]
          25734000                                              #; (lsu) t5  <-- 10
          25763000    0x80000780 p.lw s4, 4(t3!)                #; t3  = 0x800061cc, s4  <~~ Word[0x800061d0]
          25771000                                              #; (lsu) t6  <-- 6
          25807000    0x80000784 p.lw s5, t0(t3!)               #; t3  = 0x800061d0, t0  = 28, s5  <~~ Word[0x800061ec]
          25815000                                              #; (lsu) s1  <-- 12
          25844000    0x80000788 p.lw s6, 4(t3!)                #; t3  = 0x800061ec, s6  <~~ Word[0x800061f0]
          25852000                                              #; (lsu) s4  <-- 0
          25888000    0x8000078c p.lw s7, 0(t3!)                #; t3  = 0x800061f0, s7  <~~ Word[0x800061f0]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:24)
#;     c00 += val_a00 * val_b00;
#;                    ^
          25889000    0x80000790 mul t2, t4, s4                 #; t4  = 5, s4  = 0
          25891000                                              #; (acc) t2  <-- 0
          25896000                                              #; (lsu) s5  <-- 0
          25933000                                              #; (lsu) s6  <-- 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          25934000    0x80000794 p.mac t2, t5, s6               #; t5  = 10, s6  = 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:24)
#;     c01 += val_a00 * val_b01;
#;                    ^
          25935000    0x80000798 mul t3, t4, s5                 #; t4  = 5, s5  = 0
          25936000                                              #; (acc) t2  <-- 10
          25937000                                              #; (acc) t3  <-- 0
          25977000                                              #; (lsu) s7  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          25978000    0x8000079c p.mac t3, t5, s7               #; t5  = 10, s7  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:24)
#;     c10 += val_a10 * val_b00;
#;                    ^
          25979000    0x800007a0 mul t4, t6, s4                 #; t6  = 6, s4  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          25980000    0x800007a4 addi t5, a7, 8                 #; a7  = 0x80006148, (wrb) t5  <-- 0x80006150
          25981000    0x800007a8 mv s4, a2                      #; a2  = 0x8000620c, (wrb) s4  <-- 0x8000620c
          25982000    0x800007ac mv a0, s0                      #; s0  = 0x80005fc8, (wrb) a0  <-- 0x80005fc8
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          25983000    0x800007b0 p.lw s8, 4(t5!)                #; t5  = 0x80006150, s8  <~~ Word[0x80006154]
          25984000    0x800007b4 p.lw s9, t0(t5!)               #; t5  = 0x80006154, t0  = 28, s9  <~~ Word[0x80006170]
          25985000                                              #; (acc) t3  <-- 0
          25986000                                              #; (acc) t4  <-- 0
          26006000    0x800007b8 p.lw s10, 4(t5!)               #; t5  = 0x80006170, s10 <~~ Word[0x80006174]
          26014000                                              #; (lsu) s8  <-- 15
          26050000    0x800007bc p.lw s11, 0(t5!)               #; t5  = 0x80006174, s11 <~~ Word[0x80006174]
          26058000                                              #; (lsu) s9  <-- 20
          26087000    0x800007c0 p.lw ra, 4(s4!)                #; s4  = 0x8000620c, ra  <~~ Word[0x80006210]
          26095000                                              #; (lsu) s10 <-- 18
          26131000    0x800007c4 p.lw s2, t0(s4!)               #; s4  = 0x80006210, t0  = 28, s2  <~~ Word[0x8000622c]
          26139000                                              #; (lsu) s11 <-- 24
          26168000    0x800007c8 p.lw s0, 4(s4!)                #; s4  = 0x8000622c, s0  <~~ Word[0x80006230]
          26176000                                              #; (lsu) ra  <-- 0
          26212000    0x800007cc p.lw s3, 0(s4!)                #; s4  = 0x80006230, s3  <~~ Word[0x80006230]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          26213000    0x800007d0 p.mac t4, s1, s6               #; s1  = 12, s6  = 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:24)
#;     c11 += val_a10 * val_b01;
#;                    ^
          26214000    0x800007d4 mul t5, t6, s5                 #; t6  = 6, s5  = 0
          26215000                                              #; (acc) t4  <-- 12
          26216000                                              #; (acc) t5  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          26217000    0x800007d8 p.mac t5, s1, s7               #; s1  = 12, s7  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          26218000    0x800007dc p.mac t2, s8, ra               #; s8  = 15, ra  = 0
          26219000                                              #; (acc) t5  <-- 0
          26220000                                              #; (lsu) s2  <-- 1
          26221000                                              #; (acc) t2  <-- 10
          26257000                                              #; (lsu) s0  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          26258000    0x800007e0 p.mac t2, s9, s0               #; s9  = 20, s0  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          26259000    0x800007e4 p.mac t3, s8, s2               #; s8  = 15, s2  = 1
          26260000                                              #; (acc) t2  <-- 10
          26261000                                              #; (acc) t3  <-- 15
          26301000                                              #; (lsu) s3  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          26302000    0x800007e8 p.mac t3, s9, s3               #; s9  = 20, s3  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          26303000    0x800007ec p.mac t4, s10, ra              #; s10 = 18, ra  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          26304000    0x800007f0 addi t6, a7, 16                #; a7  = 0x80006148, (wrb) t6  <-- 0x80006158
          26305000    0x800007f4 mv s1, a3                      #; a3  = 0x8000624c, (wrb) s1  <-- 0x8000624c
          26306000    0x800007f8 p.lw s4, 4(t6!)                #; t6  = 0x80006158, s4  <~~ Word[0x8000615c]
          26307000    0x800007fc p.lw s5, t0(t6!)               #; t6  = 0x8000615c, t0  = 28, s5  <~~ Word[0x80006178]
          26308000                                              #; (acc) t3  <-- 15
          26309000                                              #; (acc) t4  <-- 12
          26330000    0x80000800 p.lw s6, 4(t6!)                #; t6  = 0x80006178, s6  <~~ Word[0x8000617c]
          26338000                                              #; (lsu) s4  <-- 25
          26374000    0x80000804 p.lw s7, 0(t6!)                #; t6  = 0x8000617c, s7  <~~ Word[0x8000617c]
          26382000                                              #; (lsu) s5  <-- 30
          26411000    0x80000808 p.lw s8, 4(s1!)                #; s1  = 0x8000624c, s8  <~~ Word[0x80006250]
          26419000                                              #; (lsu) s6  <-- 30
          26455000    0x8000080c p.lw s9, t0(s1!)               #; s1  = 0x80006250, t0  = 28, s9  <~~ Word[0x8000626c]
          26463000                                              #; (lsu) s7  <-- 36
          26492000    0x80000810 p.lw ra, 4(s1!)                #; s1  = 0x8000626c, ra  <~~ Word[0x80006270]
          26500000                                              #; (lsu) s8  <-- 0
          26536000    0x80000814 p.lw t1, 0(s1!)                #; s1  = 0x80006270, t1  <~~ Word[0x80006270]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          26537000    0x80000818 p.mac t4, s11, s0              #; s11 = 24, s0  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          26538000    0x8000081c p.mac t5, s10, s2              #; s10 = 18, s2  = 1
          26539000                                              #; (acc) t4  <-- 12
          26540000                                              #; (acc) t5  <-- 18
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          26541000    0x80000820 p.mac t5, s11, s3              #; s11 = 24, s3  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          26542000    0x80000824 p.mac t2, s4, s8               #; s4  = 25, s8  = 0
          26543000                                              #; (acc) t5  <-- 18
          26544000                                              #; (lsu) s9  <-- 0
          26545000                                              #; (acc) t2  <-- 10
          26581000                                              #; (lsu) ra  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          26582000    0x80000828 p.mac t2, s5, ra               #; s5  = 30, ra  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          26583000    0x8000082c p.mac t3, s4, s9               #; s4  = 25, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          26584000    0x80000830 p.mac t4, s6, s8               #; s6  = 30, s8  = 0, (acc) t2  <-- 10
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          26585000    0x80000834 p.mac t5, s6, s9               #; s6  = 30, s9  = 0, (acc) t3  <-- 15
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          26586000    0x80000838 addi t6, a7, 24                #; a7  = 0x80006148, (wrb) t6  <-- 0x80006160
          26587000    0x8000083c mv s0, a4                      #; a4  = 0x8000628c, (wrb) s0  <-- 0x8000628c
          26588000    0x80000840 p.lw s1, 4(t6!)                #; t6  = 0x80006160, s1  <~~ Word[0x80006164]
          26589000                                              #; (acc) t4  <-- 12
          26590000                                              #; (acc) t5  <-- 18
          26617000    0x80000844 p.lw s2, t0(t6!)               #; t6  = 0x80006164, t0  = 28, s2  <~~ Word[0x80006180]
          26625000                                              #; (lsu) t1  <-- 0
          26654000    0x80000848 p.lw s3, 4(t6!)                #; t6  = 0x80006180, s3  <~~ Word[0x80006184]
          26662000                                              #; (lsu) s1  <-- 35
          26698000    0x8000084c p.lw s4, 0(t6!)                #; t6  = 0x80006184, s4  <~~ Word[0x80006184]
          26706000                                              #; (lsu) s2  <-- 40
          26735000    0x80000850 p.lw s6, 4(s0!)                #; s0  = 0x8000628c, s6  <~~ Word[0x80006290]
          26743000                                              #; (lsu) s3  <-- 42
          26787000    0x80000854 p.lw s8, t0(s0!)               #; s0  = 0x80006290, t0  = 28, s8  <~~ Word[0x800062ac]
          26795000                                              #; (lsu) s4  <-- 48
          26832000    0x80000858 p.lw s9, 4(s0!)                #; s0  = 0x800062ac, s9  <~~ Word[0x800062b0]
          26840000                                              #; (lsu) s6  <-- 0
          26877000    0x8000085c p.lw s10, 0(s0!)               #; s0  = 0x800062b0, s10 <~~ Word[0x800062b0]
          26878000    0x80000860 mv s0, a0                      #; a0  = 0x80005fc8, (wrb) s0  <-- 0x80005fc8
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          26879000    0x80000864 p.mac t3, s5, t1               #; s5  = 30, t1  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          26880000    0x80000868 p.mac t4, s7, ra               #; s7  = 36, ra  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          26881000    0x8000086c p.mac t5, s7, t1               #; s7  = 36, t1  = 0, (acc) t3  <-- 15
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          26882000    0x80000870 p.mac t2, s1, s6               #; s1  = 35, s6  = 0, (acc) t4  <-- 12
          26883000                                              #; (acc) t5  <-- 18
          26884000                                              #; (acc) t2  <-- 10
          26885000                                              #; (lsu) s8  <-- 0
          26930000                                              #; (lsu) s9  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          26931000    0x80000874 p.mac t2, s2, s9               #; s2  = 40, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          26932000    0x80000878 p.mac t3, s1, s8               #; s1  = 35, s8  = 0
          26933000                                              #; (acc) t2  <-- 10
          26934000                                              #; (acc) t3  <-- 15
          26967000                                              #; (lsu) s10 <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          26968000    0x8000087c p.mac t3, s2, s10              #; s2  = 40, s10 = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          26969000    0x80000880 p.mac t4, s3, s6               #; s3  = 42, s6  = 0
          26970000                                              #; (acc) t3  <-- 15
          26971000                                              #; (acc) t4  <-- 12
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          26972000    0x80000884 p.mac t4, s4, s9               #; s4  = 48, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          26973000    0x80000888 p.mac t5, s3, s8               #; s3  = 42, s8  = 0
          26974000                                              #; (acc) t4  <-- 12
          26975000                                              #; (acc) t5  <-- 18
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          26976000    0x8000088c p.mac t5, s4, s10              #; s4  = 48, s10 = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:133:33)
#;     int32_t *idx_c = &C[i * P + j];
#;                               ^
          26977000    0x80000890 lw a0, 24(sp)                  #; sp  = 0x1001faf0, a0  <~~ Word[0x1001fb08]
          26978000                                              #; (acc) t5  <-- 18
          26980000                                              #; (lsu) a0  <-- 1
          26981000    0x80000894 or t1, a0, a6                  #; a0  = 1, a6  = 32, (wrb) t1  <-- 33
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:133:25)
#;     int32_t *idx_c = &C[i * P + j];
#;                       ^
          26982000    0x80000898 slli t1, t1, 2                 #; t1  = 33, (wrb) t1  <-- 132
          26983000    0x8000089c add t1, t1, s0                 #; t1  = 132, s0  = 0x80005fc8, (wrb) t1  <-- 0x8000604c
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:134:7)
#;     __asm__ volatile("p.sw %[s00], 4(%[addr_c]!) \n"
#;     ^
          26984000    0x800008a0 p.sw t2, 4(t1!)                #; t1  = 0x8000604c, 10 ~~> Word[0x80006050]
          26985000    0x800008a4 p.sw t3, t0(t1!)               #; t1  = 0x80006050, 15 ~~> Word[0x8000606c]
          27003000    0x800008a8 p.sw t4, 4(t1!)                #; t1  = 0x8000606c, 12 ~~> Word[0x80006070]
          27051000    0x800008ac p.sw t5, 0(t1!)                #; t1  = 0x80006070, 18 ~~> Word[0x80006070]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:88:37)
#;     for (uint32_t i = 2 * (id / c); i < M; i += 2 * (numThreads / c)) {
#;                                       ^
          27052000    0x800008b0 addi a5, a5, 2                 #; a5  = 2, (wrb) a5  <-- 4
          27053000    0x800008b4 addi a6, a6, 16                #; a6  = 32, (wrb) a6  <-- 48
          27054000    0x800008b8 addi a7, a7, 64                #; a7  = 0x80006148, (wrb) a7  <-- 0x80006188
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:88:3)
#;     for (uint32_t i = 2 * (id / c); i < M; i += 2 * (numThreads / c)) {
#;     ^
          27055000    0x800008bc li a0, 6                       #; (wrb) a0  <-- 6
          27056000    0x800008c0 bltu a5, a0, -344              #; a5  = 4, a0  = 6, taken, goto 0x80000768
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          27057000    0x80000768 mv t2, a7                      #; a7  = 0x80006188, (wrb) t2  <-- 0x80006188
          27058000    0x8000076c mv t3, a1                      #; a1  = 0x800061cc, (wrb) t3  <-- 0x800061cc
          27099000    0x80000770 p.lw t4, 4(t2!)                #; t2  = 0x80006188, t4  <~~ Word[0x8000618c]
          27147000    0x80000774 p.lw t5, t0(t2!)               #; t2  = 0x8000618c, t0  = 28, t5  <~~ Word[0x800061a8]
          27188000    0x80000778 p.lw t6, 4(t2!)                #; t2  = 0x800061a8, t6  <~~ Word[0x800061ac]
          27196000                                              #; (lsu) t4  <-- 7
          27224000    0x8000077c p.lw s1, 0(t2!)                #; t2  = 0x800061ac, s1  <~~ Word[0x800061ac]
          27232000                                              #; (lsu) t5  <-- 14
          27260000    0x80000780 p.lw s4, 4(t3!)                #; t3  = 0x800061cc, s4  <~~ Word[0x800061d0]
          27268000                                              #; (lsu) t6  <-- 8
          27296000    0x80000784 p.lw s5, t0(t3!)               #; t3  = 0x800061d0, t0  = 28, s5  <~~ Word[0x800061ec]
          27304000                                              #; (lsu) s1  <-- 16
          27332000    0x80000788 p.lw s6, 4(t3!)                #; t3  = 0x800061ec, s6  <~~ Word[0x800061f0]
          27340000                                              #; (lsu) s4  <-- 0
          27368000    0x8000078c p.lw s7, 0(t3!)                #; t3  = 0x800061f0, s7  <~~ Word[0x800061f0]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:24)
#;     c00 += val_a00 * val_b00;
#;                    ^
          27369000    0x80000790 mul t2, t4, s4                 #; t4  = 7, s4  = 0
          27371000                                              #; (acc) t2  <-- 0
          27376000                                              #; (lsu) s5  <-- 0
          27412000                                              #; (lsu) s6  <-- 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          27413000    0x80000794 p.mac t2, t5, s6               #; t5  = 14, s6  = 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:24)
#;     c01 += val_a00 * val_b01;
#;                    ^
          27414000    0x80000798 mul t3, t4, s5                 #; t4  = 7, s5  = 0
          27415000                                              #; (acc) t2  <-- 14
          27416000                                              #; (acc) t3  <-- 0
          27448000                                              #; (lsu) s7  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          27449000    0x8000079c p.mac t3, t5, s7               #; t5  = 14, s7  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:24)
#;     c10 += val_a10 * val_b00;
#;                    ^
          27450000    0x800007a0 mul t4, t6, s4                 #; t6  = 8, s4  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          27451000    0x800007a4 addi t5, a7, 8                 #; a7  = 0x80006188, (wrb) t5  <-- 0x80006190
          27452000    0x800007a8 mv s4, a2                      #; a2  = 0x8000620c, (wrb) s4  <-- 0x8000620c
          27453000    0x800007ac mv a0, s0                      #; s0  = 0x80005fc8, (wrb) a0  <-- 0x80005fc8
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          27454000    0x800007b0 p.lw s8, 4(t5!)                #; t5  = 0x80006190, s8  <~~ Word[0x80006194]
          27455000    0x800007b4 p.lw s9, t0(t5!)               #; t5  = 0x80006194, t0  = 28, s9  <~~ Word[0x800061b0]
          27456000                                              #; (acc) t3  <-- 0
          27457000                                              #; (acc) t4  <-- 0
          27476000    0x800007b8 p.lw s10, 4(t5!)               #; t5  = 0x800061b0, s10 <~~ Word[0x800061b4]
          27484000                                              #; (lsu) s8  <-- 21
          27512000    0x800007bc p.lw s11, 0(t5!)               #; t5  = 0x800061b4, s11 <~~ Word[0x800061b4]
          27520000                                              #; (lsu) s9  <-- 28
          27548000    0x800007c0 p.lw ra, 4(s4!)                #; s4  = 0x8000620c, ra  <~~ Word[0x80006210]
          27556000                                              #; (lsu) s10 <-- 24
          27584000    0x800007c4 p.lw s2, t0(s4!)               #; s4  = 0x80006210, t0  = 28, s2  <~~ Word[0x8000622c]
          27592000                                              #; (lsu) s11 <-- 32
          27620000    0x800007c8 p.lw s0, 4(s4!)                #; s4  = 0x8000622c, s0  <~~ Word[0x80006230]
          27628000                                              #; (lsu) ra  <-- 0
          27656000    0x800007cc p.lw s3, 0(s4!)                #; s4  = 0x80006230, s3  <~~ Word[0x80006230]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          27657000    0x800007d0 p.mac t4, s1, s6               #; s1  = 16, s6  = 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:24)
#;     c11 += val_a10 * val_b01;
#;                    ^
          27658000    0x800007d4 mul t5, t6, s5                 #; t6  = 8, s5  = 0
          27659000                                              #; (acc) t4  <-- 16
          27660000                                              #; (acc) t5  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          27661000    0x800007d8 p.mac t5, s1, s7               #; s1  = 16, s7  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          27662000    0x800007dc p.mac t2, s8, ra               #; s8  = 21, ra  = 0
          27663000                                              #; (acc) t5  <-- 0
          27664000                                              #; (lsu) s2  <-- 1
          27665000                                              #; (acc) t2  <-- 14
          27700000                                              #; (lsu) s0  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          27701000    0x800007e0 p.mac t2, s9, s0               #; s9  = 28, s0  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          27702000    0x800007e4 p.mac t3, s8, s2               #; s8  = 21, s2  = 1
          27703000                                              #; (acc) t2  <-- 14
          27704000                                              #; (acc) t3  <-- 21
          27736000                                              #; (lsu) s3  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          27737000    0x800007e8 p.mac t3, s9, s3               #; s9  = 28, s3  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          27738000    0x800007ec p.mac t4, s10, ra              #; s10 = 24, ra  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          27739000    0x800007f0 addi t6, a7, 16                #; a7  = 0x80006188, (wrb) t6  <-- 0x80006198
          27740000    0x800007f4 mv s1, a3                      #; a3  = 0x8000624c, (wrb) s1  <-- 0x8000624c
          27741000    0x800007f8 p.lw s4, 4(t6!)                #; t6  = 0x80006198, s4  <~~ Word[0x8000619c]
          27742000    0x800007fc p.lw s5, t0(t6!)               #; t6  = 0x8000619c, t0  = 28, s5  <~~ Word[0x800061b8]
          27743000                                              #; (acc) t3  <-- 21
          27744000                                              #; (acc) t4  <-- 16
          27764000    0x80000800 p.lw s6, 4(t6!)                #; t6  = 0x800061b8, s6  <~~ Word[0x800061bc]
          27772000                                              #; (lsu) s4  <-- 35
          27800000    0x80000804 p.lw s7, 0(t6!)                #; t6  = 0x800061bc, s7  <~~ Word[0x800061bc]
          27808000                                              #; (lsu) s5  <-- 42
          27836000    0x80000808 p.lw s8, 4(s1!)                #; s1  = 0x8000624c, s8  <~~ Word[0x80006250]
          27844000                                              #; (lsu) s6  <-- 40
          27872000    0x8000080c p.lw s9, t0(s1!)               #; s1  = 0x80006250, t0  = 28, s9  <~~ Word[0x8000626c]
          27880000                                              #; (lsu) s7  <-- 48
          27908000    0x80000810 p.lw ra, 4(s1!)                #; s1  = 0x8000626c, ra  <~~ Word[0x80006270]
          27916000                                              #; (lsu) s8  <-- 0
          27944000    0x80000814 p.lw t1, 0(s1!)                #; s1  = 0x80006270, t1  <~~ Word[0x80006270]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          27945000    0x80000818 p.mac t4, s11, s0              #; s11 = 32, s0  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          27946000    0x8000081c p.mac t5, s10, s2              #; s10 = 24, s2  = 1
          27947000                                              #; (acc) t4  <-- 16
          27948000                                              #; (acc) t5  <-- 24
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          27949000    0x80000820 p.mac t5, s11, s3              #; s11 = 32, s3  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          27950000    0x80000824 p.mac t2, s4, s8               #; s4  = 35, s8  = 0
          27951000                                              #; (acc) t5  <-- 24
          27952000                                              #; (lsu) s9  <-- 0
          27953000                                              #; (acc) t2  <-- 14
          27988000                                              #; (lsu) ra  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          27989000    0x80000828 p.mac t2, s5, ra               #; s5  = 42, ra  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          27990000    0x8000082c p.mac t3, s4, s9               #; s4  = 35, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          27991000    0x80000830 p.mac t4, s6, s8               #; s6  = 40, s8  = 0, (acc) t2  <-- 14
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          27992000    0x80000834 p.mac t5, s6, s9               #; s6  = 40, s9  = 0, (acc) t3  <-- 21
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          27993000    0x80000838 addi t6, a7, 24                #; a7  = 0x80006188, (wrb) t6  <-- 0x800061a0
          27994000    0x8000083c mv s0, a4                      #; a4  = 0x8000628c, (wrb) s0  <-- 0x8000628c
          27995000    0x80000840 p.lw s1, 4(t6!)                #; t6  = 0x800061a0, s1  <~~ Word[0x800061a4]
          27996000                                              #; (acc) t4  <-- 16
          27997000                                              #; (acc) t5  <-- 24
          28016000    0x80000844 p.lw s2, t0(t6!)               #; t6  = 0x800061a4, t0  = 28, s2  <~~ Word[0x800061c0]
          28024000                                              #; (lsu) t1  <-- 0
          28052000    0x80000848 p.lw s3, 4(t6!)                #; t6  = 0x800061c0, s3  <~~ Word[0x800061c4]
          28060000                                              #; (lsu) s1  <-- 49
          28088000    0x8000084c p.lw s4, 0(t6!)                #; t6  = 0x800061c4, s4  <~~ Word[0x800061c4]
          28096000                                              #; (lsu) s2  <-- 56
          28124000    0x80000850 p.lw s6, 4(s0!)                #; s0  = 0x8000628c, s6  <~~ Word[0x80006290]
          28132000                                              #; (lsu) s3  <-- 56
          28168000    0x80000854 p.lw s8, t0(s0!)               #; s0  = 0x80006290, t0  = 28, s8  <~~ Word[0x800062ac]
          28176000                                              #; (lsu) s4  <-- 64
          28212000    0x80000858 p.lw s9, 4(s0!)                #; s0  = 0x800062ac, s9  <~~ Word[0x800062b0]
          28220000                                              #; (lsu) s6  <-- 0
          28256000    0x8000085c p.lw s10, 0(s0!)               #; s0  = 0x800062b0, s10 <~~ Word[0x800062b0]
          28257000    0x80000860 mv s0, a0                      #; a0  = 0x80005fc8, (wrb) s0  <-- 0x80005fc8
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          28258000    0x80000864 p.mac t3, s5, t1               #; s5  = 42, t1  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          28259000    0x80000868 p.mac t4, s7, ra               #; s7  = 48, ra  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          28260000    0x8000086c p.mac t5, s7, t1               #; s7  = 48, t1  = 0, (acc) t3  <-- 21
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          28261000    0x80000870 p.mac t2, s1, s6               #; s1  = 49, s6  = 0, (acc) t4  <-- 16
          28262000                                              #; (acc) t5  <-- 24
          28263000                                              #; (acc) t2  <-- 14
          28264000                                              #; (lsu) s8  <-- 0
          28308000                                              #; (lsu) s9  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          28309000    0x80000874 p.mac t2, s2, s9               #; s2  = 56, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          28310000    0x80000878 p.mac t3, s1, s8               #; s1  = 49, s8  = 0
          28311000                                              #; (acc) t2  <-- 14
          28312000                                              #; (acc) t3  <-- 21
          28336000                                              #; (lsu) s10 <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          28337000    0x8000087c p.mac t3, s2, s10              #; s2  = 56, s10 = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          28338000    0x80000880 p.mac t4, s3, s6               #; s3  = 56, s6  = 0
          28339000                                              #; (acc) t3  <-- 21
          28340000                                              #; (acc) t4  <-- 16
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          28341000    0x80000884 p.mac t4, s4, s9               #; s4  = 64, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          28342000    0x80000888 p.mac t5, s3, s8               #; s3  = 56, s8  = 0
          28343000                                              #; (acc) t4  <-- 16
          28344000                                              #; (acc) t5  <-- 24
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          28345000    0x8000088c p.mac t5, s4, s10              #; s4  = 64, s10 = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:133:33)
#;     int32_t *idx_c = &C[i * P + j];
#;                               ^
          28346000    0x80000890 lw a0, 24(sp)                  #; sp  = 0x1001faf0, a0  <~~ Word[0x1001fb08]
          28347000                                              #; (acc) t5  <-- 24
          28349000                                              #; (lsu) a0  <-- 1
          28350000    0x80000894 or t1, a0, a6                  #; a0  = 1, a6  = 48, (wrb) t1  <-- 49
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:133:25)
#;     int32_t *idx_c = &C[i * P + j];
#;                       ^
          28351000    0x80000898 slli t1, t1, 2                 #; t1  = 49, (wrb) t1  <-- 196
          28352000    0x8000089c add t1, t1, s0                 #; t1  = 196, s0  = 0x80005fc8, (wrb) t1  <-- 0x8000608c
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:134:7)
#;     __asm__ volatile("p.sw %[s00], 4(%[addr_c]!) \n"
#;     ^
          28353000    0x800008a0 p.sw t2, 4(t1!)                #; t1  = 0x8000608c, 14 ~~> Word[0x80006090]
          28354000    0x800008a4 p.sw t3, t0(t1!)               #; t1  = 0x80006090, 21 ~~> Word[0x800060ac]
          28363000    0x800008a8 p.sw t4, 4(t1!)                #; t1  = 0x800060ac, 16 ~~> Word[0x800060b0]
          28394000    0x800008ac p.sw t5, 0(t1!)                #; t1  = 0x800060b0, 24 ~~> Word[0x800060b0]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:88:37)
#;     for (uint32_t i = 2 * (id / c); i < M; i += 2 * (numThreads / c)) {
#;                                       ^
          28395000    0x800008b0 addi a5, a5, 2                 #; a5  = 4, (wrb) a5  <-- 6
          28396000    0x800008b4 addi a6, a6, 16                #; a6  = 48, (wrb) a6  <-- 64
          28397000    0x800008b8 addi a7, a7, 64                #; a7  = 0x80006188, (wrb) a7  <-- 0x800061c8
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:88:3)
#;     for (uint32_t i = 2 * (id / c); i < M; i += 2 * (numThreads / c)) {
#;     ^
          28398000    0x800008bc li a0, 6                       #; (wrb) a0  <-- 6
          28399000    0x800008c0 bltu a5, a0, -344              #; a5  = 6, a0  = 6, not taken
          28400000    0x800008c4 j 1152                         #; goto 0x80000d44
#; .LBB2_5 (matmul_i32.c:105:5)
#;   snrt_cluster_hw_barrier (sync.h:174:5)
#;     asm volatile("csrr x0, 0x7C2" ::: "memory");
#;     ^
          28403000    0x80000d44 csrr zero, 1986                #; csr@7c2 = 0
#; .LBB2_5 (matmul_i32.c:106:9)
#;   if (core_id == 0) {
#;       ^
          28435000    0x80000d48 lw a0, 20(sp)                  #; sp  = 0x1001faf0, a0  <~~ Word[0x1001fb04]
          28487000                                              #; (lsu) a0  <-- 1
          28488000    0x80000d4c bnez a0, 584                   #; a0  = 1, taken, goto 0x80000f94
#; .LBB2_43 (matmul_i32.c:150:5)
#;   snrt_cluster_hw_barrier (sync.h:174:5)
#;     asm volatile("csrr x0, 0x7C2" ::: "memory");
#;     ^
          28491000    0x80000f94 csrr zero, 1986                #; csr@7c2 = 0
#; .LBB2_43 (matmul_i32.c:151:5)
#;   return 0;
#;   ^
          45700000    0x80000f98 li a0, 0                       #; (wrb) a0  <-- 0
          45701000    0x80000f9c lw ra, 76(sp)                  #; sp  = 0x1001faf0, ra  <~~ Word[0x1001fb3c]
          45702000    0x80000fa0 lw s0, 72(sp)                  #; sp  = 0x1001faf0, s0  <~~ Word[0x1001fb38]
          45703000    0x80000fa4 lw s1, 68(sp)                  #; sp  = 0x1001faf0, s1  <~~ Word[0x1001fb34]
          45704000    0x80000fa8 lw s2, 64(sp)                  #; sp  = 0x1001faf0, s2  <~~ Word[0x1001fb30], (lsu) ra  <-- 0x8000418c
          45705000    0x80000fac lw s3, 60(sp)                  #; sp  = 0x1001faf0, s3  <~~ Word[0x1001fb2c], (lsu) s0  <-- 0x1001fb80
          45706000    0x80000fb0 lw s4, 56(sp)                  #; sp  = 0x1001faf0, s4  <~~ Word[0x1001fb28], (lsu) s1  <-- 2064
          45707000    0x80000fb4 lw s5, 52(sp)                  #; sp  = 0x1001faf0, s5  <~~ Word[0x1001fb24], (lsu) s2  <-- 1
          45708000    0x80000fb8 lw s6, 48(sp)                  #; sp  = 0x1001faf0, s6  <~~ Word[0x1001fb20], (lsu) s3  <-- 0
          45709000    0x80000fbc lw s7, 44(sp)                  #; sp  = 0x1001faf0, s7  <~~ Word[0x1001fb1c], (lsu) s4  <-- 0
          45710000                                              #; (lsu) s5  <-- 1
          45711000                                              #; (lsu) s6  <-- 0x80005ed8
          45712000                                              #; (lsu) s7  <-- 0x80005ed8
          45720000    0x80000fc0 lw s8, 40(sp)                  #; sp  = 0x1001faf0, s8  <~~ Word[0x1001fb18]
          45721000    0x80000fc4 lw s9, 36(sp)                  #; sp  = 0x1001faf0, s9  <~~ Word[0x1001fb14]
          45722000    0x80000fc8 lw s10, 32(sp)                 #; sp  = 0x1001faf0, s10 <~~ Word[0x1001fb10]
          45723000    0x80000fcc lw s11, 28(sp)                 #; sp  = 0x1001faf0, s11 <~~ Word[0x1001fb0c], (lsu) s8  <-- 0x80005ef8
          45724000    0x80000fd0 addi sp, sp, 80                #; sp  = 0x1001faf0, (wrb) sp  <-- 0x1001fb40
          45725000    0x80000fd4 ret                            #; ra  = 0x8000418c, (lsu) s9  <-- 6192, goto 0x8000418c
          45726000                                              #; (lsu) s10 <-- 7224
          45727000                                              #; (lsu) s11 <-- 8256
#; .LBB25_16 (start.c:268:5)
#;   snrt_cluster_hw_barrier (sync.h:174:5)
#;     asm volatile("csrr x0, 0x7C2" ::: "memory");
#;     ^
          45730000    0x8000418c csrr zero, 1986                #; csr@7c2 = 0
#; .LBB25_16 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:293:34)
#;         cls (cls.h:9:30)
#;           inline cls_t* cls() { return _cls_ptr; }
#;                                        ^
          45738000    0x80004190 lw a1, 64(s0)                  #; s0  = 0x1001fb80, a1  <~~ Word[0x1001fbc0]
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
          45758000                                              #; (lsu) a0  <-- 0
#; .LBB25_16 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:297:5)
#;         snrt_wait_writeback (sync.h:404:5)
#;           asm volatile("mv %0, %0" : "+r"(val)::);
#;           ^
          45759000    0x8000419c mv a0, a0                      #; a0  = 0, (wrb) a0  <-- 0
#; .LBB25_16 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:298:5)
#;         snrt_cluster_hw_barrier (sync.h:174:5)
#;           asm volatile("csrr x0, 0x7C2" ::: "memory");
#;           ^
          45760000    0x800041a0 csrr zero, 1986                #; csr@7c2 = 0
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
          45810000    0x800041f8 lw ra, 60(sp)                  #; sp  = 0x1001fb40, ra  <~~ Word[0x1001fb7c]
          45811000    0x800041fc lw s0, 56(sp)                  #; sp  = 0x1001fb40, s0  <~~ Word[0x1001fb78]
          45813000                                              #; (lsu) ra  <-- 0x800001c4
          45814000    0x80004200 lw s1, 52(sp)                  #; sp  = 0x1001fb40, s1  <~~ Word[0x1001fb74], (lsu) s0  <-- 0
          45815000    0x80004204 lw s2, 48(sp)                  #; sp  = 0x1001fb40, s2  <~~ Word[0x1001fb70]
          45816000    0x80004208 lw s3, 44(sp)                  #; sp  = 0x1001fb40, s3  <~~ Word[0x1001fb6c]
          45817000    0x8000420c lw s4, 40(sp)                  #; sp  = 0x1001fb40, s4  <~~ Word[0x1001fb68], (lsu) s1  <-- 0
          45818000                                              #; (lsu) s2  <-- 0
          45819000    0x80004210 lw s5, 36(sp)                  #; sp  = 0x1001fb40, s5  <~~ Word[0x1001fb64]
          45820000                                              #; (lsu) s3  <-- 0
          45821000    0x80004214 lw s6, 32(sp)                  #; sp  = 0x1001fb40, s6  <~~ Word[0x1001fb60]
          45822000                                              #; (lsu) s4  <-- 0
          45823000    0x80004218 lw s7, 28(sp)                  #; sp  = 0x1001fb40, s7  <~~ Word[0x1001fb5c]
          45824000    0x8000421c lw s8, 24(sp)                  #; sp  = 0x1001fb40, s8  <~~ Word[0x1001fb58], (lsu) s5  <-- 0
          45825000    0x80004220 lw s9, 20(sp)                  #; sp  = 0x1001fb40, s9  <~~ Word[0x1001fb54], (lsu) s6  <-- 0
          45826000    0x80004224 lw s10, 16(sp)                 #; sp  = 0x1001fb40, s10 <~~ Word[0x1001fb50], (lsu) s7  <-- 0
          45827000                                              #; (lsu) s8  <-- 0
          45828000    0x80004228 lw s11, 12(sp)                 #; sp  = 0x1001fb40, s11 <~~ Word[0x1001fb4c]
          45829000    0x8000422c addi sp, sp, 64                #; sp  = 0x1001fb40, (wrb) sp  <-- 0x1001fb80
          45830000    0x80004230 ret                            #; ra  = 0x800001c4, (lsu) s9  <-- 0, goto 0x800001c4
          45831000                                              #; (lsu) s10 <-- 0
          45832000                                              #; (lsu) s11 <-- 0
#; .Ltmp2 (start.S:183)
#;   wfi
          45833000    0x800001c4 wfi                            #; 

## Performance metrics

Performance metrics for section 0 @ (9, 45831):
tstart                                          11
snitch_loads                                   229
snitch_stores                                  567
tend                                         45833
fpss_loads                                       0
snitch_avg_load_latency                      51.06
snitch_occupancy                           0.04655
snitch_fseq_rel_offloads                   0.01478
fseq_yield                                     1.0
fseq_fpu_yield                                 1.0
fpss_section_latency                             0
fpss_avg_fpu_latency                           2.0
fpss_avg_load_latency                            0
fpss_occupancy                           0.0006983
fpss_fpu_occupancy                       0.0006983
fpss_fpu_rel_occupancy                         1.0
cycles                                       45823
total_ipc                                  0.04725
