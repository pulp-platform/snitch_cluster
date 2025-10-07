             10000    0x18020000 auipc t0, 0                    #; (wrb) t0  <-- 0x18020000
             23000    0x18020004 addi t0, t0, 32                #; t0  = 0x18020000, (wrb) t0  <-- 0x18020020
             36000    0x18020008 csrw mtvec, t0                 #; t0  = 0x18020020
             49000    0x1802000c csrsi mstatus, 8               #; mstatus = 0x80006000
             64000    0x18020010 lui t0, 128                    #; (wrb) t0  <-- 0x00080000
             77000    0x18020014 addi t0, t0, 8                 #; t0  = 0x00080000, (wrb) t0  <-- 0x00080008
             90000    0x18020018 csrw mie, t0                   #; t0  = 0x00080008
            103000    0x1802001c wfi                            #; 
            324000    0x18020020 auipc t0, 0                    #; exception, goto 0x18020020
            337000    0x18020020 auipc t0, 0                    #; (wrb) t0  <-- 0x18020020
            350000    0x18020024 lui t1, 1                      #; (wrb) t1  <-- 4096
            365000    0x18020028 addi t1, t1, 360               #; t1  = 4096, (wrb) t1  <-- 4456
            378000    0x1802002c add t0, t0, t1                 #; t0  = 0x18020020, t1  = 4456, (wrb) t0  <-- 0x18021188
            391000    0x18020030 lw t0, 0(t0)                   #; t0  = 0x18021188, t0  <~~ Word[0x18021188]
            399000                                              #; (lsu) t0  <-- 0x80000000
            404000    0x18020034 jalr t0                        #; t0  = 0x80000000, (wrb) ra  <-- 0x18020038, goto 0x80000000
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
            480000    0x800000fc addi gp, gp, 1200              #; gp  = 0x800060f8, (wrb) gp  <-- 0x800065a8
                                                                #; (f:fpu) ft10 <-- 0.0
#; snrt.crt0.init_core_info (start.S:98)
#;   csrr a0, mhartid
            481000    0x80000100 csrr a0, mhartid               #; mhartid = 0, (wrb) a0  <-- 0
                                                                #; (f:fpu) ft11 <-- 0.0
#; snrt.crt0.init_core_info (start.S:99)
#;   li   t0, SNRT_BASE_HARTID
            482000    0x80000104 li t0, 0                       #; (wrb) t0  <-- 0
#; snrt.crt0.init_core_info (start.S:100)
#;   sub  a0, a0, t0
            483000    0x80000108 sub a0, a0, t0                 #; a0  = 0, t0  = 0, (wrb) a0  <-- 0
#; snrt.crt0.init_core_info (start.S:101)
#;   li   a1, SNRT_CLUSTER_CORE_NUM
            484000    0x8000010c li a1, 9                       #; (wrb) a1  <-- 9
#; snrt.crt0.init_core_info (start.S:102)
#;   div  t0, a0, a1
            485000    0x80000110 div t0, a0, a1                 #; a0  = 0, a1  = 9
#; snrt.crt0.init_core_info (start.S:105)
#;   remu a0, a0, a1
            486000    0x80000114 remu a0, a0, a1                #; a0  = 0, a1  = 9
#; snrt.crt0.init_core_info (start.S:108)
#;   li   a2, SNRT_TCDM_START_ADDR
            487000    0x80000118 lui a2, 65536                  #; (wrb) a2  <-- 0x10000000
#; snrt.crt0.init_core_info (start.S:109)
#;   li   t1, SNRT_CLUSTER_OFFSET
            488000    0x8000011c li t1, 0                       #; (wrb) t1  <-- 0
            489000                                              #; (acc) t0  <-- 0
#; snrt.crt0.init_core_info (start.S:110)
#;   mul  t0, t1, t0
            490000    0x80000120 mul t0, t1, t0                 #; t1  = 0, t0  = 0, (acc) a0  <-- 0
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
            497000    0x80000134 addi t0, t0, -920              #; t0  = 0x80006130, (wrb) t0  <-- 0x80005d98
#; .Lpcrel_hi1 (start.S:122)
#;   la        t1, __cdata_start
            498000    0x80000138 auipc t1, 6                    #; (wrb) t1  <-- 0x80006138
            499000    0x8000013c addi t1, t1, -928              #; t1  = 0x80006138, (wrb) t1  <-- 0x80005d98
#; .Lpcrel_hi1 (start.S:123)
#;   sub       t0, t0, t1
            500000    0x80000140 sub t0, t0, t1                 #; t0  = 0x80005d98, t1  = 0x80005d98, (wrb) t0  <-- 0
#; .Lpcrel_hi1 (start.S:124)
#;   sub       a2, a2, t0
            501000    0x80000144 sub a2, a2, t0                 #; a2  = 0x10020000, t0  = 0, (wrb) a2  <-- 0x10020000
#; .Lpcrel_hi2 (start.S:125)
#;   la        t0, __cbss_end
            502000    0x80000148 auipc t0, 6                    #; (wrb) t0  <-- 0x80006148
            503000    0x8000014c addi t0, t0, -912              #; t0  = 0x80006148, (wrb) t0  <-- 0x80005db8
#; .Lpcrel_hi3 (start.S:126)
#;   la        t1, __cbss_start
            504000    0x80000150 auipc t1, 6                    #; (wrb) t1  <-- 0x80006150
            505000    0x80000154 addi t1, t1, -952              #; t1  = 0x80006150, (wrb) t1  <-- 0x80005d98
#; .Lpcrel_hi3 (start.S:127)
#;   sub       t0, t0, t1
            506000    0x80000158 sub t0, t0, t1                 #; t0  = 0x80005db8, t1  = 0x80005d98, (wrb) t0  <-- 32
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
            510000    0x80000168 slli t0, a0, 10                #; a0  = 0, (wrb) t0  <-- 0
#; snrt.crt0.init_stack (start.S:143)
#;   sub       sp, a2, t0
            511000    0x8000016c sub sp, a2, t0                 #; a2  = 0x1001ffd8, t0  = 0, (wrb) sp  <-- 0x1001ffd8
#; snrt.crt0.init_stack (start.S:146)
#;   slli      t0, a0, 3  # this hart
            512000    0x80000170 slli t0, a0, 3                 #; a0  = 0, (wrb) t0  <-- 0
#; snrt.crt0.init_stack (start.S:147)
#;   slli      t1, a1, 3  # all harts
            513000    0x80000174 slli t1, a1, 3                 #; a1  = 9, (wrb) t1  <-- 72
#; snrt.crt0.init_stack (start.S:148)
#;   sub       sp, sp, t0
            514000    0x80000178 sub sp, sp, t0                 #; sp  = 0x1001ffd8, t0  = 0, (wrb) sp  <-- 0x1001ffd8
#; snrt.crt0.init_stack (start.S:149)
#;   sub       a2, a2, t1
            515000    0x8000017c sub a2, a2, t1                 #; a2  = 0x1001ffd8, t1  = 72, (wrb) a2  <-- 0x1001ff90
#; .Lpcrel_hi4 (start.S:155)
#;   la        t0, __tdata_end
            516000    0x80000180 auipc t0, 6                    #; (wrb) t0  <-- 0x80006180
            517000    0x80000184 addi t0, t0, -1068             #; t0  = 0x80006180, (wrb) t0  <-- 0x80005d54
#; .Lpcrel_hi5 (start.S:156)
#;   la        t1, __tdata_start
            518000    0x80000188 auipc t1, 6                    #; (wrb) t1  <-- 0x80006188
            519000    0x8000018c addi t1, t1, -1088             #; t1  = 0x80006188, (wrb) t1  <-- 0x80005d48
#; .Lpcrel_hi5 (start.S:157)
#;   sub       t0, t0, t1
            520000    0x80000190 sub t0, t0, t1                 #; t0  = 0x80005d54, t1  = 0x80005d48, (wrb) t0  <-- 12
#; .Lpcrel_hi5 (start.S:158)
#;   sub       sp, sp, t0
            521000    0x80000194 sub sp, sp, t0                 #; sp  = 0x1001ffd8, t0  = 12, (wrb) sp  <-- 0x1001ffcc
#; .Lpcrel_hi6 (start.S:159)
#;   la        t0, __tbss_end
            522000    0x80000198 auipc t0, 6                    #; (wrb) t0  <-- 0x80006198
            523000    0x8000019c addi t0, t0, -1024             #; t0  = 0x80006198, (wrb) t0  <-- 0x80005d98
#; .Lpcrel_hi7 (start.S:160)
#;   la        t1, __tbss_start
            524000    0x800001a0 auipc t1, 6                    #; (wrb) t1  <-- 0x800061a0
            525000    0x800001a4 addi t1, t1, -1096             #; t1  = 0x800061a0, (wrb) t1  <-- 0x80005d58
#; .Lpcrel_hi7 (start.S:161)
#;   sub       t0, t0, t1
            526000    0x800001a8 sub t0, t0, t1                 #; t0  = 0x80005d98, t1  = 0x80005d58, (wrb) t0  <-- 64
#; .Lpcrel_hi7 (start.S:162)
#;   sub       sp, sp, t0
            527000    0x800001ac sub sp, sp, t0                 #; sp  = 0x1001ffcc, t0  = 64, (wrb) sp  <-- 0x1001ff8c
#; .Lpcrel_hi7 (start.S:163)
#;   andi      sp, sp, ~0x7 # align to 8B
            528000    0x800001b0 andi sp, sp, -8                #; sp  = 0x1001ff8c, (wrb) sp  <-- 0x1001ff88
#; .Lpcrel_hi7 (start.S:165)
#;   mv        tp, sp
            529000    0x800001b4 mv tp, sp                      #; sp  = 0x1001ff88, (wrb) tp  <-- 0x1001ff88
#; .Lpcrel_hi7 (start.S:167)
#;   andi      sp, sp, ~0x7 # align stack to 8B
            530000    0x800001b8 andi sp, sp, -8                #; sp  = 0x1001ff88, (wrb) sp  <-- 0x1001ff88
#; snrt.crt0.main (start.S:178)
#;   call snrt_main
            531000    0x800001bc auipc ra, 4                    #; (wrb) ra  <-- 0x800041bc
            532000    0x800001c0 jalr -1352(ra)                 #; ra  = 0x800041bc, (wrb) ra  <-- 0x800001c4, goto 0x80003c74
#; snrt_main (start.c:204)
#;   EXTERN_C void snrt_main() {
            543000    0x80003c74 addi sp, sp, -64               #; sp  = 0x1001ff88, (wrb) sp  <-- 0x1001ff48
            544000    0x80003c78 sw ra, 60(sp)                  #; sp  = 0x1001ff48, 0x800001c4 ~~> Word[0x1001ff84]
            545000    0x80003c7c sw s0, 56(sp)                  #; sp  = 0x1001ff48, 0 ~~> Word[0x1001ff80]
            556000    0x80003c80 sw s1, 52(sp)                  #; sp  = 0x1001ff48, 0 ~~> Word[0x1001ff7c]
            557000    0x80003c84 sw s2, 48(sp)                  #; sp  = 0x1001ff48, 0 ~~> Word[0x1001ff78]
            558000    0x80003c88 sw s3, 44(sp)                  #; sp  = 0x1001ff48, 0 ~~> Word[0x1001ff74]
            559000    0x80003c8c sw s4, 40(sp)                  #; sp  = 0x1001ff48, 0 ~~> Word[0x1001ff70]
            560000    0x80003c90 sw s5, 36(sp)                  #; sp  = 0x1001ff48, 0 ~~> Word[0x1001ff6c]
            561000    0x80003c94 sw s6, 32(sp)                  #; sp  = 0x1001ff48, 0 ~~> Word[0x1001ff68]
            562000    0x80003c98 sw s7, 28(sp)                  #; sp  = 0x1001ff48, 0 ~~> Word[0x1001ff64]
            563000    0x80003c9c sw s8, 24(sp)                  #; sp  = 0x1001ff48, 0 ~~> Word[0x1001ff60]
            565000    0x80003ca0 sw s9, 20(sp)                  #; sp  = 0x1001ff48, 0 ~~> Word[0x1001ff5c]
            567000    0x80003ca4 sw s10, 16(sp)                 #; sp  = 0x1001ff48, 0 ~~> Word[0x1001ff58]
            569000    0x80003ca8 sw s11, 12(sp)                 #; sp  = 0x1001ff48, 0 ~~> Word[0x1001ff54]
            570000    0x80003cac li s0, -1                      #; (wrb) s0  <-- -1
#; snrt_main (start.c:206:9)
#;   snrt_cluster_idx (team.h:99:12)
#;     snrt_global_core_idx (team.h:80:12)
#;       snrt_hartid (team.h:25:5)
#;         asm("csrr %0, mhartid" : "=r"(hartid));
#;         ^
            571000    0x80003cb0 csrr s2, mhartid               #; mhartid = 0, (wrb) s2  <-- 0
            572000    0x80003cb4 lui a0, 233017                 #; (wrb) a0  <-- 0x38e39000
            573000    0x80003cb8 addi a0, a0, -455              #; a0  = 0x38e39000, (wrb) a0  <-- 0x38e38e39
#; snrt_main (start.c:206:9)
#;   snrt_cluster_idx (team.h:99:35)
#;     return snrt_global_core_idx() / snrt_cluster_core_num();
#;                                   ^
            574000    0x80003cbc mulhu a0, s2, a0               #; s2  = 0, a0  = 0x38e38e39
            576000                                              #; (acc) a0  <-- 0
            577000    0x80003cc0 srli a0, a0, 1                 #; a0  = 0, (wrb) a0  <-- 0
            578000    0x80003cc4 li a1, 8                       #; (wrb) a1  <-- 8
            579000    0x80003cc8 slli s3, a0, 18                #; a0  = 0, (wrb) s3  <-- 0
#; snrt_main (start.c:206:9)
#;   if (snrt_cluster_idx() == 0) {
#;       ^
            580000    0x80003ccc bltu a1, s2, 184               #; a1  = 8, s2  = 0, not taken
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:31)
#;       snrt_cluster_core_idx (team.h:108:35)
#;         return snrt_global_core_idx() % snrt_cluster_core_num();
#;                                       ^
            581000    0x80003cd0 .text                          #; s2  = 0
            582000    0x80003cd4 li a1, 57                      #; (wrb) a1  <-- 57
            583000                                              #; (acc) s1  <-- 0
            584000    0x80003cd8 mul a1, s1, a1                 #; s1  = 0, a1  = 57
            586000                                              #; (acc) a1  <-- 0
            587000    0x80003cdc srli a1, a1, 9                 #; a1  = 0, (wrb) a1  <-- 0
            588000    0x80003ce0 slli a2, a1, 3                 #; a1  = 0, (wrb) a2  <-- 0
            589000    0x80003ce4 add a1, a2, a1                 #; a2  = 0, a1  = 0, (wrb) a1  <-- 0
            590000    0x80003ce8 lui a2, 65569                  #; (wrb) a2  <-- 0x10021000
            591000    0x80003cec addi a2, a2, 424               #; a2  = 0x10021000, (wrb) a2  <-- 0x100211a8
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:5)
#;       snrt_int_cluster_clr (cluster_interrupts.h:22:53)
#;         snrt_cluster()->peripheral_reg.cl_clint_clear.f.cl_clint_clear = mask;
#;                                                         ^
            592000    0x80003cf0 add a2, s3, a2                 #; s3  = 0, a2  = 0x100211a8, (wrb) a2  <-- 0x100211a8
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:5)
#;       snrt_int_cluster_clr (cluster_interrupts.h:22:68)
#;         snrt_cluster()->peripheral_reg.cl_clint_clear.f.cl_clint_clear = mask;
#;                                                                        ^
            593000    0x80003cf4 lw a3, 0(a2)                   #; a2  = 0x100211a8, a3  <~~ Word[0x100211a8]
            621000                                              #; (lsu) a3  <-- 0
            622000    0x80003cf8 ori a3, a2, 4                  #; a2  = 0x100211a8, (wrb) a3  <-- 0x100211ac
            623000    0x80003cfc lw a4, 0(a3)                   #; a3  = 0x100211ac, a4  <~~ Word[0x100211ac]
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:31)
#;       snrt_cluster_core_idx (team.h:108:35)
#;         return snrt_global_core_idx() % snrt_cluster_core_num();
#;                                       ^
            624000    0x80003d00 sub a1, s2, a1                 #; s2  = 0, a1  = 0, (wrb) a1  <-- 0
            625000    0x80003d04 li a5, 1                       #; (wrb) a5  <-- 1
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:28)
#;       snrt_int_cluster_clr(1 << snrt_cluster_core_idx());
#;                              ^
            626000    0x80003d08 sll a1, a5, a1                 #; a5  = 1, a1  = 0, (wrb) a1  <-- 1
            652000                                              #; (lsu) a4  <-- 0
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:5)
#;       snrt_int_cluster_clr (cluster_interrupts.h:22:68)
#;         snrt_cluster()->peripheral_reg.cl_clint_clear.f.cl_clint_clear = mask;
#;                                                                        ^
            653000    0x80003d0c and a4, a4, s0                 #; a4  = 0, s0  = -1, (wrb) a4  <-- 0
            654000    0x80003d10 sw a4, 0(a3)                   #; a3  = 0x100211ac, 0 ~~> Word[0x100211ac]
            655000    0x80003d14 sw a1, 0(a2)                   #; a2  = 0x100211a8, 1 ~~> Word[0x100211a8]
            656000    0x80003d18 lui a1, 128                    #; (wrb) a1  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            657000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            658000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            659000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            660000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            661000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            662000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            663000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            664000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            665000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            666000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            667000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            668000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            669000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            670000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            671000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            672000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            673000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            674000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            675000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            676000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            677000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            678000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            679000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            680000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            681000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            682000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            683000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            684000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            685000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            686000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            687000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            688000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            689000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            690000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            691000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            692000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            693000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            694000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            695000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            696000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            697000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            698000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            699000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            700000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            701000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            702000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            703000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            704000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            705000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            706000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            707000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            708000    0x80003d1c csrr a2, mip                   #; mip = 0, (wrb) a2  <-- 0
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            709000    0x80003d20 and a2, a2, a1                 #; a2  = 0, a1  = 0x00080000, (wrb) a2  <-- 0
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            710000    0x80003d24 bnez a2, -8                    #; a2  = 0, not taken
            711000    0x80003d28 li a1, 9                       #; (wrb) a1  <-- 9
#; .LBB25_2 (start.c:215:5)
#;   snrt_init_bss (start.c:110:9)
#;     if (snrt_cluster_idx() == 0) {
#;         ^
            712000    0x80003d2c bgeu s2, a1, 88                #; s2  = 0, a1  = 9, not taken
#; .LBB25_21 (start.c:215:5)
#;   snrt_init_bss (start.c:112:9)
#;     memset((void*)&__bss_start, 0, size);
#;     ^
            713000    0x80003d30 auipc a0, 2                    #; (wrb) a0  <-- 0x80005d30
            714000    0x80003d34 addi a0, a0, 312               #; a0  = 0x80005d30, (wrb) a0  <-- 0x80005e68
#; .LBB25_22 (start.c:215:5)
#;   snrt_init_bss (start.c:112:9)
#;     memset((void*)&__bss_start, 0, size);
#;     ^
            715000    0x80003d38 auipc a1, 2                    #; (wrb) a1  <-- 0x80005d38
            716000    0x80003d3c addi a1, a1, 360               #; a1  = 0x80005d38, (wrb) a1  <-- 0x80005ea0
            717000    0x80003d40 sub a2, a1, a0                 #; a1  = 0x80005ea0, a0  = 0x80005e68, (wrb) a2  <-- 56
            718000    0x80003d44 li a1, 0                       #; (wrb) a1  <-- 0
            719000    0x80003d48 auipc ra, 0                    #; (wrb) ra  <-- 0x80003d48
            720000    0x80003d4c jalr 1220(ra)                  #; ra  = 0x80003d48, (wrb) ra  <-- 0x80003d50, goto 0x8000420c
#; memset (memset.S:30)
#;   li t1, 15
            730000    0x8000420c li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
            731000    0x80004210 mv a4, a0                      #; a0  = 0x80005e68, (wrb) a4  <-- 0x80005e68
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
            732000    0x80004214 bgeu t1, a2, 60                #; t1  = 15, a2  = 56, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
            733000    0x80004218 andi a5, a4, 15                #; a4  = 0x80005e68, (wrb) a5  <-- 8
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
            734000    0x8000421c bnez a5, 160                   #; a5  = 8, taken, goto 0x800042bc
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
            744000    0x800042bc slli a3, a5, 2                 #; a5  = 8, (wrb) a3  <-- 32
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
            756000    0x800042c0 auipc t0, 0                    #; (wrb) t0  <-- 0x800042c0
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
            757000    0x800042c4 add a3, a3, t0                 #; a3  = 32, t0  = 0x800042c0, (wrb) a3  <-- 0x800042e0
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
            758000    0x800042c8 mv t0, ra                      #; ra  = 0x80003d50, (wrb) t0  <-- 0x80003d50
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
            759000    0x800042cc jalr -96(a3)                   #; a3  = 0x800042e0, (wrb) ra  <-- 0x800042d0, goto 0x80004280
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
            760000    0x80004280 sb a1, 7(a4)                   #; a4  = 0x80005e68, 0 ~~> Byte[0x80005e6f]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
            761000    0x80004284 sb a1, 6(a4)                   #; a4  = 0x80005e68, 0 ~~> Byte[0x80005e6e]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
            783000    0x80004288 sb a1, 5(a4)                   #; a4  = 0x80005e68, 0 ~~> Byte[0x80005e6d]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
            832000    0x8000428c sb a1, 4(a4)                   #; a4  = 0x80005e68, 0 ~~> Byte[0x80005e6c]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
            873000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x80005e68, 0 ~~> Byte[0x80005e6b]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
            922000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x80005e68, 0 ~~> Byte[0x80005e6a]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
            963000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x80005e68, 0 ~~> Byte[0x80005e69]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           1012000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x80005e68, 0 ~~> Byte[0x80005e68]
