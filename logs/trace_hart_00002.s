             12000    0x18020000 auipc t0, 0                    #; (wrb) t0  <-- 0x18020000
             25000    0x18020004 addi t0, t0, 32                #; t0  = 0x18020000, (wrb) t0  <-- 0x18020020
             40000    0x18020008 csrw mtvec, t0                 #; t0  = 0x18020020
             53000    0x1802000c csrsi mstatus, 8               #; mstatus = 0x80006000
             66000    0x18020010 lui t0, 128                    #; (wrb) t0  <-- 0x00080000
             79000    0x18020014 addi t0, t0, 8                 #; t0  = 0x00080000, (wrb) t0  <-- 0x00080008
             94000    0x18020018 csrw mie, t0                   #; t0  = 0x00080008
            107000    0x1802001c wfi                            #; 
            326000    0x18020020 auipc t0, 0                    #; exception, goto 0x18020020
            341000    0x18020020 auipc t0, 0                    #; (wrb) t0  <-- 0x18020020
            354000    0x18020024 lui t1, 1                      #; (wrb) t1  <-- 4096
            367000    0x18020028 addi t1, t1, 360               #; t1  = 4096, (wrb) t1  <-- 4456
            380000    0x1802002c add t0, t0, t1                 #; t0  = 0x18020020, t1  = 4456, (wrb) t0  <-- 0x18021188
            395000    0x18020030 lw t0, 0(t0)                   #; t0  = 0x18021188, t0  <~~ Word[0x18021188]
            409000                                              #; (lsu) t0  <-- 0x80000000
            424000    0x18020034 jalr t0                        #; t0  = 0x80000000, (wrb) ra  <-- 0x18020038, goto 0x80000000
#; _start (start.S:12)
#;   mv t0, x0
            429000    0x80000000 li t0, 0                       #; (wrb) t0  <-- 0
#; _start (start.S:13)
#;   mv t1, x0
            430000    0x80000004 li t1, 0                       #; (wrb) t1  <-- 0
#; _start (start.S:14)
#;   mv t2, x0
            431000    0x80000008 li t2, 0                       #; (wrb) t2  <-- 0
#; _start (start.S:15)
#;   mv t3, x0
            432000    0x8000000c li t3, 0                       #; (wrb) t3  <-- 0
#; _start (start.S:16)
#;   mv t4, x0
            433000    0x80000010 li t4, 0                       #; (wrb) t4  <-- 0
#; _start (start.S:17)
#;   mv t5, x0
            434000    0x80000014 li t5, 0                       #; (wrb) t5  <-- 0
#; _start (start.S:18)
#;   mv t6, x0
            435000    0x80000018 li t6, 0                       #; (wrb) t6  <-- 0
#; _start (start.S:19)
#;   mv a0, x0
            436000    0x8000001c li a0, 0                       #; (wrb) a0  <-- 0
#; _start (start.S:20)
#;   mv a1, x0
            437000    0x80000020 li a1, 0                       #; (wrb) a1  <-- 0
#; _start (start.S:21)
#;   mv a2, x0
            438000    0x80000024 li a2, 0                       #; (wrb) a2  <-- 0
#; _start (start.S:22)
#;   mv a3, x0
            439000    0x80000028 li a3, 0                       #; (wrb) a3  <-- 0
#; _start (start.S:23)
#;   mv a4, x0
            440000    0x8000002c li a4, 0                       #; (wrb) a4  <-- 0
#; _start (start.S:24)
#;   mv a5, x0
            441000    0x80000030 li a5, 0                       #; (wrb) a5  <-- 0
#; _start (start.S:25)
#;   mv a6, x0
            442000    0x80000034 li a6, 0                       #; (wrb) a6  <-- 0
#; _start (start.S:26)
#;   mv a7, x0
            443000    0x80000038 li a7, 0                       #; (wrb) a7  <-- 0
#; _start (start.S:27)
#;   mv s0, x0
            444000    0x8000003c li s0, 0                       #; (wrb) s0  <-- 0
#; _start (start.S:28)
#;   mv s1, x0
            445000    0x80000040 li s1, 0                       #; (wrb) s1  <-- 0
#; _start (start.S:29)
#;   mv s2, x0
            446000    0x80000044 li s2, 0                       #; (wrb) s2  <-- 0
#; _start (start.S:30)
#;   mv s3, x0
            447000    0x80000048 li s3, 0                       #; (wrb) s3  <-- 0
#; _start (start.S:31)
#;   mv s4, x0
            448000    0x8000004c li s4, 0                       #; (wrb) s4  <-- 0
#; _start (start.S:32)
#;   mv s5, x0
            449000    0x80000050 li s5, 0                       #; (wrb) s5  <-- 0
#; _start (start.S:33)
#;   mv s6, x0
            450000    0x80000054 li s6, 0                       #; (wrb) s6  <-- 0
#; _start (start.S:34)
#;   mv s7, x0
            451000    0x80000058 li s7, 0                       #; (wrb) s7  <-- 0
#; _start (start.S:35)
#;   mv s8, x0
            452000    0x8000005c li s8, 0                       #; (wrb) s8  <-- 0
#; _start (start.S:36)
#;   mv s9, x0
            453000    0x80000060 li s9, 0                       #; (wrb) s9  <-- 0
#; _start (start.S:37)
#;   mv s10, x0
            454000    0x80000064 li s10, 0                      #; (wrb) s10 <-- 0
#; _start (start.S:38)
#;   mv s11, x0
            455000    0x80000068 li s11, 0                      #; (wrb) s11 <-- 0
#; snrt.crt0.init_fp_registers (start.S:44)
#;   csrr    t0, misa
            456000    0x8000006c csrr t0, misa                  #; misa = 0x40801129, (wrb) t0  <-- 0x40801129
#; snrt.crt0.init_fp_registers (start.S:45)
#;   andi    t0, t0, (1 << 3) | (1 << 5) # D/F - single/double precision float extension
            457000    0x80000070 andi t0, t0, 40                #; t0  = 0x40801129, (wrb) t0  <-- 40
#; snrt.crt0.init_fp_registers (start.S:46)
#;   beqz    t0, 3f
            458000    0x80000074 beqz t0, 132                   #; t0  = 40, not taken
#; snrt.crt0.init_fp_registers (start.S:48)
#;   fcvt.d.w f0, zero
            460000    0x80000078 fcvt.d.w ft0, zero             #; ac1  = 0
#; snrt.crt0.init_fp_registers (start.S:49)
#;   fcvt.d.w f1, zero
            461000    0x8000007c fcvt.d.w ft1, zero             #; ac1  = 0
#; snrt.crt0.init_fp_registers (start.S:50)
#;   fcvt.d.w f2, zero
            462000    0x80000080 fcvt.d.w ft2, zero             #; ac1  = 0, (f:fpu) ft0  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:51)
#;   fcvt.d.w f3, zero
            463000    0x80000084 fcvt.d.w ft3, zero             #; ac1  = 0, (f:fpu) ft1  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:52)
#;   fcvt.d.w f4, zero
            464000    0x80000088 fcvt.d.w ft4, zero             #; ac1  = 0, (f:fpu) ft2  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:53)
#;   fcvt.d.w f5, zero
            465000    0x8000008c fcvt.d.w ft5, zero             #; ac1  = 0, (f:fpu) ft3  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:54)
#;   fcvt.d.w f6, zero
            466000    0x80000090 fcvt.d.w ft6, zero             #; ac1  = 0, (f:fpu) ft4  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:55)
#;   fcvt.d.w f7, zero
            467000    0x80000094 fcvt.d.w ft7, zero             #; ac1  = 0, (f:fpu) ft5  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:56)
#;   fcvt.d.w f8, zero
            468000    0x80000098 fcvt.d.w fs0, zero             #; ac1  = 0, (f:fpu) ft6  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:57)
#;   fcvt.d.w f9, zero
            469000    0x8000009c fcvt.d.w fs1, zero             #; ac1  = 0, (f:fpu) ft7  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:58)
#;   fcvt.d.w f10, zero
            470000    0x800000a0 fcvt.d.w fa0, zero             #; ac1  = 0, (f:fpu) fs0  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:59)
#;   fcvt.d.w f11, zero
            471000    0x800000a4 fcvt.d.w fa1, zero             #; ac1  = 0, (f:fpu) fs1  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:60)
#;   fcvt.d.w f12, zero
            472000    0x800000a8 fcvt.d.w fa2, zero             #; ac1  = 0, (f:fpu) fa0  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:61)
#;   fcvt.d.w f13, zero
            473000    0x800000ac fcvt.d.w fa3, zero             #; ac1  = 0, (f:fpu) fa1  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:62)
#;   fcvt.d.w f14, zero
            474000    0x800000b0 fcvt.d.w fa4, zero             #; ac1  = 0, (f:fpu) fa2  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:63)
#;   fcvt.d.w f15, zero
            475000    0x800000b4 fcvt.d.w fa5, zero             #; ac1  = 0, (f:fpu) fa3  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:64)
#;   fcvt.d.w f16, zero
            476000    0x800000b8 fcvt.d.w fa6, zero             #; ac1  = 0, (f:fpu) fa4  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:65)
#;   fcvt.d.w f17, zero
            477000    0x800000bc fcvt.d.w fa7, zero             #; ac1  = 0, (f:fpu) fa5  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:66)
#;   fcvt.d.w f18, zero
            478000    0x800000c0 fcvt.d.w fs2, zero             #; ac1  = 0, (f:fpu) fa6  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:67)
#;   fcvt.d.w f19, zero
            479000    0x800000c4 fcvt.d.w fs3, zero             #; ac1  = 0, (f:fpu) fa7  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:68)
#;   fcvt.d.w f20, zero
            480000    0x800000c8 fcvt.d.w fs4, zero             #; ac1  = 0, (f:fpu) fs2  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:69)
#;   fcvt.d.w f21, zero
            481000    0x800000cc fcvt.d.w fs5, zero             #; ac1  = 0, (f:fpu) fs3  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:70)
#;   fcvt.d.w f22, zero
            482000    0x800000d0 fcvt.d.w fs6, zero             #; ac1  = 0, (f:fpu) fs4  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:71)
#;   fcvt.d.w f23, zero
            483000    0x800000d4 fcvt.d.w fs7, zero             #; ac1  = 0, (f:fpu) fs5  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:72)
#;   fcvt.d.w f24, zero
            484000    0x800000d8 fcvt.d.w fs8, zero             #; ac1  = 0, (f:fpu) fs6  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:73)
#;   fcvt.d.w f25, zero
            485000    0x800000dc fcvt.d.w fs9, zero             #; ac1  = 0, (f:fpu) fs7  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:74)
#;   fcvt.d.w f26, zero
            486000    0x800000e0 fcvt.d.w fs10, zero            #; ac1  = 0, (f:fpu) fs8  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:75)
#;   fcvt.d.w f27, zero
            487000    0x800000e4 fcvt.d.w fs11, zero            #; ac1  = 0, (f:fpu) fs9  <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:76)
#;   fcvt.d.w f28, zero
            488000    0x800000e8 fcvt.d.w ft8, zero             #; ac1  = 0, (f:fpu) fs10 <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:77)
#;   fcvt.d.w f29, zero
            489000    0x800000ec fcvt.d.w ft9, zero             #; ac1  = 0, (f:fpu) fs11 <-- 0.0
#; snrt.crt0.init_fp_registers (start.S:78)
#;   fcvt.d.w f30, zero
            490000    0x800000f0 fcvt.d.w ft10, zero            #; ac1  = 0, (f:fpu) ft8  <-- 0.0
#; .Ltmp1 (start.S:88)
#;   1:  auipc   gp, %pcrel_hi(__global_pointer$)
            491000    0x800000f8 auipc gp, 6                    #; (wrb) gp  <-- 0x800060f8
#; snrt.crt0.init_fp_registers (start.S:79)
#;   fcvt.d.w f31, zero
                      0x800000f4 fcvt.d.w ft11, zero            #; ac1  = 0, (f:fpu) ft9  <-- 0.0
#; .Ltmp1 (start.S:89)
#;   addi    gp, gp, %pcrel_lo(1b)
            492000    0x800000fc addi gp, gp, 1200              #; gp  = 0x800060f8, (wrb) gp  <-- 0x800065a8
                                                                #; (f:fpu) ft10 <-- 0.0
#; snrt.crt0.init_core_info (start.S:98)
#;   csrr a0, mhartid
            493000    0x80000100 csrr a0, mhartid               #; mhartid = 2, (wrb) a0  <-- 2
                                                                #; (f:fpu) ft11 <-- 0.0
#; snrt.crt0.init_core_info (start.S:99)
#;   li   t0, SNRT_BASE_HARTID
            494000    0x80000104 li t0, 0                       #; (wrb) t0  <-- 0
#; snrt.crt0.init_core_info (start.S:100)
#;   sub  a0, a0, t0
            495000    0x80000108 sub a0, a0, t0                 #; a0  = 2, t0  = 0, (wrb) a0  <-- 2
#; snrt.crt0.init_core_info (start.S:101)
#;   li   a1, SNRT_CLUSTER_CORE_NUM
            496000    0x8000010c li a1, 9                       #; (wrb) a1  <-- 9
#; snrt.crt0.init_core_info (start.S:102)
#;   div  t0, a0, a1
            497000    0x80000110 div t0, a0, a1                 #; a0  = 2, a1  = 9
#; snrt.crt0.init_core_info (start.S:105)
#;   remu a0, a0, a1
            498000    0x80000114 remu a0, a0, a1                #; a0  = 2, a1  = 9
#; snrt.crt0.init_core_info (start.S:108)
#;   li   a2, SNRT_TCDM_START_ADDR
            499000    0x80000118 lui a2, 65536                  #; (wrb) a2  <-- 0x10000000
#; snrt.crt0.init_core_info (start.S:109)
#;   li   t1, SNRT_CLUSTER_OFFSET
            500000    0x8000011c li t1, 0                       #; (wrb) t1  <-- 0
            501000                                              #; (acc) t0  <-- 0
#; snrt.crt0.init_core_info (start.S:110)
#;   mul  t0, t1, t0
            502000    0x80000120 mul t0, t1, t0                 #; t1  = 0, t0  = 0, (acc) a0  <-- 2
            504000                                              #; (acc) t0  <-- 0
#; snrt.crt0.init_core_info (start.S:111)
#;   add  a2, a2, t0
            505000    0x80000124 add a2, a2, t0                 #; a2  = 0x10000000, t0  = 0, (wrb) a2  <-- 0x10000000
#; snrt.crt0.init_core_info (start.S:114)
#;   li   t0, SNRT_TCDM_SIZE
            506000    0x80000128 lui t0, 32                     #; (wrb) t0  <-- 0x00020000
#; snrt.crt0.init_core_info (start.S:115)
#;   add  a2, a2, t0
            507000    0x8000012c add a2, a2, t0                 #; a2  = 0x10000000, t0  = 0x00020000, (wrb) a2  <-- 0x10020000
#; .Lpcrel_hi0 (start.S:121)
#;   la        t0, __cdata_end
            508000    0x80000130 auipc t0, 6                    #; (wrb) t0  <-- 0x80006130
            509000    0x80000134 addi t0, t0, -920              #; t0  = 0x80006130, (wrb) t0  <-- 0x80005d98
#; .Lpcrel_hi1 (start.S:122)
#;   la        t1, __cdata_start
            510000    0x80000138 auipc t1, 6                    #; (wrb) t1  <-- 0x80006138
            511000    0x8000013c addi t1, t1, -928              #; t1  = 0x80006138, (wrb) t1  <-- 0x80005d98
#; .Lpcrel_hi1 (start.S:123)
#;   sub       t0, t0, t1
            512000    0x80000140 sub t0, t0, t1                 #; t0  = 0x80005d98, t1  = 0x80005d98, (wrb) t0  <-- 0
#; .Lpcrel_hi1 (start.S:124)
#;   sub       a2, a2, t0
            513000    0x80000144 sub a2, a2, t0                 #; a2  = 0x10020000, t0  = 0, (wrb) a2  <-- 0x10020000
#; .Lpcrel_hi2 (start.S:125)
#;   la        t0, __cbss_end
            514000    0x80000148 auipc t0, 6                    #; (wrb) t0  <-- 0x80006148
            515000    0x8000014c addi t0, t0, -912              #; t0  = 0x80006148, (wrb) t0  <-- 0x80005db8
#; .Lpcrel_hi3 (start.S:126)
#;   la        t1, __cbss_start
            516000    0x80000150 auipc t1, 6                    #; (wrb) t1  <-- 0x80006150
            517000    0x80000154 addi t1, t1, -952              #; t1  = 0x80006150, (wrb) t1  <-- 0x80005d98
#; .Lpcrel_hi3 (start.S:127)
#;   sub       t0, t0, t1
            518000    0x80000158 sub t0, t0, t1                 #; t0  = 0x80005db8, t1  = 0x80005d98, (wrb) t0  <-- 32
#; .Lpcrel_hi3 (start.S:128)
#;   sub       a2, a2, t0
            519000    0x8000015c sub a2, a2, t0                 #; a2  = 0x10020000, t0  = 32, (wrb) a2  <-- 0x1001ffe0
#; snrt.crt0.init_stack (start.S:135)
#;   addi      a2, a2, -8
            520000    0x80000160 addi a2, a2, -8                #; a2  = 0x1001ffe0, (wrb) a2  <-- 0x1001ffd8
#; snrt.crt0.init_stack (start.S:136)
#;   sw        zero, 0(a2)
            521000    0x80000164 sw zero, 0(a2)                 #; a2  = 0x1001ffd8, 0 ~~> Word[0x1001ffd8]
#; snrt.crt0.init_stack (start.S:140)
#;   sll       t0, a0, SNRT_LOG2_STACK_SIZE
            522000    0x80000168 slli t0, a0, 10                #; a0  = 2, (wrb) t0  <-- 2048
#; snrt.crt0.init_stack (start.S:143)
#;   sub       sp, a2, t0
            523000    0x8000016c sub sp, a2, t0                 #; a2  = 0x1001ffd8, t0  = 2048, (wrb) sp  <-- 0x1001f7d8
#; snrt.crt0.init_stack (start.S:146)
#;   slli      t0, a0, 3  # this hart
            524000    0x80000170 slli t0, a0, 3                 #; a0  = 2, (wrb) t0  <-- 16
#; snrt.crt0.init_stack (start.S:147)
#;   slli      t1, a1, 3  # all harts
            525000    0x80000174 slli t1, a1, 3                 #; a1  = 9, (wrb) t1  <-- 72
#; snrt.crt0.init_stack (start.S:148)
#;   sub       sp, sp, t0
            526000    0x80000178 sub sp, sp, t0                 #; sp  = 0x1001f7d8, t0  = 16, (wrb) sp  <-- 0x1001f7c8
#; snrt.crt0.init_stack (start.S:149)
#;   sub       a2, a2, t1
            527000    0x8000017c sub a2, a2, t1                 #; a2  = 0x1001ffd8, t1  = 72, (wrb) a2  <-- 0x1001ff90
#; .Lpcrel_hi4 (start.S:155)
#;   la        t0, __tdata_end
            528000    0x80000180 auipc t0, 6                    #; (wrb) t0  <-- 0x80006180
            529000    0x80000184 addi t0, t0, -1068             #; t0  = 0x80006180, (wrb) t0  <-- 0x80005d54
#; .Lpcrel_hi5 (start.S:156)
#;   la        t1, __tdata_start
            530000    0x80000188 auipc t1, 6                    #; (wrb) t1  <-- 0x80006188
            531000    0x8000018c addi t1, t1, -1088             #; t1  = 0x80006188, (wrb) t1  <-- 0x80005d48
#; .Lpcrel_hi5 (start.S:157)
#;   sub       t0, t0, t1
            532000    0x80000190 sub t0, t0, t1                 #; t0  = 0x80005d54, t1  = 0x80005d48, (wrb) t0  <-- 12
#; .Lpcrel_hi5 (start.S:158)
#;   sub       sp, sp, t0
            533000    0x80000194 sub sp, sp, t0                 #; sp  = 0x1001f7c8, t0  = 12, (wrb) sp  <-- 0x1001f7bc
#; .Lpcrel_hi6 (start.S:159)
#;   la        t0, __tbss_end
            534000    0x80000198 auipc t0, 6                    #; (wrb) t0  <-- 0x80006198
            535000    0x8000019c addi t0, t0, -1024             #; t0  = 0x80006198, (wrb) t0  <-- 0x80005d98
#; .Lpcrel_hi7 (start.S:160)
#;   la        t1, __tbss_start
            536000    0x800001a0 auipc t1, 6                    #; (wrb) t1  <-- 0x800061a0
            537000    0x800001a4 addi t1, t1, -1096             #; t1  = 0x800061a0, (wrb) t1  <-- 0x80005d58
#; .Lpcrel_hi7 (start.S:161)
#;   sub       t0, t0, t1
            538000    0x800001a8 sub t0, t0, t1                 #; t0  = 0x80005d98, t1  = 0x80005d58, (wrb) t0  <-- 64
#; .Lpcrel_hi7 (start.S:162)
#;   sub       sp, sp, t0
            539000    0x800001ac sub sp, sp, t0                 #; sp  = 0x1001f7bc, t0  = 64, (wrb) sp  <-- 0x1001f77c
#; .Lpcrel_hi7 (start.S:163)
#;   andi      sp, sp, ~0x7 # align to 8B
            540000    0x800001b0 andi sp, sp, -8                #; sp  = 0x1001f77c, (wrb) sp  <-- 0x1001f778
#; .Lpcrel_hi7 (start.S:165)
#;   mv        tp, sp
            541000    0x800001b4 mv tp, sp                      #; sp  = 0x1001f778, (wrb) tp  <-- 0x1001f778
#; .Lpcrel_hi7 (start.S:167)
#;   andi      sp, sp, ~0x7 # align stack to 8B
            542000    0x800001b8 andi sp, sp, -8                #; sp  = 0x1001f778, (wrb) sp  <-- 0x1001f778
#; snrt.crt0.main (start.S:178)
#;   call snrt_main
            543000    0x800001bc auipc ra, 4                    #; (wrb) ra  <-- 0x800041bc
            544000    0x800001c0 jalr -1352(ra)                 #; ra  = 0x800041bc, (wrb) ra  <-- 0x800001c4, goto 0x80003c74
#; snrt_main (start.c:204)
#;   EXTERN_C void snrt_main() {
            551000    0x80003c74 addi sp, sp, -64               #; sp  = 0x1001f778, (wrb) sp  <-- 0x1001f738
            552000    0x80003c78 sw ra, 60(sp)                  #; sp  = 0x1001f738, 0x800001c4 ~~> Word[0x1001f774]
            553000    0x80003c7c sw s0, 56(sp)                  #; sp  = 0x1001f738, 0 ~~> Word[0x1001f770]
            556000    0x80003c80 sw s1, 52(sp)                  #; sp  = 0x1001f738, 0 ~~> Word[0x1001f76c]
            557000    0x80003c84 sw s2, 48(sp)                  #; sp  = 0x1001f738, 0 ~~> Word[0x1001f768]
            558000    0x80003c88 sw s3, 44(sp)                  #; sp  = 0x1001f738, 0 ~~> Word[0x1001f764]
            559000    0x80003c8c sw s4, 40(sp)                  #; sp  = 0x1001f738, 0 ~~> Word[0x1001f760]
            560000    0x80003c90 sw s5, 36(sp)                  #; sp  = 0x1001f738, 0 ~~> Word[0x1001f75c]
            561000    0x80003c94 sw s6, 32(sp)                  #; sp  = 0x1001f738, 0 ~~> Word[0x1001f758]
            562000    0x80003c98 sw s7, 28(sp)                  #; sp  = 0x1001f738, 0 ~~> Word[0x1001f754]
            563000    0x80003c9c sw s8, 24(sp)                  #; sp  = 0x1001f738, 0 ~~> Word[0x1001f750]
            564000    0x80003ca0 sw s9, 20(sp)                  #; sp  = 0x1001f738, 0 ~~> Word[0x1001f74c]
            565000    0x80003ca4 sw s10, 16(sp)                 #; sp  = 0x1001f738, 0 ~~> Word[0x1001f748]
            566000    0x80003ca8 sw s11, 12(sp)                 #; sp  = 0x1001f738, 0 ~~> Word[0x1001f744]
            567000    0x80003cac li s0, -1                      #; (wrb) s0  <-- -1
#; snrt_main (start.c:206:9)
#;   snrt_cluster_idx (team.h:99:12)
#;     snrt_global_core_idx (team.h:80:12)
#;       snrt_hartid (team.h:25:5)
#;         asm("csrr %0, mhartid" : "=r"(hartid));
#;         ^
            568000    0x80003cb0 csrr s2, mhartid               #; mhartid = 2, (wrb) s2  <-- 2
            569000    0x80003cb4 lui a0, 233017                 #; (wrb) a0  <-- 0x38e39000
            570000    0x80003cb8 addi a0, a0, -455              #; a0  = 0x38e39000, (wrb) a0  <-- 0x38e38e39
#; snrt_main (start.c:206:9)
#;   snrt_cluster_idx (team.h:99:35)
#;     return snrt_global_core_idx() / snrt_cluster_core_num();
#;                                   ^
            571000    0x80003cbc mulhu a0, s2, a0               #; s2  = 2, a0  = 0x38e38e39
            573000                                              #; (acc) a0  <-- 0
            574000    0x80003cc0 srli a0, a0, 1                 #; a0  = 0, (wrb) a0  <-- 0
            575000    0x80003cc4 li a1, 8                       #; (wrb) a1  <-- 8
            576000    0x80003cc8 slli s3, a0, 18                #; a0  = 0, (wrb) s3  <-- 0
#; snrt_main (start.c:206:9)
#;   if (snrt_cluster_idx() == 0) {
#;       ^
            577000    0x80003ccc bltu a1, s2, 184               #; a1  = 8, s2  = 2, not taken
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:31)
#;       snrt_cluster_core_idx (team.h:108:35)
#;         return snrt_global_core_idx() % snrt_cluster_core_num();
#;                                       ^
            578000    0x80003cd0 .text                          #; s2  = 2
            579000    0x80003cd4 li a1, 57                      #; (wrb) a1  <-- 57
            580000                                              #; (acc) s1  <-- 2
            581000    0x80003cd8 mul a1, s1, a1                 #; s1  = 2, a1  = 57
            583000                                              #; (acc) a1  <-- 114
            584000    0x80003cdc srli a1, a1, 9                 #; a1  = 114, (wrb) a1  <-- 0
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
            603000                                              #; (lsu) a3  <-- 0
            604000    0x80003cf8 ori a3, a2, 4                  #; a2  = 0x100211a8, (wrb) a3  <-- 0x100211ac
            605000    0x80003cfc lw a4, 0(a3)                   #; a3  = 0x100211ac, a4  <~~ Word[0x100211ac]
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:31)
#;       snrt_cluster_core_idx (team.h:108:35)
#;         return snrt_global_core_idx() % snrt_cluster_core_num();
#;                                       ^
            606000    0x80003d00 sub a1, s2, a1                 #; s2  = 2, a1  = 0, (wrb) a1  <-- 2
            607000    0x80003d04 li a5, 1                       #; (wrb) a5  <-- 1
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:28)
#;       snrt_int_cluster_clr(1 << snrt_cluster_core_idx());
#;                              ^
            608000    0x80003d08 sll a1, a5, a1                 #; a5  = 1, a1  = 2, (wrb) a1  <-- 4
            627000                                              #; (lsu) a4  <-- 0
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:5)
#;       snrt_int_cluster_clr (cluster_interrupts.h:22:68)
#;         snrt_cluster()->peripheral_reg.cl_clint_clear.f.cl_clint_clear = mask;
#;                                                                        ^
            628000    0x80003d0c and a4, a4, s0                 #; a4  = 0, s0  = -1, (wrb) a4  <-- 0
            629000    0x80003d10 sw a4, 0(a3)                   #; a3  = 0x100211ac, 0 ~~> Word[0x100211ac]
            630000    0x80003d14 sw a1, 0(a2)                   #; a2  = 0x100211a8, 4 ~~> Word[0x100211a8]
            631000    0x80003d18 lui a1, 128                    #; (wrb) a1  <-- 0x00080000
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
            680000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            681000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            682000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            683000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            684000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            685000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            686000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            687000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            688000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            689000    0x80003d1c csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            690000    0x80003d20 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            691000    0x80003d24 bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d1c
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            692000    0x80003d1c csrr a2, mip                   #; mip = 0, (wrb) a2  <-- 0
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            693000    0x80003d20 and a2, a2, a1                 #; a2  = 0, a1  = 0x00080000, (wrb) a2  <-- 0
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            694000    0x80003d24 bnez a2, -8                    #; a2  = 0, not taken
            695000    0x80003d28 li a1, 9                       #; (wrb) a1  <-- 9
#; .LBB25_2 (start.c:215:5)
#;   snrt_init_bss (start.c:110:9)
#;     if (snrt_cluster_idx() == 0) {
#;         ^
            696000    0x80003d2c bgeu s2, a1, 88                #; s2  = 2, a1  = 9, not taken
#; .LBB25_21 (start.c:215:5)
#;   snrt_init_bss (start.c:112:9)
#;     memset((void*)&__bss_start, 0, size);
#;     ^
            697000    0x80003d30 auipc a0, 2                    #; (wrb) a0  <-- 0x80005d30
            698000    0x80003d34 addi a0, a0, 312               #; a0  = 0x80005d30, (wrb) a0  <-- 0x80005e68
#; .LBB25_22 (start.c:215:5)
#;   snrt_init_bss (start.c:112:9)
#;     memset((void*)&__bss_start, 0, size);
#;     ^
            699000    0x80003d38 auipc a1, 2                    #; (wrb) a1  <-- 0x80005d38
            700000    0x80003d3c addi a1, a1, 360               #; a1  = 0x80005d38, (wrb) a1  <-- 0x80005ea0
            701000    0x80003d40 sub a2, a1, a0                 #; a1  = 0x80005ea0, a0  = 0x80005e68, (wrb) a2  <-- 56
            702000    0x80003d44 li a1, 0                       #; (wrb) a1  <-- 0
            703000    0x80003d48 auipc ra, 0                    #; (wrb) ra  <-- 0x80003d48
            704000    0x80003d4c jalr 1220(ra)                  #; ra  = 0x80003d48, (wrb) ra  <-- 0x80003d50, goto 0x8000420c
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
            793000    0x80004288 sb a1, 5(a4)                   #; a4  = 0x80005e68, 0 ~~> Byte[0x80005e6d]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
            842000    0x8000428c sb a1, 4(a4)                   #; a4  = 0x80005e68, 0 ~~> Byte[0x80005e6c]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
            883000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x80005e68, 0 ~~> Byte[0x80005e6b]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
            932000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x80005e68, 0 ~~> Byte[0x80005e6a]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
            973000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x80005e68, 0 ~~> Byte[0x80005e69]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           1022000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x80005e68, 0 ~~> Byte[0x80005e68]
#; .Ltable (memset.S:85)
#;   ret
           1023000    0x800042a0 ret                            #; ra  = 0x800042d0, goto 0x800042d0
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           1024000    0x800042d0 mv ra, t0                      #; t0  = 0x80003d50, (wrb) ra  <-- 0x80003d50
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           1025000    0x800042d4 addi a5, a5, -16               #; a5  = 8, (wrb) a5  <-- -8
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           1026000    0x800042d8 sub a4, a4, a5                 #; a4  = 0x80005e68, a5  = -8, (wrb) a4  <-- 0x80005e70
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           1027000    0x800042dc add a2, a2, a5                 #; a2  = 56, a5  = -8, (wrb) a2  <-- 48
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           1028000    0x800042e0 bgeu t1, a2, -144              #; t1  = 15, a2  = 48, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           1029000    0x800042e4 j -196                         #; goto 0x80004220
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           1030000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           1031000    0x80004224 andi a3, a2, -16               #; a2  = 48, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           1032000    0x80004228 andi a2, a2, 15                #; a2  = 48, (wrb) a2  <-- 0
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           1033000    0x8000422c add a3, a3, a4                 #; a3  = 48, a4  = 0x80005e70, (wrb) a3  <-- 0x80005ea0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           1063000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x80005e70, 0 ~~> Word[0x80005e70]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           1112000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x80005e70, 0 ~~> Word[0x80005e74]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           1153000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x80005e70, 0 ~~> Word[0x80005e78]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           1202000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x80005e70, 0 ~~> Word[0x80005e7c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           1203000    0x80004240 addi a4, a4, 16                #; a4  = 0x80005e70, (wrb) a4  <-- 0x80005e80
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           1204000    0x80004244 bltu a4, a3, -20               #; a4  = 0x80005e80, a3  = 0x80005ea0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           1243000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x80005e80, 0 ~~> Word[0x80005e80]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           1292000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x80005e80, 0 ~~> Word[0x80005e84]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           1333000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x80005e80, 0 ~~> Word[0x80005e88]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           1382000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x80005e80, 0 ~~> Word[0x80005e8c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           1383000    0x80004240 addi a4, a4, 16                #; a4  = 0x80005e80, (wrb) a4  <-- 0x80005e90
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           1384000    0x80004244 bltu a4, a3, -20               #; a4  = 0x80005e90, a3  = 0x80005ea0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           1423000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x80005e90, 0 ~~> Word[0x80005e90]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           1472000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x80005e90, 0 ~~> Word[0x80005e94]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           1513000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x80005e90, 0 ~~> Word[0x80005e98]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           1562000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x80005e90, 0 ~~> Word[0x80005e9c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           1563000    0x80004240 addi a4, a4, 16                #; a4  = 0x80005e90, (wrb) a4  <-- 0x80005ea0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           1564000    0x80004244 bltu a4, a3, -20               #; a4  = 0x80005ea0, a3  = 0x80005ea0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           1565000    0x80004248 bnez a2, 8                     #; a2  = 0, not taken
#; .Ltmp0 (memset.S:57)
#;   ret
           1566000    0x8000424c ret                            #; ra  = 0x80003d50, goto 0x80003d50
#; .LBB25_22 (start.c:215:5)
#;   snrt_init_bss (start.c:115:9)
#;     snrt_cluster_hw_barrier (sync.h:174:5)
#;       asm volatile("csrr x0, 0x7C2" ::: "memory");
#;       ^
           1567000    0x80003d50 csrr zero, 1986                #; csr@7c2 = 0
           1579000    0x80003d54 li a0, 57                      #; (wrb) a0  <-- 57
           1580000    0x80003d58 mul a0, s1, a0                 #; s1  = 2, a0  = 57
           1582000                                              #; (acc) a0  <-- 114
           1583000    0x80003d5c srli a0, a0, 9                 #; a0  = 114, (wrb) a0  <-- 0
           1584000    0x80003d60 slli a1, a0, 3                 #; a0  = 0, (wrb) a1  <-- 0
           1585000    0x80003d64 add a0, a1, a0                 #; a1  = 0, a0  = 0, (wrb) a0  <-- 0
           1586000    0x80003d68 sub a0, s2, a0                 #; s2  = 2, a0  = 0, (wrb) a0  <-- 2
           1587000    0x80003d6c .text                          #; a0  = 2
           1588000    0x80003d70 li s4, 0                       #; (wrb) s4  <-- 0
           1589000                                              #; (acc) s5  <-- 2
#; .LBB25_22 (start.c:219:5)
#;   snrt_wake_up (start.c:124:33)
#;     if (snrt_cluster_idx() == 0 && snrt_cluster_core_idx() == 0) {
#;                                 ^
           1590000    0x80003d74 bnez s5, 32                    #; s5  = 2, taken, goto 0x80003d94
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
           1685000                                              #; (lsu) a1  <-- 0
           1686000    0x80003da8 ori a1, a0, 4                  #; a0  = 0x100211a8, (wrb) a1  <-- 0x100211ac
           1687000    0x80003dac lw a2, 0(a1)                   #; a1  = 0x100211ac, a2  <~~ Word[0x100211ac]
           1688000    0x80003db0 li a3, 1                       #; (wrb) a3  <-- 1
#; .LBB25_7 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;       snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:28)
#;         snrt_int_cluster_clr(1 << snrt_cluster_core_idx());
#;                                ^
           1689000    0x80003db4 sll a3, a3, s5                 #; a3  = 1, s5  = 2, (wrb) a3  <-- 4
           1711000                                              #; (lsu) a2  <-- 0
#; .LBB25_7 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;       snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:5)
#;         snrt_int_cluster_clr (cluster_interrupts.h:22:68)
#;           snrt_cluster()->peripheral_reg.cl_clint_clear.f.cl_clint_clear = mask;
#;                                                                          ^
           1712000    0x80003db8 and a2, a2, s0                 #; a2  = 0, s0  = -1, (wrb) a2  <-- 0
           1713000    0x80003dbc sw a3, 0(a0)                   #; a0  = 0x100211a8, 4 ~~> Word[0x100211a8]
           1714000    0x80003dc0 sw a2, 0(a1)                   #; a1  = 0x100211ac, 0 ~~> Word[0x100211ac]
           1715000    0x80003dc4 lui a0, 128                    #; (wrb) a0  <-- 0x00080000
#; .LBB25_8 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;       snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;         while (read_csr(mip) & MIP_MCIP)
#;                ^
           1716000    0x80003dc8 csrr a1, mip                   #; mip = 0, (wrb) a1  <-- 0
#; .LBB25_8 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;       snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;         while (read_csr(mip) & MIP_MCIP)
#;                              ^
           1717000    0x80003dcc and a1, a1, a0                 #; a1  = 0, a0  = 0x00080000, (wrb) a1  <-- 0
#; .LBB25_8 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;       snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;         while (read_csr(mip) & MIP_MCIP)
#;         ^
           1718000    0x80003dd0 bnez a1, -8                    #; a1  = 0, not taken
#; .LBB25_8 (start.c:227:5)
#;   snrt_init_tls (start.c:66:5)
#;     asm volatile("mv %0, tp" : "=r"(tls_ptr) : :);
#;     ^
           1719000    0x80003dd4 mv a0, tp                      #; tp  = 0x1001f778, (wrb) a0  <-- 0x1001f778
           1738000    0x80003dd8 sw a0, 8(sp)                   #; sp  = 0x1001f738, 0x1001f778 ~~> Word[0x1001f740]
#; .LBB25_8 (start.c:227:5)
#;   snrt_init_tls (start.c:67:19)
#;     memcpy((void*)tls_ptr, (const void*)&__tdata_start, size);
#;                   ^
           1768000    0x80003ddc lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
