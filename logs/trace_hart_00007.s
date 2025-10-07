             19000    0x18020000 auipc t0, 0                    #; (wrb) t0  <-- 0x18020000
             34000    0x18020004 addi t0, t0, 32                #; t0  = 0x18020000, (wrb) t0  <-- 0x18020020
             47000    0x18020008 csrw mtvec, t0                 #; t0  = 0x18020020
             60000    0x1802000c csrsi mstatus, 8               #; mstatus = 0x80006000
             73000    0x18020010 lui t0, 128                    #; (wrb) t0  <-- 0x00080000
             88000    0x18020014 addi t0, t0, 8                 #; t0  = 0x00080000, (wrb) t0  <-- 0x00080008
            101000    0x18020018 csrw mie, t0                   #; t0  = 0x00080008
            114000    0x1802001c wfi                            #; 
            335000    0x18020020 auipc t0, 0                    #; exception, goto 0x18020020
            348000    0x18020020 auipc t0, 0                    #; (wrb) t0  <-- 0x18020020
            361000    0x18020024 lui t1, 1                      #; (wrb) t1  <-- 4096
            374000    0x18020028 addi t1, t1, 360               #; t1  = 4096, (wrb) t1  <-- 4456
            389000    0x1802002c add t0, t0, t1                 #; t0  = 0x18020020, t1  = 4456, (wrb) t0  <-- 0x18021188
            402000    0x18020030 lw t0, 0(t0)                   #; t0  = 0x18021188, t0  <~~ Word[0x18021188]
            421000                                              #; (lsu) t0  <-- 0x80000000
            423000    0x18020034 jalr t0                        #; t0  = 0x80000000, (wrb) ra  <-- 0x18020038, goto 0x80000000
#; _start (start.S:12)
#;   mv t0, x0
            428000    0x80000000 li t0, 0                       #; (wrb) t0  <-- 0
#; _start (start.S:13)
#;   mv t1, x0
            429000    0x80000004 li t1, 0                       #; (wrb) t1  <-- 0
#; _start (start.S:14)
#;   mv t2, x0
            430000    0x80000008 li t2, 0                       #; (wrb) t2  <-- 0
#; _start (start.S:15)
#;   mv t3, x0
            431000    0x8000000c li t3, 0                       #; (wrb) t3  <-- 0
#; _start (start.S:16)
#;   mv t4, x0
            432000    0x80000010 li t4, 0                       #; (wrb) t4  <-- 0
#; _start (start.S:17)
#;   mv t5, x0
            433000    0x80000014 li t5, 0                       #; (wrb) t5  <-- 0
#; _start (start.S:18)
#;   mv t6, x0
            434000    0x80000018 li t6, 0                       #; (wrb) t6  <-- 0
#; _start (start.S:19)
#;   mv a0, x0
            435000    0x8000001c li a0, 0                       #; (wrb) a0  <-- 0
#; _start (start.S:20)
#;   mv a1, x0
            436000    0x80000020 li a1, 0                       #; (wrb) a1  <-- 0
#; _start (start.S:21)
#;   mv a2, x0
            437000    0x80000024 li a2, 0                       #; (wrb) a2  <-- 0
#; _start (start.S:22)
#;   mv a3, x0
            438000    0x80000028 li a3, 0                       #; (wrb) a3  <-- 0
#; _start (start.S:23)
#;   mv a4, x0
            439000    0x8000002c li a4, 0                       #; (wrb) a4  <-- 0
#; _start (start.S:24)
#;   mv a5, x0
            440000    0x80000030 li a5, 0                       #; (wrb) a5  <-- 0
#; _start (start.S:25)
#;   mv a6, x0
            441000    0x80000034 li a6, 0                       #; (wrb) a6  <-- 0
#; _start (start.S:26)
#;   mv a7, x0
            442000    0x80000038 li a7, 0                       #; (wrb) a7  <-- 0
#; _start (start.S:27)
#;   mv s0, x0
            443000    0x8000003c li s0, 0                       #; (wrb) s0  <-- 0
#; _start (start.S:28)
#;   mv s1, x0
            444000    0x80000040 li s1, 0                       #; (wrb) s1  <-- 0
#; _start (start.S:29)
#;   mv s2, x0
            445000    0x80000044 li s2, 0                       #; (wrb) s2  <-- 0
#; _start (start.S:30)
#;   mv s3, x0
            446000    0x80000048 li s3, 0                       #; (wrb) s3  <-- 0
#; _start (start.S:31)
#;   mv s4, x0
            447000    0x8000004c li s4, 0                       #; (wrb) s4  <-- 0
#; _start (start.S:32)
#;   mv s5, x0
            448000    0x80000050 li s5, 0                       #; (wrb) s5  <-- 0
#; _start (start.S:33)
#;   mv s6, x0
            449000    0x80000054 li s6, 0                       #; (wrb) s6  <-- 0
#; _start (start.S:34)
#;   mv s7, x0
            450000    0x80000058 li s7, 0                       #; (wrb) s7  <-- 0
#; _start (start.S:35)
#;   mv s8, x0
            451000    0x8000005c li s8, 0                       #; (wrb) s8  <-- 0
#; _start (start.S:36)
#;   mv s9, x0
            452000    0x80000060 li s9, 0                       #; (wrb) s9  <-- 0
#; _start (start.S:37)
#;   mv s10, x0
            453000    0x80000064 li s10, 0                      #; (wrb) s10 <-- 0
#; _start (start.S:38)
#;   mv s11, x0
            454000    0x80000068 li s11, 0                      #; (wrb) s11 <-- 0
#; snrt.crt0.init_fp_registers (start.S:44)
#;   csrr    t0, misa
            455000    0x8000006c csrr t0, misa                  #; misa = 0x40801129, (wrb) t0  <-- 0x40801129
#; snrt.crt0.init_fp_registers (start.S:45)
#;   andi    t0, t0, (1 << 3) | (1 << 5) # D/F - single/double precision float extension
            456000    0x80000070 andi t0, t0, 40                #; t0  = 0x40801129, (wrb) t0  <-- 40
#; snrt.crt0.init_fp_registers (start.S:46)
#;   beqz    t0, 3f
            457000    0x80000074 beqz t0, 132                   #; t0  = 40, not taken
#; snrt.crt0.init_fp_registers (start.S:48)
#;   fcvt.d.w f0, zero
            459000    0x80000078 fcvt.d.w ft0, zero             #; ac1  = 0
#; snrt.crt0.init_fp_registers (start.S:49)
#;   fcvt.d.w f1, zero
            460000    0x8000007c fcvt.d.w ft1, zero             #; ac1  = 0
#; snrt.crt0.init_fp_registers (start.S:50)
#;   fcvt.d.w f2, zero
            461000    0x80000080 fcvt.d.w ft2, zero             #; ac1  = 0, (f:fpu) ft0  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:51)
#;   fcvt.d.w f3, zero
            462000    0x80000084 fcvt.d.w ft3, zero             #; ac1  = 0, (f:fpu) ft1  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:52)
#;   fcvt.d.w f4, zero
            463000    0x80000088 fcvt.d.w ft4, zero             #; ac1  = 0, (f:fpu) ft2  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:53)
#;   fcvt.d.w f5, zero
            464000    0x8000008c fcvt.d.w ft5, zero             #; ac1  = 0, (f:fpu) ft3  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:54)
#;   fcvt.d.w f6, zero
            465000    0x80000090 fcvt.d.w ft6, zero             #; ac1  = 0, (f:fpu) ft4  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:55)
#;   fcvt.d.w f7, zero
            466000    0x80000094 fcvt.d.w ft7, zero             #; ac1  = 0, (f:fpu) ft5  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:56)
#;   fcvt.d.w f8, zero
            467000    0x80000098 fcvt.d.w fs0, zero             #; ac1  = 0, (f:fpu) ft6  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:57)
#;   fcvt.d.w f9, zero
            468000    0x8000009c fcvt.d.w fs1, zero             #; ac1  = 0, (f:fpu) ft7  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:58)
#;   fcvt.d.w f10, zero
            469000    0x800000a0 fcvt.d.w fa0, zero             #; ac1  = 0, (f:fpu) fs0  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:59)
#;   fcvt.d.w f11, zero
            470000    0x800000a4 fcvt.d.w fa1, zero             #; ac1  = 0, (f:fpu) fs1  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:60)
#;   fcvt.d.w f12, zero
            471000    0x800000a8 fcvt.d.w fa2, zero             #; ac1  = 0, (f:fpu) fa0  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:61)
#;   fcvt.d.w f13, zero
            472000    0x800000ac fcvt.d.w fa3, zero             #; ac1  = 0, (f:fpu) fa1  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:62)
#;   fcvt.d.w f14, zero
            473000    0x800000b0 fcvt.d.w fa4, zero             #; ac1  = 0, (f:fpu) fa2  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:63)
#;   fcvt.d.w f15, zero
            474000    0x800000b4 fcvt.d.w fa5, zero             #; ac1  = 0, (f:fpu) fa3  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:64)
#;   fcvt.d.w f16, zero
            475000    0x800000b8 fcvt.d.w fa6, zero             #; ac1  = 0, (f:fpu) fa4  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:65)
#;   fcvt.d.w f17, zero
            476000    0x800000bc fcvt.d.w fa7, zero             #; ac1  = 0, (f:fpu) fa5  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:66)
#;   fcvt.d.w f18, zero
            477000    0x800000c0 fcvt.d.w fs2, zero             #; ac1  = 0, (f:fpu) fa6  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:67)
#;   fcvt.d.w f19, zero
            478000    0x800000c4 fcvt.d.w fs3, zero             #; ac1  = 0, (f:fpu) fa7  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:68)
#;   fcvt.d.w f20, zero
            479000    0x800000c8 fcvt.d.w fs4, zero             #; ac1  = 0, (f:fpu) fs2  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:69)
#;   fcvt.d.w f21, zero
            480000    0x800000cc fcvt.d.w fs5, zero             #; ac1  = 0, (f:fpu) fs3  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:70)
#;   fcvt.d.w f22, zero
            481000    0x800000d0 fcvt.d.w fs6, zero             #; ac1  = 0, (f:fpu) fs4  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:71)
#;   fcvt.d.w f23, zero
            482000    0x800000d4 fcvt.d.w fs7, zero             #; ac1  = 0, (f:fpu) fs5  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:72)
#;   fcvt.d.w f24, zero
            483000    0x800000d8 fcvt.d.w fs8, zero             #; ac1  = 0, (f:fpu) fs6  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:73)
#;   fcvt.d.w f25, zero
            484000    0x800000dc fcvt.d.w fs9, zero             #; ac1  = 0, (f:fpu) fs7  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:74)
#;   fcvt.d.w f26, zero
            485000    0x800000e0 fcvt.d.w fs10, zero            #; ac1  = 0, (f:fpu) fs8  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:75)
#;   fcvt.d.w f27, zero
            486000    0x800000e4 fcvt.d.w fs11, zero            #; ac1  = 0, (f:fpu) fs9  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:76)
#;   fcvt.d.w f28, zero
            487000    0x800000e8 fcvt.d.w ft8, zero             #; ac1  = 0, (f:fpu) fs10 <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:77)
#;   fcvt.d.w f29, zero
            488000    0x800000ec fcvt.d.w ft9, zero             #; ac1  = 0, (f:fpu) fs11 <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:78)
#;   fcvt.d.w f30, zero
            489000    0x800000f0 fcvt.d.w ft10, zero            #; ac1  = 0, (f:fpu) ft8  <-- 0.0
#; .Ltmp1 (start.S:88)
#;   1:  auipc   gp, %pcrel_hi(__global_pointer$)
            490000    0x800000f8 auipc gp, 6                    #; (wrb) gp  <-- 0x800060f8
#; snrt.crt0.init_fp_registers (start.S:79)
#;   fcvt.d.w f31, zero
                      0x800000f4 fcvt.d.w ft11, zero            #; ac1  = 0, (f:fpu) ft9  <-- 0.0
#; .Ltmp1 (start.S:89)
#;   addi    gp, gp, %pcrel_lo(1b)
            491000    0x800000fc addi gp, gp, 1200              #; gp  = 0x800060f8, (wrb) gp  <-- 0x800065a8
                                                                #; (f:fpu) ft10 <-- 0.0
#; snrt.crt0.init_core_info (start.S:98)
#;   csrr a0, mhartid
            492000    0x80000100 csrr a0, mhartid               #; mhartid = 7, (wrb) a0  <-- 7
                                                                #; (f:fpu) ft11 <-- 0.0
#; snrt.crt0.init_core_info (start.S:99)
#;   li   t0, SNRT_BASE_HARTID
            493000    0x80000104 li t0, 0                       #; (wrb) t0  <-- 0
#; snrt.crt0.init_core_info (start.S:100)
#;   sub  a0, a0, t0
            494000    0x80000108 sub a0, a0, t0                 #; a0  = 7, t0  = 0, (wrb) a0  <-- 7
#; snrt.crt0.init_core_info (start.S:101)
#;   li   a1, SNRT_CLUSTER_CORE_NUM
            495000    0x8000010c li a1, 9                       #; (wrb) a1  <-- 9
#; snrt.crt0.init_core_info (start.S:102)
#;   div  t0, a0, a1
            496000    0x80000110 div t0, a0, a1                 #; a0  = 7, a1  = 9
#; snrt.crt0.init_core_info (start.S:105)
#;   remu a0, a0, a1
            497000    0x80000114 remu a0, a0, a1                #; a0  = 7, a1  = 9
#; snrt.crt0.init_core_info (start.S:108)
#;   li   a2, SNRT_TCDM_START_ADDR
            498000    0x80000118 lui a2, 65536                  #; (wrb) a2  <-- 0x10000000
#; snrt.crt0.init_core_info (start.S:109)
#;   li   t1, SNRT_CLUSTER_OFFSET
            499000    0x8000011c li t1, 0                       #; (wrb) t1  <-- 0
            500000                                              #; (acc) t0  <-- 0
#; snrt.crt0.init_core_info (start.S:110)
#;   mul  t0, t1, t0
            501000    0x80000120 mul t0, t1, t0                 #; t1  = 0, t0  = 0, (acc) a0  <-- 7
            503000                                              #; (acc) t0  <-- 0
#; snrt.crt0.init_core_info (start.S:111)
#;   add  a2, a2, t0
            504000    0x80000124 add a2, a2, t0                 #; a2  = 0x10000000, t0  = 0, (wrb) a2  <-- 0x10000000
#; snrt.crt0.init_core_info (start.S:114)
#;   li   t0, SNRT_TCDM_SIZE
            505000    0x80000128 lui t0, 32                     #; (wrb) t0  <-- 0x00020000
#; snrt.crt0.init_core_info (start.S:115)
#;   add  a2, a2, t0
            506000    0x8000012c add a2, a2, t0                 #; a2  = 0x10000000, t0  = 0x00020000, (wrb) a2  <-- 0x10020000
#; .Lpcrel_hi0 (start.S:121)
#;   la        t0, __cdata_end
            507000    0x80000130 auipc t0, 6                    #; (wrb) t0  <-- 0x80006130
            508000    0x80000134 addi t0, t0, -920              #; t0  = 0x80006130, (wrb) t0  <-- 0x80005d98
#; .Lpcrel_hi1 (start.S:122)
#;   la        t1, __cdata_start
            509000    0x80000138 auipc t1, 6                    #; (wrb) t1  <-- 0x80006138
            510000    0x8000013c addi t1, t1, -928              #; t1  = 0x80006138, (wrb) t1  <-- 0x80005d98
#; .Lpcrel_hi1 (start.S:123)
#;   sub       t0, t0, t1
            511000    0x80000140 sub t0, t0, t1                 #; t0  = 0x80005d98, t1  = 0x80005d98, (wrb) t0  <-- 0
#; .Lpcrel_hi1 (start.S:124)
#;   sub       a2, a2, t0
            512000    0x80000144 sub a2, a2, t0                 #; a2  = 0x10020000, t0  = 0, (wrb) a2  <-- 0x10020000
#; .Lpcrel_hi2 (start.S:125)
#;   la        t0, __cbss_end
            513000    0x80000148 auipc t0, 6                    #; (wrb) t0  <-- 0x80006148
            514000    0x8000014c addi t0, t0, -912              #; t0  = 0x80006148, (wrb) t0  <-- 0x80005db8
#; .Lpcrel_hi3 (start.S:126)
#;   la        t1, __cbss_start
            515000    0x80000150 auipc t1, 6                    #; (wrb) t1  <-- 0x80006150
            516000    0x80000154 addi t1, t1, -952              #; t1  = 0x80006150, (wrb) t1  <-- 0x80005d98
#; .Lpcrel_hi3 (start.S:127)
#;   sub       t0, t0, t1
            517000    0x80000158 sub t0, t0, t1                 #; t0  = 0x80005db8, t1  = 0x80005d98, (wrb) t0  <-- 32
#; .Lpcrel_hi3 (start.S:128)
#;   sub       a2, a2, t0
            518000    0x8000015c sub a2, a2, t0                 #; a2  = 0x10020000, t0  = 32, (wrb) a2  <-- 0x1001ffe0
#; snrt.crt0.init_stack (start.S:135)
#;   addi      a2, a2, -8
            519000    0x80000160 addi a2, a2, -8                #; a2  = 0x1001ffe0, (wrb) a2  <-- 0x1001ffd8
#; snrt.crt0.init_stack (start.S:136)
#;   sw        zero, 0(a2)
            520000    0x80000164 sw zero, 0(a2)                 #; a2  = 0x1001ffd8, 0 ~~> Word[0x1001ffd8]
#; snrt.crt0.init_stack (start.S:140)
#;   sll       t0, a0, SNRT_LOG2_STACK_SIZE
            521000    0x80000168 slli t0, a0, 10                #; a0  = 7, (wrb) t0  <-- 7168
#; snrt.crt0.init_stack (start.S:143)
#;   sub       sp, a2, t0
            522000    0x8000016c sub sp, a2, t0                 #; a2  = 0x1001ffd8, t0  = 7168, (wrb) sp  <-- 0x1001e3d8
#; snrt.crt0.init_stack (start.S:146)
#;   slli      t0, a0, 3  # this hart
            523000    0x80000170 slli t0, a0, 3                 #; a0  = 7, (wrb) t0  <-- 56
#; snrt.crt0.init_stack (start.S:147)
#;   slli      t1, a1, 3  # all harts
            524000    0x80000174 slli t1, a1, 3                 #; a1  = 9, (wrb) t1  <-- 72
#; snrt.crt0.init_stack (start.S:148)
#;   sub       sp, sp, t0
            525000    0x80000178 sub sp, sp, t0                 #; sp  = 0x1001e3d8, t0  = 56, (wrb) sp  <-- 0x1001e3a0
#; snrt.crt0.init_stack (start.S:149)
#;   sub       a2, a2, t1
            526000    0x8000017c sub a2, a2, t1                 #; a2  = 0x1001ffd8, t1  = 72, (wrb) a2  <-- 0x1001ff90
#; .Lpcrel_hi4 (start.S:155)
#;   la        t0, __tdata_end
            527000    0x80000180 auipc t0, 6                    #; (wrb) t0  <-- 0x80006180
            528000    0x80000184 addi t0, t0, -1068             #; t0  = 0x80006180, (wrb) t0  <-- 0x80005d54
#; .Lpcrel_hi5 (start.S:156)
#;   la        t1, __tdata_start
            529000    0x80000188 auipc t1, 6                    #; (wrb) t1  <-- 0x80006188
            530000    0x8000018c addi t1, t1, -1088             #; t1  = 0x80006188, (wrb) t1  <-- 0x80005d48
#; .Lpcrel_hi5 (start.S:157)
#;   sub       t0, t0, t1
            531000    0x80000190 sub t0, t0, t1                 #; t0  = 0x80005d54, t1  = 0x80005d48, (wrb) t0  <-- 12
#; .Lpcrel_hi5 (start.S:158)
#;   sub       sp, sp, t0
            532000    0x80000194 sub sp, sp, t0                 #; sp  = 0x1001e3a0, t0  = 12, (wrb) sp  <-- 0x1001e394
#; .Lpcrel_hi6 (start.S:159)
#;   la        t0, __tbss_end
            533000    0x80000198 auipc t0, 6                    #; (wrb) t0  <-- 0x80006198
            534000    0x8000019c addi t0, t0, -1024             #; t0  = 0x80006198, (wrb) t0  <-- 0x80005d98
#; .Lpcrel_hi7 (start.S:160)
#;   la        t1, __tbss_start
            535000    0x800001a0 auipc t1, 6                    #; (wrb) t1  <-- 0x800061a0
            536000    0x800001a4 addi t1, t1, -1096             #; t1  = 0x800061a0, (wrb) t1  <-- 0x80005d58