#; .Ltable (memset.S:85)
#;   ret
           1013000    0x800042a0 ret                            #; ra  = 0x800042d0, goto 0x800042d0
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           1014000    0x800042d0 mv ra, t0                      #; t0  = 0x80003d50, (wrb) ra  <-- 0x80003d50
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           1015000    0x800042d4 addi a5, a5, -16               #; a5  = 8, (wrb) a5  <-- -8
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           1016000    0x800042d8 sub a4, a4, a5                 #; a4  = 0x80005e68, a5  = -8, (wrb) a4  <-- 0x80005e70
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           1017000    0x800042dc add a2, a2, a5                 #; a2  = 56, a5  = -8, (wrb) a2  <-- 48
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           1018000    0x800042e0 bgeu t1, a2, -144              #; t1  = 15, a2  = 48, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           1019000    0x800042e4 j -196                         #; goto 0x80004220
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           1020000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           1021000    0x80004224 andi a3, a2, -16               #; a2  = 48, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           1022000    0x80004228 andi a2, a2, 15                #; a2  = 48, (wrb) a2  <-- 0
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           1023000    0x8000422c add a3, a3, a4                 #; a3  = 48, a4  = 0x80005e70, (wrb) a3  <-- 0x80005ea0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           1053000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x80005e70, 0 ~~> Word[0x80005e70]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           1102000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x80005e70, 0 ~~> Word[0x80005e74]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           1143000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x80005e70, 0 ~~> Word[0x80005e78]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           1192000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x80005e70, 0 ~~> Word[0x80005e7c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           1193000    0x80004240 addi a4, a4, 16                #; a4  = 0x80005e70, (wrb) a4  <-- 0x80005e80
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           1194000    0x80004244 bltu a4, a3, -20               #; a4  = 0x80005e80, a3  = 0x80005ea0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           1233000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x80005e80, 0 ~~> Word[0x80005e80]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           1282000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x80005e80, 0 ~~> Word[0x80005e84]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           1323000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x80005e80, 0 ~~> Word[0x80005e88]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           1372000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x80005e80, 0 ~~> Word[0x80005e8c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           1373000    0x80004240 addi a4, a4, 16                #; a4  = 0x80005e80, (wrb) a4  <-- 0x80005e90
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           1374000    0x80004244 bltu a4, a3, -20               #; a4  = 0x80005e90, a3  = 0x80005ea0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           1413000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x80005e90, 0 ~~> Word[0x80005e90]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           1462000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x80005e90, 0 ~~> Word[0x80005e94]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           1503000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x80005e90, 0 ~~> Word[0x80005e98]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           1552000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x80005e90, 0 ~~> Word[0x80005e9c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           1553000    0x80004240 addi a4, a4, 16                #; a4  = 0x80005e90, (wrb) a4  <-- 0x80005ea0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           1554000    0x80004244 bltu a4, a3, -20               #; a4  = 0x80005ea0, a3  = 0x80005ea0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           1555000    0x80004248 bnez a2, 8                     #; a2  = 0, not taken
#; .Ltmp0 (memset.S:57)
#;   ret
           1556000    0x8000424c ret                            #; ra  = 0x80003d50, goto 0x80003d50
#; .LBB25_22 (start.c:215:5)
#;   snrt_init_bss (start.c:115:9)
#;     snrt_cluster_hw_barrier (sync.h:174:5)
#;       asm volatile("csrr x0, 0x7C2" ::: "memory");
#;       ^
           1557000    0x80003d50 csrr zero, 1986                #; csr@7c2 = 0
           1579000    0x80003d54 li a0, 57                      #; (wrb) a0  <-- 57
           1580000    0x80003d58 mul a0, s1, a0                 #; s1  = 0, a0  = 57
           1582000                                              #; (acc) a0  <-- 0
           1583000    0x80003d5c srli a0, a0, 9                 #; a0  = 0, (wrb) a0  <-- 0
           1584000    0x80003d60 slli a1, a0, 3                 #; a0  = 0, (wrb) a1  <-- 0
           1585000    0x80003d64 add a0, a1, a0                 #; a1  = 0, a0  = 0, (wrb) a0  <-- 0
           1586000    0x80003d68 sub a0, s2, a0                 #; s2  = 0, a0  = 0, (wrb) a0  <-- 0
           1587000    0x80003d6c .text                          #; a0  = 0
           1588000    0x80003d70 li s4, 0                       #; (wrb) s4  <-- 0
           1589000                                              #; (acc) s5  <-- 0
#; .LBB25_22 (start.c:219:5)
#;   snrt_wake_up (start.c:124:33)
#;     if (snrt_cluster_idx() == 0 && snrt_cluster_core_idx() == 0) {
#;                                 ^
           1590000    0x80003d74 bnez s5, 32                    #; s5  = 0, not taken
#; .LBB25_22 (start.c:219:5)
#;   snrt_wake_up (start.c:133:9)
#;     snrt_fence (riscv.h:19:28)
#;       inline void snrt_fence() { asm volatile("fence" : : :); }
#;                                  ^
           1643000    0x80003d78 fence                          #; 
           1644000    0x80003d7c li s4, 1                       #; (wrb) s4  <-- 1
           1645000    0x80003d80 j 20                           #; goto 0x80003d94
#; .LBB25_7 (start.c:219:5)
#;   snrt_wake_up (start.c:137:5)
#;     snrt_cluster_hw_barrier (sync.h:174:5)
#;       asm volatile("csrr x0, 0x7C2" ::: "memory");
#;       ^
           1646000    0x80003d94 csrr zero, 1986                #; csr@7c2 = 0
           1648000    0x80003d98 lui a0, 65569                  #; (wrb) a0  <-- 0x10021000
           1649000    0x80003d9c addi a0, a0, 424               #; a0  = 0x10021000, (wrb) a0  <-- 0x100211a8
#; .LBB25_7 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;       snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:5)
#;         snrt_int_cluster_clr (cluster_interrupts.h:22:53)
#;           snrt_cluster()->peripheral_reg.cl_clint_clear.f.cl_clint_clear = mask;
#;                                                           ^
           1650000    0x80003da0 add a0, s3, a0                 #; s3  = 0, a0  = 0x100211a8, (wrb) a0  <-- 0x100211a8
#; .LBB25_7 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;       snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:5)
#;         snrt_int_cluster_clr (cluster_interrupts.h:22:68)
#;           snrt_cluster()->peripheral_reg.cl_clint_clear.f.cl_clint_clear = mask;
#;                                                                          ^
           1651000    0x80003da4 lw a1, 0(a0)                   #; a0  = 0x100211a8, a1  <~~ Word[0x100211a8]
           1679000                                              #; (lsu) a1  <-- 0
           1680000    0x80003da8 ori a1, a0, 4                  #; a0  = 0x100211a8, (wrb) a1  <-- 0x100211ac
           1681000    0x80003dac lw a2, 0(a1)                   #; a1  = 0x100211ac, a2  <~~ Word[0x100211ac]
           1682000    0x80003db0 li a3, 1                       #; (wrb) a3  <-- 1
#; .LBB25_7 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;       snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:28)
#;         snrt_int_cluster_clr(1 << snrt_cluster_core_idx());
#;                                ^
           1683000    0x80003db4 sll a3, a3, s5                 #; a3  = 1, s5  = 0, (wrb) a3  <-- 1
           1705000                                              #; (lsu) a2  <-- 0
#; .LBB25_7 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;       snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:5)
#;         snrt_int_cluster_clr (cluster_interrupts.h:22:68)
#;           snrt_cluster()->peripheral_reg.cl_clint_clear.f.cl_clint_clear = mask;
#;                                                                          ^
           1706000    0x80003db8 and a2, a2, s0                 #; a2  = 0, s0  = -1, (wrb) a2  <-- 0
           1707000    0x80003dbc sw a3, 0(a0)                   #; a0  = 0x100211a8, 1 ~~> Word[0x100211a8]
           1708000    0x80003dc0 sw a2, 0(a1)                   #; a1  = 0x100211ac, 0 ~~> Word[0x100211ac]
           1709000    0x80003dc4 lui a0, 128                    #; (wrb) a0  <-- 0x00080000
#; .LBB25_8 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;       snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;         while (read_csr(mip) & MIP_MCIP)
#;                ^
           1710000    0x80003dc8 csrr a1, mip                   #; mip = 0, (wrb) a1  <-- 0
#; .LBB25_8 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;       snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;         while (read_csr(mip) & MIP_MCIP)
#;                              ^
           1711000    0x80003dcc and a1, a1, a0                 #; a1  = 0, a0  = 0x00080000, (wrb) a1  <-- 0
#; .LBB25_8 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;       snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;         while (read_csr(mip) & MIP_MCIP)
#;         ^
           1712000    0x80003dd0 bnez a1, -8                    #; a1  = 0, not taken
#; .LBB25_8 (start.c:227:5)
#;   snrt_init_tls (start.c:66:5)
#;     asm volatile("mv %0, tp" : "=r"(tls_ptr) : :);
#;     ^
           1713000    0x80003dd4 mv a0, tp                      #; tp  = 0x1001ff88, (wrb) a0  <-- 0x1001ff88
           1731000    0x80003dd8 sw a0, 8(sp)                   #; sp  = 0x1001ff48, 0x1001ff88 ~~> Word[0x1001ff50]
#; .LBB25_8 (start.c:227:5)
#;   snrt_init_tls (start.c:67:19)
#;     memcpy((void*)tls_ptr, (const void*)&__tdata_start, size);
#;                   ^
           1761000    0x80003ddc lw a0, 8(sp)                   #; sp  = 0x1001ff48, a0  <~~ Word[0x1001ff50]
#; .LBB25_23 (start.c:227:5)
#;   snrt_init_tls (start.c:67:5)
#;     memcpy((void*)tls_ptr, (const void*)&__tdata_start, size);
#;     ^
           1762000    0x80003de0 auipc a1, 2                    #; (wrb) a1  <-- 0x80005de0
           1763000    0x80003de4 addi a1, a1, -152              #; a1  = 0x80005de0, (wrb) a1  <-- 0x80005d48
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:67:5)
#;     memcpy((void*)tls_ptr, (const void*)&__tdata_start, size);
#;     ^
           1764000    0x80003de8 auipc a2, 2                    #; (wrb) a2  <-- 0x80005de8
           1765000    0x80003dec addi a2, a2, -148              #; a2  = 0x80005de8, (wrb) a2  <-- 0x80005d54
           1766000    0x80003df0 sub s0, a2, a1                 #; a2  = 0x80005d54, a1  = 0x80005d48, (wrb) s0  <-- 12
           1767000    0x80003df4 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
           1768000    0x80003df8 auipc ra, 2                    #; (wrb) ra  <-- 0x80005df8
           1769000    0x80003dfc jalr -2028(ra)                 #; ra  = 0x80005df8, (wrb) ra  <-- 0x80003e00, goto 0x8000560c
           1770000                                              #; (lsu) a0  <-- 0x1001ff88
#; memcpy (memcpy.c:25)
#;   {
           1773000    0x8000560c addi sp, sp, -16               #; sp  = 0x1001ff48, (wrb) sp  <-- 0x1001ff38
           1774000    0x80005610 sw s0, 12(sp)                  #; sp  = 0x1001ff38, 12 ~~> Word[0x1001ff44]
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           1775000    0x80005614 andi a3, a0, 3                 #; a0  = 0x1001ff88, (wrb) a3  <-- 0
           1776000    0x80005618 andi a4, a1, 3                 #; a1  = 0x80005d48, (wrb) a4  <-- 0
           1777000    0x8000561c xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
           1778000    0x80005620 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
           1779000    0x80005624 li a5, 3                       #; (wrb) a5  <-- 3
           1780000    0x80005628 sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
           1781000    0x8000562c and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
           1782000    0x80005630 add a2, a0, a2                 #; a0  = 0x1001ff88, a2  = 12, (wrb) a2  <-- 0x1001ff94
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           1783000    0x80005634 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
           1784000    0x80005638 bnez a3, 116                   #; a3  = 0, not taken
           1785000    0x8000563c mv a4, a0                      #; a0  = 0x1001ff88, (wrb) a4  <-- 0x1001ff88
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
           1786000    0x80005640 andi a3, a2, -4                #; a2  = 0x1001ff94, (wrb) a3  <-- 0x1001ff94
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
           1787000    0x80005644 sub a5, a3, a4                 #; a3  = 0x1001ff94, a4  = 0x1001ff88, (wrb) a5  <-- 12
           1788000    0x80005648 li a6, 33                      #; (wrb) a6  <-- 33
           1789000    0x8000564c bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1790000    0x80005650 bgeu a4, a3, 32                #; a4  = 0x1001ff88, a3  = 0x1001ff94, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           1791000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x80005d48, a6  <~~ Word[0x80005d48]
           1792000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001ff88, (wrb) a5  <-- 0x1001ff8c
           1793000    0x8000565c addi a1, a1, 4                 #; a1  = 0x80005d48, (wrb) a1  <-- 0x80005d4c
           1812000                                              #; (lsu) a6  <-- 0x80005e80
           1813000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001ff88, 0x80005e80 ~~> Word[0x1001ff88]
           1814000    0x80005664 mv a4, a5                      #; a5  = 0x1001ff8c, (wrb) a4  <-- 0x1001ff8c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1815000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001ff8c, a3  = 0x1001ff94, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           1816000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x80005d4c, a6  <~~ Word[0x80005d4c]
           1817000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001ff8c, (wrb) a5  <-- 0x1001ff90
           1818000    0x8000565c addi a1, a1, 4                 #; a1  = 0x80005d4c, (wrb) a1  <-- 0x80005d50
           1849000                                              #; (lsu) a6  <-- 1
           1850000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001ff8c, 1 ~~> Word[0x1001ff8c]
           1851000    0x80005664 mv a4, a5                      #; a5  = 0x1001ff90, (wrb) a4  <-- 0x1001ff90
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1852000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001ff90, a3  = 0x1001ff94, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           1853000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x80005d50, a6  <~~ Word[0x80005d50]
           1854000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001ff90, (wrb) a5  <-- 0x1001ff94
           1855000    0x8000565c addi a1, a1, 4                 #; a1  = 0x80005d50, (wrb) a1  <-- 0x80005d54
           1893000                                              #; (lsu) a6  <-- 1
           1894000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001ff90, 1 ~~> Word[0x1001ff90]
           1895000    0x80005664 mv a4, a5                      #; a5  = 0x1001ff94, (wrb) a4  <-- 0x1001ff94
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1896000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001ff94, a3  = 0x1001ff94, not taken
           1897000    0x8000566c j 8                            #; goto 0x80005674
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
           1898000    0x80005674 bltu a5, a2, 20                #; a5  = 0x1001ff94, a2  = 0x1001ff94, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
           1899000    0x80005678 lw s0, 12(sp)                  #; sp  = 0x1001ff38, s0  <~~ Word[0x1001ff44]
           1900000    0x8000567c addi sp, sp, 16                #; sp  = 0x1001ff38, (wrb) sp  <-- 0x1001ff48
           1901000    0x80005680 ret                            #; ra  = 0x80003e00, goto 0x80003e00
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
           1902000    0x80003e00 lw a0, 8(sp)                   #; sp  = 0x1001ff48, a0  <~~ Word[0x1001ff50], (lsu) s0  <-- 12
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
           1903000    0x80003e04 lw a1, 8(sp)                   #; sp  = 0x1001ff48, a1  <~~ Word[0x1001ff50]
           1905000                                              #; (lsu) a0  <-- 0x1001ff88
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
           1906000    0x80003e08 addi a0, a0, 1032              #; a0  = 0x1001ff88, (wrb) a0  <-- 0x10020390
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
           1907000    0x80003e0c mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
           1908000    0x80003e10 auipc ra, 1                    #; (wrb) ra  <-- 0x80004e10
           1909000    0x80003e14 jalr 2044(ra)                  #; ra  = 0x80004e10, (wrb) ra  <-- 0x80003e18, goto 0x8000560c
#; memcpy (memcpy.c:25)
#;   {
           1910000    0x8000560c addi sp, sp, -16               #; sp  = 0x1001ff48, (wrb) sp  <-- 0x1001ff38
           1911000    0x80005610 sw s0, 12(sp)                  #; sp  = 0x1001ff38, 12 ~~> Word[0x1001ff44], (lsu) a1  <-- 0x1001ff88
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           1912000    0x80005614 andi a3, a0, 3                 #; a0  = 0x10020390, (wrb) a3  <-- 0
           1913000    0x80005618 andi a4, a1, 3                 #; a1  = 0x1001ff88, (wrb) a4  <-- 0
           1914000    0x8000561c xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
           1915000    0x80005620 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
           1916000    0x80005624 li a5, 3                       #; (wrb) a5  <-- 3
           1917000    0x80005628 sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
           1918000    0x8000562c and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
           1919000    0x80005630 add a2, a0, a2                 #; a0  = 0x10020390, a2  = 12, (wrb) a2  <-- 0x1002039c
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           1920000    0x80005634 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
           1921000    0x80005638 bnez a3, 116                   #; a3  = 0, not taken
           1922000    0x8000563c mv a4, a0                      #; a0  = 0x10020390, (wrb) a4  <-- 0x10020390
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
           1923000    0x80005640 andi a3, a2, -4                #; a2  = 0x1002039c, (wrb) a3  <-- 0x1002039c
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
           1924000    0x80005644 sub a5, a3, a4                 #; a3  = 0x1002039c, a4  = 0x10020390, (wrb) a5  <-- 12
           1925000    0x80005648 li a6, 33                      #; (wrb) a6  <-- 33
           1926000    0x8000564c bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1927000    0x80005650 bgeu a4, a3, 32                #; a4  = 0x10020390, a3  = 0x1002039c, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           1928000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001ff88, a6  <~~ Word[0x1001ff88]
           1929000    0x80005658 addi a5, a4, 4                 #; a4  = 0x10020390, (wrb) a5  <-- 0x10020394
           1930000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001ff88, (wrb) a1  <-- 0x1001ff8c
           1931000                                              #; (lsu) a6  <-- 0x80005e80
           1932000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x10020390, 0x80005e80 ~~> Word[0x10020390]
           1933000    0x80005664 mv a4, a5                      #; a5  = 0x10020394, (wrb) a4  <-- 0x10020394
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1934000    0x80005668 bltu a5, a3, -20               #; a5  = 0x10020394, a3  = 0x1002039c, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           1935000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001ff8c, a6  <~~ Word[0x1001ff8c]
           1936000    0x80005658 addi a5, a4, 4                 #; a4  = 0x10020394, (wrb) a5  <-- 0x10020398
           1937000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001ff8c, (wrb) a1  <-- 0x1001ff90
           1944000                                              #; (lsu) a6  <-- 1
           1945000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x10020394, 1 ~~> Word[0x10020394]
           1946000    0x80005664 mv a4, a5                      #; a5  = 0x10020398, (wrb) a4  <-- 0x10020398
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1947000    0x80005668 bltu a5, a3, -20               #; a5  = 0x10020398, a3  = 0x1002039c, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           1948000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001ff90, a6  <~~ Word[0x1001ff90]
           1949000    0x80005658 addi a5, a4, 4                 #; a4  = 0x10020398, (wrb) a5  <-- 0x1002039c
           1950000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001ff90, (wrb) a1  <-- 0x1001ff94
           1957000                                              #; (lsu) a6  <-- 1
           1958000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x10020398, 1 ~~> Word[0x10020398]
           1959000    0x80005664 mv a4, a5                      #; a5  = 0x1002039c, (wrb) a4  <-- 0x1002039c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1960000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1002039c, a3  = 0x1002039c, not taken
           1961000    0x8000566c j 8                            #; goto 0x80005674
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
           1962000    0x80005674 bltu a5, a2, 20                #; a5  = 0x1002039c, a2  = 0x1002039c, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
           1963000    0x80005678 lw s0, 12(sp)                  #; sp  = 0x1001ff38, s0  <~~ Word[0x1001ff44]
           1964000    0x8000567c addi sp, sp, 16                #; sp  = 0x1001ff38, (wrb) sp  <-- 0x1001ff48
           1965000    0x80005680 ret                            #; ra  = 0x80003e18, goto 0x80003e18
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
           1966000    0x80003e18 lw a0, 8(sp)                   #; sp  = 0x1001ff48, a0  <~~ Word[0x1001ff50]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
           1967000    0x80003e1c lw a1, 8(sp)                   #; sp  = 0x1001ff48, a1  <~~ Word[0x1001ff50]
           1968000    0x80003e20 lui s7, 1                      #; (wrb) s7  <-- 4096
           1969000    0x80003e24 addi s1, s7, -2032             #; s7  = 4096, (wrb) s1  <-- 2064
           1970000                                              #; (lsu) s0  <-- 12
           1971000                                              #; (lsu) a0  <-- 0x1001ff88
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
           1972000    0x80003e28 add a0, a0, s1                 #; a0  = 0x1001ff88, s1  = 2064, (wrb) a0  <-- 0x10020798
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
           1973000    0x80003e2c mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
           1974000    0x80003e30 auipc ra, 1                    #; (wrb) ra  <-- 0x80004e30
           1975000    0x80003e34 jalr 2012(ra)                  #; ra  = 0x80004e30, (wrb) ra  <-- 0x80003e38, goto 0x8000560c