#; .LBB25_23 (start.c:227:5)
#;   snrt_init_tls (start.c:67:5)
#;     memcpy((void*)tls_ptr, (const void*)&__tdata_start, size);
#;     ^
           1769000    0x80003de0 auipc a1, 2                    #; (wrb) a1  <-- 0x80005de0
           1770000    0x80003de4 addi a1, a1, -152              #; a1  = 0x80005de0, (wrb) a1  <-- 0x80005d48
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:67:5)
#;     memcpy((void*)tls_ptr, (const void*)&__tdata_start, size);
#;     ^
           1771000    0x80003de8 auipc a2, 2                    #; (wrb) a2  <-- 0x80005de8
           1772000    0x80003dec addi a2, a2, -148              #; a2  = 0x80005de8, (wrb) a2  <-- 0x80005d54
           1773000    0x80003df0 sub s0, a2, a1                 #; a2  = 0x80005d54, a1  = 0x80005d48, (wrb) s0  <-- 12
           1774000    0x80003df4 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
           1775000    0x80003df8 auipc ra, 2                    #; (wrb) ra  <-- 0x80005df8
           1776000    0x80003dfc jalr -2028(ra)                 #; ra  = 0x80005df8, (wrb) ra  <-- 0x80003e00, goto 0x8000560c
           1777000                                              #; (lsu) a0  <-- 0x1001f778
#; memcpy (memcpy.c:25)
#;   {
           1780000    0x8000560c addi sp, sp, -16               #; sp  = 0x1001f738, (wrb) sp  <-- 0x1001f728
           1781000    0x80005610 sw s0, 12(sp)                  #; sp  = 0x1001f728, 12 ~~> Word[0x1001f734]
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           1782000    0x80005614 andi a3, a0, 3                 #; a0  = 0x1001f778, (wrb) a3  <-- 0
           1783000    0x80005618 andi a4, a1, 3                 #; a1  = 0x80005d48, (wrb) a4  <-- 0
           1784000    0x8000561c xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
           1785000    0x80005620 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
           1786000    0x80005624 li a5, 3                       #; (wrb) a5  <-- 3
           1787000    0x80005628 sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
           1788000    0x8000562c and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
           1789000    0x80005630 add a2, a0, a2                 #; a0  = 0x1001f778, a2  = 12, (wrb) a2  <-- 0x1001f784
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           1790000    0x80005634 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
           1791000    0x80005638 bnez a3, 116                   #; a3  = 0, not taken
           1792000    0x8000563c mv a4, a0                      #; a0  = 0x1001f778, (wrb) a4  <-- 0x1001f778
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
           1793000    0x80005640 andi a3, a2, -4                #; a2  = 0x1001f784, (wrb) a3  <-- 0x1001f784
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
           1794000    0x80005644 sub a5, a3, a4                 #; a3  = 0x1001f784, a4  = 0x1001f778, (wrb) a5  <-- 12
           1795000    0x80005648 li a6, 33                      #; (wrb) a6  <-- 33
           1796000    0x8000564c bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1797000    0x80005650 bgeu a4, a3, 32                #; a4  = 0x1001f778, a3  = 0x1001f784, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           1798000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x80005d48, a6  <~~ Word[0x80005d48]
           1799000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001f778, (wrb) a5  <-- 0x1001f77c
           1800000    0x8000565c addi a1, a1, 4                 #; a1  = 0x80005d48, (wrb) a1  <-- 0x80005d4c
           1821000                                              #; (lsu) a6  <-- 0x80005e80
           1822000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001f778, 0x80005e80 ~~> Word[0x1001f778]
           1823000    0x80005664 mv a4, a5                      #; a5  = 0x1001f77c, (wrb) a4  <-- 0x1001f77c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1824000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001f77c, a3  = 0x1001f784, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           1825000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x80005d4c, a6  <~~ Word[0x80005d4c]
           1826000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001f77c, (wrb) a5  <-- 0x1001f780
           1827000    0x8000565c addi a1, a1, 4                 #; a1  = 0x80005d4c, (wrb) a1  <-- 0x80005d50
           1858000                                              #; (lsu) a6  <-- 1
           1859000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001f77c, 1 ~~> Word[0x1001f77c]
           1860000    0x80005664 mv a4, a5                      #; a5  = 0x1001f780, (wrb) a4  <-- 0x1001f780
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1861000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001f780, a3  = 0x1001f784, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           1862000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x80005d50, a6  <~~ Word[0x80005d50]
           1863000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001f780, (wrb) a5  <-- 0x1001f784
           1864000    0x8000565c addi a1, a1, 4                 #; a1  = 0x80005d50, (wrb) a1  <-- 0x80005d54
           1902000                                              #; (lsu) a6  <-- 1
           1903000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001f780, 1 ~~> Word[0x1001f780]
           1904000    0x80005664 mv a4, a5                      #; a5  = 0x1001f784, (wrb) a4  <-- 0x1001f784
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1905000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001f784, a3  = 0x1001f784, not taken
           1906000    0x8000566c j 8                            #; goto 0x80005674
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
           1907000    0x80005674 bltu a5, a2, 20                #; a5  = 0x1001f784, a2  = 0x1001f784, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
           1908000    0x80005678 lw s0, 12(sp)                  #; sp  = 0x1001f728, s0  <~~ Word[0x1001f734]
           1909000    0x8000567c addi sp, sp, 16                #; sp  = 0x1001f728, (wrb) sp  <-- 0x1001f738
           1910000    0x80005680 ret                            #; ra  = 0x80003e00, goto 0x80003e00
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
           1911000    0x80003e00 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740], (lsu) s0  <-- 12
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
           1912000    0x80003e04 lw a1, 8(sp)                   #; sp  = 0x1001f738, a1  <~~ Word[0x1001f740]
           1915000                                              #; (lsu) a0  <-- 0x1001f778
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
           1916000    0x80003e08 addi a0, a0, 1032              #; a0  = 0x1001f778, (wrb) a0  <-- 0x1001fb80
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
           1917000    0x80003e0c mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
           1918000    0x80003e10 auipc ra, 1                    #; (wrb) ra  <-- 0x80004e10
           1919000    0x80003e14 jalr 2044(ra)                  #; ra  = 0x80004e10, (wrb) ra  <-- 0x80003e18, goto 0x8000560c
#; memcpy (memcpy.c:25)
#;   {
           1920000    0x8000560c addi sp, sp, -16               #; sp  = 0x1001f738, (wrb) sp  <-- 0x1001f728
           1921000    0x80005610 sw s0, 12(sp)                  #; sp  = 0x1001f728, 12 ~~> Word[0x1001f734], (lsu) a1  <-- 0x1001f778
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           1922000    0x80005614 andi a3, a0, 3                 #; a0  = 0x1001fb80, (wrb) a3  <-- 0
           1923000    0x80005618 andi a4, a1, 3                 #; a1  = 0x1001f778, (wrb) a4  <-- 0
           1924000    0x8000561c xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
           1925000    0x80005620 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
           1926000    0x80005624 li a5, 3                       #; (wrb) a5  <-- 3
           1927000    0x80005628 sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
           1928000    0x8000562c and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
           1929000    0x80005630 add a2, a0, a2                 #; a0  = 0x1001fb80, a2  = 12, (wrb) a2  <-- 0x1001fb8c
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           1930000    0x80005634 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
           1931000    0x80005638 bnez a3, 116                   #; a3  = 0, not taken
           1932000    0x8000563c mv a4, a0                      #; a0  = 0x1001fb80, (wrb) a4  <-- 0x1001fb80
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
           1933000    0x80005640 andi a3, a2, -4                #; a2  = 0x1001fb8c, (wrb) a3  <-- 0x1001fb8c
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
           1934000    0x80005644 sub a5, a3, a4                 #; a3  = 0x1001fb8c, a4  = 0x1001fb80, (wrb) a5  <-- 12
           1935000    0x80005648 li a6, 33                      #; (wrb) a6  <-- 33
           1936000    0x8000564c bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1937000    0x80005650 bgeu a4, a3, 32                #; a4  = 0x1001fb80, a3  = 0x1001fb8c, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           1938000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001f778, a6  <~~ Word[0x1001f778]
           1939000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001fb80, (wrb) a5  <-- 0x1001fb84
           1940000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001f778, (wrb) a1  <-- 0x1001f77c
           1941000                                              #; (lsu) a6  <-- 0x80005e80
           1942000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001fb80, 0x80005e80 ~~> Word[0x1001fb80]
           1943000    0x80005664 mv a4, a5                      #; a5  = 0x1001fb84, (wrb) a4  <-- 0x1001fb84
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1944000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001fb84, a3  = 0x1001fb8c, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           1945000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001f77c, a6  <~~ Word[0x1001f77c]
           1946000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001fb84, (wrb) a5  <-- 0x1001fb88
           1947000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001f77c, (wrb) a1  <-- 0x1001f780
           1948000                                              #; (lsu) a6  <-- 1
           1949000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001fb84, 1 ~~> Word[0x1001fb84]
           1950000    0x80005664 mv a4, a5                      #; a5  = 0x1001fb88, (wrb) a4  <-- 0x1001fb88
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1951000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001fb88, a3  = 0x1001fb8c, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           1952000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001f780, a6  <~~ Word[0x1001f780]
           1953000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001fb88, (wrb) a5  <-- 0x1001fb8c
           1954000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001f780, (wrb) a1  <-- 0x1001f784
           1955000                                              #; (lsu) a6  <-- 1
           1956000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001fb88, 1 ~~> Word[0x1001fb88]
           1957000    0x80005664 mv a4, a5                      #; a5  = 0x1001fb8c, (wrb) a4  <-- 0x1001fb8c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1958000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001fb8c, a3  = 0x1001fb8c, not taken
           1959000    0x8000566c j 8                            #; goto 0x80005674
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
           1960000    0x80005674 bltu a5, a2, 20                #; a5  = 0x1001fb8c, a2  = 0x1001fb8c, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
           1961000    0x80005678 lw s0, 12(sp)                  #; sp  = 0x1001f728, s0  <~~ Word[0x1001f734]
           1962000    0x8000567c addi sp, sp, 16                #; sp  = 0x1001f728, (wrb) sp  <-- 0x1001f738
           1963000    0x80005680 ret                            #; ra  = 0x80003e18, goto 0x80003e18
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
           1964000    0x80003e18 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740], (lsu) s0  <-- 12
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
           1965000    0x80003e1c lw a1, 8(sp)                   #; sp  = 0x1001f738, a1  <~~ Word[0x1001f740]
           1966000    0x80003e20 lui s7, 1                      #; (wrb) s7  <-- 4096
           1967000    0x80003e24 addi s1, s7, -2032             #; s7  = 4096, (wrb) s1  <-- 2064
           1968000                                              #; (lsu) a0  <-- 0x1001f778
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
           1969000    0x80003e28 add a0, a0, s1                 #; a0  = 0x1001f778, s1  = 2064, (wrb) a0  <-- 0x1001ff88
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
           1970000    0x80003e2c mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
           1971000    0x80003e30 auipc ra, 1                    #; (wrb) ra  <-- 0x80004e30
           1972000    0x80003e34 jalr 2012(ra)                  #; ra  = 0x80004e30, (wrb) ra  <-- 0x80003e38, goto 0x8000560c
#; memcpy (memcpy.c:25)
#;   {
           1973000    0x8000560c addi sp, sp, -16               #; sp  = 0x1001f738, (wrb) sp  <-- 0x1001f728
           1974000    0x80005610 sw s0, 12(sp)                  #; sp  = 0x1001f728, 12 ~~> Word[0x1001f734], (lsu) a1  <-- 0x1001f778
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           1975000    0x80005614 andi a3, a0, 3                 #; a0  = 0x1001ff88, (wrb) a3  <-- 0
           1976000    0x80005618 andi a4, a1, 3                 #; a1  = 0x1001f778, (wrb) a4  <-- 0
           1977000    0x8000561c xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
           1978000    0x80005620 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
           1979000    0x80005624 li a5, 3                       #; (wrb) a5  <-- 3
           1980000    0x80005628 sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
           1981000    0x8000562c and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
           1982000    0x80005630 add a2, a0, a2                 #; a0  = 0x1001ff88, a2  = 12, (wrb) a2  <-- 0x1001ff94
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           1983000    0x80005634 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
           1984000    0x80005638 bnez a3, 116                   #; a3  = 0, not taken
           1985000    0x8000563c mv a4, a0                      #; a0  = 0x1001ff88, (wrb) a4  <-- 0x1001ff88
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
           1986000    0x80005640 andi a3, a2, -4                #; a2  = 0x1001ff94, (wrb) a3  <-- 0x1001ff94
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
           1987000    0x80005644 sub a5, a3, a4                 #; a3  = 0x1001ff94, a4  = 0x1001ff88, (wrb) a5  <-- 12
           1988000    0x80005648 li a6, 33                      #; (wrb) a6  <-- 33
           1989000    0x8000564c bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1990000    0x80005650 bgeu a4, a3, 32                #; a4  = 0x1001ff88, a3  = 0x1001ff94, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           1991000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001f778, a6  <~~ Word[0x1001f778]
           1992000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001ff88, (wrb) a5  <-- 0x1001ff8c
           1993000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001f778, (wrb) a1  <-- 0x1001f77c
           1994000                                              #; (lsu) a6  <-- 0x80005e80
           1995000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001ff88, 0x80005e80 ~~> Word[0x1001ff88]
           1996000    0x80005664 mv a4, a5                      #; a5  = 0x1001ff8c, (wrb) a4  <-- 0x1001ff8c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           1997000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001ff8c, a3  = 0x1001ff94, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           1998000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001f77c, a6  <~~ Word[0x1001f77c]
           1999000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001ff8c, (wrb) a5  <-- 0x1001ff90
           2000000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001f77c, (wrb) a1  <-- 0x1001f780
           2001000                                              #; (lsu) a6  <-- 1
           2002000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001ff8c, 1 ~~> Word[0x1001ff8c]
           2003000    0x80005664 mv a4, a5                      #; a5  = 0x1001ff90, (wrb) a4  <-- 0x1001ff90
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2004000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001ff90, a3  = 0x1001ff94, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2005000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001f780, a6  <~~ Word[0x1001f780]
           2006000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1001ff90, (wrb) a5  <-- 0x1001ff94
           2007000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001f780, (wrb) a1  <-- 0x1001f784
           2008000                                              #; (lsu) a6  <-- 1
           2009000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1001ff90, 1 ~~> Word[0x1001ff90]
           2010000    0x80005664 mv a4, a5                      #; a5  = 0x1001ff94, (wrb) a4  <-- 0x1001ff94
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2011000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1001ff94, a3  = 0x1001ff94, not taken
           2012000    0x8000566c j 8                            #; goto 0x80005674
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
           2013000    0x80005674 bltu a5, a2, 20                #; a5  = 0x1001ff94, a2  = 0x1001ff94, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
           2014000    0x80005678 lw s0, 12(sp)                  #; sp  = 0x1001f728, s0  <~~ Word[0x1001f734]
           2015000    0x8000567c addi sp, sp, 16                #; sp  = 0x1001f728, (wrb) sp  <-- 0x1001f738
           2016000    0x80005680 ret                            #; ra  = 0x80003e38, goto 0x80003e38
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
           2017000    0x80003e38 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740], (lsu) s0  <-- 12
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
           2018000    0x80003e3c lw a1, 8(sp)                   #; sp  = 0x1001f738, a1  <~~ Word[0x1001f740]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
           2019000    0x80003e40 ori s6, s1, 1032               #; s1  = 2064, (wrb) s6  <-- 3096
           2020000                                              #; (lsu) a0  <-- 0x1001f778
           2021000    0x80003e44 add a0, a0, s6                 #; a0  = 0x1001f778, s6  = 3096, (wrb) a0  <-- 0x10020390
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
           2022000    0x80003e48 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
           2023000    0x80003e4c auipc ra, 1                    #; (wrb) ra  <-- 0x80004e4c
           2024000    0x80003e50 jalr 1984(ra)                  #; ra  = 0x80004e4c, (wrb) ra  <-- 0x80003e54, goto 0x8000560c
#; memcpy (memcpy.c:25)
#;   {
           2025000    0x8000560c addi sp, sp, -16               #; sp  = 0x1001f738, (wrb) sp  <-- 0x1001f728
           2026000    0x80005610 sw s0, 12(sp)                  #; sp  = 0x1001f728, 12 ~~> Word[0x1001f734], (lsu) a1  <-- 0x1001f778
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2027000    0x80005614 andi a3, a0, 3                 #; a0  = 0x10020390, (wrb) a3  <-- 0
           2028000    0x80005618 andi a4, a1, 3                 #; a1  = 0x1001f778, (wrb) a4  <-- 0
           2029000    0x8000561c xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
           2030000    0x80005620 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
           2031000    0x80005624 li a5, 3                       #; (wrb) a5  <-- 3
           2032000    0x80005628 sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
           2033000    0x8000562c and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
           2034000    0x80005630 add a2, a0, a2                 #; a0  = 0x10020390, a2  = 12, (wrb) a2  <-- 0x1002039c
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2035000    0x80005634 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
           2036000    0x80005638 bnez a3, 116                   #; a3  = 0, not taken
           2037000    0x8000563c mv a4, a0                      #; a0  = 0x10020390, (wrb) a4  <-- 0x10020390
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
           2038000    0x80005640 andi a3, a2, -4                #; a2  = 0x1002039c, (wrb) a3  <-- 0x1002039c
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
           2039000    0x80005644 sub a5, a3, a4                 #; a3  = 0x1002039c, a4  = 0x10020390, (wrb) a5  <-- 12
           2040000    0x80005648 li a6, 33                      #; (wrb) a6  <-- 33
           2041000    0x8000564c bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2042000    0x80005650 bgeu a4, a3, 32                #; a4  = 0x10020390, a3  = 0x1002039c, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2043000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001f778, a6  <~~ Word[0x1001f778]
           2044000    0x80005658 addi a5, a4, 4                 #; a4  = 0x10020390, (wrb) a5  <-- 0x10020394
           2045000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001f778, (wrb) a1  <-- 0x1001f77c
           2046000                                              #; (lsu) a6  <-- 0x80005e80
           2047000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x10020390, 0x80005e80 ~~> Word[0x10020390]
           2048000    0x80005664 mv a4, a5                      #; a5  = 0x10020394, (wrb) a4  <-- 0x10020394
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2049000    0x80005668 bltu a5, a3, -20               #; a5  = 0x10020394, a3  = 0x1002039c, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2050000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001f77c, a6  <~~ Word[0x1001f77c]
           2051000    0x80005658 addi a5, a4, 4                 #; a4  = 0x10020394, (wrb) a5  <-- 0x10020398
           2052000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001f77c, (wrb) a1  <-- 0x1001f780
           2059000                                              #; (lsu) a6  <-- 1
           2060000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x10020394, 1 ~~> Word[0x10020394]
           2061000    0x80005664 mv a4, a5                      #; a5  = 0x10020398, (wrb) a4  <-- 0x10020398
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2062000    0x80005668 bltu a5, a3, -20               #; a5  = 0x10020398, a3  = 0x1002039c, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2063000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001f780, a6  <~~ Word[0x1001f780]
           2064000    0x80005658 addi a5, a4, 4                 #; a4  = 0x10020398, (wrb) a5  <-- 0x1002039c
           2065000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001f780, (wrb) a1  <-- 0x1001f784
           2073000                                              #; (lsu) a6  <-- 1
           2074000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x10020398, 1 ~~> Word[0x10020398]
           2075000    0x80005664 mv a4, a5                      #; a5  = 0x1002039c, (wrb) a4  <-- 0x1002039c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2076000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1002039c, a3  = 0x1002039c, not taken
           2077000    0x8000566c j 8                            #; goto 0x80005674
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
           2078000    0x80005674 bltu a5, a2, 20                #; a5  = 0x1002039c, a2  = 0x1002039c, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
           2079000    0x80005678 lw s0, 12(sp)                  #; sp  = 0x1001f728, s0  <~~ Word[0x1001f734]
           2080000    0x8000567c addi sp, sp, 16                #; sp  = 0x1001f728, (wrb) sp  <-- 0x1001f738
           2081000    0x80005680 ret                            #; ra  = 0x80003e54, goto 0x80003e54
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
           2082000    0x80003e54 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
           2083000    0x80003e58 lw a1, 8(sp)                   #; sp  = 0x1001f738, a1  <~~ Word[0x1001f740]
           2084000    0x80003e5c addi s7, s7, 32                #; s7  = 4096, (wrb) s7  <-- 4128
           2086000                                              #; (lsu) s0  <-- 12
           2087000                                              #; (lsu) a0  <-- 0x1001f778
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
           2088000    0x80003e60 add a0, a0, s7                 #; a0  = 0x1001f778, s7  = 4128, (wrb) a0  <-- 0x10020798
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
           2089000    0x80003e64 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
           2090000    0x80003e68 auipc ra, 1                    #; (wrb) ra  <-- 0x80004e68
           2091000    0x80003e6c jalr 1956(ra)                  #; ra  = 0x80004e68, (wrb) ra  <-- 0x80003e70, goto 0x8000560c
#; memcpy (memcpy.c:25)
#;   {
           2092000    0x8000560c addi sp, sp, -16               #; sp  = 0x1001f738, (wrb) sp  <-- 0x1001f728
           2093000    0x80005610 sw s0, 12(sp)                  #; sp  = 0x1001f728, 12 ~~> Word[0x1001f734], (lsu) a1  <-- 0x1001f778
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2094000    0x80005614 andi a3, a0, 3                 #; a0  = 0x10020798, (wrb) a3  <-- 0
           2095000    0x80005618 andi a4, a1, 3                 #; a1  = 0x1001f778, (wrb) a4  <-- 0
           2096000    0x8000561c xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
           2097000    0x80005620 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
           2098000    0x80005624 li a5, 3                       #; (wrb) a5  <-- 3
           2099000    0x80005628 sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
           2100000    0x8000562c and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
           2101000    0x80005630 add a2, a0, a2                 #; a0  = 0x10020798, a2  = 12, (wrb) a2  <-- 0x100207a4
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2102000    0x80005634 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
           2103000    0x80005638 bnez a3, 116                   #; a3  = 0, not taken
           2104000    0x8000563c mv a4, a0                      #; a0  = 0x10020798, (wrb) a4  <-- 0x10020798
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
           2105000    0x80005640 andi a3, a2, -4                #; a2  = 0x100207a4, (wrb) a3  <-- 0x100207a4
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
           2106000    0x80005644 sub a5, a3, a4                 #; a3  = 0x100207a4, a4  = 0x10020798, (wrb) a5  <-- 12
           2107000    0x80005648 li a6, 33                      #; (wrb) a6  <-- 33
           2108000    0x8000564c bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2109000    0x80005650 bgeu a4, a3, 32                #; a4  = 0x10020798, a3  = 0x100207a4, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2110000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001f778, a6  <~~ Word[0x1001f778]
           2111000    0x80005658 addi a5, a4, 4                 #; a4  = 0x10020798, (wrb) a5  <-- 0x1002079c
           2112000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001f778, (wrb) a1  <-- 0x1001f77c
           2113000                                              #; (lsu) a6  <-- 0x80005e80
           2114000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x10020798, 0x80005e80 ~~> Word[0x10020798]
           2115000    0x80005664 mv a4, a5                      #; a5  = 0x1002079c, (wrb) a4  <-- 0x1002079c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2116000    0x80005668 bltu a5, a3, -20               #; a5  = 0x1002079c, a3  = 0x100207a4, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2117000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001f77c, a6  <~~ Word[0x1001f77c]
           2118000    0x80005658 addi a5, a4, 4                 #; a4  = 0x1002079c, (wrb) a5  <-- 0x100207a0
           2119000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001f77c, (wrb) a1  <-- 0x1001f780
           2127000                                              #; (lsu) a6  <-- 1
           2128000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x1002079c, 1 ~~> Word[0x1002079c]
           2129000    0x80005664 mv a4, a5                      #; a5  = 0x100207a0, (wrb) a4  <-- 0x100207a0
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2130000    0x80005668 bltu a5, a3, -20               #; a5  = 0x100207a0, a3  = 0x100207a4, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2131000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001f780, a6  <~~ Word[0x1001f780]
           2132000    0x80005658 addi a5, a4, 4                 #; a4  = 0x100207a0, (wrb) a5  <-- 0x100207a4
           2133000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001f780, (wrb) a1  <-- 0x1001f784
           2146000                                              #; (lsu) a6  <-- 1
           2147000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x100207a0, 1 ~~> Word[0x100207a0]
           2148000    0x80005664 mv a4, a5                      #; a5  = 0x100207a4, (wrb) a4  <-- 0x100207a4
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2149000    0x80005668 bltu a5, a3, -20               #; a5  = 0x100207a4, a3  = 0x100207a4, not taken
           2150000    0x8000566c j 8                            #; goto 0x80005674
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
           2151000    0x80005674 bltu a5, a2, 20                #; a5  = 0x100207a4, a2  = 0x100207a4, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
           2152000    0x80005678 lw s0, 12(sp)                  #; sp  = 0x1001f728, s0  <~~ Word[0x1001f734]
           2153000    0x8000567c addi sp, sp, 16                #; sp  = 0x1001f728, (wrb) sp  <-- 0x1001f738
           2154000    0x80005680 ret                            #; ra  = 0x80003e70, goto 0x80003e70
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
           2155000    0x80003e70 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
           2156000    0x80003e74 lw a1, 8(sp)                   #; sp  = 0x1001f738, a1  <~~ Word[0x1001f740]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
           2157000    0x80003e78 ori s8, s7, 1032               #; s7  = 4128, (wrb) s8  <-- 5160
           2159000                                              #; (lsu) s0  <-- 12
           2160000                                              #; (lsu) a0  <-- 0x1001f778
           2161000    0x80003e7c add a0, a0, s8                 #; a0  = 0x1001f778, s8  = 5160, (wrb) a0  <-- 0x10020ba0
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
           2162000    0x80003e80 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
           2163000    0x80003e84 auipc ra, 1                    #; (wrb) ra  <-- 0x80004e84
           2164000    0x80003e88 jalr 1928(ra)                  #; ra  = 0x80004e84, (wrb) ra  <-- 0x80003e8c, goto 0x8000560c
#; memcpy (memcpy.c:25)
#;   {
           2165000    0x8000560c addi sp, sp, -16               #; sp  = 0x1001f738, (wrb) sp  <-- 0x1001f728
           2166000    0x80005610 sw s0, 12(sp)                  #; sp  = 0x1001f728, 12 ~~> Word[0x1001f734], (lsu) a1  <-- 0x1001f778
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2167000    0x80005614 andi a3, a0, 3                 #; a0  = 0x10020ba0, (wrb) a3  <-- 0
           2168000    0x80005618 andi a4, a1, 3                 #; a1  = 0x1001f778, (wrb) a4  <-- 0
           2169000    0x8000561c xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
           2170000    0x80005620 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
           2171000    0x80005624 li a5, 3                       #; (wrb) a5  <-- 3
           2172000    0x80005628 sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
           2173000    0x8000562c and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
           2174000    0x80005630 add a2, a0, a2                 #; a0  = 0x10020ba0, a2  = 12, (wrb) a2  <-- 0x10020bac
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2175000    0x80005634 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
           2176000    0x80005638 bnez a3, 116                   #; a3  = 0, not taken
           2177000    0x8000563c mv a4, a0                      #; a0  = 0x10020ba0, (wrb) a4  <-- 0x10020ba0
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
           2178000    0x80005640 andi a3, a2, -4                #; a2  = 0x10020bac, (wrb) a3  <-- 0x10020bac
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
           2179000    0x80005644 sub a5, a3, a4                 #; a3  = 0x10020bac, a4  = 0x10020ba0, (wrb) a5  <-- 12
           2180000    0x80005648 li a6, 33                      #; (wrb) a6  <-- 33
           2181000    0x8000564c bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2182000    0x80005650 bgeu a4, a3, 32                #; a4  = 0x10020ba0, a3  = 0x10020bac, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2183000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001f778, a6  <~~ Word[0x1001f778]
           2184000    0x80005658 addi a5, a4, 4                 #; a4  = 0x10020ba0, (wrb) a5  <-- 0x10020ba4
           2185000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001f778, (wrb) a1  <-- 0x1001f77c
           2186000                                              #; (lsu) a6  <-- 0x80005e80
           2187000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x10020ba0, 0x80005e80 ~~> Word[0x10020ba0]
           2188000    0x80005664 mv a4, a5                      #; a5  = 0x10020ba4, (wrb) a4  <-- 0x10020ba4
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2189000    0x80005668 bltu a5, a3, -20               #; a5  = 0x10020ba4, a3  = 0x10020bac, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2190000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001f77c, a6  <~~ Word[0x1001f77c]
           2191000    0x80005658 addi a5, a4, 4                 #; a4  = 0x10020ba4, (wrb) a5  <-- 0x10020ba8
           2192000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001f77c, (wrb) a1  <-- 0x1001f780
           2207000                                              #; (lsu) a6  <-- 1
           2208000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x10020ba4, 1 ~~> Word[0x10020ba4]
           2209000    0x80005664 mv a4, a5                      #; a5  = 0x10020ba8, (wrb) a4  <-- 0x10020ba8
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2210000    0x80005668 bltu a5, a3, -20               #; a5  = 0x10020ba8, a3  = 0x10020bac, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2211000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001f780, a6  <~~ Word[0x1001f780]
           2212000    0x80005658 addi a5, a4, 4                 #; a4  = 0x10020ba8, (wrb) a5  <-- 0x10020bac
           2213000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001f780, (wrb) a1  <-- 0x1001f784
           2232000                                              #; (lsu) a6  <-- 1
           2233000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x10020ba8, 1 ~~> Word[0x10020ba8]
           2234000    0x80005664 mv a4, a5                      #; a5  = 0x10020bac, (wrb) a4  <-- 0x10020bac
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2235000    0x80005668 bltu a5, a3, -20               #; a5  = 0x10020bac, a3  = 0x10020bac, not taken
           2236000    0x8000566c j 8                            #; goto 0x80005674
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
           2237000    0x80005674 bltu a5, a2, 20                #; a5  = 0x10020bac, a2  = 0x10020bac, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
           2238000    0x80005678 lw s0, 12(sp)                  #; sp  = 0x1001f728, s0  <~~ Word[0x1001f734]
           2239000    0x8000567c addi sp, sp, 16                #; sp  = 0x1001f728, (wrb) sp  <-- 0x1001f738
           2240000    0x80005680 ret                            #; ra  = 0x80003e8c, goto 0x80003e8c
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
           2247000    0x80003e8c lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
           2248000    0x80003e90 lw a1, 8(sp)                   #; sp  = 0x1001f738, a1  <~~ Word[0x1001f740]
           2249000    0x80003e94 lui s11, 2                     #; (wrb) s11 <-- 8192
           2250000    0x80003e98 addi s9, s11, -2000            #; s11 = 8192, (wrb) s9  <-- 6192
           2257000                                              #; (lsu) s0  <-- 12
           2258000                                              #; (lsu) a0  <-- 0x1001f778
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
           2259000    0x80003e9c add a0, a0, s9                 #; a0  = 0x1001f778, s9  = 6192, (wrb) a0  <-- 0x10020fa8
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
           2260000    0x80003ea0 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
           2261000    0x80003ea4 auipc ra, 1                    #; (wrb) ra  <-- 0x80004ea4
           2262000    0x80003ea8 jalr 1896(ra)                  #; ra  = 0x80004ea4, (wrb) ra  <-- 0x80003eac, goto 0x8000560c
#; memcpy (memcpy.c:25)
#;   {
           2263000    0x8000560c addi sp, sp, -16               #; sp  = 0x1001f738, (wrb) sp  <-- 0x1001f728
           2264000    0x80005610 sw s0, 12(sp)                  #; sp  = 0x1001f728, 12 ~~> Word[0x1001f734], (lsu) a1  <-- 0x1001f778
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2265000    0x80005614 andi a3, a0, 3                 #; a0  = 0x10020fa8, (wrb) a3  <-- 0
           2266000    0x80005618 andi a4, a1, 3                 #; a1  = 0x1001f778, (wrb) a4  <-- 0
           2267000    0x8000561c xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
           2268000    0x80005620 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
           2269000    0x80005624 li a5, 3                       #; (wrb) a5  <-- 3
           2270000    0x80005628 sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
           2271000    0x8000562c and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
           2272000    0x80005630 add a2, a0, a2                 #; a0  = 0x10020fa8, a2  = 12, (wrb) a2  <-- 0x10020fb4
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2273000    0x80005634 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
           2274000    0x80005638 bnez a3, 116                   #; a3  = 0, not taken
           2275000    0x8000563c mv a4, a0                      #; a0  = 0x10020fa8, (wrb) a4  <-- 0x10020fa8
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
           2276000    0x80005640 andi a3, a2, -4                #; a2  = 0x10020fb4, (wrb) a3  <-- 0x10020fb4
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
           2277000    0x80005644 sub a5, a3, a4                 #; a3  = 0x10020fb4, a4  = 0x10020fa8, (wrb) a5  <-- 12
           2278000    0x80005648 li a6, 33                      #; (wrb) a6  <-- 33
           2279000    0x8000564c bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2280000    0x80005650 bgeu a4, a3, 32                #; a4  = 0x10020fa8, a3  = 0x10020fb4, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2281000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001f778, a6  <~~ Word[0x1001f778]
           2282000    0x80005658 addi a5, a4, 4                 #; a4  = 0x10020fa8, (wrb) a5  <-- 0x10020fac
           2283000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001f778, (wrb) a1  <-- 0x1001f77c
           2284000                                              #; (lsu) a6  <-- 0x80005e80
           2285000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x10020fa8, 0x80005e80 ~~> Word[0x10020fa8]
           2286000    0x80005664 mv a4, a5                      #; a5  = 0x10020fac, (wrb) a4  <-- 0x10020fac
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2287000    0x80005668 bltu a5, a3, -20               #; a5  = 0x10020fac, a3  = 0x10020fb4, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2288000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001f77c, a6  <~~ Word[0x1001f77c]
           2289000    0x80005658 addi a5, a4, 4                 #; a4  = 0x10020fac, (wrb) a5  <-- 0x10020fb0
           2290000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001f77c, (wrb) a1  <-- 0x1001f780
           2302000                                              #; (lsu) a6  <-- 1
           2303000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x10020fac, 1 ~~> Word[0x10020fac]
           2304000    0x80005664 mv a4, a5                      #; a5  = 0x10020fb0, (wrb) a4  <-- 0x10020fb0
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2305000    0x80005668 bltu a5, a3, -20               #; a5  = 0x10020fb0, a3  = 0x10020fb4, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2306000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001f780, a6  <~~ Word[0x1001f780]
           2307000    0x80005658 addi a5, a4, 4                 #; a4  = 0x10020fb0, (wrb) a5  <-- 0x10020fb4
           2308000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001f780, (wrb) a1  <-- 0x1001f784
           2345000                                              #; (lsu) a6  <-- 1
           2346000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x10020fb0, 1 ~~> Word[0x10020fb0]
           2347000    0x80005664 mv a4, a5                      #; a5  = 0x10020fb4, (wrb) a4  <-- 0x10020fb4
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2348000    0x80005668 bltu a5, a3, -20               #; a5  = 0x10020fb4, a3  = 0x10020fb4, not taken
           2349000    0x8000566c j 8                            #; goto 0x80005674
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
           2350000    0x80005674 bltu a5, a2, 20                #; a5  = 0x10020fb4, a2  = 0x10020fb4, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
           2351000    0x80005678 lw s0, 12(sp)                  #; sp  = 0x1001f728, s0  <~~ Word[0x1001f734]
           2352000    0x8000567c addi sp, sp, 16                #; sp  = 0x1001f728, (wrb) sp  <-- 0x1001f738
           2353000    0x80005680 ret                            #; ra  = 0x80003eac, goto 0x80003eac
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
           2362000    0x80003eac lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
           2363000    0x80003eb0 lw a1, 8(sp)                   #; sp  = 0x1001f738, a1  <~~ Word[0x1001f740]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
           2364000    0x80003eb4 ori s10, s9, 1032              #; s9  = 6192, (wrb) s10 <-- 7224
           2372000                                              #; (lsu) s0  <-- 12
           2373000                                              #; (lsu) a0  <-- 0x1001f778
           2374000    0x80003eb8 add a0, a0, s10                #; a0  = 0x1001f778, s10 = 7224, (wrb) a0  <-- 0x100213b0
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
           2375000    0x80003ebc mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
           2376000    0x80003ec0 auipc ra, 1                    #; (wrb) ra  <-- 0x80004ec0
           2377000    0x80003ec4 jalr 1868(ra)                  #; ra  = 0x80004ec0, (wrb) ra  <-- 0x80003ec8, goto 0x8000560c