#; .Lpcrel_hi7 (start.S:161)
#;   sub       t0, t0, t1
            537000    0x800001a8 sub t0, t0, t1                 #; t0  = 0x80005d98, t1  = 0x80005d58, (wrb) t0  <-- 64
#; .Lpcrel_hi7 (start.S:162)
#;   sub       sp, sp, t0
            538000    0x800001ac sub sp, sp, t0                 #; sp  = 0x1001e394, t0  = 64, (wrb) sp  <-- 0x1001e354
#; .Lpcrel_hi7 (start.S:163)
#;   andi      sp, sp, ~0x7 # align to 8B
            539000    0x800001b0 andi sp, sp, -8                #; sp  = 0x1001e354, (wrb) sp  <-- 0x1001e350
#; .Lpcrel_hi7 (start.S:165)
#;   mv        tp, sp
            540000    0x800001b4 mv tp, sp                      #; sp  = 0x1001e350, (wrb) tp  <-- 0x1001e350
#; .Lpcrel_hi7 (start.S:167)
#;   andi      sp, sp, ~0x7 # align stack to 8B
            541000    0x800001b8 andi sp, sp, -8                #; sp  = 0x1001e350, (wrb) sp  <-- 0x1001e350
#; snrt.crt0.main (start.S:178)
#;   call snrt_main
            542000    0x800001bc auipc ra, 4                    #; (wrb) ra  <-- 0x800041bc
            543000    0x800001c0 jalr -1352(ra)                 #; ra  = 0x800041bc, (wrb) ra  <-- 0x800001c4, goto 0x80003c74
#; snrt_main (start.c:204)
#;   EXTERN_C void snrt_main() {
            546000    0x80003c74 addi sp, sp, -64               #; sp  = 0x1001e350, (wrb) sp  <-- 0x1001e310
            547000    0x80003c78 sw ra, 60(sp)                  #; sp  = 0x1001e310, 0x800001c4 ~~> Word[0x1001e34c]
            548000    0x80003c7c sw s0, 56(sp)                  #; sp  = 0x1001e310, 0 ~~> Word[0x1001e348]
            556000    0x80003c80 sw s1, 52(sp)                  #; sp  = 0x1001e310, 0 ~~> Word[0x1001e344]
            557000    0x80003c84 sw s2, 48(sp)                  #; sp  = 0x1001e310, 0 ~~> Word[0x1001e340]
            558000    0x80003c88 sw s3, 44(sp)                  #; sp  = 0x1001e310, 0 ~~> Word[0x1001e33c]
            559000    0x80003c8c sw s4, 40(sp)                  #; sp  = 0x1001e310, 0 ~~> Word[0x1001e338]
            560000    0x80003c90 sw s5, 36(sp)                  #; sp  = 0x1001e310, 0 ~~> Word[0x1001e334]
            561000    0x80003c94 sw s6, 32(sp)                  #; sp  = 0x1001e310, 0 ~~> Word[0x1001e330]
            562000    0x80003c98 sw s7, 28(sp)                  #; sp  = 0x1001e310, 0 ~~> Word[0x1001e32c]
            563000    0x80003c9c sw s8, 24(sp)                  #; sp  = 0x1001e310, 0 ~~> Word[0x1001e328]
            564000    0x80003ca0 sw s9, 20(sp)                  #; sp  = 0x1001e310, 0 ~~> Word[0x1001e324]
            565000    0x80003ca4 sw s10, 16(sp)                 #; sp  = 0x1001e310, 0 ~~> Word[0x1001e320]
            566000    0x80003ca8 sw s11, 12(sp)                 #; sp  = 0x1001e310, 0 ~~> Word[0x1001e31c]
            567000    0x80003cac li s0, -1                      #; (wrb) s0  <-- -1
#; snrt_main (start.c:206:9)
#;   snrt_cluster_idx (team.h:99:12)
#;     snrt_global_core_idx (team.h:80:12)
#;       snrt_hartid (team.h:25:5)
#;         asm("csrr %0, mhartid" : "=r"(hartid));
#;         ^
            568000    0x80003cb0 csrr s2, mhartid               #; mhartid = 7, (wrb) s2  <-- 7
            569000    0x80003cb4 lui a0, 233017                 #; (wrb) a0  <-- 0x38e39000
            570000    0x80003cb8 addi a0, a0, -455              #; a0  = 0x38e39000, (wrb) a0  <-- 0x38e38e39
#; snrt_main (start.c:206:9)
#;   snrt_cluster_idx (team.h:99:35)
#;     return snrt_global_core_idx() / snrt_cluster_core_num();
#;                                   ^
            571000    0x80003cbc mulhu a0, s2, a0               #; s2  = 7, a0  = 0x38e38e39
            573000                                              #; (acc) a0  <-- 1
            574000    0x80003cc0 srli a0, a0, 1                 #; a0  = 1, (wrb) a0  <-- 0
            575000    0x80003cc4 li a1, 8                       #; (wrb) a1  <-- 8
            576000    0x80003cc8 slli s3, a0, 18                #; a0  = 0, (wrb) s3  <-- 0
#; snrt_main (start.c:206:9)
#;   if (snrt_cluster_idx() == 0) {
#;       ^
            577000    0x80003ccc bltu a1, s2, 184               #; a1  = 8, s2  = 7, not taken
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:31)
#;       snrt_cluster_core_idx (team.h:108:35)
#;         return snrt_global_core_idx() % snrt_cluster_core_num();
#;                                       ^
            578000    0x80003cd0 .text                          #; s2  = 7
            579000    0x80003cd4 li a1, 57                      #; (wrb) a1  <-- 57
            580000                                              #; (acc) s1  <-- 7
            581000    0x80003cd8 mul a1, s1, a1                 #; s1  = 7, a1  = 57
            583000                                              #; (acc) a1  <-- 399
            584000    0x80003cdc srli a1, a1, 9                 #; a1  = 399, (wrb) a1  <-- 0
            585000    0x80003ce0 slli a2, a1, 3                 #; a1  = 0, (wrb) a2  <-- 0
            586000    0x80003ce4 add a1, a2, a1                 #; a2  = 0, a1  = 0, (wrb) a1  <-- 0
            587000    0x80003ce8 lui a2, 65569                  #; (wrb) a2  <-- 0x10021000
            588000    0x80003cec addi a2, a2, 424               #; a2  = 0x10021000, (wrb) a2  <-- 0x100211a8
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:5)
#;       snrt_int_cluster_clr (cluster_interrupts.h:22:53)
#;         snrt_cluster()->peripheral_reg.cl_clint_clear.f.cl_clint_clear = mask;
#;                                                         ^
            589000    0x80003cf0 add a2, s3, a2                 #; s3  = 0, a2  = 0x100211a8, (wrb) a2  <-- 0x100211a8
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:5)
#;       snrt_int_cluster_clr (cluster_interrupts.h:22:68)
#;         snrt_cluster()->peripheral_reg.cl_clint_clear.f.cl_clint_clear = mask;
#;                                                                        ^
            590000    0x80003cf4 lw a3, 0(a2)                   #; a2  = 0x100211a8, a3  <~~ Word[0x100211a8]
            597000                                              #; (lsu) a3  <-- 0
            598000    0x80003cf8 ori a3, a2, 4                  #; a2  = 0x100211a8, (wrb) a3  <-- 0x100211ac
            599000    0x80003cfc lw a4, 0(a3)                   #; a3  = 0x100211ac, a4  <~~ Word[0x100211ac]
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:31)
#;       snrt_cluster_core_idx (team.h:108:35)
#;         return snrt_global_core_idx() % snrt_cluster_core_num();
#;                                       ^
            600000    0x80003d00 sub a1, s2, a1                 #; s2  = 7, a1  = 0, (wrb) a1  <-- 7
            601000    0x80003d04 li a5, 1                       #; (wrb) a5  <-- 1
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:28)
#;       snrt_int_cluster_clr(1 << snrt_cluster_core_idx());
#;                              ^
            602000    0x80003d08 sll a1, a5, a1                 #; a5  = 1, a1  = 7, (wrb) a1  <-- 128
            615000                                              #; (lsu) a4  <-- 0
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:5)
#;       snrt_int_cluster_clr (cluster_interrupts.h:22:68)
#;         snrt_cluster()->peripheral_reg.cl_clint_clear.f.cl_clint_clear = mask;
#;                                                                        ^
            616000    0x80003d0c and a4, a4, s0                 #; a4  = 0, s0  = -1, (wrb) a4  <-- 0
            617000    0x80003d10 sw a4, 0(a3)                   #; a3  = 0x100211ac, 0 ~~> Word[0x100211ac]
            618000    0x80003d14 sw a1, 0(a2)                   #; a2  = 0x100211a8, 128 ~~> Word[0x100211a8]
            619000    0x80003d18 lui a1, 128                    #; (wrb) a1  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            620000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            621000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            622000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            623000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            624000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            625000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            626000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            627000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            628000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            629000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            630000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            631000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            632000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            633000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            634000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            635000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            636000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            637000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            638000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            639000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            640000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            641000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            642000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            643000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            644000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            645000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            646000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            647000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            648000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            649000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            650000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            651000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            652000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            653000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            654000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            655000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            656000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            657000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            658000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            659000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            660000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            661000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            662000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            663000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            664000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            665000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            666000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            667000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            668000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            669000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            670000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            671000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            672000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            673000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            674000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            675000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            676000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            677000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            678000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            679000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            680000    0x80003d1c csrr a2, mip                   #; mip = 0, (wrb) a2  <-- 0
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            681000    0x80003d20 and a2, a2, a1                 #; a2  = 0, a1  = 0x00080000, (wrb) a2  <-- 0
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            682000    0x80003d24 bnez a2, -8                    #; a2  = 0, not taken
            683000    0x80003d28 li a1, 9                       #; (wrb) a1  <-- 9
#; .LBB25_2 (start.c:215:5)
#;   snrt_init_bss (start.c:110:9)
#;     if (snrt_cluster_idx() == 0) {
#;         ^
            684000    0x80003d2c bgeu s2, a1, 88                #; s2  = 7, a1  = 9, not taken
#; .LBB25_21 (start.c:215:5)
#;   snrt_init_bss (start.c:112:9)
#;     memset((void*)&__bss_start, 0, size);
#;     ^
            685000    0x80003d30 auipc a0, 2                    #; (wrb) a0  <-- 0x80005d30
            686000    0x80003d34 addi a0, a0, 312               #; a0  = 0x80005d30, (wrb) a0  <-- 0x80005e68
#; .LBB25_22 (start.c:215:5)
#;   snrt_init_bss (start.c:112:9)
#;     memset((void*)&__bss_start, 0, size);
#;     ^
            687000    0x80003d38 auipc a1, 2                    #; (wrb) a1  <-- 0x80005d38
            688000    0x80003d3c addi a1, a1, 360               #; a1  = 0x80005d38, (wrb) a1  <-- 0x80005ea0
            694000    0x80003d40 sub a2, a1, a0                 #; a1  = 0x80005ea0, a0  = 0x80005e68, (wrb) a2  <-- 56
            695000    0x80003d44 li a1, 0                       #; (wrb) a1  <-- 0
            696000    0x80003d48 auipc ra, 0                    #; (wrb) ra  <-- 0x80003d48
            697000    0x80003d4c jalr 1220(ra)                  #; ra  = 0x80003d48, (wrb) ra  <-- 0x80003d50, goto 0x8000420c
#; memset (memset.S:30)
#;   li t1, 15
            716000    0x8000420c li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
            717000    0x80004210 mv a4, a0                      #; a0  = 0x80005e68, (wrb) a4  <-- 0x80005e68
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
            718000    0x80004214 bgeu t1, a2, 60                #; t1  = 15, a2  = 56, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
            719000    0x80004218 andi a5, a4, 15                #; a4  = 0x80005e68, (wrb) a5  <-- 8
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
            720000    0x8000421c bnez a5, 160                   #; a5  = 8, taken, goto 0x800042bc
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
            742000    0x800042bc slli a3, a5, 2                 #; a5  = 8, (wrb) a3  <-- 32
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
            773000    0x80004288 sb a1, 5(a4)                   #; a4  = 0x80005e68, 0 ~~> Byte[0x80005e6d]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
            822000    0x8000428c sb a1, 4(a4)                   #; a4  = 0x80005e68, 0 ~~> Byte[0x80005e6c]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
            863000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x80005e68, 0 ~~> Byte[0x80005e6b]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
            912000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x80005e68, 0 ~~> Byte[0x80005e6a]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
            953000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x80005e68, 0 ~~> Byte[0x80005e69]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           1002000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x80005e68, 0 ~~> Byte[0x80005e68]
#; .Ltable (memset.S:85)
#;   ret
           1003000    0x800042a0 ret                            #; ra  = 0x800042d0, goto 0x800042d0
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           1004000    0x800042d0 mv ra, t0                      #; t0  = 0x80003d50, (wrb) ra  <-- 0x80003d50
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           1005000    0x800042d4 addi a5, a5, -16               #; a5  = 8, (wrb) a5  <-- -8
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           1006000    0x800042d8 sub a4, a4, a5                 #; a4  = 0x80005e68, a5  = -8, (wrb) a4  <-- 0x80005e70
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           1007000    0x800042dc add a2, a2, a5                 #; a2  = 56, a5  = -8, (wrb) a2  <-- 48
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           1008000    0x800042e0 bgeu t1, a2, -144              #; t1  = 15, a2  = 48, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           1009000    0x800042e4 j -196                         #; goto 0x80004220
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           1010000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           1011000    0x80004224 andi a3, a2, -16               #; a2  = 48, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           1012000    0x80004228 andi a2, a2, 15                #; a2  = 48, (wrb) a2  <-- 0
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           1013000    0x8000422c add a3, a3, a4                 #; a3  = 48, a4  = 0x80005e70, (wrb) a3  <-- 0x80005ea0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           1043000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x80005e70, 0 ~~> Word[0x80005e70]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           1092000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x80005e70, 0 ~~> Word[0x80005e74]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           1133000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x80005e70, 0 ~~> Word[0x80005e78]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           1182000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x80005e70, 0 ~~> Word[0x80005e7c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           1183000    0x80004240 addi a4, a4, 16                #; a4  = 0x80005e70, (wrb) a4  <-- 0x80005e80
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           1184000    0x80004244 bltu a4, a3, -20               #; a4  = 0x80005e80, a3  = 0x80005ea0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           1223000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x80005e80, 0 ~~> Word[0x80005e80]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           1272000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x80005e80, 0 ~~> Word[0x80005e84]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           1313000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x80005e80, 0 ~~> Word[0x80005e88]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           1362000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x80005e80, 0 ~~> Word[0x80005e8c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           1363000    0x80004240 addi a4, a4, 16                #; a4  = 0x80005e80, (wrb) a4  <-- 0x80005e90
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           1364000    0x80004244 bltu a4, a3, -20               #; a4  = 0x80005e90, a3  = 0x80005ea0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           1403000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x80005e90, 0 ~~> Word[0x80005e90]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           1452000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x80005e90, 0 ~~> Word[0x80005e94]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           1493000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x80005e90, 0 ~~> Word[0x80005e98]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           1542000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x80005e90, 0 ~~> Word[0x80005e9c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           1543000    0x80004240 addi a4, a4, 16                #; a4  = 0x80005e90, (wrb) a4  <-- 0x80005ea0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           1544000    0x80004244 bltu a4, a3, -20               #; a4  = 0x80005ea0, a3  = 0x80005ea0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           1545000    0x80004248 bnez a2, 8                     #; a2  = 0, not taken
#; .Ltmp0 (memset.S:57)
#;   ret
           1546000    0x8000424c ret                            #; ra  = 0x80003d50, goto 0x80003d50
#; .LBB25_22 (start.c:215:5)
#;   snrt_init_bss (start.c:115:9)
#;     snrt_cluster_hw_barrier (sync.h:174:5)
#;       asm volatile("csrr x0, 0x7C2" ::: "memory");
#;       ^
           1547000    0x80003d50 csrr zero, 1986                #; csr@7c2 = 0
           1579000    0x80003d54 li a0, 57                      #; (wrb) a0  <-- 57
           1580000    0x80003d58 mul a0, s1, a0                 #; s1  = 7, a0  = 57
           1582000                                              #; (acc) a0  <-- 399
           1583000    0x80003d5c srli a0, a0, 9                 #; a0  = 399, (wrb) a0  <-- 0
           1584000    0x80003d60 slli a1, a0, 3                 #; a0  = 0, (wrb) a1  <-- 0
           1585000    0x80003d64 add a0, a1, a0                 #; a1  = 0, a0  = 0, (wrb) a0  <-- 0
           1586000    0x80003d68 sub a0, s2, a0                 #; s2  = 7, a0  = 0, (wrb) a0  <-- 7
           1587000    0x80003d6c .text                          #; a0  = 7
           1588000    0x80003d70 li s4, 0                       #; (wrb) s4  <-- 0
           1589000                                              #; (acc) s5  <-- 7
#; .LBB25_22 (start.c:219:5)
#;   snrt_wake_up (start.c:124:33)
#;     if (snrt_cluster_idx() == 0 && snrt_cluster_core_idx() == 0) {
#;                                 ^
           1590000    0x80003d74 bnez s5, 32                    #; s5  = 7, taken, goto 0x80003d94
#; .LBB25_7 (start.c:219:5)
#;   snrt_wake_up (start.c:137:5)
#;     snrt_cluster_hw_barrier (sync.h:174:5)
#;       asm volatile("csrr x0, 0x7C2" ::: "memory");
#;       ^
           1591000    0x80003d94 csrr zero, 1986                #; csr@7c2 = 0
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
           1673000                                              #; (lsu) a1  <-- 0
           1674000    0x80003da8 ori a1, a0, 4                  #; a0  = 0x100211a8, (wrb) a1  <-- 0x100211ac
           1675000    0x80003dac lw a2, 0(a1)                   #; a1  = 0x100211ac, a2  <~~ Word[0x100211ac]
           1676000    0x80003db0 li a3, 1                       #; (wrb) a3  <-- 1
#; .LBB25_7 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;       snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:28)
#;         snrt_int_cluster_clr(1 << snrt_cluster_core_idx());
#;                                ^
           1677000    0x80003db4 sll a3, a3, s5                 #; a3  = 1, s5  = 7, (wrb) a3  <-- 128
           1699000                                              #; (lsu) a2  <-- 0
#; .LBB25_7 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;       snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:5)
#;         snrt_int_cluster_clr (cluster_interrupts.h:22:68)
#;           snrt_cluster()->peripheral_reg.cl_clint_clear.f.cl_clint_clear = mask;
#;                                                                          ^
           1700000    0x80003db8 and a2, a2, s0                 #; a2  = 0, s0  = -1, (wrb) a2  <-- 0
           1701000    0x80003dbc sw a3, 0(a0)                   #; a0  = 0x100211a8, 128 ~~> Word[0x100211a8]
           1702000    0x80003dc0 sw a2, 0(a1)                   #; a1  = 0x100211ac, 0 ~~> Word[0x100211ac]
           1703000    0x80003dc4 lui a0, 128                    #; (wrb) a0  <-- 0x00080000
#; .LBB25_8 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;       snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;         while (read_csr(mip) & MIP_MCIP)
#;                ^
           1704000    0x80003dc8 csrr a1, mip                   #; mip = 0, (wrb) a1  <-- 0
#; .LBB25_8 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;       snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;         while (read_csr(mip) & MIP_MCIP)
#;                              ^
           1705000    0x80003dcc and a1, a1, a0                 #; a1  = 0, a0  = 0x00080000, (wrb) a1  <-- 0
#; .LBB25_8 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;       snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;         while (read_csr(mip) & MIP_MCIP)
#;         ^
           1706000    0x80003dd0 bnez a1, -8                    #; a1  = 0, not taken
#; .LBB25_8 (start.c:227:5)
#;   snrt_init_tls (start.c:66:5)
#;     asm volatile("mv %0, tp" : "=r"(tls_ptr) : :);
#;     ^
           1707000    0x80003dd4 mv a0, tp                      #; tp  = 0x1001e350, (wrb) a0  <-- 0x1001e350
           1724000    0x80003dd8 sw a0, 8(sp)                   #; sp  = 0x1001e310, 0x1001e350 ~~> Word[0x1001e318]
#; .LBB25_8 (start.c:227:5)
#;   snrt_init_tls (start.c:67:19)
#;     memcpy((void*)tls_ptr, (const void*)&__tdata_start, size);
#;                   ^
           1754000    0x80003ddc lw a0, 8(sp)                   #; sp  = 0x1001e310, a0  <~~ Word[0x1001e318]