#; memcpy (memcpy.c:25)
#;   {
           1976000    0x8000560c addi sp, sp, -16               #; sp  = 0x1001ff48, (wrb) sp  <-- 0x1001ff38
           1977000    0x80005610 sw s0, 12(sp)                  #; sp  = 0x1001ff38, 12 ~~> Word[0x1001ff44], (lsu) a1  <-- 0x1001ff88
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           1978000    0x80005614 andi a3, a0, 3                 #; a0  = 0x10020798, (wrb) a3  <-- 0
           1979000    0x80005618 andi a4, a1, 3                 #; a1  = 0x1001ff88, (wrb) a4  <-- 0
           1980000    0x8000561c xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
           1981000    0x80005620 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
           1982000    0x80005624 li a5, 3                       #; (wrb) a5  <-- 3
           1983000    0x80005628 sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
           1984000    0x8000562c and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
           1985000    0x80005630 add a2, a0, a2                 #; a0  = 0x10020798, a2  = 12, (wrb) a2  <-- 0x100207a4
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           1986000    0x80005634 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
           1987000    0x80005638 bnez a3, 116                   #; a3  = 0, not taken
           1988000    0x8000563c mv a4, a0                      #; a0  = 0x10020798, (wrb) a4  <-- 0x10020798
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
           1989000    0x80005640 andi a3, a2, -4                #; a2  = 0x100207a4, (wrb) a3  <-- 0x100207a4
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
           1990000    0x80005644 sub a5, a3, a4                 #; a3  = 0x100207a4, a4  = 0x10020798, (wrb) a5  <-- 12
           1991000    0x80005648 li a6, 33                      #; (wrb) a6  <-- 33
           1992000    0x8000564c bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1993000    0x80005650 bgeu a4, a3, 32                #; a4  = 0x10020798, a3  = 0x100207a4, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           1994000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001ff88, a6  <~~ Word[0x1001ff88]
           1995000    0x80005658 addi a5, a4, 4                 #; a4  = 0x10020798, (wrb) a5  <-- 0x1002079c
           1996000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001ff88, (wrb) a1  <-- 0x1001ff8c
           1997000                                              #; (lsu) a6  <-- 0x80005e80
           1998000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x10020798, 0x80005e80 ~~> Word[0x10020798]
           1999000    0x80005664 mv a4, a5                      #; a5  = 0x1002079c, (wrb) a4  <-- 0x1002079c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2000000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1002079c, a3  = 0x100207a4, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2001000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001ff8c, a6  <~~ Word[0x1001ff8c]
           2002000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1002079c, (wrb) a5  <-- 0x100207a0
           2003000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001ff8c, (wrb) a1  <-- 0x1001ff90
           2010000                                              #; (lsu) a6  <-- 1
           2011000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1002079c, 1 ~~> Word[0x1002079c]
           2012000    0x80005664 mv a4, a5                      #; a5  = 0x100207a0, (wrb) a4  <-- 0x100207a0
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2013000    0x80005668 bltu a5, a3, -20               #; a5  = 0x100207a0, a3  = 0x100207a4, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2014000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001ff90, a6  <~~ Word[0x1001ff90]
           2015000    0x80005658 addi a5, a4, 4                 #; a4  = 0x100207a0, (wrb) a5  <-- 0x100207a4
           2016000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001ff90, (wrb) a1  <-- 0x1001ff94
           2023000                                              #; (lsu) a6  <-- 1
           2024000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x100207a0, 1 ~~> Word[0x100207a0]
           2025000    0x80005664 mv a4, a5                      #; a5  = 0x100207a4, (wrb) a4  <-- 0x100207a4
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2026000    0x80005668 bltu a5, a3, -20               #; a5  = 0x100207a4, a3  = 0x100207a4, not taken
           2027000    0x8000566c j 8                            #; goto 0x80005674
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
           2028000    0x80005674 bltu a5, a2, 20                #; a5  = 0x100207a4, a2  = 0x100207a4, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
           2029000    0x80005678 lw s0, 12(sp)                  #; sp  = 0x1001ff38, s0  <~~ Word[0x1001ff44]
           2030000    0x8000567c addi sp, sp, 16                #; sp  = 0x1001ff38, (wrb) sp  <-- 0x1001ff48
           2031000    0x80005680 ret                            #; ra  = 0x80003e38, goto 0x80003e38
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
           2032000    0x80003e38 lw a0, 8(sp)                   #; sp  = 0x1001ff48, a0  <~~ Word[0x1001ff50]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
           2033000    0x80003e3c lw a1, 8(sp)                   #; sp  = 0x1001ff48, a1  <~~ Word[0x1001ff50]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
           2034000    0x80003e40 ori s6, s1, 1032               #; s1  = 2064, (wrb) s6  <-- 3096
           2036000                                              #; (lsu) s0  <-- 12
           2037000                                              #; (lsu) a0  <-- 0x1001ff88
           2038000    0x80003e44 add a0, a0, s6                 #; a0  = 0x1001ff88, s6  = 3096, (wrb) a0  <-- 0x10020ba0
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
           2039000    0x80003e48 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
           2040000    0x80003e4c auipc ra, 1                    #; (wrb) ra  <-- 0x80004e4c
           2041000    0x80003e50 jalr 1984(ra)                  #; ra  = 0x80004e4c, (wrb) ra  <-- 0x80003e54, goto 0x8000560c
#; memcpy (memcpy.c:25)
#;   {
           2042000    0x8000560c addi sp, sp, -16               #; sp  = 0x1001ff48, (wrb) sp  <-- 0x1001ff38
           2043000    0x80005610 sw s0, 12(sp)                  #; sp  = 0x1001ff38, 12 ~~> Word[0x1001ff44], (lsu) a1  <-- 0x1001ff88
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2044000    0x80005614 andi a3, a0, 3                 #; a0  = 0x10020ba0, (wrb) a3  <-- 0
           2045000    0x80005618 andi a4, a1, 3                 #; a1  = 0x1001ff88, (wrb) a4  <-- 0
           2046000    0x8000561c xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
           2047000    0x80005620 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
           2048000    0x80005624 li a5, 3                       #; (wrb) a5  <-- 3
           2049000    0x80005628 sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
           2050000    0x8000562c and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
           2051000    0x80005630 add a2, a0, a2                 #; a0  = 0x10020ba0, a2  = 12, (wrb) a2  <-- 0x10020bac
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2052000    0x80005634 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
           2053000    0x80005638 bnez a3, 116                   #; a3  = 0, not taken
           2054000    0x8000563c mv a4, a0                      #; a0  = 0x10020ba0, (wrb) a4  <-- 0x10020ba0
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
           2055000    0x80005640 andi a3, a2, -4                #; a2  = 0x10020bac, (wrb) a3  <-- 0x10020bac
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
           2056000    0x80005644 sub a5, a3, a4                 #; a3  = 0x10020bac, a4  = 0x10020ba0, (wrb) a5  <-- 12
           2057000    0x80005648 li a6, 33                      #; (wrb) a6  <-- 33
           2058000    0x8000564c bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2059000    0x80005650 bgeu a4, a3, 32                #; a4  = 0x10020ba0, a3  = 0x10020bac, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2060000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001ff88, a6  <~~ Word[0x1001ff88]
           2061000    0x80005658 addi a5, a4, 4                 #; a4  = 0x10020ba0, (wrb) a5  <-- 0x10020ba4
           2062000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001ff88, (wrb) a1  <-- 0x1001ff8c
           2063000                                              #; (lsu) a6  <-- 0x80005e80
           2064000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x10020ba0, 0x80005e80 ~~> Word[0x10020ba0]
           2065000    0x80005664 mv a4, a5                      #; a5  = 0x10020ba4, (wrb) a4  <-- 0x10020ba4
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2066000    0x80005668 bltu a5, a3, -20               #; a5  = 0x10020ba4, a3  = 0x10020bac, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2067000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001ff8c, a6  <~~ Word[0x1001ff8c]
           2068000    0x80005658 addi a5, a4, 4                 #; a4  = 0x10020ba4, (wrb) a5  <-- 0x10020ba8
           2069000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001ff8c, (wrb) a1  <-- 0x1001ff90
           2076000                                              #; (lsu) a6  <-- 1
           2077000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x10020ba4, 1 ~~> Word[0x10020ba4]
           2078000    0x80005664 mv a4, a5                      #; a5  = 0x10020ba8, (wrb) a4  <-- 0x10020ba8
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2079000    0x80005668 bltu a5, a3, -20               #; a5  = 0x10020ba8, a3  = 0x10020bac, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2080000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001ff90, a6  <~~ Word[0x1001ff90]
           2081000    0x80005658 addi a5, a4, 4                 #; a4  = 0x10020ba8, (wrb) a5  <-- 0x10020bac
           2082000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001ff90, (wrb) a1  <-- 0x1001ff94
           2093000                                              #; (lsu) a6  <-- 1
           2094000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x10020ba8, 1 ~~> Word[0x10020ba8]
           2095000    0x80005664 mv a4, a5                      #; a5  = 0x10020bac, (wrb) a4  <-- 0x10020bac
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2096000    0x80005668 bltu a5, a3, -20               #; a5  = 0x10020bac, a3  = 0x10020bac, not taken
           2097000    0x8000566c j 8                            #; goto 0x80005674
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
           2098000    0x80005674 bltu a5, a2, 20                #; a5  = 0x10020bac, a2  = 0x10020bac, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
           2099000    0x80005678 lw s0, 12(sp)                  #; sp  = 0x1001ff38, s0  <~~ Word[0x1001ff44]
           2100000    0x8000567c addi sp, sp, 16                #; sp  = 0x1001ff38, (wrb) sp  <-- 0x1001ff48
           2101000    0x80005680 ret                            #; ra  = 0x80003e54, goto 0x80003e54
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
           2102000    0x80003e54 lw a0, 8(sp)                   #; sp  = 0x1001ff48, a0  <~~ Word[0x1001ff50]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
           2103000    0x80003e58 lw a1, 8(sp)                   #; sp  = 0x1001ff48, a1  <~~ Word[0x1001ff50]
           2104000    0x80003e5c addi s7, s7, 32                #; s7  = 4096, (wrb) s7  <-- 4128
           2106000                                              #; (lsu) s0  <-- 12
           2107000                                              #; (lsu) a0  <-- 0x1001ff88
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
           2108000    0x80003e60 add a0, a0, s7                 #; a0  = 0x1001ff88, s7  = 4128, (wrb) a0  <-- 0x10020fa8
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
           2109000    0x80003e64 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
           2110000    0x80003e68 auipc ra, 1                    #; (wrb) ra  <-- 0x80004e68
           2111000    0x80003e6c jalr 1956(ra)                  #; ra  = 0x80004e68, (wrb) ra  <-- 0x80003e70, goto 0x8000560c
#; memcpy (memcpy.c:25)
#;   {
           2112000    0x8000560c addi sp, sp, -16               #; sp  = 0x1001ff48, (wrb) sp  <-- 0x1001ff38
           2113000    0x80005610 sw s0, 12(sp)                  #; sp  = 0x1001ff38, 12 ~~> Word[0x1001ff44], (lsu) a1  <-- 0x1001ff88
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2114000    0x80005614 andi a3, a0, 3                 #; a0  = 0x10020fa8, (wrb) a3  <-- 0
           2115000    0x80005618 andi a4, a1, 3                 #; a1  = 0x1001ff88, (wrb) a4  <-- 0
           2116000    0x8000561c xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
           2117000    0x80005620 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
           2118000    0x80005624 li a5, 3                       #; (wrb) a5  <-- 3
           2119000    0x80005628 sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
           2120000    0x8000562c and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
           2121000    0x80005630 add a2, a0, a2                 #; a0  = 0x10020fa8, a2  = 12, (wrb) a2  <-- 0x10020fb4
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2122000    0x80005634 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
           2123000    0x80005638 bnez a3, 116                   #; a3  = 0, not taken
           2124000    0x8000563c mv a4, a0                      #; a0  = 0x10020fa8, (wrb) a4  <-- 0x10020fa8
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
           2125000    0x80005640 andi a3, a2, -4                #; a2  = 0x10020fb4, (wrb) a3  <-- 0x10020fb4
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
           2126000    0x80005644 sub a5, a3, a4                 #; a3  = 0x10020fb4, a4  = 0x10020fa8, (wrb) a5  <-- 12
           2127000    0x80005648 li a6, 33                      #; (wrb) a6  <-- 33
           2128000    0x8000564c bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2129000    0x80005650 bgeu a4, a3, 32                #; a4  = 0x10020fa8, a3  = 0x10020fb4, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2130000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001ff88, a6  <~~ Word[0x1001ff88]
           2131000    0x80005658 addi a5, a4, 4                 #; a4  = 0x10020fa8, (wrb) a5  <-- 0x10020fac
           2132000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001ff88, (wrb) a1  <-- 0x1001ff8c
           2133000                                              #; (lsu) a6  <-- 0x80005e80
           2134000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x10020fa8, 0x80005e80 ~~> Word[0x10020fa8]
           2135000    0x80005664 mv a4, a5                      #; a5  = 0x10020fac, (wrb) a4  <-- 0x10020fac
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2136000    0x80005668 bltu a5, a3, -20               #; a5  = 0x10020fac, a3  = 0x10020fb4, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2137000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001ff8c, a6  <~~ Word[0x1001ff8c]
           2138000    0x80005658 addi a5, a4, 4                 #; a4  = 0x10020fac, (wrb) a5  <-- 0x10020fb0
           2139000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001ff8c, (wrb) a1  <-- 0x1001ff90
           2149000                                              #; (lsu) a6  <-- 1
           2150000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x10020fac, 1 ~~> Word[0x10020fac]
           2151000    0x80005664 mv a4, a5                      #; a5  = 0x10020fb0, (wrb) a4  <-- 0x10020fb0
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2152000    0x80005668 bltu a5, a3, -20               #; a5  = 0x10020fb0, a3  = 0x10020fb4, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2153000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001ff90, a6  <~~ Word[0x1001ff90]
           2154000    0x80005658 addi a5, a4, 4                 #; a4  = 0x10020fb0, (wrb) a5  <-- 0x10020fb4
           2155000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001ff90, (wrb) a1  <-- 0x1001ff94
           2166000                                              #; (lsu) a6  <-- 1
           2167000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x10020fb0, 1 ~~> Word[0x10020fb0]
           2168000    0x80005664 mv a4, a5                      #; a5  = 0x10020fb4, (wrb) a4  <-- 0x10020fb4
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2169000    0x80005668 bltu a5, a3, -20               #; a5  = 0x10020fb4, a3  = 0x10020fb4, not taken
           2170000    0x8000566c j 8                            #; goto 0x80005674
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
           2171000    0x80005674 bltu a5, a2, 20                #; a5  = 0x10020fb4, a2  = 0x10020fb4, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
           2172000    0x80005678 lw s0, 12(sp)                  #; sp  = 0x1001ff38, s0  <~~ Word[0x1001ff44]
           2173000    0x8000567c addi sp, sp, 16                #; sp  = 0x1001ff38, (wrb) sp  <-- 0x1001ff48
           2174000    0x80005680 ret                            #; ra  = 0x80003e70, goto 0x80003e70
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
           2175000    0x80003e70 lw a0, 8(sp)                   #; sp  = 0x1001ff48, a0  <~~ Word[0x1001ff50]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
           2176000    0x80003e74 lw a1, 8(sp)                   #; sp  = 0x1001ff48, a1  <~~ Word[0x1001ff50]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
           2177000    0x80003e78 ori s8, s7, 1032               #; s7  = 4128, (wrb) s8  <-- 5160
           2179000                                              #; (lsu) s0  <-- 12
           2180000                                              #; (lsu) a0  <-- 0x1001ff88
           2181000    0x80003e7c add a0, a0, s8                 #; a0  = 0x1001ff88, s8  = 5160, (wrb) a0  <-- 0x100213b0
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
           2182000    0x80003e80 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
           2183000    0x80003e84 auipc ra, 1                    #; (wrb) ra  <-- 0x80004e84
           2184000    0x80003e88 jalr 1928(ra)                  #; ra  = 0x80004e84, (wrb) ra  <-- 0x80003e8c, goto 0x8000560c
#; memcpy (memcpy.c:25)
#;   {
           2185000    0x8000560c addi sp, sp, -16               #; sp  = 0x1001ff48, (wrb) sp  <-- 0x1001ff38
           2186000    0x80005610 sw s0, 12(sp)                  #; sp  = 0x1001ff38, 12 ~~> Word[0x1001ff44], (lsu) a1  <-- 0x1001ff88
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2187000    0x80005614 andi a3, a0, 3                 #; a0  = 0x100213b0, (wrb) a3  <-- 0
           2188000    0x80005618 andi a4, a1, 3                 #; a1  = 0x1001ff88, (wrb) a4  <-- 0
           2189000    0x8000561c xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
           2190000    0x80005620 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
           2191000    0x80005624 li a5, 3                       #; (wrb) a5  <-- 3
           2192000    0x80005628 sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
           2193000    0x8000562c and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
           2194000    0x80005630 add a2, a0, a2                 #; a0  = 0x100213b0, a2  = 12, (wrb) a2  <-- 0x100213bc
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2195000    0x80005634 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
           2196000    0x80005638 bnez a3, 116                   #; a3  = 0, not taken
           2197000    0x8000563c mv a4, a0                      #; a0  = 0x100213b0, (wrb) a4  <-- 0x100213b0
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
           2198000    0x80005640 andi a3, a2, -4                #; a2  = 0x100213bc, (wrb) a3  <-- 0x100213bc
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
           2199000    0x80005644 sub a5, a3, a4                 #; a3  = 0x100213bc, a4  = 0x100213b0, (wrb) a5  <-- 12
           2200000    0x80005648 li a6, 33                      #; (wrb) a6  <-- 33
           2201000    0x8000564c bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2202000    0x80005650 bgeu a4, a3, 32                #; a4  = 0x100213b0, a3  = 0x100213bc, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2203000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001ff88, a6  <~~ Word[0x1001ff88]
           2204000    0x80005658 addi a5, a4, 4                 #; a4  = 0x100213b0, (wrb) a5  <-- 0x100213b4
           2205000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001ff88, (wrb) a1  <-- 0x1001ff8c
           2206000                                              #; (lsu) a6  <-- 0x80005e80
           2207000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x100213b0, 0x80005e80 ~~> Word[0x100213b0]
           2208000    0x80005664 mv a4, a5                      #; a5  = 0x100213b4, (wrb) a4  <-- 0x100213b4
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2209000    0x80005668 bltu a5, a3, -20               #; a5  = 0x100213b4, a3  = 0x100213bc, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2210000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001ff8c, a6  <~~ Word[0x1001ff8c]
           2211000    0x80005658 addi a5, a4, 4                 #; a4  = 0x100213b4, (wrb) a5  <-- 0x100213b8
           2212000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001ff8c, (wrb) a1  <-- 0x1001ff90
           2224000                                              #; (lsu) a6  <-- 1
           2225000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x100213b4, 1 ~~> Word[0x100213b4]
           2226000    0x80005664 mv a4, a5                      #; a5  = 0x100213b8, (wrb) a4  <-- 0x100213b8
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2227000    0x80005668 bltu a5, a3, -20               #; a5  = 0x100213b8, a3  = 0x100213bc, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2228000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001ff90, a6  <~~ Word[0x1001ff90]
           2229000    0x80005658 addi a5, a4, 4                 #; a4  = 0x100213b8, (wrb) a5  <-- 0x100213bc
           2230000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001ff90, (wrb) a1  <-- 0x1001ff94
           2247000                                              #; (lsu) a6  <-- 1
           2248000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x100213b8, 1 ~~> Word[0x100213b8]
           2249000    0x80005664 mv a4, a5                      #; a5  = 0x100213bc, (wrb) a4  <-- 0x100213bc
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2250000    0x80005668 bltu a5, a3, -20               #; a5  = 0x100213bc, a3  = 0x100213bc, not taken
           2251000    0x8000566c j 8                            #; goto 0x80005674
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
           2252000    0x80005674 bltu a5, a2, 20                #; a5  = 0x100213bc, a2  = 0x100213bc, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
           2253000    0x80005678 lw s0, 12(sp)                  #; sp  = 0x1001ff38, s0  <~~ Word[0x1001ff44]
           2254000    0x8000567c addi sp, sp, 16                #; sp  = 0x1001ff38, (wrb) sp  <-- 0x1001ff48
           2255000    0x80005680 ret                            #; ra  = 0x80003e8c, goto 0x80003e8c
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
           2265000    0x80003e8c lw a0, 8(sp)                   #; sp  = 0x1001ff48, a0  <~~ Word[0x1001ff50]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
           2266000    0x80003e90 lw a1, 8(sp)                   #; sp  = 0x1001ff48, a1  <~~ Word[0x1001ff50]
           2267000    0x80003e94 lui s11, 2                     #; (wrb) s11 <-- 8192
           2268000    0x80003e98 addi s9, s11, -2000            #; s11 = 8192, (wrb) s9  <-- 6192
           2272000                                              #; (lsu) s0  <-- 12
           2273000                                              #; (lsu) a0  <-- 0x1001ff88
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
           2274000    0x80003e9c add a0, a0, s9                 #; a0  = 0x1001ff88, s9  = 6192, (wrb) a0  <-- 0x100217b8
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
           2275000    0x80003ea0 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
           2276000    0x80003ea4 auipc ra, 1                    #; (wrb) ra  <-- 0x80004ea4
           2277000    0x80003ea8 jalr 1896(ra)                  #; ra  = 0x80004ea4, (wrb) ra  <-- 0x80003eac, goto 0x8000560c