#; memcpy (memcpy.c:25)
#;   {
           2378000    0x8000560c addi sp, sp, -16               #; sp  = 0x1001f738, (wrb) sp  <-- 0x1001f728
           2379000    0x80005610 sw s0, 12(sp)                  #; sp  = 0x1001f728, 12 ~~> Word[0x1001f734], (lsu) a1  <-- 0x1001f778
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2380000    0x80005614 andi a3, a0, 3                 #; a0  = 0x100213b0, (wrb) a3  <-- 0
           2381000    0x80005618 andi a4, a1, 3                 #; a1  = 0x1001f778, (wrb) a4  <-- 0
           2382000    0x8000561c xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
           2383000    0x80005620 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
           2384000    0x80005624 li a5, 3                       #; (wrb) a5  <-- 3
           2385000    0x80005628 sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
           2386000    0x8000562c and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
           2387000    0x80005630 add a2, a0, a2                 #; a0  = 0x100213b0, a2  = 12, (wrb) a2  <-- 0x100213bc
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2388000    0x80005634 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
           2389000    0x80005638 bnez a3, 116                   #; a3  = 0, not taken
           2390000    0x8000563c mv a4, a0                      #; a0  = 0x100213b0, (wrb) a4  <-- 0x100213b0
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
           2391000    0x80005640 andi a3, a2, -4                #; a2  = 0x100213bc, (wrb) a3  <-- 0x100213bc
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
           2392000    0x80005644 sub a5, a3, a4                 #; a3  = 0x100213bc, a4  = 0x100213b0, (wrb) a5  <-- 12
           2393000    0x80005648 li a6, 33                      #; (wrb) a6  <-- 33
           2394000    0x8000564c bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2395000    0x80005650 bgeu a4, a3, 32                #; a4  = 0x100213b0, a3  = 0x100213bc, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2396000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001f778, a6  <~~ Word[0x1001f778]
           2397000    0x80005658 addi a5, a4, 4                 #; a4  = 0x100213b0, (wrb) a5  <-- 0x100213b4
           2398000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001f778, (wrb) a1  <-- 0x1001f77c
           2399000                                              #; (lsu) a6  <-- 0x80005e80
           2400000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x100213b0, 0x80005e80 ~~> Word[0x100213b0]
           2401000    0x80005664 mv a4, a5                      #; a5  = 0x100213b4, (wrb) a4  <-- 0x100213b4
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2402000    0x80005668 bltu a5, a3, -20               #; a5  = 0x100213b4, a3  = 0x100213bc, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2403000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001f77c, a6  <~~ Word[0x1001f77c]
           2404000    0x80005658 addi a5, a4, 4                 #; a4  = 0x100213b4, (wrb) a5  <-- 0x100213b8
           2405000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001f77c, (wrb) a1  <-- 0x1001f780
           2424000                                              #; (lsu) a6  <-- 1
           2425000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x100213b4, 1 ~~> Word[0x100213b4]
           2426000    0x80005664 mv a4, a5                      #; a5  = 0x100213b8, (wrb) a4  <-- 0x100213b8
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2427000    0x80005668 bltu a5, a3, -20               #; a5  = 0x100213b8, a3  = 0x100213bc, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2428000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001f780, a6  <~~ Word[0x1001f780]
           2429000    0x80005658 addi a5, a4, 4                 #; a4  = 0x100213b8, (wrb) a5  <-- 0x100213bc
           2430000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001f780, (wrb) a1  <-- 0x1001f784
           2454000                                              #; (lsu) a6  <-- 1
           2455000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x100213b8, 1 ~~> Word[0x100213b8]
           2456000    0x80005664 mv a4, a5                      #; a5  = 0x100213bc, (wrb) a4  <-- 0x100213bc
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2457000    0x80005668 bltu a5, a3, -20               #; a5  = 0x100213bc, a3  = 0x100213bc, not taken
           2458000    0x8000566c j 8                            #; goto 0x80005674
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
           2459000    0x80005674 bltu a5, a2, 20                #; a5  = 0x100213bc, a2  = 0x100213bc, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
           2460000    0x80005678 lw s0, 12(sp)                  #; sp  = 0x1001f728, s0  <~~ Word[0x1001f734]
           2461000    0x8000567c addi sp, sp, 16                #; sp  = 0x1001f728, (wrb) sp  <-- 0x1001f738
           2462000    0x80005680 ret                            #; ra  = 0x80003ec8, goto 0x80003ec8
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
           2477000    0x80003ec8 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
           2478000    0x80003ecc lw a1, 8(sp)                   #; sp  = 0x1001f738, a1  <~~ Word[0x1001f740]
           2479000    0x80003ed0 addi s11, s11, 64              #; s11 = 8192, (wrb) s11 <-- 8256
           2484000                                              #; (lsu) s0  <-- 12
           2485000                                              #; (lsu) a0  <-- 0x1001f778
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
           2486000    0x80003ed4 add a0, a0, s11                #; a0  = 0x1001f778, s11 = 8256, (wrb) a0  <-- 0x100217b8
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
           2487000    0x80003ed8 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
           2488000    0x80003edc auipc ra, 1                    #; (wrb) ra  <-- 0x80004edc
           2489000    0x80003ee0 jalr 1840(ra)                  #; ra  = 0x80004edc, (wrb) ra  <-- 0x80003ee4, goto 0x8000560c
#; memcpy (memcpy.c:25)
#;   {
           2490000    0x8000560c addi sp, sp, -16               #; sp  = 0x1001f738, (wrb) sp  <-- 0x1001f728
           2491000    0x80005610 sw s0, 12(sp)                  #; sp  = 0x1001f728, 12 ~~> Word[0x1001f734], (lsu) a1  <-- 0x1001f778
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2492000    0x80005614 andi a3, a0, 3                 #; a0  = 0x100217b8, (wrb) a3  <-- 0
           2493000    0x80005618 andi a4, a1, 3                 #; a1  = 0x1001f778, (wrb) a4  <-- 0
           2494000    0x8000561c xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
           2495000    0x80005620 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
           2496000    0x80005624 li a5, 3                       #; (wrb) a5  <-- 3
           2497000    0x80005628 sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
           2498000    0x8000562c and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
           2499000    0x80005630 add a2, a0, a2                 #; a0  = 0x100217b8, a2  = 12, (wrb) a2  <-- 0x100217c4
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
           2500000    0x80005634 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
           2501000    0x80005638 bnez a3, 116                   #; a3  = 0, not taken
           2502000    0x8000563c mv a4, a0                      #; a0  = 0x100217b8, (wrb) a4  <-- 0x100217b8
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
           2503000    0x80005640 andi a3, a2, -4                #; a2  = 0x100217c4, (wrb) a3  <-- 0x100217c4
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
           2504000    0x80005644 sub a5, a3, a4                 #; a3  = 0x100217c4, a4  = 0x100217b8, (wrb) a5  <-- 12
           2505000    0x80005648 li a6, 33                      #; (wrb) a6  <-- 33
           2506000    0x8000564c bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2507000    0x80005650 bgeu a4, a3, 32                #; a4  = 0x100217b8, a3  = 0x100217c4, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2508000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001f778, a6  <~~ Word[0x1001f778]
           2509000    0x80005658 addi a5, a4, 4                 #; a4  = 0x100217b8, (wrb) a5  <-- 0x100217bc
           2510000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001f778, (wrb) a1  <-- 0x1001f77c
           2511000                                              #; (lsu) a6  <-- 0x80005e80
           2512000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x100217b8, 0x80005e80 ~~> Word[0x100217b8]
           2513000    0x80005664 mv a4, a5                      #; a5  = 0x100217bc, (wrb) a4  <-- 0x100217bc
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2514000    0x80005668 bltu a5, a3, -20               #; a5  = 0x100217bc, a3  = 0x100217c4, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2515000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001f77c, a6  <~~ Word[0x1001f77c]
           2516000    0x80005658 addi a5, a4, 4                 #; a4  = 0x100217bc, (wrb) a5  <-- 0x100217c0
           2517000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001f77c, (wrb) a1  <-- 0x1001f780
           2521000                                              #; (lsu) a6  <-- 1
           2522000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x100217bc, 1 ~~> Word[0x100217bc]
           2523000    0x80005664 mv a4, a5                      #; a5  = 0x100217c0, (wrb) a4  <-- 0x100217c0
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2524000    0x80005668 bltu a5, a3, -20               #; a5  = 0x100217c0, a3  = 0x100217c4, taken, goto 0x80005654
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
           2525000    0x80005654 lw a6, 0(a1)                   #; a1  = 0x1001f780, a6  <~~ Word[0x1001f780]
           2526000    0x80005658 addi a5, a4, 4                 #; a4  = 0x100217c0, (wrb) a5  <-- 0x100217c4
           2527000    0x8000565c addi a1, a1, 4                 #; a1  = 0x1001f780, (wrb) a1  <-- 0x1001f784
           2531000                                              #; (lsu) a6  <-- 1
           2532000    0x80005660 sw a6, 0(a4)                   #; a4  = 0x100217c0, 1 ~~> Word[0x100217c0]
           2533000    0x80005664 mv a4, a5                      #; a5  = 0x100217c4, (wrb) a4  <-- 0x100217c4
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
           2534000    0x80005668 bltu a5, a3, -20               #; a5  = 0x100217c4, a3  = 0x100217c4, not taken
           2535000    0x8000566c j 8                            #; goto 0x80005674
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
           2536000    0x80005674 bltu a5, a2, 20                #; a5  = 0x100217c4, a2  = 0x100217c4, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
           2537000    0x80005678 lw s0, 12(sp)                  #; sp  = 0x1001f728, s0  <~~ Word[0x1001f734]
           2538000    0x8000567c addi sp, sp, 16                #; sp  = 0x1001f728, (wrb) sp  <-- 0x1001f738
           2539000    0x80005680 ret                            #; ra  = 0x80003ee4, goto 0x80003ee4
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:79:17)
#;     tls_ptr += size;
#;             ^
           2540000    0x80003ee4 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
           2543000                                              #; (lsu) s0  <-- 12
           2544000                                              #; (lsu) a0  <-- 0x1001f778
           2545000    0x80003ee8 add a0, a0, s0                 #; a0  = 0x1001f778, s0  = 12, (wrb) a0  <-- 0x1001f784
           2546000    0x80003eec sw a0, 8(sp)                   #; sp  = 0x1001f738, 0x1001f784 ~~> Word[0x1001f740]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
           2547000    0x80003ef0 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
#; .LBB25_25 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
           2548000    0x80003ef4 auipc a1, 2                    #; (wrb) a1  <-- 0x80005ef4
           2549000    0x80003ef8 addi a1, a1, -412              #; a1  = 0x80005ef4, (wrb) a1  <-- 0x80005d58
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
           2550000    0x80003efc auipc a2, 2                    #; (wrb) a2  <-- 0x80005efc
           2551000                                              #; (lsu) a0  <-- 0x1001f784
           2553000    0x80003f00 addi a2, a2, -356              #; a2  = 0x80005efc, (wrb) a2  <-- 0x80005d98
           2554000    0x80003f04 sub s0, a2, a1                 #; a2  = 0x80005d98, a1  = 0x80005d58, (wrb) s0  <-- 64
           2555000    0x80003f08 li a1, 0                       #; (wrb) a1  <-- 0
           2556000    0x80003f0c mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
           2557000    0x80003f10 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f10
           2558000    0x80003f14 jalr 764(ra)                   #; ra  = 0x80003f10, (wrb) ra  <-- 0x80003f18, goto 0x8000420c
#; memset (memset.S:30)
#;   li t1, 15
           2561000    0x8000420c li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
           2562000    0x80004210 mv a4, a0                      #; a0  = 0x1001f784, (wrb) a4  <-- 0x1001f784
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
           2563000    0x80004214 bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
           2564000    0x80004218 andi a5, a4, 15                #; a4  = 0x1001f784, (wrb) a5  <-- 4
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
           2565000    0x8000421c bnez a5, 160                   #; a5  = 4, taken, goto 0x800042bc
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
           2568000    0x800042bc slli a3, a5, 2                 #; a5  = 4, (wrb) a3  <-- 16
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
           2571000    0x800042c0 auipc t0, 0                    #; (wrb) t0  <-- 0x800042c0
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
           2572000    0x800042c4 add a3, a3, t0                 #; a3  = 16, t0  = 0x800042c0, (wrb) a3  <-- 0x800042d0
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
           2573000    0x800042c8 mv t0, ra                      #; ra  = 0x80003f18, (wrb) t0  <-- 0x80003f18
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
           2574000    0x800042cc jalr -96(a3)                   #; a3  = 0x800042d0, (wrb) ra  <-- 0x800042d0, goto 0x80004270
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
           2577000    0x80004270 sb a1, 11(a4)                  #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f78f]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
           2578000    0x80004274 sb a1, 10(a4)                  #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f78e]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
           2579000    0x80004278 sb a1, 9(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f78d]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
           2580000    0x8000427c sb a1, 8(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f78c]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
           2582000    0x80004280 sb a1, 7(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f78b]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
           2584000    0x80004284 sb a1, 6(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f78a]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
           2585000    0x80004288 sb a1, 5(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f789]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
           2586000    0x8000428c sb a1, 4(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f788]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           2587000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f787]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           2588000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f786]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           2589000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f785]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           2590000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f784]
#; .Ltable (memset.S:85)
#;   ret
           2591000    0x800042a0 ret                            #; ra  = 0x800042d0, goto 0x800042d0
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           2592000    0x800042d0 mv ra, t0                      #; t0  = 0x80003f18, (wrb) ra  <-- 0x80003f18
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           2593000    0x800042d4 addi a5, a5, -16               #; a5  = 4, (wrb) a5  <-- -12
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           2594000    0x800042d8 sub a4, a4, a5                 #; a4  = 0x1001f784, a5  = -12, (wrb) a4  <-- 0x1001f790
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           2595000    0x800042dc add a2, a2, a5                 #; a2  = 64, a5  = -12, (wrb) a2  <-- 52
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           2596000    0x800042e0 bgeu t1, a2, -144              #; t1  = 15, a2  = 52, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           2597000    0x800042e4 j -196                         #; goto 0x80004220
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           2598000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           2599000    0x80004224 andi a3, a2, -16               #; a2  = 52, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           2600000    0x80004228 andi a2, a2, 15                #; a2  = 52, (wrb) a2  <-- 4
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           2601000    0x8000422c add a3, a3, a4                 #; a3  = 48, a4  = 0x1001f790, (wrb) a3  <-- 0x1001f7c0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2602000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001f790, 0 ~~> Word[0x1001f790]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2603000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001f790, 0 ~~> Word[0x1001f794]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2605000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001f790, 0 ~~> Word[0x1001f798]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2607000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001f790, 0 ~~> Word[0x1001f79c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2608000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001f790, (wrb) a4  <-- 0x1001f7a0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2609000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001f7a0, a3  = 0x1001f7c0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2610000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001f7a0, 0 ~~> Word[0x1001f7a0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2611000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001f7a0, 0 ~~> Word[0x1001f7a4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2613000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001f7a0, 0 ~~> Word[0x1001f7a8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2615000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001f7a0, 0 ~~> Word[0x1001f7ac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2616000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001f7a0, (wrb) a4  <-- 0x1001f7b0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2617000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001f7b0, a3  = 0x1001f7c0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2618000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001f7b0, 0 ~~> Word[0x1001f7b0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2619000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001f7b0, 0 ~~> Word[0x1001f7b4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2620000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001f7b0, 0 ~~> Word[0x1001f7b8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2621000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001f7b0, 0 ~~> Word[0x1001f7bc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2622000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001f7b0, (wrb) a4  <-- 0x1001f7c0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2623000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001f7c0, a3  = 0x1001f7c0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           2624000    0x80004248 bnez a2, 8                     #; a2  = 4, taken, goto 0x80004250
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
           2625000    0x80004250 sub a3, t1, a2                 #; t1  = 15, a2  = 4, (wrb) a3  <-- 11
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
           2626000    0x80004254 slli a3, a3, 2                 #; a3  = 11, (wrb) a3  <-- 44
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
           2627000    0x80004258 auipc t0, 0                    #; (wrb) t0  <-- 0x80004258
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
           2628000    0x8000425c add a3, a3, t0                 #; a3  = 44, t0  = 0x80004258, (wrb) a3  <-- 0x80004284
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
           2629000    0x80004260 jr 12(a3)                      #; a3  = 0x80004284, goto 0x80004290
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           2630000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x1001f7c0, 0 ~~> Byte[0x1001f7c3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           2631000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x1001f7c0, 0 ~~> Byte[0x1001f7c2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           2633000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x1001f7c0, 0 ~~> Byte[0x1001f7c1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           2635000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x1001f7c0, 0 ~~> Byte[0x1001f7c0]
#; .Ltable (memset.S:85)
#;   ret
           2636000    0x800042a0 ret                            #; ra  = 0x80003f18, goto 0x80003f18
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
           2637000    0x80003f18 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
           2640000                                              #; (lsu) a0  <-- 0x1001f784
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
           2641000    0x80003f1c addi a0, a0, 1032              #; a0  = 0x1001f784, (wrb) a0  <-- 0x1001fb8c
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
           2642000    0x80003f20 li a1, 0                       #; (wrb) a1  <-- 0
           2643000    0x80003f24 mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
           2644000    0x80003f28 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f28
           2645000    0x80003f2c jalr 740(ra)                   #; ra  = 0x80003f28, (wrb) ra  <-- 0x80003f30, goto 0x8000420c
#; memset (memset.S:30)
#;   li t1, 15
           2646000    0x8000420c li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
           2647000    0x80004210 mv a4, a0                      #; a0  = 0x1001fb8c, (wrb) a4  <-- 0x1001fb8c
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
           2648000    0x80004214 bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
           2649000    0x80004218 andi a5, a4, 15                #; a4  = 0x1001fb8c, (wrb) a5  <-- 12
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
           2650000    0x8000421c bnez a5, 160                   #; a5  = 12, taken, goto 0x800042bc
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
           2651000    0x800042bc slli a3, a5, 2                 #; a5  = 12, (wrb) a3  <-- 48
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
           2652000    0x800042c0 auipc t0, 0                    #; (wrb) t0  <-- 0x800042c0
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
           2653000    0x800042c4 add a3, a3, t0                 #; a3  = 48, t0  = 0x800042c0, (wrb) a3  <-- 0x800042f0
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
           2654000    0x800042c8 mv t0, ra                      #; ra  = 0x80003f30, (wrb) t0  <-- 0x80003f30
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
           2655000    0x800042cc jalr -96(a3)                   #; a3  = 0x800042f0, (wrb) ra  <-- 0x800042d0, goto 0x80004290
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           2656000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x1001fb8c, 0 ~~> Byte[0x1001fb8f]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           2657000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x1001fb8c, 0 ~~> Byte[0x1001fb8e]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           2658000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x1001fb8c, 0 ~~> Byte[0x1001fb8d]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           2659000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x1001fb8c, 0 ~~> Byte[0x1001fb8c]
#; .Ltable (memset.S:85)
#;   ret
           2660000    0x800042a0 ret                            #; ra  = 0x800042d0, goto 0x800042d0
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           2661000    0x800042d0 mv ra, t0                      #; t0  = 0x80003f30, (wrb) ra  <-- 0x80003f30
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           2662000    0x800042d4 addi a5, a5, -16               #; a5  = 12, (wrb) a5  <-- -4
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           2663000    0x800042d8 sub a4, a4, a5                 #; a4  = 0x1001fb8c, a5  = -4, (wrb) a4  <-- 0x1001fb90
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           2664000    0x800042dc add a2, a2, a5                 #; a2  = 64, a5  = -4, (wrb) a2  <-- 60
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           2665000    0x800042e0 bgeu t1, a2, -144              #; t1  = 15, a2  = 60, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           2666000    0x800042e4 j -196                         #; goto 0x80004220
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           2667000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           2668000    0x80004224 andi a3, a2, -16               #; a2  = 60, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           2669000    0x80004228 andi a2, a2, 15                #; a2  = 60, (wrb) a2  <-- 12
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           2670000    0x8000422c add a3, a3, a4                 #; a3  = 48, a4  = 0x1001fb90, (wrb) a3  <-- 0x1001fbc0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2671000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001fb90, 0 ~~> Word[0x1001fb90]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2672000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001fb90, 0 ~~> Word[0x1001fb94]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2673000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001fb90, 0 ~~> Word[0x1001fb98]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2674000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001fb90, 0 ~~> Word[0x1001fb9c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2675000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001fb90, (wrb) a4  <-- 0x1001fba0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2676000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001fba0, a3  = 0x1001fbc0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2677000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001fba0, 0 ~~> Word[0x1001fba0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2678000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001fba0, 0 ~~> Word[0x1001fba4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2679000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001fba0, 0 ~~> Word[0x1001fba8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2680000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001fba0, 0 ~~> Word[0x1001fbac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2681000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001fba0, (wrb) a4  <-- 0x1001fbb0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2682000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001fbb0, a3  = 0x1001fbc0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2683000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001fbb0, 0 ~~> Word[0x1001fbb0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2684000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001fbb0, 0 ~~> Word[0x1001fbb4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2685000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001fbb0, 0 ~~> Word[0x1001fbb8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2687000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001fbb0, 0 ~~> Word[0x1001fbbc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2688000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001fbb0, (wrb) a4  <-- 0x1001fbc0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2689000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001fbc0, a3  = 0x1001fbc0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           2690000    0x80004248 bnez a2, 8                     #; a2  = 12, taken, goto 0x80004250
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
           2691000    0x80004250 sub a3, t1, a2                 #; t1  = 15, a2  = 12, (wrb) a3  <-- 3
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
           2692000    0x80004254 slli a3, a3, 2                 #; a3  = 3, (wrb) a3  <-- 12
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
           2693000    0x80004258 auipc t0, 0                    #; (wrb) t0  <-- 0x80004258
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
           2694000    0x8000425c add a3, a3, t0                 #; a3  = 12, t0  = 0x80004258, (wrb) a3  <-- 0x80004264
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
           2695000    0x80004260 jr 12(a3)                      #; a3  = 0x80004264, goto 0x80004270
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
           2696000    0x80004270 sb a1, 11(a4)                  #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbcb]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
           2697000    0x80004274 sb a1, 10(a4)                  #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbca]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
           2698000    0x80004278 sb a1, 9(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc9]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
           2699000    0x8000427c sb a1, 8(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc8]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
           2700000    0x80004280 sb a1, 7(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc7]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
           2701000    0x80004284 sb a1, 6(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc6]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
           2702000    0x80004288 sb a1, 5(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc5]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
           2703000    0x8000428c sb a1, 4(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc4]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           2704000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           2705000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           2706000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           2707000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc0]
#; .Ltable (memset.S:85)
#;   ret
           2708000    0x800042a0 ret                            #; ra  = 0x80003f30, goto 0x80003f30
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
           2709000    0x80003f30 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
           2712000                                              #; (lsu) a0  <-- 0x1001f784
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
           2713000    0x80003f34 add a0, a0, s1                 #; a0  = 0x1001f784, s1  = 2064, (wrb) a0  <-- 0x1001ff94
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
           2714000    0x80003f38 li a1, 0                       #; (wrb) a1  <-- 0
           2715000    0x80003f3c mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
           2718000    0x80003f40 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f40
           2719000    0x80003f44 jalr 716(ra)                   #; ra  = 0x80003f40, (wrb) ra  <-- 0x80003f48, goto 0x8000420c
#; memset (memset.S:30)
#;   li t1, 15
           2720000    0x8000420c li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
           2721000    0x80004210 mv a4, a0                      #; a0  = 0x1001ff94, (wrb) a4  <-- 0x1001ff94
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
           2722000    0x80004214 bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
           2723000    0x80004218 andi a5, a4, 15                #; a4  = 0x1001ff94, (wrb) a5  <-- 4
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
           2724000    0x8000421c bnez a5, 160                   #; a5  = 4, taken, goto 0x800042bc
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
           2725000    0x800042bc slli a3, a5, 2                 #; a5  = 4, (wrb) a3  <-- 16
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
           2726000    0x800042c0 auipc t0, 0                    #; (wrb) t0  <-- 0x800042c0
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
           2727000    0x800042c4 add a3, a3, t0                 #; a3  = 16, t0  = 0x800042c0, (wrb) a3  <-- 0x800042d0
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
           2728000    0x800042c8 mv t0, ra                      #; ra  = 0x80003f48, (wrb) t0  <-- 0x80003f48
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
           2729000    0x800042cc jalr -96(a3)                   #; a3  = 0x800042d0, (wrb) ra  <-- 0x800042d0, goto 0x80004270
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
           2730000    0x80004270 sb a1, 11(a4)                  #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9f]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
           2731000    0x80004274 sb a1, 10(a4)                  #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9e]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
           2732000    0x80004278 sb a1, 9(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9d]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
           2733000    0x8000427c sb a1, 8(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9c]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
           2734000    0x80004280 sb a1, 7(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9b]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
           2736000    0x80004284 sb a1, 6(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9a]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
           2738000    0x80004288 sb a1, 5(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff99]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
           2739000    0x8000428c sb a1, 4(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff98]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           2740000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff97]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           2741000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff96]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           2742000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff95]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           2743000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff94]
#; .Ltable (memset.S:85)
#;   ret
           2744000    0x800042a0 ret                            #; ra  = 0x800042d0, goto 0x800042d0
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           2745000    0x800042d0 mv ra, t0                      #; t0  = 0x80003f48, (wrb) ra  <-- 0x80003f48
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           2746000    0x800042d4 addi a5, a5, -16               #; a5  = 4, (wrb) a5  <-- -12
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           2747000    0x800042d8 sub a4, a4, a5                 #; a4  = 0x1001ff94, a5  = -12, (wrb) a4  <-- 0x1001ffa0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           2748000    0x800042dc add a2, a2, a5                 #; a2  = 64, a5  = -12, (wrb) a2  <-- 52
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           2749000    0x800042e0 bgeu t1, a2, -144              #; t1  = 15, a2  = 52, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           2750000    0x800042e4 j -196                         #; goto 0x80004220
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           2751000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           2752000    0x80004224 andi a3, a2, -16               #; a2  = 52, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           2753000    0x80004228 andi a2, a2, 15                #; a2  = 52, (wrb) a2  <-- 4
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           2754000    0x8000422c add a3, a3, a4                 #; a3  = 48, a4  = 0x1001ffa0, (wrb) a3  <-- 0x1001ffd0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2755000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001ffa0, 0 ~~> Word[0x1001ffa0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2756000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001ffa0, 0 ~~> Word[0x1001ffa4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2757000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001ffa0, 0 ~~> Word[0x1001ffa8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2758000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001ffa0, 0 ~~> Word[0x1001ffac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2759000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001ffa0, (wrb) a4  <-- 0x1001ffb0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2760000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001ffb0, a3  = 0x1001ffd0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2761000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001ffb0, 0 ~~> Word[0x1001ffb0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2762000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001ffb0, 0 ~~> Word[0x1001ffb4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2763000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001ffb0, 0 ~~> Word[0x1001ffb8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2764000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001ffb0, 0 ~~> Word[0x1001ffbc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2765000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001ffb0, (wrb) a4  <-- 0x1001ffc0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2766000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001ffc0, a3  = 0x1001ffd0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2767000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x1001ffc0, 0 ~~> Word[0x1001ffc0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2768000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x1001ffc0, 0 ~~> Word[0x1001ffc4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2769000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x1001ffc0, 0 ~~> Word[0x1001ffc8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2770000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x1001ffc0, 0 ~~> Word[0x1001ffcc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2771000    0x80004240 addi a4, a4, 16                #; a4  = 0x1001ffc0, (wrb) a4  <-- 0x1001ffd0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2772000    0x80004244 bltu a4, a3, -20               #; a4  = 0x1001ffd0, a3  = 0x1001ffd0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           2773000    0x80004248 bnez a2, 8                     #; a2  = 4, taken, goto 0x80004250
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
           2774000    0x80004250 sub a3, t1, a2                 #; t1  = 15, a2  = 4, (wrb) a3  <-- 11
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
           2775000    0x80004254 slli a3, a3, 2                 #; a3  = 11, (wrb) a3  <-- 44
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
           2776000    0x80004258 auipc t0, 0                    #; (wrb) t0  <-- 0x80004258
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
           2777000    0x8000425c add a3, a3, t0                 #; a3  = 44, t0  = 0x80004258, (wrb) a3  <-- 0x80004284
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
           2778000    0x80004260 jr 12(a3)                      #; a3  = 0x80004284, goto 0x80004290
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           2779000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x1001ffd0, 0 ~~> Byte[0x1001ffd3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           2780000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x1001ffd0, 0 ~~> Byte[0x1001ffd2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           2781000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x1001ffd0, 0 ~~> Byte[0x1001ffd1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           2782000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x1001ffd0, 0 ~~> Byte[0x1001ffd0]
#; .Ltable (memset.S:85)
#;   ret
           2783000    0x800042a0 ret                            #; ra  = 0x80003f48, goto 0x80003f48
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
           2784000    0x80003f48 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
           2787000                                              #; (lsu) a0  <-- 0x1001f784
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
           2788000    0x80003f4c add a0, a0, s6                 #; a0  = 0x1001f784, s6  = 3096, (wrb) a0  <-- 0x1002039c
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
           2789000    0x80003f50 li a1, 0                       #; (wrb) a1  <-- 0
           2790000    0x80003f54 mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
           2791000    0x80003f58 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f58
           2792000    0x80003f5c jalr 692(ra)                   #; ra  = 0x80003f58, (wrb) ra  <-- 0x80003f60, goto 0x8000420c
#; memset (memset.S:30)
#;   li t1, 15
           2793000    0x8000420c li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
           2794000    0x80004210 mv a4, a0                      #; a0  = 0x1002039c, (wrb) a4  <-- 0x1002039c
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
           2795000    0x80004214 bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
           2796000    0x80004218 andi a5, a4, 15                #; a4  = 0x1002039c, (wrb) a5  <-- 12
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
           2797000    0x8000421c bnez a5, 160                   #; a5  = 12, taken, goto 0x800042bc
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
           2798000    0x800042bc slli a3, a5, 2                 #; a5  = 12, (wrb) a3  <-- 48
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
           2799000    0x800042c0 auipc t0, 0                    #; (wrb) t0  <-- 0x800042c0
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
           2800000    0x800042c4 add a3, a3, t0                 #; a3  = 48, t0  = 0x800042c0, (wrb) a3  <-- 0x800042f0
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
           2801000    0x800042c8 mv t0, ra                      #; ra  = 0x80003f60, (wrb) t0  <-- 0x80003f60
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
           2802000    0x800042cc jalr -96(a3)                   #; a3  = 0x800042f0, (wrb) ra  <-- 0x800042d0, goto 0x80004290
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           2803000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x1002039c, 0 ~~> Byte[0x1002039f]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           2804000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x1002039c, 0 ~~> Byte[0x1002039e]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           2810000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x1002039c, 0 ~~> Byte[0x1002039d]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           2829000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x1002039c, 0 ~~> Byte[0x1002039c]
#; .Ltable (memset.S:85)
#;   ret
           2830000    0x800042a0 ret                            #; ra  = 0x800042d0, goto 0x800042d0
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           2831000    0x800042d0 mv ra, t0                      #; t0  = 0x80003f60, (wrb) ra  <-- 0x80003f60
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           2832000    0x800042d4 addi a5, a5, -16               #; a5  = 12, (wrb) a5  <-- -4
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           2833000    0x800042d8 sub a4, a4, a5                 #; a4  = 0x1002039c, a5  = -4, (wrb) a4  <-- 0x100203a0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           2834000    0x800042dc add a2, a2, a5                 #; a2  = 64, a5  = -4, (wrb) a2  <-- 60
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           2835000    0x800042e0 bgeu t1, a2, -144              #; t1  = 15, a2  = 60, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           2836000    0x800042e4 j -196                         #; goto 0x80004220
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           2837000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           2838000    0x80004224 andi a3, a2, -16               #; a2  = 60, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           2839000    0x80004228 andi a2, a2, 15                #; a2  = 60, (wrb) a2  <-- 12
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           2840000    0x8000422c add a3, a3, a4                 #; a3  = 48, a4  = 0x100203a0, (wrb) a3  <-- 0x100203d0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2841000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x100203a0, 0 ~~> Word[0x100203a0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2859000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x100203a0, 0 ~~> Word[0x100203a4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2879000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x100203a0, 0 ~~> Word[0x100203a8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2899000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x100203a0, 0 ~~> Word[0x100203ac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2900000    0x80004240 addi a4, a4, 16                #; a4  = 0x100203a0, (wrb) a4  <-- 0x100203b0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2901000    0x80004244 bltu a4, a3, -20               #; a4  = 0x100203b0, a3  = 0x100203d0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2910000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x100203b0, 0 ~~> Word[0x100203b0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2939000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x100203b0, 0 ~~> Word[0x100203b4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2969000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x100203b0, 0 ~~> Word[0x100203b8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2999000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x100203b0, 0 ~~> Word[0x100203bc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           3000000    0x80004240 addi a4, a4, 16                #; a4  = 0x100203b0, (wrb) a4  <-- 0x100203c0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           3001000    0x80004244 bltu a4, a3, -20               #; a4  = 0x100203c0, a3  = 0x100203d0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           3039000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x100203c0, 0 ~~> Word[0x100203c0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           3079000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x100203c0, 0 ~~> Word[0x100203c4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           3119000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x100203c0, 0 ~~> Word[0x100203c8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           3159000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x100203c0, 0 ~~> Word[0x100203cc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           3160000    0x80004240 addi a4, a4, 16                #; a4  = 0x100203c0, (wrb) a4  <-- 0x100203d0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           3161000    0x80004244 bltu a4, a3, -20               #; a4  = 0x100203d0, a3  = 0x100203d0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           3162000    0x80004248 bnez a2, 8                     #; a2  = 12, taken, goto 0x80004250
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
           3163000    0x80004250 sub a3, t1, a2                 #; t1  = 15, a2  = 12, (wrb) a3  <-- 3
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
           3164000    0x80004254 slli a3, a3, 2                 #; a3  = 3, (wrb) a3  <-- 12
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
           3165000    0x80004258 auipc t0, 0                    #; (wrb) t0  <-- 0x80004258
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
           3166000    0x8000425c add a3, a3, t0                 #; a3  = 12, t0  = 0x80004258, (wrb) a3  <-- 0x80004264
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
           3167000    0x80004260 jr 12(a3)                      #; a3  = 0x80004264, goto 0x80004270
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
           3199000    0x80004270 sb a1, 11(a4)                  #; a4  = 0x100203d0, 0 ~~> Byte[0x100203db]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
           3239000    0x80004274 sb a1, 10(a4)                  #; a4  = 0x100203d0, 0 ~~> Byte[0x100203da]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
           3279000    0x80004278 sb a1, 9(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d9]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
           3319000    0x8000427c sb a1, 8(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d8]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
           3359000    0x80004280 sb a1, 7(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d7]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
           3399000    0x80004284 sb a1, 6(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d6]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
           3439000    0x80004288 sb a1, 5(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d5]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
           3479000    0x8000428c sb a1, 4(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d4]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           3519000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           3559000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           3599000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           3639000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d0]
#; .Ltable (memset.S:85)
#;   ret
           3640000    0x800042a0 ret                            #; ra  = 0x80003f60, goto 0x80003f60
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
           3679000    0x80003f60 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
           3729000                                              #; (lsu) a0  <-- 0x1001f784
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
           3730000    0x80003f64 add a0, a0, s7                 #; a0  = 0x1001f784, s7  = 4128, (wrb) a0  <-- 0x100207a4
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
           3731000    0x80003f68 li a1, 0                       #; (wrb) a1  <-- 0
           3732000    0x80003f6c mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
           3733000    0x80003f70 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f70
           3734000    0x80003f74 jalr 668(ra)                   #; ra  = 0x80003f70, (wrb) ra  <-- 0x80003f78, goto 0x8000420c
#; memset (memset.S:30)
#;   li t1, 15
           3735000    0x8000420c li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
           3736000    0x80004210 mv a4, a0                      #; a0  = 0x100207a4, (wrb) a4  <-- 0x100207a4
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
           3737000    0x80004214 bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
           3738000    0x80004218 andi a5, a4, 15                #; a4  = 0x100207a4, (wrb) a5  <-- 4
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
           3739000    0x8000421c bnez a5, 160                   #; a5  = 4, taken, goto 0x800042bc
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
           3740000    0x800042bc slli a3, a5, 2                 #; a5  = 4, (wrb) a3  <-- 16
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
           3741000    0x800042c0 auipc t0, 0                    #; (wrb) t0  <-- 0x800042c0
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
           3742000    0x800042c4 add a3, a3, t0                 #; a3  = 16, t0  = 0x800042c0, (wrb) a3  <-- 0x800042d0
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
           3743000    0x800042c8 mv t0, ra                      #; ra  = 0x80003f78, (wrb) t0  <-- 0x80003f78
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
           3744000    0x800042cc jalr -96(a3)                   #; a3  = 0x800042d0, (wrb) ra  <-- 0x800042d0, goto 0x80004270
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
           3745000    0x80004270 sb a1, 11(a4)                  #; a4  = 0x100207a4, 0 ~~> Byte[0x100207af]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
           3746000    0x80004274 sb a1, 10(a4)                  #; a4  = 0x100207a4, 0 ~~> Byte[0x100207ae]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
           3759000    0x80004278 sb a1, 9(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207ad]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
           3799000    0x8000427c sb a1, 8(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207ac]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
           3839000    0x80004280 sb a1, 7(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207ab]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
           3879000    0x80004284 sb a1, 6(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207aa]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
           3919000    0x80004288 sb a1, 5(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207a9]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
           3959000    0x8000428c sb a1, 4(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207a8]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           3999000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207a7]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           4039000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207a6]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           4079000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207a5]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           4119000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207a4]