#; .LBB25_23 (start.c:227:5)
#;   snrt_init_tls (start.c:67:5)
#;     memcpy((void*)tls_ptr, (const void*)&__tdata_start, size);
#;     ^
           1755000    0x80003de0 auipc a1, 2                    #; (wrb) a1  <-- 0x80005de0
           1756000    0x80003de4 addi a1, a1, -152              #; a1  = 0x80005de0, (wrb) a1  <-- 0x80005d48
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:67:5)
#;     memcpy((void*)tls_ptr, (const void*)&__tdata_start, size);
#;     ^
           1757000    0x80003de8 auipc a2, 2                    #; (wrb) a2  <-- 0x80005de8
           1758000    0x80003dec addi a2, a2, -148              #; a2  = 0x80005de8, (wrb) a2  <-- 0x80005d54
           1759000    0x80003df0 sub s0, a2, a1                 #; a2  = 0x80005d54, a1  = 0x80005d48, (wrb) s0  <-- 12
           1760000    0x80003df4 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
           1761000    0x80003df8 auipc ra, 2                    #; (wrb) ra  <-- 0x80005df8
           1762000    0x80003dfc jalr -2028(ra)                 #; ra  = 0x80005df8, (wrb) ra  <-- 0x80003e00, goto 0x8000560c
           1763000                                              #; (lsu) a0  <-- 0x1001e350
#; memcpy (memcpy.c:25)
#;   {
           1766000    0x8000560c addi sp, sp, -16               #; sp  = 0x1001e310, (wrb) sp  <-- 0x1001e300
           1767000    0x80005610 sw s0, 12(sp)                  #; sp  = 0x1001e300, 12 ~~> Word[0x1001e30c]
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           1768000    0x80005614 andi a3, a0, 3                 #; a0  = 0x1001e350, (wrb) a3  <-- 0
           1769000    0x80005618 andi a4, a1, 3                 #; a1  = 0x80005d48, (wrb) a4  <-- 0
           1770000    0x8000561c xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
           1771000    0x80005620 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
           1772000    0x80005624 li a5, 3                       #; (wrb) a5  <-- 3
           1773000    0x80005628 sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
           1774000    0x8000562c and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
           1775000    0x80005630 add a2, a0, a2                 #; a0  = 0x1001e350, a2  = 12, (wrb) a2  <-- 0x1001e35c
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           1776000    0x80005634 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
           1777000    0x80005638 bnez a3, 116                   #; a3  = 0, not taken
           1778000    0x8000563c mv a4, a0                      #; a0  = 0x1001e350, (wrb) a4  <-- 0x1001e350
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
           1779000    0x80005640 andi a3, a2, -4                #; a2  = 0x1001e35c, (wrb) a3  <-- 0x1001e35c
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
           1780000    0x80005644 sub a5, a3, a4                 #; a3  = 0x1001e35c, a4  = 0x1001e350, (wrb) a5  <-- 12
           1781000    0x80005648 li a6, 33                      #; (wrb) a6  <-- 33
           1782000    0x8000564c bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1783000    0x80005650 bgeu a4, a3, 32                #; a4  = 0x1001e350, a3  = 0x1001e35c, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           1784000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x80005d48, a6  <~~ Word[0x80005d48]
           1785000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001e350, (wrb) a5  <-- 0x1001e354
           1786000    0x8000565c addi a1, a1, 4                 #; a1  = 0x80005d48, (wrb) a1  <-- 0x80005d4c
           1795000                                              #; (lsu) a6  <-- 0x80005e80
           1796000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001e350, 0x80005e80 ~~> Word[0x1001e350]
           1797000    0x80005664 mv a4, a5                      #; a5  = 0x1001e354, (wrb) a4  <-- 0x1001e354
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1798000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001e354, a3  = 0x1001e35c, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           1799000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x80005d4c, a6  <~~ Word[0x80005d4c]
           1800000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001e354, (wrb) a5  <-- 0x1001e358
           1801000    0x8000565c addi a1, a1, 4                 #; a1  = 0x80005d4c, (wrb) a1  <-- 0x80005d50
           1840000                                              #; (lsu) a6  <-- 1
           1841000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001e354, 1 ~~> Word[0x1001e354]
           1842000    0x80005664 mv a4, a5                      #; a5  = 0x1001e358, (wrb) a4  <-- 0x1001e358
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1843000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001e358, a3  = 0x1001e35c, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           1844000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x80005d50, a6  <~~ Word[0x80005d50]
           1845000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001e358, (wrb) a5  <-- 0x1001e35c
           1846000    0x8000565c addi a1, a1, 4                 #; a1  = 0x80005d50, (wrb) a1  <-- 0x80005d54
           1884000                                              #; (lsu) a6  <-- 1
           1885000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001e358, 1 ~~> Word[0x1001e358]
           1886000    0x80005664 mv a4, a5                      #; a5  = 0x1001e35c, (wrb) a4  <-- 0x1001e35c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1887000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001e35c, a3  = 0x1001e35c, not taken
           1888000    0x8000566c j 8                            #; goto 0x80005674
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
           1889000    0x80005674 bltu a5, a2, 20                #; a5  = 0x1001e35c, a2  = 0x1001e35c, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
           1890000    0x80005678 lw s0, 12(sp)                  #; sp  = 0x1001e300, s0  <~~ Word[0x1001e30c]
           1891000    0x8000567c addi sp, sp, 16                #; sp  = 0x1001e300, (wrb) sp  <-- 0x1001e310
           1893000    0x80005680 ret                            #; ra  = 0x80003e00, (lsu) s0  <-- 12, goto 0x80003e00
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
           1894000    0x80003e00 lw a0, 8(sp)                   #; sp  = 0x1001e310, a0  <~~ Word[0x1001e318]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
           1895000    0x80003e04 lw a1, 8(sp)                   #; sp  = 0x1001e310, a1  <~~ Word[0x1001e318]
           1897000                                              #; (lsu) a0  <-- 0x1001e350
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
           1898000    0x80003e08 addi a0, a0, 1032              #; a0  = 0x1001e350, (wrb) a0  <-- 0x1001e758
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
           1899000    0x80003e0c mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
           1900000    0x80003e10 auipc ra, 1                    #; (wrb) ra  <-- 0x80004e10
           1901000    0x80003e14 jalr 2044(ra)                  #; ra  = 0x80004e10, (wrb) ra  <-- 0x80003e18, goto 0x8000560c
#; memcpy (memcpy.c:25)
#;   {
           1902000    0x8000560c addi sp, sp, -16               #; sp  = 0x1001e310, (wrb) sp  <-- 0x1001e300
           1903000    0x80005610 sw s0, 12(sp)                  #; sp  = 0x1001e300, 12 ~~> Word[0x1001e30c], (lsu) a1  <-- 0x1001e350
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           1904000    0x80005614 andi a3, a0, 3                 #; a0  = 0x1001e758, (wrb) a3  <-- 0
           1905000    0x80005618 andi a4, a1, 3                 #; a1  = 0x1001e350, (wrb) a4  <-- 0
           1906000    0x8000561c xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
           1907000    0x80005620 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
           1908000    0x80005624 li a5, 3                       #; (wrb) a5  <-- 3
           1909000    0x80005628 sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
           1910000    0x8000562c and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
           1911000    0x80005630 add a2, a0, a2                 #; a0  = 0x1001e758, a2  = 12, (wrb) a2  <-- 0x1001e764
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           1912000    0x80005634 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
           1913000    0x80005638 bnez a3, 116                   #; a3  = 0, not taken
           1914000    0x8000563c mv a4, a0                      #; a0  = 0x1001e758, (wrb) a4  <-- 0x1001e758
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
           1915000    0x80005640 andi a3, a2, -4                #; a2  = 0x1001e764, (wrb) a3  <-- 0x1001e764
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
           1916000    0x80005644 sub a5, a3, a4                 #; a3  = 0x1001e764, a4  = 0x1001e758, (wrb) a5  <-- 12
           1917000    0x80005648 li a6, 33                      #; (wrb) a6  <-- 33
           1918000    0x8000564c bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1919000    0x80005650 bgeu a4, a3, 32                #; a4  = 0x1001e758, a3  = 0x1001e764, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           1920000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001e350, a6  <~~ Word[0x1001e350]
           1921000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001e758, (wrb) a5  <-- 0x1001e75c
           1922000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001e350, (wrb) a1  <-- 0x1001e354
           1923000                                              #; (lsu) a6  <-- 0x80005e80
           1924000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001e758, 0x80005e80 ~~> Word[0x1001e758]
           1925000    0x80005664 mv a4, a5                      #; a5  = 0x1001e75c, (wrb) a4  <-- 0x1001e75c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1926000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001e75c, a3  = 0x1001e764, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           1927000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001e354, a6  <~~ Word[0x1001e354]
           1928000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001e75c, (wrb) a5  <-- 0x1001e760
           1929000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001e354, (wrb) a1  <-- 0x1001e358
           1930000                                              #; (lsu) a6  <-- 1
           1931000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001e75c, 1 ~~> Word[0x1001e75c]
           1932000    0x80005664 mv a4, a5                      #; a5  = 0x1001e760, (wrb) a4  <-- 0x1001e760
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1933000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001e760, a3  = 0x1001e764, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           1934000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001e358, a6  <~~ Word[0x1001e358]
           1935000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001e760, (wrb) a5  <-- 0x1001e764
           1936000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001e358, (wrb) a1  <-- 0x1001e35c
           1937000                                              #; (lsu) a6  <-- 1
           1938000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001e760, 1 ~~> Word[0x1001e760]
           1939000    0x80005664 mv a4, a5                      #; a5  = 0x1001e764, (wrb) a4  <-- 0x1001e764
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1940000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001e764, a3  = 0x1001e764, not taken
           1941000    0x8000566c j 8                            #; goto 0x80005674
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
           1942000    0x80005674 bltu a5, a2, 20                #; a5  = 0x1001e764, a2  = 0x1001e764, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
           1943000    0x80005678 lw s0, 12(sp)                  #; sp  = 0x1001e300, s0  <~~ Word[0x1001e30c]
           1944000    0x8000567c addi sp, sp, 16                #; sp  = 0x1001e300, (wrb) sp  <-- 0x1001e310
           1945000    0x80005680 ret                            #; ra  = 0x80003e18, goto 0x80003e18
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
           1946000    0x80003e18 lw a0, 8(sp)                   #; sp  = 0x1001e310, a0  <~~ Word[0x1001e318], (lsu) s0  <-- 12
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
           1947000    0x80003e1c lw a1, 8(sp)                   #; sp  = 0x1001e310, a1  <~~ Word[0x1001e318]
           1948000    0x80003e20 lui s7, 1                      #; (wrb) s7  <-- 4096
           1949000    0x80003e24 addi s1, s7, -2032             #; s7  = 4096, (wrb) s1  <-- 2064
           1950000                                              #; (lsu) a0  <-- 0x1001e350
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
           1951000    0x80003e28 add a0, a0, s1                 #; a0  = 0x1001e350, s1  = 2064, (wrb) a0  <-- 0x1001eb60
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
           1952000    0x80003e2c mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
           1953000    0x80003e30 auipc ra, 1                    #; (wrb) ra  <-- 0x80004e30
           1954000    0x80003e34 jalr 2012(ra)                  #; ra  = 0x80004e30, (wrb) ra  <-- 0x80003e38, goto 0x8000560c
#; memcpy (memcpy.c:25)
#;   {
           1955000    0x8000560c addi sp, sp, -16               #; sp  = 0x1001e310, (wrb) sp  <-- 0x1001e300
           1956000    0x80005610 sw s0, 12(sp)                  #; sp  = 0x1001e300, 12 ~~> Word[0x1001e30c], (lsu) a1  <-- 0x1001e350
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           1957000    0x80005614 andi a3, a0, 3                 #; a0  = 0x1001eb60, (wrb) a3  <-- 0
           1958000    0x80005618 andi a4, a1, 3                 #; a1  = 0x1001e350, (wrb) a4  <-- 0
           1959000    0x8000561c xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
           1960000    0x80005620 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
           1961000    0x80005624 li a5, 3                       #; (wrb) a5  <-- 3
           1962000    0x80005628 sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
           1963000    0x8000562c and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
           1964000    0x80005630 add a2, a0, a2                 #; a0  = 0x1001eb60, a2  = 12, (wrb) a2  <-- 0x1001eb6c
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           1965000    0x80005634 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
           1966000    0x80005638 bnez a3, 116                   #; a3  = 0, not taken
           1967000    0x8000563c mv a4, a0                      #; a0  = 0x1001eb60, (wrb) a4  <-- 0x1001eb60
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
           1968000    0x80005640 andi a3, a2, -4                #; a2  = 0x1001eb6c, (wrb) a3  <-- 0x1001eb6c
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
           1969000    0x80005644 sub a5, a3, a4                 #; a3  = 0x1001eb6c, a4  = 0x1001eb60, (wrb) a5  <-- 12
           1970000    0x80005648 li a6, 33                      #; (wrb) a6  <-- 33
           1971000    0x8000564c bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1972000    0x80005650 bgeu a4, a3, 32                #; a4  = 0x1001eb60, a3  = 0x1001eb6c, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           1973000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001e350, a6  <~~ Word[0x1001e350]
           1974000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001eb60, (wrb) a5  <-- 0x1001eb64
           1975000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001e350, (wrb) a1  <-- 0x1001e354
           1976000                                              #; (lsu) a6  <-- 0x80005e80
           1977000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001eb60, 0x80005e80 ~~> Word[0x1001eb60]
           1978000    0x80005664 mv a4, a5                      #; a5  = 0x1001eb64, (wrb) a4  <-- 0x1001eb64
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1979000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001eb64, a3  = 0x1001eb6c, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           1980000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001e354, a6  <~~ Word[0x1001e354]
           1981000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001eb64, (wrb) a5  <-- 0x1001eb68
           1982000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001e354, (wrb) a1  <-- 0x1001e358
           1983000                                              #; (lsu) a6  <-- 1
           1984000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001eb64, 1 ~~> Word[0x1001eb64]
           1985000    0x80005664 mv a4, a5                      #; a5  = 0x1001eb68, (wrb) a4  <-- 0x1001eb68
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1986000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001eb68, a3  = 0x1001eb6c, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           1987000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001e358, a6  <~~ Word[0x1001e358]
           1988000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001eb68, (wrb) a5  <-- 0x1001eb6c
           1989000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001e358, (wrb) a1  <-- 0x1001e35c
           1990000                                              #; (lsu) a6  <-- 1
           1991000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001eb68, 1 ~~> Word[0x1001eb68]
           1992000    0x80005664 mv a4, a5                      #; a5  = 0x1001eb6c, (wrb) a4  <-- 0x1001eb6c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1993000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001eb6c, a3  = 0x1001eb6c, not taken
           1994000    0x8000566c j 8                            #; goto 0x80005674
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
           1995000    0x80005674 bltu a5, a2, 20                #; a5  = 0x1001eb6c, a2  = 0x1001eb6c, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
           1996000    0x80005678 lw s0, 12(sp)                  #; sp  = 0x1001e300, s0  <~~ Word[0x1001e30c]
           1997000    0x8000567c addi sp, sp, 16                #; sp  = 0x1001e300, (wrb) sp  <-- 0x1001e310
           1998000    0x80005680 ret                            #; ra  = 0x80003e38, goto 0x80003e38
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
           1999000    0x80003e38 lw a0, 8(sp)                   #; sp  = 0x1001e310, a0  <~~ Word[0x1001e318], (lsu) s0  <-- 12
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
           2000000    0x80003e3c lw a1, 8(sp)                   #; sp  = 0x1001e310, a1  <~~ Word[0x1001e318]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
           2001000    0x80003e40 ori s6, s1, 1032               #; s1  = 2064, (wrb) s6  <-- 3096
           2002000                                              #; (lsu) a0  <-- 0x1001e350
           2003000    0x80003e44 add a0, a0, s6                 #; a0  = 0x1001e350, s6  = 3096, (wrb) a0  <-- 0x1001ef68
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
           2004000    0x80003e48 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
           2005000    0x80003e4c auipc ra, 1                    #; (wrb) ra  <-- 0x80004e4c
           2006000    0x80003e50 jalr 1984(ra)                  #; ra  = 0x80004e4c, (wrb) ra  <-- 0x80003e54, goto 0x8000560c
#; memcpy (memcpy.c:25)
#;   {
           2007000    0x8000560c addi sp, sp, -16               #; sp  = 0x1001e310, (wrb) sp  <-- 0x1001e300
           2008000    0x80005610 sw s0, 12(sp)                  #; sp  = 0x1001e300, 12 ~~> Word[0x1001e30c], (lsu) a1  <-- 0x1001e350
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2009000    0x80005614 andi a3, a0, 3                 #; a0  = 0x1001ef68, (wrb) a3  <-- 0
           2010000    0x80005618 andi a4, a1, 3                 #; a1  = 0x1001e350, (wrb) a4  <-- 0
           2011000    0x8000561c xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
           2012000    0x80005620 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
           2013000    0x80005624 li a5, 3                       #; (wrb) a5  <-- 3
           2014000    0x80005628 sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
           2015000    0x8000562c and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
           2016000    0x80005630 add a2, a0, a2                 #; a0  = 0x1001ef68, a2  = 12, (wrb) a2  <-- 0x1001ef74
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2017000    0x80005634 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
           2018000    0x80005638 bnez a3, 116                   #; a3  = 0, not taken
           2019000    0x8000563c mv a4, a0                      #; a0  = 0x1001ef68, (wrb) a4  <-- 0x1001ef68
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
           2020000    0x80005640 andi a3, a2, -4                #; a2  = 0x1001ef74, (wrb) a3  <-- 0x1001ef74
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
           2021000    0x80005644 sub a5, a3, a4                 #; a3  = 0x1001ef74, a4  = 0x1001ef68, (wrb) a5  <-- 12
           2022000    0x80005648 li a6, 33                      #; (wrb) a6  <-- 33
           2023000    0x8000564c bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2024000    0x80005650 bgeu a4, a3, 32                #; a4  = 0x1001ef68, a3  = 0x1001ef74, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2025000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001e350, a6  <~~ Word[0x1001e350]
           2026000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001ef68, (wrb) a5  <-- 0x1001ef6c
           2027000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001e350, (wrb) a1  <-- 0x1001e354
           2028000                                              #; (lsu) a6  <-- 0x80005e80
           2029000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001ef68, 0x80005e80 ~~> Word[0x1001ef68]
           2030000    0x80005664 mv a4, a5                      #; a5  = 0x1001ef6c, (wrb) a4  <-- 0x1001ef6c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2031000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001ef6c, a3  = 0x1001ef74, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2032000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001e354, a6  <~~ Word[0x1001e354]
           2033000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001ef6c, (wrb) a5  <-- 0x1001ef70
           2034000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001e354, (wrb) a1  <-- 0x1001e358
           2035000                                              #; (lsu) a6  <-- 1
           2036000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001ef6c, 1 ~~> Word[0x1001ef6c]
           2037000    0x80005664 mv a4, a5                      #; a5  = 0x1001ef70, (wrb) a4  <-- 0x1001ef70
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2038000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001ef70, a3  = 0x1001ef74, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2039000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001e358, a6  <~~ Word[0x1001e358]
           2040000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001ef70, (wrb) a5  <-- 0x1001ef74
           2041000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001e358, (wrb) a1  <-- 0x1001e35c
           2042000                                              #; (lsu) a6  <-- 1
           2043000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001ef70, 1 ~~> Word[0x1001ef70]
           2044000    0x80005664 mv a4, a5                      #; a5  = 0x1001ef74, (wrb) a4  <-- 0x1001ef74
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2045000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001ef74, a3  = 0x1001ef74, not taken
           2046000    0x8000566c j 8                            #; goto 0x80005674
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
           2047000    0x80005674 bltu a5, a2, 20                #; a5  = 0x1001ef74, a2  = 0x1001ef74, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
           2048000    0x80005678 lw s0, 12(sp)                  #; sp  = 0x1001e300, s0  <~~ Word[0x1001e30c]
           2049000    0x8000567c addi sp, sp, 16                #; sp  = 0x1001e300, (wrb) sp  <-- 0x1001e310
           2050000    0x80005680 ret                            #; ra  = 0x80003e54, goto 0x80003e54
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
           2051000    0x80003e54 lw a0, 8(sp)                   #; sp  = 0x1001e310, a0  <~~ Word[0x1001e318], (lsu) s0  <-- 12
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
           2052000    0x80003e58 lw a1, 8(sp)                   #; sp  = 0x1001e310, a1  <~~ Word[0x1001e318]
           2053000    0x80003e5c addi s7, s7, 32                #; s7  = 4096, (wrb) s7  <-- 4128
           2054000                                              #; (lsu) a0  <-- 0x1001e350
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
           2055000    0x80003e60 add a0, a0, s7                 #; a0  = 0x1001e350, s7  = 4128, (wrb) a0  <-- 0x1001f370
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
           2056000    0x80003e64 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
           2057000    0x80003e68 auipc ra, 1                    #; (wrb) ra  <-- 0x80004e68
           2058000    0x80003e6c jalr 1956(ra)                  #; ra  = 0x80004e68, (wrb) ra  <-- 0x80003e70, goto 0x8000560c