#; memcpy (memcpy.c:25)
#;   {
           2278000    0x8000560c addi sp, sp, -16               #; sp  = 0x1001ff48, (wrb) sp  <-- 0x1001ff38
           2279000    0x80005610 sw s0, 12(sp)                  #; sp  = 0x1001ff38, 12 ~~> Word[0x1001ff44], (lsu) a1  <-- 0x1001ff88
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2280000    0x80005614 andi a3, a0, 3                 #; a0  = 0x100217b8, (wrb) a3  <-- 0
           2281000    0x80005618 andi a4, a1, 3                 #; a1  = 0x1001ff88, (wrb) a4  <-- 0
           2282000    0x8000561c xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
           2283000    0x80005620 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
           2284000    0x80005624 li a5, 3                       #; (wrb) a5  <-- 3
           2285000    0x80005628 sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
           2286000    0x8000562c and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
           2287000    0x80005630 add a2, a0, a2                 #; a0  = 0x100217b8, a2  = 12, (wrb) a2  <-- 0x100217c4
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2288000    0x80005634 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
           2289000    0x80005638 bnez a3, 116                   #; a3  = 0, not taken
           2290000    0x8000563c mv a4, a0                      #; a0  = 0x100217b8, (wrb) a4  <-- 0x100217b8
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
           2291000    0x80005640 andi a3, a2, -4                #; a2  = 0x100217c4, (wrb) a3  <-- 0x100217c4
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
           2292000    0x80005644 sub a5, a3, a4                 #; a3  = 0x100217c4, a4  = 0x100217b8, (wrb) a5  <-- 12
           2293000    0x80005648 li a6, 33                      #; (wrb) a6  <-- 33
           2294000    0x8000564c bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2295000    0x80005650 bgeu a4, a3, 32                #; a4  = 0x100217b8, a3  = 0x100217c4, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2296000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001ff88, a6  <~~ Word[0x1001ff88]
           2297000    0x80005658 addi a5, a4, 4                 #; a4  = 0x100217b8, (wrb) a5  <-- 0x100217bc
           2298000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001ff88, (wrb) a1  <-- 0x1001ff8c
           2299000                                              #; (lsu) a6  <-- 0x80005e80
           2300000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x100217b8, 0x80005e80 ~~> Word[0x100217b8]
           2301000    0x80005664 mv a4, a5                      #; a5  = 0x100217bc, (wrb) a4  <-- 0x100217bc
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2302000    0x80005668 bltu a5, a3, -20               #; a5  = 0x100217bc, a3  = 0x100217c4, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2303000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001ff8c, a6  <~~ Word[0x1001ff8c]
           2304000    0x80005658 addi a5, a4, 4                 #; a4  = 0x100217bc, (wrb) a5  <-- 0x100217c0
           2305000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001ff8c, (wrb) a1  <-- 0x1001ff90
           2335000                                              #; (lsu) a6  <-- 1
           2336000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x100217bc, 1 ~~> Word[0x100217bc]
           2337000    0x80005664 mv a4, a5                      #; a5  = 0x100217c0, (wrb) a4  <-- 0x100217c0
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2338000    0x80005668 bltu a5, a3, -20               #; a5  = 0x100217c0, a3  = 0x100217c4, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2339000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001ff90, a6  <~~ Word[0x1001ff90]
           2340000    0x80005658 addi a5, a4, 4                 #; a4  = 0x100217c0, (wrb) a5  <-- 0x100217c4
           2341000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001ff90, (wrb) a1  <-- 0x1001ff94
           2362000                                              #; (lsu) a6  <-- 1
           2363000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x100217c0, 1 ~~> Word[0x100217c0]
           2364000    0x80005664 mv a4, a5                      #; a5  = 0x100217c4, (wrb) a4  <-- 0x100217c4
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2365000    0x80005668 bltu a5, a3, -20               #; a5  = 0x100217c4, a3  = 0x100217c4, not taken
           2366000    0x8000566c j 8                            #; goto 0x80005674
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
           2367000    0x80005674 bltu a5, a2, 20                #; a5  = 0x100217c4, a2  = 0x100217c4, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
           2368000    0x80005678 lw s0, 12(sp)                  #; sp  = 0x1001ff38, s0  <~~ Word[0x1001ff44]
           2369000    0x8000567c addi sp, sp, 16                #; sp  = 0x1001ff38, (wrb) sp  <-- 0x1001ff48
           2370000    0x80005680 ret                            #; ra  = 0x80003eac, goto 0x80003eac
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
           2382000    0x80003eac lw a0, 8(sp)                   #; sp  = 0x1001ff48, a0  <~~ Word[0x1001ff50]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
           2383000    0x80003eb0 lw a1, 8(sp)                   #; sp  = 0x1001ff48, a1  <~~ Word[0x1001ff50]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
           2384000    0x80003eb4 ori s10, s9, 1032              #; s9  = 6192, (wrb) s10 <-- 7224
           2389000                                              #; (lsu) s0  <-- 12
           2390000                                              #; (lsu) a0  <-- 0x1001ff88
           2391000    0x80003eb8 add a0, a0, s10                #; a0  = 0x1001ff88, s10 = 7224, (wrb) a0  <-- 0x10021bc0
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
           2392000    0x80003ebc mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
           2393000    0x80003ec0 auipc ra, 1                    #; (wrb) ra  <-- 0x80004ec0
           2394000    0x80003ec4 jalr 1868(ra)                  #; ra  = 0x80004ec0, (wrb) ra  <-- 0x80003ec8, goto 0x8000560c
#; memcpy (memcpy.c:25)
#;   {
           2395000    0x8000560c addi sp, sp, -16               #; sp  = 0x1001ff48, (wrb) sp  <-- 0x1001ff38
           2396000    0x80005610 sw s0, 12(sp)                  #; sp  = 0x1001ff38, 12 ~~> Word[0x1001ff44], (lsu) a1  <-- 0x1001ff88
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2397000    0x80005614 andi a3, a0, 3                 #; a0  = 0x10021bc0, (wrb) a3  <-- 0
           2398000    0x80005618 andi a4, a1, 3                 #; a1  = 0x1001ff88, (wrb) a4  <-- 0
           2399000    0x8000561c xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
           2400000    0x80005620 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
           2401000    0x80005624 li a5, 3                       #; (wrb) a5  <-- 3
           2402000    0x80005628 sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
           2403000    0x8000562c and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
           2404000    0x80005630 add a2, a0, a2                 #; a0  = 0x10021bc0, a2  = 12, (wrb) a2  <-- 0x10021bcc
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2405000    0x80005634 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
           2406000    0x80005638 bnez a3, 116                   #; a3  = 0, not taken
           2407000    0x8000563c mv a4, a0                      #; a0  = 0x10021bc0, (wrb) a4  <-- 0x10021bc0
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
           2408000    0x80005640 andi a3, a2, -4                #; a2  = 0x10021bcc, (wrb) a3  <-- 0x10021bcc
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
           2409000    0x80005644 sub a5, a3, a4                 #; a3  = 0x10021bcc, a4  = 0x10021bc0, (wrb) a5  <-- 12
           2410000    0x80005648 li a6, 33                      #; (wrb) a6  <-- 33
           2411000    0x8000564c bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2412000    0x80005650 bgeu a4, a3, 32                #; a4  = 0x10021bc0, a3  = 0x10021bcc, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2413000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001ff88, a6  <~~ Word[0x1001ff88]
           2414000    0x80005658 addi a5, a4, 4                 #; a4  = 0x10021bc0, (wrb) a5  <-- 0x10021bc4
           2415000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001ff88, (wrb) a1  <-- 0x1001ff8c
           2416000                                              #; (lsu) a6  <-- 0x80005e80
           2417000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x10021bc0, 0x80005e80 ~~> Word[0x10021bc0]
           2418000    0x80005664 mv a4, a5                      #; a5  = 0x10021bc4, (wrb) a4  <-- 0x10021bc4
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2419000    0x80005668 bltu a5, a3, -20               #; a5  = 0x10021bc4, a3  = 0x10021bcc, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2420000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001ff8c, a6  <~~ Word[0x1001ff8c]
           2421000    0x80005658 addi a5, a4, 4                 #; a4  = 0x10021bc4, (wrb) a5  <-- 0x10021bc8
           2422000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001ff8c, (wrb) a1  <-- 0x1001ff90
           2447000                                              #; (lsu) a6  <-- 1
           2448000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x10021bc4, 1 ~~> Word[0x10021bc4]
           2449000    0x80005664 mv a4, a5                      #; a5  = 0x10021bc8, (wrb) a4  <-- 0x10021bc8
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2450000    0x80005668 bltu a5, a3, -20               #; a5  = 0x10021bc8, a3  = 0x10021bcc, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2451000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001ff90, a6  <~~ Word[0x1001ff90]
           2452000    0x80005658 addi a5, a4, 4                 #; a4  = 0x10021bc8, (wrb) a5  <-- 0x10021bcc
           2453000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001ff90, (wrb) a1  <-- 0x1001ff94
           2477000                                              #; (lsu) a6  <-- 1
           2478000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x10021bc8, 1 ~~> Word[0x10021bc8]
           2479000    0x80005664 mv a4, a5                      #; a5  = 0x10021bcc, (wrb) a4  <-- 0x10021bcc
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2480000    0x80005668 bltu a5, a3, -20               #; a5  = 0x10021bcc, a3  = 0x10021bcc, not taken
           2481000    0x8000566c j 8                            #; goto 0x80005674
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
           2482000    0x80005674 bltu a5, a2, 20                #; a5  = 0x10021bcc, a2  = 0x10021bcc, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
           2483000    0x80005678 lw s0, 12(sp)                  #; sp  = 0x1001ff38, s0  <~~ Word[0x1001ff44]
           2484000    0x8000567c addi sp, sp, 16                #; sp  = 0x1001ff38, (wrb) sp  <-- 0x1001ff48
           2485000    0x80005680 ret                            #; ra  = 0x80003ec8, goto 0x80003ec8
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
           2486000    0x80003ec8 lw a0, 8(sp)                   #; sp  = 0x1001ff48, a0  <~~ Word[0x1001ff50]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
           2487000    0x80003ecc lw a1, 8(sp)                   #; sp  = 0x1001ff48, a1  <~~ Word[0x1001ff50]
           2488000    0x80003ed0 addi s11, s11, 64              #; s11 = 8192, (wrb) s11 <-- 8256
           2497000                                              #; (lsu) s0  <-- 12
           2498000                                              #; (lsu) a0  <-- 0x1001ff88
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
           2499000    0x80003ed4 add a0, a0, s11                #; a0  = 0x1001ff88, s11 = 8256, (wrb) a0  <-- 0x10021fc8
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
           2500000    0x80003ed8 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
           2501000    0x80003edc auipc ra, 1                    #; (wrb) ra  <-- 0x80004edc
           2502000    0x80003ee0 jalr 1840(ra)                  #; ra  = 0x80004edc, (wrb) ra  <-- 0x80003ee4, goto 0x8000560c
#; memcpy (memcpy.c:25)
#;   {
           2503000    0x8000560c addi sp, sp, -16               #; sp  = 0x1001ff48, (wrb) sp  <-- 0x1001ff38
           2504000    0x80005610 sw s0, 12(sp)                  #; sp  = 0x1001ff38, 12 ~~> Word[0x1001ff44], (lsu) a1  <-- 0x1001ff88
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2505000    0x80005614 andi a3, a0, 3                 #; a0  = 0x10021fc8, (wrb) a3  <-- 0
           2506000    0x80005618 andi a4, a1, 3                 #; a1  = 0x1001ff88, (wrb) a4  <-- 0
           2507000    0x8000561c xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
           2508000    0x80005620 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
           2509000    0x80005624 li a5, 3                       #; (wrb) a5  <-- 3
           2510000    0x80005628 sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
           2511000    0x8000562c and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
           2512000    0x80005630 add a2, a0, a2                 #; a0  = 0x10021fc8, a2  = 12, (wrb) a2  <-- 0x10021fd4
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2513000    0x80005634 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
           2514000    0x80005638 bnez a3, 116                   #; a3  = 0, not taken
           2515000    0x8000563c mv a4, a0                      #; a0  = 0x10021fc8, (wrb) a4  <-- 0x10021fc8
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
           2516000    0x80005640 andi a3, a2, -4                #; a2  = 0x10021fd4, (wrb) a3  <-- 0x10021fd4
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
           2517000    0x80005644 sub a5, a3, a4                 #; a3  = 0x10021fd4, a4  = 0x10021fc8, (wrb) a5  <-- 12
           2518000    0x80005648 li a6, 33                      #; (wrb) a6  <-- 33
           2519000    0x8000564c bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2520000    0x80005650 bgeu a4, a3, 32                #; a4  = 0x10021fc8, a3  = 0x10021fd4, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2521000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001ff88, a6  <~~ Word[0x1001ff88]
           2522000    0x80005658 addi a5, a4, 4                 #; a4  = 0x10021fc8, (wrb) a5  <-- 0x10021fcc
           2523000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001ff88, (wrb) a1  <-- 0x1001ff8c
           2526000                                              #; (lsu) a6  <-- 0x80005e80
           2527000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x10021fc8, 0x80005e80 ~~> Word[0x10021fc8]
           2528000    0x80005664 mv a4, a5                      #; a5  = 0x10021fcc, (wrb) a4  <-- 0x10021fcc
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2529000    0x80005668 bltu a5, a3, -20               #; a5  = 0x10021fcc, a3  = 0x10021fd4, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2530000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001ff8c, a6  <~~ Word[0x1001ff8c]
           2531000    0x80005658 addi a5, a4, 4                 #; a4  = 0x10021fcc, (wrb) a5  <-- 0x10021fd0
           2532000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001ff8c, (wrb) a1  <-- 0x1001ff90
           2536000                                              #; (lsu) a6  <-- 1
           2537000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x10021fcc, 1 ~~> Word[0x10021fcc]
           2538000    0x80005664 mv a4, a5                      #; a5  = 0x10021fd0, (wrb) a4  <-- 0x10021fd0
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2539000    0x80005668 bltu a5, a3, -20               #; a5  = 0x10021fd0, a3  = 0x10021fd4, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2540000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001ff90, a6  <~~ Word[0x1001ff90]
           2541000    0x80005658 addi a5, a4, 4                 #; a4  = 0x10021fd0, (wrb) a5  <-- 0x10021fd4
           2542000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001ff90, (wrb) a1  <-- 0x1001ff94
           2546000                                              #; (lsu) a6  <-- 1
           2547000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x10021fd0, 1 ~~> Word[0x10021fd0]
           2548000    0x80005664 mv a4, a5                      #; a5  = 0x10021fd4, (wrb) a4  <-- 0x10021fd4
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2549000    0x80005668 bltu a5, a3, -20               #; a5  = 0x10021fd4, a3  = 0x10021fd4, not taken
           2550000    0x8000566c j 8                            #; goto 0x80005674
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
           2551000    0x80005674 bltu a5, a2, 20                #; a5  = 0x10021fd4, a2  = 0x10021fd4, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
           2552000    0x80005678 lw s0, 12(sp)                  #; sp  = 0x1001ff38, s0  <~~ Word[0x1001ff44]
           2553000    0x8000567c addi sp, sp, 16                #; sp  = 0x1001ff38, (wrb) sp  <-- 0x1001ff48
           2554000    0x80005680 ret                            #; ra  = 0x80003ee4, goto 0x80003ee4
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:79:17)
#;     tls_ptr += size;
#;             ^
           2555000    0x80003ee4 lw a0, 8(sp)                   #; sp  = 0x1001ff48, a0  <~~ Word[0x1001ff50]
           2556000                                              #; (lsu) s0  <-- 12
           2558000                                              #; (lsu) a0  <-- 0x1001ff88
           2559000    0x80003ee8 add a0, a0, s0                 #; a0  = 0x1001ff88, s0  = 12, (wrb) a0  <-- 0x1001ff94
           2560000    0x80003eec sw a0, 8(sp)                   #; sp  = 0x1001ff48, 0x1001ff94 ~~> Word[0x1001ff50]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
           2561000    0x80003ef0 lw a0, 8(sp)                   #; sp  = 0x1001ff48, a0  <~~ Word[0x1001ff50]
#; .LBB25_25 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
           2562000    0x80003ef4 auipc a1, 2                    #; (wrb) a1  <-- 0x80005ef4
           2563000    0x80003ef8 addi a1, a1, -412              #; a1  = 0x80005ef4, (wrb) a1  <-- 0x80005d58
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
           2564000    0x80003efc auipc a2, 2                    #; (wrb) a2  <-- 0x80005efc
           2565000                                              #; (lsu) a0  <-- 0x1001ff94
           2567000    0x80003f00 addi a2, a2, -356              #; a2  = 0x80005efc, (wrb) a2  <-- 0x80005d98
           2568000    0x80003f04 sub s0, a2, a1                 #; a2  = 0x80005d98, a1  = 0x80005d58, (wrb) s0  <-- 64
           2569000    0x80003f08 li a1, 0                       #; (wrb) a1  <-- 0
           2570000    0x80003f0c mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
           2571000    0x80003f10 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f10
           2572000    0x80003f14 jalr 764(ra)                   #; ra  = 0x80003f10, (wrb) ra  <-- 0x80003f18, goto 0x8000420c
#; memset (memset.S:30)
#;   li t1, 15
           2575000    0x8000420c li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
           2576000    0x80004210 mv a4, a0                      #; a0  = 0x1001ff94, (wrb) a4  <-- 0x1001ff94
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
           2577000    0x80004214 bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
           2578000    0x80004218 andi a5, a4, 15                #; a4  = 0x1001ff94, (wrb) a5  <-- 4
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
           2579000    0x8000421c bnez a5, 160                   #; a5  = 4, taken, goto 0x800042bc
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
           2582000    0x800042bc slli a3, a5, 2                 #; a5  = 4, (wrb) a3  <-- 16
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
           2585000    0x800042c0 auipc t0, 0                    #; (wrb) t0  <-- 0x800042c0
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
           2586000    0x800042c4 add a3, a3, t0                 #; a3  = 16, t0  = 0x800042c0, (wrb) a3  <-- 0x800042d0
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
           2587000    0x800042c8 mv t0, ra                      #; ra  = 0x80003f18, (wrb) t0  <-- 0x80003f18
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
           2588000    0x800042cc jalr -96(a3)                   #; a3  = 0x800042d0, (wrb) ra  <-- 0x800042d0, goto 0x80004270
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
           2591000    0x80004270 sb a1, 11(a4)                  #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9f]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
           2592000    0x80004274 sb a1, 10(a4)                  #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9e]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
           2593000    0x80004278 sb a1, 9(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9d]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
           2594000    0x8000427c sb a1, 8(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9c]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
           2596000    0x80004280 sb a1, 7(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9b]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
           2598000    0x80004284 sb a1, 6(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9a]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
           2599000    0x80004288 sb a1, 5(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff99]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
           2600000    0x8000428c sb a1, 4(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff98]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           2601000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff97]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           2602000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff96]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           2603000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff95]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           2604000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff94]