#; .Ltable (memset.S:85)
#;   ret
           4120000    0x800042a0 ret                            #; ra  = 0x800042d0, goto 0x800042d0
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           4121000    0x800042d0 mv ra, t0                      #; t0  = 0x80003f78, (wrb) ra  <-- 0x80003f78
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           4122000    0x800042d4 addi a5, a5, -16               #; a5  = 4, (wrb) a5  <-- -12
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           4123000    0x800042d8 sub a4, a4, a5                 #; a4  = 0x100207a4, a5  = -12, (wrb) a4  <-- 0x100207b0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           4124000    0x800042dc add a2, a2, a5                 #; a2  = 64, a5  = -12, (wrb) a2  <-- 52
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           4125000    0x800042e0 bgeu t1, a2, -144              #; t1  = 15, a2  = 52, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           4126000    0x800042e4 j -196                         #; goto 0x80004220
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           4127000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           4128000    0x80004224 andi a3, a2, -16               #; a2  = 52, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           4129000    0x80004228 andi a2, a2, 15                #; a2  = 52, (wrb) a2  <-- 4
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           4130000    0x8000422c add a3, a3, a4                 #; a3  = 48, a4  = 0x100207b0, (wrb) a3  <-- 0x100207e0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           4150000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x100207b0, 0 ~~> Word[0x100207b0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           4189000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x100207b0, 0 ~~> Word[0x100207b4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           4220000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x100207b0, 0 ~~> Word[0x100207b8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           4259000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x100207b0, 0 ~~> Word[0x100207bc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           4260000    0x80004240 addi a4, a4, 16                #; a4  = 0x100207b0, (wrb) a4  <-- 0x100207c0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           4261000    0x80004244 bltu a4, a3, -20               #; a4  = 0x100207c0, a3  = 0x100207e0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           4290000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x100207c0, 0 ~~> Word[0x100207c0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           4329000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x100207c0, 0 ~~> Word[0x100207c4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           4360000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x100207c0, 0 ~~> Word[0x100207c8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           4399000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x100207c0, 0 ~~> Word[0x100207cc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           4400000    0x80004240 addi a4, a4, 16                #; a4  = 0x100207c0, (wrb) a4  <-- 0x100207d0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           4401000    0x80004244 bltu a4, a3, -20               #; a4  = 0x100207d0, a3  = 0x100207e0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           4430000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x100207d0, 0 ~~> Word[0x100207d0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           4469000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x100207d0, 0 ~~> Word[0x100207d4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           4500000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x100207d0, 0 ~~> Word[0x100207d8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           4539000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x100207d0, 0 ~~> Word[0x100207dc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           4540000    0x80004240 addi a4, a4, 16                #; a4  = 0x100207d0, (wrb) a4  <-- 0x100207e0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           4541000    0x80004244 bltu a4, a3, -20               #; a4  = 0x100207e0, a3  = 0x100207e0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           4542000    0x80004248 bnez a2, 8                     #; a2  = 4, taken, goto 0x80004250
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
           4543000    0x80004250 sub a3, t1, a2                 #; t1  = 15, a2  = 4, (wrb) a3  <-- 11
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
           4544000    0x80004254 slli a3, a3, 2                 #; a3  = 11, (wrb) a3  <-- 44
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
           4545000    0x80004258 auipc t0, 0                    #; (wrb) t0  <-- 0x80004258
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
           4546000    0x8000425c add a3, a3, t0                 #; a3  = 44, t0  = 0x80004258, (wrb) a3  <-- 0x80004284
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
           4547000    0x80004260 jr 12(a3)                      #; a3  = 0x80004284, goto 0x80004290
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           4570000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x100207e0, 0 ~~> Byte[0x100207e3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           4609000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x100207e0, 0 ~~> Byte[0x100207e2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           4640000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x100207e0, 0 ~~> Byte[0x100207e1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           4679000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x100207e0, 0 ~~> Byte[0x100207e0]
#; .Ltable (memset.S:85)
#;   ret
           4680000    0x800042a0 ret                            #; ra  = 0x80003f78, goto 0x80003f78
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
           4710000    0x80003f78 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
           4759000                                              #; (lsu) a0  <-- 0x1001f784
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
           4760000    0x80003f7c add a0, a0, s8                 #; a0  = 0x1001f784, s8  = 5160, (wrb) a0  <-- 0x10020bac
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
           4763000    0x80003f80 li a1, 0                       #; (wrb) a1  <-- 0
           4764000    0x80003f84 mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
           4765000    0x80003f88 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f88
           4766000    0x80003f8c jalr 644(ra)                   #; ra  = 0x80003f88, (wrb) ra  <-- 0x80003f90, goto 0x8000420c
#; memset (memset.S:30)
#;   li t1, 15
           4767000    0x8000420c li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
           4768000    0x80004210 mv a4, a0                      #; a0  = 0x10020bac, (wrb) a4  <-- 0x10020bac
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
           4769000    0x80004214 bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
           4770000    0x80004218 andi a5, a4, 15                #; a4  = 0x10020bac, (wrb) a5  <-- 12
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
           4771000    0x8000421c bnez a5, 160                   #; a5  = 12, taken, goto 0x800042bc
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
           4772000    0x800042bc slli a3, a5, 2                 #; a5  = 12, (wrb) a3  <-- 48
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
           4773000    0x800042c0 auipc t0, 0                    #; (wrb) t0  <-- 0x800042c0
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
           4774000    0x800042c4 add a3, a3, t0                 #; a3  = 48, t0  = 0x800042c0, (wrb) a3  <-- 0x800042f0
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
           4775000    0x800042c8 mv t0, ra                      #; ra  = 0x80003f90, (wrb) t0  <-- 0x80003f90
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
           4776000    0x800042cc jalr -96(a3)                   #; a3  = 0x800042f0, (wrb) ra  <-- 0x800042d0, goto 0x80004290
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           4777000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x10020bac, 0 ~~> Byte[0x10020baf]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           4778000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x10020bac, 0 ~~> Byte[0x10020bae]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           4780000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x10020bac, 0 ~~> Byte[0x10020bad]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           4819000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x10020bac, 0 ~~> Byte[0x10020bac]
#; .Ltable (memset.S:85)
#;   ret
           4820000    0x800042a0 ret                            #; ra  = 0x800042d0, goto 0x800042d0
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           4821000    0x800042d0 mv ra, t0                      #; t0  = 0x80003f90, (wrb) ra  <-- 0x80003f90
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           4822000    0x800042d4 addi a5, a5, -16               #; a5  = 12, (wrb) a5  <-- -4
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           4823000    0x800042d8 sub a4, a4, a5                 #; a4  = 0x10020bac, a5  = -4, (wrb) a4  <-- 0x10020bb0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           4824000    0x800042dc add a2, a2, a5                 #; a2  = 64, a5  = -4, (wrb) a2  <-- 60
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           4825000    0x800042e0 bgeu t1, a2, -144              #; t1  = 15, a2  = 60, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           4826000    0x800042e4 j -196                         #; goto 0x80004220
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           4827000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           4828000    0x80004224 andi a3, a2, -16               #; a2  = 60, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           4829000    0x80004228 andi a2, a2, 15                #; a2  = 60, (wrb) a2  <-- 12
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           4830000    0x8000422c add a3, a3, a4                 #; a3  = 48, a4  = 0x10020bb0, (wrb) a3  <-- 0x10020be0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           4850000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x10020bb0, 0 ~~> Word[0x10020bb0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           4889000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x10020bb0, 0 ~~> Word[0x10020bb4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           4920000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x10020bb0, 0 ~~> Word[0x10020bb8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           4959000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x10020bb0, 0 ~~> Word[0x10020bbc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           4960000    0x80004240 addi a4, a4, 16                #; a4  = 0x10020bb0, (wrb) a4  <-- 0x10020bc0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           4961000    0x80004244 bltu a4, a3, -20               #; a4  = 0x10020bc0, a3  = 0x10020be0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           4990000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x10020bc0, 0 ~~> Word[0x10020bc0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           5029000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x10020bc0, 0 ~~> Word[0x10020bc4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           5060000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x10020bc0, 0 ~~> Word[0x10020bc8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           5099000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x10020bc0, 0 ~~> Word[0x10020bcc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           5100000    0x80004240 addi a4, a4, 16                #; a4  = 0x10020bc0, (wrb) a4  <-- 0x10020bd0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           5101000    0x80004244 bltu a4, a3, -20               #; a4  = 0x10020bd0, a3  = 0x10020be0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           5129000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x10020bd0, 0 ~~> Word[0x10020bd0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           5159000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x10020bd0, 0 ~~> Word[0x10020bd4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           5189000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x10020bd0, 0 ~~> Word[0x10020bd8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           5219000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x10020bd0, 0 ~~> Word[0x10020bdc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           5220000    0x80004240 addi a4, a4, 16                #; a4  = 0x10020bd0, (wrb) a4  <-- 0x10020be0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           5221000    0x80004244 bltu a4, a3, -20               #; a4  = 0x10020be0, a3  = 0x10020be0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           5222000    0x80004248 bnez a2, 8                     #; a2  = 12, taken, goto 0x80004250
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
           5223000    0x80004250 sub a3, t1, a2                 #; t1  = 15, a2  = 12, (wrb) a3  <-- 3
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
           5224000    0x80004254 slli a3, a3, 2                 #; a3  = 3, (wrb) a3  <-- 12
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
           5225000    0x80004258 auipc t0, 0                    #; (wrb) t0  <-- 0x80004258
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
           5226000    0x8000425c add a3, a3, t0                 #; a3  = 12, t0  = 0x80004258, (wrb) a3  <-- 0x80004264
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
           5227000    0x80004260 jr 12(a3)                      #; a3  = 0x80004264, goto 0x80004270
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
           5249000    0x80004270 sb a1, 11(a4)                  #; a4  = 0x10020be0, 0 ~~> Byte[0x10020beb]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
           5279000    0x80004274 sb a1, 10(a4)                  #; a4  = 0x10020be0, 0 ~~> Byte[0x10020bea]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
           5309000    0x80004278 sb a1, 9(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be9]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
           5339000    0x8000427c sb a1, 8(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be8]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
           5369000    0x80004280 sb a1, 7(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be7]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
           5399000    0x80004284 sb a1, 6(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be6]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
           5429000    0x80004288 sb a1, 5(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be5]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
           5459000    0x8000428c sb a1, 4(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be4]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           5489000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           5510000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           5540000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           5570000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be0]
#; .Ltable (memset.S:85)
#;   ret
           5571000    0x800042a0 ret                            #; ra  = 0x80003f90, goto 0x80003f90
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
           5600000    0x80003f90 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
           5640000                                              #; (lsu) a0  <-- 0x1001f784
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
           5641000    0x80003f94 add a0, a0, s9                 #; a0  = 0x1001f784, s9  = 6192, (wrb) a0  <-- 0x10020fb4
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
           5642000    0x80003f98 li a1, 0                       #; (wrb) a1  <-- 0
           5643000    0x80003f9c mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
           5644000    0x80003fa0 auipc ra, 0                    #; (wrb) ra  <-- 0x80003fa0
           5645000    0x80003fa4 jalr 620(ra)                   #; ra  = 0x80003fa0, (wrb) ra  <-- 0x80003fa8, goto 0x8000420c
#; memset (memset.S:30)
#;   li t1, 15
           5646000    0x8000420c li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
           5647000    0x80004210 mv a4, a0                      #; a0  = 0x10020fb4, (wrb) a4  <-- 0x10020fb4
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
           5648000    0x80004214 bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
           5649000    0x80004218 andi a5, a4, 15                #; a4  = 0x10020fb4, (wrb) a5  <-- 4
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
           5650000    0x8000421c bnez a5, 160                   #; a5  = 4, taken, goto 0x800042bc
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
           5651000    0x800042bc slli a3, a5, 2                 #; a5  = 4, (wrb) a3  <-- 16
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
           5652000    0x800042c0 auipc t0, 0                    #; (wrb) t0  <-- 0x800042c0
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
           5653000    0x800042c4 add a3, a3, t0                 #; a3  = 16, t0  = 0x800042c0, (wrb) a3  <-- 0x800042d0
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
           5654000    0x800042c8 mv t0, ra                      #; ra  = 0x80003fa8, (wrb) t0  <-- 0x80003fa8
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
           5655000    0x800042cc jalr -96(a3)                   #; a3  = 0x800042d0, (wrb) ra  <-- 0x800042d0, goto 0x80004270
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
           5656000    0x80004270 sb a1, 11(a4)                  #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fbf]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
           5657000    0x80004274 sb a1, 10(a4)                  #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fbe]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
           5660000    0x80004278 sb a1, 9(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fbd]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
           5690000    0x8000427c sb a1, 8(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fbc]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
           5720000    0x80004280 sb a1, 7(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fbb]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
           5750000    0x80004284 sb a1, 6(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fba]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
           5779000    0x80004288 sb a1, 5(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fb9]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
           5809000    0x8000428c sb a1, 4(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fb8]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           5839000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fb7]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           5859000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fb6]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           5884000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fb5]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           5909000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fb4]
#; .Ltable (memset.S:85)
#;   ret
           5910000    0x800042a0 ret                            #; ra  = 0x800042d0, goto 0x800042d0
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           5911000    0x800042d0 mv ra, t0                      #; t0  = 0x80003fa8, (wrb) ra  <-- 0x80003fa8
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           5912000    0x800042d4 addi a5, a5, -16               #; a5  = 4, (wrb) a5  <-- -12
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           5913000    0x800042d8 sub a4, a4, a5                 #; a4  = 0x10020fb4, a5  = -12, (wrb) a4  <-- 0x10020fc0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           5914000    0x800042dc add a2, a2, a5                 #; a2  = 64, a5  = -12, (wrb) a2  <-- 52
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           5915000    0x800042e0 bgeu t1, a2, -144              #; t1  = 15, a2  = 52, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           5916000    0x800042e4 j -196                         #; goto 0x80004220
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           5917000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           5918000    0x80004224 andi a3, a2, -16               #; a2  = 52, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           5919000    0x80004228 andi a2, a2, 15                #; a2  = 52, (wrb) a2  <-- 4
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           5920000    0x8000422c add a3, a3, a4                 #; a3  = 48, a4  = 0x10020fc0, (wrb) a3  <-- 0x10020ff0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           5934000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x10020fc0, 0 ~~> Word[0x10020fc0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           5959000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x10020fc0, 0 ~~> Word[0x10020fc4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           5984000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x10020fc0, 0 ~~> Word[0x10020fc8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6009000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x10020fc0, 0 ~~> Word[0x10020fcc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6010000    0x80004240 addi a4, a4, 16                #; a4  = 0x10020fc0, (wrb) a4  <-- 0x10020fd0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6011000    0x80004244 bltu a4, a3, -20               #; a4  = 0x10020fd0, a3  = 0x10020ff0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6034000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x10020fd0, 0 ~~> Word[0x10020fd0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           6059000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x10020fd0, 0 ~~> Word[0x10020fd4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           6084000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x10020fd0, 0 ~~> Word[0x10020fd8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6109000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x10020fd0, 0 ~~> Word[0x10020fdc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6110000    0x80004240 addi a4, a4, 16                #; a4  = 0x10020fd0, (wrb) a4  <-- 0x10020fe0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6111000    0x80004244 bltu a4, a3, -20               #; a4  = 0x10020fe0, a3  = 0x10020ff0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6134000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x10020fe0, 0 ~~> Word[0x10020fe0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           6159000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x10020fe0, 0 ~~> Word[0x10020fe4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           6184000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x10020fe0, 0 ~~> Word[0x10020fe8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6209000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x10020fe0, 0 ~~> Word[0x10020fec]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6210000    0x80004240 addi a4, a4, 16                #; a4  = 0x10020fe0, (wrb) a4  <-- 0x10020ff0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6211000    0x80004244 bltu a4, a3, -20               #; a4  = 0x10020ff0, a3  = 0x10020ff0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           6212000    0x80004248 bnez a2, 8                     #; a2  = 4, taken, goto 0x80004250
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
           6213000    0x80004250 sub a3, t1, a2                 #; t1  = 15, a2  = 4, (wrb) a3  <-- 11
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
           6214000    0x80004254 slli a3, a3, 2                 #; a3  = 11, (wrb) a3  <-- 44
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
           6215000    0x80004258 auipc t0, 0                    #; (wrb) t0  <-- 0x80004258
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
           6216000    0x8000425c add a3, a3, t0                 #; a3  = 44, t0  = 0x80004258, (wrb) a3  <-- 0x80004284
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
           6217000    0x80004260 jr 12(a3)                      #; a3  = 0x80004284, goto 0x80004290
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           6234000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x10020ff0, 0 ~~> Byte[0x10020ff3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           6259000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x10020ff0, 0 ~~> Byte[0x10020ff2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           6279000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x10020ff0, 0 ~~> Byte[0x10020ff1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           6307000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x10020ff0, 0 ~~> Byte[0x10020ff0]
#; .Ltable (memset.S:85)
#;   ret
           6308000    0x800042a0 ret                            #; ra  = 0x80003fa8, goto 0x80003fa8
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
           6332000    0x80003fa8 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
           6367000                                              #; (lsu) a0  <-- 0x1001f784
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
           6368000    0x80003fac add a0, a0, s10                #; a0  = 0x1001f784, s10 = 7224, (wrb) a0  <-- 0x100213bc
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
           6369000    0x80003fb0 li a1, 0                       #; (wrb) a1  <-- 0
           6370000    0x80003fb4 mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
           6371000    0x80003fb8 auipc ra, 0                    #; (wrb) ra  <-- 0x80003fb8
           6372000    0x80003fbc jalr 596(ra)                   #; ra  = 0x80003fb8, (wrb) ra  <-- 0x80003fc0, goto 0x8000420c
#; memset (memset.S:30)
#;   li t1, 15
           6373000    0x8000420c li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
           6374000    0x80004210 mv a4, a0                      #; a0  = 0x100213bc, (wrb) a4  <-- 0x100213bc
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
           6375000    0x80004214 bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
           6376000    0x80004218 andi a5, a4, 15                #; a4  = 0x100213bc, (wrb) a5  <-- 12
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
           6377000    0x8000421c bnez a5, 160                   #; a5  = 12, taken, goto 0x800042bc
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
           6378000    0x800042bc slli a3, a5, 2                 #; a5  = 12, (wrb) a3  <-- 48
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
           6379000    0x800042c0 auipc t0, 0                    #; (wrb) t0  <-- 0x800042c0
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
           6380000    0x800042c4 add a3, a3, t0                 #; a3  = 48, t0  = 0x800042c0, (wrb) a3  <-- 0x800042f0
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
           6381000    0x800042c8 mv t0, ra                      #; ra  = 0x80003fc0, (wrb) t0  <-- 0x80003fc0
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
           6382000    0x800042cc jalr -96(a3)                   #; a3  = 0x800042f0, (wrb) ra  <-- 0x800042d0, goto 0x80004290
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           6383000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x100213bc, 0 ~~> Byte[0x100213bf]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           6384000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x100213bc, 0 ~~> Byte[0x100213be]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           6399000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x100213bc, 0 ~~> Byte[0x100213bd]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           6421000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x100213bc, 0 ~~> Byte[0x100213bc]
#; .Ltable (memset.S:85)
#;   ret
           6422000    0x800042a0 ret                            #; ra  = 0x800042d0, goto 0x800042d0
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           6423000    0x800042d0 mv ra, t0                      #; t0  = 0x80003fc0, (wrb) ra  <-- 0x80003fc0
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           6424000    0x800042d4 addi a5, a5, -16               #; a5  = 12, (wrb) a5  <-- -4
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           6425000    0x800042d8 sub a4, a4, a5                 #; a4  = 0x100213bc, a5  = -4, (wrb) a4  <-- 0x100213c0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           6426000    0x800042dc add a2, a2, a5                 #; a2  = 64, a5  = -4, (wrb) a2  <-- 60
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           6427000    0x800042e0 bgeu t1, a2, -144              #; t1  = 15, a2  = 60, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           6428000    0x800042e4 j -196                         #; goto 0x80004220
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           6429000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           6430000    0x80004224 andi a3, a2, -16               #; a2  = 60, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           6431000    0x80004228 andi a2, a2, 15                #; a2  = 60, (wrb) a2  <-- 12
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           6432000    0x8000422c add a3, a3, a4                 #; a3  = 48, a4  = 0x100213c0, (wrb) a3  <-- 0x100213f0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6443000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x100213c0, 0 ~~> Word[0x100213c0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           6465000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x100213c0, 0 ~~> Word[0x100213c4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           6485000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x100213c0, 0 ~~> Word[0x100213c8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6507000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x100213c0, 0 ~~> Word[0x100213cc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6508000    0x80004240 addi a4, a4, 16                #; a4  = 0x100213c0, (wrb) a4  <-- 0x100213d0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6509000    0x80004244 bltu a4, a3, -20               #; a4  = 0x100213d0, a3  = 0x100213f0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6529000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x100213d0, 0 ~~> Word[0x100213d0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           6538000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x100213d0, 0 ~~> Word[0x100213d4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           6550000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x100213d0, 0 ~~> Word[0x100213d8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6564000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x100213d0, 0 ~~> Word[0x100213dc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6565000    0x80004240 addi a4, a4, 16                #; a4  = 0x100213d0, (wrb) a4  <-- 0x100213e0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6566000    0x80004244 bltu a4, a3, -20               #; a4  = 0x100213e0, a3  = 0x100213f0, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6578000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x100213e0, 0 ~~> Word[0x100213e0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           6592000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x100213e0, 0 ~~> Word[0x100213e4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           6606000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x100213e0, 0 ~~> Word[0x100213e8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6620000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x100213e0, 0 ~~> Word[0x100213ec]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6621000    0x80004240 addi a4, a4, 16                #; a4  = 0x100213e0, (wrb) a4  <-- 0x100213f0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6622000    0x80004244 bltu a4, a3, -20               #; a4  = 0x100213f0, a3  = 0x100213f0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           6623000    0x80004248 bnez a2, 8                     #; a2  = 12, taken, goto 0x80004250
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
           6624000    0x80004250 sub a3, t1, a2                 #; t1  = 15, a2  = 12, (wrb) a3  <-- 3
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
           6625000    0x80004254 slli a3, a3, 2                 #; a3  = 3, (wrb) a3  <-- 12
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
           6626000    0x80004258 auipc t0, 0                    #; (wrb) t0  <-- 0x80004258
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
           6627000    0x8000425c add a3, a3, t0                 #; a3  = 12, t0  = 0x80004258, (wrb) a3  <-- 0x80004264
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
           6628000    0x80004260 jr 12(a3)                      #; a3  = 0x80004264, goto 0x80004270
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
           6634000    0x80004270 sb a1, 11(a4)                  #; a4  = 0x100213f0, 0 ~~> Byte[0x100213fb]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
           6648000    0x80004274 sb a1, 10(a4)                  #; a4  = 0x100213f0, 0 ~~> Byte[0x100213fa]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
           6662000    0x80004278 sb a1, 9(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f9]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
           6676000    0x8000427c sb a1, 8(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f8]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
           6690000    0x80004280 sb a1, 7(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f7]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
           6704000    0x80004284 sb a1, 6(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f6]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
           6718000    0x80004288 sb a1, 5(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f5]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
           6732000    0x8000428c sb a1, 4(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f4]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           6746000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           6760000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           6769000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           6781000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f0]
#; .Ltable (memset.S:85)
#;   ret
           6782000    0x800042a0 ret                            #; ra  = 0x80003fc0, goto 0x80003fc0
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
           6795000    0x80003fc0 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
           6816000                                              #; (lsu) a0  <-- 0x1001f784
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
           6817000    0x80003fc4 add a0, a0, s11                #; a0  = 0x1001f784, s11 = 8256, (wrb) a0  <-- 0x100217c4
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
           6818000    0x80003fc8 li a1, 0                       #; (wrb) a1  <-- 0
           6819000    0x80003fcc mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
           6820000    0x80003fd0 auipc ra, 0                    #; (wrb) ra  <-- 0x80003fd0
           6821000    0x80003fd4 jalr 572(ra)                   #; ra  = 0x80003fd0, (wrb) ra  <-- 0x80003fd8, goto 0x8000420c
#; memset (memset.S:30)
#;   li t1, 15
           6822000    0x8000420c li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
           6823000    0x80004210 mv a4, a0                      #; a0  = 0x100217c4, (wrb) a4  <-- 0x100217c4
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
           6824000    0x80004214 bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
           6825000    0x80004218 andi a5, a4, 15                #; a4  = 0x100217c4, (wrb) a5  <-- 4
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
           6826000    0x8000421c bnez a5, 160                   #; a5  = 4, taken, goto 0x800042bc
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
           6827000    0x800042bc slli a3, a5, 2                 #; a5  = 4, (wrb) a3  <-- 16
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
           6828000    0x800042c0 auipc t0, 0                    #; (wrb) t0  <-- 0x800042c0
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
           6829000    0x800042c4 add a3, a3, t0                 #; a3  = 16, t0  = 0x800042c0, (wrb) a3  <-- 0x800042d0
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
           6830000    0x800042c8 mv t0, ra                      #; ra  = 0x80003fd8, (wrb) t0  <-- 0x80003fd8
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
           6831000    0x800042cc jalr -96(a3)                   #; a3  = 0x800042d0, (wrb) ra  <-- 0x800042d0, goto 0x80004270
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
           6832000    0x80004270 sb a1, 11(a4)                  #; a4  = 0x100217c4, 0 ~~> Byte[0x100217cf]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
           6833000    0x80004274 sb a1, 10(a4)                  #; a4  = 0x100217c4, 0 ~~> Byte[0x100217ce]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
           6844000    0x80004278 sb a1, 9(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217cd]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
           6858000    0x8000427c sb a1, 8(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217cc]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
           6872000    0x80004280 sb a1, 7(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217cb]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
           6881000    0x80004284 sb a1, 6(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217ca]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
           6893000    0x80004288 sb a1, 5(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217c9]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
           6902000    0x8000428c sb a1, 4(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217c8]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           6914000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217c7]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           6921000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217c6]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           6928000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217c5]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           6935000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217c4]
#; .Ltable (memset.S:85)
#;   ret
           6936000    0x800042a0 ret                            #; ra  = 0x800042d0, goto 0x800042d0
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           6937000    0x800042d0 mv ra, t0                      #; t0  = 0x80003fd8, (wrb) ra  <-- 0x80003fd8
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           6938000    0x800042d4 addi a5, a5, -16               #; a5  = 4, (wrb) a5  <-- -12
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           6939000    0x800042d8 sub a4, a4, a5                 #; a4  = 0x100217c4, a5  = -12, (wrb) a4  <-- 0x100217d0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           6940000    0x800042dc add a2, a2, a5                 #; a2  = 64, a5  = -12, (wrb) a2  <-- 52
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           6941000    0x800042e0 bgeu t1, a2, -144              #; t1  = 15, a2  = 52, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           6942000    0x800042e4 j -196                         #; goto 0x80004220
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           6943000    0x80004220 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           6944000    0x80004224 andi a3, a2, -16               #; a2  = 52, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           6945000    0x80004228 andi a2, a2, 15                #; a2  = 52, (wrb) a2  <-- 4
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           6946000    0x8000422c add a3, a3, a4                 #; a3  = 48, a4  = 0x100217d0, (wrb) a3  <-- 0x10021800
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6947000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x100217d0, 0 ~~> Word[0x100217d0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           6956000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x100217d0, 0 ~~> Word[0x100217d4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           6965000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x100217d0, 0 ~~> Word[0x100217d8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6977000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x100217d0, 0 ~~> Word[0x100217dc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6978000    0x80004240 addi a4, a4, 16                #; a4  = 0x100217d0, (wrb) a4  <-- 0x100217e0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6979000    0x80004244 bltu a4, a3, -20               #; a4  = 0x100217e0, a3  = 0x10021800, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6986000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x100217e0, 0 ~~> Word[0x100217e0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           6998000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x100217e0, 0 ~~> Word[0x100217e4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           7007000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x100217e0, 0 ~~> Word[0x100217e8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           7019000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x100217e0, 0 ~~> Word[0x100217ec]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           7020000    0x80004240 addi a4, a4, 16                #; a4  = 0x100217e0, (wrb) a4  <-- 0x100217f0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           7021000    0x80004244 bltu a4, a3, -20               #; a4  = 0x100217f0, a3  = 0x10021800, taken, goto 0x80004230
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           7028000    0x80004230 sw a1, 0(a4)                   #; a4  = 0x100217f0, 0 ~~> Word[0x100217f0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           7040000    0x80004234 sw a1, 4(a4)                   #; a4  = 0x100217f0, 0 ~~> Word[0x100217f4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           7049000    0x80004238 sw a1, 8(a4)                   #; a4  = 0x100217f0, 0 ~~> Word[0x100217f8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           7061000    0x8000423c sw a1, 12(a4)                  #; a4  = 0x100217f0, 0 ~~> Word[0x100217fc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           7062000    0x80004240 addi a4, a4, 16                #; a4  = 0x100217f0, (wrb) a4  <-- 0x10021800
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           7063000    0x80004244 bltu a4, a3, -20               #; a4  = 0x10021800, a3  = 0x10021800, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
           7064000    0x80004248 bnez a2, 8                     #; a2  = 4, taken, goto 0x80004250
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
           7065000    0x80004250 sub a3, t1, a2                 #; t1  = 15, a2  = 4, (wrb) a3  <-- 11
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
           7066000    0x80004254 slli a3, a3, 2                 #; a3  = 11, (wrb) a3  <-- 44
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
           7067000    0x80004258 auipc t0, 0                    #; (wrb) t0  <-- 0x80004258
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
           7068000    0x8000425c add a3, a3, t0                 #; a3  = 44, t0  = 0x80004258, (wrb) a3  <-- 0x80004284
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
           7069000    0x80004260 jr 12(a3)                      #; a3  = 0x80004284, goto 0x80004290
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
           7070000    0x80004290 sb a1, 3(a4)                   #; a4  = 0x10021800, 0 ~~> Byte[0x10021803]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
           7082000    0x80004294 sb a1, 2(a4)                   #; a4  = 0x10021800, 0 ~~> Byte[0x10021802]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
           7089000    0x80004298 sb a1, 1(a4)                   #; a4  = 0x10021800, 0 ~~> Byte[0x10021801]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           7096000    0x8000429c sb a1, 0(a4)                   #; a4  = 0x10021800, 0 ~~> Byte[0x10021800]
#; .Ltable (memset.S:85)
#;   ret
           7097000    0x800042a0 ret                            #; ra  = 0x80003fd8, goto 0x80003fd8
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:85:5)
#;     snrt_cluster_hw_barrier (sync.h:174:5)
#;       asm volatile("csrr x0, 0x7C2" ::: "memory");
#;       ^
           7098000    0x80003fd8 csrr zero, 1986                #; csr@7c2 = 0
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
           7364000    0x80004068 add s0, a3, tp                 #; a3  = 0, tp  = 0x1001f778, (wrb) s0  <-- 0x1001f778
           7365000    0x8000406c sw a1, 64(s0)                  #; s0  = 0x1001f778, 0x1001ffe0 ~~> Word[0x1001f7b8]
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
           7419000    0x80004080 bltu s5, a3, 84                #; s5  = 2, a3  = 8, taken, goto 0x800040d4
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
           7456000    0x800040e4 add a3, a3, tp                 #; a3  = 0, tp  = 0x1001f778, (wrb) a3  <-- 0x1001f778
           7457000    0x800040e8 sw zero, 20(a3)                #; a3  = 0x1001f778, 0 ~~> Word[0x1001f78c]
           7458000    0x800040ec sw a2, 16(a3)                  #; a3  = 0x1001f778, 0x10000000 ~~> Word[0x1001f788]
           7459000    0x800040f0 addi a3, a3, 16                #; a3  = 0x1001f778, (wrb) a3  <-- 0x1001f788
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:190:5)
#;     snrt_l1_init (alloc_v2.h:119:33)
#;       snrt_l1_allocator_v2()->end = heap_end_addr;
#;                                   ^
           7460000    0x800040f4 sw zero, 12(a3)                #; a3  = 0x1001f788, 0 ~~> Word[0x1001f794]
           7461000    0x800040f8 lui a4, 65566                  #; (wrb) a4  <-- 0x1001e000
           7462000    0x800040fc addi a4, a4, -1152             #; a4  = 0x1001e000, (wrb) a4  <-- 0x1001db80
           7473000    0x80004100 add a0, a0, a4                 #; a0  = -32, a4  = 0x1001db80, (wrb) a0  <-- 0x1001db60
           7474000    0x80004104 sw a0, 8(a3)                   #; a3  = 0x1001f788, 0x1001db60 ~~> Word[0x1001f790]
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:190:5)
#;     snrt_l1_init (alloc_v2.h:120:34)
#;       snrt_l1_allocator_v2()->next = snrt_l1_allocator_v2()->base;
#;                                    ^
           7475000    0x80004108 sw zero, 20(a3)                #; a3  = 0x1001f788, 0 ~~> Word[0x1001f79c]
           7476000    0x8000410c sw a2, 16(a3)                  #; a3  = 0x1001f788, 0x10000000 ~~> Word[0x1001f798]
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:191:5)
#;     snrt_l3_init (alloc_v2.h:184:34)
#;       snrt_l3_allocator_v2()->base =
#;                                    ^
           7477000    0x80004110 lui a0, 0                      #; (wrb) a0  <-- 0
           7478000    0x80004114 add a0, a0, tp                 #; a0  = 0, tp  = 0x1001f778, (wrb) a0  <-- 0x1001f778
           7479000    0x80004118 sw zero, 44(a0)                #; a0  = 0x1001f778, 0 ~~> Word[0x1001f7a4]
           7480000    0x8000411c addi a1, a1, 7                 #; a1  = 0x80008528, (wrb) a1  <-- 0x8000852f
           7481000    0x80004120 andi a1, a1, -8                #; a1  = 0x8000852f, (wrb) a1  <-- 0x80008528
           7482000    0x80004124 sw a1, 40(a0)                  #; a0  = 0x1001f778, 0x80008528 ~~> Word[0x1001f7a0]
           7483000    0x80004128 addi a0, a0, 40                #; a0  = 0x1001f778, (wrb) a0  <-- 0x1001f7a0
           7484000    0x8000412c li a2, 1                       #; (wrb) a2  <-- 1
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:191:5)
#;     snrt_l3_init (alloc_v2.h:186:33)
#;       snrt_l3_allocator_v2()->end = SNRT_L3_END_ADDR;
#;                                   ^
           7485000    0x80004130 sw a2, 12(a0)                  #; a0  = 0x1001f7a0, 1 ~~> Word[0x1001f7ac]
           7486000    0x80004134 sw zero, 8(a0)                 #; a0  = 0x1001f7a0, 0 ~~> Word[0x1001f7a8]
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:191:5)
#;     snrt_l3_init (alloc_v2.h:187:34)
#;       snrt_l3_allocator_v2()->next = snrt_l3_allocator_v2()->base;
#;                                    ^
           7487000    0x80004138 sw zero, 20(a0)                #; a0  = 0x1001f7a0, 0 ~~> Word[0x1001f7b4]
           7488000    0x8000413c sw a1, 16(a0)                  #; a0  = 0x1001f7a0, 0x80008528 ~~> Word[0x1001f7b0]
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:192:5)
#;     snrt_comm_init (sync.h:37:48)
#;       inline void snrt_comm_init() { snrt_comm_world = &snrt_comm_world_info; }
#;                                                      ^
           7499000    0x80004140 lui a0, 0                      #; (wrb) a0  <-- 0
           7500000    0x80004144 add a0, a0, tp                 #; a0  = 0, tp  = 0x1001f778, (wrb) a0  <-- 0x1001f778
           7501000    0x80004148 lui a1, 0                      #; (wrb) a1  <-- 0
           7502000    0x8000414c add a1, a1, tp                 #; a1  = 0, tp  = 0x1001f778, (wrb) a1  <-- 0x1001f778
           7503000    0x80004150 mv a1, a1                      #; a1  = 0x1001f778, (wrb) a1  <-- 0x1001f778
           7504000    0x80004154 sw a1, 76(a0)                  #; a0  = 0x1001f778, 0x1001f778 ~~> Word[0x1001f7c4]
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
           7515000    0x800001cc addi sp, sp, -48               #; sp  = 0x1001f738, (wrb) sp  <-- 0x1001f708
#; main (xpulp_vect.c:6:5)
#;   snrt_cluster_hw_barrier (sync.h:174:5)
#;     asm volatile("csrr x0, 0x7C2" ::: "memory");
#;     ^
           7516000    0x800001d0 sw s0, 44(sp)                  #; sp  = 0x1001f708, 0x1001f778 ~~> Word[0x1001f734]
           7517000    0x800001d4 sw s1, 40(sp)                  #; sp  = 0x1001f708, 2064 ~~> Word[0x1001f730]
           7518000    0x800001d8 sw s2, 36(sp)                  #; sp  = 0x1001f708, 2 ~~> Word[0x1001f72c]
           7519000    0x800001dc sw s3, 32(sp)                  #; sp  = 0x1001f708, 0 ~~> Word[0x1001f728]
           7521000    0x800001e0 sw s4, 28(sp)                  #; sp  = 0x1001f708, 0 ~~> Word[0x1001f724]
           7522000    0x800001e4 sw s5, 24(sp)                  #; sp  = 0x1001f708, 2 ~~> Word[0x1001f720]
           7524000    0x800001e8 sw s6, 20(sp)                  #; sp  = 0x1001f708, 0x80005d98 ~~> Word[0x1001f71c]
           7525000    0x800001ec sw s7, 16(sp)                  #; sp  = 0x1001f708, 0x80005d98 ~~> Word[0x1001f718]
           7527000    0x800001f0 sw s8, 12(sp)                  #; sp  = 0x1001f708, 0x80005db8 ~~> Word[0x1001f714]
           7528000    0x800001f4 csrr zero, 1986                #; csr@7c2 = 0
#; main (xpulp_vect.c:5:18)
#;   snrt_global_core_idx (team.h:80:12)
#;     snrt_hartid (team.h:25:5)
#;       asm("csrr %0, mhartid" : "=r"(hartid));
#;       ^
           7531000    0x800001f8 csrr a0, mhartid               #; mhartid = 2, (wrb) a0  <-- 2
           7532000    0x800001fc li a1, 2                       #; (wrb) a1  <-- 2
#; main (xpulp_vect.c:7:9)
#;   if (i == 2) {
#;       ^
           7543000    0x80000200 bne a0, a1, 3456               #; a0  = 2, a1  = 2, not taken
           7544000    0x80000204 lui s0, 32                     #; (wrb) s0  <-- 0x00020000
           7545000    0x80000208 addi a2, s0, 3                 #; s0  = 0x00020000, (wrb) a2  <-- 0x00020003
           7546000    0x8000020c lui s1, 64                     #; (wrb) s1  <-- 0x00040000
           7547000    0x80000210 addi a6, s1, 5                 #; s1  = 0x00040000, (wrb) a6  <-- 0x00040005
#; main (xpulp_vect.c:16:13)
#;   asm volatile("pv.add.h a3, a4, a5\n"
#;   ^
           7548000    0x80000214 mv a4, a2                      #; a2  = 0x00020003, (wrb) a4  <-- 0x00020003
           7549000    0x80000218 mv a5, a6                      #; a6  = 0x00040005, (wrb) a5  <-- 0x00040005
           7550000    0x8000021c .text                          #; a4  = 0x00020003, a5  = 0x00040005
           7551000    0x80000220 lui t6, 96                     #; (wrb) t6  <-- 0x00060000
           7552000    0x80000224 addi t0, t6, 8                 #; t6  = 0x00060000, (wrb) t0  <-- 0x00060008
           7553000                                              #; (acc) a3  <-- 0x00060008
#; main (xpulp_vect.c:22:27)
#;   if (result_rd != 0x00060008) errs++;
#;                 ^
           7554000    0x80000228 xor a0, a3, t0                 #; a3  = 0x00060008, t0  = 0x00060008, (wrb) a0  <-- 0
           7555000    0x8000022c snez t1, a0                    #; a0  = 0, (wrb) t1  <-- 0
#; main (xpulp_vect.c:30:13)
#;   asm volatile("pv.add.sc.h a3, a4, a5\n"
#;   ^
           7556000    0x80000230 li a5, 4                       #; (wrb) a5  <-- 4
           7557000    0x80000234 addi a0, t6, 7                 #; t6  = 0x00060000, (wrb) a0  <-- 0x00060007
           7558000    0x80000238 mv a4, a2                      #; a2  = 0x00020003, (wrb) a4  <-- 0x00020003
           7559000    0x8000023c .text                          #; a4  = 0x00020003, a5  = 4
           7561000                                              #; (acc) a3  <-- 0x00060007
#; main (xpulp_vect.c:36:17)
#;   if (result_rd != 0x00060007) errs++;
#;       ^
           7570000    0x80000240 beq a3, a0, 8                  #; a3  = 0x00060007, a0  = 0x00060007, taken, goto 0x80000248