#; memcpy (memcpy.c:25)
#;   {
           2059000    0x8000560c addi sp, sp, -16               #; sp  = 0x1001e310, (wrb) sp  <-- 0x1001e300
           2060000    0x80005610 sw s0, 12(sp)                  #; sp  = 0x1001e300, 12 ~~> Word[0x1001e30c], (lsu) a1  <-- 0x1001e350
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2061000    0x80005614 andi a3, a0, 3                 #; a0  = 0x1001f370, (wrb) a3  <-- 0
           2062000    0x80005618 andi a4, a1, 3                 #; a1  = 0x1001e350, (wrb) a4  <-- 0
           2063000    0x8000561c xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
           2064000    0x80005620 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
           2065000    0x80005624 li a5, 3                       #; (wrb) a5  <-- 3
           2066000    0x80005628 sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
           2067000    0x8000562c and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
           2068000    0x80005630 add a2, a0, a2                 #; a0  = 0x1001f370, a2  = 12, (wrb) a2  <-- 0x1001f37c
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2069000    0x80005634 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
           2070000    0x80005638 bnez a3, 116                   #; a3  = 0, not taken
           2071000    0x8000563c mv a4, a0                      #; a0  = 0x1001f370, (wrb) a4  <-- 0x1001f370
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
           2072000    0x80005640 andi a3, a2, -4                #; a2  = 0x1001f37c, (wrb) a3  <-- 0x1001f37c
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
           2073000    0x80005644 sub a5, a3, a4                 #; a3  = 0x1001f37c, a4  = 0x1001f370, (wrb) a5  <-- 12
           2074000    0x80005648 li a6, 33                      #; (wrb) a6  <-- 33
           2075000    0x8000564c bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2076000    0x80005650 bgeu a4, a3, 32                #; a4  = 0x1001f370, a3  = 0x1001f37c, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2077000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001e350, a6  <~~ Word[0x1001e350]
           2078000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001f370, (wrb) a5  <-- 0x1001f374
           2079000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001e350, (wrb) a1  <-- 0x1001e354
           2080000                                              #; (lsu) a6  <-- 0x80005e80
           2081000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001f370, 0x80005e80 ~~> Word[0x1001f370]
           2082000    0x80005664 mv a4, a5                      #; a5  = 0x1001f374, (wrb) a4  <-- 0x1001f374
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2083000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001f374, a3  = 0x1001f37c, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2084000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001e354, a6  <~~ Word[0x1001e354]
           2085000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001f374, (wrb) a5  <-- 0x1001f378
           2086000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001e354, (wrb) a1  <-- 0x1001e358
           2087000                                              #; (lsu) a6  <-- 1
           2088000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001f374, 1 ~~> Word[0x1001f374]
           2089000    0x80005664 mv a4, a5                      #; a5  = 0x1001f378, (wrb) a4  <-- 0x1001f378
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2090000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001f378, a3  = 0x1001f37c, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2091000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001e358, a6  <~~ Word[0x1001e358]
           2092000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001f378, (wrb) a5  <-- 0x1001f37c
           2093000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001e358, (wrb) a1  <-- 0x1001e35c
           2094000                                              #; (lsu) a6  <-- 1
           2095000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001f378, 1 ~~> Word[0x1001f378]
           2096000    0x80005664 mv a4, a5                      #; a5  = 0x1001f37c, (wrb) a4  <-- 0x1001f37c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2097000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001f37c, a3  = 0x1001f37c, not taken
           2098000    0x8000566c j 8                            #; goto 0x80005674
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
           2099000    0x80005674 bltu a5, a2, 20                #; a5  = 0x1001f37c, a2  = 0x1001f37c, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
           2100000    0x80005678 lw s0, 12(sp)                  #; sp  = 0x1001e300, s0  <~~ Word[0x1001e30c]
           2101000    0x8000567c addi sp, sp, 16                #; sp  = 0x1001e300, (wrb) sp  <-- 0x1001e310
           2102000    0x80005680 ret                            #; ra  = 0x80003e70, goto 0x80003e70
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
           2103000    0x80003e70 lw a0, 8(sp)                   #; sp  = 0x1001e310, a0  <~~ Word[0x1001e318], (lsu) s0  <-- 12
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
           2104000    0x80003e74 lw a1, 8(sp)                   #; sp  = 0x1001e310, a1  <~~ Word[0x1001e318]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
           2105000    0x80003e78 ori s8, s7, 1032               #; s7  = 4128, (wrb) s8  <-- 5160
           2106000                                              #; (lsu) a0  <-- 0x1001e350
           2107000    0x80003e7c add a0, a0, s8                 #; a0  = 0x1001e350, s8  = 5160, (wrb) a0  <-- 0x1001f778
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
           2108000    0x80003e80 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
           2109000    0x80003e84 auipc ra, 1                    #; (wrb) ra  <-- 0x80004e84
           2110000    0x80003e88 jalr 1928(ra)                  #; ra  = 0x80004e84, (wrb) ra  <-- 0x80003e8c, goto 0x8000560c
#; memcpy (memcpy.c:25)
#;   {
           2111000    0x8000560c addi sp, sp, -16               #; sp  = 0x1001e310, (wrb) sp  <-- 0x1001e300
           2112000    0x80005610 sw s0, 12(sp)                  #; sp  = 0x1001e300, 12 ~~> Word[0x1001e30c], (lsu) a1  <-- 0x1001e350
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2113000    0x80005614 andi a3, a0, 3                 #; a0  = 0x1001f778, (wrb) a3  <-- 0
           2114000    0x80005618 andi a4, a1, 3                 #; a1  = 0x1001e350, (wrb) a4  <-- 0
           2115000    0x8000561c xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
           2116000    0x80005620 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
           2117000    0x80005624 li a5, 3                       #; (wrb) a5  <-- 3
           2118000    0x80005628 sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
           2119000    0x8000562c and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
           2120000    0x80005630 add a2, a0, a2                 #; a0  = 0x1001f778, a2  = 12, (wrb) a2  <-- 0x1001f784
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2121000    0x80005634 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
           2122000    0x80005638 bnez a3, 116                   #; a3  = 0, not taken
           2123000    0x8000563c mv a4, a0                      #; a0  = 0x1001f778, (wrb) a4  <-- 0x1001f778
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
           2124000    0x80005640 andi a3, a2, -4                #; a2  = 0x1001f784, (wrb) a3  <-- 0x1001f784
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
           2125000    0x80005644 sub a5, a3, a4                 #; a3  = 0x1001f784, a4  = 0x1001f778, (wrb) a5  <-- 12
           2126000    0x80005648 li a6, 33                      #; (wrb) a6  <-- 33
           2127000    0x8000564c bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2128000    0x80005650 bgeu a4, a3, 32                #; a4  = 0x1001f778, a3  = 0x1001f784, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2129000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001e350, a6  <~~ Word[0x1001e350]
           2130000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001f778, (wrb) a5  <-- 0x1001f77c
           2131000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001e350, (wrb) a1  <-- 0x1001e354
           2132000                                              #; (lsu) a6  <-- 0x80005e80
           2133000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001f778, 0x80005e80 ~~> Word[0x1001f778]
           2134000    0x80005664 mv a4, a5                      #; a5  = 0x1001f77c, (wrb) a4  <-- 0x1001f77c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2135000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001f77c, a3  = 0x1001f784, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2136000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001e354, a6  <~~ Word[0x1001e354]
           2137000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001f77c, (wrb) a5  <-- 0x1001f780
           2138000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001e354, (wrb) a1  <-- 0x1001e358
           2139000                                              #; (lsu) a6  <-- 1
           2140000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001f77c, 1 ~~> Word[0x1001f77c]
           2141000    0x80005664 mv a4, a5                      #; a5  = 0x1001f780, (wrb) a4  <-- 0x1001f780
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2142000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001f780, a3  = 0x1001f784, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2143000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001e358, a6  <~~ Word[0x1001e358]
           2144000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001f780, (wrb) a5  <-- 0x1001f784
           2145000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001e358, (wrb) a1  <-- 0x1001e35c
           2146000                                              #; (lsu) a6  <-- 1
           2147000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001f780, 1 ~~> Word[0x1001f780]
           2148000    0x80005664 mv a4, a5                      #; a5  = 0x1001f784, (wrb) a4  <-- 0x1001f784
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2149000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001f784, a3  = 0x1001f784, not taken
           2150000    0x8000566c j 8                            #; goto 0x80005674
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
           2151000    0x80005674 bltu a5, a2, 20                #; a5  = 0x1001f784, a2  = 0x1001f784, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
           2152000    0x80005678 lw s0, 12(sp)                  #; sp  = 0x1001e300, s0  <~~ Word[0x1001e30c]
           2153000    0x8000567c addi sp, sp, 16                #; sp  = 0x1001e300, (wrb) sp  <-- 0x1001e310
           2154000    0x80005680 ret                            #; ra  = 0x80003e8c, goto 0x80003e8c
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
           2155000    0x80003e8c lw a0, 8(sp)                   #; sp  = 0x1001e310, a0  <~~ Word[0x1001e318], (lsu) s0  <-- 12
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
           2156000    0x80003e90 lw a1, 8(sp)                   #; sp  = 0x1001e310, a1  <~~ Word[0x1001e318]
           2157000    0x80003e94 lui s11, 2                     #; (wrb) s11 <-- 8192
           2158000    0x80003e98 addi s9, s11, -2000            #; s11 = 8192, (wrb) s9  <-- 6192
           2159000                                              #; (lsu) a0  <-- 0x1001e350
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
           2160000    0x80003e9c add a0, a0, s9                 #; a0  = 0x1001e350, s9  = 6192, (wrb) a0  <-- 0x1001fb80
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
           2161000    0x80003ea0 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
           2162000    0x80003ea4 auipc ra, 1                    #; (wrb) ra  <-- 0x80004ea4
           2163000    0x80003ea8 jalr 1896(ra)                  #; ra  = 0x80004ea4, (wrb) ra  <-- 0x80003eac, goto 0x8000560c
#; memcpy (memcpy.c:25)
#;   {
           2164000    0x8000560c addi sp, sp, -16               #; sp  = 0x1001e310, (wrb) sp  <-- 0x1001e300
           2165000    0x80005610 sw s0, 12(sp)                  #; sp  = 0x1001e300, 12 ~~> Word[0x1001e30c], (lsu) a1  <-- 0x1001e350
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2166000    0x80005614 andi a3, a0, 3                 #; a0  = 0x1001fb80, (wrb) a3  <-- 0
           2167000    0x80005618 andi a4, a1, 3                 #; a1  = 0x1001e350, (wrb) a4  <-- 0
           2168000    0x8000561c xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
           2169000    0x80005620 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
           2170000    0x80005624 li a5, 3                       #; (wrb) a5  <-- 3
           2171000    0x80005628 sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
           2172000    0x8000562c and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
           2173000    0x80005630 add a2, a0, a2                 #; a0  = 0x1001fb80, a2  = 12, (wrb) a2  <-- 0x1001fb8c
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2174000    0x80005634 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
           2175000    0x80005638 bnez a3, 116                   #; a3  = 0, not taken
           2176000    0x8000563c mv a4, a0                      #; a0  = 0x1001fb80, (wrb) a4  <-- 0x1001fb80
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
           2177000    0x80005640 andi a3, a2, -4                #; a2  = 0x1001fb8c, (wrb) a3  <-- 0x1001fb8c
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
           2178000    0x80005644 sub a5, a3, a4                 #; a3  = 0x1001fb8c, a4  = 0x1001fb80, (wrb) a5  <-- 12
           2179000    0x80005648 li a6, 33                      #; (wrb) a6  <-- 33
           2180000    0x8000564c bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2181000    0x80005650 bgeu a4, a3, 32                #; a4  = 0x1001fb80, a3  = 0x1001fb8c, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2182000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001e350, a6  <~~ Word[0x1001e350]
           2183000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001fb80, (wrb) a5  <-- 0x1001fb84
           2184000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001e350, (wrb) a1  <-- 0x1001e354
           2185000                                              #; (lsu) a6  <-- 0x80005e80
           2186000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001fb80, 0x80005e80 ~~> Word[0x1001fb80]
           2187000    0x80005664 mv a4, a5                      #; a5  = 0x1001fb84, (wrb) a4  <-- 0x1001fb84
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2188000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001fb84, a3  = 0x1001fb8c, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2189000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001e354, a6  <~~ Word[0x1001e354]
           2190000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001fb84, (wrb) a5  <-- 0x1001fb88
           2191000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001e354, (wrb) a1  <-- 0x1001e358
           2192000                                              #; (lsu) a6  <-- 1
           2193000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001fb84, 1 ~~> Word[0x1001fb84]
           2194000    0x80005664 mv a4, a5                      #; a5  = 0x1001fb88, (wrb) a4  <-- 0x1001fb88
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2195000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001fb88, a3  = 0x1001fb8c, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2196000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001e358, a6  <~~ Word[0x1001e358]
           2197000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001fb88, (wrb) a5  <-- 0x1001fb8c
           2198000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001e358, (wrb) a1  <-- 0x1001e35c
           2199000                                              #; (lsu) a6  <-- 1
           2200000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001fb88, 1 ~~> Word[0x1001fb88]
           2201000    0x80005664 mv a4, a5                      #; a5  = 0x1001fb8c, (wrb) a4  <-- 0x1001fb8c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2202000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001fb8c, a3  = 0x1001fb8c, not taken
           2203000    0x8000566c j 8                            #; goto 0x80005674
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
           2204000    0x80005674 bltu a5, a2, 20                #; a5  = 0x1001fb8c, a2  = 0x1001fb8c, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
           2205000    0x80005678 lw s0, 12(sp)                  #; sp  = 0x1001e300, s0  <~~ Word[0x1001e30c]
           2206000    0x8000567c addi sp, sp, 16                #; sp  = 0x1001e300, (wrb) sp  <-- 0x1001e310
           2207000    0x80005680 ret                            #; ra  = 0x80003eac, goto 0x80003eac
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
           2208000    0x80003eac lw a0, 8(sp)                   #; sp  = 0x1001e310, a0  <~~ Word[0x1001e318], (lsu) s0  <-- 12
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
           2209000    0x80003eb0 lw a1, 8(sp)                   #; sp  = 0x1001e310, a1  <~~ Word[0x1001e318]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
           2210000    0x80003eb4 ori s10, s9, 1032              #; s9  = 6192, (wrb) s10 <-- 7224
           2211000                                              #; (lsu) a0  <-- 0x1001e350
           2212000    0x80003eb8 add a0, a0, s10                #; a0  = 0x1001e350, s10 = 7224, (wrb) a0  <-- 0x1001ff88
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
           2213000    0x80003ebc mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
           2214000    0x80003ec0 auipc ra, 1                    #; (wrb) ra  <-- 0x80004ec0
           2215000    0x80003ec4 jalr 1868(ra)                  #; ra  = 0x80004ec0, (wrb) ra  <-- 0x80003ec8, goto 0x8000560c
#; memcpy (memcpy.c:25)
#;   {
           2216000    0x8000560c addi sp, sp, -16               #; sp  = 0x1001e310, (wrb) sp  <-- 0x1001e300
           2217000    0x80005610 sw s0, 12(sp)                  #; sp  = 0x1001e300, 12 ~~> Word[0x1001e30c], (lsu) a1  <-- 0x1001e350
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2218000    0x80005614 andi a3, a0, 3                 #; a0  = 0x1001ff88, (wrb) a3  <-- 0
           2219000    0x80005618 andi a4, a1, 3                 #; a1  = 0x1001e350, (wrb) a4  <-- 0
           2220000    0x8000561c xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
           2221000    0x80005620 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
           2222000    0x80005624 li a5, 3                       #; (wrb) a5  <-- 3
           2223000    0x80005628 sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
           2224000    0x8000562c and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
           2225000    0x80005630 add a2, a0, a2                 #; a0  = 0x1001ff88, a2  = 12, (wrb) a2  <-- 0x1001ff94
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2226000    0x80005634 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
           2227000    0x80005638 bnez a3, 116                   #; a3  = 0, not taken
           2228000    0x8000563c mv a4, a0                      #; a0  = 0x1001ff88, (wrb) a4  <-- 0x1001ff88
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
           2229000    0x80005640 andi a3, a2, -4                #; a2  = 0x1001ff94, (wrb) a3  <-- 0x1001ff94
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
           2230000    0x80005644 sub a5, a3, a4                 #; a3  = 0x1001ff94, a4  = 0x1001ff88, (wrb) a5  <-- 12
           2231000    0x80005648 li a6, 33                      #; (wrb) a6  <-- 33
           2232000    0x8000564c bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2233000    0x80005650 bgeu a4, a3, 32                #; a4  = 0x1001ff88, a3  = 0x1001ff94, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2234000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001e350, a6  <~~ Word[0x1001e350]
           2235000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001ff88, (wrb) a5  <-- 0x1001ff8c
           2236000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001e350, (wrb) a1  <-- 0x1001e354
           2237000                                              #; (lsu) a6  <-- 0x80005e80
           2238000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001ff88, 0x80005e80 ~~> Word[0x1001ff88]
           2239000    0x80005664 mv a4, a5                      #; a5  = 0x1001ff8c, (wrb) a4  <-- 0x1001ff8c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2240000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001ff8c, a3  = 0x1001ff94, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2241000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001e354, a6  <~~ Word[0x1001e354]
           2242000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001ff8c, (wrb) a5  <-- 0x1001ff90
           2243000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001e354, (wrb) a1  <-- 0x1001e358
           2244000                                              #; (lsu) a6  <-- 1
           2245000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001ff8c, 1 ~~> Word[0x1001ff8c]
           2246000    0x80005664 mv a4, a5                      #; a5  = 0x1001ff90, (wrb) a4  <-- 0x1001ff90
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2247000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001ff90, a3  = 0x1001ff94, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2248000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001e358, a6  <~~ Word[0x1001e358]
           2249000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001ff90, (wrb) a5  <-- 0x1001ff94
           2250000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001e358, (wrb) a1  <-- 0x1001e35c
           2251000                                              #; (lsu) a6  <-- 1
           2252000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001ff90, 1 ~~> Word[0x1001ff90]
           2253000    0x80005664 mv a4, a5                      #; a5  = 0x1001ff94, (wrb) a4  <-- 0x1001ff94
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2254000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001ff94, a3  = 0x1001ff94, not taken
           2255000    0x8000566c j 8                            #; goto 0x80005674
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
           2256000    0x80005674 bltu a5, a2, 20                #; a5  = 0x1001ff94, a2  = 0x1001ff94, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
           2257000    0x80005678 lw s0, 12(sp)                  #; sp  = 0x1001e300, s0  <~~ Word[0x1001e30c]
           2258000    0x8000567c addi sp, sp, 16                #; sp  = 0x1001e300, (wrb) sp  <-- 0x1001e310
           2259000    0x80005680 ret                            #; ra  = 0x80003ec8, goto 0x80003ec8
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
           2260000    0x80003ec8 lw a0, 8(sp)                   #; sp  = 0x1001e310, a0  <~~ Word[0x1001e318], (lsu) s0  <-- 12
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
           2261000    0x80003ecc lw a1, 8(sp)                   #; sp  = 0x1001e310, a1  <~~ Word[0x1001e318]
           2262000    0x80003ed0 addi s11, s11, 64              #; s11 = 8192, (wrb) s11 <-- 8256
           2263000                                              #; (lsu) a0  <-- 0x1001e350
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
           2264000    0x80003ed4 add a0, a0, s11                #; a0  = 0x1001e350, s11 = 8256, (wrb) a0  <-- 0x10020390
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
           2265000    0x80003ed8 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
           2266000    0x80003edc auipc ra, 1                    #; (wrb) ra  <-- 0x80004edc
           2267000    0x80003ee0 jalr 1840(ra)                  #; ra  = 0x80004edc, (wrb) ra  <-- 0x80003ee4, goto 0x8000560c