#; .Ltable (memset.S:85)
#;   ret
           2605000    0x800042a0 ret                            #; ra  = 0x800042d0, goto 0x800042d0
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           2606000    0x800042d0 mv ra, t0                      #; t0  = 0x80003f18, (wrb) ra  <-- 0x80003f18
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           2607000    0x800042d4 addi a5, a5, -16               #; a5  = 4, (wrb) a5  <-- -12
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           2608000    0x800042d8 sub a4, a4, a5                 #; a4  = 0x1001ff94, a5  = -12, (wrb) a4  <-- 0x1001ffa0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           2609000    0x800042dc add a2, a2, a5                 #; a2  = 64, a5  = -12, (wrb) a2  <-- 52
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           2610000    0x800042e0 bgeu t1, a2, -144              #; t1  = 15, a2  = 52, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           2611000    0x800042e4 j -196                         #; goto 0x80004220
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           2612000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           2613000    0x80004224 andi a3, a2, -16               #; a2  = 52, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           2614000    0x80004228 andi a2, a2, 15                #; a2  = 52, (wrb) a2  <-- 4
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           2615000    0x8000422c add a3, a3, a4                 #; a3  = 48, a4  = 0x1001ffa0, (wrb) a3  <-- 0x1001ffd0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2616000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001ffa0, 0 ~~> Word[0x1001ffa0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2617000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001ffa0, 0 ~~> Word[0x1001ffa4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2619000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001ffa0, 0 ~~> Word[0x1001ffa8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2621000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001ffa0, 0 ~~> Word[0x1001ffac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2622000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001ffa0, (wrb) a4  <-- 0x1001ffb0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2623000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001ffb0, a3  = 0x1001ffd0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2624000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001ffb0, 0 ~~> Word[0x1001ffb0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2625000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001ffb0, 0 ~~> Word[0x1001ffb4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2626000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001ffb0, 0 ~~> Word[0x1001ffb8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2627000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001ffb0, 0 ~~> Word[0x1001ffbc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2628000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001ffb0, (wrb) a4  <-- 0x1001ffc0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2629000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001ffc0, a3  = 0x1001ffd0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2630000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001ffc0, 0 ~~> Word[0x1001ffc0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2631000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001ffc0, 0 ~~> Word[0x1001ffc4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2632000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001ffc0, 0 ~~> Word[0x1001ffc8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2634000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001ffc0, 0 ~~> Word[0x1001ffcc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2635000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001ffc0, (wrb) a4  <-- 0x1001ffd0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2636000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001ffd0, a3  = 0x1001ffd0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           2637000    0x80004248 bnez a2, 8                     #; a2  = 4, taken, goto 0x80004250
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
           2638000    0x80004250 sub a3, t1, a2                 #; t1  = 15, a2  = 4, (wrb) a3  <-- 11
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
           2639000    0x80004254 slli a3, a3, 2                 #; a3  = 11, (wrb) a3  <-- 44
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
           2640000    0x80004258 auipc t0, 0                    #; (wrb) t0  <-- 0x80004258
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
           2641000    0x8000425c add a3, a3, t0                 #; a3  = 44, t0  = 0x80004258, (wrb) a3  <-- 0x80004284
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
           2642000    0x80004260 jr 12(a3)                      #; a3  = 0x80004284, goto 0x80004290
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           2643000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x1001ffd0, 0 ~~> Byte[0x1001ffd3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           2644000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x1001ffd0, 0 ~~> Byte[0x1001ffd2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           2645000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x1001ffd0, 0 ~~> Byte[0x1001ffd1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           2646000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x1001ffd0, 0 ~~> Byte[0x1001ffd0]
#; .Ltable (memset.S:85)
#;   ret
           2647000    0x800042a0 ret                            #; ra  = 0x80003f18, goto 0x80003f18
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
           2648000    0x80003f18 lw a0, 8(sp)                   #; sp  = 0x1001ff48, a0  <~~ Word[0x1001ff50]
           2651000                                              #; (lsu) a0  <-- 0x1001ff94
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
           2652000    0x80003f1c addi a0, a0, 1032              #; a0  = 0x1001ff94, (wrb) a0  <-- 0x1002039c
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
           2653000    0x80003f20 li a1, 0                       #; (wrb) a1  <-- 0
           2654000    0x80003f24 mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
           2655000    0x80003f28 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f28
           2656000    0x80003f2c jalr 740(ra)                   #; ra  = 0x80003f28, (wrb) ra  <-- 0x80003f30, goto 0x8000420c
#; memset (memset.S:30)
#;   li t1, 15
           2657000    0x8000420c li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
           2658000    0x80004210 mv a4, a0                      #; a0  = 0x1002039c, (wrb) a4  <-- 0x1002039c
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
           2659000    0x80004214 bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
           2660000    0x80004218 andi a5, a4, 15                #; a4  = 0x1002039c, (wrb) a5  <-- 12
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
           2661000    0x8000421c bnez a5, 160                   #; a5  = 12, taken, goto 0x800042bc
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
           2662000    0x800042bc slli a3, a5, 2                 #; a5  = 12, (wrb) a3  <-- 48
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
           2663000    0x800042c0 auipc t0, 0                    #; (wrb) t0  <-- 0x800042c0
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
           2664000    0x800042c4 add a3, a3, t0                 #; a3  = 48, t0  = 0x800042c0, (wrb) a3  <-- 0x800042f0
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
           2665000    0x800042c8 mv t0, ra                      #; ra  = 0x80003f30, (wrb) t0  <-- 0x80003f30
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
           2666000    0x800042cc jalr -96(a3)                   #; a3  = 0x800042f0, (wrb) ra  <-- 0x800042d0, goto 0x80004290
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           2667000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x1002039c, 0 ~~> Byte[0x1002039f]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           2668000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x1002039c, 0 ~~> Byte[0x1002039e]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           2669000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x1002039c, 0 ~~> Byte[0x1002039d]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           2670000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x1002039c, 0 ~~> Byte[0x1002039c]
#; .Ltable (memset.S:85)
#;   ret
           2671000    0x800042a0 ret                            #; ra  = 0x800042d0, goto 0x800042d0
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           2672000    0x800042d0 mv ra, t0                      #; t0  = 0x80003f30, (wrb) ra  <-- 0x80003f30
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           2673000    0x800042d4 addi a5, a5, -16               #; a5  = 12, (wrb) a5  <-- -4
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           2674000    0x800042d8 sub a4, a4, a5                 #; a4  = 0x1002039c, a5  = -4, (wrb) a4  <-- 0x100203a0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           2675000    0x800042dc add a2, a2, a5                 #; a2  = 64, a5  = -4, (wrb) a2  <-- 60
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           2676000    0x800042e0 bgeu t1, a2, -144              #; t1  = 15, a2  = 60, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           2677000    0x800042e4 j -196                         #; goto 0x80004220
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           2678000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           2679000    0x80004224 andi a3, a2, -16               #; a2  = 60, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           2680000    0x80004228 andi a2, a2, 15                #; a2  = 60, (wrb) a2  <-- 12
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           2681000    0x8000422c add a3, a3, a4                 #; a3  = 48, a4  = 0x100203a0, (wrb) a3  <-- 0x100203d0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2682000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x100203a0, 0 ~~> Word[0x100203a0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2683000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x100203a0, 0 ~~> Word[0x100203a4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2689000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x100203a0, 0 ~~> Word[0x100203a8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2690000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x100203a0, 0 ~~> Word[0x100203ac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2691000    0x80004240 addi a4, a4, 16                #; a4  = 0x100203a0, (wrb) a4  <-- 0x100203b0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2692000    0x80004244 bltu a4, a3, -20               #; a4  = 0x100203b0, a3  = 0x100203d0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2699000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x100203b0, 0 ~~> Word[0x100203b0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2700000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x100203b0, 0 ~~> Word[0x100203b4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2709000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x100203b0, 0 ~~> Word[0x100203b8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2710000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x100203b0, 0 ~~> Word[0x100203bc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2711000    0x80004240 addi a4, a4, 16                #; a4  = 0x100203b0, (wrb) a4  <-- 0x100203c0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2712000    0x80004244 bltu a4, a3, -20               #; a4  = 0x100203c0, a3  = 0x100203d0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2719000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x100203c0, 0 ~~> Word[0x100203c0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2720000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x100203c0, 0 ~~> Word[0x100203c4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2729000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x100203c0, 0 ~~> Word[0x100203c8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2730000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x100203c0, 0 ~~> Word[0x100203cc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2731000    0x80004240 addi a4, a4, 16                #; a4  = 0x100203c0, (wrb) a4  <-- 0x100203d0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2732000    0x80004244 bltu a4, a3, -20               #; a4  = 0x100203d0, a3  = 0x100203d0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           2733000    0x80004248 bnez a2, 8                     #; a2  = 12, taken, goto 0x80004250
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
           2734000    0x80004250 sub a3, t1, a2                 #; t1  = 15, a2  = 12, (wrb) a3  <-- 3
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
           2735000    0x80004254 slli a3, a3, 2                 #; a3  = 3, (wrb) a3  <-- 12
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
           2736000    0x80004258 auipc t0, 0                    #; (wrb) t0  <-- 0x80004258
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
           2737000    0x8000425c add a3, a3, t0                 #; a3  = 12, t0  = 0x80004258, (wrb) a3  <-- 0x80004264
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
           2738000    0x80004260 jr 12(a3)                      #; a3  = 0x80004264, goto 0x80004270
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
           2739000    0x80004270 sb a1, 11(a4)                  #; a4  = 0x100203d0, 0 ~~> Byte[0x100203db]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
           2740000    0x80004274 sb a1, 10(a4)                  #; a4  = 0x100203d0, 0 ~~> Byte[0x100203da]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
           2749000    0x80004278 sb a1, 9(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d9]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
           2750000    0x8000427c sb a1, 8(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d8]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
           2760000    0x80004280 sb a1, 7(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d7]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
           2770000    0x80004284 sb a1, 6(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d6]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
           2780000    0x80004288 sb a1, 5(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d5]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
           2790000    0x8000428c sb a1, 4(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d4]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           2800000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           2819000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           2830000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           2849000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d0]
#; .Ltable (memset.S:85)
#;   ret
           2850000    0x800042a0 ret                            #; ra  = 0x80003f30, goto 0x80003f30
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
           2869000    0x80003f30 lw a0, 8(sp)                   #; sp  = 0x1001ff48, a0  <~~ Word[0x1001ff50]
           2899000                                              #; (lsu) a0  <-- 0x1001ff94
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
           2900000    0x80003f34 add a0, a0, s1                 #; a0  = 0x1001ff94, s1  = 2064, (wrb) a0  <-- 0x100207a4
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
           2901000    0x80003f38 li a1, 0                       #; (wrb) a1  <-- 0
           2902000    0x80003f3c mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
           2905000    0x80003f40 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f40
           2906000    0x80003f44 jalr 716(ra)                   #; ra  = 0x80003f40, (wrb) ra  <-- 0x80003f48, goto 0x8000420c
#; memset (memset.S:30)
#;   li t1, 15
           2907000    0x8000420c li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
           2908000    0x80004210 mv a4, a0                      #; a0  = 0x100207a4, (wrb) a4  <-- 0x100207a4
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
           2909000    0x80004214 bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
           2910000    0x80004218 andi a5, a4, 15                #; a4  = 0x100207a4, (wrb) a5  <-- 4
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
           2911000    0x8000421c bnez a5, 160                   #; a5  = 4, taken, goto 0x800042bc
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
           2912000    0x800042bc slli a3, a5, 2                 #; a5  = 4, (wrb) a3  <-- 16
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
           2913000    0x800042c0 auipc t0, 0                    #; (wrb) t0  <-- 0x800042c0
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
           2914000    0x800042c4 add a3, a3, t0                 #; a3  = 16, t0  = 0x800042c0, (wrb) a3  <-- 0x800042d0
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
           2915000    0x800042c8 mv t0, ra                      #; ra  = 0x80003f48, (wrb) t0  <-- 0x80003f48
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
           2916000    0x800042cc jalr -96(a3)                   #; a3  = 0x800042d0, (wrb) ra  <-- 0x800042d0, goto 0x80004270
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
           2917000    0x80004270 sb a1, 11(a4)                  #; a4  = 0x100207a4, 0 ~~> Byte[0x100207af]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
           2918000    0x80004274 sb a1, 10(a4)                  #; a4  = 0x100207a4, 0 ~~> Byte[0x100207ae]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
           2929000    0x80004278 sb a1, 9(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207ad]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
           2959000    0x8000427c sb a1, 8(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207ac]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
           2989000    0x80004280 sb a1, 7(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207ab]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
           3029000    0x80004284 sb a1, 6(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207aa]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
           3069000    0x80004288 sb a1, 5(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207a9]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
           3109000    0x8000428c sb a1, 4(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207a8]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           3149000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207a7]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           3189000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207a6]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           3229000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207a5]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           3269000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207a4]
#; .Ltable (memset.S:85)
#;   ret
           3270000    0x800042a0 ret                            #; ra  = 0x800042d0, goto 0x800042d0
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           3271000    0x800042d0 mv ra, t0                      #; t0  = 0x80003f48, (wrb) ra  <-- 0x80003f48
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           3272000    0x800042d4 addi a5, a5, -16               #; a5  = 4, (wrb) a5  <-- -12
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           3273000    0x800042d8 sub a4, a4, a5                 #; a4  = 0x100207a4, a5  = -12, (wrb) a4  <-- 0x100207b0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           3274000    0x800042dc add a2, a2, a5                 #; a2  = 64, a5  = -12, (wrb) a2  <-- 52
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           3275000    0x800042e0 bgeu t1, a2, -144              #; t1  = 15, a2  = 52, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           3276000    0x800042e4 j -196                         #; goto 0x80004220
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           3277000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           3278000    0x80004224 andi a3, a2, -16               #; a2  = 52, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           3279000    0x80004228 andi a2, a2, 15                #; a2  = 52, (wrb) a2  <-- 4
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           3280000    0x8000422c add a3, a3, a4                 #; a3  = 48, a4  = 0x100207b0, (wrb) a3  <-- 0x100207e0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           3309000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x100207b0, 0 ~~> Word[0x100207b0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           3349000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x100207b0, 0 ~~> Word[0x100207b4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           3389000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x100207b0, 0 ~~> Word[0x100207b8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           3429000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x100207b0, 0 ~~> Word[0x100207bc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           3430000    0x80004240 addi a4, a4, 16                #; a4  = 0x100207b0, (wrb) a4  <-- 0x100207c0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           3431000    0x80004244 bltu a4, a3, -20               #; a4  = 0x100207c0, a3  = 0x100207e0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           3469000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x100207c0, 0 ~~> Word[0x100207c0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           3509000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x100207c0, 0 ~~> Word[0x100207c4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           3549000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x100207c0, 0 ~~> Word[0x100207c8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           3589000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x100207c0, 0 ~~> Word[0x100207cc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           3590000    0x80004240 addi a4, a4, 16                #; a4  = 0x100207c0, (wrb) a4  <-- 0x100207d0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           3591000    0x80004244 bltu a4, a3, -20               #; a4  = 0x100207d0, a3  = 0x100207e0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           3629000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x100207d0, 0 ~~> Word[0x100207d0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           3669000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x100207d0, 0 ~~> Word[0x100207d4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           3709000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x100207d0, 0 ~~> Word[0x100207d8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           3749000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x100207d0, 0 ~~> Word[0x100207dc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           3750000    0x80004240 addi a4, a4, 16                #; a4  = 0x100207d0, (wrb) a4  <-- 0x100207e0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           3751000    0x80004244 bltu a4, a3, -20               #; a4  = 0x100207e0, a3  = 0x100207e0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           3752000    0x80004248 bnez a2, 8                     #; a2  = 4, taken, goto 0x80004250
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
           3753000    0x80004250 sub a3, t1, a2                 #; t1  = 15, a2  = 4, (wrb) a3  <-- 11
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
           3754000    0x80004254 slli a3, a3, 2                 #; a3  = 11, (wrb) a3  <-- 44
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
           3755000    0x80004258 auipc t0, 0                    #; (wrb) t0  <-- 0x80004258
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
           3756000    0x8000425c add a3, a3, t0                 #; a3  = 44, t0  = 0x80004258, (wrb) a3  <-- 0x80004284
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
           3757000    0x80004260 jr 12(a3)                      #; a3  = 0x80004284, goto 0x80004290
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           3789000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x100207e0, 0 ~~> Byte[0x100207e3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           3829000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x100207e0, 0 ~~> Byte[0x100207e2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           3869000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x100207e0, 0 ~~> Byte[0x100207e1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           3909000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x100207e0, 0 ~~> Byte[0x100207e0]
#; .Ltable (memset.S:85)
#;   ret
           3910000    0x800042a0 ret                            #; ra  = 0x80003f48, goto 0x80003f48
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
           3949000    0x80003f48 lw a0, 8(sp)                   #; sp  = 0x1001ff48, a0  <~~ Word[0x1001ff50]
           3999000                                              #; (lsu) a0  <-- 0x1001ff94
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
           4000000    0x80003f4c add a0, a0, s6                 #; a0  = 0x1001ff94, s6  = 3096, (wrb) a0  <-- 0x10020bac
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
           4001000    0x80003f50 li a1, 0                       #; (wrb) a1  <-- 0
           4002000    0x80003f54 mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
           4003000    0x80003f58 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f58
           4004000    0x80003f5c jalr 692(ra)                   #; ra  = 0x80003f58, (wrb) ra  <-- 0x80003f60, goto 0x8000420c
#; memset (memset.S:30)
#;   li t1, 15
           4005000    0x8000420c li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
           4006000    0x80004210 mv a4, a0                      #; a0  = 0x10020bac, (wrb) a4  <-- 0x10020bac
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
           4007000    0x80004214 bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
           4008000    0x80004218 andi a5, a4, 15                #; a4  = 0x10020bac, (wrb) a5  <-- 12
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
           4009000    0x8000421c bnez a5, 160                   #; a5  = 12, taken, goto 0x800042bc
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
           4010000    0x800042bc slli a3, a5, 2                 #; a5  = 12, (wrb) a3  <-- 48
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
           4011000    0x800042c0 auipc t0, 0                    #; (wrb) t0  <-- 0x800042c0
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
           4012000    0x800042c4 add a3, a3, t0                 #; a3  = 48, t0  = 0x800042c0, (wrb) a3  <-- 0x800042f0
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
           4013000    0x800042c8 mv t0, ra                      #; ra  = 0x80003f60, (wrb) t0  <-- 0x80003f60
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
           4014000    0x800042cc jalr -96(a3)                   #; a3  = 0x800042f0, (wrb) ra  <-- 0x800042d0, goto 0x80004290
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           4015000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x10020bac, 0 ~~> Byte[0x10020baf]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           4016000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x10020bac, 0 ~~> Byte[0x10020bae]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           4029000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x10020bac, 0 ~~> Byte[0x10020bad]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           4069000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x10020bac, 0 ~~> Byte[0x10020bac]
#; .Ltable (memset.S:85)
#;   ret
           4070000    0x800042a0 ret                            #; ra  = 0x800042d0, goto 0x800042d0
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           4071000    0x800042d0 mv ra, t0                      #; t0  = 0x80003f60, (wrb) ra  <-- 0x80003f60
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           4072000    0x800042d4 addi a5, a5, -16               #; a5  = 12, (wrb) a5  <-- -4
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           4073000    0x800042d8 sub a4, a4, a5                 #; a4  = 0x10020bac, a5  = -4, (wrb) a4  <-- 0x10020bb0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           4074000    0x800042dc add a2, a2, a5                 #; a2  = 64, a5  = -4, (wrb) a2  <-- 60
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           4075000    0x800042e0 bgeu t1, a2, -144              #; t1  = 15, a2  = 60, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           4076000    0x800042e4 j -196                         #; goto 0x80004220
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           4077000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           4078000    0x80004224 andi a3, a2, -16               #; a2  = 60, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           4079000    0x80004228 andi a2, a2, 15                #; a2  = 60, (wrb) a2  <-- 12
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           4080000    0x8000422c add a3, a3, a4                 #; a3  = 48, a4  = 0x10020bb0, (wrb) a3  <-- 0x10020be0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           4109000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x10020bb0, 0 ~~> Word[0x10020bb0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           4140000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x10020bb0, 0 ~~> Word[0x10020bb4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           4179000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x10020bb0, 0 ~~> Word[0x10020bb8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           4210000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x10020bb0, 0 ~~> Word[0x10020bbc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           4211000    0x80004240 addi a4, a4, 16                #; a4  = 0x10020bb0, (wrb) a4  <-- 0x10020bc0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           4212000    0x80004244 bltu a4, a3, -20               #; a4  = 0x10020bc0, a3  = 0x10020be0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           4249000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x10020bc0, 0 ~~> Word[0x10020bc0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           4280000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x10020bc0, 0 ~~> Word[0x10020bc4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           4319000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x10020bc0, 0 ~~> Word[0x10020bc8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           4350000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x10020bc0, 0 ~~> Word[0x10020bcc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           4351000    0x80004240 addi a4, a4, 16                #; a4  = 0x10020bc0, (wrb) a4  <-- 0x10020bd0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           4352000    0x80004244 bltu a4, a3, -20               #; a4  = 0x10020bd0, a3  = 0x10020be0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           4389000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x10020bd0, 0 ~~> Word[0x10020bd0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           4420000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x10020bd0, 0 ~~> Word[0x10020bd4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           4459000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x10020bd0, 0 ~~> Word[0x10020bd8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           4490000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x10020bd0, 0 ~~> Word[0x10020bdc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           4491000    0x80004240 addi a4, a4, 16                #; a4  = 0x10020bd0, (wrb) a4  <-- 0x10020be0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           4492000    0x80004244 bltu a4, a3, -20               #; a4  = 0x10020be0, a3  = 0x10020be0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           4493000    0x80004248 bnez a2, 8                     #; a2  = 12, taken, goto 0x80004250
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
           4494000    0x80004250 sub a3, t1, a2                 #; t1  = 15, a2  = 12, (wrb) a3  <-- 3
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
           4495000    0x80004254 slli a3, a3, 2                 #; a3  = 3, (wrb) a3  <-- 12
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
           4496000    0x80004258 auipc t0, 0                    #; (wrb) t0  <-- 0x80004258
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
           4497000    0x8000425c add a3, a3, t0                 #; a3  = 12, t0  = 0x80004258, (wrb) a3  <-- 0x80004264
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
           4498000    0x80004260 jr 12(a3)                      #; a3  = 0x80004264, goto 0x80004270
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
           4529000    0x80004270 sb a1, 11(a4)                  #; a4  = 0x10020be0, 0 ~~> Byte[0x10020beb]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
           4560000    0x80004274 sb a1, 10(a4)                  #; a4  = 0x10020be0, 0 ~~> Byte[0x10020bea]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
           4599000    0x80004278 sb a1, 9(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be9]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
           4630000    0x8000427c sb a1, 8(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be8]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
           4669000    0x80004280 sb a1, 7(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be7]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
           4700000    0x80004284 sb a1, 6(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be6]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
           4739000    0x80004288 sb a1, 5(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be5]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
           4770000    0x8000428c sb a1, 4(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be4]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           4809000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           4840000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           4879000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           4910000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be0]
#; .Ltable (memset.S:85)
#;   ret
           4911000    0x800042a0 ret                            #; ra  = 0x80003f60, goto 0x80003f60
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
           4949000    0x80003f60 lw a0, 8(sp)                   #; sp  = 0x1001ff48, a0  <~~ Word[0x1001ff50]
           4990000                                              #; (lsu) a0  <-- 0x1001ff94
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
           4991000    0x80003f64 add a0, a0, s7                 #; a0  = 0x1001ff94, s7  = 4128, (wrb) a0  <-- 0x10020fb4
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
           4992000    0x80003f68 li a1, 0                       #; (wrb) a1  <-- 0
           4993000    0x80003f6c mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
           4994000    0x80003f70 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f70
           4995000    0x80003f74 jalr 668(ra)                   #; ra  = 0x80003f70, (wrb) ra  <-- 0x80003f78, goto 0x8000420c
#; memset (memset.S:30)
#;   li t1, 15
           4996000    0x8000420c li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
           4997000    0x80004210 mv a4, a0                      #; a0  = 0x10020fb4, (wrb) a4  <-- 0x10020fb4
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
           4998000    0x80004214 bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
           4999000    0x80004218 andi a5, a4, 15                #; a4  = 0x10020fb4, (wrb) a5  <-- 4
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
           5000000    0x8000421c bnez a5, 160                   #; a5  = 4, taken, goto 0x800042bc
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
           5001000    0x800042bc slli a3, a5, 2                 #; a5  = 4, (wrb) a3  <-- 16
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
           5002000    0x800042c0 auipc t0, 0                    #; (wrb) t0  <-- 0x800042c0
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
           5003000    0x800042c4 add a3, a3, t0                 #; a3  = 16, t0  = 0x800042c0, (wrb) a3  <-- 0x800042d0
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
           5004000    0x800042c8 mv t0, ra                      #; ra  = 0x80003f78, (wrb) t0  <-- 0x80003f78
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
           5005000    0x800042cc jalr -96(a3)                   #; a3  = 0x800042d0, (wrb) ra  <-- 0x800042d0, goto 0x80004270
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
           5006000    0x80004270 sb a1, 11(a4)                  #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fbf]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
           5007000    0x80004274 sb a1, 10(a4)                  #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fbe]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
           5019000    0x80004278 sb a1, 9(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fbd]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
           5050000    0x8000427c sb a1, 8(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fbc]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
           5089000    0x80004280 sb a1, 7(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fbb]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
           5119000    0x80004284 sb a1, 6(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fba]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
           5149000    0x80004288 sb a1, 5(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fb9]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
           5179000    0x8000428c sb a1, 4(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fb8]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           5209000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fb7]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           5239000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fb6]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           5269000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fb5]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           5299000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fb4]