#; .LBB0_3 (xpulp_vect.c:43:13)
#;   asm volatile("pv.add.sci.h a3, a4, 1\n"
#;   ^
           7571000    0x80000248 mv a4, a2                      #; a2  = 0x00020003, (wrb) a4  <-- 0x00020003
           7572000    0x8000024c .text                          #; a4  = 0x00020003
           7573000    0x80000250 lui s3, 48                     #; (wrb) s3  <-- 0x00030000
           7574000    0x80000254 addi a1, s3, 4                 #; s3  = 0x00030000, (wrb) a1  <-- 0x00030004
           7575000                                              #; (acc) a3  <-- 0x00030004
#; .LBB0_3 (xpulp_vect.c:49:27)
#;   if (result_rd != 0x00030004) errs++;
#;                 ^
           7576000    0x80000258 xor a0, a3, a1                 #; a3  = 0x00030004, a1  = 0x00030004, (wrb) a0  <-- 0
           7577000    0x8000025c snez a3, a0                    #; a0  = 0, (wrb) a3  <-- 0
           7578000    0x80000260 lui s2, 4128                   #; (wrb) s2  <-- 0x01020000
           7579000    0x80000264 addi a7, s2, 772               #; s2  = 0x01020000, (wrb) a7  <-- 0x01020304
           7580000    0x80000268 lui a0, 20576                  #; (wrb) a0  <-- 0x05060000
           7581000    0x8000026c addi a0, a0, 1800              #; a0  = 0x05060000, (wrb) a0  <-- 0x05060708
#; .LBB0_3 (xpulp_vect.c:49:17)
#;   if (result_rd != 0x00030004) errs++;
#;       ^
           7582000    0x80000270 add t1, t1, a3                 #; t1  = 0, a3  = 0, (wrb) t1  <-- 0
#; .LBB0_3 (xpulp_vect.c:57:13)
#;   asm volatile("pv.add.b a3, a4, a5\n"
#;   ^
           7583000    0x80000274 mv a4, a7                      #; a7  = 0x01020304, (wrb) a4  <-- 0x01020304
           7584000    0x80000278 mv a5, a0                      #; a0  = 0x05060708, (wrb) a5  <-- 0x05060708
           7585000    0x8000027c .text                          #; a4  = 0x01020304, a5  = 0x05060708
           7587000                                              #; (acc) a3  <-- 0x06080a0c
           7596000    0x80000280 lui a4, 24705                  #; (wrb) a4  <-- 0x06081000
           7597000    0x80000284 addi t2, a4, -1524             #; a4  = 0x06081000, (wrb) t2  <-- 0x06080a0c
#; .LBB0_3 (xpulp_vect.c:63:27)
#;   if (result_rd != 0x06080A0C) errs++;
#;                 ^
           7598000    0x80000288 xor a3, a3, t2                 #; a3  = 0x06080a0c, t2  = 0x06080a0c, (wrb) a3  <-- 0
           7599000    0x8000028c snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:63:17)
#;   if (result_rd != 0x06080A0C) errs++;
#;       ^
           7600000    0x80000290 add t1, t1, a3                 #; t1  = 0, a3  = 0, (wrb) t1  <-- 0
#; .LBB0_3 (xpulp_vect.c:71:13)
#;   asm volatile("pv.add.sc.b a3, a4, a5\n"
#;   ^
           7601000    0x80000294 li a5, 5                       #; (wrb) a5  <-- 5
           7602000    0x80000298 mv a4, a7                      #; a7  = 0x01020304, (wrb) a4  <-- 0x01020304
           7603000    0x8000029c .text                          #; a4  = 0x01020304, a5  = 5
           7604000    0x800002a0 lui a4, 24689                  #; (wrb) a4  <-- 0x06071000
           7605000    0x800002a4 addi t3, a4, -2039             #; a4  = 0x06071000, (wrb) t3  <-- 0x06070809
           7606000                                              #; (acc) a3  <-- 0x06070809
#; .LBB0_3 (xpulp_vect.c:77:27)
#;   if (result_rd != 0x06070809) errs++;
#;                 ^
           7607000    0x800002a8 xor a3, a3, t3                 #; a3  = 0x06070809, t3  = 0x06070809, (wrb) a3  <-- 0
           7608000    0x800002ac snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:77:17)
#;   if (result_rd != 0x06070809) errs++;
#;       ^
           7609000    0x800002b0 add a5, t1, a3                 #; t1  = 0, a3  = 0, (wrb) a5  <-- 0
#; .LBB0_3 (xpulp_vect.c:84:13)
#;   asm volatile("pv.add.sci.b a3, a4, 1\n"
#;   ^
           7610000    0x800002b4 mv a4, a7                      #; a7  = 0x01020304, (wrb) a4  <-- 0x01020304
           7611000    0x800002b8 .text                          #; a4  = 0x01020304
           7612000    0x800002bc lui a4, 8240                   #; (wrb) a4  <-- 0x02030000
           7613000                                              #; (acc) a3  <-- 0x02030405
           7623000    0x800002c0 addi t1, a4, 1029              #; a4  = 0x02030000, (wrb) t1  <-- 0x02030405
#; .LBB0_3 (xpulp_vect.c:90:27)
#;   if (result_rd != 0x02030405) errs++;
#;                 ^
           7624000    0x800002c4 xor a3, a3, t1                 #; a3  = 0x02030405, t1  = 0x02030405, (wrb) a3  <-- 0
           7625000    0x800002c8 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:90:17)
#;   if (result_rd != 0x02030405) errs++;
#;       ^
           7626000    0x800002cc add t4, a5, a3                 #; a5  = 0, a3  = 0, (wrb) t4  <-- 0
#; .LBB0_3 (xpulp_vect.c:97:13)
#;   asm volatile("pv.sub.h a3, a4, a5\n"
#;   ^
           7627000    0x800002d0 mv a4, t0                      #; t0  = 0x00060008, (wrb) a4  <-- 0x00060008
           7628000    0x800002d4 mv a5, a2                      #; a2  = 0x00020003, (wrb) a5  <-- 0x00020003
           7629000    0x800002d8 .text                          #; a4  = 0x00060008, a5  = 0x00020003
           7631000                                              #; (acc) a3  <-- 0x00040005
#; .LBB0_3 (xpulp_vect.c:103:27)
#;   if (result_rd != 0x00040005) errs++;
#;                 ^
           7632000    0x800002dc xor a3, a3, a6                 #; a3  = 0x00040005, a6  = 0x00040005, (wrb) a3  <-- 0
           7633000    0x800002e0 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:103:17)
#;   if (result_rd != 0x00040005) errs++;
#;       ^
           7634000    0x800002e4 add t4, t4, a3                 #; t4  = 0, a3  = 0, (wrb) t4  <-- 0
#; .LBB0_3 (xpulp_vect.c:111:13)
#;   asm volatile("pv.sub.sc.h a3, a4, a5\n"
#;   ^
           7635000    0x800002e8 li a5, 2                       #; (wrb) a5  <-- 2
           7636000    0x800002ec mv a4, t0                      #; t0  = 0x00060008, (wrb) a4  <-- 0x00060008
           7637000    0x800002f0 .text                          #; a4  = 0x00060008, a5  = 2
           7638000    0x800002f4 addi a4, s1, 6                 #; s1  = 0x00040000, (wrb) a4  <-- 0x00040006
           7639000                                              #; (acc) a3  <-- 0x00040006
#; .LBB0_3 (xpulp_vect.c:117:27)
#;   if (result_rd != 0x00040006) errs++;
#;                 ^
           7640000    0x800002f8 xor a3, a3, a4                 #; a3  = 0x00040006, a4  = 0x00040006, (wrb) a3  <-- 0
           7641000    0x800002fc snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:117:17)
#;   if (result_rd != 0x00040006) errs++;
#;       ^
           7652000    0x80000300 add a5, t4, a3                 #; t4  = 0, a3  = 0, (wrb) a5  <-- 0
#; .LBB0_3 (xpulp_vect.c:124:13)
#;   asm volatile("pv.sub.sci.h a3, a4, 1\n"
#;   ^
           7653000    0x80000304 mv a4, t0                      #; t0  = 0x00060008, (wrb) a4  <-- 0x00060008
           7654000    0x80000308 .text                          #; a4  = 0x00060008
           7655000    0x8000030c lui s5, 80                     #; (wrb) s5  <-- 0x00050000
           7656000    0x80000310 addi a4, s5, 7                 #; s5  = 0x00050000, (wrb) a4  <-- 0x00050007
           7657000                                              #; (acc) a3  <-- 0x00050007
#; .LBB0_3 (xpulp_vect.c:130:27)
#;   if (result_rd != 0x00050007) errs++;
#;                 ^
           7658000    0x80000314 xor a3, a3, a4                 #; a3  = 0x00050007, a4  = 0x00050007, (wrb) a3  <-- 0
           7659000    0x80000318 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:130:17)
#;   if (result_rd != 0x00050007) errs++;
#;       ^
           7660000    0x8000031c add t0, a5, a3                 #; a5  = 0, a3  = 0, (wrb) t0  <-- 0
#; .LBB0_3 (xpulp_vect.c:138:13)
#;   asm volatile("pv.sub.b a3, a4, a5\n"
#;   ^
           7661000    0x80000320 mv a4, t2                      #; t2  = 0x06080a0c, (wrb) a4  <-- 0x06080a0c
           7662000    0x80000324 mv a5, a7                      #; a7  = 0x01020304, (wrb) a5  <-- 0x01020304
           7663000    0x80000328 .text                          #; a4  = 0x06080a0c, a5  = 0x01020304
           7665000                                              #; (acc) a3  <-- 0x05060708
#; .LBB0_3 (xpulp_vect.c:144:27)
#;   if (result_rd != 0x05060708) errs++;
#;                 ^
           7666000    0x8000032c xor a3, a3, a0                 #; a3  = 0x05060708, a0  = 0x05060708, (wrb) a3  <-- 0
           7667000    0x80000330 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:144:17)
#;   if (result_rd != 0x05060708) errs++;
#;       ^
           7668000    0x80000334 add t0, t0, a3                 #; t0  = 0, a3  = 0, (wrb) t0  <-- 0
#; .LBB0_3 (xpulp_vect.c:152:13)
#;   asm volatile("pv.sub.sc.b a3, a4, a5\n"
#;   ^
           7669000    0x80000338 li a5, 1                       #; (wrb) a5  <-- 1
           7670000    0x8000033c mv a4, t3                      #; t3  = 0x06070809, (wrb) a4  <-- 0x06070809
           7681000    0x80000340 .text                          #; a4  = 0x06070809, a5  = 1
           7683000                                              #; (acc) a3  <-- 0x05060708
#; .LBB0_3 (xpulp_vect.c:158:27)
#;   if (result_rd != 0x05060708) errs++;
#;                 ^
           7684000    0x80000344 xor a3, a3, a0                 #; a3  = 0x05060708, a0  = 0x05060708, (wrb) a3  <-- 0
           7685000    0x80000348 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:158:17)
#;   if (result_rd != 0x05060708) errs++;
#;       ^
           7686000    0x8000034c add t0, t0, a3                 #; t0  = 0, a3  = 0, (wrb) t0  <-- 0
#; .LBB0_3 (xpulp_vect.c:165:13)
#;   asm volatile("pv.sub.sci.b a3, a4, 2\n"
#;   ^
           7687000    0x80000350 mv a4, t3                      #; t3  = 0x06070809, (wrb) a4  <-- 0x06070809
           7688000    0x80000354 .text                          #; a4  = 0x06070809
           7689000    0x80000358 lui a4, 16464                  #; (wrb) a4  <-- 0x04050000
           7690000    0x8000035c addi t2, a4, 1543              #; a4  = 0x04050000, (wrb) t2  <-- 0x04050607
           7691000                                              #; (acc) a3  <-- 0x04050607
#; .LBB0_3 (xpulp_vect.c:171:27)
#;   if (result_rd != 0x04050607) errs++;
#;                 ^
           7692000    0x80000360 xor a3, a3, t2                 #; a3  = 0x04050607, t2  = 0x04050607, (wrb) a3  <-- 0
           7693000    0x80000364 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           7694000    0x80000368 lui s4, 1048544                #; (wrb) s4  <-- 0xfffe0000
           7695000    0x8000036c addi a4, s4, 6                 #; s4  = 0xfffe0000, (wrb) a4  <-- 0xfffe0006
           7696000    0x80000370 lui a5, 1048512                #; (wrb) a5  <-- 0xfffc0000
           7697000    0x80000374 addi a5, a5, 2                 #; a5  = 0xfffc0000, (wrb) a5  <-- 0xfffc0002
#; .LBB0_3 (xpulp_vect.c:171:17)
#;   if (result_rd != 0x04050607) errs++;
#;       ^
           7698000    0x80000378 add t0, t0, a3                 #; t0  = 0, a3  = 0, (wrb) t0  <-- 0
#; .LBB0_3 (xpulp_vect.c:178:13)
#;   asm volatile("pv.avg.h a3, a4, a5\n"
#;   ^
           7699000    0x8000037c .text                          #; a4  = 0xfffe0006, a5  = 0xfffc0002
           7701000                                              #; (acc) a3  <-- 0xfffd0004
           7710000    0x80000380 lui t3, 1048528                #; (wrb) t3  <-- 0xfffd0000
           7711000    0x80000384 addi a4, t3, 4                 #; t3  = 0xfffd0000, (wrb) a4  <-- 0xfffd0004
#; .LBB0_3 (xpulp_vect.c:183:27)
#;   if (result_rd != 0xFFFD0004) errs++;
#;                 ^
           7712000    0x80000388 xor a3, a3, a4                 #; a3  = 0xfffd0004, a4  = 0xfffd0004, (wrb) a3  <-- 0
           7713000    0x8000038c snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           7714000    0x80000390 addi a4, s3, 5                 #; s3  = 0x00030000, (wrb) a4  <-- 0x00030005
           7715000    0x80000394 lui t5, 16                     #; (wrb) t5  <-- 0x00010000
           7716000    0x80000398 addi a5, t5, -2                #; t5  = 0x00010000, (wrb) a5  <-- 65534
#; .LBB0_3 (xpulp_vect.c:183:17)
#;   if (result_rd != 0xFFFD0004) errs++;
#;       ^
           7717000    0x8000039c add t0, t0, a3                 #; t0  = 0, a3  = 0, (wrb) t0  <-- 0
#; .LBB0_3 (xpulp_vect.c:191:13)
#;   asm volatile("pv.avg.sc.h a3, a4, a5\n"
#;   ^
           7718000    0x800003a0 .text                          #; a4  = 0x00030005, a5  = 65534
           7720000                                              #; (acc) a3  <-- 1
#; .LBB0_3 (xpulp_vect.c:196:27)
#;   if (result_rd != 0x00000001) errs++;
#;                 ^
           7721000    0x800003a4 addi a3, a3, -1                #; a3  = 1, (wrb) a3  <-- 0
           7722000    0x800003a8 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           7723000    0x800003ac addi a4, t3, 2                 #; t3  = 0xfffd0000, (wrb) a4  <-- 0xfffd0002
#; .LBB0_3 (xpulp_vect.c:196:17)
#;   if (result_rd != 0x00000001) errs++;
#;       ^
           7724000    0x800003b0 add t0, t0, a3                 #; t0  = 0, a3  = 0, (wrb) t0  <-- 0
#; .LBB0_3 (xpulp_vect.c:203:13)
#;   asm volatile("pv.avg.sci.h a3, a4, -1\n"      // add -1, arithmetic >> 1
#;   ^
           7725000    0x800003b4 .text                          #; a4  = 0xfffd0002
           7727000                                              #; (acc) a3  <-- 0xfffe0000
#; .LBB0_3 (xpulp_vect.c:208:27)
#;   if (result_rd != 0xFFFE0000) errs++;
#;                 ^
           7728000    0x800003b8 xor a3, a3, s4                 #; a3  = 0xfffe0000, s4  = 0xfffe0000, (wrb) a3  <-- 0
           7729000    0x800003bc snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           7740000    0x800003c0 lui a4, 1032320                #; (wrb) a4  <-- 0xfc080000
           7741000    0x800003c4 addi a4, a4, -254              #; a4  = 0xfc080000, (wrb) a4  <-- 0xfc07ff02
           7742000    0x800003c8 lui a5, 1040400                #; (wrb) a5  <-- 0xfe010000
           7743000    0x800003cc addi a5, a5, 510               #; a5  = 0xfe010000, (wrb) a5  <-- 0xfe0101fe
#; .LBB0_3 (xpulp_vect.c:208:17)
#;   if (result_rd != 0xFFFE0000) errs++;
#;       ^
           7744000    0x800003d0 add t0, t0, a3                 #; t0  = 0, a3  = 0, (wrb) t0  <-- 0
#; .LBB0_3 (xpulp_vect.c:216:13)
#;   asm volatile("pv.avg.b a3, a4, a5\n"
#;   ^
           7745000    0x800003d4 .text                          #; a4  = 0xfc07ff02, a5  = 0xfe0101fe
           7746000    0x800003d8 lui a4, 1036352                #; (wrb) a4  <-- 0xfd040000
           7747000                                              #; (acc) a3  <-- 0xfd040000
#; .LBB0_3 (xpulp_vect.c:221:27)
#;   if (result_rd != 0xFD040000) errs++;
#;                 ^
           7748000    0x800003dc xor a3, a3, a4                 #; a3  = 0xfd040000, a4  = 0xfd040000, (wrb) a3  <-- 0
           7749000    0x800003e0 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:221:17)
#;   if (result_rd != 0xFD040000) errs++;
#;       ^
           7750000    0x800003e4 add t0, t0, a3                 #; t0  = 0, a3  = 0, (wrb) t0  <-- 0
           7751000    0x800003e8 lui a3, 1040496                #; (wrb) a3  <-- 0xfe070000
           7752000    0x800003ec addi a4, a3, -506              #; a3  = 0xfe070000, (wrb) a4  <-- 0xfe06fe06
#; .LBB0_3 (xpulp_vect.c:229:13)
#;   asm volatile("pv.avg.sc.b a3, a4, a5\n"
#;   ^
           7753000    0x800003f0 li a5, 254                     #; (wrb) a5  <-- 254
           7754000    0x800003f4 .text                          #; a4  = 0xfe06fe06, a5  = 254
           7755000    0x800003f8 lui a4, 1040432                #; (wrb) a4  <-- 0xfe030000
           7756000    0x800003fc addi a4, a4, -510              #; a4  = 0xfe030000, (wrb) a4  <-- 0xfe02fe02
           7757000                                              #; (acc) a3  <-- 0xfe02fe02
#; .LBB0_3 (xpulp_vect.c:234:27)
#;   if (result_rd != 0xFE02FE02) errs++;
#;                 ^
           7767000    0x80000400 xor a3, a3, a4                 #; a3  = 0xfe02fe02, a4  = 0xfe02fe02, (wrb) a3  <-- 0
           7768000    0x80000404 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:234:17)
#;   if (result_rd != 0xFE02FE02) errs++;
#;       ^
           7769000    0x80000408 add t3, t0, a3                 #; t0  = 0, a3  = 0, (wrb) t3  <-- 0
#; .LBB0_3 (xpulp_vect.c:241:13)
#;   asm volatile("pv.avg.sci.b a3, a4, -1\n"
#;   ^
           7770000    0x8000040c mv a4, t1                      #; t1  = 0x02030405, (wrb) a4  <-- 0x02030405
           7771000    0x80000410 .text                          #; a4  = 0x02030405
           7772000    0x80000414 addi a4, t5, 258               #; t5  = 0x00010000, (wrb) a4  <-- 0x00010102
           7773000                                              #; (acc) a3  <-- 0x00010102
#; .LBB0_3 (xpulp_vect.c:246:27)
#;   if (result_rd != 0x00010102) errs++;
#;                 ^
           7774000    0x80000418 xor a3, a3, a4                 #; a3  = 0x00010102, a4  = 0x00010102, (wrb) a3  <-- 0
           7775000    0x8000041c snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           7776000    0x80000420 lui a4, 74565                  #; (wrb) a4  <-- 0x12345000
           7777000    0x80000424 addi t0, a4, 1656              #; a4  = 0x12345000, (wrb) t0  <-- 0x12345678
           7778000    0x80000428 lui t4, 256                    #; (wrb) t4  <-- 0x00100000
           7779000    0x8000042c addi a5, t4, 4                 #; t4  = 0x00100000, (wrb) a5  <-- 0x00100004
#; .LBB0_3 (xpulp_vect.c:246:17)
#;   if (result_rd != 0x00010102) errs++;
#;       ^
           7780000    0x80000430 add t3, t3, a3                 #; t3  = 0, a3  = 0, (wrb) t3  <-- 0
#; .LBB0_3 (xpulp_vect.c:256:13)
#;   asm volatile("pv.avgu.h a3, a4, a5\n"
#;   ^
           7781000    0x80000434 mv a4, t0                      #; t0  = 0x12345678, (wrb) a4  <-- 0x12345678
           7782000    0x80000438 .text                          #; a4  = 0x12345678, a5  = 0x00100004
           7783000    0x8000043c lui a4, 37411                  #; (wrb) a4  <-- 0x09223000
           7784000                                              #; (acc) a3  <-- 0x09222b3e
           7794000    0x80000440 addi a4, a4, -1218             #; a4  = 0x09223000, (wrb) a4  <-- 0x09222b3e
#; .LBB0_3 (xpulp_vect.c:262:27)
#;   if (result_rd != 0x09222B3E) errs++;
#;                 ^
           7795000    0x80000444 xor a3, a3, a4                 #; a3  = 0x09222b3e, a4  = 0x09222b3e, (wrb) a3  <-- 0
           7796000    0x80000448 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:262:17)
#;   if (result_rd != 0x09222B3E) errs++;
#;       ^
           7797000    0x8000044c add t3, t3, a3                 #; t3  = 0, a3  = 0, (wrb) t3  <-- 0
           7798000    0x80000450 lui a3, 65571                  #; (wrb) a3  <-- 0x10023000
           7799000    0x80000454 addi a4, a3, 4                 #; a3  = 0x10023000, (wrb) a4  <-- 0x10023004
#; .LBB0_3 (xpulp_vect.c:270:13)
#;   asm volatile("pv.avgu.sc.h a3, a4, a5\n"
#;   ^
           7800000    0x80000458 li a5, 2                       #; (wrb) a5  <-- 2
           7801000    0x8000045c .text                          #; a4  = 0x10023004, a5  = 2
           7802000    0x80000460 lui a4, 32802                  #; (wrb) a4  <-- 0x08022000
           7803000    0x80000464 addi a4, a4, -2045             #; a4  = 0x08022000, (wrb) a4  <-- 0x08021803
           7804000                                              #; (acc) a3  <-- 0x08021803
#; .LBB0_3 (xpulp_vect.c:276:27)
#;   if (result_rd != 0x08021803) errs++;
#;                 ^
           7805000    0x80000468 xor a3, a3, a4                 #; a3  = 0x08021803, a4  = 0x08021803, (wrb) a3  <-- 0
           7806000    0x8000046c snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:276:17)
#;   if (result_rd != 0x08021803) errs++;
#;       ^
           7807000    0x80000470 add a5, t3, a3                 #; t3  = 0, a3  = 0, (wrb) a5  <-- 0
#; .LBB0_3 (xpulp_vect.c:283:13)
#;   asm volatile("pv.avgu.sci.h a3, a4, 3\n"
#;   ^
           7808000    0x80000474 mv a4, a6                      #; a6  = 0x00040005, (wrb) a4  <-- 0x00040005
           7809000    0x80000478 .text                          #; a4  = 0x00040005
           7811000                                              #; (acc) a3  <-- 0x00030004
#; .LBB0_3 (xpulp_vect.c:288:27)
#;   if (result_rd != 0x00030004) errs++;
#;                 ^
           7812000    0x8000047c xor a3, a3, a1                 #; a3  = 0x00030004, a1  = 0x00030004, (wrb) a3  <-- 0
           7823000    0x80000480 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           7824000    0x80000484 lui a4, 66051                  #; (wrb) a4  <-- 0x10203000
           7825000    0x80000488 addi a4, a4, 64                #; a4  = 0x10203000, (wrb) a4  <-- 0x10203040
#; .LBB0_3 (xpulp_vect.c:288:17)
#;   if (result_rd != 0x00030004) errs++;
#;       ^
           7826000    0x8000048c add t3, a5, a3                 #; a5  = 0, a3  = 0, (wrb) t3  <-- 0
#; .LBB0_3 (xpulp_vect.c:296:13)
#;   asm volatile("pv.avgu.b a3, a4, a5\n"
#;   ^
           7827000    0x80000490 mv a5, a7                      #; a7  = 0x01020304, (wrb) a5  <-- 0x01020304
           7828000    0x80000494 .text                          #; a4  = 0x10203040, a5  = 0x01020304
           7829000    0x80000498 lui a4, 33042                  #; (wrb) a4  <-- 0x08112000
           7830000    0x8000049c addi a4, a4, -1758             #; a4  = 0x08112000, (wrb) a4  <-- 0x08111922
           7831000                                              #; (acc) a3  <-- 0x08111922
#; .LBB0_3 (xpulp_vect.c:301:27)
#;   if (result_rd != 0x08111922) errs++;
#;                 ^
           7832000    0x800004a0 xor a3, a3, a4                 #; a3  = 0x08111922, a4  = 0x08111922, (wrb) a3  <-- 0
           7833000    0x800004a4 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:301:17)
#;   if (result_rd != 0x08111922) errs++;
#;       ^
           7834000    0x800004a8 add t3, t3, a3                 #; t3  = 0, a3  = 0, (wrb) t3  <-- 0
           7835000    0x800004ac lui a3, 20593                  #; (wrb) a3  <-- 0x05071000
           7836000    0x800004b0 addi a4, a3, -1781             #; a3  = 0x05071000, (wrb) a4  <-- 0x0507090b
#; .LBB0_3 (xpulp_vect.c:309:13)
#;   asm volatile("pv.avgu.sc.b a3, a4, a5\n"
#;   ^
           7837000    0x800004b4 li a5, 3                       #; (wrb) a5  <-- 3
           7838000    0x800004b8 .text                          #; a4  = 0x0507090b, a5  = 3
           7840000                                              #; (acc) a3  <-- 0x04050607
#; .LBB0_3 (xpulp_vect.c:314:27)
#;   if (result_rd != 0x04050607) errs++;
#;                 ^
           7841000    0x800004bc xor a3, a3, t2                 #; a3  = 0x04050607, t2  = 0x04050607, (wrb) a3  <-- 0
           7852000    0x800004c0 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:314:17)
#;   if (result_rd != 0x04050607) errs++;
#;       ^
           7853000    0x800004c4 add t2, t3, a3                 #; t3  = 0, a3  = 0, (wrb) t2  <-- 0
#; .LBB0_3 (xpulp_vect.c:321:13)
#;   asm volatile("pv.avgu.sci.b a3, a4, 1\n"
#;   ^
           7854000    0x800004c8 mv a4, a7                      #; a7  = 0x01020304, (wrb) a4  <-- 0x01020304
           7855000    0x800004cc .text                          #; a4  = 0x01020304
           7856000    0x800004d0 lui a4, 4112                   #; (wrb) a4  <-- 0x01010000
           7857000    0x800004d4 addi a4, a4, 514               #; a4  = 0x01010000, (wrb) a4  <-- 0x01010202
           7858000                                              #; (acc) a3  <-- 0x01010202
#; .LBB0_3 (xpulp_vect.c:326:27)
#;   if (result_rd != 0x01010202) errs++;
#;                 ^
           7859000    0x800004d8 xor a3, a3, a4                 #; a3  = 0x01010202, a4  = 0x01010202, (wrb) a3  <-- 0
           7860000    0x800004dc snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           7861000    0x800004e0 addi a4, s5, -256              #; s5  = 0x00050000, (wrb) a4  <-- 0x0004ff00
           7862000    0x800004e4 addi a5, s1, -240              #; s1  = 0x00040000, (wrb) a5  <-- 0x0003ff10
#; .LBB0_3 (xpulp_vect.c:326:17)
#;   if (result_rd != 0x01010202) errs++;
#;       ^
           7863000    0x800004e8 add t2, t2, a3                 #; t2  = 0, a3  = 0, (wrb) t2  <-- 0
#; .LBB0_3 (xpulp_vect.c:333:13)
#;   asm volatile("pv.min.h a3, a4, a5\n"
#;   ^
           7864000    0x800004ec .text                          #; a4  = 0x0004ff00, a5  = 0x0003ff10
           7865000    0x800004f0 addi a4, s1, -256              #; s1  = 0x00040000, (wrb) a4  <-- 0x0003ff00
           7866000                                              #; (acc) a3  <-- 0x0003ff00
#; .LBB0_3 (xpulp_vect.c:338:27)
#;   if (result_rd != 0x0003FF00) errs++;
#;                 ^
           7867000    0x800004f4 xor a3, a3, a4                 #; a3  = 0x0003ff00, a4  = 0x0003ff00, (wrb) a3  <-- 0
           7868000    0x800004f8 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:338:17)
#;   if (result_rd != 0x0003FF00) errs++;
#;       ^
           7869000    0x800004fc add t3, t2, a3                 #; t2  = 0, a3  = 0, (wrb) t3  <-- 0
           7880000    0x80000500 lui a3, 144                    #; (wrb) a3  <-- 0x00090000
           7881000    0x80000504 addi t2, a3, -256              #; a3  = 0x00090000, (wrb) t2  <-- 0x0008ff00
#; .LBB0_3 (xpulp_vect.c:346:13)
#;   asm volatile("pv.min.sc.h a3, a4, a5\n"
#;   ^
           7882000    0x80000508 li a5, 6                       #; (wrb) a5  <-- 6
           7883000    0x8000050c mv a4, t2                      #; t2  = 0x0008ff00, (wrb) a4  <-- 0x0008ff00
           7884000    0x80000510 .text                          #; a4  = 0x0008ff00, a5  = 6
           7885000    0x80000514 lui s7, 112                    #; (wrb) s7  <-- 0x00070000
           7886000    0x80000518 addi a5, s7, -256              #; s7  = 0x00070000, (wrb) a5  <-- 0x0006ff00
           7887000                                              #; (acc) a3  <-- 0x0006ff00
#; .LBB0_3 (xpulp_vect.c:351:27)
#;   if (result_rd != 0x0006FF00) errs++;
#;                 ^
           7888000    0x8000051c xor a3, a3, a5                 #; a3  = 0x0006ff00, a5  = 0x0006ff00, (wrb) a3  <-- 0
           7889000    0x80000520 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:351:17)
#;   if (result_rd != 0x0006FF00) errs++;
#;       ^
           7890000    0x80000524 add t3, t3, a3                 #; t3  = 0, a3  = 0, (wrb) t3  <-- 0
#; .LBB0_3 (xpulp_vect.c:358:13)
#;   asm volatile("pv.min.sci.h a3, a4, 6\n"
#;   ^
           7891000    0x80000528 mv a4, t2                      #; t2  = 0x0008ff00, (wrb) a4  <-- 0x0008ff00
           7892000    0x8000052c .text                          #; a4  = 0x0008ff00
           7894000                                              #; (acc) a3  <-- 0x0006ff00
#; .LBB0_3 (xpulp_vect.c:363:27)
#;   if (result_rd != 0x0006FF00) errs++;
#;                 ^
           7895000    0x80000530 xor a3, a3, a5                 #; a3  = 0x0006ff00, a5  = 0x0006ff00, (wrb) a3  <-- 0
           7896000    0x80000534 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           7897000    0x80000538 lui a4, 65809                  #; (wrb) a4  <-- 0x10111000
           7898000    0x8000053c addi a4, a4, 531               #; a4  = 0x10111000, (wrb) a4  <-- 0x10111213
#; .LBB0_3 (xpulp_vect.c:363:17)
#;   if (result_rd != 0x0006FF00) errs++;
#;       ^
           7909000    0x80000540 add t2, t3, a3                 #; t3  = 0, a3  = 0, (wrb) t2  <-- 0
#; .LBB0_3 (xpulp_vect.c:371:13)
#;   asm volatile("pv.min.b a3, a4, a5\n"
#;   ^
           7910000    0x80000544 mv a5, a0                      #; a0  = 0x05060708, (wrb) a5  <-- 0x05060708
           7911000    0x80000548 .text                          #; a4  = 0x10111213, a5  = 0x05060708
           7913000                                              #; (acc) a3  <-- 0x05060708
#; .LBB0_3 (xpulp_vect.c:376:27)
#;   if (result_rd != 0x05060708) errs++;
#;                 ^
           7914000    0x8000054c xor a3, a3, a0                 #; a3  = 0x05060708, a0  = 0x05060708, (wrb) a3  <-- 0
           7915000    0x80000550 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:376:17)
#;   if (result_rd != 0x05060708) errs++;
#;       ^
           7916000    0x80000554 add t2, t2, a3                 #; t2  = 0, a3  = 0, (wrb) t2  <-- 0
           7917000    0x80000558 lui a3, 32913                  #; (wrb) a3  <-- 0x08091000
           7918000    0x8000055c addi t3, a3, -1525             #; a3  = 0x08091000, (wrb) t3  <-- 0x08090a0b
#; .LBB0_3 (xpulp_vect.c:384:13)
#;   asm volatile("pv.min.sc.b a3, a4, a5\n"
#;   ^
           7919000    0x80000560 li a5, 7                       #; (wrb) a5  <-- 7
           7920000    0x80000564 mv a4, t3                      #; t3  = 0x08090a0b, (wrb) a4  <-- 0x08090a0b
           7921000    0x80000568 .text                          #; a4  = 0x08090a0b, a5  = 7
           7922000    0x8000056c lui a4, 28784                  #; (wrb) a4  <-- 0x07070000
           7923000    0x80000570 addi a5, a4, 1799              #; a4  = 0x07070000, (wrb) a5  <-- 0x07070707
           7924000                                              #; (acc) a3  <-- 0x07070707
#; .LBB0_3 (xpulp_vect.c:389:27)
#;   if (result_rd != 0x07070707) errs++;
#;                 ^
           7925000    0x80000574 xor a3, a3, a5                 #; a3  = 0x07070707, a5  = 0x07070707, (wrb) a3  <-- 0
           7926000    0x80000578 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:389:17)
#;   if (result_rd != 0x07070707) errs++;
#;       ^
           7927000    0x8000057c add s8, t2, a3                 #; t2  = 0, a3  = 0, (wrb) s8  <-- 0
#; .LBB0_3 (xpulp_vect.c:396:13)
#;   asm volatile("pv.min.sci.b a3, a4, 7\n"
#;   ^
           7938000    0x80000580 mv a4, t3                      #; t3  = 0x08090a0b, (wrb) a4  <-- 0x08090a0b
           7939000    0x80000584 .text                          #; a4  = 0x08090a0b
           7941000                                              #; (acc) a3  <-- 0x07070707
#; .LBB0_3 (xpulp_vect.c:401:27)
#;   if (result_rd != 0x07070707) errs++;
#;                 ^
           7942000    0x80000588 xor a3, a3, a5                 #; a3  = 0x07070707, a5  = 0x07070707, (wrb) a3  <-- 0
           7943000    0x8000058c snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           7944000    0x80000590 lui s6, 1044480                #; (wrb) s6  <-- 0xff000000
           7945000    0x80000594 addi t2, s6, 16                #; s6  = 0xff000000, (wrb) t2  <-- 0xff000010
           7946000    0x80000598 addi t4, t4, 8                 #; t4  = 0x00100000, (wrb) t4  <-- 0x00100008
#; .LBB0_3 (xpulp_vect.c:401:17)
#;   if (result_rd != 0x07070707) errs++;
#;       ^
           7947000    0x8000059c add s8, s8, a3                 #; s8  = 0, a3  = 0, (wrb) s8  <-- 0
#; .LBB0_3 (xpulp_vect.c:409:13)
#;   asm volatile("pv.minu.h a3, a4, a5\n"
#;   ^
           7948000    0x800005a0 mv a4, t2                      #; t2  = 0xff000010, (wrb) a4  <-- 0xff000010
           7949000    0x800005a4 mv a5, t4                      #; t4  = 0x00100008, (wrb) a5  <-- 0x00100008
           7950000    0x800005a8 .text                          #; a4  = 0xff000010, a5  = 0x00100008
           7952000                                              #; (acc) a3  <-- 0x00100008
#; .LBB0_3 (xpulp_vect.c:414:27)
#;   if (result_rd != 0x00100008) errs++;
#;                 ^
           7953000    0x800005ac xor a3, a3, t4                 #; a3  = 0x00100008, t4  = 0x00100008, (wrb) a3  <-- 0
           7954000    0x800005b0 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:414:17)
#;   if (result_rd != 0x00100008) errs++;
#;       ^
           7955000    0x800005b4 add s8, s8, a3                 #; s8  = 0, a3  = 0, (wrb) s8  <-- 0
#; .LBB0_3 (xpulp_vect.c:422:13)
#;   asm volatile("pv.minu.sc.h a3, a4, a5\n"
#;   ^
           7956000    0x800005b8 li a5, 8                       #; (wrb) a5  <-- 8
           7957000    0x800005bc mv a4, t2                      #; t2  = 0xff000010, (wrb) a4  <-- 0xff000010
           7968000    0x800005c0 .text                          #; a4  = 0xff000010, a5  = 8
           7969000    0x800005c4 lui t4, 128                    #; (wrb) t4  <-- 0x00080000
           7970000    0x800005c8 addi a5, t4, 8                 #; t4  = 0x00080000, (wrb) a5  <-- 0x00080008
           7971000                                              #; (acc) a3  <-- 0x00080008
#; .LBB0_3 (xpulp_vect.c:427:27)
#;   if (result_rd != 0x00080008) errs++;
#;                 ^
           7972000    0x800005cc xor a3, a3, a5                 #; a3  = 0x00080008, a5  = 0x00080008, (wrb) a3  <-- 0
           7973000    0x800005d0 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:427:17)
#;   if (result_rd != 0x00080008) errs++;
#;       ^
           7974000    0x800005d4 add s8, s8, a3                 #; s8  = 0, a3  = 0, (wrb) s8  <-- 0
#; .LBB0_3 (xpulp_vect.c:434:13)
#;   asm volatile("pv.minu.sci.h a3, a4, 8\n"
#;   ^
           7975000    0x800005d8 mv a4, t2                      #; t2  = 0xff000010, (wrb) a4  <-- 0xff000010
           7976000    0x800005dc .text                          #; a4  = 0xff000010
           7978000                                              #; (acc) a3  <-- 0x00080008