#; memcpy (memcpy.c:25)
#;   {
           2268000    0x8000560c addi sp, sp, -16               #; sp  = 0x1001e310, (wrb) sp  <-- 0x1001e300
           2269000    0x80005610 sw s0, 12(sp)                  #; sp  = 0x1001e300, 12 ~~> Word[0x1001e30c], (lsu) a1  <-- 0x1001e350
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2270000    0x80005614 andi a3, a0, 3                 #; a0  = 0x10020390, (wrb) a3  <-- 0
           2271000    0x80005618 andi a4, a1, 3                 #; a1  = 0x1001e350, (wrb) a4  <-- 0
           2272000    0x8000561c xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
           2273000    0x80005620 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
           2274000    0x80005624 li a5, 3                       #; (wrb) a5  <-- 3
           2275000    0x80005628 sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
           2276000    0x8000562c and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
           2277000    0x80005630 add a2, a0, a2                 #; a0  = 0x10020390, a2  = 12, (wrb) a2  <-- 0x1002039c
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2278000    0x80005634 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
           2279000    0x80005638 bnez a3, 116                   #; a3  = 0, not taken
           2280000    0x8000563c mv a4, a0                      #; a0  = 0x10020390, (wrb) a4  <-- 0x10020390
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
           2281000    0x80005640 andi a3, a2, -4                #; a2  = 0x1002039c, (wrb) a3  <-- 0x1002039c
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
           2282000    0x80005644 sub a5, a3, a4                 #; a3  = 0x1002039c, a4  = 0x10020390, (wrb) a5  <-- 12
           2283000    0x80005648 li a6, 33                      #; (wrb) a6  <-- 33
           2284000    0x8000564c bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2285000    0x80005650 bgeu a4, a3, 32                #; a4  = 0x10020390, a3  = 0x1002039c, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2286000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001e350, a6  <~~ Word[0x1001e350]
           2287000    0x80005658 addi a5, a4, 4                 #; a4  = 0x10020390, (wrb) a5  <-- 0x10020394
           2288000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001e350, (wrb) a1  <-- 0x1001e354
           2289000                                              #; (lsu) a6  <-- 0x80005e80
           2290000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x10020390, 0x80005e80 ~~> Word[0x10020390]
           2291000    0x80005664 mv a4, a5                      #; a5  = 0x10020394, (wrb) a4  <-- 0x10020394
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2292000    0x80005668 bltu a5, a3, -20               #; a5  = 0x10020394, a3  = 0x1002039c, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2293000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001e354, a6  <~~ Word[0x1001e354]
           2294000    0x80005658 addi a5, a4, 4                 #; a4  = 0x10020394, (wrb) a5  <-- 0x10020398
           2295000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001e354, (wrb) a1  <-- 0x1001e358
           2330000                                              #; (lsu) a6  <-- 1
           2331000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x10020394, 1 ~~> Word[0x10020394]
           2332000    0x80005664 mv a4, a5                      #; a5  = 0x10020398, (wrb) a4  <-- 0x10020398
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2333000    0x80005668 bltu a5, a3, -20               #; a5  = 0x10020398, a3  = 0x1002039c, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2334000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001e358, a6  <~~ Word[0x1001e358]
           2335000    0x80005658 addi a5, a4, 4                 #; a4  = 0x10020398, (wrb) a5  <-- 0x1002039c
           2336000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001e358, (wrb) a1  <-- 0x1001e35c
           2357000                                              #; (lsu) a6  <-- 1
           2358000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x10020398, 1 ~~> Word[0x10020398]
           2359000    0x80005664 mv a4, a5                      #; a5  = 0x1002039c, (wrb) a4  <-- 0x1002039c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2360000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1002039c, a3  = 0x1002039c, not taken
           2361000    0x8000566c j 8                            #; goto 0x80005674
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
           2362000    0x80005674 bltu a5, a2, 20                #; a5  = 0x1002039c, a2  = 0x1002039c, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
           2363000    0x80005678 lw s0, 12(sp)                  #; sp  = 0x1001e300, s0  <~~ Word[0x1001e30c]
           2364000    0x8000567c addi sp, sp, 16                #; sp  = 0x1001e300, (wrb) sp  <-- 0x1001e310
           2365000    0x80005680 ret                            #; ra  = 0x80003ee4, goto 0x80003ee4
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:79:17)
#;     tls_ptr += size;
#;             ^
           2374000    0x80003ee4 lw a0, 8(sp)                   #; sp  = 0x1001e310, a0  <~~ Word[0x1001e318]
           2384000                                              #; (lsu) s0  <-- 12
           2385000                                              #; (lsu) a0  <-- 0x1001e350
           2386000    0x80003ee8 add a0, a0, s0                 #; a0  = 0x1001e350, s0  = 12, (wrb) a0  <-- 0x1001e35c
           2387000    0x80003eec sw a0, 8(sp)                   #; sp  = 0x1001e310, 0x1001e35c ~~> Word[0x1001e318]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
           2388000    0x80003ef0 lw a0, 8(sp)                   #; sp  = 0x1001e310, a0  <~~ Word[0x1001e318]
#; .LBB25_25 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
           2389000    0x80003ef4 auipc a1, 2                    #; (wrb) a1  <-- 0x80005ef4
           2390000    0x80003ef8 addi a1, a1, -412              #; a1  = 0x80005ef4, (wrb) a1  <-- 0x80005d58
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
           2391000    0x80003efc auipc a2, 2                    #; (wrb) a2  <-- 0x80005efc
           2392000    0x80003f00 addi a2, a2, -356              #; a2  = 0x80005efc, (wrb) a2  <-- 0x80005d98
           2393000    0x80003f04 sub s0, a2, a1                 #; a2  = 0x80005d98, a1  = 0x80005d58, (wrb) s0  <-- 64
           2394000    0x80003f08 li a1, 0                       #; (wrb) a1  <-- 0
           2395000    0x80003f0c mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
           2396000    0x80003f10 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f10
           2397000    0x80003f14 jalr 764(ra)                   #; ra  = 0x80003f10, (wrb) ra  <-- 0x80003f18, goto 0x8000420c
           2398000                                              #; (lsu) a0  <-- 0x1001e35c