#; .Ltable (memset.S:85)
#;   ret
           5300000    0x800042a0 ret                            #; ra  = 0x800042d0, goto 0x800042d0
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           5301000    0x800042d0 mv ra, t0                      #; t0  = 0x80003f78, (wrb) ra  <-- 0x80003f78
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           5302000    0x800042d4 addi a5, a5, -16               #; a5  = 4, (wrb) a5  <-- -12
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           5303000    0x800042d8 sub a4, a4, a5                 #; a4  = 0x10020fb4, a5  = -12, (wrb) a4  <-- 0x10020fc0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           5304000    0x800042dc add a2, a2, a5                 #; a2  = 64, a5  = -12, (wrb) a2  <-- 52
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           5305000    0x800042e0 bgeu t1, a2, -144              #; t1  = 15, a2  = 52, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           5306000    0x800042e4 j -196                         #; goto 0x80004220
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           5307000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           5308000    0x80004224 andi a3, a2, -16               #; a2  = 52, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           5309000    0x80004228 andi a2, a2, 15                #; a2  = 52, (wrb) a2  <-- 4
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           5310000    0x8000422c add a3, a3, a4                 #; a3  = 48, a4  = 0x10020fc0, (wrb) a3  <-- 0x10020ff0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           5329000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x10020fc0, 0 ~~> Word[0x10020fc0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           5359000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x10020fc0, 0 ~~> Word[0x10020fc4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           5389000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x10020fc0, 0 ~~> Word[0x10020fc8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           5419000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x10020fc0, 0 ~~> Word[0x10020fcc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           5420000    0x80004240 addi a4, a4, 16                #; a4  = 0x10020fc0, (wrb) a4  <-- 0x10020fd0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           5421000    0x80004244 bltu a4, a3, -20               #; a4  = 0x10020fd0, a3  = 0x10020ff0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           5449000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x10020fd0, 0 ~~> Word[0x10020fd0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           5479000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x10020fd0, 0 ~~> Word[0x10020fd4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           5509000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x10020fd0, 0 ~~> Word[0x10020fd8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           5530000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x10020fd0, 0 ~~> Word[0x10020fdc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           5531000    0x80004240 addi a4, a4, 16                #; a4  = 0x10020fd0, (wrb) a4  <-- 0x10020fe0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           5532000    0x80004244 bltu a4, a3, -20               #; a4  = 0x10020fe0, a3  = 0x10020ff0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           5560000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x10020fe0, 0 ~~> Word[0x10020fe0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           5590000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x10020fe0, 0 ~~> Word[0x10020fe4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           5620000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x10020fe0, 0 ~~> Word[0x10020fe8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           5650000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x10020fe0, 0 ~~> Word[0x10020fec]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           5651000    0x80004240 addi a4, a4, 16                #; a4  = 0x10020fe0, (wrb) a4  <-- 0x10020ff0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           5652000    0x80004244 bltu a4, a3, -20               #; a4  = 0x10020ff0, a3  = 0x10020ff0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           5653000    0x80004248 bnez a2, 8                     #; a2  = 4, taken, goto 0x80004250
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
           5654000    0x80004250 sub a3, t1, a2                 #; t1  = 15, a2  = 4, (wrb) a3  <-- 11
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
           5655000    0x80004254 slli a3, a3, 2                 #; a3  = 11, (wrb) a3  <-- 44
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
           5656000    0x80004258 auipc t0, 0                    #; (wrb) t0  <-- 0x80004258
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
           5657000    0x8000425c add a3, a3, t0                 #; a3  = 44, t0  = 0x80004258, (wrb) a3  <-- 0x80004284
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
           5658000    0x80004260 jr 12(a3)                      #; a3  = 0x80004284, goto 0x80004290
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           5680000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x10020ff0, 0 ~~> Byte[0x10020ff3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           5710000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x10020ff0, 0 ~~> Byte[0x10020ff2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           5740000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x10020ff0, 0 ~~> Byte[0x10020ff1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           5769000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x10020ff0, 0 ~~> Byte[0x10020ff0]
#; .Ltable (memset.S:85)
#;   ret
           5770000    0x800042a0 ret                            #; ra  = 0x80003f78, goto 0x80003f78
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
           5799000    0x80003f78 lw a0, 8(sp)                   #; sp  = 0x1001ff48, a0  <~~ Word[0x1001ff50]
           5839000                                              #; (lsu) a0  <-- 0x1001ff94
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
           5840000    0x80003f7c add a0, a0, s8                 #; a0  = 0x1001ff94, s8  = 5160, (wrb) a0  <-- 0x100213bc
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
           5843000    0x80003f80 li a1, 0                       #; (wrb) a1  <-- 0
           5844000    0x80003f84 mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
           5845000    0x80003f88 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f88
           5846000    0x80003f8c jalr 644(ra)                   #; ra  = 0x80003f88, (wrb) ra  <-- 0x80003f90, goto 0x8000420c
#; memset (memset.S:30)
#;   li t1, 15
           5847000    0x8000420c li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
           5848000    0x80004210 mv a4, a0                      #; a0  = 0x100213bc, (wrb) a4  <-- 0x100213bc
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
           5849000    0x80004214 bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
           5850000    0x80004218 andi a5, a4, 15                #; a4  = 0x100213bc, (wrb) a5  <-- 12
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
           5851000    0x8000421c bnez a5, 160                   #; a5  = 12, taken, goto 0x800042bc
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
           5852000    0x800042bc slli a3, a5, 2                 #; a5  = 12, (wrb) a3  <-- 48
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
           5853000    0x800042c0 auipc t0, 0                    #; (wrb) t0  <-- 0x800042c0
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
           5854000    0x800042c4 add a3, a3, t0                 #; a3  = 48, t0  = 0x800042c0, (wrb) a3  <-- 0x800042f0
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
           5855000    0x800042c8 mv t0, ra                      #; ra  = 0x80003f90, (wrb) t0  <-- 0x80003f90
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
           5856000    0x800042cc jalr -96(a3)                   #; a3  = 0x800042f0, (wrb) ra  <-- 0x800042d0, goto 0x80004290
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           5857000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x100213bc, 0 ~~> Byte[0x100213bf]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           5858000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x100213bc, 0 ~~> Byte[0x100213be]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           5870000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x100213bc, 0 ~~> Byte[0x100213bd]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           5902000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x100213bc, 0 ~~> Byte[0x100213bc]
#; .Ltable (memset.S:85)
#;   ret
           5903000    0x800042a0 ret                            #; ra  = 0x800042d0, goto 0x800042d0
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           5904000    0x800042d0 mv ra, t0                      #; t0  = 0x80003f90, (wrb) ra  <-- 0x80003f90
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           5905000    0x800042d4 addi a5, a5, -16               #; a5  = 12, (wrb) a5  <-- -4
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           5906000    0x800042d8 sub a4, a4, a5                 #; a4  = 0x100213bc, a5  = -4, (wrb) a4  <-- 0x100213c0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           5907000    0x800042dc add a2, a2, a5                 #; a2  = 64, a5  = -4, (wrb) a2  <-- 60
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           5908000    0x800042e0 bgeu t1, a2, -144              #; t1  = 15, a2  = 60, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           5909000    0x800042e4 j -196                         #; goto 0x80004220
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           5910000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           5911000    0x80004224 andi a3, a2, -16               #; a2  = 60, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           5912000    0x80004228 andi a2, a2, 15                #; a2  = 60, (wrb) a2  <-- 12
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           5913000    0x8000422c add a3, a3, a4                 #; a3  = 48, a4  = 0x100213c0, (wrb) a3  <-- 0x100213f0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           5927000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x100213c0, 0 ~~> Word[0x100213c0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           5952000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x100213c0, 0 ~~> Word[0x100213c4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           5977000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x100213c0, 0 ~~> Word[0x100213c8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6002000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x100213c0, 0 ~~> Word[0x100213cc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6003000    0x80004240 addi a4, a4, 16                #; a4  = 0x100213c0, (wrb) a4  <-- 0x100213d0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6004000    0x80004244 bltu a4, a3, -20               #; a4  = 0x100213d0, a3  = 0x100213f0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6027000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x100213d0, 0 ~~> Word[0x100213d0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           6052000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x100213d0, 0 ~~> Word[0x100213d4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           6077000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x100213d0, 0 ~~> Word[0x100213d8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6102000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x100213d0, 0 ~~> Word[0x100213dc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6103000    0x80004240 addi a4, a4, 16                #; a4  = 0x100213d0, (wrb) a4  <-- 0x100213e0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6104000    0x80004244 bltu a4, a3, -20               #; a4  = 0x100213e0, a3  = 0x100213f0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6127000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x100213e0, 0 ~~> Word[0x100213e0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           6152000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x100213e0, 0 ~~> Word[0x100213e4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           6177000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x100213e0, 0 ~~> Word[0x100213e8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6202000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x100213e0, 0 ~~> Word[0x100213ec]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6203000    0x80004240 addi a4, a4, 16                #; a4  = 0x100213e0, (wrb) a4  <-- 0x100213f0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6204000    0x80004244 bltu a4, a3, -20               #; a4  = 0x100213f0, a3  = 0x100213f0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           6205000    0x80004248 bnez a2, 8                     #; a2  = 12, taken, goto 0x80004250
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
           6206000    0x80004250 sub a3, t1, a2                 #; t1  = 15, a2  = 12, (wrb) a3  <-- 3
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
           6207000    0x80004254 slli a3, a3, 2                 #; a3  = 3, (wrb) a3  <-- 12
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
           6208000    0x80004258 auipc t0, 0                    #; (wrb) t0  <-- 0x80004258
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
           6209000    0x8000425c add a3, a3, t0                 #; a3  = 12, t0  = 0x80004258, (wrb) a3  <-- 0x80004264
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
           6210000    0x80004260 jr 12(a3)                      #; a3  = 0x80004264, goto 0x80004270
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
           6227000    0x80004270 sb a1, 11(a4)                  #; a4  = 0x100213f0, 0 ~~> Byte[0x100213fb]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
           6252000    0x80004274 sb a1, 10(a4)                  #; a4  = 0x100213f0, 0 ~~> Byte[0x100213fa]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
           6277000    0x80004278 sb a1, 9(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f9]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
           6294000    0x8000427c sb a1, 8(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f8]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
           6319000    0x80004280 sb a1, 7(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f7]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
           6344000    0x80004284 sb a1, 6(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f6]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
           6369000    0x80004288 sb a1, 5(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f5]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
           6392000    0x8000428c sb a1, 4(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f4]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           6414000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           6436000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           6458000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           6472000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f0]
#; .Ltable (memset.S:85)
#;   ret
           6473000    0x800042a0 ret                            #; ra  = 0x80003f90, goto 0x80003f90
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
           6494000    0x80003f90 lw a0, 8(sp)                   #; sp  = 0x1001ff48, a0  <~~ Word[0x1001ff50]
           6529000                                              #; (lsu) a0  <-- 0x1001ff94
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
           6530000    0x80003f94 add a0, a0, s9                 #; a0  = 0x1001ff94, s9  = 6192, (wrb) a0  <-- 0x100217c4
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
           6531000    0x80003f98 li a1, 0                       #; (wrb) a1  <-- 0
           6532000    0x80003f9c mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
           6533000    0x80003fa0 auipc ra, 0                    #; (wrb) ra  <-- 0x80003fa0
           6534000    0x80003fa4 jalr 620(ra)                   #; ra  = 0x80003fa0, (wrb) ra  <-- 0x80003fa8, goto 0x8000420c
#; memset (memset.S:30)
#;   li t1, 15
           6535000    0x8000420c li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
           6536000    0x80004210 mv a4, a0                      #; a0  = 0x100217c4, (wrb) a4  <-- 0x100217c4
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
           6537000    0x80004214 bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
           6538000    0x80004218 andi a5, a4, 15                #; a4  = 0x100217c4, (wrb) a5  <-- 4
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
           6539000    0x8000421c bnez a5, 160                   #; a5  = 4, taken, goto 0x800042bc
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
           6540000    0x800042bc slli a3, a5, 2                 #; a5  = 4, (wrb) a3  <-- 16
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
           6541000    0x800042c0 auipc t0, 0                    #; (wrb) t0  <-- 0x800042c0
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
           6542000    0x800042c4 add a3, a3, t0                 #; a3  = 16, t0  = 0x800042c0, (wrb) a3  <-- 0x800042d0
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
           6543000    0x800042c8 mv t0, ra                      #; ra  = 0x80003fa8, (wrb) t0  <-- 0x80003fa8
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
           6544000    0x800042cc jalr -96(a3)                   #; a3  = 0x800042d0, (wrb) ra  <-- 0x800042d0, goto 0x80004270
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
           6545000    0x80004270 sb a1, 11(a4)                  #; a4  = 0x100217c4, 0 ~~> Byte[0x100217cf]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
           6546000    0x80004274 sb a1, 10(a4)                  #; a4  = 0x100217c4, 0 ~~> Byte[0x100217ce]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
           6557000    0x80004278 sb a1, 9(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217cd]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
           6571000    0x8000427c sb a1, 8(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217cc]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
           6585000    0x80004280 sb a1, 7(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217cb]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
           6599000    0x80004284 sb a1, 6(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217ca]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
           6613000    0x80004288 sb a1, 5(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217c9]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
           6627000    0x8000428c sb a1, 4(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217c8]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           6641000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217c7]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           6655000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217c6]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           6669000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217c5]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           6683000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217c4]