#; .LBB0_3 (xpulp_vect.c:439:27)
#;   if (result_rd != 0x00080008) errs++;
#;                 ^
           7979000    0x800005e0 xor a3, a3, a5                 #; a3  = 0x00080008, a5  = 0x00080008, (wrb) a3  <-- 0
           7980000    0x800005e4 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           7981000    0x800005e8 lui a4, 69616                  #; (wrb) a4  <-- 0x10ff0000
           7982000    0x800005ec addi t2, a4, 240               #; a4  = 0x10ff0000, (wrb) t2  <-- 0x10ff00f0
           7983000    0x800005f0 lui a4, 24561                  #; (wrb) a4  <-- 0x05ff1000
           7984000    0x800005f4 addi a5, a4, 241               #; a4  = 0x05ff1000, (wrb) a5  <-- 0x05ff10f1
#; .LBB0_3 (xpulp_vect.c:439:17)
#;   if (result_rd != 0x00080008) errs++;
#;       ^
           7985000    0x800005f8 add s8, s8, a3                 #; s8  = 0, a3  = 0, (wrb) s8  <-- 0
#; .LBB0_3 (xpulp_vect.c:447:13)
#;   asm volatile("pv.minu.b a3, a4, a5\n"
#;   ^
           7986000    0x800005fc mv a4, t2                      #; t2  = 0x10ff00f0, (wrb) a4  <-- 0x10ff00f0
           7997000    0x80000600 .text                          #; a4  = 0x10ff00f0, a5  = 0x05ff10f1
           7998000    0x80000604 lui a4, 24560                  #; (wrb) a4  <-- 0x05ff0000
           7999000    0x80000608 addi a4, a4, 240               #; a4  = 0x05ff0000, (wrb) a4  <-- 0x05ff00f0
           8000000                                              #; (acc) a3  <-- 0x05ff00f0
#; .LBB0_3 (xpulp_vect.c:452:27)
#;   if (result_rd != 0x05FF00F0) errs++;
#;                 ^
           8001000    0x8000060c xor a3, a3, a4                 #; a3  = 0x05ff00f0, a4  = 0x05ff00f0, (wrb) a3  <-- 0
           8002000    0x80000610 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:452:17)
#;   if (result_rd != 0x05FF00F0) errs++;
#;       ^
           8003000    0x80000614 add s8, s8, a3                 #; s8  = 0, a3  = 0, (wrb) s8  <-- 0
#; .LBB0_3 (xpulp_vect.c:460:13)
#;   asm volatile("pv.minu.sc.b a3, a4, a5\n"
#;   ^
           8004000    0x80000618 li a5, 8                       #; (wrb) a5  <-- 8
           8005000    0x8000061c mv a4, t3                      #; t3  = 0x08090a0b, (wrb) a4  <-- 0x08090a0b
           8006000    0x80000620 .text                          #; a4  = 0x08090a0b, a5  = 8
           8007000    0x80000624 lui a4, 32897                  #; (wrb) a4  <-- 0x08081000
           8008000    0x80000628 addi a5, a4, -2040             #; a4  = 0x08081000, (wrb) a5  <-- 0x08080808
           8009000                                              #; (acc) a3  <-- 0x08080808
#; .LBB0_3 (xpulp_vect.c:465:27)
#;   if (result_rd != 0x08080808) errs++;
#;                 ^
           8010000    0x8000062c xor a3, a3, a5                 #; a3  = 0x08080808, a5  = 0x08080808, (wrb) a3  <-- 0
           8011000    0x80000630 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:465:17)
#;   if (result_rd != 0x08080808) errs++;
#;       ^
           8012000    0x80000634 add s8, s8, a3                 #; s8  = 0, a3  = 0, (wrb) s8  <-- 0
#; .LBB0_3 (xpulp_vect.c:472:13)
#;   asm volatile("pv.minu.sci.b a3, a4, 8\n"
#;   ^
           8013000    0x80000638 mv a4, t3                      #; t3  = 0x08090a0b, (wrb) a4  <-- 0x08090a0b
           8014000    0x8000063c .text                          #; a4  = 0x08090a0b
           8016000                                              #; (acc) a3  <-- 0x08080808
#; .LBB0_3 (xpulp_vect.c:477:27)
#;   if (result_rd != 0x08080808) errs++;
#;                 ^
           8025000    0x80000640 xor a3, a3, a5                 #; a3  = 0x08080808, a5  = 0x08080808, (wrb) a3  <-- 0
           8026000    0x80000644 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           8027000    0x80000648 addi a4, s4, 10                #; s4  = 0xfffe0000, (wrb) a4  <-- 0xfffe000a
           8028000    0x8000064c addi a5, t6, -16               #; t6  = 0x00060000, (wrb) a5  <-- 0x0005fff0
#; .LBB0_3 (xpulp_vect.c:477:17)
#;   if (result_rd != 0x08080808) errs++;
#;       ^
           8029000    0x80000650 add t3, s8, a3                 #; s8  = 0, a3  = 0, (wrb) t3  <-- 0
#; .LBB0_3 (xpulp_vect.c:484:13)
#;   asm volatile("pv.max.h a3, a4, a5\n"
#;   ^
           8030000    0x80000654 .text                          #; a4  = 0xfffe000a, a5  = 0x0005fff0
           8031000    0x80000658 addi a4, s5, 10                #; s5  = 0x00050000, (wrb) a4  <-- 0x0005000a
           8032000                                              #; (acc) a3  <-- 0x0005000a
#; .LBB0_3 (xpulp_vect.c:489:27)
#;   if (result_rd != 0x0005000A) errs++;
#;                 ^
           8033000    0x8000065c xor a3, a3, a4                 #; a3  = 0x0005000a, a4  = 0x0005000a, (wrb) a3  <-- 0
           8034000    0x80000660 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:489:17)
#;   if (result_rd != 0x0005000A) errs++;
#;       ^
           8035000    0x80000664 add t3, t3, a3                 #; t3  = 0, a3  = 0, (wrb) t3  <-- 0
           8036000    0x80000668 lui a3, 1048480                #; (wrb) a3  <-- 0xfffa0000
           8037000    0x8000066c addi a4, a3, 4                 #; a3  = 0xfffa0000, (wrb) a4  <-- 0xfffa0004
#; .LBB0_3 (xpulp_vect.c:497:13)
#;   asm volatile("pv.max.sc.h a3, a4, a5\n"
#;   ^
           8038000    0x80000670 li a5, 7                       #; (wrb) a5  <-- 7
           8039000    0x80000674 .text                          #; a4  = 0xfffa0004, a5  = 7
           8040000    0x80000678 addi a4, s7, 7                 #; s7  = 0x00070000, (wrb) a4  <-- 0x00070007
           8041000                                              #; (acc) a3  <-- 0x00070007
#; .LBB0_3 (xpulp_vect.c:502:27)
#;   if (result_rd != 0x00070007) errs++;
#;                 ^
           8042000    0x8000067c xor a3, a3, a4                 #; a3  = 0x00070007, a4  = 0x00070007, (wrb) a3  <-- 0
           8053000    0x80000680 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           8054000    0x80000684 addi a4, s6, 9                 #; s6  = 0xff000000, (wrb) a4  <-- 0xff000009
#; .LBB0_3 (xpulp_vect.c:502:17)
#;   if (result_rd != 0x00070007) errs++;
#;       ^
           8055000    0x80000688 add t3, t3, a3                 #; t3  = 0, a3  = 0, (wrb) t3  <-- 0
#; .LBB0_3 (xpulp_vect.c:509:13)
#;   asm volatile("pv.max.sci.h a3, a4, 6\n"
#;   ^
           8056000    0x8000068c .text                          #; a4  = 0xff000009
           8057000    0x80000690 addi a4, t6, 9                 #; t6  = 0x00060000, (wrb) a4  <-- 0x00060009
           8058000                                              #; (acc) a3  <-- 0x00060009
#; .LBB0_3 (xpulp_vect.c:514:27)
#;   if (result_rd != 0x00060009) errs++;
#;                 ^
           8059000    0x80000694 xor a3, a3, a4                 #; a3  = 0x00060009, a4  = 0x00060009, (wrb) a3  <-- 0
           8060000    0x80000698 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           8061000    0x8000069c lui a4, 522240                 #; (wrb) a4  <-- 0x7f800000
           8062000    0x800006a0 addi a4, a4, 258               #; a4  = 0x7f800000, (wrb) a4  <-- 0x7f800102
           8063000    0x800006a4 addi a5, s0, 1022              #; s0  = 0x00020000, (wrb) a5  <-- 0x000203fe
#; .LBB0_3 (xpulp_vect.c:514:17)
#;   if (result_rd != 0x00060009) errs++;
#;       ^
           8064000    0x800006a8 add t3, t3, a3                 #; t3  = 0, a3  = 0, (wrb) t3  <-- 0
#; .LBB0_3 (xpulp_vect.c:522:13)
#;   asm volatile("pv.max.b a3, a4, a5\n"
#;   ^
           8065000    0x800006ac .text                          #; a4  = 0x7f800102, a5  = 0x000203fe
           8066000    0x800006b0 lui a4, 520224                 #; (wrb) a4  <-- 0x7f020000
           8067000    0x800006b4 addi a4, a4, 770               #; a4  = 0x7f020000, (wrb) a4  <-- 0x7f020302
           8068000                                              #; (acc) a3  <-- 0x7f020302
#; .LBB0_3 (xpulp_vect.c:527:27)
#;   if (result_rd != 0x7F020302) errs++;
#;                 ^
           8069000    0x800006b8 xor a3, a3, a4                 #; a3  = 0x7f020302, a4  = 0x7f020302, (wrb) a3  <-- 0
           8070000    0x800006bc snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:527:17)
#;   if (result_rd != 0x7F020302) errs++;
#;       ^
           8081000    0x800006c0 add s0, t3, a3                 #; t3  = 0, a3  = 0, (wrb) s0  <-- 0
#; .LBB0_3 (xpulp_vect.c:535:13)
#;   asm volatile("pv.max.sc.b a3, a4, a5\n"
#;   ^
           8082000    0x800006c4 li a5, 3                       #; (wrb) a5  <-- 3
           8083000    0x800006c8 mv a4, t1                      #; t1  = 0x02030405, (wrb) a4  <-- 0x02030405
           8084000    0x800006cc .text                          #; a4  = 0x02030405, a5  = 3
           8085000    0x800006d0 lui t3, 12336                  #; (wrb) t3  <-- 0x03030000
           8086000    0x800006d4 addi a4, t3, 1029              #; t3  = 0x03030000, (wrb) a4  <-- 0x03030405
           8087000                                              #; (acc) a3  <-- 0x03030405
#; .LBB0_3 (xpulp_vect.c:540:27)
#;   if (result_rd != 0x03030405) errs++;
#;                 ^
           8088000    0x800006d8 xor a3, a3, a4                 #; a3  = 0x03030405, a4  = 0x03030405, (wrb) a3  <-- 0
           8089000    0x800006dc snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           8090000    0x800006e0 lui a5, 24656                  #; (wrb) a5  <-- 0x06050000
           8091000    0x800006e4 addi a4, a5, 1027              #; a5  = 0x06050000, (wrb) a4  <-- 0x06050403
#; .LBB0_3 (xpulp_vect.c:540:17)
#;   if (result_rd != 0x03030405) errs++;
#;       ^
           8092000    0x800006e8 add t1, s0, a3                 #; s0  = 0, a3  = 0, (wrb) t1  <-- 0
#; .LBB0_3 (xpulp_vect.c:547:13)
#;   asm volatile("pv.max.sci.b a3, a4, 4\n"
#;   ^
           8093000    0x800006ec .text                          #; a4  = 0x06050403
           8094000    0x800006f0 addi a4, a5, 1028              #; a5  = 0x06050000, (wrb) a4  <-- 0x06050404
           8095000                                              #; (acc) a3  <-- 0x06050404
#; .LBB0_3 (xpulp_vect.c:552:27)
#;   if (result_rd != 0x06050404) errs++;
#;                 ^
           8096000    0x800006f4 xor a3, a3, a4                 #; a3  = 0x06050404, a4  = 0x06050404, (wrb) a3  <-- 0
           8097000    0x800006f8 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           8098000    0x800006fc lui s0, 524288                 #; (wrb) s0  <-- 0x80000000
           8109000    0x80000700 addi a4, s0, 16                #; s0  = 0x80000000, (wrb) a4  <-- 0x80000010
           8110000    0x80000704 lui a5, 524272                 #; (wrb) a5  <-- 0x7fff0000
           8111000    0x80000708 addi a5, a5, 32                #; a5  = 0x7fff0000, (wrb) a5  <-- 0x7fff0020
#; .LBB0_3 (xpulp_vect.c:552:17)
#;   if (result_rd != 0x06050404) errs++;
#;       ^
           8112000    0x8000070c add t1, t1, a3                 #; t1  = 0, a3  = 0, (wrb) t1  <-- 0
#; .LBB0_3 (xpulp_vect.c:560:13)
#;   asm volatile("pv.maxu.h a3, a4, a5\n"
#;   ^
           8113000    0x80000710 .text                          #; a4  = 0x80000010, a5  = 0x7fff0020
           8114000    0x80000714 addi a4, s0, 32                #; s0  = 0x80000000, (wrb) a4  <-- 0x80000020
           8115000                                              #; (acc) a3  <-- 0x80000020
#; .LBB0_3 (xpulp_vect.c:565:27)
#;   if (result_rd != 0x80000020) errs++;
#;                 ^
           8116000    0x80000718 xor a3, a3, a4                 #; a3  = 0x80000020, a4  = 0x80000020, (wrb) a3  <-- 0
           8117000    0x8000071c snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:565:17)
#;   if (result_rd != 0x80000020) errs++;
#;       ^
           8118000    0x80000720 add s0, t1, a3                 #; t1  = 0, a3  = 0, (wrb) s0  <-- 0
           8119000    0x80000724 lui a3, 272                    #; (wrb) a3  <-- 0x00110000
           8120000    0x80000728 addi t1, a3, -256              #; a3  = 0x00110000, (wrb) t1  <-- 0x0010ff00
#; .LBB0_3 (xpulp_vect.c:573:13)
#;   asm volatile("pv.maxu.sc.h a3, a4, a5\n"
#;   ^
           8121000    0x8000072c li a5, 8                       #; (wrb) a5  <-- 8
           8122000    0x80000730 mv a4, t1                      #; t1  = 0x0010ff00, (wrb) a4  <-- 0x0010ff00
           8123000    0x80000734 .text                          #; a4  = 0x0010ff00, a5  = 8
           8125000                                              #; (acc) a3  <-- 0x0010ff00
#; .LBB0_3 (xpulp_vect.c:578:27)
#;   if (result_rd != 0x0010FF00) errs++;
#;                 ^
           8126000    0x80000738 xor a3, a3, t1                 #; a3  = 0x0010ff00, t1  = 0x0010ff00, (wrb) a3  <-- 0
           8127000    0x8000073c snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:578:17)
#;   if (result_rd != 0x0010FF00) errs++;
#;       ^
           8138000    0x80000740 add t1, s0, a3                 #; s0  = 0, a3  = 0, (wrb) t1  <-- 0
#; .LBB0_3 (xpulp_vect.c:585:13)
#;   asm volatile("pv.maxu.sci.h a3, a4, 6\n"
#;   ^
           8139000    0x80000744 mv a4, a6                      #; a6  = 0x00040005, (wrb) a4  <-- 0x00040005
           8140000    0x80000748 .text                          #; a4  = 0x00040005
           8141000    0x8000074c addi a4, t6, 6                 #; t6  = 0x00060000, (wrb) a4  <-- 0x00060006
           8142000                                              #; (acc) a3  <-- 0x00060006
#; .LBB0_3 (xpulp_vect.c:590:27)
#;   if (result_rd != 0x00060006) errs++;
#;                 ^
           8143000    0x80000750 xor a3, a3, a4                 #; a3  = 0x00060006, a4  = 0x00060006, (wrb) a3  <-- 0
           8144000    0x80000754 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           8145000    0x80000758 lui a4, 24546                  #; (wrb) a4  <-- 0x05fe2000
           8146000    0x8000075c addi a5, a4, 224               #; a4  = 0x05fe2000, (wrb) a5  <-- 0x05fe20e0
#; .LBB0_3 (xpulp_vect.c:590:17)
#;   if (result_rd != 0x00060006) errs++;
#;       ^
           8147000    0x80000760 add t1, t1, a3                 #; t1  = 0, a3  = 0, (wrb) t1  <-- 0
#; .LBB0_3 (xpulp_vect.c:598:13)
#;   asm volatile("pv.maxu.b a3, a4, a5\n"
#;   ^
           8148000    0x80000764 mv a4, t2                      #; t2  = 0x10ff00f0, (wrb) a4  <-- 0x10ff00f0
           8149000    0x80000768 .text                          #; a4  = 0x10ff00f0, a5  = 0x05fe20e0
           8150000    0x8000076c lui a4, 69618                  #; (wrb) a4  <-- 0x10ff2000
           8151000    0x80000770 addi a4, a4, 240               #; a4  = 0x10ff2000, (wrb) a4  <-- 0x10ff20f0
           8152000                                              #; (acc) a3  <-- 0x10ff20f0
#; .LBB0_3 (xpulp_vect.c:603:27)
#;   if (result_rd != 0x10FF20F0) errs++;
#;                 ^
           8153000    0x80000774 xor a3, a3, a4                 #; a3  = 0x10ff20f0, a4  = 0x10ff20f0, (wrb) a3  <-- 0
           8154000    0x80000778 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:603:17)
#;   if (result_rd != 0x10FF20F0) errs++;
#;       ^
           8155000    0x8000077c add t1, t1, a3                 #; t1  = 0, a3  = 0, (wrb) t1  <-- 0
#; .LBB0_3 (xpulp_vect.c:611:13)
#;   asm volatile("pv.maxu.sc.b a3, a4, a5\n"
#;   ^
           8166000    0x80000780 li a5, 6                       #; (wrb) a5  <-- 6
           8167000    0x80000784 mv a4, a0                      #; a0  = 0x05060708, (wrb) a4  <-- 0x05060708
           8168000    0x80000788 .text                          #; a4  = 0x05060708, a5  = 6
           8169000    0x8000078c lui a4, 24672                  #; (wrb) a4  <-- 0x06060000
           8170000    0x80000790 addi a4, a4, 1800              #; a4  = 0x06060000, (wrb) a4  <-- 0x06060708
           8171000                                              #; (acc) a3  <-- 0x06060708
#; .LBB0_3 (xpulp_vect.c:616:27)
#;   if (result_rd != 0x06060708) errs++;
#;                 ^
           8172000    0x80000794 xor a3, a3, a4                 #; a3  = 0x06060708, a4  = 0x06060708, (wrb) a3  <-- 0
           8173000    0x80000798 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:616:17)
#;   if (result_rd != 0x06060708) errs++;
#;       ^
           8174000    0x8000079c add t1, t1, a3                 #; t1  = 0, a3  = 0, (wrb) t1  <-- 0
#; .LBB0_3 (xpulp_vect.c:623:13)
#;   asm volatile("pv.maxu.sci.b a3, a4, 3\n"
#;   ^
           8175000    0x800007a0 mv a4, a7                      #; a7  = 0x01020304, (wrb) a4  <-- 0x01020304
           8176000    0x800007a4 .text                          #; a4  = 0x01020304
           8177000    0x800007a8 addi a4, t3, 772               #; t3  = 0x03030000, (wrb) a4  <-- 0x03030304
           8178000                                              #; (acc) a3  <-- 0x03030304
#; .LBB0_3 (xpulp_vect.c:628:27)
#;   if (result_rd != 0x03030304) errs++;
#;                 ^
           8179000    0x800007ac xor a3, a3, a4                 #; a3  = 0x03030304, a4  = 0x03030304, (wrb) a3  <-- 0
           8180000    0x800007b0 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           8181000    0x800007b4 lui a4, 655601                 #; (wrb) a4  <-- 0xa00f1000
           8182000    0x800007b8 addi a4, a4, 564               #; a4  = 0xa00f1000, (wrb) a4  <-- 0xa00f1234
           8183000    0x800007bc addi a5, s3, 2                 #; s3  = 0x00030000, (wrb) a5  <-- 0x00030002
#; .LBB0_3 (xpulp_vect.c:628:17)
#;   if (result_rd != 0x03030304) errs++;
#;       ^
           8194000    0x800007c0 add t1, t1, a3                 #; t1  = 0, a3  = 0, (wrb) t1  <-- 0
#; .LBB0_3 (xpulp_vect.c:636:13)
#;   asm volatile("pv.srl.h a3, a4, a5\n": "=r"(rd): "r"(rs1),"r"(rs2):"a3","a4","a5");
#;   ^
           8195000    0x800007c4 .text                          #; a4  = 0xa00f1234, a5  = 0x00030002
           8196000    0x800007c8 lui a4, 81936                  #; (wrb) a4  <-- 0x14010000
           8197000    0x800007cc addi a4, a4, 1165              #; a4  = 0x14010000, (wrb) a4  <-- 0x1401048d
           8198000                                              #; (acc) a3  <-- 0x1401048d
#; .LBB0_3 (xpulp_vect.c:638:27)
#;   if (result_rd != 0x1401048D) errs++;
#;                 ^
           8199000    0x800007d0 xor a3, a3, a4                 #; a3  = 0x1401048d, a4  = 0x1401048d, (wrb) a3  <-- 0
           8200000    0x800007d4 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:638:17)
#;   if (result_rd != 0x1401048D) errs++;
#;       ^
           8201000    0x800007d8 add t1, t1, a3                 #; t1  = 0, a3  = 0, (wrb) t1  <-- 0
           8202000    0x800007dc lui a3, 983041                 #; (wrb) a3  <-- 0xf0001000
           8203000    0x800007e0 addi a4, a3, 564               #; a3  = 0xf0001000, (wrb) a4  <-- 0xf0001234
#; .LBB0_3 (xpulp_vect.c:646:13)
#;   asm volatile("pv.srl.sc.h a3, a4, a5\n": "=r"(rd): "r"(rs1),"r"(rs2):"a3","a4","a5");
#;   ^
           8204000    0x800007e4 li a5, 3                       #; (wrb) a5  <-- 3
           8205000    0x800007e8 .text                          #; a4  = 0xf0001234, a5  = 3
           8206000    0x800007ec lui a4, 122880                 #; (wrb) a4  <-- 0x1e000000
           8207000    0x800007f0 addi a4, a4, 582               #; a4  = 0x1e000000, (wrb) a4  <-- 0x1e000246
           8208000                                              #; (acc) a3  <-- 0x1e000246
#; .LBB0_3 (xpulp_vect.c:648:27)
#;   if (result_rd != 0x1E000246) errs++;
#;                 ^
           8209000    0x800007f4 xor a3, a3, a4                 #; a3  = 0x1e000246, a4  = 0x1e000246, (wrb) a3  <-- 0
           8210000    0x800007f8 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:648:17)
#;   if (result_rd != 0x1E000246) errs++;
#;       ^
           8211000    0x800007fc add a5, t1, a3                 #; t1  = 0, a3  = 0, (wrb) a5  <-- 0
#; .LBB0_3 (xpulp_vect.c:655:13)
#;   asm volatile("pv.srl.sci.h a3, a4, 4\n": "=r"(rd): "r"(rs1):"a3","a4");
#;   ^
           8222000    0x80000800 mv a4, t0                      #; t0  = 0x12345678, (wrb) a4  <-- 0x12345678
           8223000    0x80000804 .text                          #; a4  = 0x12345678
           8224000    0x80000808 lui a4, 4656                   #; (wrb) a4  <-- 0x01230000
           8225000    0x8000080c addi a4, a4, 1383              #; a4  = 0x01230000, (wrb) a4  <-- 0x01230567
           8226000                                              #; (acc) a3  <-- 0x01230567
#; .LBB0_3 (xpulp_vect.c:657:27)
#;   if (result_rd != 0x01230567) errs++;
#;                 ^
           8227000    0x80000810 xor a3, a3, a4                 #; a3  = 0x01230567, a4  = 0x01230567, (wrb) a3  <-- 0
           8228000    0x80000814 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           8229000    0x80000818 lui a4, 988680                 #; (wrb) a4  <-- 0xf1608000
           8230000    0x8000081c addi a4, a4, 255               #; a4  = 0xf1608000, (wrb) a4  <-- 0xf16080ff
#; .LBB0_3 (xpulp_vect.c:657:17)
#;   if (result_rd != 0x01230567) errs++;
#;       ^
           8231000    0x80000820 add t1, a5, a3                 #; a5  = 0, a3  = 0, (wrb) t1  <-- 0
#; .LBB0_3 (xpulp_vect.c:665:13)
#;   asm volatile("pv.srl.b a3, a4, a5\n": "=r"(rd): "r"(rs1),"r"(rs2):"a3","a4","a5");
#;   ^
           8232000    0x80000824 mv a5, a7                      #; a7  = 0x01020304, (wrb) a5  <-- 0x01020304
           8233000    0x80000828 .text                          #; a4  = 0xf16080ff, a5  = 0x01020304
           8234000    0x8000082c lui a4, 491905                 #; (wrb) a4  <-- 0x78181000
           8235000    0x80000830 addi a4, a4, 15                #; a4  = 0x78181000, (wrb) a4  <-- 0x7818100f
           8236000                                              #; (acc) a3  <-- 0x7818100f
#; .LBB0_3 (xpulp_vect.c:667:27)
#;   if (result_rd != 0x7818100F) errs++;
#;                 ^
           8237000    0x80000834 xor a3, a3, a4                 #; a3  = 0x7818100f, a4  = 0x7818100f, (wrb) a3  <-- 0
           8238000    0x80000838 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:667:17)
#;   if (result_rd != 0x7818100F) errs++;
#;       ^
           8239000    0x8000083c add t1, t1, a3                 #; t1  = 0, a3  = 0, (wrb) t1  <-- 0
           8250000    0x80000840 lui a3, 986636                 #; (wrb) a3  <-- 0xf0e0c000
           8251000    0x80000844 addi a4, a3, 128               #; a3  = 0xf0e0c000, (wrb) a4  <-- 0xf0e0c080
#; .LBB0_3 (xpulp_vect.c:675:13)
#;   asm volatile("pv.srl.sc.b a3, a4, a5\n": "=r"(rd): "r"(rs1),"r"(rs2):"a3","a4","a5");
#;   ^
           8252000    0x80000848 li a5, 2                       #; (wrb) a5  <-- 2
           8253000    0x8000084c .text                          #; a4  = 0xf0e0c080, a5  = 2
           8254000    0x80000850 lui a4, 246659                 #; (wrb) a4  <-- 0x3c383000
           8255000    0x80000854 addi a4, a4, 32                #; a4  = 0x3c383000, (wrb) a4  <-- 0x3c383020
           8256000                                              #; (acc) a3  <-- 0x3c383020
#; .LBB0_3 (xpulp_vect.c:677:27)
#;   if (result_rd != 0x3C383020) errs++;
#;                 ^
           8257000    0x80000858 xor a3, a3, a4                 #; a3  = 0x3c383020, a4  = 0x3c383020, (wrb) a3  <-- 0
           8258000    0x8000085c snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           8259000    0x80000860 lui a4, 924714                 #; (wrb) a4  <-- 0xe1c2a000
           8260000    0x80000864 addi a4, a4, 772               #; a4  = 0xe1c2a000, (wrb) a4  <-- 0xe1c2a304
#; .LBB0_3 (xpulp_vect.c:677:17)
#;   if (result_rd != 0x3C383020) errs++;
#;       ^
           8261000    0x80000868 add a5, t1, a3                 #; t1  = 0, a3  = 0, (wrb) a5  <-- 0
#; .LBB0_3 (xpulp_vect.c:684:13)
#;   asm volatile("pv.srl.sci.b a3, a4, 3\n": "=r"(rd): "r"(rs1):"a3","a4");
#;   ^
           8262000    0x8000086c .text                          #; a4  = 0xe1c2a304
           8263000    0x80000870 lui t3, 115073                 #; (wrb) t3  <-- 0x1c181000
           8264000    0x80000874 addi a4, t3, 1024              #; t3  = 0x1c181000, (wrb) a4  <-- 0x1c181400
           8265000                                              #; (acc) a3  <-- 0x1c181400
#; .LBB0_3 (xpulp_vect.c:686:27)
#;   if (result_rd != 0x1C181400) errs++;
#;                 ^
           8266000    0x80000878 xor a3, a3, a4                 #; a3  = 0x1c181400, a4  = 0x1c181400, (wrb) a3  <-- 0
           8267000    0x8000087c snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:686:17)
#;   if (result_rd != 0x1C181400) errs++;
#;       ^
           8278000    0x80000880 add t1, a5, a3                 #; a5  = 0, a3  = 0, (wrb) t1  <-- 0
           8279000    0x80000884 addi a5, t5, 4                 #; t5  = 0x00010000, (wrb) a5  <-- 0x00010004
#; .LBB0_3 (xpulp_vect.c:694:13)
#;   asm volatile("pv.sra.h a3, a4, a5\n": "=r"(rd): "r"(rs1),"r"(rs2):"a3","a4","a5");
#;   ^
           8280000    0x80000888 lui a4, 524319                 #; (wrb) a4  <-- 0x8001f000
           8281000    0x8000088c .text                          #; a4  = 0x8001f000, a5  = 0x00010004
           8282000    0x80000890 lui a4, 786448                 #; (wrb) a4  <-- 0xc0010000
           8283000    0x80000894 addi a4, a4, -256              #; a4  = 0xc0010000, (wrb) a4  <-- 0xc000ff00
           8284000                                              #; (acc) a3  <-- 0xc000ff00
#; .LBB0_3 (xpulp_vect.c:696:27)
#;   if (result_rd != 0xC000FF00) errs++;
#;                 ^
           8285000    0x80000898 xor a3, a3, a4                 #; a3  = 0xc000ff00, a4  = 0xc000ff00, (wrb) a3  <-- 0
           8286000    0x8000089c snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:696:17)
#;   if (result_rd != 0xC000FF00) errs++;
#;       ^
           8287000    0x800008a0 add t1, t1, a3                 #; t1  = 0, a3  = 0, (wrb) t1  <-- 0
           8288000    0x800008a4 addi a4, s6, 64                #; s6  = 0xff000000, (wrb) a4  <-- 0xff000040
#; .LBB0_3 (xpulp_vect.c:704:13)
#;   asm volatile("pv.sra.sc.h a3, a4, a5\n": "=r"(rd): "r"(rs1),"r"(rs2):"a3","a4","a5");
#;   ^
           8289000    0x800008a8 li a5, 2                       #; (wrb) a5  <-- 2
           8290000    0x800008ac .text                          #; a4  = 0xff000040, a5  = 2
           8291000    0x800008b0 lui a4, 1047552                #; (wrb) a4  <-- 0xffc00000
           8292000    0x800008b4 addi a4, a4, 16                #; a4  = 0xffc00000, (wrb) a4  <-- 0xffc00010
           8293000                                              #; (acc) a3  <-- 0xffc00010
#; .LBB0_3 (xpulp_vect.c:706:27)
#;   if (result_rd != 0xFFC00010) errs++;
#;                 ^
           8294000    0x800008b8 xor a3, a3, a4                 #; a3  = 0xffc00010, a4  = 0xffc00010, (wrb) a3  <-- 0
           8295000    0x800008bc snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:706:17)
#;   if (result_rd != 0xFFC00010) errs++;
#;       ^
           8306000    0x800008c0 add t2, t1, a3                 #; t1  = 0, a3  = 0, (wrb) t2  <-- 0
#; .LBB0_3 (xpulp_vect.c:713:13)
#;   asm volatile("pv.sra.sci.h a3, a4, 3\n": "=r"(rd): "r"(rs1):"a3","a4");
#;   ^
           8307000    0x800008c4 lui a4, 983047                 #; (wrb) a4  <-- 0xf0007000
           8308000    0x800008c8 .text                          #; a4  = 0xf0007000
           8309000    0x800008cc lui a4, 1040385                #; (wrb) a4  <-- 0xfe001000
           8310000    0x800008d0 addi a4, a4, -512              #; a4  = 0xfe001000, (wrb) a4  <-- 0xfe000e00
           8311000                                              #; (acc) a3  <-- 0xfe000e00
#; .LBB0_3 (xpulp_vect.c:715:27)
#;   if (result_rd != 0xFE000E00) errs++;
#;                 ^
           8312000    0x800008d4 xor a3, a3, a4                 #; a3  = 0xfe000e00, a4  = 0xfe000e00, (wrb) a3  <-- 0
           8313000    0x800008d8 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           8314000    0x800008dc lui a4, 528241                 #; (wrb) a4  <-- 0x80f71000
           8315000    0x800008e0 addi t1, a4, -2032             #; a4  = 0x80f71000, (wrb) t1  <-- 0x80f70810
           8316000    0x800008e4 addi a5, s2, 259               #; s2  = 0x01020000, (wrb) a5  <-- 0x01020103
#; .LBB0_3 (xpulp_vect.c:715:17)
#;   if (result_rd != 0xFE000E00) errs++;
#;       ^
           8317000    0x800008e8 add t2, t2, a3                 #; t2  = 0, a3  = 0, (wrb) t2  <-- 0
#; .LBB0_3 (xpulp_vect.c:723:13)
#;   asm volatile("pv.sra.b a3, a4, a5\n": "=r"(rd): "r"(rs1),"r"(rs2):"a3","a4","a5");
#;   ^
           8318000    0x800008ec mv a4, t1                      #; t1  = 0x80f70810, (wrb) a4  <-- 0x80f70810
           8319000    0x800008f0 .text                          #; a4  = 0x80f70810, a5  = 0x01020103
           8320000    0x800008f4 lui a4, 790480                 #; (wrb) a4  <-- 0xc0fd0000
           8321000    0x800008f8 addi a4, a4, 1026              #; a4  = 0xc0fd0000, (wrb) a4  <-- 0xc0fd0402
           8322000                                              #; (acc) a3  <-- 0xc0fd0402
#; .LBB0_3 (xpulp_vect.c:725:27)
#;   if (result_rd != 0xC0FD0402) errs++;
#;                 ^
           8323000    0x800008fc xor a3, a3, a4                 #; a3  = 0xc0fd0402, a4  = 0xc0fd0402, (wrb) a3  <-- 0
           8334000    0x80000900 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:725:17)
#;   if (result_rd != 0xC0FD0402) errs++;
#;       ^
           8335000    0x80000904 add t2, t2, a3                 #; t2  = 0, a3  = 0, (wrb) t2  <-- 0
           8336000    0x80000908 lui a3, 920584                 #; (wrb) a3  <-- 0xe0c08000
           8337000    0x8000090c addi a4, a3, 127               #; a3  = 0xe0c08000, (wrb) a4  <-- 0xe0c0807f
#; .LBB0_3 (xpulp_vect.c:733:13)
#;   asm volatile("pv.sra.sc.b a3, a4, a5\n": "=r"(rd): "r"(rs1),"r"(rs2):"a3","a4","a5");
#;   ^
           8338000    0x80000910 li a5, 2                       #; (wrb) a5  <-- 2
           8339000    0x80000914 .text                          #; a4  = 0xe0c0807f, a5  = 2
           8340000    0x80000918 lui a4, 1019662                #; (wrb) a4  <-- 0xf8f0e000
           8341000    0x8000091c addi a4, a4, 31                #; a4  = 0xf8f0e000, (wrb) a4  <-- 0xf8f0e01f
           8342000                                              #; (acc) a3  <-- 0xf8f0e01f
#; .LBB0_3 (xpulp_vect.c:735:27)
#;   if (result_rd != 0xF8F0E01F) errs++;
#;                 ^
           8343000    0x80000920 xor a3, a3, a4                 #; a3  = 0xf8f0e01f, a4  = 0xf8f0e01f, (wrb) a3  <-- 0
           8344000    0x80000924 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:735:17)
#;   if (result_rd != 0xF8F0E01F) errs++;
#;       ^
           8345000    0x80000928 add t2, t2, a3                 #; t2  = 0, a3  = 0, (wrb) t2  <-- 0
#; .LBB0_3 (xpulp_vect.c:742:13)
#;   asm volatile("pv.sra.sci.b a3, a4, 1\n": "=r"(rd): "r"(rs1):"a3","a4");
#;   ^
           8346000    0x8000092c lui a4, 522255                 #; (wrb) a4  <-- 0x7f80f000
           8347000    0x80000930 .text                          #; a4  = 0x7f80f000
           8348000    0x80000934 lui a4, 261136                 #; (wrb) a4  <-- 0x3fc10000
           8349000    0x80000938 addi a4, a4, -2048             #; a4  = 0x3fc10000, (wrb) a4  <-- 0x3fc0f800
           8350000                                              #; (acc) a3  <-- 0x3fc0f800
#; .LBB0_3 (xpulp_vect.c:744:27)
#;   if (result_rd != 0x3FC0F800) errs++;
#;                 ^
           8351000    0x8000093c xor a3, a3, a4                 #; a3  = 0x3fc0f800, a4  = 0x3fc0f800, (wrb) a3  <-- 0
           8362000    0x80000940 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           8363000    0x80000944 lui a4, 61464                  #; (wrb) a4  <-- 0x0f018000
           8364000    0x80000948 addi a4, a4, 7                 #; a4  = 0x0f018000, (wrb) a4  <-- 0x0f018007
           8365000    0x8000094c addi a5, t5, 3                 #; t5  = 0x00010000, (wrb) a5  <-- 0x00010003
#; .LBB0_3 (xpulp_vect.c:744:17)
#;   if (result_rd != 0x3FC0F800) errs++;
#;       ^
           8366000    0x80000950 add t2, t2, a3                 #; t2  = 0, a3  = 0, (wrb) t2  <-- 0
#; .LBB0_3 (xpulp_vect.c:752:13)
#;   asm volatile("pv.sll.h a3, a4, a5\n": "=r"(rd): "r"(rs1),"r"(rs2):"a3","a4","a5");
#;   ^
           8367000    0x80000954 .text                          #; a4  = 0x0f018007, a5  = 0x00010003
           8368000    0x80000958 lui a4, 122912                 #; (wrb) a4  <-- 0x1e020000
           8369000    0x8000095c addi a4, a4, 56                #; a4  = 0x1e020000, (wrb) a4  <-- 0x1e020038
           8370000                                              #; (acc) a3  <-- 0x1e020038