#; memset (memset.S:30)
#;   li t1, 15
           2400000    0x8000420c li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
           2401000    0x80004210 mv a4, a0                      #; a0  = 0x1001e35c, (wrb) a4  <-- 0x1001e35c
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
           2402000    0x80004214 bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
           2403000    0x80004218 andi a5, a4, 15                #; a4  = 0x1001e35c, (wrb) a5  <-- 12
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
           2404000    0x8000421c bnez a5, 160                   #; a5  = 12, taken, goto 0x800042bc
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
           2407000    0x800042bc slli a3, a5, 2                 #; a5  = 12, (wrb) a3  <-- 48
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
           2410000    0x800042c0 auipc t0, 0                    #; (wrb) t0  <-- 0x800042c0
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
           2411000    0x800042c4 add a3, a3, t0                 #; a3  = 48, t0  = 0x800042c0, (wrb) a3  <-- 0x800042f0
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
           2412000    0x800042c8 mv t0, ra                      #; ra  = 0x80003f18, (wrb) t0  <-- 0x80003f18
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
           2413000    0x800042cc jalr -96(a3)                   #; a3  = 0x800042f0, (wrb) ra  <-- 0x800042d0, goto 0x80004290
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           2414000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x1001e35c, 0 ~~> Byte[0x1001e35f]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           2415000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x1001e35c, 0 ~~> Byte[0x1001e35e]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           2416000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x1001e35c, 0 ~~> Byte[0x1001e35d]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           2417000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x1001e35c, 0 ~~> Byte[0x1001e35c]
#; .Ltable (memset.S:85)
#;   ret
           2418000    0x800042a0 ret                            #; ra  = 0x800042d0, goto 0x800042d0
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           2419000    0x800042d0 mv ra, t0                      #; t0  = 0x80003f18, (wrb) ra  <-- 0x80003f18
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           2420000    0x800042d4 addi a5, a5, -16               #; a5  = 12, (wrb) a5  <-- -4
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           2421000    0x800042d8 sub a4, a4, a5                 #; a4  = 0x1001e35c, a5  = -4, (wrb) a4  <-- 0x1001e360
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           2422000    0x800042dc add a2, a2, a5                 #; a2  = 64, a5  = -4, (wrb) a2  <-- 60
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           2423000    0x800042e0 bgeu t1, a2, -144              #; t1  = 15, a2  = 60, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           2424000    0x800042e4 j -196                         #; goto 0x80004220
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           2425000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           2426000    0x80004224 andi a3, a2, -16               #; a2  = 60, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           2427000    0x80004228 andi a2, a2, 15                #; a2  = 60, (wrb) a2  <-- 12
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           2428000    0x8000422c add a3, a3, a4                 #; a3  = 48, a4  = 0x1001e360, (wrb) a3  <-- 0x1001e390
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2429000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001e360, 0 ~~> Word[0x1001e360]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2430000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001e360, 0 ~~> Word[0x1001e364]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2431000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001e360, 0 ~~> Word[0x1001e368]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2432000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001e360, 0 ~~> Word[0x1001e36c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2435000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001e360, (wrb) a4  <-- 0x1001e370
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2436000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001e370, a3  = 0x1001e390, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2437000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001e370, 0 ~~> Word[0x1001e370]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2438000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001e370, 0 ~~> Word[0x1001e374]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2439000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001e370, 0 ~~> Word[0x1001e378]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2440000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001e370, 0 ~~> Word[0x1001e37c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2441000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001e370, (wrb) a4  <-- 0x1001e380
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2442000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001e380, a3  = 0x1001e390, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2443000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001e380, 0 ~~> Word[0x1001e380]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2444000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001e380, 0 ~~> Word[0x1001e384]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2445000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001e380, 0 ~~> Word[0x1001e388]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2446000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001e380, 0 ~~> Word[0x1001e38c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2447000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001e380, (wrb) a4  <-- 0x1001e390
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2448000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001e390, a3  = 0x1001e390, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           2449000    0x80004248 bnez a2, 8                     #; a2  = 12, taken, goto 0x80004250
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
           2450000    0x80004250 sub a3, t1, a2                 #; t1  = 15, a2  = 12, (wrb) a3  <-- 3
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
           2451000    0x80004254 slli a3, a3, 2                 #; a3  = 3, (wrb) a3  <-- 12
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
           2452000    0x80004258 auipc t0, 0                    #; (wrb) t0  <-- 0x80004258
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
           2453000    0x8000425c add a3, a3, t0                 #; a3  = 12, t0  = 0x80004258, (wrb) a3  <-- 0x80004264
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
           2454000    0x80004260 jr 12(a3)                      #; a3  = 0x80004264, goto 0x80004270
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
           2455000    0x80004270 sb a1, 11(a4)                  #; a4  = 0x1001e390, 0 ~~> Byte[0x1001e39b]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
           2456000    0x80004274 sb a1, 10(a4)                  #; a4  = 0x1001e390, 0 ~~> Byte[0x1001e39a]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
           2457000    0x80004278 sb a1, 9(a4)                   #; a4  = 0x1001e390, 0 ~~> Byte[0x1001e399]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
           2458000    0x8000427c sb a1, 8(a4)                   #; a4  = 0x1001e390, 0 ~~> Byte[0x1001e398]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
           2459000    0x80004280 sb a1, 7(a4)                   #; a4  = 0x1001e390, 0 ~~> Byte[0x1001e397]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
           2460000    0x80004284 sb a1, 6(a4)                   #; a4  = 0x1001e390, 0 ~~> Byte[0x1001e396]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
           2461000    0x80004288 sb a1, 5(a4)                   #; a4  = 0x1001e390, 0 ~~> Byte[0x1001e395]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
           2462000    0x8000428c sb a1, 4(a4)                   #; a4  = 0x1001e390, 0 ~~> Byte[0x1001e394]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           2463000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x1001e390, 0 ~~> Byte[0x1001e393]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           2464000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x1001e390, 0 ~~> Byte[0x1001e392]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           2465000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x1001e390, 0 ~~> Byte[0x1001e391]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           2468000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x1001e390, 0 ~~> Byte[0x1001e390]
#; .Ltable (memset.S:85)
#;   ret
           2469000    0x800042a0 ret                            #; ra  = 0x80003f18, goto 0x80003f18
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
           2470000    0x80003f18 lw a0, 8(sp)                   #; sp  = 0x1001e310, a0  <~~ Word[0x1001e318]
           2474000                                              #; (lsu) a0  <-- 0x1001e35c
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
           2475000    0x80003f1c addi a0, a0, 1032              #; a0  = 0x1001e35c, (wrb) a0  <-- 0x1001e764
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
           2476000    0x80003f20 li a1, 0                       #; (wrb) a1  <-- 0
           2477000    0x80003f24 mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
           2478000    0x80003f28 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f28
           2479000    0x80003f2c jalr 740(ra)                   #; ra  = 0x80003f28, (wrb) ra  <-- 0x80003f30, goto 0x8000420c
#; memset (memset.S:30)
#;   li t1, 15
           2480000    0x8000420c li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
           2481000    0x80004210 mv a4, a0                      #; a0  = 0x1001e764, (wrb) a4  <-- 0x1001e764
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
           2482000    0x80004214 bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
           2483000    0x80004218 andi a5, a4, 15                #; a4  = 0x1001e764, (wrb) a5  <-- 4
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
           2484000    0x8000421c bnez a5, 160                   #; a5  = 4, taken, goto 0x800042bc
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
           2485000    0x800042bc slli a3, a5, 2                 #; a5  = 4, (wrb) a3  <-- 16
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
           2486000    0x800042c0 auipc t0, 0                    #; (wrb) t0  <-- 0x800042c0
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
           2487000    0x800042c4 add a3, a3, t0                 #; a3  = 16, t0  = 0x800042c0, (wrb) a3  <-- 0x800042d0
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
           2488000    0x800042c8 mv t0, ra                      #; ra  = 0x80003f30, (wrb) t0  <-- 0x80003f30
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
           2489000    0x800042cc jalr -96(a3)                   #; a3  = 0x800042d0, (wrb) ra  <-- 0x800042d0, goto 0x80004270
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
           2490000    0x80004270 sb a1, 11(a4)                  #; a4  = 0x1001e764, 0 ~~> Byte[0x1001e76f]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
           2491000    0x80004274 sb a1, 10(a4)                  #; a4  = 0x1001e764, 0 ~~> Byte[0x1001e76e]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
           2492000    0x80004278 sb a1, 9(a4)                   #; a4  = 0x1001e764, 0 ~~> Byte[0x1001e76d]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
           2493000    0x8000427c sb a1, 8(a4)                   #; a4  = 0x1001e764, 0 ~~> Byte[0x1001e76c]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
           2494000    0x80004280 sb a1, 7(a4)                   #; a4  = 0x1001e764, 0 ~~> Byte[0x1001e76b]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
           2495000    0x80004284 sb a1, 6(a4)                   #; a4  = 0x1001e764, 0 ~~> Byte[0x1001e76a]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
           2496000    0x80004288 sb a1, 5(a4)                   #; a4  = 0x1001e764, 0 ~~> Byte[0x1001e769]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
           2497000    0x8000428c sb a1, 4(a4)                   #; a4  = 0x1001e764, 0 ~~> Byte[0x1001e768]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           2498000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x1001e764, 0 ~~> Byte[0x1001e767]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           2499000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x1001e764, 0 ~~> Byte[0x1001e766]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           2500000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x1001e764, 0 ~~> Byte[0x1001e765]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           2501000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x1001e764, 0 ~~> Byte[0x1001e764]
#; .Ltable (memset.S:85)
#;   ret
           2502000    0x800042a0 ret                            #; ra  = 0x800042d0, goto 0x800042d0
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           2503000    0x800042d0 mv ra, t0                      #; t0  = 0x80003f30, (wrb) ra  <-- 0x80003f30
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           2504000    0x800042d4 addi a5, a5, -16               #; a5  = 4, (wrb) a5  <-- -12
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           2505000    0x800042d8 sub a4, a4, a5                 #; a4  = 0x1001e764, a5  = -12, (wrb) a4  <-- 0x1001e770
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           2506000    0x800042dc add a2, a2, a5                 #; a2  = 64, a5  = -12, (wrb) a2  <-- 52
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           2507000    0x800042e0 bgeu t1, a2, -144              #; t1  = 15, a2  = 52, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           2508000    0x800042e4 j -196                         #; goto 0x80004220
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           2509000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           2510000    0x80004224 andi a3, a2, -16               #; a2  = 52, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           2511000    0x80004228 andi a2, a2, 15                #; a2  = 52, (wrb) a2  <-- 4
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           2512000    0x8000422c add a3, a3, a4                 #; a3  = 48, a4  = 0x1001e770, (wrb) a3  <-- 0x1001e7a0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2513000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001e770, 0 ~~> Word[0x1001e770]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2514000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001e770, 0 ~~> Word[0x1001e774]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2515000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001e770, 0 ~~> Word[0x1001e778]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2516000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001e770, 0 ~~> Word[0x1001e77c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2517000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001e770, (wrb) a4  <-- 0x1001e780
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2518000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001e780, a3  = 0x1001e7a0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2519000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001e780, 0 ~~> Word[0x1001e780]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2520000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001e780, 0 ~~> Word[0x1001e784]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2521000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001e780, 0 ~~> Word[0x1001e788]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2522000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001e780, 0 ~~> Word[0x1001e78c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2523000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001e780, (wrb) a4  <-- 0x1001e790
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2524000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001e790, a3  = 0x1001e7a0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2525000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001e790, 0 ~~> Word[0x1001e790]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2526000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001e790, 0 ~~> Word[0x1001e794]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2527000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001e790, 0 ~~> Word[0x1001e798]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2528000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001e790, 0 ~~> Word[0x1001e79c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2529000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001e790, (wrb) a4  <-- 0x1001e7a0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2530000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001e7a0, a3  = 0x1001e7a0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           2531000    0x80004248 bnez a2, 8                     #; a2  = 4, taken, goto 0x80004250
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
           2532000    0x80004250 sub a3, t1, a2                 #; t1  = 15, a2  = 4, (wrb) a3  <-- 11
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
           2533000    0x80004254 slli a3, a3, 2                 #; a3  = 11, (wrb) a3  <-- 44
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
           2534000    0x80004258 auipc t0, 0                    #; (wrb) t0  <-- 0x80004258
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
           2535000    0x8000425c add a3, a3, t0                 #; a3  = 44, t0  = 0x80004258, (wrb) a3  <-- 0x80004284
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
           2536000    0x80004260 jr 12(a3)                      #; a3  = 0x80004284, goto 0x80004290
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           2537000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x1001e7a0, 0 ~~> Byte[0x1001e7a3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           2538000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x1001e7a0, 0 ~~> Byte[0x1001e7a2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           2539000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x1001e7a0, 0 ~~> Byte[0x1001e7a1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           2540000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x1001e7a0, 0 ~~> Byte[0x1001e7a0]
#; .Ltable (memset.S:85)
#;   ret
           2541000    0x800042a0 ret                            #; ra  = 0x80003f30, goto 0x80003f30
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
           2542000    0x80003f30 lw a0, 8(sp)                   #; sp  = 0x1001e310, a0  <~~ Word[0x1001e318]
           2545000                                              #; (lsu) a0  <-- 0x1001e35c
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
           2546000    0x80003f34 add a0, a0, s1                 #; a0  = 0x1001e35c, s1  = 2064, (wrb) a0  <-- 0x1001eb6c
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
           2547000    0x80003f38 li a1, 0                       #; (wrb) a1  <-- 0
           2548000    0x80003f3c mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
           2551000    0x80003f40 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f40
           2552000    0x80003f44 jalr 716(ra)                   #; ra  = 0x80003f40, (wrb) ra  <-- 0x80003f48, goto 0x8000420c
#; memset (memset.S:30)
#;   li t1, 15
           2553000    0x8000420c li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
           2554000    0x80004210 mv a4, a0                      #; a0  = 0x1001eb6c, (wrb) a4  <-- 0x1001eb6c
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
           2555000    0x80004214 bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
           2556000    0x80004218 andi a5, a4, 15                #; a4  = 0x1001eb6c, (wrb) a5  <-- 12
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
           2557000    0x8000421c bnez a5, 160                   #; a5  = 12, taken, goto 0x800042bc
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
           2558000    0x800042bc slli a3, a5, 2                 #; a5  = 12, (wrb) a3  <-- 48
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
           2559000    0x800042c0 auipc t0, 0                    #; (wrb) t0  <-- 0x800042c0
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
           2560000    0x800042c4 add a3, a3, t0                 #; a3  = 48, t0  = 0x800042c0, (wrb) a3  <-- 0x800042f0
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
           2561000    0x800042c8 mv t0, ra                      #; ra  = 0x80003f48, (wrb) t0  <-- 0x80003f48
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
           2562000    0x800042cc jalr -96(a3)                   #; a3  = 0x800042f0, (wrb) ra  <-- 0x800042d0, goto 0x80004290
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           2563000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x1001eb6c, 0 ~~> Byte[0x1001eb6f]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           2564000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x1001eb6c, 0 ~~> Byte[0x1001eb6e]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           2565000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x1001eb6c, 0 ~~> Byte[0x1001eb6d]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           2566000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x1001eb6c, 0 ~~> Byte[0x1001eb6c]
#; .Ltable (memset.S:85)
#;   ret
           2567000    0x800042a0 ret                            #; ra  = 0x800042d0, goto 0x800042d0
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           2568000    0x800042d0 mv ra, t0                      #; t0  = 0x80003f48, (wrb) ra  <-- 0x80003f48
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           2569000    0x800042d4 addi a5, a5, -16               #; a5  = 12, (wrb) a5  <-- -4
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           2570000    0x800042d8 sub a4, a4, a5                 #; a4  = 0x1001eb6c, a5  = -4, (wrb) a4  <-- 0x1001eb70
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           2571000    0x800042dc add a2, a2, a5                 #; a2  = 64, a5  = -4, (wrb) a2  <-- 60
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           2572000    0x800042e0 bgeu t1, a2, -144              #; t1  = 15, a2  = 60, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           2573000    0x800042e4 j -196                         #; goto 0x80004220
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           2574000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           2575000    0x80004224 andi a3, a2, -16               #; a2  = 60, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           2576000    0x80004228 andi a2, a2, 15                #; a2  = 60, (wrb) a2  <-- 12
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           2577000    0x8000422c add a3, a3, a4                 #; a3  = 48, a4  = 0x1001eb70, (wrb) a3  <-- 0x1001eba0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2578000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001eb70, 0 ~~> Word[0x1001eb70]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2579000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001eb70, 0 ~~> Word[0x1001eb74]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2580000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001eb70, 0 ~~> Word[0x1001eb78]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2581000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001eb70, 0 ~~> Word[0x1001eb7c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2582000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001eb70, (wrb) a4  <-- 0x1001eb80
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2583000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001eb80, a3  = 0x1001eba0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2584000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001eb80, 0 ~~> Word[0x1001eb80]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2585000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001eb80, 0 ~~> Word[0x1001eb84]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2586000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001eb80, 0 ~~> Word[0x1001eb88]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2587000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001eb80, 0 ~~> Word[0x1001eb8c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2588000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001eb80, (wrb) a4  <-- 0x1001eb90
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2589000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001eb90, a3  = 0x1001eba0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2590000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001eb90, 0 ~~> Word[0x1001eb90]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2591000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001eb90, 0 ~~> Word[0x1001eb94]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2592000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001eb90, 0 ~~> Word[0x1001eb98]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2593000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001eb90, 0 ~~> Word[0x1001eb9c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2594000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001eb90, (wrb) a4  <-- 0x1001eba0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2595000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001eba0, a3  = 0x1001eba0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           2596000    0x80004248 bnez a2, 8                     #; a2  = 12, taken, goto 0x80004250
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
           2597000    0x80004250 sub a3, t1, a2                 #; t1  = 15, a2  = 12, (wrb) a3  <-- 3
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
           2598000    0x80004254 slli a3, a3, 2                 #; a3  = 3, (wrb) a3  <-- 12
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
           2599000    0x80004258 auipc t0, 0                    #; (wrb) t0  <-- 0x80004258
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
           2600000    0x8000425c add a3, a3, t0                 #; a3  = 12, t0  = 0x80004258, (wrb) a3  <-- 0x80004264
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
           2601000    0x80004260 jr 12(a3)                      #; a3  = 0x80004264, goto 0x80004270
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
           2602000    0x80004270 sb a1, 11(a4)                  #; a4  = 0x1001eba0, 0 ~~> Byte[0x1001ebab]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
           2603000    0x80004274 sb a1, 10(a4)                  #; a4  = 0x1001eba0, 0 ~~> Byte[0x1001ebaa]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
           2604000    0x80004278 sb a1, 9(a4)                   #; a4  = 0x1001eba0, 0 ~~> Byte[0x1001eba9]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
           2605000    0x8000427c sb a1, 8(a4)                   #; a4  = 0x1001eba0, 0 ~~> Byte[0x1001eba8]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
           2606000    0x80004280 sb a1, 7(a4)                   #; a4  = 0x1001eba0, 0 ~~> Byte[0x1001eba7]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
           2607000    0x80004284 sb a1, 6(a4)                   #; a4  = 0x1001eba0, 0 ~~> Byte[0x1001eba6]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
           2608000    0x80004288 sb a1, 5(a4)                   #; a4  = 0x1001eba0, 0 ~~> Byte[0x1001eba5]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
           2609000    0x8000428c sb a1, 4(a4)                   #; a4  = 0x1001eba0, 0 ~~> Byte[0x1001eba4]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           2610000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x1001eba0, 0 ~~> Byte[0x1001eba3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           2611000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x1001eba0, 0 ~~> Byte[0x1001eba2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           2612000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x1001eba0, 0 ~~> Byte[0x1001eba1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           2614000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x1001eba0, 0 ~~> Byte[0x1001eba0]
#; .Ltable (memset.S:85)
#;   ret
           2615000    0x800042a0 ret                            #; ra  = 0x80003f48, goto 0x80003f48
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
           2616000    0x80003f48 lw a0, 8(sp)                   #; sp  = 0x1001e310, a0  <~~ Word[0x1001e318]
           2620000                                              #; (lsu) a0  <-- 0x1001e35c
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
           2621000    0x80003f4c add a0, a0, s6                 #; a0  = 0x1001e35c, s6  = 3096, (wrb) a0  <-- 0x1001ef74
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
           2622000    0x80003f50 li a1, 0                       #; (wrb) a1  <-- 0
           2623000    0x80003f54 mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
           2624000    0x80003f58 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f58
           2625000    0x80003f5c jalr 692(ra)                   #; ra  = 0x80003f58, (wrb) ra  <-- 0x80003f60, goto 0x8000420c
#; memset (memset.S:30)
#;   li t1, 15
           2626000    0x8000420c li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
           2627000    0x80004210 mv a4, a0                      #; a0  = 0x1001ef74, (wrb) a4  <-- 0x1001ef74
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
           2628000    0x80004214 bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
           2629000    0x80004218 andi a5, a4, 15                #; a4  = 0x1001ef74, (wrb) a5  <-- 4
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
           2630000    0x8000421c bnez a5, 160                   #; a5  = 4, taken, goto 0x800042bc
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
           2631000    0x800042bc slli a3, a5, 2                 #; a5  = 4, (wrb) a3  <-- 16
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
           2632000    0x800042c0 auipc t0, 0                    #; (wrb) t0  <-- 0x800042c0
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
           2633000    0x800042c4 add a3, a3, t0                 #; a3  = 16, t0  = 0x800042c0, (wrb) a3  <-- 0x800042d0
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
           2634000    0x800042c8 mv t0, ra                      #; ra  = 0x80003f60, (wrb) t0  <-- 0x80003f60
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
           2635000    0x800042cc jalr -96(a3)                   #; a3  = 0x800042d0, (wrb) ra  <-- 0x800042d0, goto 0x80004270
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
           2636000    0x80004270 sb a1, 11(a4)                  #; a4  = 0x1001ef74, 0 ~~> Byte[0x1001ef7f]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
           2637000    0x80004274 sb a1, 10(a4)                  #; a4  = 0x1001ef74, 0 ~~> Byte[0x1001ef7e]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
           2638000    0x80004278 sb a1, 9(a4)                   #; a4  = 0x1001ef74, 0 ~~> Byte[0x1001ef7d]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
           2639000    0x8000427c sb a1, 8(a4)                   #; a4  = 0x1001ef74, 0 ~~> Byte[0x1001ef7c]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
           2640000    0x80004280 sb a1, 7(a4)                   #; a4  = 0x1001ef74, 0 ~~> Byte[0x1001ef7b]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
           2641000    0x80004284 sb a1, 6(a4)                   #; a4  = 0x1001ef74, 0 ~~> Byte[0x1001ef7a]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
           2642000    0x80004288 sb a1, 5(a4)                   #; a4  = 0x1001ef74, 0 ~~> Byte[0x1001ef79]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
           2643000    0x8000428c sb a1, 4(a4)                   #; a4  = 0x1001ef74, 0 ~~> Byte[0x1001ef78]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           2644000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x1001ef74, 0 ~~> Byte[0x1001ef77]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           2645000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x1001ef74, 0 ~~> Byte[0x1001ef76]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           2646000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x1001ef74, 0 ~~> Byte[0x1001ef75]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           2647000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x1001ef74, 0 ~~> Byte[0x1001ef74]
#; .Ltable (memset.S:85)
#;   ret
           2648000    0x800042a0 ret                            #; ra  = 0x800042d0, goto 0x800042d0
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           2649000    0x800042d0 mv ra, t0                      #; t0  = 0x80003f60, (wrb) ra  <-- 0x80003f60
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           2650000    0x800042d4 addi a5, a5, -16               #; a5  = 4, (wrb) a5  <-- -12
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           2651000    0x800042d8 sub a4, a4, a5                 #; a4  = 0x1001ef74, a5  = -12, (wrb) a4  <-- 0x1001ef80
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           2652000    0x800042dc add a2, a2, a5                 #; a2  = 64, a5  = -12, (wrb) a2  <-- 52
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           2653000    0x800042e0 bgeu t1, a2, -144              #; t1  = 15, a2  = 52, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           2654000    0x800042e4 j -196                         #; goto 0x80004220
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           2655000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           2656000    0x80004224 andi a3, a2, -16               #; a2  = 52, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           2657000    0x80004228 andi a2, a2, 15                #; a2  = 52, (wrb) a2  <-- 4
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           2658000    0x8000422c add a3, a3, a4                 #; a3  = 48, a4  = 0x1001ef80, (wrb) a3  <-- 0x1001efb0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2659000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001ef80, 0 ~~> Word[0x1001ef80]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2660000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001ef80, 0 ~~> Word[0x1001ef84]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2661000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001ef80, 0 ~~> Word[0x1001ef88]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2662000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001ef80, 0 ~~> Word[0x1001ef8c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2663000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001ef80, (wrb) a4  <-- 0x1001ef90
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2664000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001ef90, a3  = 0x1001efb0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2665000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001ef90, 0 ~~> Word[0x1001ef90]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2666000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001ef90, 0 ~~> Word[0x1001ef94]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2667000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001ef90, 0 ~~> Word[0x1001ef98]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2668000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001ef90, 0 ~~> Word[0x1001ef9c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2669000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001ef90, (wrb) a4  <-- 0x1001efa0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2670000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001efa0, a3  = 0x1001efb0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2671000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001efa0, 0 ~~> Word[0x1001efa0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2672000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001efa0, 0 ~~> Word[0x1001efa4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2673000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001efa0, 0 ~~> Word[0x1001efa8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2674000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001efa0, 0 ~~> Word[0x1001efac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2675000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001efa0, (wrb) a4  <-- 0x1001efb0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2676000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001efb0, a3  = 0x1001efb0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           2677000    0x80004248 bnez a2, 8                     #; a2  = 4, taken, goto 0x80004250
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
           2678000    0x80004250 sub a3, t1, a2                 #; t1  = 15, a2  = 4, (wrb) a3  <-- 11
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
           2679000    0x80004254 slli a3, a3, 2                 #; a3  = 11, (wrb) a3  <-- 44
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
           2680000    0x80004258 auipc t0, 0                    #; (wrb) t0  <-- 0x80004258
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
           2681000    0x8000425c add a3, a3, t0                 #; a3  = 44, t0  = 0x80004258, (wrb) a3  <-- 0x80004284
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
           2682000    0x80004260 jr 12(a3)                      #; a3  = 0x80004284, goto 0x80004290
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           2683000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x1001efb0, 0 ~~> Byte[0x1001efb3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           2684000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x1001efb0, 0 ~~> Byte[0x1001efb2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           2686000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x1001efb0, 0 ~~> Byte[0x1001efb1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           2688000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x1001efb0, 0 ~~> Byte[0x1001efb0]
#; .Ltable (memset.S:85)
#;   ret
           2689000    0x800042a0 ret                            #; ra  = 0x80003f60, goto 0x80003f60
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
           2690000    0x80003f60 lw a0, 8(sp)                   #; sp  = 0x1001e310, a0  <~~ Word[0x1001e318]
           2693000                                              #; (lsu) a0  <-- 0x1001e35c
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
           2694000    0x80003f64 add a0, a0, s7                 #; a0  = 0x1001e35c, s7  = 4128, (wrb) a0  <-- 0x1001f37c
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
           2695000    0x80003f68 li a1, 0                       #; (wrb) a1  <-- 0
           2696000    0x80003f6c mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
           2697000    0x80003f70 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f70
           2698000    0x80003f74 jalr 668(ra)                   #; ra  = 0x80003f70, (wrb) ra  <-- 0x80003f78, goto 0x8000420c
#; memset (memset.S:30)
#;   li t1, 15
           2699000    0x8000420c li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
           2700000    0x80004210 mv a4, a0                      #; a0  = 0x1001f37c, (wrb) a4  <-- 0x1001f37c
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
           2701000    0x80004214 bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
           2702000    0x80004218 andi a5, a4, 15                #; a4  = 0x1001f37c, (wrb) a5  <-- 12
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
           2703000    0x8000421c bnez a5, 160                   #; a5  = 12, taken, goto 0x800042bc
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
           2704000    0x800042bc slli a3, a5, 2                 #; a5  = 12, (wrb) a3  <-- 48
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
           2705000    0x800042c0 auipc t0, 0                    #; (wrb) t0  <-- 0x800042c0
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
           2706000    0x800042c4 add a3, a3, t0                 #; a3  = 48, t0  = 0x800042c0, (wrb) a3  <-- 0x800042f0
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
           2707000    0x800042c8 mv t0, ra                      #; ra  = 0x80003f78, (wrb) t0  <-- 0x80003f78
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
           2708000    0x800042cc jalr -96(a3)                   #; a3  = 0x800042f0, (wrb) ra  <-- 0x800042d0, goto 0x80004290
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           2709000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x1001f37c, 0 ~~> Byte[0x1001f37f]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           2710000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x1001f37c, 0 ~~> Byte[0x1001f37e]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           2711000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x1001f37c, 0 ~~> Byte[0x1001f37d]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           2712000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x1001f37c, 0 ~~> Byte[0x1001f37c]
#; .Ltable (memset.S:85)
#;   ret
           2713000    0x800042a0 ret                            #; ra  = 0x800042d0, goto 0x800042d0
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           2714000    0x800042d0 mv ra, t0                      #; t0  = 0x80003f78, (wrb) ra  <-- 0x80003f78
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           2715000    0x800042d4 addi a5, a5, -16               #; a5  = 12, (wrb) a5  <-- -4
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           2716000    0x800042d8 sub a4, a4, a5                 #; a4  = 0x1001f37c, a5  = -4, (wrb) a4  <-- 0x1001f380
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           2717000    0x800042dc add a2, a2, a5                 #; a2  = 64, a5  = -4, (wrb) a2  <-- 60
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           2718000    0x800042e0 bgeu t1, a2, -144              #; t1  = 15, a2  = 60, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           2719000    0x800042e4 j -196                         #; goto 0x80004220
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           2720000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           2721000    0x80004224 andi a3, a2, -16               #; a2  = 60, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           2722000    0x80004228 andi a2, a2, 15                #; a2  = 60, (wrb) a2  <-- 12
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           2723000    0x8000422c add a3, a3, a4                 #; a3  = 48, a4  = 0x1001f380, (wrb) a3  <-- 0x1001f3b0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2724000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001f380, 0 ~~> Word[0x1001f380]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2725000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001f380, 0 ~~> Word[0x1001f384]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2726000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001f380, 0 ~~> Word[0x1001f388]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2727000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001f380, 0 ~~> Word[0x1001f38c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2728000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001f380, (wrb) a4  <-- 0x1001f390
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2729000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001f390, a3  = 0x1001f3b0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2730000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001f390, 0 ~~> Word[0x1001f390]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2731000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001f390, 0 ~~> Word[0x1001f394]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2732000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001f390, 0 ~~> Word[0x1001f398]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2733000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001f390, 0 ~~> Word[0x1001f39c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2734000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001f390, (wrb) a4  <-- 0x1001f3a0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2735000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001f3a0, a3  = 0x1001f3b0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2736000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001f3a0, 0 ~~> Word[0x1001f3a0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2737000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001f3a0, 0 ~~> Word[0x1001f3a4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2738000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001f3a0, 0 ~~> Word[0x1001f3a8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2739000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001f3a0, 0 ~~> Word[0x1001f3ac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2740000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001f3a0, (wrb) a4  <-- 0x1001f3b0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2741000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001f3b0, a3  = 0x1001f3b0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           2742000    0x80004248 bnez a2, 8                     #; a2  = 12, taken, goto 0x80004250
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
           2743000    0x80004250 sub a3, t1, a2                 #; t1  = 15, a2  = 12, (wrb) a3  <-- 3
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
           2744000    0x80004254 slli a3, a3, 2                 #; a3  = 3, (wrb) a3  <-- 12
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
           2745000    0x80004258 auipc t0, 0                    #; (wrb) t0  <-- 0x80004258
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
           2746000    0x8000425c add a3, a3, t0                 #; a3  = 12, t0  = 0x80004258, (wrb) a3  <-- 0x80004264
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
           2747000    0x80004260 jr 12(a3)                      #; a3  = 0x80004264, goto 0x80004270
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
           2748000    0x80004270 sb a1, 11(a4)                  #; a4  = 0x1001f3b0, 0 ~~> Byte[0x1001f3bb]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
           2749000    0x80004274 sb a1, 10(a4)                  #; a4  = 0x1001f3b0, 0 ~~> Byte[0x1001f3ba]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
           2750000    0x80004278 sb a1, 9(a4)                   #; a4  = 0x1001f3b0, 0 ~~> Byte[0x1001f3b9]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
           2751000    0x8000427c sb a1, 8(a4)                   #; a4  = 0x1001f3b0, 0 ~~> Byte[0x1001f3b8]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
           2752000    0x80004280 sb a1, 7(a4)                   #; a4  = 0x1001f3b0, 0 ~~> Byte[0x1001f3b7]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
           2753000    0x80004284 sb a1, 6(a4)                   #; a4  = 0x1001f3b0, 0 ~~> Byte[0x1001f3b6]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
           2754000    0x80004288 sb a1, 5(a4)                   #; a4  = 0x1001f3b0, 0 ~~> Byte[0x1001f3b5]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
           2755000    0x8000428c sb a1, 4(a4)                   #; a4  = 0x1001f3b0, 0 ~~> Byte[0x1001f3b4]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           2756000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x1001f3b0, 0 ~~> Byte[0x1001f3b3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           2757000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x1001f3b0, 0 ~~> Byte[0x1001f3b2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           2758000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x1001f3b0, 0 ~~> Byte[0x1001f3b1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           2759000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x1001f3b0, 0 ~~> Byte[0x1001f3b0]
#; .Ltable (memset.S:85)
#;   ret
           2760000    0x800042a0 ret                            #; ra  = 0x80003f78, goto 0x80003f78
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
           2761000    0x80003f78 lw a0, 8(sp)                   #; sp  = 0x1001e310, a0  <~~ Word[0x1001e318]
           2764000                                              #; (lsu) a0  <-- 0x1001e35c
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
           2765000    0x80003f7c add a0, a0, s8                 #; a0  = 0x1001e35c, s8  = 5160, (wrb) a0  <-- 0x1001f784
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
           2768000    0x80003f80 li a1, 0                       #; (wrb) a1  <-- 0
           2769000    0x80003f84 mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
           2770000    0x80003f88 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f88
           2771000    0x80003f8c jalr 644(ra)                   #; ra  = 0x80003f88, (wrb) ra  <-- 0x80003f90, goto 0x8000420c
#; memset (memset.S:30)
#;   li t1, 15
           2772000    0x8000420c li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
           2773000    0x80004210 mv a4, a0                      #; a0  = 0x1001f784, (wrb) a4  <-- 0x1001f784
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
           2774000    0x80004214 bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
           2775000    0x80004218 andi a5, a4, 15                #; a4  = 0x1001f784, (wrb) a5  <-- 4
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
           2776000    0x8000421c bnez a5, 160                   #; a5  = 4, taken, goto 0x800042bc
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
           2777000    0x800042bc slli a3, a5, 2                 #; a5  = 4, (wrb) a3  <-- 16
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
           2778000    0x800042c0 auipc t0, 0                    #; (wrb) t0  <-- 0x800042c0
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
           2779000    0x800042c4 add a3, a3, t0                 #; a3  = 16, t0  = 0x800042c0, (wrb) a3  <-- 0x800042d0
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
           2780000    0x800042c8 mv t0, ra                      #; ra  = 0x80003f90, (wrb) t0  <-- 0x80003f90
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
           2781000    0x800042cc jalr -96(a3)                   #; a3  = 0x800042d0, (wrb) ra  <-- 0x800042d0, goto 0x80004270
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
           2782000    0x80004270 sb a1, 11(a4)                  #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f78f]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
           2783000    0x80004274 sb a1, 10(a4)                  #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f78e]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
           2784000    0x80004278 sb a1, 9(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f78d]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
           2785000    0x8000427c sb a1, 8(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f78c]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
           2786000    0x80004280 sb a1, 7(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f78b]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
           2787000    0x80004284 sb a1, 6(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f78a]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
           2788000    0x80004288 sb a1, 5(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f789]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
           2789000    0x8000428c sb a1, 4(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f788]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           2790000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f787]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           2791000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f786]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           2792000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f785]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           2793000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f784]
#; .Ltable (memset.S:85)
#;   ret
           2794000    0x800042a0 ret                            #; ra  = 0x800042d0, goto 0x800042d0
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           2795000    0x800042d0 mv ra, t0                      #; t0  = 0x80003f90, (wrb) ra  <-- 0x80003f90
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           2796000    0x800042d4 addi a5, a5, -16               #; a5  = 4, (wrb) a5  <-- -12
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           2797000    0x800042d8 sub a4, a4, a5                 #; a4  = 0x1001f784, a5  = -12, (wrb) a4  <-- 0x1001f790
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           2798000    0x800042dc add a2, a2, a5                 #; a2  = 64, a5  = -12, (wrb) a2  <-- 52
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           2799000    0x800042e0 bgeu t1, a2, -144              #; t1  = 15, a2  = 52, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           2800000    0x800042e4 j -196                         #; goto 0x80004220
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           2801000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           2802000    0x80004224 andi a3, a2, -16               #; a2  = 52, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           2803000    0x80004228 andi a2, a2, 15                #; a2  = 52, (wrb) a2  <-- 4
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           2804000    0x8000422c add a3, a3, a4                 #; a3  = 48, a4  = 0x1001f790, (wrb) a3  <-- 0x1001f7c0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2805000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001f790, 0 ~~> Word[0x1001f790]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2806000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001f790, 0 ~~> Word[0x1001f794]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2807000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001f790, 0 ~~> Word[0x1001f798]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2808000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001f790, 0 ~~> Word[0x1001f79c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2809000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001f790, (wrb) a4  <-- 0x1001f7a0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2810000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001f7a0, a3  = 0x1001f7c0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2811000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001f7a0, 0 ~~> Word[0x1001f7a0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2812000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001f7a0, 0 ~~> Word[0x1001f7a4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2813000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001f7a0, 0 ~~> Word[0x1001f7a8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2814000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001f7a0, 0 ~~> Word[0x1001f7ac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2815000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001f7a0, (wrb) a4  <-- 0x1001f7b0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2816000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001f7b0, a3  = 0x1001f7c0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2817000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001f7b0, 0 ~~> Word[0x1001f7b0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2818000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001f7b0, 0 ~~> Word[0x1001f7b4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2819000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001f7b0, 0 ~~> Word[0x1001f7b8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2820000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001f7b0, 0 ~~> Word[0x1001f7bc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2821000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001f7b0, (wrb) a4  <-- 0x1001f7c0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2822000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001f7c0, a3  = 0x1001f7c0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           2823000    0x80004248 bnez a2, 8                     #; a2  = 4, taken, goto 0x80004250
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
           2824000    0x80004250 sub a3, t1, a2                 #; t1  = 15, a2  = 4, (wrb) a3  <-- 11
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
           2825000    0x80004254 slli a3, a3, 2                 #; a3  = 11, (wrb) a3  <-- 44
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
           2826000    0x80004258 auipc t0, 0                    #; (wrb) t0  <-- 0x80004258
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
           2827000    0x8000425c add a3, a3, t0                 #; a3  = 44, t0  = 0x80004258, (wrb) a3  <-- 0x80004284
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
           2828000    0x80004260 jr 12(a3)                      #; a3  = 0x80004284, goto 0x80004290
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           2829000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x1001f7c0, 0 ~~> Byte[0x1001f7c3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           2830000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x1001f7c0, 0 ~~> Byte[0x1001f7c2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           2831000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x1001f7c0, 0 ~~> Byte[0x1001f7c1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           2832000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x1001f7c0, 0 ~~> Byte[0x1001f7c0]
#; .Ltable (memset.S:85)
#;   ret
           2833000    0x800042a0 ret                            #; ra  = 0x80003f90, goto 0x80003f90
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
           2834000    0x80003f90 lw a0, 8(sp)                   #; sp  = 0x1001e310, a0  <~~ Word[0x1001e318]
           2837000                                              #; (lsu) a0  <-- 0x1001e35c
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
           2838000    0x80003f94 add a0, a0, s9                 #; a0  = 0x1001e35c, s9  = 6192, (wrb) a0  <-- 0x1001fb8c
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
           2839000    0x80003f98 li a1, 0                       #; (wrb) a1  <-- 0
           2840000    0x80003f9c mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
           2841000    0x80003fa0 auipc ra, 0                    #; (wrb) ra  <-- 0x80003fa0
           2842000    0x80003fa4 jalr 620(ra)                   #; ra  = 0x80003fa0, (wrb) ra  <-- 0x80003fa8, goto 0x8000420c
#; memset (memset.S:30)
#;   li t1, 15
           2843000    0x8000420c li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
           2844000    0x80004210 mv a4, a0                      #; a0  = 0x1001fb8c, (wrb) a4  <-- 0x1001fb8c
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
           2845000    0x80004214 bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
           2846000    0x80004218 andi a5, a4, 15                #; a4  = 0x1001fb8c, (wrb) a5  <-- 12
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
           2847000    0x8000421c bnez a5, 160                   #; a5  = 12, taken, goto 0x800042bc
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
           2848000    0x800042bc slli a3, a5, 2                 #; a5  = 12, (wrb) a3  <-- 48
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
           2849000    0x800042c0 auipc t0, 0                    #; (wrb) t0  <-- 0x800042c0
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
           2850000    0x800042c4 add a3, a3, t0                 #; a3  = 48, t0  = 0x800042c0, (wrb) a3  <-- 0x800042f0
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
           2851000    0x800042c8 mv t0, ra                      #; ra  = 0x80003fa8, (wrb) t0  <-- 0x80003fa8
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
           2852000    0x800042cc jalr -96(a3)                   #; a3  = 0x800042f0, (wrb) ra  <-- 0x800042d0, goto 0x80004290
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           2853000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x1001fb8c, 0 ~~> Byte[0x1001fb8f]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           2854000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x1001fb8c, 0 ~~> Byte[0x1001fb8e]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           2855000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x1001fb8c, 0 ~~> Byte[0x1001fb8d]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           2856000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x1001fb8c, 0 ~~> Byte[0x1001fb8c]
#; .Ltable (memset.S:85)
#;   ret
           2857000    0x800042a0 ret                            #; ra  = 0x800042d0, goto 0x800042d0
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           2858000    0x800042d0 mv ra, t0                      #; t0  = 0x80003fa8, (wrb) ra  <-- 0x80003fa8
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           2859000    0x800042d4 addi a5, a5, -16               #; a5  = 12, (wrb) a5  <-- -4
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           2860000    0x800042d8 sub a4, a4, a5                 #; a4  = 0x1001fb8c, a5  = -4, (wrb) a4  <-- 0x1001fb90
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           2861000    0x800042dc add a2, a2, a5                 #; a2  = 64, a5  = -4, (wrb) a2  <-- 60
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           2862000    0x800042e0 bgeu t1, a2, -144              #; t1  = 15, a2  = 60, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           2863000    0x800042e4 j -196                         #; goto 0x80004220
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           2864000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           2865000    0x80004224 andi a3, a2, -16               #; a2  = 60, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           2866000    0x80004228 andi a2, a2, 15                #; a2  = 60, (wrb) a2  <-- 12
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           2867000    0x8000422c add a3, a3, a4                 #; a3  = 48, a4  = 0x1001fb90, (wrb) a3  <-- 0x1001fbc0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2868000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001fb90, 0 ~~> Word[0x1001fb90]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2869000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001fb90, 0 ~~> Word[0x1001fb94]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2870000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001fb90, 0 ~~> Word[0x1001fb98]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2871000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001fb90, 0 ~~> Word[0x1001fb9c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2872000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001fb90, (wrb) a4  <-- 0x1001fba0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2873000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001fba0, a3  = 0x1001fbc0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2874000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001fba0, 0 ~~> Word[0x1001fba0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2875000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001fba0, 0 ~~> Word[0x1001fba4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2876000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001fba0, 0 ~~> Word[0x1001fba8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2877000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001fba0, 0 ~~> Word[0x1001fbac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2878000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001fba0, (wrb) a4  <-- 0x1001fbb0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2879000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001fbb0, a3  = 0x1001fbc0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2880000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001fbb0, 0 ~~> Word[0x1001fbb0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2881000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001fbb0, 0 ~~> Word[0x1001fbb4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2882000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001fbb0, 0 ~~> Word[0x1001fbb8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2883000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001fbb0, 0 ~~> Word[0x1001fbbc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2884000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001fbb0, (wrb) a4  <-- 0x1001fbc0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2885000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001fbc0, a3  = 0x1001fbc0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           2886000    0x80004248 bnez a2, 8                     #; a2  = 12, taken, goto 0x80004250
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
           2887000    0x80004250 sub a3, t1, a2                 #; t1  = 15, a2  = 12, (wrb) a3  <-- 3
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
           2888000    0x80004254 slli a3, a3, 2                 #; a3  = 3, (wrb) a3  <-- 12
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
           2889000    0x80004258 auipc t0, 0                    #; (wrb) t0  <-- 0x80004258
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
           2890000    0x8000425c add a3, a3, t0                 #; a3  = 12, t0  = 0x80004258, (wrb) a3  <-- 0x80004264
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
           2891000    0x80004260 jr 12(a3)                      #; a3  = 0x80004264, goto 0x80004270
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
           2892000    0x80004270 sb a1, 11(a4)                  #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbcb]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
           2893000    0x80004274 sb a1, 10(a4)                  #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbca]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
           2894000    0x80004278 sb a1, 9(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc9]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
           2895000    0x8000427c sb a1, 8(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc8]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
           2896000    0x80004280 sb a1, 7(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc7]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
           2897000    0x80004284 sb a1, 6(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc6]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
           2898000    0x80004288 sb a1, 5(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc5]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
           2899000    0x8000428c sb a1, 4(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc4]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           2900000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           2901000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           2902000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           2903000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc0]
#; .Ltable (memset.S:85)
#;   ret
           2904000    0x800042a0 ret                            #; ra  = 0x80003fa8, goto 0x80003fa8
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
           2905000    0x80003fa8 lw a0, 8(sp)                   #; sp  = 0x1001e310, a0  <~~ Word[0x1001e318]
           2908000                                              #; (lsu) a0  <-- 0x1001e35c
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
           2909000    0x80003fac add a0, a0, s10                #; a0  = 0x1001e35c, s10 = 7224, (wrb) a0  <-- 0x1001ff94
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
           2910000    0x80003fb0 li a1, 0                       #; (wrb) a1  <-- 0
           2911000    0x80003fb4 mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
           2912000    0x80003fb8 auipc ra, 0                    #; (wrb) ra  <-- 0x80003fb8
           2913000    0x80003fbc jalr 596(ra)                   #; ra  = 0x80003fb8, (wrb) ra  <-- 0x80003fc0, goto 0x8000420c
#; memset (memset.S:30)
#;   li t1, 15
           2914000    0x8000420c li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
           2915000    0x80004210 mv a4, a0                      #; a0  = 0x1001ff94, (wrb) a4  <-- 0x1001ff94
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
           2916000    0x80004214 bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
           2917000    0x80004218 andi a5, a4, 15                #; a4  = 0x1001ff94, (wrb) a5  <-- 4
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
           2918000    0x8000421c bnez a5, 160                   #; a5  = 4, taken, goto 0x800042bc
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
           2919000    0x800042bc slli a3, a5, 2                 #; a5  = 4, (wrb) a3  <-- 16
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
           2920000    0x800042c0 auipc t0, 0                    #; (wrb) t0  <-- 0x800042c0
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
           2921000    0x800042c4 add a3, a3, t0                 #; a3  = 16, t0  = 0x800042c0, (wrb) a3  <-- 0x800042d0
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
           2922000    0x800042c8 mv t0, ra                      #; ra  = 0x80003fc0, (wrb) t0  <-- 0x80003fc0
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
           2923000    0x800042cc jalr -96(a3)                   #; a3  = 0x800042d0, (wrb) ra  <-- 0x800042d0, goto 0x80004270
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
           2924000    0x80004270 sb a1, 11(a4)                  #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9f]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
           2925000    0x80004274 sb a1, 10(a4)                  #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9e]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
           2926000    0x80004278 sb a1, 9(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9d]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
           2927000    0x8000427c sb a1, 8(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9c]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
           2928000    0x80004280 sb a1, 7(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9b]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
           2929000    0x80004284 sb a1, 6(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9a]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
           2930000    0x80004288 sb a1, 5(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff99]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
           2931000    0x8000428c sb a1, 4(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff98]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           2932000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff97]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           2933000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff96]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           2934000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff95]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           2935000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff94]
#; .Ltable (memset.S:85)
#;   ret
           2936000    0x800042a0 ret                            #; ra  = 0x800042d0, goto 0x800042d0
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           2937000    0x800042d0 mv ra, t0                      #; t0  = 0x80003fc0, (wrb) ra  <-- 0x80003fc0
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           2938000    0x800042d4 addi a5, a5, -16               #; a5  = 4, (wrb) a5  <-- -12
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           2939000    0x800042d8 sub a4, a4, a5                 #; a4  = 0x1001ff94, a5  = -12, (wrb) a4  <-- 0x1001ffa0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           2940000    0x800042dc add a2, a2, a5                 #; a2  = 64, a5  = -12, (wrb) a2  <-- 52
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           2941000    0x800042e0 bgeu t1, a2, -144              #; t1  = 15, a2  = 52, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           2942000    0x800042e4 j -196                         #; goto 0x80004220
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           2943000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           2944000    0x80004224 andi a3, a2, -16               #; a2  = 52, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           2945000    0x80004228 andi a2, a2, 15                #; a2  = 52, (wrb) a2  <-- 4
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           2946000    0x8000422c add a3, a3, a4                 #; a3  = 48, a4  = 0x1001ffa0, (wrb) a3  <-- 0x1001ffd0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2947000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001ffa0, 0 ~~> Word[0x1001ffa0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2948000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001ffa0, 0 ~~> Word[0x1001ffa4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2949000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001ffa0, 0 ~~> Word[0x1001ffa8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2950000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001ffa0, 0 ~~> Word[0x1001ffac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2951000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001ffa0, (wrb) a4  <-- 0x1001ffb0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2952000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001ffb0, a3  = 0x1001ffd0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2953000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001ffb0, 0 ~~> Word[0x1001ffb0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2954000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001ffb0, 0 ~~> Word[0x1001ffb4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2955000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001ffb0, 0 ~~> Word[0x1001ffb8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2956000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001ffb0, 0 ~~> Word[0x1001ffbc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2957000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001ffb0, (wrb) a4  <-- 0x1001ffc0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2958000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001ffc0, a3  = 0x1001ffd0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2959000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001ffc0, 0 ~~> Word[0x1001ffc0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2960000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001ffc0, 0 ~~> Word[0x1001ffc4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2961000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001ffc0, 0 ~~> Word[0x1001ffc8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2962000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001ffc0, 0 ~~> Word[0x1001ffcc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2963000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001ffc0, (wrb) a4  <-- 0x1001ffd0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2964000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001ffd0, a3  = 0x1001ffd0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           2965000    0x80004248 bnez a2, 8                     #; a2  = 4, taken, goto 0x80004250
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
           2966000    0x80004250 sub a3, t1, a2                 #; t1  = 15, a2  = 4, (wrb) a3  <-- 11
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
           2967000    0x80004254 slli a3, a3, 2                 #; a3  = 11, (wrb) a3  <-- 44
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
           2968000    0x80004258 auipc t0, 0                    #; (wrb) t0  <-- 0x80004258
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
           2969000    0x8000425c add a3, a3, t0                 #; a3  = 44, t0  = 0x80004258, (wrb) a3  <-- 0x80004284
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
           2970000    0x80004260 jr 12(a3)                      #; a3  = 0x80004284, goto 0x80004290
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           2971000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x1001ffd0, 0 ~~> Byte[0x1001ffd3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           2972000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x1001ffd0, 0 ~~> Byte[0x1001ffd2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           2973000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x1001ffd0, 0 ~~> Byte[0x1001ffd1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           2974000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x1001ffd0, 0 ~~> Byte[0x1001ffd0]
#; .Ltable (memset.S:85)
#;   ret
           2975000    0x800042a0 ret                            #; ra  = 0x80003fc0, goto 0x80003fc0
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
           2978000    0x80003fc0 lw a0, 8(sp)                   #; sp  = 0x1001e310, a0  <~~ Word[0x1001e318]
           2981000                                              #; (lsu) a0  <-- 0x1001e35c
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
           2982000    0x80003fc4 add a0, a0, s11                #; a0  = 0x1001e35c, s11 = 8256, (wrb) a0  <-- 0x1002039c
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
           2983000    0x80003fc8 li a1, 0                       #; (wrb) a1  <-- 0
           2984000    0x80003fcc mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
           2985000    0x80003fd0 auipc ra, 0                    #; (wrb) ra  <-- 0x80003fd0
           2986000    0x80003fd4 jalr 572(ra)                   #; ra  = 0x80003fd0, (wrb) ra  <-- 0x80003fd8, goto 0x8000420c
#; memset (memset.S:30)
#;   li t1, 15
           2987000    0x8000420c li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
           2988000    0x80004210 mv a4, a0                      #; a0  = 0x1002039c, (wrb) a4  <-- 0x1002039c
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
           2989000    0x80004214 bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
           2990000    0x80004218 andi a5, a4, 15                #; a4  = 0x1002039c, (wrb) a5  <-- 12
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
           2991000    0x8000421c bnez a5, 160                   #; a5  = 12, taken, goto 0x800042bc
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
           2992000    0x800042bc slli a3, a5, 2                 #; a5  = 12, (wrb) a3  <-- 48
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
           2993000    0x800042c0 auipc t0, 0                    #; (wrb) t0  <-- 0x800042c0
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
           2994000    0x800042c4 add a3, a3, t0                 #; a3  = 48, t0  = 0x800042c0, (wrb) a3  <-- 0x800042f0
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
           2995000    0x800042c8 mv t0, ra                      #; ra  = 0x80003fd8, (wrb) t0  <-- 0x80003fd8
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
           2996000    0x800042cc jalr -96(a3)                   #; a3  = 0x800042f0, (wrb) ra  <-- 0x800042d0, goto 0x80004290
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           2997000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x1002039c, 0 ~~> Byte[0x1002039f]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           2998000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x1002039c, 0 ~~> Byte[0x1002039e]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           3020000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x1002039c, 0 ~~> Byte[0x1002039d]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           3060000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x1002039c, 0 ~~> Byte[0x1002039c]
#; .Ltable (memset.S:85)
#;   ret
           3061000    0x800042a0 ret                            #; ra  = 0x800042d0, goto 0x800042d0
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           3062000    0x800042d0 mv ra, t0                      #; t0  = 0x80003fd8, (wrb) ra  <-- 0x80003fd8
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           3063000    0x800042d4 addi a5, a5, -16               #; a5  = 12, (wrb) a5  <-- -4
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           3064000    0x800042d8 sub a4, a4, a5                 #; a4  = 0x1002039c, a5  = -4, (wrb) a4  <-- 0x100203a0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           3065000    0x800042dc add a2, a2, a5                 #; a2  = 64, a5  = -4, (wrb) a2  <-- 60
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           3066000    0x800042e0 bgeu t1, a2, -144              #; t1  = 15, a2  = 60, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           3067000    0x800042e4 j -196                         #; goto 0x80004220
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           3068000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           3069000    0x80004224 andi a3, a2, -16               #; a2  = 60, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           3070000    0x80004228 andi a2, a2, 15                #; a2  = 60, (wrb) a2  <-- 12
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           3071000    0x8000422c add a3, a3, a4                 #; a3  = 48, a4  = 0x100203a0, (wrb) a3  <-- 0x100203d0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           3100000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x100203a0, 0 ~~> Word[0x100203a0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           3140000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x100203a0, 0 ~~> Word[0x100203a4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           3180000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x100203a0, 0 ~~> Word[0x100203a8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           3220000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x100203a0, 0 ~~> Word[0x100203ac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           3221000    0x80004240 addi a4, a4, 16                #; a4  = 0x100203a0, (wrb) a4  <-- 0x100203b0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           3222000    0x80004244 bltu a4, a3, -20               #; a4  = 0x100203b0, a3  = 0x100203d0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           3260000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x100203b0, 0 ~~> Word[0x100203b0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           3300000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x100203b0, 0 ~~> Word[0x100203b4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           3340000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x100203b0, 0 ~~> Word[0x100203b8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           3380000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x100203b0, 0 ~~> Word[0x100203bc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           3381000    0x80004240 addi a4, a4, 16                #; a4  = 0x100203b0, (wrb) a4  <-- 0x100203c0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           3382000    0x80004244 bltu a4, a3, -20               #; a4  = 0x100203c0, a3  = 0x100203d0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           3420000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x100203c0, 0 ~~> Word[0x100203c0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           3460000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x100203c0, 0 ~~> Word[0x100203c4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           3500000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x100203c0, 0 ~~> Word[0x100203c8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           3540000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x100203c0, 0 ~~> Word[0x100203cc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           3541000    0x80004240 addi a4, a4, 16                #; a4  = 0x100203c0, (wrb) a4  <-- 0x100203d0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           3542000    0x80004244 bltu a4, a3, -20               #; a4  = 0x100203d0, a3  = 0x100203d0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           3543000    0x80004248 bnez a2, 8                     #; a2  = 12, taken, goto 0x80004250
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
           3544000    0x80004250 sub a3, t1, a2                 #; t1  = 15, a2  = 12, (wrb) a3  <-- 3
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
           3545000    0x80004254 slli a3, a3, 2                 #; a3  = 3, (wrb) a3  <-- 12
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
           3546000    0x80004258 auipc t0, 0                    #; (wrb) t0  <-- 0x80004258
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
           3547000    0x8000425c add a3, a3, t0                 #; a3  = 12, t0  = 0x80004258, (wrb) a3  <-- 0x80004264
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
           3548000    0x80004260 jr 12(a3)                      #; a3  = 0x80004264, goto 0x80004270
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
           3580000    0x80004270 sb a1, 11(a4)                  #; a4  = 0x100203d0, 0 ~~> Byte[0x100203db]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
           3620000    0x80004274 sb a1, 10(a4)                  #; a4  = 0x100203d0, 0 ~~> Byte[0x100203da]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
           3660000    0x80004278 sb a1, 9(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d9]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
           3700000    0x8000427c sb a1, 8(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d8]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
           3740000    0x80004280 sb a1, 7(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d7]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
           3780000    0x80004284 sb a1, 6(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d6]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
           3820000    0x80004288 sb a1, 5(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d5]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
           3860000    0x8000428c sb a1, 4(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d4]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           3900000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           3940000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           3980000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           4020000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d0]
#; .Ltable (memset.S:85)
#;   ret
           4021000    0x800042a0 ret                            #; ra  = 0x80003fd8, goto 0x80003fd8
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:85:5)
#;     snrt_cluster_hw_barrier (sync.h:174:5)
#;       asm volatile("csrr x0, 0x7C2" ::: "memory");
#;       ^
           4022000    0x80003fd8 csrr zero, 1986                #; csr@7c2 = 0
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
           7346000    0x80003ffc beqz s4, 84                    #; s4  = 0, taken, goto 0x80004050
#; .LBB25_14 (start.c:235:5)
#;   snrt_init_cls (start.c:182:14)
#;     _cls_ptr = (cls_t*)snrt_cls_base_addr();
#;              ^
           7358000    0x80004050 sub a0, s7, s0                 #; s7  = 0x80005d98, s0  = 0x80005d98, (wrb) a0  <-- 0
           7359000    0x80004054 add a0, a0, s8                 #; a0  = 0, s8  = 0x80005db8, (wrb) a0  <-- 0x80005db8
           7360000    0x80004058 sub a0, s6, a0                 #; s6  = 0x80005d98, a0  = 0x80005db8, (wrb) a0  <-- -32
           7361000    0x8000405c lui a2, 65568                  #; (wrb) a2  <-- 0x10020000
           7362000    0x80004060 add a1, a0, a2                 #; a0  = -32, a2  = 0x10020000, (wrb) a1  <-- 0x1001ffe0
           7363000    0x80004064 lui a3, 0                      #; (wrb) a3  <-- 0
           7364000    0x80004068 add s0, a3, tp                 #; a3  = 0, tp  = 0x1001e350, (wrb) s0  <-- 0x1001e350
           7365000    0x8000406c sw a1, 64(s0)                  #; s0  = 0x1001e350, 0x1001ffe0 ~~> Word[0x1001e390]
#; .LBB25_14 (start.c:235:5)
#;   snrt_init_cls (start.c:183:5)
#;     snrt_cluster_hw_barrier (sync.h:174:5)
#;       asm volatile("csrr x0, 0x7C2" ::: "memory");
#;       ^
           7366000    0x80004070 csrr zero, 1986                #; csr@7c2 = 0
           7406000    0x80004074 li a3, 8                       #; (wrb) a3  <-- 8
           7407000    0x80004078 auipc a1, 4                    #; (wrb) a1  <-- 0x80008078
           7408000    0x8000407c addi a1, a1, 1200              #; a1  = 0x80008078, (wrb) a1  <-- 0x80008528
#; .LBB25_31 (start.c:243:5)
#;   snrt_init_libs (start.c:189:5)
#;     snrt_alloc_init (alloc.h:113:9)
#;       if (snrt_is_dm_core()) {
#;           ^
           7419000    0x80004080 bltu s5, a3, 84                #; s5  = 7, a3  = 8, taken, goto 0x800040d4
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
           7456000    0x800040e4 add a3, a3, tp                 #; a3  = 0, tp  = 0x1001e350, (wrb) a3  <-- 0x1001e350
           7457000    0x800040e8 sw zero, 20(a3)                #; a3  = 0x1001e350, 0 ~~> Word[0x1001e364]
           7458000    0x800040ec sw a2, 16(a3)                  #; a3  = 0x1001e350, 0x10000000 ~~> Word[0x1001e360]
           7459000    0x800040f0 addi a3, a3, 16                #; a3  = 0x1001e350, (wrb) a3  <-- 0x1001e360
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:190:5)
#;     snrt_l1_init (alloc_v2.h:119:33)
#;       snrt_l1_allocator_v2()->end = heap_end_addr;
#;                                   ^
           7460000    0x800040f4 sw zero, 12(a3)                #; a3  = 0x1001e360, 0 ~~> Word[0x1001e36c]
           7461000    0x800040f8 lui a4, 65566                  #; (wrb) a4  <-- 0x1001e000
           7462000    0x800040fc addi a4, a4, -1152             #; a4  = 0x1001e000, (wrb) a4  <-- 0x1001db80
           7473000    0x80004100 add a0, a0, a4                 #; a0  = -32, a4  = 0x1001db80, (wrb) a0  <-- 0x1001db60
           7474000    0x80004104 sw a0, 8(a3)                   #; a3  = 0x1001e360, 0x1001db60 ~~> Word[0x1001e368]
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:190:5)
#;     snrt_l1_init (alloc_v2.h:120:34)
#;       snrt_l1_allocator_v2()->next = snrt_l1_allocator_v2()->base;
#;                                    ^
           7475000    0x80004108 sw zero, 20(a3)                #; a3  = 0x1001e360, 0 ~~> Word[0x1001e374]
           7476000    0x8000410c sw a2, 16(a3)                  #; a3  = 0x1001e360, 0x10000000 ~~> Word[0x1001e370]
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:191:5)
#;     snrt_l3_init (alloc_v2.h:184:34)
#;       snrt_l3_allocator_v2()->base =
#;                                    ^
           7477000    0x80004110 lui a0, 0                      #; (wrb) a0  <-- 0
           7478000    0x80004114 add a0, a0, tp                 #; a0  = 0, tp  = 0x1001e350, (wrb) a0  <-- 0x1001e350
           7479000    0x80004118 sw zero, 44(a0)                #; a0  = 0x1001e350, 0 ~~> Word[0x1001e37c]
           7480000    0x8000411c addi a1, a1, 7                 #; a1  = 0x80008528, (wrb) a1  <-- 0x8000852f
           7481000    0x80004120 andi a1, a1, -8                #; a1  = 0x8000852f, (wrb) a1  <-- 0x80008528
           7482000    0x80004124 sw a1, 40(a0)                  #; a0  = 0x1001e350, 0x80008528 ~~> Word[0x1001e378]
           7483000    0x80004128 addi a0, a0, 40                #; a0  = 0x1001e350, (wrb) a0  <-- 0x1001e378
           7484000    0x8000412c li a2, 1                       #; (wrb) a2  <-- 1
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:191:5)
#;     snrt_l3_init (alloc_v2.h:186:33)
#;       snrt_l3_allocator_v2()->end = SNRT_L3_END_ADDR;
#;                                   ^
           7485000    0x80004130 sw a2, 12(a0)                  #; a0  = 0x1001e378, 1 ~~> Word[0x1001e384]
           7486000    0x80004134 sw zero, 8(a0)                 #; a0  = 0x1001e378, 0 ~~> Word[0x1001e380]
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:191:5)
#;     snrt_l3_init (alloc_v2.h:187:34)
#;       snrt_l3_allocator_v2()->next = snrt_l3_allocator_v2()->base;
#;                                    ^
           7487000    0x80004138 sw zero, 20(a0)                #; a0  = 0x1001e378, 0 ~~> Word[0x1001e38c]
           7488000    0x8000413c sw a1, 16(a0)                  #; a0  = 0x1001e378, 0x80008528 ~~> Word[0x1001e388]
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:192:5)
#;     snrt_comm_init (sync.h:37:48)
#;       inline void snrt_comm_init() { snrt_comm_world = &snrt_comm_world_info; }
#;                                                      ^
           7499000    0x80004140 lui a0, 0                      #; (wrb) a0  <-- 0
           7500000    0x80004144 add a0, a0, tp                 #; a0  = 0, tp  = 0x1001e350, (wrb) a0  <-- 0x1001e350
           7501000    0x80004148 lui a1, 0                      #; (wrb) a1  <-- 0
           7502000    0x8000414c add a1, a1, tp                 #; a1  = 0, tp  = 0x1001e350, (wrb) a1  <-- 0x1001e350
           7503000    0x80004150 mv a1, a1                      #; a1  = 0x1001e350, (wrb) a1  <-- 0x1001e350
           7504000    0x80004154 sw a1, 76(a0)                  #; a0  = 0x1001e350, 0x1001e350 ~~> Word[0x1001e39c]
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
           7511000    0x800001cc addi sp, sp, -48               #; sp  = 0x1001e310, (wrb) sp  <-- 0x1001e2e0
#; main (xpulp_vect.c:6:5)
#;   snrt_cluster_hw_barrier (sync.h:174:5)
#;     asm volatile("csrr x0, 0x7C2" ::: "memory");
#;     ^
           7512000    0x800001d0 sw s0, 44(sp)                  #; sp  = 0x1001e2e0, 0x1001e350 ~~> Word[0x1001e30c]
           7513000    0x800001d4 sw s1, 40(sp)                  #; sp  = 0x1001e2e0, 2064 ~~> Word[0x1001e308]
           7514000    0x800001d8 sw s2, 36(sp)                  #; sp  = 0x1001e2e0, 7 ~~> Word[0x1001e304]
           7515000    0x800001dc sw s3, 32(sp)                  #; sp  = 0x1001e2e0, 0 ~~> Word[0x1001e300]
           7517000    0x800001e0 sw s4, 28(sp)                  #; sp  = 0x1001e2e0, 0 ~~> Word[0x1001e2fc]
           7518000    0x800001e4 sw s5, 24(sp)                  #; sp  = 0x1001e2e0, 7 ~~> Word[0x1001e2f8]
           7519000    0x800001e8 sw s6, 20(sp)                  #; sp  = 0x1001e2e0, 0x80005d98 ~~> Word[0x1001e2f4]
           7520000    0x800001ec sw s7, 16(sp)                  #; sp  = 0x1001e2e0, 0x80005d98 ~~> Word[0x1001e2f0]
           7521000    0x800001f0 sw s8, 12(sp)                  #; sp  = 0x1001e2e0, 0x80005db8 ~~> Word[0x1001e2ec]
           7522000    0x800001f4 csrr zero, 1986                #; csr@7c2 = 0
#; main (xpulp_vect.c:5:18)
#;   snrt_global_core_idx (team.h:80:12)
#;     snrt_hartid (team.h:25:5)
#;       asm("csrr %0, mhartid" : "=r"(hartid));
#;       ^
           7531000    0x800001f8 csrr a0, mhartid               #; mhartid = 7, (wrb) a0  <-- 7
           7532000    0x800001fc li a1, 2                       #; (wrb) a1  <-- 2
#; main (xpulp_vect.c:7:9)
#;   if (i == 2) {
#;       ^
           7543000    0x80000200 bne a0, a1, 3456               #; a0  = 7, a1  = 2, taken, goto 0x80000f80
           7554000    0x80000f80 li a0, 0                       #; (wrb) a0  <-- 0
#; .LBB0_5 (xpulp_vect.c:1310:1)
#;   }
#;   ^
           7555000    0x80000f84 lw s0, 44(sp)                  #; sp  = 0x1001e2e0, s0  <~~ Word[0x1001e30c]
           7556000    0x80000f88 lw s1, 40(sp)                  #; sp  = 0x1001e2e0, s1  <~~ Word[0x1001e308]
           7557000    0x80000f8c lw s2, 36(sp)                  #; sp  = 0x1001e2e0, s2  <~~ Word[0x1001e304]
           7558000    0x80000f90 lw s3, 32(sp)                  #; sp  = 0x1001e2e0, s3  <~~ Word[0x1001e300], (lsu) s0  <-- 0x1001e350
           7559000    0x80000f94 lw s4, 28(sp)                  #; sp  = 0x1001e2e0, s4  <~~ Word[0x1001e2fc], (lsu) s1  <-- 2064
           7560000    0x80000f98 lw s5, 24(sp)                  #; sp  = 0x1001e2e0, s5  <~~ Word[0x1001e2f8], (lsu) s2  <-- 7
           7561000    0x80000f9c lw s6, 20(sp)                  #; sp  = 0x1001e2e0, s6  <~~ Word[0x1001e2f4], (lsu) s3  <-- 0
           7562000    0x80000fa0 lw s7, 16(sp)                  #; sp  = 0x1001e2e0, s7  <~~ Word[0x1001e2f0], (lsu) s4  <-- 0
           7563000    0x80000fa4 lw s8, 12(sp)                  #; sp  = 0x1001e2e0, s8  <~~ Word[0x1001e2ec], (lsu) s5  <-- 7
           7564000    0x80000fa8 addi sp, sp, 48                #; sp  = 0x1001e2e0, (wrb) sp  <-- 0x1001e310
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
           9094000    0x80004168 lw a1, 64(s0)                  #; s0  = 0x1001e350, a1  <~~ Word[0x1001e390]
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
           9126000                                              #; (lsu) a0  <-- 6
#; .LBB25_16 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:297:5)
#;         snrt_wait_writeback (sync.h:404:5)
#;           asm volatile("mv %0, %0" : "+r"(val)::);
#;           ^
           9127000    0x80004174 mv a0, a0                      #; a0  = 6, (wrb) a0  <-- 6
#; .LBB25_16 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:298:5)
#;         snrt_cluster_hw_barrier (sync.h:174:5)
#;           asm volatile("csrr x0, 0x7C2" ::: "memory");
#;           ^
           9128000    0x80004178 csrr zero, 1986                #; csr@7c2 = 0
#; .LBB25_16 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:300:9)
#;         if (snrt_cluster_core_idx() == 0) {
#;             ^
           9130000    0x8000417c beqz s4, 72                    #; s4  = 0, taken, goto 0x800041c4
#; .LBB25_19 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:304:5)
#;         snrt_global_barrier (sync.h:218:5)
#;           snrt_cluster_hw_barrier (sync.h:174:5)
#;             asm volatile("csrr x0, 0x7C2" ::: "memory");
#;             ^
           9141000    0x800041c4 csrr zero, 1986                #; csr@7c2 = 0
#; .LBB25_19 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:304:5)
#;         snrt_global_barrier (sync.h:230:5)
#;           snrt_cluster_hw_barrier (sync.h:174:5)
#;             asm volatile("csrr x0, 0x7C2" ::: "memory");
#;             ^
           9155000    0x800041c8 csrr zero, 1986                #; csr@7c2 = 0
#; .LBB25_19 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:308:5)
#;         snrt_cluster_hw_barrier (sync.h:174:5)
#;           asm volatile("csrr x0, 0x7C2" ::: "memory");
#;           ^
           9157000    0x800041cc csrr zero, 1986                #; csr@7c2 = 0
#; .LBB25_20 (start.c:282:1)
#;   }
#;   ^
           9183000    0x800041d0 lw ra, 60(sp)                  #; sp  = 0x1001e310, ra  <~~ Word[0x1001e34c]
           9184000    0x800041d4 lw s0, 56(sp)                  #; sp  = 0x1001e310, s0  <~~ Word[0x1001e348]
           9185000    0x800041d8 lw s1, 52(sp)                  #; sp  = 0x1001e310, s1  <~~ Word[0x1001e344]
           9186000    0x800041dc lw s2, 48(sp)                  #; sp  = 0x1001e310, s2  <~~ Word[0x1001e340], (lsu) ra  <-- 0x800001c4
           9187000    0x800041e0 lw s3, 44(sp)                  #; sp  = 0x1001e310, s3  <~~ Word[0x1001e33c], (lsu) s0  <-- 0
           9188000    0x800041e4 lw s4, 40(sp)                  #; sp  = 0x1001e310, s4  <~~ Word[0x1001e338], (lsu) s1  <-- 0
           9189000    0x800041e8 lw s5, 36(sp)                  #; sp  = 0x1001e310, s5  <~~ Word[0x1001e334], (lsu) s2  <-- 0
           9190000    0x800041ec lw s6, 32(sp)                  #; sp  = 0x1001e310, s6  <~~ Word[0x1001e330], (lsu) s3  <-- 0
           9191000    0x800041f0 lw s7, 28(sp)                  #; sp  = 0x1001e310, s7  <~~ Word[0x1001e32c], (lsu) s4  <-- 0
           9192000    0x800041f4 lw s8, 24(sp)                  #; sp  = 0x1001e310, s8  <~~ Word[0x1001e328], (lsu) s5  <-- 0
           9193000    0x800041f8 lw s9, 20(sp)                  #; sp  = 0x1001e310, s9  <~~ Word[0x1001e324], (lsu) s6  <-- 0
           9194000    0x800041fc lw s10, 16(sp)                 #; sp  = 0x1001e310, s10 <~~ Word[0x1001e320], (lsu) s7  <-- 0
           9195000                                              #; (lsu) s8  <-- 0
           9196000                                              #; (lsu) s9  <-- 0
           9197000                                              #; (lsu) s10 <-- 0
           9205000    0x80004200 lw s11, 12(sp)                 #; sp  = 0x1001e310, s11 <~~ Word[0x1001e31c]
           9206000    0x80004204 addi sp, sp, 64                #; sp  = 0x1001e310, (wrb) sp  <-- 0x1001e350
           9207000    0x80004208 ret                            #; ra  = 0x800001c4, goto 0x800001c4
           9208000                                              #; (lsu) s11 <-- 0
#; .Ltmp2 (start.S:183)
#;   wfi
           9219000    0x800001c4 wfi                            #; 

## Performance metrics

Performance metrics for section 0 @ (17, 9217):
tstart                                          19
snitch_loads                                    92
snitch_stores                                  351
tend                                          9219
fpss_loads                                       0
snitch_avg_load_latency                        6.5
snitch_occupancy                            0.1579
snitch_fseq_rel_offloads                   0.02155
fseq_yield                                     1.0
fseq_fpu_yield                                 1.0
fpss_section_latency                             0
fpss_avg_fpu_latency                           2.0
fpss_avg_load_latency                            0
fpss_occupancy                            0.003478
fpss_fpu_occupancy                        0.003478
fpss_fpu_rel_occupancy                         1.0
cycles                                        9201
total_ipc                                   0.1614