#; .Ltable (memset.S:85)
#;   ret
           6684000    0x800042a0 ret                            #; ra  = 0x800042d0, goto 0x800042d0
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           6685000    0x800042d0 mv ra, t0                      #; t0  = 0x80003fa8, (wrb) ra  <-- 0x80003fa8
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           6686000    0x800042d4 addi a5, a5, -16               #; a5  = 4, (wrb) a5  <-- -12
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           6687000    0x800042d8 sub a4, a4, a5                 #; a4  = 0x100217c4, a5  = -12, (wrb) a4  <-- 0x100217d0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           6688000    0x800042dc add a2, a2, a5                 #; a2  = 64, a5  = -12, (wrb) a2  <-- 52
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           6689000    0x800042e0 bgeu t1, a2, -144              #; t1  = 15, a2  = 52, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           6690000    0x800042e4 j -196                         #; goto 0x80004220
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           6691000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           6692000    0x80004224 andi a3, a2, -16               #; a2  = 52, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           6693000    0x80004228 andi a2, a2, 15                #; a2  = 52, (wrb) a2  <-- 4
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           6694000    0x8000422c add a3, a3, a4                 #; a3  = 48, a4  = 0x100217d0, (wrb) a3  <-- 0x10021800
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6697000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x100217d0, 0 ~~> Word[0x100217d0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           6711000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x100217d0, 0 ~~> Word[0x100217d4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           6725000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x100217d0, 0 ~~> Word[0x100217d8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6739000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x100217d0, 0 ~~> Word[0x100217dc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6740000    0x80004240 addi a4, a4, 16                #; a4  = 0x100217d0, (wrb) a4  <-- 0x100217e0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6741000    0x80004244 bltu a4, a3, -20               #; a4  = 0x100217e0, a3  = 0x10021800, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6753000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x100217e0, 0 ~~> Word[0x100217e0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           6767000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x100217e0, 0 ~~> Word[0x100217e4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           6776000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x100217e0, 0 ~~> Word[0x100217e8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6788000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x100217e0, 0 ~~> Word[0x100217ec]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6789000    0x80004240 addi a4, a4, 16                #; a4  = 0x100217e0, (wrb) a4  <-- 0x100217f0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6790000    0x80004244 bltu a4, a3, -20               #; a4  = 0x100217f0, a3  = 0x10021800, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6802000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x100217f0, 0 ~~> Word[0x100217f0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           6816000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x100217f0, 0 ~~> Word[0x100217f4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           6825000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x100217f0, 0 ~~> Word[0x100217f8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6837000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x100217f0, 0 ~~> Word[0x100217fc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6838000    0x80004240 addi a4, a4, 16                #; a4  = 0x100217f0, (wrb) a4  <-- 0x10021800
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6839000    0x80004244 bltu a4, a3, -20               #; a4  = 0x10021800, a3  = 0x10021800, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           6840000    0x80004248 bnez a2, 8                     #; a2  = 4, taken, goto 0x80004250
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
           6841000    0x80004250 sub a3, t1, a2                 #; t1  = 15, a2  = 4, (wrb) a3  <-- 11
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
           6842000    0x80004254 slli a3, a3, 2                 #; a3  = 11, (wrb) a3  <-- 44
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
           6843000    0x80004258 auipc t0, 0                    #; (wrb) t0  <-- 0x80004258
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
           6844000    0x8000425c add a3, a3, t0                 #; a3  = 44, t0  = 0x80004258, (wrb) a3  <-- 0x80004284
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
           6845000    0x80004260 jr 12(a3)                      #; a3  = 0x80004284, goto 0x80004290
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           6851000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x10021800, 0 ~~> Byte[0x10021803]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           6865000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x10021800, 0 ~~> Byte[0x10021802]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           6874000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x10021800, 0 ~~> Byte[0x10021801]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           6886000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x10021800, 0 ~~> Byte[0x10021800]
#; .Ltable (memset.S:85)
#;   ret
           6887000    0x800042a0 ret                            #; ra  = 0x80003fa8, goto 0x80003fa8
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
           6895000    0x80003fa8 lw a0, 8(sp)                   #; sp  = 0x1001ff48, a0  <~~ Word[0x1001ff50]
           6914000                                              #; (lsu) a0  <-- 0x1001ff94
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
           6915000    0x80003fac add a0, a0, s10                #; a0  = 0x1001ff94, s10 = 7224, (wrb) a0  <-- 0x10021bcc
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
           6916000    0x80003fb0 li a1, 0                       #; (wrb) a1  <-- 0
           6917000    0x80003fb4 mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
           6918000    0x80003fb8 auipc ra, 0                    #; (wrb) ra  <-- 0x80003fb8
           6919000    0x80003fbc jalr 596(ra)                   #; ra  = 0x80003fb8, (wrb) ra  <-- 0x80003fc0, goto 0x8000420c
#; memset (memset.S:30)
#;   li t1, 15
           6920000    0x8000420c li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
           6921000    0x80004210 mv a4, a0                      #; a0  = 0x10021bcc, (wrb) a4  <-- 0x10021bcc
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
           6922000    0x80004214 bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
           6923000    0x80004218 andi a5, a4, 15                #; a4  = 0x10021bcc, (wrb) a5  <-- 12
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
           6924000    0x8000421c bnez a5, 160                   #; a5  = 12, taken, goto 0x800042bc
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
           6925000    0x800042bc slli a3, a5, 2                 #; a5  = 12, (wrb) a3  <-- 48
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
           6926000    0x800042c0 auipc t0, 0                    #; (wrb) t0  <-- 0x800042c0
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
           6927000    0x800042c4 add a3, a3, t0                 #; a3  = 48, t0  = 0x800042c0, (wrb) a3  <-- 0x800042f0
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
           6928000    0x800042c8 mv t0, ra                      #; ra  = 0x80003fc0, (wrb) t0  <-- 0x80003fc0
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
           6929000    0x800042cc jalr -96(a3)                   #; a3  = 0x800042f0, (wrb) ra  <-- 0x800042d0, goto 0x80004290
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           6930000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x10021bcc, 0 ~~> Byte[0x10021bcf]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           6931000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x10021bcc, 0 ~~> Byte[0x10021bce]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           6937000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x10021bcc, 0 ~~> Byte[0x10021bcd]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           6949000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x10021bcc, 0 ~~> Byte[0x10021bcc]
#; .Ltable (memset.S:85)
#;   ret
           6950000    0x800042a0 ret                            #; ra  = 0x800042d0, goto 0x800042d0
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           6951000    0x800042d0 mv ra, t0                      #; t0  = 0x80003fc0, (wrb) ra  <-- 0x80003fc0
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           6952000    0x800042d4 addi a5, a5, -16               #; a5  = 12, (wrb) a5  <-- -4
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           6953000    0x800042d8 sub a4, a4, a5                 #; a4  = 0x10021bcc, a5  = -4, (wrb) a4  <-- 0x10021bd0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           6954000    0x800042dc add a2, a2, a5                 #; a2  = 64, a5  = -4, (wrb) a2  <-- 60
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           6955000    0x800042e0 bgeu t1, a2, -144              #; t1  = 15, a2  = 60, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           6956000    0x800042e4 j -196                         #; goto 0x80004220
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           6957000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           6958000    0x80004224 andi a3, a2, -16               #; a2  = 60, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           6959000    0x80004228 andi a2, a2, 15                #; a2  = 60, (wrb) a2  <-- 12
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           6960000    0x8000422c add a3, a3, a4                 #; a3  = 48, a4  = 0x10021bd0, (wrb) a3  <-- 0x10021c00
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6961000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x10021bd0, 0 ~~> Word[0x10021bd0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           6970000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x10021bd0, 0 ~~> Word[0x10021bd4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           6979000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x10021bd0, 0 ~~> Word[0x10021bd8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6991000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x10021bd0, 0 ~~> Word[0x10021bdc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6992000    0x80004240 addi a4, a4, 16                #; a4  = 0x10021bd0, (wrb) a4  <-- 0x10021be0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6993000    0x80004244 bltu a4, a3, -20               #; a4  = 0x10021be0, a3  = 0x10021c00, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           7000000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x10021be0, 0 ~~> Word[0x10021be0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           7012000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x10021be0, 0 ~~> Word[0x10021be4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           7021000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x10021be0, 0 ~~> Word[0x10021be8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           7033000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x10021be0, 0 ~~> Word[0x10021bec]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           7034000    0x80004240 addi a4, a4, 16                #; a4  = 0x10021be0, (wrb) a4  <-- 0x10021bf0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           7035000    0x80004244 bltu a4, a3, -20               #; a4  = 0x10021bf0, a3  = 0x10021c00, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           7042000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x10021bf0, 0 ~~> Word[0x10021bf0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           7054000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x10021bf0, 0 ~~> Word[0x10021bf4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           7063000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x10021bf0, 0 ~~> Word[0x10021bf8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           7075000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x10021bf0, 0 ~~> Word[0x10021bfc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           7076000    0x80004240 addi a4, a4, 16                #; a4  = 0x10021bf0, (wrb) a4  <-- 0x10021c00
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           7077000    0x80004244 bltu a4, a3, -20               #; a4  = 0x10021c00, a3  = 0x10021c00, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           7078000    0x80004248 bnez a2, 8                     #; a2  = 12, taken, goto 0x80004250
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
           7079000    0x80004250 sub a3, t1, a2                 #; t1  = 15, a2  = 12, (wrb) a3  <-- 3
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
           7080000    0x80004254 slli a3, a3, 2                 #; a3  = 3, (wrb) a3  <-- 12
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
           7081000    0x80004258 auipc t0, 0                    #; (wrb) t0  <-- 0x80004258
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
           7082000    0x8000425c add a3, a3, t0                 #; a3  = 12, t0  = 0x80004258, (wrb) a3  <-- 0x80004264
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
           7083000    0x80004260 jr 12(a3)                      #; a3  = 0x80004264, goto 0x80004270
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
           7084000    0x80004270 sb a1, 11(a4)                  #; a4  = 0x10021c00, 0 ~~> Byte[0x10021c0b]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
           7091000    0x80004274 sb a1, 10(a4)                  #; a4  = 0x10021c00, 0 ~~> Byte[0x10021c0a]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
           7098000    0x80004278 sb a1, 9(a4)                   #; a4  = 0x10021c00, 0 ~~> Byte[0x10021c09]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
           7105000    0x8000427c sb a1, 8(a4)                   #; a4  = 0x10021c00, 0 ~~> Byte[0x10021c08]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
           7117000    0x80004280 sb a1, 7(a4)                   #; a4  = 0x10021c00, 0 ~~> Byte[0x10021c07]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
           7124000    0x80004284 sb a1, 6(a4)                   #; a4  = 0x10021c00, 0 ~~> Byte[0x10021c06]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
           7131000    0x80004288 sb a1, 5(a4)                   #; a4  = 0x10021c00, 0 ~~> Byte[0x10021c05]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
           7138000    0x8000428c sb a1, 4(a4)                   #; a4  = 0x10021c00, 0 ~~> Byte[0x10021c04]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           7145000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x10021c00, 0 ~~> Byte[0x10021c03]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           7152000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x10021c00, 0 ~~> Byte[0x10021c02]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           7159000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x10021c00, 0 ~~> Byte[0x10021c01]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           7166000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x10021c00, 0 ~~> Byte[0x10021c00]
#; .Ltable (memset.S:85)
#;   ret
           7167000    0x800042a0 ret                            #; ra  = 0x80003fc0, goto 0x80003fc0
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
           7173000    0x80003fc0 lw a0, 8(sp)                   #; sp  = 0x1001ff48, a0  <~~ Word[0x1001ff50]
           7187000                                              #; (lsu) a0  <-- 0x1001ff94
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
           7188000    0x80003fc4 add a0, a0, s11                #; a0  = 0x1001ff94, s11 = 8256, (wrb) a0  <-- 0x10021fd4
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
           7189000    0x80003fc8 li a1, 0                       #; (wrb) a1  <-- 0
           7190000    0x80003fcc mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
           7191000    0x80003fd0 auipc ra, 0                    #; (wrb) ra  <-- 0x80003fd0
           7192000    0x80003fd4 jalr 572(ra)                   #; ra  = 0x80003fd0, (wrb) ra  <-- 0x80003fd8, goto 0x8000420c
#; memset (memset.S:30)
#;   li t1, 15
           7193000    0x8000420c li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
           7194000    0x80004210 mv a4, a0                      #; a0  = 0x10021fd4, (wrb) a4  <-- 0x10021fd4
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
           7195000    0x80004214 bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
           7196000    0x80004218 andi a5, a4, 15                #; a4  = 0x10021fd4, (wrb) a5  <-- 4
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
           7197000    0x8000421c bnez a5, 160                   #; a5  = 4, taken, goto 0x800042bc
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
           7198000    0x800042bc slli a3, a5, 2                 #; a5  = 4, (wrb) a3  <-- 16
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
           7199000    0x800042c0 auipc t0, 0                    #; (wrb) t0  <-- 0x800042c0
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
           7200000    0x800042c4 add a3, a3, t0                 #; a3  = 16, t0  = 0x800042c0, (wrb) a3  <-- 0x800042d0
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
           7201000    0x800042c8 mv t0, ra                      #; ra  = 0x80003fd8, (wrb) t0  <-- 0x80003fd8
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
           7202000    0x800042cc jalr -96(a3)                   #; a3  = 0x800042d0, (wrb) ra  <-- 0x800042d0, goto 0x80004270
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
           7203000    0x80004270 sb a1, 11(a4)                  #; a4  = 0x10021fd4, 0 ~~> Byte[0x10021fdf]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
           7204000    0x80004274 sb a1, 10(a4)                  #; a4  = 0x10021fd4, 0 ~~> Byte[0x10021fde]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
           7208000    0x80004278 sb a1, 9(a4)                   #; a4  = 0x10021fd4, 0 ~~> Byte[0x10021fdd]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
           7215000    0x8000427c sb a1, 8(a4)                   #; a4  = 0x10021fd4, 0 ~~> Byte[0x10021fdc]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
           7222000    0x80004280 sb a1, 7(a4)                   #; a4  = 0x10021fd4, 0 ~~> Byte[0x10021fdb]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
           7229000    0x80004284 sb a1, 6(a4)                   #; a4  = 0x10021fd4, 0 ~~> Byte[0x10021fda]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
           7236000    0x80004288 sb a1, 5(a4)                   #; a4  = 0x10021fd4, 0 ~~> Byte[0x10021fd9]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
           7243000    0x8000428c sb a1, 4(a4)                   #; a4  = 0x10021fd4, 0 ~~> Byte[0x10021fd8]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           7250000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x10021fd4, 0 ~~> Byte[0x10021fd7]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           7257000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x10021fd4, 0 ~~> Byte[0x10021fd6]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           7264000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x10021fd4, 0 ~~> Byte[0x10021fd5]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           7271000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x10021fd4, 0 ~~> Byte[0x10021fd4]
#; .Ltable (memset.S:85)
#;   ret
           7272000    0x800042a0 ret                            #; ra  = 0x800042d0, goto 0x800042d0
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           7273000    0x800042d0 mv ra, t0                      #; t0  = 0x80003fd8, (wrb) ra  <-- 0x80003fd8
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           7274000    0x800042d4 addi a5, a5, -16               #; a5  = 4, (wrb) a5  <-- -12
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           7275000    0x800042d8 sub a4, a4, a5                 #; a4  = 0x10021fd4, a5  = -12, (wrb) a4  <-- 0x10021fe0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           7276000    0x800042dc add a2, a2, a5                 #; a2  = 64, a5  = -12, (wrb) a2  <-- 52
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           7277000    0x800042e0 bgeu t1, a2, -144              #; t1  = 15, a2  = 52, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           7278000    0x800042e4 j -196                         #; goto 0x80004220
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           7279000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           7280000    0x80004224 andi a3, a2, -16               #; a2  = 52, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           7281000    0x80004228 andi a2, a2, 15                #; a2  = 52, (wrb) a2  <-- 4
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           7282000    0x8000422c add a3, a3, a4                 #; a3  = 48, a4  = 0x10021fe0, (wrb) a3  <-- 0x10022010
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           7283000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x10021fe0, 0 ~~> Word[0x10021fe0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           7285000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x10021fe0, 0 ~~> Word[0x10021fe4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           7289000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x10021fe0, 0 ~~> Word[0x10021fe8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           7292000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x10021fe0, 0 ~~> Word[0x10021fec]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           7293000    0x80004240 addi a4, a4, 16                #; a4  = 0x10021fe0, (wrb) a4  <-- 0x10021ff0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           7294000    0x80004244 bltu a4, a3, -20               #; a4  = 0x10021ff0, a3  = 0x10022010, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           7296000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x10021ff0, 0 ~~> Word[0x10021ff0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           7299000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x10021ff0, 0 ~~> Word[0x10021ff4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           7303000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x10021ff0, 0 ~~> Word[0x10021ff8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           7306000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x10021ff0, 0 ~~> Word[0x10021ffc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           7307000    0x80004240 addi a4, a4, 16                #; a4  = 0x10021ff0, (wrb) a4  <-- 0x10022000
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           7308000    0x80004244 bltu a4, a3, -20               #; a4  = 0x10022000, a3  = 0x10022010, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           7310000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x10022000, 0 ~~> Word[0x10022000]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           7313000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x10022000, 0 ~~> Word[0x10022004]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           7317000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x10022000, 0 ~~> Word[0x10022008]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           7320000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x10022000, 0 ~~> Word[0x1002200c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           7321000    0x80004240 addi a4, a4, 16                #; a4  = 0x10022000, (wrb) a4  <-- 0x10022010
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           7322000    0x80004244 bltu a4, a3, -20               #; a4  = 0x10022010, a3  = 0x10022010, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           7323000    0x80004248 bnez a2, 8                     #; a2  = 4, taken, goto 0x80004250
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
           7324000    0x80004250 sub a3, t1, a2                 #; t1  = 15, a2  = 4, (wrb) a3  <-- 11
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
           7325000    0x80004254 slli a3, a3, 2                 #; a3  = 11, (wrb) a3  <-- 44
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
           7326000    0x80004258 auipc t0, 0                    #; (wrb) t0  <-- 0x80004258
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
           7327000    0x8000425c add a3, a3, t0                 #; a3  = 44, t0  = 0x80004258, (wrb) a3  <-- 0x80004284
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
           7328000    0x80004260 jr 12(a3)                      #; a3  = 0x80004284, goto 0x80004290
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           7329000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x10022010, 0 ~~> Byte[0x10022013]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           7330000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x10022010, 0 ~~> Byte[0x10022012]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           7331000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x10022010, 0 ~~> Byte[0x10022011]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           7334000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x10022010, 0 ~~> Byte[0x10022010]
#; .Ltable (memset.S:85)
#;   ret
           7335000    0x800042a0 ret                            #; ra  = 0x80003fd8, goto 0x80003fd8
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:85:5)
#;     snrt_cluster_hw_barrier (sync.h:174:5)
#;       asm volatile("csrr x0, 0x7C2" ::: "memory");
#;       ^
           7336000    0x80003fd8 csrr zero, 1986                #; csr@7c2 = 0
           7338000    0x80003fdc auipc s0, 2                    #; (wrb) s0  <-- 0x80005fdc
           7339000    0x80003fe0 addi s0, s0, -580              #; s0  = 0x80005fdc, (wrb) s0  <-- 0x80005d98
           7340000    0x80003fe4 auipc s7, 2                    #; (wrb) s7  <-- 0x80005fe4
           7341000    0x80003fe8 addi s7, s7, -588              #; s7  = 0x80005fe4, (wrb) s7  <-- 0x80005d98
           7342000    0x80003fec auipc s6, 2                    #; (wrb) s6  <-- 0x80005fec
           7343000    0x80003ff0 addi s6, s6, -596              #; s6  = 0x80005fec, (wrb) s6  <-- 0x80005d98
           7344000    0x80003ff4 auipc s8, 2                    #; (wrb) s8  <-- 0x80005ff4
           7345000    0x80003ff8 addi s8, s8, -572              #; s8  = 0x80005ff4, (wrb) s8  <-- 0x80005db8
#; .LBB25_30 (start.c:235:5)
#;   snrt_init_cls (start.c:166:13)
#;     if (snrt_cluster_core_idx() == 0) {
#;         ^
           7346000    0x80003ffc beqz s4, 84                    #; s4  = 1, not taken
#; .LBB25_30 (start.c:235:5)
#;   snrt_init_cls (start.c:172:17)
#;     if (size)
#;         ^
           7357000    0x80004000 sub s1, s7, s0                 #; s7  = 0x80005d98, s0  = 0x80005d98, (wrb) s1  <-- 0
           7358000    0x80004004 beqz s1, 36                    #; s1  = 0, taken, goto 0x80004028
#; .LBB25_12 (start.c:235:5)
#;   snrt_init_cls (start.c:177:21)
#;     if (size)
#;         ^
           7359000    0x80004028 sub a2, s8, s6                 #; s8  = 0x80005db8, s6  = 0x80005d98, (wrb) a2  <-- 32
           7360000    0x8000402c beqz a2, 36                    #; a2  = 32, not taken
#; .LBB25_12 (start.c:235:5)
#;   snrt_init_cls (start.c:178:20)
#;     memset((void*)ptr, 0, size);
#;     ^
           7361000    0x80004030 add a0, s1, a2                 #; s1  = 0, a2  = 32, (wrb) a0  <-- 32
           7362000    0x80004034 add a0, a0, s0                 #; a0  = 32, s0  = 0x80005d98, (wrb) a0  <-- 0x80005db8
           7363000    0x80004038 sub a0, s7, a0                 #; s7  = 0x80005d98, a0  = 0x80005db8, (wrb) a0  <-- -32
           7364000    0x8000403c lui a1, 65568                  #; (wrb) a1  <-- 0x10020000
           7367000    0x80004040 add a0, a0, a1                 #; a0  = -32, a1  = 0x10020000, (wrb) a0  <-- 0x1001ffe0
           7368000    0x80004044 li a1, 0                       #; (wrb) a1  <-- 0
           7369000    0x80004048 auipc ra, 0                    #; (wrb) ra  <-- 0x80004048
           7370000    0x8000404c jalr 452(ra)                   #; ra  = 0x80004048, (wrb) ra  <-- 0x80004050, goto 0x8000420c
#; memset (memset.S:30)
#;   li t1, 15
           7373000    0x8000420c li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
           7374000    0x80004210 mv a4, a0                      #; a0  = 0x1001ffe0, (wrb) a4  <-- 0x1001ffe0
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
           7375000    0x80004214 bgeu t1, a2, 60                #; t1  = 15, a2  = 32, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
           7376000    0x80004218 andi a5, a4, 15                #; a4  = 0x1001ffe0, (wrb) a5  <-- 0
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
           7377000    0x8000421c bnez a5, 160                   #; a5  = 0, not taken
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           7378000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           7379000    0x80004224 andi a3, a2, -16               #; a2  = 32, (wrb) a3  <-- 32
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           7380000    0x80004228 andi a2, a2, 15                #; a2  = 32, (wrb) a2  <-- 0
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           7381000    0x8000422c add a3, a3, a4                 #; a3  = 32, a4  = 0x1001ffe0, (wrb) a3  <-- 0x10020000
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           7382000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001ffe0, 0 ~~> Word[0x1001ffe0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           7383000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001ffe0, 0 ~~> Word[0x1001ffe4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           7384000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001ffe0, 0 ~~> Word[0x1001ffe8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           7385000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001ffe0, 0 ~~> Word[0x1001ffec]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           7386000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001ffe0, (wrb) a4  <-- 0x1001fff0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           7387000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001fff0, a3  = 0x10020000, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           7388000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001fff0, 0 ~~> Word[0x1001fff0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           7389000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001fff0, 0 ~~> Word[0x1001fff4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           7390000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001fff0, 0 ~~> Word[0x1001fff8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           7391000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001fff0, 0 ~~> Word[0x1001fffc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           7392000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001fff0, (wrb) a4  <-- 0x10020000
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           7393000    0x80004244 bltu a4, a3, -20               #; a4  = 0x10020000, a3  = 0x10020000, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           7394000    0x80004248 bnez a2, 8                     #; a2  = 0, not taken
#; .Ltmp0 (memset.S:57)
#;   ret
           7395000    0x8000424c ret                            #; ra  = 0x80004050, goto 0x80004050
#; .LBB25_14 (start.c:235:5)
#;   snrt_init_cls (start.c:182:14)
#;     _cls_ptr = (cls_t*)snrt_cls_base_addr();
#;              ^
           7396000    0x80004050 sub a0, s7, s0                 #; s7  = 0x80005d98, s0  = 0x80005d98, (wrb) a0  <-- 0
           7397000    0x80004054 add a0, a0, s8                 #; a0  = 0, s8  = 0x80005db8, (wrb) a0  <-- 0x80005db8
           7398000    0x80004058 sub a0, s6, a0                 #; s6  = 0x80005d98, a0  = 0x80005db8, (wrb) a0  <-- -32
           7399000    0x8000405c lui a2, 65568                  #; (wrb) a2  <-- 0x10020000
           7400000    0x80004060 add a1, a0, a2                 #; a0  = -32, a2  = 0x10020000, (wrb) a1  <-- 0x1001ffe0
           7401000    0x80004064 lui a3, 0                      #; (wrb) a3  <-- 0
           7402000    0x80004068 add s0, a3, tp                 #; a3  = 0, tp  = 0x1001ff88, (wrb) s0  <-- 0x1001ff88
           7403000    0x8000406c sw a1, 64(s0)                  #; s0  = 0x1001ff88, 0x1001ffe0 ~~> Word[0x1001ffc8]
#; .LBB25_14 (start.c:235:5)
#;   snrt_init_cls (start.c:183:5)
#;     snrt_cluster_hw_barrier (sync.h:174:5)
#;       asm volatile("csrr x0, 0x7C2" ::: "memory");
#;       ^
           7404000    0x80004070 csrr zero, 1986                #; csr@7c2 = 0
           7406000    0x80004074 li a3, 8                       #; (wrb) a3  <-- 8
           7407000    0x80004078 auipc a1, 4                    #; (wrb) a1  <-- 0x80008078
           7408000    0x8000407c addi a1, a1, 1200              #; a1  = 0x80008078, (wrb) a1  <-- 0x80008528
#; .LBB25_31 (start.c:243:5)
#;   snrt_init_libs (start.c:189:5)
#;     snrt_alloc_init (alloc.h:113:9)
#;       if (snrt_is_dm_core()) {
#;           ^
           7419000    0x80004080 bltu s5, a3, 84                #; s5  = 0, a3  = 8, taken, goto 0x800040d4
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:189:5)
#;     snrt_alloc_init (alloc.h:131:5)
#;       snrt_cluster_hw_barrier (sync.h:174:5)
#;         asm volatile("csrr x0, 0x7C2" ::: "memory");
#;         ^
           7430000    0x800040d4 csrr zero, 1986                #; csr@7c2 = 0
           7453000    0x800040d8 lui a2, 65536                  #; (wrb) a2  <-- 0x10000000
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:190:5)
#;     snrt_l1_init (alloc_v2.h:117:43)
#;       snrt_cluster (snitch_cluster_memory.h:23:46)
#;         return &(snitch_cluster_addrmap.cluster) + snrt_cluster_idx();
#;                                                  ^
           7454000    0x800040dc add a2, s3, a2                 #; s3  = 0, a2  = 0x10000000, (wrb) a2  <-- 0x10000000
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:190:5)
#;     snrt_l1_init (alloc_v2.h:118:34)
#;       snrt_l1_allocator_v2()->base = snrt_align_up(l1_start_addr, MIN_CHUNK_SIZE);
#;                                    ^
           7455000    0x800040e0 lui a3, 0                      #; (wrb) a3  <-- 0
           7456000    0x800040e4 add a3, a3, tp                 #; a3  = 0, tp  = 0x1001ff88, (wrb) a3  <-- 0x1001ff88
           7457000    0x800040e8 sw zero, 20(a3)                #; a3  = 0x1001ff88, 0 ~~> Word[0x1001ff9c]
           7458000    0x800040ec sw a2, 16(a3)                  #; a3  = 0x1001ff88, 0x10000000 ~~> Word[0x1001ff98]
           7459000    0x800040f0 addi a3, a3, 16                #; a3  = 0x1001ff88, (wrb) a3  <-- 0x1001ff98
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:190:5)
#;     snrt_l1_init (alloc_v2.h:119:33)
#;       snrt_l1_allocator_v2()->end = heap_end_addr;
#;                                   ^
           7460000    0x800040f4 sw zero, 12(a3)                #; a3  = 0x1001ff98, 0 ~~> Word[0x1001ffa4]
           7461000    0x800040f8 lui a4, 65566                  #; (wrb) a4  <-- 0x1001e000
           7462000    0x800040fc addi a4, a4, -1152             #; a4  = 0x1001e000, (wrb) a4  <-- 0x1001db80
           7473000    0x80004100 add a0, a0, a4                 #; a0  = -32, a4  = 0x1001db80, (wrb) a0  <-- 0x1001db60
           7474000    0x80004104 sw a0, 8(a3)                   #; a3  = 0x1001ff98, 0x1001db60 ~~> Word[0x1001ffa0]
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:190:5)
#;     snrt_l1_init (alloc_v2.h:120:34)
#;       snrt_l1_allocator_v2()->next = snrt_l1_allocator_v2()->base;
#;                                    ^
           7475000    0x80004108 sw zero, 20(a3)                #; a3  = 0x1001ff98, 0 ~~> Word[0x1001ffac]
           7476000    0x8000410c sw a2, 16(a3)                  #; a3  = 0x1001ff98, 0x10000000 ~~> Word[0x1001ffa8]
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:191:5)
#;     snrt_l3_init (alloc_v2.h:184:34)
#;       snrt_l3_allocator_v2()->base =
#;                                    ^
           7477000    0x80004110 lui a0, 0                      #; (wrb) a0  <-- 0
           7478000    0x80004114 add a0, a0, tp                 #; a0  = 0, tp  = 0x1001ff88, (wrb) a0  <-- 0x1001ff88
           7479000    0x80004118 sw zero, 44(a0)                #; a0  = 0x1001ff88, 0 ~~> Word[0x1001ffb4]
           7480000    0x8000411c addi a1, a1, 7                 #; a1  = 0x80008528, (wrb) a1  <-- 0x8000852f
           7481000    0x80004120 andi a1, a1, -8                #; a1  = 0x8000852f, (wrb) a1  <-- 0x80008528
           7482000    0x80004124 sw a1, 40(a0)                  #; a0  = 0x1001ff88, 0x80008528 ~~> Word[0x1001ffb0]
           7483000    0x80004128 addi a0, a0, 40                #; a0  = 0x1001ff88, (wrb) a0  <-- 0x1001ffb0
           7484000    0x8000412c li a2, 1                       #; (wrb) a2  <-- 1
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:191:5)
#;     snrt_l3_init (alloc_v2.h:186:33)
#;       snrt_l3_allocator_v2()->end = SNRT_L3_END_ADDR;
#;                                   ^
           7485000    0x80004130 sw a2, 12(a0)                  #; a0  = 0x1001ffb0, 1 ~~> Word[0x1001ffbc]
           7486000    0x80004134 sw zero, 8(a0)                 #; a0  = 0x1001ffb0, 0 ~~> Word[0x1001ffb8]
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:191:5)
#;     snrt_l3_init (alloc_v2.h:187:34)
#;       snrt_l3_allocator_v2()->next = snrt_l3_allocator_v2()->base;
#;                                    ^
           7487000    0x80004138 sw zero, 20(a0)                #; a0  = 0x1001ffb0, 0 ~~> Word[0x1001ffc4]
           7488000    0x8000413c sw a1, 16(a0)                  #; a0  = 0x1001ffb0, 0x80008528 ~~> Word[0x1001ffc0]
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:192:5)
#;     snrt_comm_init (sync.h:37:48)
#;       inline void snrt_comm_init() { snrt_comm_world = &snrt_comm_world_info; }
#;                                                      ^
           7499000    0x80004140 lui a0, 0                      #; (wrb) a0  <-- 0
           7500000    0x80004144 add a0, a0, tp                 #; a0  = 0, tp  = 0x1001ff88, (wrb) a0  <-- 0x1001ff88
           7501000    0x80004148 lui a1, 0                      #; (wrb) a1  <-- 0
           7502000    0x8000414c add a1, a1, tp                 #; a1  = 0, tp  = 0x1001ff88, (wrb) a1  <-- 0x1001ff88
           7503000    0x80004150 mv a1, a1                      #; a1  = 0x1001ff88, (wrb) a1  <-- 0x1001ff88
           7504000    0x80004154 sw a1, 76(a0)                  #; a0  = 0x1001ff88, 0x1001ff88 ~~> Word[0x1001ffd4]
#; .LBB25_16 (start.c:251:5)
#;   snrt_cluster_hw_barrier (sync.h:174:5)
#;     asm volatile("csrr x0, 0x7C2" ::: "memory");
#;     ^
           7505000    0x80004158 csrr zero, 1986                #; csr@7c2 = 0
#; .LBB25_16 (start.c:260:17)
#;   exit_code = main();
#;               ^
           7507000    0x8000415c auipc ra, 1048572              #; (wrb) ra  <-- 0x8000015c
           7508000    0x80004160 jalr 112(ra)                   #; ra  = 0x8000015c, (wrb) ra  <-- 0x80004164, goto 0x800001cc
#; main (xpulp_vect.c:4)
#;   int main() {
           7513000    0x800001cc addi sp, sp, -48               #; sp  = 0x1001ff48, (wrb) sp  <-- 0x1001ff18
#; main (xpulp_vect.c:6:5)
#;   snrt_cluster_hw_barrier (sync.h:174:5)
#;     asm volatile("csrr x0, 0x7C2" ::: "memory");
#;     ^
           7514000    0x800001d0 sw s0, 44(sp)                  #; sp  = 0x1001ff18, 0x1001ff88 ~~> Word[0x1001ff44]
           7515000    0x800001d4 sw s1, 40(sp)                  #; sp  = 0x1001ff18, 0 ~~> Word[0x1001ff40]
           7516000    0x800001d8 sw s2, 36(sp)                  #; sp  = 0x1001ff18, 0 ~~> Word[0x1001ff3c]
           7517000    0x800001dc sw s3, 32(sp)                  #; sp  = 0x1001ff18, 0 ~~> Word[0x1001ff38]
           7519000    0x800001e0 sw s4, 28(sp)                  #; sp  = 0x1001ff18, 1 ~~> Word[0x1001ff34]
           7520000    0x800001e4 sw s5, 24(sp)                  #; sp  = 0x1001ff18, 0 ~~> Word[0x1001ff30]
           7522000    0x800001e8 sw s6, 20(sp)                  #; sp  = 0x1001ff18, 0x80005d98 ~~> Word[0x1001ff2c]
           7523000    0x800001ec sw s7, 16(sp)                  #; sp  = 0x1001ff18, 0x80005d98 ~~> Word[0x1001ff28]
           7525000    0x800001f0 sw s8, 12(sp)                  #; sp  = 0x1001ff18, 0x80005db8 ~~> Word[0x1001ff24]
           7526000    0x800001f4 csrr zero, 1986                #; csr@7c2 = 0
#; main (xpulp_vect.c:5:18)
#;   snrt_global_core_idx (team.h:80:12)
#;     snrt_hartid (team.h:25:5)
#;       asm("csrr %0, mhartid" : "=r"(hartid));
#;       ^
           7531000    0x800001f8 csrr a0, mhartid               #; mhartid = 0, (wrb) a0  <-- 0
           7532000    0x800001fc li a1, 2                       #; (wrb) a1  <-- 2
#; main (xpulp_vect.c:7:9)
#;   if (i == 2) {
#;       ^
           7543000    0x80000200 bne a0, a1, 3456               #; a0  = 0, a1  = 2, taken, goto 0x80000f80
           7554000    0x80000f80 li a0, 0                       #; (wrb) a0  <-- 0
#; .LBB0_5 (xpulp_vect.c:1310:1)
#;   }
#;   ^
           7555000    0x80000f84 lw s0, 44(sp)                  #; sp  = 0x1001ff18, s0  <~~ Word[0x1001ff44]
           7556000    0x80000f88 lw s1, 40(sp)                  #; sp  = 0x1001ff18, s1  <~~ Word[0x1001ff40]
           7557000    0x80000f8c lw s2, 36(sp)                  #; sp  = 0x1001ff18, s2  <~~ Word[0x1001ff3c]
           7558000    0x80000f90 lw s3, 32(sp)                  #; sp  = 0x1001ff18, s3  <~~ Word[0x1001ff38], (lsu) s0  <-- 0x1001ff88
           7559000    0x80000f94 lw s4, 28(sp)                  #; sp  = 0x1001ff18, s4  <~~ Word[0x1001ff34], (lsu) s1  <-- 0
           7560000    0x80000f98 lw s5, 24(sp)                  #; sp  = 0x1001ff18, s5  <~~ Word[0x1001ff30], (lsu) s2  <-- 0
           7561000    0x80000f9c lw s6, 20(sp)                  #; sp  = 0x1001ff18, s6  <~~ Word[0x1001ff2c], (lsu) s3  <-- 0
           7562000    0x80000fa0 lw s7, 16(sp)                  #; sp  = 0x1001ff18, s7  <~~ Word[0x1001ff28], (lsu) s4  <-- 1
           7563000    0x80000fa4 lw s8, 12(sp)                  #; sp  = 0x1001ff18, s8  <~~ Word[0x1001ff24], (lsu) s5  <-- 0
           7564000    0x80000fa8 addi sp, sp, 48                #; sp  = 0x1001ff18, (wrb) sp  <-- 0x1001ff48
           7565000    0x80000fac ret                            #; ra  = 0x80004164, (lsu) s6  <-- 0x80005d98, goto 0x80004164
#; .LBB25_16 (start.c:268:5)
#;   snrt_cluster_hw_barrier (sync.h:174:5)
#;     asm volatile("csrr x0, 0x7C2" ::: "memory");
#;     ^
           7566000    0x80004164 csrr zero, 1986                #; csr@7c2 = 0, (lsu) s7  <-- 0x80005d98
           7567000                                              #; (lsu) s8  <-- 0x80005db8
#; .LBB25_16 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:293:34)
#;         cls (cls.h:9:30)
#;           inline cls_t* cls() { return _cls_ptr; }
#;                                        ^
           9094000    0x80004168 lw a1, 64(s0)                  #; s0  = 0x1001ff88, a1  <~~ Word[0x1001ffc8]
           9097000                                              #; (lsu) a1  <-- 0x1001ffe0
#; .LBB25_16 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:293:41)
#;         uint32_t *cluster_result = &(cls()->reduction);
#;                                             ^
           9098000    0x8000416c addi a2, a1, 4                 #; a1  = 0x1001ffe0, (wrb) a2  <-- 0x1001ffe4
#; .LBB25_16 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:294:20)
#;         uint32_t tmp = __atomic_fetch_add(cluster_result, value, __ATOMIC_RELAXED);
#;                        ^
           9099000    0x80004170 amoadd.w a0, a0, (a2)          #; a2  = 0x1001ffe4, a0  = 0, a0  <~~ Word[0x1001ffe4]
           9105000                                              #; (lsu) a0  <-- 0
#; .LBB25_16 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:297:5)
#;         snrt_wait_writeback (sync.h:404:5)
#;           asm volatile("mv %0, %0" : "+r"(val)::);
#;           ^
           9106000    0x80004174 mv a0, a0                      #; a0  = 0, (wrb) a0  <-- 0
#; .LBB25_16 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:298:5)
#;         snrt_cluster_hw_barrier (sync.h:174:5)
#;           asm volatile("csrr x0, 0x7C2" ::: "memory");
#;           ^
           9107000    0x80004178 csrr zero, 1986                #; csr@7c2 = 0
#; .LBB25_16 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:300:9)
#;         if (snrt_cluster_core_idx() == 0) {
#;             ^
           9130000    0x8000417c beqz s4, 72                    #; s4  = 1, not taken
#; .LBB25_16 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:301:48)
#;         __atomic_add_fetch(&_reduction_result, *cluster_result,
#;                                                ^
           9148000    0x80004180 lw a0, 4(a1)                   #; a1  = 0x1001ffe0, a0  <~~ Word[0x1001ffe4]
#; .LBB25_33 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:301:9)
#;         __atomic_add_fetch(&_reduction_result, *cluster_result,
#;         ^
           9149000    0x80004184 auipc a2, 2                    #; (wrb) a2  <-- 0x80006184
           9150000    0x80004188 addi a2, a2, -784              #; a2  = 0x80006184, (wrb) a2  <-- 0x80005e74
           9151000                                              #; (lsu) a0  <-- 6
           9152000    0x8000418c amoadd.w a0, a0, (a2)          #; a2  = 0x80005e74, a0  = 6, a0  <~~ Word[0x80005e74]
#; .LBB25_33 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:304:5)
#;         snrt_global_barrier (sync.h:218:5)
#;           snrt_cluster_hw_barrier (sync.h:174:5)
#;             asm volatile("csrr x0, 0x7C2" ::: "memory");
#;             ^
           9153000    0x80004190 csrr zero, 1986                #; csr@7c2 = 0
#; .LBB25_33 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:304:5)
#;         snrt_global_barrier (sync.h:230:5)
#;           snrt_cluster_hw_barrier (sync.h:174:5)
#;             asm volatile("csrr x0, 0x7C2" ::: "memory");
#;             ^
           9155000    0x80004194 csrr zero, 1986                #; csr@7c2 = 0
           9168000                                              #; (lsu) a0  <-- 0
#; .LBB25_33 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:306:27)
#;         *cluster_result = _reduction_result;
#;                           ^
           9169000    0x80004198 lw a0, 0(a2)                   #; a2  = 0x80005e74, a0  <~~ Word[0x80005e74]
           9179000                                              #; (lsu) a0  <-- 6
#; .LBB25_33 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:306:25)
#;         *cluster_result = _reduction_result;
#;                         ^
           9180000    0x8000419c sw a0, 4(a1)                   #; a1  = 0x1001ffe0, 6 ~~> Word[0x1001ffe4]
#; .LBB25_33 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:308:5)
#;         snrt_cluster_hw_barrier (sync.h:174:5)
#;           asm volatile("csrr x0, 0x7C2" ::: "memory");
#;           ^
           9181000    0x800041a0 csrr zero, 1986                #; csr@7c2 = 0
#; .LBB25_33 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:15:9)
#;       if (snrt_global_core_idx() == 0)
#;           ^
           9183000    0x800041a4 bnez s2, 44                    #; s2  = 0, not taken
#; .LBB25_33 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:309:12)
#;         return *cluster_result;
#;                ^
           9184000    0x800041a8 lw a0, 4(a1)                   #; a1  = 0x1001ffe0, a0  <~~ Word[0x1001ffe4]
           9187000                                              #; (lsu) a0  <-- 6
#; .LBB25_33 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:16:54)
#;       *(snrt_exit_code_destination()) = (exit_code << 1) | 1;
#;                                                    ^
           9188000    0x800041ac slli a0, a0, 1                 #; a0  = 6, (wrb) a0  <-- 12
#; .LBB25_33 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:16:60)
#;       *(snrt_exit_code_destination()) = (exit_code << 1) | 1;
#;                                                          ^
           9189000    0x800041b0 ori a0, a0, 1                  #; a0  = 12, (wrb) a0  <-- 13
#; .LBB25_34 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:16:41)
#;       *(snrt_exit_code_destination()) = (exit_code << 1) | 1;
#;                                       ^
           9190000    0x800041b4 auipc a1, 2                    #; (wrb) a1  <-- 0x800061b4
           9191000    0x800041b8 addi a1, a1, -1204             #; a1  = 0x800061b4, (wrb) a1  <-- 0x80005d00
           9192000    0x800041bc sw a0, 0(a1)                   #; a1  = 0x80005d00, 13 ~~> Word[0x80005d00]
           9195000    0x800041c0 j 16                           #; goto 0x800041d0
#; .LBB25_20 (start.c:282:1)
#;   }
#;   ^
           9196000    0x800041d0 lw ra, 60(sp)                  #; sp  = 0x1001ff48, ra  <~~ Word[0x1001ff84]
           9197000    0x800041d4 lw s0, 56(sp)                  #; sp  = 0x1001ff48, s0  <~~ Word[0x1001ff80]
           9198000    0x800041d8 lw s1, 52(sp)                  #; sp  = 0x1001ff48, s1  <~~ Word[0x1001ff7c]
           9204000    0x800041dc lw s2, 48(sp)                  #; sp  = 0x1001ff48, s2  <~~ Word[0x1001ff78], (lsu) ra  <-- 0x800001c4
           9205000    0x800041e0 lw s3, 44(sp)                  #; sp  = 0x1001ff48, s3  <~~ Word[0x1001ff74], (lsu) s0  <-- 0
           9206000    0x800041e4 lw s4, 40(sp)                  #; sp  = 0x1001ff48, s4  <~~ Word[0x1001ff70], (lsu) s1  <-- 0
           9207000    0x800041e8 lw s5, 36(sp)                  #; sp  = 0x1001ff48, s5  <~~ Word[0x1001ff6c], (lsu) s2  <-- 0
           9208000    0x800041ec lw s6, 32(sp)                  #; sp  = 0x1001ff48, s6  <~~ Word[0x1001ff68], (lsu) s3  <-- 0
           9209000    0x800041f0 lw s7, 28(sp)                  #; sp  = 0x1001ff48, s7  <~~ Word[0x1001ff64], (lsu) s4  <-- 0
           9210000    0x800041f4 lw s8, 24(sp)                  #; sp  = 0x1001ff48, s8  <~~ Word[0x1001ff60], (lsu) s5  <-- 0
           9211000    0x800041f8 lw s9, 20(sp)                  #; sp  = 0x1001ff48, s9  <~~ Word[0x1001ff5c], (lsu) s6  <-- 0
           9212000    0x800041fc lw s10, 16(sp)                 #; sp  = 0x1001ff48, s10 <~~ Word[0x1001ff58], (lsu) s7  <-- 0
           9213000                                              #; (lsu) s8  <-- 0
           9214000                                              #; (lsu) s9  <-- 0
           9215000                                              #; (lsu) s10 <-- 0
           9218000    0x80004200 lw s11, 12(sp)                 #; sp  = 0x1001ff48, s11 <~~ Word[0x1001ff54]
           9219000    0x80004204 addi sp, sp, 64                #; sp  = 0x1001ff48, (wrb) sp  <-- 0x1001ff88
           9220000    0x80004208 ret                            #; ra  = 0x800001c4, goto 0x800001c4
           9221000                                              #; (lsu) s11 <-- 0
#; .Ltmp2 (start.S:183)
#;   wfi
           9223000    0x800001c4 wfi                            #; 

## Performance metrics

Performance metrics for section 0 @ (8, 9221):
tstart                                          10
snitch_loads                                    96
snitch_stores                                  361
tend                                          9223
fpss_loads                                       0
snitch_avg_load_latency                      11.22
snitch_occupancy                            0.1624
snitch_fseq_rel_offloads                   0.02094
fseq_yield                                     1.0
fseq_fpu_yield                                 1.0
fpss_section_latency                             0
fpss_avg_fpu_latency                           2.0
fpss_avg_load_latency                            0
fpss_occupancy                            0.003473
fpss_fpu_occupancy                        0.003473
fpss_fpu_rel_occupancy                         1.0
cycles                                        9214
total_ipc                                   0.1658