#; .LBB0_3 (xpulp_vect.c:754:27)
#;   if (result_rd != 0x1E020038) errs++;
#;                 ^
           8371000    0x80000960 xor a3, a3, a4                 #; a3  = 0x1e020038, a4  = 0x1e020038, (wrb) a3  <-- 0
           8372000    0x80000964 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:754:17)
#;   if (result_rd != 0x1E020038) errs++;
#;       ^
           8373000    0x80000968 add t6, t2, a3                 #; t2  = 0, a3  = 0, (wrb) t6  <-- 0
           8374000    0x8000096c lui s0, 3840                   #; (wrb) s0  <-- 0x00f00000
           8375000    0x80000970 addi a4, s0, 8                 #; s0  = 0x00f00000, (wrb) a4  <-- 0x00f00008
#; .LBB0_3 (xpulp_vect.c:762:13)
#;   asm volatile("pv.sll.sc.h a3, a4, a5\n": "=r"(rd): "r"(rs1),"r"(rs2):"a3","a4","a5");
#;   ^
           8376000    0x80000974 li a5, 2                       #; (wrb) a5  <-- 2
           8377000    0x80000978 .text                          #; a4  = 0x00f00008, a5  = 2
           8378000    0x8000097c lui a4, 15360                  #; (wrb) a4  <-- 0x03c00000
           8379000                                              #; (acc) a3  <-- 0x03c00020
           8389000    0x80000980 addi a4, a4, 32                #; a4  = 0x03c00000, (wrb) a4  <-- 0x03c00020
#; .LBB0_3 (xpulp_vect.c:764:27)
#;   if (result_rd != 0x3C00020) errs++;
#;                 ^
           8390000    0x80000984 xor a3, a3, a4                 #; a3  = 0x03c00020, a4  = 0x03c00020, (wrb) a3  <-- 0
           8391000    0x80000988 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           8392000    0x8000098c addi t2, t5, 2                 #; t5  = 0x00010000, (wrb) t2  <-- 0x00010002
#; .LBB0_3 (xpulp_vect.c:764:17)
#;   if (result_rd != 0x3C00020) errs++;
#;       ^
           8393000    0x80000990 add t5, t6, a3                 #; t6  = 0, a3  = 0, (wrb) t5  <-- 0
#; .LBB0_3 (xpulp_vect.c:771:13)
#;   asm volatile("pv.sll.sci.h a3, a4, 3\n": "=r"(rd): "r"(rs1):"a3","a4");
#;   ^
           8394000    0x80000994 mv a4, t2                      #; t2  = 0x00010002, (wrb) a4  <-- 0x00010002
           8395000    0x80000998 .text                          #; a4  = 0x00010002
           8396000    0x8000099c addi a4, t4, 16                #; t4  = 0x00080000, (wrb) a4  <-- 0x00080010
           8397000                                              #; (acc) a3  <-- 0x00080010
#; .LBB0_3 (xpulp_vect.c:773:27)
#;   if (result_rd != 0x00080010) errs++;
#;                 ^
           8398000    0x800009a0 xor a3, a3, a4                 #; a3  = 0x00080010, a4  = 0x00080010, (wrb) a3  <-- 0
           8399000    0x800009a4 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           8400000    0x800009a8 lui a4, 529442                 #; (wrb) a4  <-- 0x81422000
           8401000    0x800009ac addi a4, a4, 785               #; a4  = 0x81422000, (wrb) a4  <-- 0x81422311
           8402000    0x800009b0 addi a5, s2, 769               #; s2  = 0x01020000, (wrb) a5  <-- 0x01020301
#; .LBB0_3 (xpulp_vect.c:773:17)
#;   if (result_rd != 0x00080010) errs++;
#;       ^
           8403000    0x800009b4 add t4, t5, a3                 #; t5  = 0, a3  = 0, (wrb) t4  <-- 0
#; .LBB0_3 (xpulp_vect.c:781:13)
#;   asm volatile("pv.sll.b a3, a4, a5\n": "=r"(rd): "r"(rs1),"r"(rs2):"a3","a4","a5");
#;   ^
           8404000    0x800009b8 .text                          #; a4  = 0x81422311, a5  = 0x01020301
           8405000    0x800009bc lui a4, 8322                   #; (wrb) a4  <-- 0x02082000
           8406000                                              #; (acc) a3  <-- 0x02081822
           8416000    0x800009c0 addi a4, a4, -2014             #; a4  = 0x02082000, (wrb) a4  <-- 0x02081822
#; .LBB0_3 (xpulp_vect.c:783:27)
#;   if (result_rd != 0x02081822) errs++;
#;                 ^
           8417000    0x800009c4 xor a3, a3, a4                 #; a3  = 0x02081822, a4  = 0x02081822, (wrb) a3  <-- 0
           8418000    0x800009c8 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:783:17)
#;   if (result_rd != 0x02081822) errs++;
#;       ^
           8419000    0x800009cc add t4, t4, a3                 #; t4  = 0, a3  = 0, (wrb) t4  <-- 0
           8420000    0x800009d0 lui a3, 28768                  #; (wrb) a3  <-- 0x07060000
           8421000    0x800009d4 addi a4, a3, 1284              #; a3  = 0x07060000, (wrb) a4  <-- 0x07060504
#; .LBB0_3 (xpulp_vect.c:791:13)
#;   asm volatile("pv.sll.sc.b a3, a4, a5\n": "=r"(rd): "r"(rs1),"r"(rs2):"a3","a4","a5");
#;   ^
           8422000    0x800009d8 li a5, 2                       #; (wrb) a5  <-- 2
           8423000    0x800009dc .text                          #; a4  = 0x07060504, a5  = 2
           8424000    0x800009e0 addi a4, t3, 1040              #; t3  = 0x1c181000, (wrb) a4  <-- 0x1c181410
           8425000                                              #; (acc) a3  <-- 0x1c181410
#; .LBB0_3 (xpulp_vect.c:793:27)
#;   if (result_rd != 0x1C181410) errs++;
#;                 ^
           8426000    0x800009e4 xor a3, a3, a4                 #; a3  = 0x1c181410, a4  = 0x1c181410, (wrb) a3  <-- 0
           8427000    0x800009e8 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           8428000    0x800009ec lui a4, 350880                 #; (wrb) a4  <-- 0x55aa0000
           8429000    0x800009f0 addi a4, a4, 384               #; a4  = 0x55aa0000, (wrb) a4  <-- 0x55aa0180
#; .LBB0_3 (xpulp_vect.c:793:17)
#;   if (result_rd != 0x1C181410) errs++;
#;       ^
           8430000    0x800009f4 add a5, t4, a3                 #; t4  = 0, a3  = 0, (wrb) a5  <-- 0
#; .LBB0_3 (xpulp_vect.c:800:13)
#;   asm volatile("pv.sll.sci.b a3, a4, 1\n": "=r"(rd): "r"(rs1):"a3","a4");
#;   ^
           8431000    0x800009f8 .text                          #; a4  = 0x55aa0180
           8432000    0x800009fc lui a4, 697664                 #; (wrb) a4  <-- 0xaa540000
           8433000                                              #; (acc) a3  <-- 0xaa540200
           8443000    0x80000a00 addi a4, a4, 512               #; a4  = 0xaa540000, (wrb) a4  <-- 0xaa540200
#; .LBB0_3 (xpulp_vect.c:802:27)
#;   if (result_rd != 0xAA540200) errs++;
#;                 ^
           8444000    0x80000a04 xor a3, a3, a4                 #; a3  = 0xaa540200, a4  = 0xaa540200, (wrb) a3  <-- 0
           8445000    0x80000a08 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           8446000    0x80000a0c lui s6, 61680                  #; (wrb) s6  <-- 0x0f0f0000
           8447000    0x80000a10 addi t4, s6, 240               #; s6  = 0x0f0f0000, (wrb) t4  <-- 0x0f0f00f0
           8448000    0x80000a14 addi t3, s0, 15                #; s0  = 0x00f00000, (wrb) t3  <-- 0x00f0000f
#; .LBB0_3 (xpulp_vect.c:802:17)
#;   if (result_rd != 0xAA540200) errs++;
#;       ^
           8449000    0x80000a18 add t5, a5, a3                 #; a5  = 0, a3  = 0, (wrb) t5  <-- 0
#; .LBB0_3 (xpulp_vect.c:809:13)
#;   asm volatile("pv.or.h a3, a4, a5\n": "=r"(rd): "r"(rs1),"r"(rs2):"a3","a4","a5");
#;   ^
           8450000    0x80000a1c mv a4, t4                      #; t4  = 0x0f0f00f0, (wrb) a4  <-- 0x0f0f00f0
           8451000    0x80000a20 mv a5, t3                      #; t3  = 0x00f0000f, (wrb) a5  <-- 0x00f0000f
           8452000    0x80000a24 .text                          #; a4  = 0x0f0f00f0, a5  = 0x00f0000f
           8453000    0x80000a28 lui a4, 65520                  #; (wrb) a4  <-- 0x0fff0000
           8454000    0x80000a2c addi a4, a4, 255               #; a4  = 0x0fff0000, (wrb) a4  <-- 0x0fff00ff
           8455000                                              #; (acc) a3  <-- 0x0fff00ff
#; .LBB0_3 (xpulp_vect.c:811:27)
#;   if (result_rd != 0x0FFF00FF) errs++;
#;                 ^
           8456000    0x80000a30 xor a3, a3, a4                 #; a3  = 0x0fff00ff, a4  = 0x0fff00ff, (wrb) a3  <-- 0
           8457000    0x80000a34 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:811:17)
#;   if (result_rd != 0x0FFF00FF) errs++;
#;       ^
           8458000    0x80000a38 add t5, t5, a3                 #; t5  = 0, a3  = 0, (wrb) t5  <-- 0
           8459000    0x80000a3c lui a3, 74560                  #; (wrb) a3  <-- 0x12340000
           8470000    0x80000a40 addi t6, a3, 240               #; a3  = 0x12340000, (wrb) t6  <-- 0x123400f0
#; .LBB0_3 (xpulp_vect.c:819:13)
#;   asm volatile("pv.or.sc.h a3, a4, a5\n": "=r"(rd): "r"(rs1),"r"(rs2):"a3","a4","a5");
#;   ^
           8471000    0x80000a44 li a5, 170                     #; (wrb) a5  <-- 170
           8472000    0x80000a48 mv a4, t6                      #; t6  = 0x123400f0, (wrb) a4  <-- 0x123400f0
           8473000    0x80000a4c .text                          #; a4  = 0x123400f0, a5  = 170
           8474000    0x80000a50 lui a4, 76768                  #; (wrb) a4  <-- 0x12be0000
           8475000    0x80000a54 addi a4, a4, 250               #; a4  = 0x12be0000, (wrb) a4  <-- 0x12be00fa
           8476000                                              #; (acc) a3  <-- 0x12be00fa
#; .LBB0_3 (xpulp_vect.c:821:27)
#;   if (result_rd != 0x12BE00FA) errs++;
#;                 ^
           8477000    0x80000a58 xor a3, a3, a4                 #; a3  = 0x12be00fa, a4  = 0x12be00fa, (wrb) a3  <-- 0
           8478000    0x80000a5c snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:821:17)
#;   if (result_rd != 0x12BE00FA) errs++;
#;       ^
           8479000    0x80000a60 add a5, t5, a3                 #; t5  = 0, a3  = 0, (wrb) a5  <-- 0
#; .LBB0_3 (xpulp_vect.c:828:13)
#;   asm volatile("pv.or.sci.h a3, a4, 0x0A\n": "=r"(rd): "r"(rs1):"a3","a4");
#;   ^
           8480000    0x80000a64 mv a4, t3                      #; t3  = 0x00f0000f, (wrb) a4  <-- 0x00f0000f
           8481000    0x80000a68 .text                          #; a4  = 0x00f0000f
           8482000    0x80000a6c lui a4, 4000                   #; (wrb) a4  <-- 0x00fa0000
           8483000    0x80000a70 addi a4, a4, 15                #; a4  = 0x00fa0000, (wrb) a4  <-- 0x00fa000f
           8484000                                              #; (acc) a3  <-- 0x00fa000f
#; .LBB0_3 (xpulp_vect.c:830:27)
#;   if (result_rd != 0x00FA000F) errs++;
#;                 ^
           8485000    0x80000a74 xor a3, a3, a4                 #; a3  = 0x00fa000f, a4  = 0x00fa000f, (wrb) a3  <-- 0
           8486000    0x80000a78 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           8487000    0x80000a7c lui s5, 70179                  #; (wrb) s5  <-- 0x11223000
           8498000    0x80000a80 addi t3, s5, 836               #; s5  = 0x11223000, (wrb) t3  <-- 0x11223344
           8499000    0x80000a84 lui a4, 61681                  #; (wrb) a4  <-- 0x0f0f1000
           8500000    0x80000a88 addi t5, a4, -241              #; a4  = 0x0f0f1000, (wrb) t5  <-- 0x0f0f0f0f
#; .LBB0_3 (xpulp_vect.c:830:17)
#;   if (result_rd != 0x00FA000F) errs++;
#;       ^
           8501000    0x80000a8c add s0, a5, a3                 #; a5  = 0, a3  = 0, (wrb) s0  <-- 0
#; .LBB0_3 (xpulp_vect.c:838:13)
#;   asm volatile("pv.or.b a3, a4, a5\n": "=r"(rd): "r"(rs1),"r"(rs2):"a3","a4","a5");
#;   ^
           8502000    0x80000a90 mv a4, t3                      #; t3  = 0x11223344, (wrb) a4  <-- 0x11223344
           8503000    0x80000a94 mv a5, t5                      #; t5  = 0x0f0f0f0f, (wrb) a5  <-- 0x0f0f0f0f
           8504000    0x80000a98 .text                          #; a4  = 0x11223344, a5  = 0x0f0f0f0f
           8505000    0x80000a9c lui a4, 127732                 #; (wrb) a4  <-- 0x1f2f4000
           8506000    0x80000aa0 addi a4, a4, -177              #; a4  = 0x1f2f4000, (wrb) a4  <-- 0x1f2f3f4f
           8507000                                              #; (acc) a3  <-- 0x1f2f3f4f
#; .LBB0_3 (xpulp_vect.c:840:27)
#;   if (result_rd != 0x1F2F3F4F) errs++;
#;                 ^
           8508000    0x80000aa4 xor a3, a3, a4                 #; a3  = 0x1f2f3f4f, a4  = 0x1f2f3f4f, (wrb) a3  <-- 0
           8509000    0x80000aa8 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:840:17)
#;   if (result_rd != 0x1F2F3F4F) errs++;
#;       ^
           8510000    0x80000aac add s0, s0, a3                 #; s0  = 0, a3  = 0, (wrb) s0  <-- 0
#; .LBB0_3 (xpulp_vect.c:848:13)
#;   asm volatile("pv.or.sc.b a3, a4, a5\n": "=r"(rd): "r"(rs1),"r"(rs2):"a3","a4","a5");
#;   ^
           8511000    0x80000ab0 li a5, 15                      #; (wrb) a5  <-- 15
           8512000    0x80000ab4 mv a4, a7                      #; a7  = 0x01020304, (wrb) a4  <-- 0x01020304
           8513000    0x80000ab8 .text                          #; a4  = 0x01020304, a5  = 15
           8515000                                              #; (acc) a3  <-- 0x0f0f0f0f
#; .LBB0_3 (xpulp_vect.c:850:27)
#;   if (result_rd != 0x0F0F0F0F) errs++;
#;                 ^
           8516000    0x80000abc xor a3, a3, t5                 #; a3  = 0x0f0f0f0f, t5  = 0x0f0f0f0f, (wrb) a3  <-- 0
           8527000    0x80000ac0 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           8528000    0x80000ac4 lui a4, 662316                 #; (wrb) a4  <-- 0xa1b2c000
           8529000    0x80000ac8 addi a4, a4, 980               #; a4  = 0xa1b2c000, (wrb) a4  <-- 0xa1b2c3d4
#; .LBB0_3 (xpulp_vect.c:850:17)
#;   if (result_rd != 0x0F0F0F0F) errs++;
#;       ^
           8530000    0x80000acc add a5, s0, a3                 #; s0  = 0, a3  = 0, (wrb) a5  <-- 0
#; .LBB0_3 (xpulp_vect.c:857:13)
#;   asm volatile("pv.or.sci.b a3, a4, 0x0F\n": "=r"(rd): "r"(rs1):"a3","a4");
#;   ^
           8531000    0x80000ad0 .text                          #; a4  = 0xa1b2c3d4
           8532000    0x80000ad4 lui a4, 719869                 #; (wrb) a4  <-- 0xafbfd000
           8533000    0x80000ad8 addi a4, a4, -33               #; a4  = 0xafbfd000, (wrb) a4  <-- 0xafbfcfdf
           8534000                                              #; (acc) a3  <-- 0xafbfcfdf
#; .LBB0_3 (xpulp_vect.c:859:27)
#;   if (result_rd != 0xAFBFCFDF) errs++;
#;                 ^
           8535000    0x80000adc xor a3, a3, a4                 #; a3  = 0xafbfcfdf, a4  = 0xafbfcfdf, (wrb) a3  <-- 0
           8536000    0x80000ae0 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           8537000    0x80000ae4 lui a4, 699045                 #; (wrb) a4  <-- 0xaaaa5000
           8538000    0x80000ae8 addi a4, a4, 1365              #; a4  = 0xaaaa5000, (wrb) a4  <-- 0xaaaa5555
           8539000    0x80000aec lui s0, 61695                  #; (wrb) s0  <-- 0x0f0ff000
           8540000    0x80000af0 addi s0, s0, 240               #; s0  = 0x0f0ff000, (wrb) s0  <-- 0x0f0ff0f0
#; .LBB0_3 (xpulp_vect.c:859:17)
#;   if (result_rd != 0xAFBFCFDF) errs++;
#;       ^
           8541000    0x80000af4 add s7, a5, a3                 #; a5  = 0, a3  = 0, (wrb) s7  <-- 0
#; .LBB0_3 (xpulp_vect.c:867:13)
#;   asm volatile("pv.xor.h a3, a4, a5\n": "=r"(rd): "r"(rs1),"r"(rs2):"a3","a4","a5");
#;   ^
           8542000    0x80000af8 mv a5, s0                      #; s0  = 0x0f0ff0f0, (wrb) a5  <-- 0x0f0ff0f0
           8543000    0x80000afc .text                          #; a4  = 0xaaaa5555, a5  = 0x0f0ff0f0
           8545000                                              #; (acc) a3  <-- 0xa5a5a5a5
           8554000    0x80000b00 lui a4, 678490                 #; (wrb) a4  <-- 0xa5a5a000
           8555000    0x80000b04 addi a4, a4, 1445              #; a4  = 0xa5a5a000, (wrb) a4  <-- 0xa5a5a5a5
#; .LBB0_3 (xpulp_vect.c:869:27)
#;   if (result_rd != 0xA5A5A5A5) errs++;
#;                 ^
           8556000    0x80000b08 xor a3, a3, a4                 #; a3  = 0xa5a5a5a5, a4  = 0xa5a5a5a5, (wrb) a3  <-- 0
           8557000    0x80000b0c snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:869:17)
#;   if (result_rd != 0xA5A5A5A5) errs++;
#;       ^
           8558000    0x80000b10 add s7, s7, a3                 #; s7  = 0, a3  = 0, (wrb) s7  <-- 0
           8559000    0x80000b14 addi a4, s6, 15                #; s6  = 0x0f0f0000, (wrb) a4  <-- 0x0f0f000f
#; .LBB0_3 (xpulp_vect.c:877:13)
#;   asm volatile("pv.xor.sc.h a3, a4, a5\n": "=r"(rd): "r"(rs1),"r"(rs2):"a3","a4","a5");
#;   ^
           8560000    0x80000b18 li a5, 255                     #; (wrb) a5  <-- 255
           8561000    0x80000b1c .text                          #; a4  = 0x0f0f000f, a5  = 255
           8562000    0x80000b20 lui a4, 65280                  #; (wrb) a4  <-- 0x0ff00000
           8563000    0x80000b24 addi a4, a4, 240               #; a4  = 0x0ff00000, (wrb) a4  <-- 0x0ff000f0
           8564000                                              #; (acc) a3  <-- 0x0ff000f0
#; .LBB0_3 (xpulp_vect.c:879:27)
#;   if (result_rd != 0x0FF000F0) errs++;
#;                 ^
           8565000    0x80000b28 xor a3, a3, a4                 #; a3  = 0x0ff000f0, a4  = 0x0ff000f0, (wrb) a3  <-- 0
           8566000    0x80000b2c snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:879:17)
#;   if (result_rd != 0x0FF000F0) errs++;
#;       ^
           8567000    0x80000b30 add a5, s7, a3                 #; s7  = 0, a3  = 0, (wrb) a5  <-- 0
#; .LBB0_3 (xpulp_vect.c:886:13)
#;   asm volatile("pv.xor.sci.h a3, a4, 10\n": "=r"(rd): "r"(rs1):"a3","a4");
#;   ^
           8568000    0x80000b34 mv a4, t6                      #; t6  = 0x123400f0, (wrb) a4  <-- 0x123400f0
           8569000    0x80000b38 .text                          #; a4  = 0x123400f0
           8570000    0x80000b3c lui a4, 74720                  #; (wrb) a4  <-- 0x123e0000
           8571000                                              #; (acc) a3  <-- 0x123e00fa
           8581000    0x80000b40 addi a4, a4, 250               #; a4  = 0x123e0000, (wrb) a4  <-- 0x123e00fa
#; .LBB0_3 (xpulp_vect.c:888:27)
#;   if (result_rd != 0x123E00FA) errs++;
#;                 ^
           8582000    0x80000b44 xor a3, a3, a4                 #; a3  = 0x123e00fa, a4  = 0x123e00fa, (wrb) a3  <-- 0
           8583000    0x80000b48 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:888:17)
#;   if (result_rd != 0x123E00FA) errs++;
#;       ^
           8584000    0x80000b4c add t6, a5, a3                 #; a5  = 0, a3  = 0, (wrb) t6  <-- 0
#; .LBB0_3 (xpulp_vect.c:896:13)
#;   asm volatile("pv.xor.b a3, a4, a5\n": "=r"(rd): "r"(rs1),"r"(rs2):"a3","a4","a5");
#;   ^
           8585000    0x80000b50 mv a4, a7                      #; a7  = 0x01020304, (wrb) a4  <-- 0x01020304
           8586000    0x80000b54 mv a5, t5                      #; t5  = 0x0f0f0f0f, (wrb) a5  <-- 0x0f0f0f0f
           8587000    0x80000b58 .text                          #; a4  = 0x01020304, a5  = 0x0f0f0f0f
           8588000    0x80000b5c lui a4, 57553                  #; (wrb) a4  <-- 0x0e0d1000
           8589000    0x80000b60 addi a4, a4, -1013             #; a4  = 0x0e0d1000, (wrb) a4  <-- 0x0e0d0c0b
           8590000                                              #; (acc) a3  <-- 0x0e0d0c0b
#; .LBB0_3 (xpulp_vect.c:898:27)
#;   if (result_rd != 0x0E0D0C0B) errs++;
#;                 ^
           8591000    0x80000b64 xor a3, a3, a4                 #; a3  = 0x0e0d0c0b, a4  = 0x0e0d0c0b, (wrb) a3  <-- 0
           8592000    0x80000b68 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:898:17)
#;   if (result_rd != 0x0E0D0C0B) errs++;
#;       ^
           8593000    0x80000b6c add s6, t6, a3                 #; t6  = 0, a3  = 0, (wrb) s6  <-- 0
           8594000    0x80000b70 lui a3, 349799                 #; (wrb) a3  <-- 0x55667000
           8595000    0x80000b74 addi t6, a3, 1928              #; a3  = 0x55667000, (wrb) t6  <-- 0x55667788
#; .LBB0_3 (xpulp_vect.c:906:13)
#;   asm volatile("pv.xor.sc.b a3, a4, a5\n": "=r"(rd): "r"(rs1),"r"(rs2):"a3","a4","a5");
#;   ^
           8596000    0x80000b78 li a5, 15                      #; (wrb) a5  <-- 15
           8597000    0x80000b7c mv a4, t6                      #; t6  = 0x55667788, (wrb) a4  <-- 0x55667788
           8608000    0x80000b80 .text                          #; a4  = 0x55667788, a5  = 15
           8609000    0x80000b84 lui a4, 370328                 #; (wrb) a4  <-- 0x5a698000
           8610000    0x80000b88 addi a4, a4, -1913             #; a4  = 0x5a698000, (wrb) a4  <-- 0x5a697887
           8611000                                              #; (acc) a3  <-- 0x5a697887
#; .LBB0_3 (xpulp_vect.c:908:27)
#;   if (result_rd != 0x5a697887) errs++;
#;                 ^
           8612000    0x80000b8c xor a3, a3, a4                 #; a3  = 0x5a697887, a4  = 0x5a697887, (wrb) a3  <-- 0
           8613000    0x80000b90 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:908:17)
#;   if (result_rd != 0x5a697887) errs++;
#;       ^
           8614000    0x80000b94 add a5, s6, a3                 #; s6  = 0, a3  = 0, (wrb) a5  <-- 0
#; .LBB0_3 (xpulp_vect.c:915:13)
#;   asm volatile("pv.xor.sci.b a3, a4, 10\n": "=r"(rd): "r"(rs1):"a3","a4");
#;   ^
           8615000    0x80000b98 mv a4, t0                      #; t0  = 0x12345678, (wrb) a4  <-- 0x12345678
           8616000    0x80000b9c .text                          #; a4  = 0x12345678
           8617000    0x80000ba0 lui a4, 99302                  #; (wrb) a4  <-- 0x183e6000
           8618000    0x80000ba4 addi a4, a4, -910              #; a4  = 0x183e6000, (wrb) a4  <-- 0x183e5c72
           8619000                                              #; (acc) a3  <-- 0x183e5c72
#; .LBB0_3 (xpulp_vect.c:917:27)
#;   if (result_rd != 0x183e5c72) errs++;
#;                 ^
           8620000    0x80000ba8 xor a3, a3, a4                 #; a3  = 0x183e5c72, a4  = 0x183e5c72, (wrb) a3  <-- 0
           8621000    0x80000bac snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           8622000    0x80000bb0 lui a4, 1048560                #; (wrb) a4  <-- 0xffff0000
           8623000    0x80000bb4 addi a4, a4, 255               #; a4  = 0xffff0000, (wrb) a4  <-- -65281
#; .LBB0_3 (xpulp_vect.c:917:17)
#;   if (result_rd != 0x183e5c72) errs++;
#;       ^
           8624000    0x80000bb8 add s6, a5, a3                 #; a5  = 0, a3  = 0, (wrb) s6  <-- 0
#; .LBB0_3 (xpulp_vect.c:925:13)
#;   asm volatile("pv.and.h a3, a4, a5\n": "=r"(rd): "r"(rs1),"r"(rs2):"a3","a4","a5");
#;   ^
           8625000    0x80000bbc mv a5, s0                      #; s0  = 0x0f0ff0f0, (wrb) a5  <-- 0x0f0ff0f0
           8636000    0x80000bc0 .text                          #; a4  = -65281, a5  = 0x0f0ff0f0
           8638000                                              #; (acc) a3  <-- 0x0f0f00f0
#; .LBB0_3 (xpulp_vect.c:927:27)
#;   if (result_rd != 0x0F0F00F0) errs++;
#;                 ^
           8639000    0x80000bc4 xor a3, a3, t4                 #; a3  = 0x0f0f00f0, t4  = 0x0f0f00f0, (wrb) a3  <-- 0
           8640000    0x80000bc8 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:927:17)
#;   if (result_rd != 0x0F0F00F0) errs++;
#;       ^
           8641000    0x80000bcc add s0, s6, a3                 #; s6  = 0, a3  = 0, (wrb) s0  <-- 0
#; .LBB0_3 (xpulp_vect.c:935:13)
#;   asm volatile("pv.and.sc.h a3, a4, a5\n": "=r"(rd): "r"(rs1),"r"(rs2):"a3","a4","a5");
#;   ^
           8642000    0x80000bd0 li a5, 240                     #; (wrb) a5  <-- 240
           8643000    0x80000bd4 mv a4, t0                      #; t0  = 0x12345678, (wrb) a4  <-- 0x12345678
           8644000    0x80000bd8 .text                          #; a4  = 0x12345678, a5  = 240
           8645000    0x80000bdc lui a4, 768                    #; (wrb) a4  <-- 0x00300000
           8646000    0x80000be0 addi a4, a4, 112               #; a4  = 0x00300000, (wrb) a4  <-- 0x00300070
           8647000                                              #; (acc) a3  <-- 0x00300070
#; .LBB0_3 (xpulp_vect.c:937:27)
#;   if (result_rd != 0x00300070) errs++;
#;                 ^
           8648000    0x80000be4 xor a3, a3, a4                 #; a3  = 0x00300070, a4  = 0x00300070, (wrb) a3  <-- 0
           8649000    0x80000be8 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:937:17)
#;   if (result_rd != 0x00300070) errs++;
#;       ^
           8650000    0x80000bec add a5, s0, a3                 #; s0  = 0, a3  = 0, (wrb) a5  <-- 0
#; .LBB0_3 (xpulp_vect.c:944:13)
#;   asm volatile("pv.and.sci.h a3, a4, 0x0A\n": "=r"(rd): "r"(rs1):"a3","a4");
#;   ^
           8651000    0x80000bf0 mv a4, t4                      #; t4  = 0x0f0f00f0, (wrb) a4  <-- 0x0f0f00f0
           8652000    0x80000bf4 .text                          #; a4  = 0x0f0f00f0
           8653000    0x80000bf8 lui a4, 160                    #; (wrb) a4  <-- 0x000a0000
           8654000                                              #; (acc) a3  <-- 0x000a0000
#; .LBB0_3 (xpulp_vect.c:946:27)
#;   if (result_rd != 0x000A0000) errs++;
#;                 ^
           8655000    0x80000bfc xor a3, a3, a4                 #; a3  = 0x000a0000, a4  = 0x000a0000, (wrb) a3  <-- 0
           8666000    0x80000c00 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:946:17)
#;   if (result_rd != 0x000A0000) errs++;
#;       ^
           8667000    0x80000c04 add t0, a5, a3                 #; a5  = 0, a3  = 0, (wrb) t0  <-- 0
#; .LBB0_3 (xpulp_vect.c:954:13)
#;   asm volatile("pv.and.b a3, a4, a5\n": "=r"(rd): "r"(rs1),"r"(rs2):"a3","a4","a5");
#;   ^
           8668000    0x80000c08 mv a4, t3                      #; t3  = 0x11223344, (wrb) a4  <-- 0x11223344
           8669000    0x80000c0c mv a5, t5                      #; t5  = 0x0f0f0f0f, (wrb) a5  <-- 0x0f0f0f0f
           8670000    0x80000c10 .text                          #; a4  = 0x11223344, a5  = 0x0f0f0f0f
           8672000                                              #; (acc) a3  <-- 0x01020304
#; .LBB0_3 (xpulp_vect.c:956:27)
#;   if (result_rd != 0x01020304) errs++;
#;                 ^
           8673000    0x80000c14 xor a3, a3, a7                 #; a3  = 0x01020304, a7  = 0x01020304, (wrb) a3  <-- 0
           8674000    0x80000c18 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:956:17)
#;   if (result_rd != 0x01020304) errs++;
#;       ^
           8675000    0x80000c1c add t0, t0, a3                 #; t0  = 0, a3  = 0, (wrb) t0  <-- 0
           8676000    0x80000c20 lui a3, 990765                 #; (wrb) a3  <-- 0xf1e2d000
           8677000    0x80000c24 addi a4, a3, 964               #; a3  = 0xf1e2d000, (wrb) a4  <-- 0xf1e2d3c4
#; .LBB0_3 (xpulp_vect.c:964:13)
#;   asm volatile("pv.and.sc.b a3, a4, a5\n": "=r"(rd): "r"(rs1),"r"(rs2):"a3","a4","a5");
#;   ^
           8678000    0x80000c28 li a5, 15                      #; (wrb) a5  <-- 15
           8679000    0x80000c2c .text                          #; a4  = 0xf1e2d3c4, a5  = 15
           8681000                                              #; (acc) a3  <-- 0x01020304
#; .LBB0_3 (xpulp_vect.c:966:27)
#;   if (result_rd != 0x01020304) errs++;
#;                 ^
           8682000    0x80000c30 xor a3, a3, a7                 #; a3  = 0x01020304, a7  = 0x01020304, (wrb) a3  <-- 0
           8683000    0x80000c34 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:966:17)
#;   if (result_rd != 0x01020304) errs++;
#;       ^
           8684000    0x80000c38 add a5, t0, a3                 #; t0  = 0, a3  = 0, (wrb) a5  <-- 0
#; .LBB0_3 (xpulp_vect.c:973:13)
#;   asm volatile("pv.and.sci.b a3, a4, 16\n": "=r"(rd): "r"(rs1):"a3","a4");
#;   ^
           8685000    0x80000c3c mv a4, t6                      #; t6  = 0x55667788, (wrb) a4  <-- 0x55667788
           8696000    0x80000c40 .text                          #; a4  = 0x55667788
           8697000    0x80000c44 lui a4, 65537                  #; (wrb) a4  <-- 0x10001000
           8698000                                              #; (acc) a3  <-- 0x10001000
#; .LBB0_3 (xpulp_vect.c:975:27)
#;   if (result_rd != 0x10001000) errs++;
#;                 ^
           8699000    0x80000c48 xor a3, a3, a4                 #; a3  = 0x10001000, a4  = 0x10001000, (wrb) a3  <-- 0
           8700000    0x80000c4c snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:975:17)
#;   if (result_rd != 0x10001000) errs++;
#;       ^
           8701000    0x80000c50 add a5, a5, a3                 #; a5  = 0, a3  = 0, (wrb) a5  <-- 0
#; .LBB0_3 (xpulp_vect.c:982:13)
#;   asm volatile("pv.abs.h a3, a4\n" : "=r"(rd) : "r"(rs1) : "a3","a4");
#;   ^
           8702000    0x80000c54 lui a4, 524319                 #; (wrb) a4  <-- 0x8001f000
           8703000    0x80000c58 .text                          #; a4  = 0x8001f000
           8704000    0x80000c5c lui a4, 524273                 #; (wrb) a4  <-- 0x7fff1000
           8705000                                              #; (acc) a3  <-- 0x7fff1000
#; .LBB0_3 (xpulp_vect.c:984:27)
#;   if (result_rd != 0x7FFF1000) errs++;
#;                 ^
           8706000    0x80000c60 xor a3, a3, a4                 #; a3  = 0x7fff1000, a4  = 0x7fff1000, (wrb) a3  <-- 0
           8707000    0x80000c64 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:984:17)
#;   if (result_rd != 0x7FFF1000) errs++;
#;       ^
           8708000    0x80000c68 add t0, a5, a3                 #; a5  = 0, a3  = 0, (wrb) t0  <-- 0
#; .LBB0_3 (xpulp_vect.c:991:13)
#;   asm volatile("pv.abs.b a3, a4\n" : "=r"(rd) : "r"(rs1) : "a3","a4");
#;   ^
           8709000    0x80000c6c mv a4, t1                      #; t1  = 0x80f70810, (wrb) a4  <-- 0x80f70810
           8710000    0x80000c70 .text                          #; a4  = 0x80f70810
           8711000    0x80000c74 lui a4, 524433                 #; (wrb) a4  <-- 0x80091000
           8712000    0x80000c78 addi a4, a4, -2032             #; a4  = 0x80091000, (wrb) a4  <-- 0x80090810
           8713000                                              #; (acc) a3  <-- 0x80090810
#; .LBB0_3 (xpulp_vect.c:993:27)
#;   if (result_rd != 0x80090810) errs++;
#;                 ^
           8714000    0x80000c7c xor a3, a3, a4                 #; a3  = 0x80090810, a4  = 0x80090810, (wrb) a3  <-- 0
           8725000    0x80000c80 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           8726000    0x80000c84 lui a4, 703697                 #; (wrb) a4  <-- 0xabcd1000
           8727000    0x80000c88 addi a5, a4, 564               #; a4  = 0xabcd1000, (wrb) a5  <-- 0xabcd1234
#; .LBB0_3 (xpulp_vect.c:993:17)
#;   if (result_rd != 0x80090810) errs++;
#;       ^
           8728000    0x80000c8c add t0, t0, a3                 #; t0  = 0, a3  = 0, (wrb) t0  <-- 0
#; .LBB0_3 (xpulp_vect.c:1000:13)
#;   asm volatile("pv.extract.h a3, a4, 0\n" : "=r"(rd) : "r"(rs1) : "a3","a4");
#;   ^
           8729000    0x80000c90 mv a4, a5                      #; a5  = 0xabcd1234, (wrb) a4  <-- 0xabcd1234
           8730000    0x80000c94 .text                          #; a4  = 0xabcd1234
           8731000    0x80000c98 lui a4, 1                      #; (wrb) a4  <-- 4096
           8732000    0x80000c9c addi t4, a4, 564               #; a4  = 4096, (wrb) t4  <-- 4660
           8733000                                              #; (acc) a3  <-- 4660
#; .LBB0_3 (xpulp_vect.c:1002:27)
#;   if (result_rd != 0x00001234) errs++;
#;                 ^
           8734000    0x80000ca0 xor a3, a3, t4                 #; a3  = 4660, t4  = 4660, (wrb) a3  <-- 0
           8735000    0x80000ca4 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:1002:17)
#;   if (result_rd != 0x00001234) errs++;
#;       ^
           8736000    0x80000ca8 add t0, t0, a3                 #; t0  = 0, a3  = 0, (wrb) t0  <-- 0
#; .LBB0_3 (xpulp_vect.c:1004:13)
#;   asm volatile("pv.extract.h a3, a4, 1\n" : "=r"(rd) : "r"(rs1) : "a3","a4");
#;   ^
           8737000    0x80000cac mv a4, a5                      #; a5  = 0xabcd1234, (wrb) a4  <-- 0xabcd1234
           8738000    0x80000cb0 .text                          #; a4  = 0xabcd1234
           8739000    0x80000cb4 lui a4, 1048571                #; (wrb) a4  <-- -20480
           8740000    0x80000cb8 addi a4, a4, -1075             #; a4  = -20480, (wrb) a4  <-- -21555
           8741000                                              #; (acc) a3  <-- -21555
#; .LBB0_3 (xpulp_vect.c:1006:27)
#;   if (result_rd != 0xFFFFABCD) errs++;
#;                 ^
           8742000    0x80000cbc xor a3, a3, a4                 #; a3  = -21555, a4  = -21555, (wrb) a3  <-- 0
           8753000    0x80000cc0 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:1006:17)
#;   if (result_rd != 0xFFFFABCD) errs++;
#;       ^
           8754000    0x80000cc4 add t0, t0, a3                 #; t0  = 0, a3  = 0, (wrb) t0  <-- 0
#; .LBB0_3 (xpulp_vect.c:1013:13)
#;   asm volatile("pv.extract.b a3, a4, 0\n" : "=r"(rd) : "r"(rs1) : "a3","a4");
#;   ^
           8755000    0x80000cc8 mv a4, t1                      #; t1  = 0x80f70810, (wrb) a4  <-- 0x80f70810
           8756000    0x80000ccc .text                          #; a4  = 0x80f70810
           8758000                                              #; (acc) a3  <-- 16
#; .LBB0_3 (xpulp_vect.c:1015:27)
#;   if (result_rd != 0x00000010) errs++;
#;                 ^
           8759000    0x80000cd0 addi a3, a3, -16               #; a3  = 16, (wrb) a3  <-- 0
           8760000    0x80000cd4 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:1015:17)
#;   if (result_rd != 0x00000010) errs++;
#;       ^
           8761000    0x80000cd8 add t0, t0, a3                 #; t0  = 0, a3  = 0, (wrb) t0  <-- 0
#; .LBB0_3 (xpulp_vect.c:1017:13)
#;   asm volatile("pv.extract.b a3, a4, 3\n" : "=r"(rd) : "r"(rs1) : "a3","a4");
#;   ^
           8762000    0x80000cdc mv a4, t1                      #; t1  = 0x80f70810, (wrb) a4  <-- 0x80f70810
           8763000    0x80000ce0 .text                          #; a4  = 0x80f70810
           8765000                                              #; (acc) a3  <-- -128
#; .LBB0_3 (xpulp_vect.c:1019:27)
#;   if (result_rd != 0xFFFFFF80) errs++;
#;                 ^
           8766000    0x80000ce4 addi a3, a3, 128               #; a3  = -128, (wrb) a3  <-- 0
           8767000    0x80000ce8 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:1019:17)
#;   if (result_rd != 0xFFFFFF80) errs++;
#;       ^
           8768000    0x80000cec add t0, t0, a3                 #; t0  = 0, a3  = 0, (wrb) t0  <-- 0
#; .LBB0_3 (xpulp_vect.c:1026:13)
#;   asm volatile("pv.extractu.h a3, a4, 1\n" : "=r"(rd) : "r"(rs1) : "a3","a4");
#;   ^
           8769000    0x80000cf0 mv a4, a5                      #; a5  = 0xabcd1234, (wrb) a4  <-- 0xabcd1234
           8770000    0x80000cf4 .text                          #; a4  = 0xabcd1234
           8771000    0x80000cf8 lui a4, 11                     #; (wrb) a4  <-- 45056
           8772000    0x80000cfc addi a4, a4, -1075             #; a4  = 45056, (wrb) a4  <-- 43981
           8773000                                              #; (acc) a3  <-- 43981
#; .LBB0_3 (xpulp_vect.c:1028:27)
#;   if (result_rd != 0x0000ABCD) errs++;
#;                 ^
           8783000    0x80000d00 xor a3, a3, a4                 #; a3  = 43981, a4  = 43981, (wrb) a3  <-- 0
           8784000    0x80000d04 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:1028:17)
#;   if (result_rd != 0x0000ABCD) errs++;
#;       ^
           8785000    0x80000d08 add t0, t0, a3                 #; t0  = 0, a3  = 0, (wrb) t0  <-- 0
#; .LBB0_3 (xpulp_vect.c:1030:13)
#;   asm volatile("pv.extractu.h a3, a4, 0\n" : "=r"(rd) : "r"(rs1) : "a3","a4");
#;   ^
           8786000    0x80000d0c mv a4, a5                      #; a5  = 0xabcd1234, (wrb) a4  <-- 0xabcd1234
           8787000    0x80000d10 .text                          #; a4  = 0xabcd1234
           8789000                                              #; (acc) a3  <-- 4660
#; .LBB0_3 (xpulp_vect.c:1032:27)
#;   if (result_rd != 0x00001234) errs++;
#;                 ^
           8790000    0x80000d14 xor a3, a3, t4                 #; a3  = 4660, t4  = 4660, (wrb) a3  <-- 0
           8791000    0x80000d18 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:1032:17)
#;   if (result_rd != 0x00001234) errs++;
#;       ^
           8792000    0x80000d1c add a5, t0, a3                 #; t0  = 0, a3  = 0, (wrb) a5  <-- 0
#; .LBB0_3 (xpulp_vect.c:1039:13)
#;   asm volatile("pv.extractu.b a3, a4, 3\n" : "=r"(rd) : "r"(rs1) : "a3","a4");
#;   ^
           8793000    0x80000d20 mv a4, t1                      #; t1  = 0x80f70810, (wrb) a4  <-- 0x80f70810
           8794000    0x80000d24 .text                          #; a4  = 0x80f70810
           8796000                                              #; (acc) a3  <-- 128
#; .LBB0_3 (xpulp_vect.c:1041:27)
#;   if (result_rd != 0x00000080) errs++;
#;                 ^
           8797000    0x80000d28 addi a3, a3, -128              #; a3  = 128, (wrb) a3  <-- 0
           8798000    0x80000d2c snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:1041:17)
#;   if (result_rd != 0x00000080) errs++;
#;       ^
           8799000    0x80000d30 add t4, a5, a3                 #; a5  = 0, a3  = 0, (wrb) t4  <-- 0
#; .LBB0_3 (xpulp_vect.c:1043:13)
#;   asm volatile("pv.extractu.b a3, a4, 1\n" : "=r"(rd) : "r"(rs1) : "a3","a4");
#;   ^
           8800000    0x80000d34 mv a4, t1                      #; t1  = 0x80f70810, (wrb) a4  <-- 0x80f70810
           8801000    0x80000d38 .text                          #; a4  = 0x80f70810
           8803000                                              #; (acc) a3  <-- 8
#; .LBB0_3 (xpulp_vect.c:1045:27)
#;   if (result_rd != 0x00000008) errs++;
#;                 ^
           8804000    0x80000d3c addi a3, a3, -8                #; a3  = 8, (wrb) a3  <-- 0
           8815000    0x80000d40 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           8816000    0x80000d44 lui a4, 12                     #; (wrb) a4  <-- 49152
           8817000    0x80000d48 addi a5, a4, -273              #; a4  = 49152, (wrb) a5  <-- 48879
           8818000    0x80000d4c lui a4, 69906                  #; (wrb) a4  <-- 0x11112000
           8819000    0x80000d50 addi t0, a4, 546               #; a4  = 0x11112000, (wrb) t0  <-- 0x11112222
#; .LBB0_3 (xpulp_vect.c:1045:17)
#;   if (result_rd != 0x00000008) errs++;
#;       ^
           8820000    0x80000d54 add t1, t4, a3                 #; t4  = 0, a3  = 0, (wrb) t1  <-- 0
#; .LBB0_3 (xpulp_vect.c:1052:13)
#;   asm volatile("pv.insert.h a3, a4, 1\n" : "+r"(rd) : "r"(rs1) : "a3","a4");
#;   ^
           8821000    0x80000d58 mv a4, a5                      #; a5  = 48879, (wrb) a4  <-- 48879
           8822000    0x80000d5c mv a3, t0                      #; t0  = 0x11112222, (wrb) a3  <-- 0x11112222
           8823000    0x80000d60 .text                          #; a4  = 48879
           8824000    0x80000d64 lui a4, 782066                 #; (wrb) a4  <-- 0xbeef2000
           8825000    0x80000d68 addi a4, a4, 546               #; a4  = 0xbeef2000, (wrb) a4  <-- 0xbeef2222
           8826000                                              #; (acc) a3  <-- 0xbeef2222
#; .LBB0_3 (xpulp_vect.c:1054:27)
#;   if (result_rd != 0xBEEF2222) errs++;
#;                 ^
           8827000    0x80000d6c xor a3, a3, a4                 #; a3  = 0xbeef2222, a4  = 0xbeef2222, (wrb) a3  <-- 0
           8828000    0x80000d70 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:1054:17)
#;   if (result_rd != 0xBEEF2222) errs++;
#;       ^
           8829000    0x80000d74 add t1, t1, a3                 #; t1  = 0, a3  = 0, (wrb) t1  <-- 0
#; .LBB0_3 (xpulp_vect.c:1057:13)
#;   asm volatile("pv.insert.h a3, a4, 0\n" : "+r"(rd) : "r"(rs1) : "a3","a4");
#;   ^
           8830000    0x80000d78 mv a4, a5                      #; a5  = 48879, (wrb) a4  <-- 48879
           8831000    0x80000d7c mv a3, t0                      #; t0  = 0x11112222, (wrb) a3  <-- 0x11112222
           8842000    0x80000d80 .text                          #; a4  = 48879
           8843000    0x80000d84 lui a4, 69916                  #; (wrb) a4  <-- 0x1111c000
           8844000    0x80000d88 addi a4, a4, -273              #; a4  = 0x1111c000, (wrb) a4  <-- 0x1111beef
           8845000                                              #; (acc) a3  <-- 0x1111beef
#; .LBB0_3 (xpulp_vect.c:1059:27)
#;   if (result_rd != 0x1111BEEF) errs++;
#;                 ^
           8846000    0x80000d8c xor a3, a3, a4                 #; a3  = 0x1111beef, a4  = 0x1111beef, (wrb) a3  <-- 0
           8847000    0x80000d90 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:1059:17)
#;   if (result_rd != 0x1111BEEF) errs++;
#;       ^
           8848000    0x80000d94 add a5, t1, a3                 #; t1  = 0, a3  = 0, (wrb) a5  <-- 0
#; .LBB0_3 (xpulp_vect.c:1066:13)
#;   asm volatile("pv.insert.b a3, a4, 2\n" : "+r"(rd) : "r"(rs1) : "a3","a4");
#;   ^
           8849000    0x80000d98 li a4, 170                     #; (wrb) a4  <-- 170
           8850000    0x80000d9c mv a3, t3                      #; t3  = 0x11223344, (wrb) a3  <-- 0x11223344
           8851000    0x80000da0 .text                          #; a4  = 170
           8852000    0x80000da4 lui a4, 72355                  #; (wrb) a4  <-- 0x11aa3000
           8853000    0x80000da8 addi a4, a4, 836               #; a4  = 0x11aa3000, (wrb) a4  <-- 0x11aa3344
           8854000                                              #; (acc) a3  <-- 0x11aa3344
#; .LBB0_3 (xpulp_vect.c:1068:27)
#;   if (result_rd != 0x11AA3344) errs++;
#;                 ^
           8855000    0x80000dac xor a3, a3, a4                 #; a3  = 0x11aa3344, a4  = 0x11aa3344, (wrb) a3  <-- 0
           8856000    0x80000db0 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:1068:17)
#;   if (result_rd != 0x11AA3344) errs++;
#;       ^
           8857000    0x80000db4 add a5, a5, a3                 #; a5  = 0, a3  = 0, (wrb) a5  <-- 0
#; .LBB0_3 (xpulp_vect.c:1071:13)
#;   asm volatile("pv.insert.b a3, a4, 0\n" : "+r"(rd) : "r"(rs1) : "a3","a4");
#;   ^
           8858000    0x80000db8 li a4, 170                     #; (wrb) a4  <-- 170
           8859000    0x80000dbc mv a3, t3                      #; t3  = 0x11223344, (wrb) a3  <-- 0x11223344
           8870000    0x80000dc0 .text                          #; a4  = 170
           8871000    0x80000dc4 addi a4, s5, 938               #; s5  = 0x11223000, (wrb) a4  <-- 0x112233aa
           8872000                                              #; (acc) a3  <-- 0x112233aa
#; .LBB0_3 (xpulp_vect.c:1073:27)
#;   if (result_rd != 0x112233AA) errs++;
#;                 ^
           8873000    0x80000dc8 xor a3, a3, a4                 #; a3  = 0x112233aa, a4  = 0x112233aa, (wrb) a3  <-- 0
           8874000    0x80000dcc snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:1073:17)
#;   if (result_rd != 0x112233AA) errs++;
#;       ^
           8875000    0x80000dd0 add t0, a5, a3                 #; a5  = 0, a3  = 0, (wrb) t0  <-- 0
#; .LBB0_3 (xpulp_vect.c:1081:13)
#;   asm volatile("pv.dotsp.h a3, a4, a5\n"
#;   ^
           8876000    0x80000dd4 mv a4, t2                      #; t2  = 0x00010002, (wrb) a4  <-- 0x00010002
           8877000    0x80000dd8 mv a5, a1                      #; a1  = 0x00030004, (wrb) a5  <-- 0x00030004
           8878000    0x80000ddc .text                          #; a4  = 0x00010002, a5  = 0x00030004
           8880000                                              #; (acc) a3  <-- 11
#; .LBB0_3 (xpulp_vect.c:1086:27)
#;   if (result_rd != 11) errs++;
#;                 ^
           8881000    0x80000de0 addi a3, a3, -11               #; a3  = 11, (wrb) a3  <-- 0
           8882000    0x80000de4 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:1086:17)
#;   if (result_rd != 11) errs++;
#;       ^
           8883000    0x80000de8 add t0, t0, a3                 #; t0  = 0, a3  = 0, (wrb) t0  <-- 0
           8884000    0x80000dec addi t1, s4, 3                 #; s4  = 0xfffe0000, (wrb) t1  <-- 0xfffe0003
#; .LBB0_3 (xpulp_vect.c:1094:13)
#;   asm volatile("pv.dotsp.sc.h a3, a4, a5\n"
#;   ^
           8885000    0x80000df0 li a5, 4                       #; (wrb) a5  <-- 4
           8886000    0x80000df4 mv a4, t1                      #; t1  = 0xfffe0003, (wrb) a4  <-- 0xfffe0003
           8887000    0x80000df8 .text                          #; a4  = 0xfffe0003, a5  = 4
           8889000                                              #; (acc) a3  <-- 4
#; .LBB0_3 (xpulp_vect.c:1099:27)
#;   if (result_rd != 4) errs++;
#;                 ^
           8890000    0x80000dfc addi a3, a3, -4                #; a3  = 4, (wrb) a3  <-- 0
           8901000    0x80000e00 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           8902000    0x80000e04 addi a4, s3, -2                #; s3  = 0x00030000, (wrb) a4  <-- 0x0002fffe
#; .LBB0_3 (xpulp_vect.c:1099:17)
#;   if (result_rd != 4) errs++;
#;       ^
           8903000    0x80000e08 add a5, t0, a3                 #; t0  = 0, a3  = 0, (wrb) a5  <-- 0
#; .LBB0_3 (xpulp_vect.c:1106:13)
#;   asm volatile("pv.dotsp.sci.h a3, a4, 3\n"
#;   ^
           8904000    0x80000e0c .text                          #; a4  = 0x0002fffe
           8906000                                              #; (acc) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:1111:27)
#;   if (result_rd != 0) errs++;
#;                 ^
           8907000    0x80000e10 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:1111:17)
#;   if (result_rd != 0) errs++;
#;       ^
           8908000    0x80000e14 add t0, a5, a3                 #; a5  = 0, a3  = 0, (wrb) t0  <-- 0
#; .LBB0_3 (xpulp_vect.c:1119:13)
#;   asm volatile("pv.dotsp.b a3, a4, a5\n"
#;   ^
           8909000    0x80000e18 mv a4, a7                      #; a7  = 0x01020304, (wrb) a4  <-- 0x01020304
           8910000    0x80000e1c mv a5, a0                      #; a0  = 0x05060708, (wrb) a5  <-- 0x05060708
           8911000    0x80000e20 .text                          #; a4  = 0x01020304, a5  = 0x05060708
           8913000                                              #; (acc) a3  <-- 70
#; .LBB0_3 (xpulp_vect.c:1124:27)
#;   if (result_rd != 70) errs++;
#;                 ^
           8914000    0x80000e24 addi a3, a3, -70               #; a3  = 70, (wrb) a3  <-- 0
           8915000    0x80000e28 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:1124:17)
#;   if (result_rd != 70) errs++;
#;       ^
           8916000    0x80000e2c add t3, t0, a3                 #; t0  = 0, a3  = 0, (wrb) t3  <-- 0
           8917000    0x80000e30 lui a3, 8176                   #; (wrb) a3  <-- 0x01ff0000
           8918000    0x80000e34 addi t0, a3, 515               #; a3  = 0x01ff0000, (wrb) t0  <-- 0x01ff0203
#; .LBB0_3 (xpulp_vect.c:1132:13)
#;   asm volatile("pv.dotsp.sc.b a3, a4, a5\n"
#;   ^
           8919000    0x80000e38 li a5, 4                       #; (wrb) a5  <-- 4
           8920000    0x80000e3c mv a4, t0                      #; t0  = 0x01ff0203, (wrb) a4  <-- 0x01ff0203
           8931000    0x80000e40 .text                          #; a4  = 0x01ff0203, a5  = 4
           8933000                                              #; (acc) a3  <-- 20
#; .LBB0_3 (xpulp_vect.c:1137:27)
#;   if (result_rd != 20) errs++;
#;                 ^
           8934000    0x80000e44 addi a3, a3, -20               #; a3  = 20, (wrb) a3  <-- 0
           8935000    0x80000e48 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           8936000    0x80000e4c addi t2, s2, 1021              #; s2  = 0x01020000, (wrb) t2  <-- 0x010203fd
#; .LBB0_3 (xpulp_vect.c:1137:17)
#;   if (result_rd != 20) errs++;
#;       ^
           8937000    0x80000e50 add a5, t3, a3                 #; t3  = 0, a3  = 0, (wrb) a5  <-- 0
#; .LBB0_3 (xpulp_vect.c:1144:13)
#;   asm volatile("pv.dotsp.sci.b a3, a4, 5\n"
#;   ^
           8938000    0x80000e54 mv a4, t2                      #; t2  = 0x010203fd, (wrb) a4  <-- 0x010203fd
           8939000    0x80000e58 .text                          #; a4  = 0x010203fd
           8941000                                              #; (acc) a3  <-- 15
#; .LBB0_3 (xpulp_vect.c:1149:27)
#;   if (result_rd != 15) errs++;
#;                 ^
           8942000    0x80000e5c addi a3, a3, -15               #; a3  = 15, (wrb) a3  <-- 0
           8943000    0x80000e60 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:1149:17)
#;   if (result_rd != 15) errs++;
#;       ^
           8944000    0x80000e64 add t3, a5, a3                 #; a5  = 0, a3  = 0, (wrb) t3  <-- 0
#; .LBB0_3 (xpulp_vect.c:1157:13)
#;   asm volatile("pv.dotup.h a3, a4, a5\n"
#;   ^
           8945000    0x80000e68 mv a4, a2                      #; a2  = 0x00020003, (wrb) a4  <-- 0x00020003
           8946000    0x80000e6c mv a5, a6                      #; a6  = 0x00040005, (wrb) a5  <-- 0x00040005
           8947000    0x80000e70 .text                          #; a4  = 0x00020003, a5  = 0x00040005
           8949000                                              #; (acc) a3  <-- 23
#; .LBB0_3 (xpulp_vect.c:1162:27)
#;   if (result_rd != 23) errs++;
#;                 ^
           8950000    0x80000e74 addi a2, a3, -23               #; a3  = 23, (wrb) a2  <-- 0
           8951000    0x80000e78 snez a2, a2                    #; a2  = 0, (wrb) a2  <-- 0
#; .LBB0_3 (xpulp_vect.c:1162:17)
#;   if (result_rd != 23) errs++;
#;       ^
           8952000    0x80000e7c add a2, t3, a2                 #; t3  = 0, a2  = 0, (wrb) a2  <-- 0
           8963000    0x80000e80 lui a3, 4064                   #; (wrb) a3  <-- 0x00fe0000
           8964000    0x80000e84 addi a4, a3, 2                 #; a3  = 0x00fe0000, (wrb) a4  <-- 0x00fe0002
#; .LBB0_3 (xpulp_vect.c:1170:13)
#;   asm volatile("pv.dotup.sc.h a3, a4, a5\n"
#;   ^
           8965000    0x80000e88 li a5, 3                       #; (wrb) a5  <-- 3
           8966000    0x80000e8c .text                          #; a4  = 0x00fe0002, a5  = 3
           8968000                                              #; (acc) a3  <-- 768
#; .LBB0_3 (xpulp_vect.c:1175:27)
#;   if (result_rd != 768) errs++;
#;                 ^
           8969000    0x80000e90 addi a3, a3, -768              #; a3  = 768, (wrb) a3  <-- 0
           8970000    0x80000e94 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:1175:17)
#;   if (result_rd != 768) errs++;
#;       ^
           8971000    0x80000e98 add a2, a2, a3                 #; a2  = 0, a3  = 0, (wrb) a2  <-- 0
#; .LBB0_3 (xpulp_vect.c:1182:13)
#;   asm volatile("pv.dotup.sci.h a3, a4, 5\n"
#;   ^
           8972000    0x80000e9c mv a4, a1                      #; a1  = 0x00030004, (wrb) a4  <-- 0x00030004
           8973000    0x80000ea0 .text                          #; a4  = 0x00030004
           8975000                                              #; (acc) a3  <-- 35
#; .LBB0_3 (xpulp_vect.c:1187:27)
#;   if (result_rd != 35) errs++;
#;                 ^
           8976000    0x80000ea4 addi a3, a3, -35               #; a3  = 35, (wrb) a3  <-- 0
           8977000    0x80000ea8 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:1187:17)
#;   if (result_rd != 35) errs++;
#;       ^
           8978000    0x80000eac add a2, a2, a3                 #; a2  = 0, a3  = 0, (wrb) a2  <-- 0
#; .LBB0_3 (xpulp_vect.c:1195:13)
#;   asm volatile("pv.dotup.b a3, a4, a5\n"
#;   ^
           8979000    0x80000eb0 mv a4, a7                      #; a7  = 0x01020304, (wrb) a4  <-- 0x01020304
           8980000    0x80000eb4 mv a5, a0                      #; a0  = 0x05060708, (wrb) a5  <-- 0x05060708
           8981000    0x80000eb8 .text                          #; a4  = 0x01020304, a5  = 0x05060708
           8983000                                              #; (acc) a3  <-- 70
#; .LBB0_3 (xpulp_vect.c:1200:27)
#;   if (result_rd != 70) errs++;
#;                 ^
           8984000    0x80000ebc addi a3, a3, -70               #; a3  = 70, (wrb) a3  <-- 0
           8995000    0x80000ec0 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:1200:17)
#;   if (result_rd != 70) errs++;
#;       ^
           8996000    0x80000ec4 add a2, a2, a3                 #; a2  = 0, a3  = 0, (wrb) a2  <-- 0
#; .LBB0_3 (xpulp_vect.c:1208:13)
#;   asm volatile("pv.dotup.sc.b a3, a4, a5\n"
#;   ^
           8997000    0x80000ec8 li a5, 3                       #; (wrb) a5  <-- 3
           8998000    0x80000ecc mv a4, a7                      #; a7  = 0x01020304, (wrb) a4  <-- 0x01020304
           8999000    0x80000ed0 .text                          #; a4  = 0x01020304, a5  = 3
           9001000                                              #; (acc) a3  <-- 30
#; .LBB0_3 (xpulp_vect.c:1213:27)
#;   if (result_rd != 30) errs++;
#;                 ^
           9002000    0x80000ed4 addi a3, a3, -30               #; a3  = 30, (wrb) a3  <-- 0
           9003000    0x80000ed8 snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
#; .LBB0_3 (xpulp_vect.c:1213:17)
#;   if (result_rd != 30) errs++;
#;       ^
           9004000    0x80000edc add a2, a2, a3                 #; a2  = 0, a3  = 0, (wrb) a2  <-- 0
#; .LBB0_3 (xpulp_vect.c:1220:13)
#;   asm volatile("pv.dotup.sci.b a3, a4, 2\n"
#;   ^
           9005000    0x80000ee0 mv a4, a0                      #; a0  = 0x05060708, (wrb) a4  <-- 0x05060708
           9006000    0x80000ee4 .text                          #; a4  = 0x05060708
           9008000                                              #; (acc) a3  <-- 52
#; .LBB0_3 (xpulp_vect.c:1225:27)
#;   if (result_rd != 52) errs++;
#;                 ^
           9009000    0x80000ee8 addi a3, a3, -52               #; a3  = 52, (wrb) a3  <-- 0
           9010000    0x80000eec snez a3, a3                    #; a3  = 0, (wrb) a3  <-- 0
           9011000    0x80000ef0 addi a4, s4, 2                 #; s4  = 0xfffe0000, (wrb) a4  <-- 0xfffe0002
#; .LBB0_3 (xpulp_vect.c:1225:17)
#;   if (result_rd != 52) errs++;
#;       ^
           9012000    0x80000ef4 add a2, a2, a3                 #; a2  = 0, a3  = 0, (wrb) a2  <-- 0
#; .LBB0_3 (xpulp_vect.c:1234:13)
#;   asm volatile("pv.dotusp.h a3, a4, a5\n"
#;   ^
           9013000    0x80000ef8 mv a5, a1                      #; a1  = 0x00030004, (wrb) a5  <-- 0x00030004
           9014000    0x80000efc .text                          #; a4  = 0xfffe0002, a5  = 0x00030004
           9016000                                              #; (acc) a3  <-- 0x00030002
#; .LBB0_3 (xpulp_vect.c:1239:27)
#;   if (result_rd != 2) errs++;
#;                 ^
           9025000    0x80000f00 addi a1, a3, -2                #; a3  = 0x00030002, (wrb) a1  <-- 0x00030000
           9026000    0x80000f04 snez a1, a1                    #; a1  = 0x00030000, (wrb) a1  <-- 1
#; .LBB0_3 (xpulp_vect.c:1239:17)
#;   if (result_rd != 2) errs++;
#;       ^
           9027000    0x80000f08 add a1, a2, a1                 #; a2  = 0, a1  = 1, (wrb) a1  <-- 1
#; .LBB0_3 (xpulp_vect.c:1247:13)
#;   asm volatile("pv.dotusp.sc.h a3, a4, a5\n"
#;   ^
           9028000    0x80000f0c li a5, 2                       #; (wrb) a5  <-- 2
           9029000    0x80000f10 mv a4, t1                      #; t1  = 0xfffe0003, (wrb) a4  <-- 0xfffe0003
           9030000    0x80000f14 .text                          #; a4  = 0xfffe0003, a5  = 2
           9032000                                              #; (acc) a3  <-- 0x00020002
#; .LBB0_3 (xpulp_vect.c:1252:27)
#;   if (result_rd != 2) errs++;
#;                 ^
           9033000    0x80000f18 addi a2, a3, -2                #; a3  = 0x00020002, (wrb) a2  <-- 0x00020000
           9034000    0x80000f1c snez a2, a2                    #; a2  = 0x00020000, (wrb) a2  <-- 1
           9035000    0x80000f20 addi a4, s1, -2                #; s1  = 0x00040000, (wrb) a4  <-- 0x0003fffe
#; .LBB0_3 (xpulp_vect.c:1252:17)
#;   if (result_rd != 2) errs++;
#;       ^
           9036000    0x80000f24 add a1, a1, a2                 #; a1  = 1, a2  = 1, (wrb) a1  <-- 2
#; .LBB0_3 (xpulp_vect.c:1259:13)
#;   asm volatile("pv.dotusp.sci.h a3, a4, 3\n"
#;   ^
           9037000    0x80000f28 .text                          #; a4  = 0x0003fffe
           9039000                                              #; (acc) a3  <-- 0x00030003
#; .LBB0_3 (xpulp_vect.c:1264:27)
#;   if (result_rd != 3) errs++;
#;                 ^
           9040000    0x80000f2c addi a2, a3, -3                #; a3  = 0x00030003, (wrb) a2  <-- 0x00030000
           9041000    0x80000f30 snez a2, a2                    #; a2  = 0x00030000, (wrb) a2  <-- 1
#; .LBB0_3 (xpulp_vect.c:1264:17)
#;   if (result_rd != 3) errs++;
#;       ^
           9042000    0x80000f34 add a1, a1, a2                 #; a1  = 2, a2  = 1, (wrb) a1  <-- 3
#; .LBB0_3 (xpulp_vect.c:1272:13)
#;   asm volatile("pv.dotusp.b a3, a4, a5\n"
#;   ^
           9043000    0x80000f38 mv a4, t0                      #; t0  = 0x01ff0203, (wrb) a4  <-- 0x01ff0203
           9044000    0x80000f3c mv a5, a0                      #; a0  = 0x05060708, (wrb) a5  <-- 0x05060708
           9055000    0x80000f40 .text                          #; a4  = 0x01ff0203, a5  = 0x05060708
           9057000                                              #; (acc) a3  <-- 1573
#; .LBB0_3 (xpulp_vect.c:1277:27)
#;   if (result_rd != 37) errs++;
#;                 ^
           9058000    0x80000f44 addi a0, a3, -37               #; a3  = 1573, (wrb) a0  <-- 1536
           9059000    0x80000f48 snez a0, a0                    #; a0  = 1536, (wrb) a0  <-- 1
#; .LBB0_3 (xpulp_vect.c:1277:17)
#;   if (result_rd != 37) errs++;
#;       ^
           9060000    0x80000f4c add a0, a1, a0                 #; a1  = 3, a0  = 1, (wrb) a0  <-- 4
#; .LBB0_3 (xpulp_vect.c:1285:13)
#;   asm volatile("pv.dotusp.sc.b a3, a4, a5\n"
#;   ^
           9061000    0x80000f50 li a5, 3                       #; (wrb) a5  <-- 3
           9062000    0x80000f54 mv a4, t2                      #; t2  = 0x010203fd, (wrb) a4  <-- 0x010203fd
           9063000    0x80000f58 .text                          #; a4  = 0x010203fd, a5  = 3
           9065000                                              #; (acc) a3  <-- 777
#; .LBB0_3 (xpulp_vect.c:1290:27)
#;   if (result_rd != 9) errs++;
#;                 ^
           9066000    0x80000f5c addi a1, a3, -9                #; a3  = 777, (wrb) a1  <-- 768
           9067000    0x80000f60 snez a1, a1                    #; a1  = 768, (wrb) a1  <-- 1
#; .LBB0_3 (xpulp_vect.c:1290:17)
#;   if (result_rd != 9) errs++;
#;       ^
           9068000    0x80000f64 add a0, a0, a1                 #; a0  = 4, a1  = 1, (wrb) a0  <-- 5
#; .LBB0_3 (xpulp_vect.c:1297:13)
#;   asm volatile("pv.dotusp.sci.b a3, a4, 4\n"
#;   ^
           9069000    0x80000f68 mv a4, t0                      #; t0  = 0x01ff0203, (wrb) a4  <-- 0x01ff0203
           9070000    0x80000f6c .text                          #; a4  = 0x01ff0203
           9072000                                              #; (acc) a3  <-- 1044
#; .LBB0_3 (xpulp_vect.c:1302:27)
#;   if (result_rd != 20) errs++;
#;                 ^
           9073000    0x80000f70 addi a1, a3, -20               #; a3  = 1044, (wrb) a1  <-- 1024
           9074000    0x80000f74 snez a1, a1                    #; a1  = 1024, (wrb) a1  <-- 1
#; .LBB0_3 (xpulp_vect.c:1302:17)
#;   if (result_rd != 20) errs++;
#;       ^
           9075000    0x80000f78 add a0, a0, a1                 #; a0  = 5, a1  = 1, (wrb) a0  <-- 6
           9076000    0x80000f7c j 8                            #; goto 0x80000f84
#; .LBB0_5 (xpulp_vect.c:1310:1)
#;   }
#;   ^
           9079000    0x80000f84 lw s0, 44(sp)                  #; sp  = 0x1001f708, s0  <~~ Word[0x1001f734]
           9080000    0x80000f88 lw s1, 40(sp)                  #; sp  = 0x1001f708, s1  <~~ Word[0x1001f730]
           9081000    0x80000f8c lw s2, 36(sp)                  #; sp  = 0x1001f708, s2  <~~ Word[0x1001f72c]
           9082000    0x80000f90 lw s3, 32(sp)                  #; sp  = 0x1001f708, s3  <~~ Word[0x1001f728], (lsu) s0  <-- 0x1001f778
           9083000    0x80000f94 lw s4, 28(sp)                  #; sp  = 0x1001f708, s4  <~~ Word[0x1001f724], (lsu) s1  <-- 2064
           9084000    0x80000f98 lw s5, 24(sp)                  #; sp  = 0x1001f708, s5  <~~ Word[0x1001f720], (lsu) s2  <-- 2
           9085000    0x80000f9c lw s6, 20(sp)                  #; sp  = 0x1001f708, s6  <~~ Word[0x1001f71c], (lsu) s3  <-- 0
           9086000    0x80000fa0 lw s7, 16(sp)                  #; sp  = 0x1001f708, s7  <~~ Word[0x1001f718], (lsu) s4  <-- 0
           9087000    0x80000fa4 lw s8, 12(sp)                  #; sp  = 0x1001f708, s8  <~~ Word[0x1001f714], (lsu) s5  <-- 2
           9088000    0x80000fa8 addi sp, sp, 48                #; sp  = 0x1001f708, (wrb) sp  <-- 0x1001f738
           9089000    0x80000fac ret                            #; ra  = 0x80004164, (lsu) s6  <-- 0x80005d98, goto 0x80004164
           9090000                                              #; (lsu) s7  <-- 0x80005d98
           9091000                                              #; (lsu) s8  <-- 0x80005db8
#; .LBB25_16 (start.c:268:5)
#;   snrt_cluster_hw_barrier (sync.h:174:5)
#;     asm volatile("csrr x0, 0x7C2" ::: "memory");
#;     ^
           9092000    0x80004164 csrr zero, 1986                #; csr@7c2 = 0
#; .LBB25_16 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:293:34)
#;         cls (cls.h:9:30)
#;           inline cls_t* cls() { return _cls_ptr; }
#;                                        ^
           9094000    0x80004168 lw a1, 64(s0)                  #; s0  = 0x1001f778, a1  <~~ Word[0x1001f7b8]
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
           9099000    0x80004170 amoadd.w a0, a0, (a2)          #; a2  = 0x1001ffe4, a0  = 6, a0  <~~ Word[0x1001ffe4]
           9111000                                              #; (lsu) a0  <-- 0
#; .LBB25_16 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:297:5)
#;         snrt_wait_writeback (sync.h:404:5)
#;           asm volatile("mv %0, %0" : "+r"(val)::);
#;           ^
           9112000    0x80004174 mv a0, a0                      #; a0  = 0, (wrb) a0  <-- 0
#; .LBB25_16 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:298:5)
#;         snrt_cluster_hw_barrier (sync.h:174:5)
#;           asm volatile("csrr x0, 0x7C2" ::: "memory");
#;           ^
           9113000    0x80004178 csrr zero, 1986                #; csr@7c2 = 0
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
           9183000    0x800041d0 lw ra, 60(sp)                  #; sp  = 0x1001f738, ra  <~~ Word[0x1001f774]
           9184000    0x800041d4 lw s0, 56(sp)                  #; sp  = 0x1001f738, s0  <~~ Word[0x1001f770]
           9185000    0x800041d8 lw s1, 52(sp)                  #; sp  = 0x1001f738, s1  <~~ Word[0x1001f76c]
           9186000    0x800041dc lw s2, 48(sp)                  #; sp  = 0x1001f738, s2  <~~ Word[0x1001f768], (lsu) ra  <-- 0x800001c4
           9187000    0x800041e0 lw s3, 44(sp)                  #; sp  = 0x1001f738, s3  <~~ Word[0x1001f764], (lsu) s0  <-- 0
           9188000    0x800041e4 lw s4, 40(sp)                  #; sp  = 0x1001f738, s4  <~~ Word[0x1001f760], (lsu) s1  <-- 0
           9189000    0x800041e8 lw s5, 36(sp)                  #; sp  = 0x1001f738, s5  <~~ Word[0x1001f75c], (lsu) s2  <-- 0
           9190000    0x800041ec lw s6, 32(sp)                  #; sp  = 0x1001f738, s6  <~~ Word[0x1001f758], (lsu) s3  <-- 0
           9191000    0x800041f0 lw s7, 28(sp)                  #; sp  = 0x1001f738, s7  <~~ Word[0x1001f754], (lsu) s4  <-- 0
           9192000    0x800041f4 lw s8, 24(sp)                  #; sp  = 0x1001f738, s8  <~~ Word[0x1001f750], (lsu) s5  <-- 0
           9193000    0x800041f8 lw s9, 20(sp)                  #; sp  = 0x1001f738, s9  <~~ Word[0x1001f74c], (lsu) s6  <-- 0
           9194000    0x800041fc lw s10, 16(sp)                 #; sp  = 0x1001f738, s10 <~~ Word[0x1001f748], (lsu) s7  <-- 0
           9195000                                              #; (lsu) s8  <-- 0
           9196000                                              #; (lsu) s9  <-- 0
           9197000                                              #; (lsu) s10 <-- 0
           9205000    0x80004200 lw s11, 12(sp)                 #; sp  = 0x1001f738, s11 <~~ Word[0x1001f744]
           9206000    0x80004204 addi sp, sp, 64                #; sp  = 0x1001f738, (wrb) sp  <-- 0x1001f778
           9207000    0x80004208 ret                            #; ra  = 0x800001c4, goto 0x800001c4
           9208000                                              #; (lsu) s11 <-- 0
#; .Ltmp2 (start.S:183)
#;   wfi
           9219000    0x800001c4 wfi                            #; 

## Performance metrics

Performance metrics for section 0 @ (10, 9217):
tstart                                          12
snitch_loads                                    92
snitch_stores                                  351
tend                                          9219
fpss_loads                                       0
snitch_avg_load_latency                      10.58
snitch_occupancy                            0.2513
snitch_fseq_rel_offloads                   0.01364
fseq_yield                                     1.0
fseq_fpu_yield                                 1.0
fpss_section_latency                             0
fpss_avg_fpu_latency                           2.0
fpss_avg_load_latency                            0
fpss_occupancy                            0.003475
fpss_fpu_occupancy                        0.003475
fpss_fpu_rel_occupancy                         1.0
cycles                                        9208
total_ipc                                   0.2548
