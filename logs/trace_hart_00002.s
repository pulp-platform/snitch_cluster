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
            492000    0x800000fc addi gp, gp, 1520              #; gp  = 0x800060f8, (wrb) gp  <-- 0x800066e8
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
            509000    0x80000134 addi t0, t0, -600              #; t0  = 0x80006130, (wrb) t0  <-- 0x80005ed8
#; .Lpcrel_hi1 (start.S:122)
#;   la        t1, __cdata_start
            510000    0x80000138 auipc t1, 6                    #; (wrb) t1  <-- 0x80006138
            511000    0x8000013c addi t1, t1, -608              #; t1  = 0x80006138, (wrb) t1  <-- 0x80005ed8
#; .Lpcrel_hi1 (start.S:123)
#;   sub       t0, t0, t1
            512000    0x80000140 sub t0, t0, t1                 #; t0  = 0x80005ed8, t1  = 0x80005ed8, (wrb) t0  <-- 0
#; .Lpcrel_hi1 (start.S:124)
#;   sub       a2, a2, t0
            513000    0x80000144 sub a2, a2, t0                 #; a2  = 0x10020000, t0  = 0, (wrb) a2  <-- 0x10020000
#; .Lpcrel_hi2 (start.S:125)
#;   la        t0, __cbss_end
            514000    0x80000148 auipc t0, 6                    #; (wrb) t0  <-- 0x80006148
            515000    0x8000014c addi t0, t0, -592              #; t0  = 0x80006148, (wrb) t0  <-- 0x80005ef8
#; .Lpcrel_hi3 (start.S:126)
#;   la        t1, __cbss_start
            516000    0x80000150 auipc t1, 6                    #; (wrb) t1  <-- 0x80006150
            517000    0x80000154 addi t1, t1, -632              #; t1  = 0x80006150, (wrb) t1  <-- 0x80005ed8
#; .Lpcrel_hi3 (start.S:127)
#;   sub       t0, t0, t1
            518000    0x80000158 sub t0, t0, t1                 #; t0  = 0x80005ef8, t1  = 0x80005ed8, (wrb) t0  <-- 32
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
            529000    0x80000184 addi t0, t0, -748              #; t0  = 0x80006180, (wrb) t0  <-- 0x80005e94
#; .Lpcrel_hi5 (start.S:156)
#;   la        t1, __tdata_start
            530000    0x80000188 auipc t1, 6                    #; (wrb) t1  <-- 0x80006188
            531000    0x8000018c addi t1, t1, -768              #; t1  = 0x80006188, (wrb) t1  <-- 0x80005e88
#; .Lpcrel_hi5 (start.S:157)
#;   sub       t0, t0, t1
            532000    0x80000190 sub t0, t0, t1                 #; t0  = 0x80005e94, t1  = 0x80005e88, (wrb) t0  <-- 12
#; .Lpcrel_hi5 (start.S:158)
#;   sub       sp, sp, t0
            533000    0x80000194 sub sp, sp, t0                 #; sp  = 0x1001f7c8, t0  = 12, (wrb) sp  <-- 0x1001f7bc
#; .Lpcrel_hi6 (start.S:159)
#;   la        t0, __tbss_end
            534000    0x80000198 auipc t0, 6                    #; (wrb) t0  <-- 0x80006198
            535000    0x8000019c addi t0, t0, -704              #; t0  = 0x80006198, (wrb) t0  <-- 0x80005ed8
#; .Lpcrel_hi7 (start.S:160)
#;   la        t1, __tbss_start
            536000    0x800001a0 auipc t1, 6                    #; (wrb) t1  <-- 0x800061a0
            537000    0x800001a4 addi t1, t1, -776              #; t1  = 0x800061a0, (wrb) t1  <-- 0x80005e98
#; .Lpcrel_hi7 (start.S:161)
#;   sub       t0, t0, t1
            538000    0x800001a8 sub t0, t0, t1                 #; t0  = 0x80005ed8, t1  = 0x80005e98, (wrb) t0  <-- 64
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
            544000    0x800001c0 jalr -1312(ra)                 #; ra  = 0x800041bc, (wrb) ra  <-- 0x800001c4, goto 0x80003c9c
#; snrt_main (start.c:204)
#;   EXTERN_C void snrt_main() {
            551000    0x80003c9c addi sp, sp, -64               #; sp  = 0x1001f778, (wrb) sp  <-- 0x1001f738
            552000    0x80003ca0 sw ra, 60(sp)                  #; sp  = 0x1001f738, 0x800001c4 ~~> Word[0x1001f774]
            553000    0x80003ca4 sw s0, 56(sp)                  #; sp  = 0x1001f738, 0 ~~> Word[0x1001f770]
            554000    0x80003ca8 sw s1, 52(sp)                  #; sp  = 0x1001f738, 0 ~~> Word[0x1001f76c]
            555000    0x80003cac sw s2, 48(sp)                  #; sp  = 0x1001f738, 0 ~~> Word[0x1001f768]
            556000    0x80003cb0 sw s3, 44(sp)                  #; sp  = 0x1001f738, 0 ~~> Word[0x1001f764]
            557000    0x80003cb4 sw s4, 40(sp)                  #; sp  = 0x1001f738, 0 ~~> Word[0x1001f760]
            559000    0x80003cb8 sw s5, 36(sp)                  #; sp  = 0x1001f738, 0 ~~> Word[0x1001f75c]
            561000    0x80003cbc sw s6, 32(sp)                  #; sp  = 0x1001f738, 0 ~~> Word[0x1001f758]
            563000    0x80003cc0 sw s7, 28(sp)                  #; sp  = 0x1001f738, 0 ~~> Word[0x1001f754]
            564000    0x80003cc4 sw s8, 24(sp)                  #; sp  = 0x1001f738, 0 ~~> Word[0x1001f750]
            565000    0x80003cc8 sw s9, 20(sp)                  #; sp  = 0x1001f738, 0 ~~> Word[0x1001f74c]
            566000    0x80003ccc sw s10, 16(sp)                 #; sp  = 0x1001f738, 0 ~~> Word[0x1001f748]
            567000    0x80003cd0 sw s11, 12(sp)                 #; sp  = 0x1001f738, 0 ~~> Word[0x1001f744]
            568000    0x80003cd4 li s0, -1                      #; (wrb) s0  <-- -1
#; snrt_main (start.c:206:9)
#;   snrt_cluster_idx (team.h:99:12)
#;     snrt_global_core_idx (team.h:80:12)
#;       snrt_hartid (team.h:25:5)
#;         asm("csrr %0, mhartid" : "=r"(hartid));
#;         ^
            569000    0x80003cd8 csrr s2, mhartid               #; mhartid = 2, (wrb) s2  <-- 2
            570000    0x80003cdc lui a0, 233017                 #; (wrb) a0  <-- 0x38e39000
            571000    0x80003ce0 addi a0, a0, -455              #; a0  = 0x38e39000, (wrb) a0  <-- 0x38e38e39
#; snrt_main (start.c:206:9)
#;   snrt_cluster_idx (team.h:99:35)
#;     return snrt_global_core_idx() / snrt_cluster_core_num();
#;                                   ^
            572000    0x80003ce4 mulhu a0, s2, a0               #; s2  = 2, a0  = 0x38e38e39
            574000                                              #; (acc) a0  <-- 0
            575000    0x80003ce8 srli a0, a0, 1                 #; a0  = 0, (wrb) a0  <-- 0
            576000    0x80003cec li a1, 8                       #; (wrb) a1  <-- 8
            577000    0x80003cf0 slli s3, a0, 18                #; a0  = 0, (wrb) s3  <-- 0
#; snrt_main (start.c:206:9)
#;   if (snrt_cluster_idx() == 0) {
#;       ^
            578000    0x80003cf4 bltu a1, s2, 184               #; a1  = 8, s2  = 2, not taken
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:31)
#;       snrt_cluster_core_idx (team.h:108:35)
#;         return snrt_global_core_idx() % snrt_cluster_core_num();
#;                                       ^
            579000    0x80003cf8 p.extbz s1, s2                 #; s2  = 2
            580000    0x80003cfc li a1, 57                      #; (wrb) a1  <-- 57
            581000                                              #; (acc) s1  <-- 2
            582000    0x80003d00 mul a1, s1, a1                 #; s1  = 2, a1  = 57
            584000                                              #; (acc) a1  <-- 114
            585000    0x80003d04 srli a1, a1, 9                 #; a1  = 114, (wrb) a1  <-- 0
            586000    0x80003d08 slli a2, a1, 3                 #; a1  = 0, (wrb) a2  <-- 0
            587000    0x80003d0c add a1, a2, a1                 #; a2  = 0, a1  = 0, (wrb) a1  <-- 0
            588000    0x80003d10 lui a2, 65569                  #; (wrb) a2  <-- 0x10021000
            589000    0x80003d14 addi a2, a2, 424               #; a2  = 0x10021000, (wrb) a2  <-- 0x100211a8
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:5)
#;       snrt_int_cluster_clr (cluster_interrupts.h:22:53)
#;         snrt_cluster()->peripheral_reg.cl_clint_clear.f.cl_clint_clear = mask;
#;                                                         ^
            590000    0x80003d18 add a2, s3, a2                 #; s3  = 0, a2  = 0x100211a8, (wrb) a2  <-- 0x100211a8
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:5)
#;       snrt_int_cluster_clr (cluster_interrupts.h:22:68)
#;         snrt_cluster()->peripheral_reg.cl_clint_clear.f.cl_clint_clear = mask;
#;                                                                        ^
            591000    0x80003d1c lw a3, 0(a2)                   #; a2  = 0x100211a8, a3  <~~ Word[0x100211a8]
            603000                                              #; (lsu) a3  <-- 0
            604000    0x80003d20 ori a3, a2, 4                  #; a2  = 0x100211a8, (wrb) a3  <-- 0x100211ac
            605000    0x80003d24 lw a4, 0(a3)                   #; a3  = 0x100211ac, a4  <~~ Word[0x100211ac]
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:31)
#;       snrt_cluster_core_idx (team.h:108:35)
#;         return snrt_global_core_idx() % snrt_cluster_core_num();
#;                                       ^
            606000    0x80003d28 sub a1, s2, a1                 #; s2  = 2, a1  = 0, (wrb) a1  <-- 2
            607000    0x80003d2c li a5, 1                       #; (wrb) a5  <-- 1
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:28)
#;       snrt_int_cluster_clr(1 << snrt_cluster_core_idx());
#;                              ^
            608000    0x80003d30 sll a1, a5, a1                 #; a5  = 1, a1  = 2, (wrb) a1  <-- 4
            629000                                              #; (lsu) a4  <-- 0
#; snrt_main (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;     snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:5)
#;       snrt_int_cluster_clr (cluster_interrupts.h:22:68)
#;         snrt_cluster()->peripheral_reg.cl_clint_clear.f.cl_clint_clear = mask;
#;                                                                        ^
            630000    0x80003d34 and a4, a4, s0                 #; a4  = 0, s0  = -1, (wrb) a4  <-- 0
            631000    0x80003d38 sw a4, 0(a3)                   #; a3  = 0x100211ac, 0 ~~> Word[0x100211ac]
            632000    0x80003d3c sw a1, 0(a2)                   #; a2  = 0x100211a8, 4 ~~> Word[0x100211a8]
            633000    0x80003d40 lui a1, 128                    #; (wrb) a1  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            634000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            635000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            636000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            637000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            638000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            639000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            640000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            641000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            642000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            643000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            644000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            645000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            646000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            647000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            648000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            649000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            650000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            651000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            652000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            653000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            654000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            655000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            656000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            657000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            658000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            659000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            660000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            661000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            662000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            663000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            664000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            665000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            666000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            667000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            668000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            669000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            670000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            671000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            672000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            673000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            674000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            675000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            676000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            677000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            678000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            679000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            680000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            681000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            682000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            683000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            684000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            685000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            686000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            687000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            688000    0x80003d44 csrr a2, mip                   #; mip = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            689000    0x80003d48 and a2, a2, a1                 #; a2  = 0x00080000, a1  = 0x00080000, (wrb) a2  <-- 0x00080000
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            690000    0x80003d4c bnez a2, -8                    #; a2  = 0x00080000, taken, goto 0x80003d44
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;       while (read_csr(mip) & MIP_MCIP)
#;              ^
            691000    0x80003d44 csrr a2, mip                   #; mip = 0, (wrb) a2  <-- 0
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;       while (read_csr(mip) & MIP_MCIP)
#;                            ^
            692000    0x80003d48 and a2, a2, a1                 #; a2  = 0, a1  = 0x00080000, (wrb) a2  <-- 0
#; .LBB25_2 (start.c:207:9)
#;   snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;     snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;       while (read_csr(mip) & MIP_MCIP)
#;       ^
            693000    0x80003d4c bnez a2, -8                    #; a2  = 0, not taken
            694000    0x80003d50 li a1, 9                       #; (wrb) a1  <-- 9
#; .LBB25_2 (start.c:215:5)
#;   snrt_init_bss (start.c:110:9)
#;     if (snrt_cluster_idx() == 0) {
#;         ^
            695000    0x80003d54 bgeu s2, a1, 88                #; s2  = 2, a1  = 9, not taken
#; .LBB25_21 (start.c:215:5)
#;   snrt_init_bss (start.c:112:9)
#;     memset((void*)&__bss_start, 0, size);
#;     ^
            696000    0x80003d58 auipc a0, 2                    #; (wrb) a0  <-- 0x80005d58
            697000    0x80003d5c addi a0, a0, 592               #; a0  = 0x80005d58, (wrb) a0  <-- 0x80005fa8
#; .LBB25_22 (start.c:215:5)
#;   snrt_init_bss (start.c:112:9)
#;     memset((void*)&__bss_start, 0, size);
#;     ^
            698000    0x80003d60 auipc a1, 2                    #; (wrb) a1  <-- 0x80005d60
            699000    0x80003d64 addi a1, a1, 1408              #; a1  = 0x80005d60, (wrb) a1  <-- 0x800062e0
            700000    0x80003d68 sub a2, a1, a0                 #; a1  = 0x800062e0, a0  = 0x80005fa8, (wrb) a2  <-- 824
            701000    0x80003d6c li a1, 0                       #; (wrb) a1  <-- 0
            702000    0x80003d70 auipc ra, 0                    #; (wrb) ra  <-- 0x80003d70
            703000    0x80003d74 jalr 1220(ra)                  #; ra  = 0x80003d70, (wrb) ra  <-- 0x80003d78, goto 0x80004234
#; memset (memset.S:30)
#;   li t1, 15
            708000    0x80004234 li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
            709000    0x80004238 mv a4, a0                      #; a0  = 0x80005fa8, (wrb) a4  <-- 0x80005fa8
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
            710000    0x8000423c bgeu t1, a2, 60                #; t1  = 15, a2  = 824, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
            713000    0x80004240 andi a5, a4, 15                #; a4  = 0x80005fa8, (wrb) a5  <-- 8
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
            714000    0x80004244 bnez a5, 160                   #; a5  = 8, taken, goto 0x800042e4
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
            773000    0x800042b0 sb a1, 5(a4)                   #; a4  = 0x80005fa8, 0 ~~> Byte[0x80005fad]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
            822000    0x800042b4 sb a1, 4(a4)                   #; a4  = 0x80005fa8, 0 ~~> Byte[0x80005fac]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
            863000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x80005fa8, 0 ~~> Byte[0x80005fab]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
            912000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x80005fa8, 0 ~~> Byte[0x80005faa]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
            953000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x80005fa8, 0 ~~> Byte[0x80005fa9]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
           1002000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x80005fa8, 0 ~~> Byte[0x80005fa8]
#; .Ltable (memset.S:85)
#;   ret
           1003000    0x800042c8 ret                            #; ra  = 0x800042f8, goto 0x800042f8
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
           1004000    0x800042f8 mv ra, t0                      #; t0  = 0x80003d78, (wrb) ra  <-- 0x80003d78
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
           1005000    0x800042fc addi a5, a5, -16               #; a5  = 8, (wrb) a5  <-- -8
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
           1006000    0x80004300 sub a4, a4, a5                 #; a4  = 0x80005fa8, a5  = -8, (wrb) a4  <-- 0x80005fb0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
           1007000    0x80004304 add a2, a2, a5                 #; a2  = 824, a5  = -8, (wrb) a2  <-- 816
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
           1008000    0x80004308 bgeu t1, a2, -144              #; t1  = 15, a2  = 816, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
           1009000    0x8000430c j -196                         #; goto 0x80004248
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
           1010000    0x80004248 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
           1011000    0x8000424c andi a3, a2, -16               #; a2  = 816, (wrb) a3  <-- 816
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
           1012000    0x80004250 andi a2, a2, 15                #; a2  = 816, (wrb) a2  <-- 0
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
           1013000    0x80004254 add a3, a3, a4                 #; a3  = 816, a4  = 0x80005fb0, (wrb) a3  <-- 0x800062e0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           1043000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80005fb0, 0 ~~> Word[0x80005fb0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           1092000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80005fb0, 0 ~~> Word[0x80005fb4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           1133000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80005fb0, 0 ~~> Word[0x80005fb8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           1182000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80005fb0, 0 ~~> Word[0x80005fbc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           1183000    0x80004268 addi a4, a4, 16                #; a4  = 0x80005fb0, (wrb) a4  <-- 0x80005fc0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           1184000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80005fc0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           1223000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80005fc0, 0 ~~> Word[0x80005fc0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           1272000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80005fc0, 0 ~~> Word[0x80005fc4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           1313000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80005fc0, 0 ~~> Word[0x80005fc8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           1362000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80005fc0, 0 ~~> Word[0x80005fcc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           1363000    0x80004268 addi a4, a4, 16                #; a4  = 0x80005fc0, (wrb) a4  <-- 0x80005fd0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           1364000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80005fd0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           1403000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80005fd0, 0 ~~> Word[0x80005fd0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           1452000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80005fd0, 0 ~~> Word[0x80005fd4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           1493000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80005fd0, 0 ~~> Word[0x80005fd8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           1542000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80005fd0, 0 ~~> Word[0x80005fdc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           1543000    0x80004268 addi a4, a4, 16                #; a4  = 0x80005fd0, (wrb) a4  <-- 0x80005fe0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           1544000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80005fe0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           1583000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80005fe0, 0 ~~> Word[0x80005fe0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           1632000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80005fe0, 0 ~~> Word[0x80005fe4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           1673000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80005fe0, 0 ~~> Word[0x80005fe8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           1722000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80005fe0, 0 ~~> Word[0x80005fec]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           1723000    0x80004268 addi a4, a4, 16                #; a4  = 0x80005fe0, (wrb) a4  <-- 0x80005ff0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           1724000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80005ff0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           1763000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80005ff0, 0 ~~> Word[0x80005ff0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           1812000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80005ff0, 0 ~~> Word[0x80005ff4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           1853000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80005ff0, 0 ~~> Word[0x80005ff8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           1902000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80005ff0, 0 ~~> Word[0x80005ffc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           1903000    0x80004268 addi a4, a4, 16                #; a4  = 0x80005ff0, (wrb) a4  <-- 0x80006000
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           1904000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006000, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           1943000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006000, 0 ~~> Word[0x80006000]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           1992000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006000, 0 ~~> Word[0x80006004]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2033000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006000, 0 ~~> Word[0x80006008]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2082000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006000, 0 ~~> Word[0x8000600c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2083000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006000, (wrb) a4  <-- 0x80006010
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2084000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006010, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2123000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006010, 0 ~~> Word[0x80006010]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2172000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006010, 0 ~~> Word[0x80006014]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2213000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006010, 0 ~~> Word[0x80006018]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2262000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006010, 0 ~~> Word[0x8000601c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2263000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006010, (wrb) a4  <-- 0x80006020
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2264000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006020, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2303000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006020, 0 ~~> Word[0x80006020]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2352000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006020, 0 ~~> Word[0x80006024]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2393000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006020, 0 ~~> Word[0x80006028]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2442000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006020, 0 ~~> Word[0x8000602c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2443000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006020, (wrb) a4  <-- 0x80006030
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2444000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006030, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2483000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006030, 0 ~~> Word[0x80006030]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2532000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006030, 0 ~~> Word[0x80006034]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2573000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006030, 0 ~~> Word[0x80006038]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2622000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006030, 0 ~~> Word[0x8000603c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2623000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006030, (wrb) a4  <-- 0x80006040
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2624000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006040, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2663000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006040, 0 ~~> Word[0x80006040]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2712000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006040, 0 ~~> Word[0x80006044]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2753000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006040, 0 ~~> Word[0x80006048]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2802000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006040, 0 ~~> Word[0x8000604c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2803000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006040, (wrb) a4  <-- 0x80006050
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2804000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006050, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           2843000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006050, 0 ~~> Word[0x80006050]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           2892000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006050, 0 ~~> Word[0x80006054]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           2933000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006050, 0 ~~> Word[0x80006058]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           2982000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006050, 0 ~~> Word[0x8000605c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           2983000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006050, (wrb) a4  <-- 0x80006060
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           2984000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006060, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           3023000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006060, 0 ~~> Word[0x80006060]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           3072000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006060, 0 ~~> Word[0x80006064]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           3113000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006060, 0 ~~> Word[0x80006068]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           3162000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006060, 0 ~~> Word[0x8000606c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           3163000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006060, (wrb) a4  <-- 0x80006070
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           3164000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006070, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           3203000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006070, 0 ~~> Word[0x80006070]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           3252000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006070, 0 ~~> Word[0x80006074]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           3293000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006070, 0 ~~> Word[0x80006078]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           3342000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006070, 0 ~~> Word[0x8000607c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           3343000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006070, (wrb) a4  <-- 0x80006080
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           3344000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006080, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           3383000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006080, 0 ~~> Word[0x80006080]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           3432000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006080, 0 ~~> Word[0x80006084]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           3473000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006080, 0 ~~> Word[0x80006088]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           3522000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006080, 0 ~~> Word[0x8000608c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           3523000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006080, (wrb) a4  <-- 0x80006090
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           3524000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006090, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           3563000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006090, 0 ~~> Word[0x80006090]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           3612000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006090, 0 ~~> Word[0x80006094]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           3653000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006090, 0 ~~> Word[0x80006098]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           3702000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006090, 0 ~~> Word[0x8000609c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           3703000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006090, (wrb) a4  <-- 0x800060a0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           3704000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800060a0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           3743000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800060a0, 0 ~~> Word[0x800060a0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           3792000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800060a0, 0 ~~> Word[0x800060a4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           3833000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800060a0, 0 ~~> Word[0x800060a8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           3882000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800060a0, 0 ~~> Word[0x800060ac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           3883000    0x80004268 addi a4, a4, 16                #; a4  = 0x800060a0, (wrb) a4  <-- 0x800060b0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           3884000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800060b0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           3923000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800060b0, 0 ~~> Word[0x800060b0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           3972000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800060b0, 0 ~~> Word[0x800060b4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           4013000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800060b0, 0 ~~> Word[0x800060b8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           4062000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800060b0, 0 ~~> Word[0x800060bc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           4063000    0x80004268 addi a4, a4, 16                #; a4  = 0x800060b0, (wrb) a4  <-- 0x800060c0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           4064000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800060c0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           4103000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800060c0, 0 ~~> Word[0x800060c0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           4152000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800060c0, 0 ~~> Word[0x800060c4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           4193000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800060c0, 0 ~~> Word[0x800060c8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           4242000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800060c0, 0 ~~> Word[0x800060cc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           4243000    0x80004268 addi a4, a4, 16                #; a4  = 0x800060c0, (wrb) a4  <-- 0x800060d0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           4244000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800060d0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           4283000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800060d0, 0 ~~> Word[0x800060d0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           4332000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800060d0, 0 ~~> Word[0x800060d4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           4373000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800060d0, 0 ~~> Word[0x800060d8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           4422000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800060d0, 0 ~~> Word[0x800060dc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           4423000    0x80004268 addi a4, a4, 16                #; a4  = 0x800060d0, (wrb) a4  <-- 0x800060e0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           4424000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800060e0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           4463000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800060e0, 0 ~~> Word[0x800060e0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           4512000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800060e0, 0 ~~> Word[0x800060e4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           4553000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800060e0, 0 ~~> Word[0x800060e8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           4602000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800060e0, 0 ~~> Word[0x800060ec]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           4603000    0x80004268 addi a4, a4, 16                #; a4  = 0x800060e0, (wrb) a4  <-- 0x800060f0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           4604000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800060f0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           4643000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800060f0, 0 ~~> Word[0x800060f0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           4692000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800060f0, 0 ~~> Word[0x800060f4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           4733000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800060f0, 0 ~~> Word[0x800060f8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           4782000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800060f0, 0 ~~> Word[0x800060fc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           4783000    0x80004268 addi a4, a4, 16                #; a4  = 0x800060f0, (wrb) a4  <-- 0x80006100
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           4784000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006100, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           4823000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006100, 0 ~~> Word[0x80006100]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           4872000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006100, 0 ~~> Word[0x80006104]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           4913000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006100, 0 ~~> Word[0x80006108]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           4962000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006100, 0 ~~> Word[0x8000610c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           4963000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006100, (wrb) a4  <-- 0x80006110
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           4964000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006110, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           5003000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006110, 0 ~~> Word[0x80006110]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           5052000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006110, 0 ~~> Word[0x80006114]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           5093000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006110, 0 ~~> Word[0x80006118]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           5142000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006110, 0 ~~> Word[0x8000611c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           5143000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006110, (wrb) a4  <-- 0x80006120
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           5144000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006120, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           5183000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006120, 0 ~~> Word[0x80006120]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           5232000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006120, 0 ~~> Word[0x80006124]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           5273000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006120, 0 ~~> Word[0x80006128]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           5322000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006120, 0 ~~> Word[0x8000612c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           5323000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006120, (wrb) a4  <-- 0x80006130
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           5324000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006130, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           5363000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006130, 0 ~~> Word[0x80006130]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           5412000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006130, 0 ~~> Word[0x80006134]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           5453000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006130, 0 ~~> Word[0x80006138]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           5502000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006130, 0 ~~> Word[0x8000613c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           5503000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006130, (wrb) a4  <-- 0x80006140
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           5504000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006140, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           5543000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006140, 0 ~~> Word[0x80006140]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           5592000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006140, 0 ~~> Word[0x80006144]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           5633000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006140, 0 ~~> Word[0x80006148]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           5682000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006140, 0 ~~> Word[0x8000614c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           5683000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006140, (wrb) a4  <-- 0x80006150
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           5684000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006150, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           5723000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006150, 0 ~~> Word[0x80006150]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           5772000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006150, 0 ~~> Word[0x80006154]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           5813000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006150, 0 ~~> Word[0x80006158]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           5862000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006150, 0 ~~> Word[0x8000615c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           5863000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006150, (wrb) a4  <-- 0x80006160
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           5864000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006160, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           5903000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006160, 0 ~~> Word[0x80006160]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           5952000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006160, 0 ~~> Word[0x80006164]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           5993000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006160, 0 ~~> Word[0x80006168]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6042000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006160, 0 ~~> Word[0x8000616c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6043000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006160, (wrb) a4  <-- 0x80006170
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6044000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006170, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6083000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006170, 0 ~~> Word[0x80006170]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           6132000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006170, 0 ~~> Word[0x80006174]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           6173000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006170, 0 ~~> Word[0x80006178]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6222000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006170, 0 ~~> Word[0x8000617c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6223000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006170, (wrb) a4  <-- 0x80006180
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6224000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006180, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6263000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006180, 0 ~~> Word[0x80006180]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           6312000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006180, 0 ~~> Word[0x80006184]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           6353000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006180, 0 ~~> Word[0x80006188]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6402000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006180, 0 ~~> Word[0x8000618c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6403000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006180, (wrb) a4  <-- 0x80006190
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6404000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006190, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6443000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006190, 0 ~~> Word[0x80006190]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           6492000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006190, 0 ~~> Word[0x80006194]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           6533000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006190, 0 ~~> Word[0x80006198]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6582000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006190, 0 ~~> Word[0x8000619c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6583000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006190, (wrb) a4  <-- 0x800061a0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6584000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800061a0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6623000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800061a0, 0 ~~> Word[0x800061a0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           6672000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800061a0, 0 ~~> Word[0x800061a4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           6713000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800061a0, 0 ~~> Word[0x800061a8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6762000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800061a0, 0 ~~> Word[0x800061ac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6763000    0x80004268 addi a4, a4, 16                #; a4  = 0x800061a0, (wrb) a4  <-- 0x800061b0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6764000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800061b0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6803000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800061b0, 0 ~~> Word[0x800061b0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           6852000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800061b0, 0 ~~> Word[0x800061b4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           6893000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800061b0, 0 ~~> Word[0x800061b8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           6942000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800061b0, 0 ~~> Word[0x800061bc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           6943000    0x80004268 addi a4, a4, 16                #; a4  = 0x800061b0, (wrb) a4  <-- 0x800061c0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           6944000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800061c0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           6983000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800061c0, 0 ~~> Word[0x800061c0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           7032000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800061c0, 0 ~~> Word[0x800061c4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           7073000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800061c0, 0 ~~> Word[0x800061c8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           7122000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800061c0, 0 ~~> Word[0x800061cc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           7123000    0x80004268 addi a4, a4, 16                #; a4  = 0x800061c0, (wrb) a4  <-- 0x800061d0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           7124000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800061d0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           7163000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800061d0, 0 ~~> Word[0x800061d0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           7212000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800061d0, 0 ~~> Word[0x800061d4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           7253000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800061d0, 0 ~~> Word[0x800061d8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           7302000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800061d0, 0 ~~> Word[0x800061dc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           7303000    0x80004268 addi a4, a4, 16                #; a4  = 0x800061d0, (wrb) a4  <-- 0x800061e0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           7304000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800061e0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           7343000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800061e0, 0 ~~> Word[0x800061e0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           7392000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800061e0, 0 ~~> Word[0x800061e4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           7433000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800061e0, 0 ~~> Word[0x800061e8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           7482000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800061e0, 0 ~~> Word[0x800061ec]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           7483000    0x80004268 addi a4, a4, 16                #; a4  = 0x800061e0, (wrb) a4  <-- 0x800061f0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           7484000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800061f0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           7523000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800061f0, 0 ~~> Word[0x800061f0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           7572000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800061f0, 0 ~~> Word[0x800061f4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           7613000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800061f0, 0 ~~> Word[0x800061f8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           7662000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800061f0, 0 ~~> Word[0x800061fc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           7663000    0x80004268 addi a4, a4, 16                #; a4  = 0x800061f0, (wrb) a4  <-- 0x80006200
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           7664000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006200, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           7703000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006200, 0 ~~> Word[0x80006200]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           7752000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006200, 0 ~~> Word[0x80006204]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           7793000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006200, 0 ~~> Word[0x80006208]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           7842000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006200, 0 ~~> Word[0x8000620c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           7843000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006200, (wrb) a4  <-- 0x80006210
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           7844000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006210, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           7883000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006210, 0 ~~> Word[0x80006210]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           7932000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006210, 0 ~~> Word[0x80006214]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           7973000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006210, 0 ~~> Word[0x80006218]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           8022000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006210, 0 ~~> Word[0x8000621c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           8023000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006210, (wrb) a4  <-- 0x80006220
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           8024000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006220, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           8063000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006220, 0 ~~> Word[0x80006220]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           8112000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006220, 0 ~~> Word[0x80006224]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           8153000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006220, 0 ~~> Word[0x80006228]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           8202000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006220, 0 ~~> Word[0x8000622c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           8203000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006220, (wrb) a4  <-- 0x80006230
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           8204000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006230, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           8243000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006230, 0 ~~> Word[0x80006230]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           8292000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006230, 0 ~~> Word[0x80006234]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           8333000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006230, 0 ~~> Word[0x80006238]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           8382000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006230, 0 ~~> Word[0x8000623c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           8383000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006230, (wrb) a4  <-- 0x80006240
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           8384000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006240, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           8423000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006240, 0 ~~> Word[0x80006240]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           8472000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006240, 0 ~~> Word[0x80006244]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           8513000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006240, 0 ~~> Word[0x80006248]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           8562000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006240, 0 ~~> Word[0x8000624c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           8563000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006240, (wrb) a4  <-- 0x80006250
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           8564000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006250, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           8603000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006250, 0 ~~> Word[0x80006250]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           8652000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006250, 0 ~~> Word[0x80006254]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           8693000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006250, 0 ~~> Word[0x80006258]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           8742000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006250, 0 ~~> Word[0x8000625c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           8743000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006250, (wrb) a4  <-- 0x80006260
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           8744000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006260, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           8783000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006260, 0 ~~> Word[0x80006260]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           8832000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006260, 0 ~~> Word[0x80006264]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           8873000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006260, 0 ~~> Word[0x80006268]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           8922000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006260, 0 ~~> Word[0x8000626c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           8923000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006260, (wrb) a4  <-- 0x80006270
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           8924000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006270, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           8963000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006270, 0 ~~> Word[0x80006270]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           9012000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006270, 0 ~~> Word[0x80006274]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           9053000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006270, 0 ~~> Word[0x80006278]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           9102000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006270, 0 ~~> Word[0x8000627c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           9103000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006270, (wrb) a4  <-- 0x80006280
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           9104000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006280, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           9143000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006280, 0 ~~> Word[0x80006280]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           9192000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006280, 0 ~~> Word[0x80006284]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           9233000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006280, 0 ~~> Word[0x80006288]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           9282000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006280, 0 ~~> Word[0x8000628c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           9283000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006280, (wrb) a4  <-- 0x80006290
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           9284000    0x8000426c bltu a4, a3, -20               #; a4  = 0x80006290, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           9323000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x80006290, 0 ~~> Word[0x80006290]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           9372000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x80006290, 0 ~~> Word[0x80006294]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           9413000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x80006290, 0 ~~> Word[0x80006298]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           9462000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x80006290, 0 ~~> Word[0x8000629c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           9463000    0x80004268 addi a4, a4, 16                #; a4  = 0x80006290, (wrb) a4  <-- 0x800062a0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           9464000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800062a0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           9503000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800062a0, 0 ~~> Word[0x800062a0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           9552000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800062a0, 0 ~~> Word[0x800062a4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           9593000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800062a0, 0 ~~> Word[0x800062a8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           9642000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800062a0, 0 ~~> Word[0x800062ac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           9643000    0x80004268 addi a4, a4, 16                #; a4  = 0x800062a0, (wrb) a4  <-- 0x800062b0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           9644000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800062b0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           9683000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800062b0, 0 ~~> Word[0x800062b0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           9732000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800062b0, 0 ~~> Word[0x800062b4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           9773000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800062b0, 0 ~~> Word[0x800062b8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
           9822000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800062b0, 0 ~~> Word[0x800062bc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
           9823000    0x80004268 addi a4, a4, 16                #; a4  = 0x800062b0, (wrb) a4  <-- 0x800062c0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
           9824000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800062c0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
           9863000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800062c0, 0 ~~> Word[0x800062c0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
           9912000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800062c0, 0 ~~> Word[0x800062c4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
           9953000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800062c0, 0 ~~> Word[0x800062c8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          10002000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800062c0, 0 ~~> Word[0x800062cc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          10003000    0x80004268 addi a4, a4, 16                #; a4  = 0x800062c0, (wrb) a4  <-- 0x800062d0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          10004000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800062d0, a3  = 0x800062e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          10043000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x800062d0, 0 ~~> Word[0x800062d0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          10092000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x800062d0, 0 ~~> Word[0x800062d4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          10133000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x800062d0, 0 ~~> Word[0x800062d8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          10182000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x800062d0, 0 ~~> Word[0x800062dc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          10183000    0x80004268 addi a4, a4, 16                #; a4  = 0x800062d0, (wrb) a4  <-- 0x800062e0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          10184000    0x8000426c bltu a4, a3, -20               #; a4  = 0x800062e0, a3  = 0x800062e0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
          10185000    0x80004270 bnez a2, 8                     #; a2  = 0, not taken
#; .Ltmp0 (memset.S:57)
#;   ret
          10186000    0x80004274 ret                            #; ra  = 0x80003d78, goto 0x80003d78
#; .LBB25_22 (start.c:215:5)
#;   snrt_init_bss (start.c:115:9)
#;     snrt_cluster_hw_barrier (sync.h:174:5)
#;       asm volatile("csrr x0, 0x7C2" ::: "memory");
#;       ^
          10187000    0x80003d78 csrr zero, 1986                #; csr@7c2 = 0
          10209000    0x80003d7c li a0, 57                      #; (wrb) a0  <-- 57
          10210000    0x80003d80 mul a0, s1, a0                 #; s1  = 2, a0  = 57
          10212000                                              #; (acc) a0  <-- 114
          10213000    0x80003d84 srli a0, a0, 9                 #; a0  = 114, (wrb) a0  <-- 0
          10214000    0x80003d88 slli a1, a0, 3                 #; a0  = 0, (wrb) a1  <-- 0
          10215000    0x80003d8c add a0, a1, a0                 #; a1  = 0, a0  = 0, (wrb) a0  <-- 0
          10216000    0x80003d90 sub a0, s2, a0                 #; s2  = 2, a0  = 0, (wrb) a0  <-- 2
          10217000    0x80003d94 p.extbz s5, a0                 #; a0  = 2
          10218000    0x80003d98 li s4, 0                       #; (wrb) s4  <-- 0
          10219000                                              #; (acc) s5  <-- 2
#; .LBB25_22 (start.c:219:5)
#;   snrt_wake_up (start.c:124:33)
#;     if (snrt_cluster_idx() == 0 && snrt_cluster_core_idx() == 0) {
#;                                 ^
          10220000    0x80003d9c bnez s5, 32                    #; s5  = 2, taken, goto 0x80003dbc
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
          10309000                                              #; (lsu) a1  <-- 0
          10310000    0x80003dd0 ori a1, a0, 4                  #; a0  = 0x100211a8, (wrb) a1  <-- 0x100211ac
          10311000    0x80003dd4 lw a2, 0(a1)                   #; a1  = 0x100211ac, a2  <~~ Word[0x100211ac]
          10312000    0x80003dd8 li a3, 1                       #; (wrb) a3  <-- 1
#; .LBB25_7 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;       snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:28)
#;         snrt_int_cluster_clr(1 << snrt_cluster_core_idx());
#;                                ^
          10313000    0x80003ddc sll a3, a3, s5                 #; a3  = 1, s5  = 2, (wrb) a3  <-- 4
          10335000                                              #; (lsu) a2  <-- 0
#; .LBB25_7 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:48:5)
#;       snrt_int_clr_mcip_unsafe (cluster_interrupts.h:33:5)
#;         snrt_int_cluster_clr (cluster_interrupts.h:22:68)
#;           snrt_cluster()->peripheral_reg.cl_clint_clear.f.cl_clint_clear = mask;
#;                                                                          ^
          10336000    0x80003de0 and a2, a2, s0                 #; a2  = 0, s0  = -1, (wrb) a2  <-- 0
          10337000    0x80003de4 sw a3, 0(a0)                   #; a0  = 0x100211a8, 4 ~~> Word[0x100211a8]
          10338000    0x80003de8 sw a2, 0(a1)                   #; a1  = 0x100211ac, 0 ~~> Word[0x100211ac]
          10339000    0x80003dec lui a0, 128                    #; (wrb) a0  <-- 0x00080000
#; .LBB25_8 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;       snrt_int_wait_mcip_clr (cluster_interrupts.h:40:12)
#;         while (read_csr(mip) & MIP_MCIP)
#;                ^
          10340000    0x80003df0 csrr a1, mip                   #; mip = 0, (wrb) a1  <-- 0
#; .LBB25_8 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;       snrt_int_wait_mcip_clr (cluster_interrupts.h:40:26)
#;         while (read_csr(mip) & MIP_MCIP)
#;                              ^
          10341000    0x80003df4 and a1, a1, a0                 #; a1  = 0, a0  = 0x00080000, (wrb) a1  <-- 0
#; .LBB25_8 (start.c:219:5)
#;   snrt_wake_up (start.c:140:5)
#;     snrt_int_clr_mcip (cluster_interrupts.h:49:5)
#;       snrt_int_wait_mcip_clr (cluster_interrupts.h:40:5)
#;         while (read_csr(mip) & MIP_MCIP)
#;         ^
          10342000    0x80003df8 bnez a1, -8                    #; a1  = 0, not taken
#; .LBB25_8 (start.c:227:5)
#;   snrt_init_tls (start.c:66:5)
#;     asm volatile("mv %0, tp" : "=r"(tls_ptr) : :);
#;     ^
          10343000    0x80003dfc mv a0, tp                      #; tp  = 0x1001f778, (wrb) a0  <-- 0x1001f778
          10361000    0x80003e00 sw a0, 8(sp)                   #; sp  = 0x1001f738, 0x1001f778 ~~> Word[0x1001f740]
#; .LBB25_8 (start.c:227:5)
#;   snrt_init_tls (start.c:67:19)
#;     memcpy((void*)tls_ptr, (const void*)&__tdata_start, size);
#;                   ^
          10391000    0x80003e04 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
#; .LBB25_23 (start.c:227:5)
#;   snrt_init_tls (start.c:67:5)
#;     memcpy((void*)tls_ptr, (const void*)&__tdata_start, size);
#;     ^
          10392000    0x80003e08 auipc a1, 2                    #; (wrb) a1  <-- 0x80005e08
          10393000    0x80003e0c addi a1, a1, 128               #; a1  = 0x80005e08, (wrb) a1  <-- 0x80005e88
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:67:5)
#;     memcpy((void*)tls_ptr, (const void*)&__tdata_start, size);
#;     ^
          10394000    0x80003e10 auipc a2, 2                    #; (wrb) a2  <-- 0x80005e10
          10395000    0x80003e14 addi a2, a2, 132               #; a2  = 0x80005e10, (wrb) a2  <-- 0x80005e94
          10396000    0x80003e18 sub s0, a2, a1                 #; a2  = 0x80005e94, a1  = 0x80005e88, (wrb) s0  <-- 12
          10397000    0x80003e1c mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
          10398000    0x80003e20 auipc ra, 0                    #; (wrb) ra  <-- 0x80003e20
          10399000    0x80003e24 jalr 1264(ra)                  #; ra  = 0x80003e20, (wrb) ra  <-- 0x80003e28, goto 0x80004310
#; memcpy (memcpy.c:25)
#;   {
          10400000    0x80004310 addi sp, sp, -16               #; sp  = 0x1001f738, (wrb) sp  <-- 0x1001f728
          10401000    0x80004314 sw s0, 12(sp)                  #; sp  = 0x1001f728, 12 ~~> Word[0x1001f734], (lsu) a0  <-- 0x1001f778
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10402000    0x80004318 andi a3, a0, 3                 #; a0  = 0x1001f778, (wrb) a3  <-- 0
          10403000    0x8000431c andi a4, a1, 3                 #; a1  = 0x80005e88, (wrb) a4  <-- 0
          10404000    0x80004320 xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
          10405000    0x80004324 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
          10406000    0x80004328 li a5, 3                       #; (wrb) a5  <-- 3
          10407000    0x8000432c sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
          10408000    0x80004330 and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
          10409000    0x80004334 add a2, a0, a2                 #; a0  = 0x1001f778, a2  = 12, (wrb) a2  <-- 0x1001f784
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10410000    0x80004338 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
          10411000    0x8000433c bnez a3, 116                   #; a3  = 0, not taken
          10412000    0x80004340 mv a4, a0                      #; a0  = 0x1001f778, (wrb) a4  <-- 0x1001f778
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
          10413000    0x80004344 andi a3, a2, -4                #; a2  = 0x1001f784, (wrb) a3  <-- 0x1001f784
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
          10414000    0x80004348 sub a5, a3, a4                 #; a3  = 0x1001f784, a4  = 0x1001f778, (wrb) a5  <-- 12
          10415000    0x8000434c li a6, 33                      #; (wrb) a6  <-- 33
          10416000    0x80004350 bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10417000    0x80004354 bgeu a4, a3, 32                #; a4  = 0x1001f778, a3  = 0x1001f784, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10418000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x80005e88, a6  <~~ Word[0x80005e88]
          10419000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001f778, (wrb) a5  <-- 0x1001f77c
          10420000    0x80004360 addi a1, a1, 4                 #; a1  = 0x80005e88, (wrb) a1  <-- 0x80005e8c
          10438000                                              #; (lsu) a6  <-- 0x80005fc0
          10439000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001f778, 0x80005fc0 ~~> Word[0x1001f778]
          10440000    0x80004368 mv a4, a5                      #; a5  = 0x1001f77c, (wrb) a4  <-- 0x1001f77c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10441000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001f77c, a3  = 0x1001f784, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10442000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x80005e8c, a6  <~~ Word[0x80005e8c]
          10443000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001f77c, (wrb) a5  <-- 0x1001f780
          10444000    0x80004360 addi a1, a1, 4                 #; a1  = 0x80005e8c, (wrb) a1  <-- 0x80005e90
          10474000                                              #; (lsu) a6  <-- 1
          10475000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001f77c, 1 ~~> Word[0x1001f77c]
          10476000    0x80004368 mv a4, a5                      #; a5  = 0x1001f780, (wrb) a4  <-- 0x1001f780
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10477000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001f780, a3  = 0x1001f784, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10478000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x80005e90, a6  <~~ Word[0x80005e90]
          10479000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001f780, (wrb) a5  <-- 0x1001f784
          10480000    0x80004360 addi a1, a1, 4                 #; a1  = 0x80005e90, (wrb) a1  <-- 0x80005e94
          10518000                                              #; (lsu) a6  <-- 1
          10519000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001f780, 1 ~~> Word[0x1001f780]
          10520000    0x80004368 mv a4, a5                      #; a5  = 0x1001f784, (wrb) a4  <-- 0x1001f784
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10521000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001f784, a3  = 0x1001f784, not taken
          10522000    0x80004370 j 8                            #; goto 0x80004378
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
          10523000    0x80004378 bltu a5, a2, 20                #; a5  = 0x1001f784, a2  = 0x1001f784, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
          10524000    0x8000437c lw s0, 12(sp)                  #; sp  = 0x1001f728, s0  <~~ Word[0x1001f734]
          10526000    0x80004380 addi sp, sp, 16                #; sp  = 0x1001f728, (wrb) sp  <-- 0x1001f738
          10527000    0x80004384 ret                            #; ra  = 0x80003e28, (lsu) s0  <-- 12, goto 0x80003e28
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
          10528000    0x80003e28 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
          10529000    0x80003e2c lw a1, 8(sp)                   #; sp  = 0x1001f738, a1  <~~ Word[0x1001f740]
          10531000                                              #; (lsu) a0  <-- 0x1001f778
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
          10532000    0x80003e30 addi a0, a0, 1032              #; a0  = 0x1001f778, (wrb) a0  <-- 0x1001fb80
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
          10533000    0x80003e34 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
          10534000    0x80003e38 auipc ra, 0                    #; (wrb) ra  <-- 0x80003e38
          10535000    0x80003e3c jalr 1240(ra)                  #; ra  = 0x80003e38, (wrb) ra  <-- 0x80003e40, goto 0x80004310
#; memcpy (memcpy.c:25)
#;   {
          10536000    0x80004310 addi sp, sp, -16               #; sp  = 0x1001f738, (wrb) sp  <-- 0x1001f728
          10537000    0x80004314 sw s0, 12(sp)                  #; sp  = 0x1001f728, 12 ~~> Word[0x1001f734], (lsu) a1  <-- 0x1001f778
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10538000    0x80004318 andi a3, a0, 3                 #; a0  = 0x1001fb80, (wrb) a3  <-- 0
          10539000    0x8000431c andi a4, a1, 3                 #; a1  = 0x1001f778, (wrb) a4  <-- 0
          10540000    0x80004320 xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
          10541000    0x80004324 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
          10542000    0x80004328 li a5, 3                       #; (wrb) a5  <-- 3
          10543000    0x8000432c sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
          10544000    0x80004330 and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
          10545000    0x80004334 add a2, a0, a2                 #; a0  = 0x1001fb80, a2  = 12, (wrb) a2  <-- 0x1001fb8c
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10546000    0x80004338 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
          10547000    0x8000433c bnez a3, 116                   #; a3  = 0, not taken
          10548000    0x80004340 mv a4, a0                      #; a0  = 0x1001fb80, (wrb) a4  <-- 0x1001fb80
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
          10549000    0x80004344 andi a3, a2, -4                #; a2  = 0x1001fb8c, (wrb) a3  <-- 0x1001fb8c
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
          10550000    0x80004348 sub a5, a3, a4                 #; a3  = 0x1001fb8c, a4  = 0x1001fb80, (wrb) a5  <-- 12
          10551000    0x8000434c li a6, 33                      #; (wrb) a6  <-- 33
          10552000    0x80004350 bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10553000    0x80004354 bgeu a4, a3, 32                #; a4  = 0x1001fb80, a3  = 0x1001fb8c, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10554000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001f778, a6  <~~ Word[0x1001f778]
          10555000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001fb80, (wrb) a5  <-- 0x1001fb84
          10556000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001f778, (wrb) a1  <-- 0x1001f77c
          10557000                                              #; (lsu) a6  <-- 0x80005fc0
          10558000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001fb80, 0x80005fc0 ~~> Word[0x1001fb80]
          10559000    0x80004368 mv a4, a5                      #; a5  = 0x1001fb84, (wrb) a4  <-- 0x1001fb84
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10560000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001fb84, a3  = 0x1001fb8c, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10561000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001f77c, a6  <~~ Word[0x1001f77c]
          10562000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001fb84, (wrb) a5  <-- 0x1001fb88
          10563000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001f77c, (wrb) a1  <-- 0x1001f780
          10564000                                              #; (lsu) a6  <-- 1
          10565000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001fb84, 1 ~~> Word[0x1001fb84]
          10566000    0x80004368 mv a4, a5                      #; a5  = 0x1001fb88, (wrb) a4  <-- 0x1001fb88
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10567000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001fb88, a3  = 0x1001fb8c, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10568000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001f780, a6  <~~ Word[0x1001f780]
          10569000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001fb88, (wrb) a5  <-- 0x1001fb8c
          10570000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001f780, (wrb) a1  <-- 0x1001f784
          10571000                                              #; (lsu) a6  <-- 1
          10572000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001fb88, 1 ~~> Word[0x1001fb88]
          10573000    0x80004368 mv a4, a5                      #; a5  = 0x1001fb8c, (wrb) a4  <-- 0x1001fb8c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10574000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001fb8c, a3  = 0x1001fb8c, not taken
          10575000    0x80004370 j 8                            #; goto 0x80004378
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
          10576000    0x80004378 bltu a5, a2, 20                #; a5  = 0x1001fb8c, a2  = 0x1001fb8c, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
          10577000    0x8000437c lw s0, 12(sp)                  #; sp  = 0x1001f728, s0  <~~ Word[0x1001f734]
          10578000    0x80004380 addi sp, sp, 16                #; sp  = 0x1001f728, (wrb) sp  <-- 0x1001f738
          10579000    0x80004384 ret                            #; ra  = 0x80003e40, goto 0x80003e40
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
          10580000    0x80003e40 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740], (lsu) s0  <-- 12
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
          10581000    0x80003e44 lw a1, 8(sp)                   #; sp  = 0x1001f738, a1  <~~ Word[0x1001f740]
          10582000    0x80003e48 lui s7, 1                      #; (wrb) s7  <-- 4096
          10583000    0x80003e4c addi s1, s7, -2032             #; s7  = 4096, (wrb) s1  <-- 2064
          10584000                                              #; (lsu) a0  <-- 0x1001f778
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
          10585000    0x80003e50 add a0, a0, s1                 #; a0  = 0x1001f778, s1  = 2064, (wrb) a0  <-- 0x1001ff88
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
          10586000    0x80003e54 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
          10587000    0x80003e58 auipc ra, 0                    #; (wrb) ra  <-- 0x80003e58
          10588000    0x80003e5c jalr 1208(ra)                  #; ra  = 0x80003e58, (wrb) ra  <-- 0x80003e60, goto 0x80004310
#; memcpy (memcpy.c:25)
#;   {
          10589000    0x80004310 addi sp, sp, -16               #; sp  = 0x1001f738, (wrb) sp  <-- 0x1001f728
          10590000    0x80004314 sw s0, 12(sp)                  #; sp  = 0x1001f728, 12 ~~> Word[0x1001f734], (lsu) a1  <-- 0x1001f778
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10591000    0x80004318 andi a3, a0, 3                 #; a0  = 0x1001ff88, (wrb) a3  <-- 0
          10592000    0x8000431c andi a4, a1, 3                 #; a1  = 0x1001f778, (wrb) a4  <-- 0
          10593000    0x80004320 xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
          10594000    0x80004324 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
          10595000    0x80004328 li a5, 3                       #; (wrb) a5  <-- 3
          10596000    0x8000432c sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
          10597000    0x80004330 and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
          10598000    0x80004334 add a2, a0, a2                 #; a0  = 0x1001ff88, a2  = 12, (wrb) a2  <-- 0x1001ff94
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10599000    0x80004338 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
          10600000    0x8000433c bnez a3, 116                   #; a3  = 0, not taken
          10601000    0x80004340 mv a4, a0                      #; a0  = 0x1001ff88, (wrb) a4  <-- 0x1001ff88
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
          10602000    0x80004344 andi a3, a2, -4                #; a2  = 0x1001ff94, (wrb) a3  <-- 0x1001ff94
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
          10603000    0x80004348 sub a5, a3, a4                 #; a3  = 0x1001ff94, a4  = 0x1001ff88, (wrb) a5  <-- 12
          10604000    0x8000434c li a6, 33                      #; (wrb) a6  <-- 33
          10605000    0x80004350 bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10606000    0x80004354 bgeu a4, a3, 32                #; a4  = 0x1001ff88, a3  = 0x1001ff94, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10607000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001f778, a6  <~~ Word[0x1001f778]
          10608000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001ff88, (wrb) a5  <-- 0x1001ff8c
          10609000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001f778, (wrb) a1  <-- 0x1001f77c
          10610000                                              #; (lsu) a6  <-- 0x80005fc0
          10611000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001ff88, 0x80005fc0 ~~> Word[0x1001ff88]
          10612000    0x80004368 mv a4, a5                      #; a5  = 0x1001ff8c, (wrb) a4  <-- 0x1001ff8c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10613000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001ff8c, a3  = 0x1001ff94, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10614000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001f77c, a6  <~~ Word[0x1001f77c]
          10615000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001ff8c, (wrb) a5  <-- 0x1001ff90
          10616000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001f77c, (wrb) a1  <-- 0x1001f780
          10617000                                              #; (lsu) a6  <-- 1
          10618000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001ff8c, 1 ~~> Word[0x1001ff8c]
          10619000    0x80004368 mv a4, a5                      #; a5  = 0x1001ff90, (wrb) a4  <-- 0x1001ff90
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10620000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001ff90, a3  = 0x1001ff94, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10621000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001f780, a6  <~~ Word[0x1001f780]
          10622000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1001ff90, (wrb) a5  <-- 0x1001ff94
          10623000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001f780, (wrb) a1  <-- 0x1001f784
          10624000                                              #; (lsu) a6  <-- 1
          10625000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1001ff90, 1 ~~> Word[0x1001ff90]
          10626000    0x80004368 mv a4, a5                      #; a5  = 0x1001ff94, (wrb) a4  <-- 0x1001ff94
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10627000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1001ff94, a3  = 0x1001ff94, not taken
          10628000    0x80004370 j 8                            #; goto 0x80004378
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
          10629000    0x80004378 bltu a5, a2, 20                #; a5  = 0x1001ff94, a2  = 0x1001ff94, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
          10630000    0x8000437c lw s0, 12(sp)                  #; sp  = 0x1001f728, s0  <~~ Word[0x1001f734]
          10631000    0x80004380 addi sp, sp, 16                #; sp  = 0x1001f728, (wrb) sp  <-- 0x1001f738
          10632000    0x80004384 ret                            #; ra  = 0x80003e60, goto 0x80003e60
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
          10633000    0x80003e60 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740], (lsu) s0  <-- 12
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
          10634000    0x80003e64 lw a1, 8(sp)                   #; sp  = 0x1001f738, a1  <~~ Word[0x1001f740]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
          10635000    0x80003e68 ori s6, s1, 1032               #; s1  = 2064, (wrb) s6  <-- 3096
          10636000                                              #; (lsu) a0  <-- 0x1001f778
          10637000    0x80003e6c add a0, a0, s6                 #; a0  = 0x1001f778, s6  = 3096, (wrb) a0  <-- 0x10020390
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
          10638000    0x80003e70 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
          10639000    0x80003e74 auipc ra, 0                    #; (wrb) ra  <-- 0x80003e74
          10640000    0x80003e78 jalr 1180(ra)                  #; ra  = 0x80003e74, (wrb) ra  <-- 0x80003e7c, goto 0x80004310
#; memcpy (memcpy.c:25)
#;   {
          10641000    0x80004310 addi sp, sp, -16               #; sp  = 0x1001f738, (wrb) sp  <-- 0x1001f728
          10642000    0x80004314 sw s0, 12(sp)                  #; sp  = 0x1001f728, 12 ~~> Word[0x1001f734], (lsu) a1  <-- 0x1001f778
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10643000    0x80004318 andi a3, a0, 3                 #; a0  = 0x10020390, (wrb) a3  <-- 0
          10644000    0x8000431c andi a4, a1, 3                 #; a1  = 0x1001f778, (wrb) a4  <-- 0
          10645000    0x80004320 xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
          10646000    0x80004324 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
          10647000    0x80004328 li a5, 3                       #; (wrb) a5  <-- 3
          10648000    0x8000432c sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
          10649000    0x80004330 and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
          10650000    0x80004334 add a2, a0, a2                 #; a0  = 0x10020390, a2  = 12, (wrb) a2  <-- 0x1002039c
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10651000    0x80004338 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
          10652000    0x8000433c bnez a3, 116                   #; a3  = 0, not taken
          10653000    0x80004340 mv a4, a0                      #; a0  = 0x10020390, (wrb) a4  <-- 0x10020390
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
          10654000    0x80004344 andi a3, a2, -4                #; a2  = 0x1002039c, (wrb) a3  <-- 0x1002039c
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
          10655000    0x80004348 sub a5, a3, a4                 #; a3  = 0x1002039c, a4  = 0x10020390, (wrb) a5  <-- 12
          10656000    0x8000434c li a6, 33                      #; (wrb) a6  <-- 33
          10657000    0x80004350 bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10658000    0x80004354 bgeu a4, a3, 32                #; a4  = 0x10020390, a3  = 0x1002039c, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10659000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001f778, a6  <~~ Word[0x1001f778]
          10660000    0x8000435c addi a5, a4, 4                 #; a4  = 0x10020390, (wrb) a5  <-- 0x10020394
          10661000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001f778, (wrb) a1  <-- 0x1001f77c
          10662000                                              #; (lsu) a6  <-- 0x80005fc0
          10663000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x10020390, 0x80005fc0 ~~> Word[0x10020390]
          10664000    0x80004368 mv a4, a5                      #; a5  = 0x10020394, (wrb) a4  <-- 0x10020394
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10665000    0x8000436c bltu a5, a3, -20               #; a5  = 0x10020394, a3  = 0x1002039c, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10666000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001f77c, a6  <~~ Word[0x1001f77c]
          10667000    0x8000435c addi a5, a4, 4                 #; a4  = 0x10020394, (wrb) a5  <-- 0x10020398
          10668000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001f77c, (wrb) a1  <-- 0x1001f780
          10675000                                              #; (lsu) a6  <-- 1
          10676000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x10020394, 1 ~~> Word[0x10020394]
          10677000    0x80004368 mv a4, a5                      #; a5  = 0x10020398, (wrb) a4  <-- 0x10020398
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10678000    0x8000436c bltu a5, a3, -20               #; a5  = 0x10020398, a3  = 0x1002039c, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10679000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001f780, a6  <~~ Word[0x1001f780]
          10680000    0x8000435c addi a5, a4, 4                 #; a4  = 0x10020398, (wrb) a5  <-- 0x1002039c
          10681000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001f780, (wrb) a1  <-- 0x1001f784
          10688000                                              #; (lsu) a6  <-- 1
          10689000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x10020398, 1 ~~> Word[0x10020398]
          10690000    0x80004368 mv a4, a5                      #; a5  = 0x1002039c, (wrb) a4  <-- 0x1002039c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10691000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1002039c, a3  = 0x1002039c, not taken
          10692000    0x80004370 j 8                            #; goto 0x80004378
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
          10693000    0x80004378 bltu a5, a2, 20                #; a5  = 0x1002039c, a2  = 0x1002039c, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
          10694000    0x8000437c lw s0, 12(sp)                  #; sp  = 0x1001f728, s0  <~~ Word[0x1001f734]
          10695000    0x80004380 addi sp, sp, 16                #; sp  = 0x1001f728, (wrb) sp  <-- 0x1001f738
          10696000    0x80004384 ret                            #; ra  = 0x80003e7c, goto 0x80003e7c
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
          10697000    0x80003e7c lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
          10698000    0x80003e80 lw a1, 8(sp)                   #; sp  = 0x1001f738, a1  <~~ Word[0x1001f740]
          10699000    0x80003e84 addi s7, s7, 32                #; s7  = 4096, (wrb) s7  <-- 4128
          10705000                                              #; (lsu) s0  <-- 12
          10706000                                              #; (lsu) a0  <-- 0x1001f778
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
          10707000    0x80003e88 add a0, a0, s7                 #; a0  = 0x1001f778, s7  = 4128, (wrb) a0  <-- 0x10020798
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
          10708000    0x80003e8c mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
          10709000    0x80003e90 auipc ra, 0                    #; (wrb) ra  <-- 0x80003e90
          10710000    0x80003e94 jalr 1152(ra)                  #; ra  = 0x80003e90, (wrb) ra  <-- 0x80003e98, goto 0x80004310
          10711000                                              #; (lsu) a1  <-- 0x1001f778
#; memcpy (memcpy.c:25)
#;   {
          10713000    0x80004310 addi sp, sp, -16               #; sp  = 0x1001f738, (wrb) sp  <-- 0x1001f728
          10714000    0x80004314 sw s0, 12(sp)                  #; sp  = 0x1001f728, 12 ~~> Word[0x1001f734]
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10715000    0x80004318 andi a3, a0, 3                 #; a0  = 0x10020798, (wrb) a3  <-- 0
          10716000    0x8000431c andi a4, a1, 3                 #; a1  = 0x1001f778, (wrb) a4  <-- 0
          10717000    0x80004320 xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
          10718000    0x80004324 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
          10719000    0x80004328 li a5, 3                       #; (wrb) a5  <-- 3
          10720000    0x8000432c sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
          10721000    0x80004330 and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
          10722000    0x80004334 add a2, a0, a2                 #; a0  = 0x10020798, a2  = 12, (wrb) a2  <-- 0x100207a4
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10723000    0x80004338 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
          10724000    0x8000433c bnez a3, 116                   #; a3  = 0, not taken
          10725000    0x80004340 mv a4, a0                      #; a0  = 0x10020798, (wrb) a4  <-- 0x10020798
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
          10726000    0x80004344 andi a3, a2, -4                #; a2  = 0x100207a4, (wrb) a3  <-- 0x100207a4
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
          10727000    0x80004348 sub a5, a3, a4                 #; a3  = 0x100207a4, a4  = 0x10020798, (wrb) a5  <-- 12
          10728000    0x8000434c li a6, 33                      #; (wrb) a6  <-- 33
          10729000    0x80004350 bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10730000    0x80004354 bgeu a4, a3, 32                #; a4  = 0x10020798, a3  = 0x100207a4, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10731000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001f778, a6  <~~ Word[0x1001f778]
          10732000    0x8000435c addi a5, a4, 4                 #; a4  = 0x10020798, (wrb) a5  <-- 0x1002079c
          10733000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001f778, (wrb) a1  <-- 0x1001f77c
          10734000                                              #; (lsu) a6  <-- 0x80005fc0
          10735000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x10020798, 0x80005fc0 ~~> Word[0x10020798]
          10736000    0x80004368 mv a4, a5                      #; a5  = 0x1002079c, (wrb) a4  <-- 0x1002079c
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10737000    0x8000436c bltu a5, a3, -20               #; a5  = 0x1002079c, a3  = 0x100207a4, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10738000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001f77c, a6  <~~ Word[0x1001f77c]
          10739000    0x8000435c addi a5, a4, 4                 #; a4  = 0x1002079c, (wrb) a5  <-- 0x100207a0
          10740000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001f77c, (wrb) a1  <-- 0x1001f780
          10747000                                              #; (lsu) a6  <-- 1
          10748000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x1002079c, 1 ~~> Word[0x1002079c]
          10749000    0x80004368 mv a4, a5                      #; a5  = 0x100207a0, (wrb) a4  <-- 0x100207a0
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10750000    0x8000436c bltu a5, a3, -20               #; a5  = 0x100207a0, a3  = 0x100207a4, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10751000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001f780, a6  <~~ Word[0x1001f780]
          10752000    0x8000435c addi a5, a4, 4                 #; a4  = 0x100207a0, (wrb) a5  <-- 0x100207a4
          10753000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001f780, (wrb) a1  <-- 0x1001f784
          10768000                                              #; (lsu) a6  <-- 1
          10769000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x100207a0, 1 ~~> Word[0x100207a0]
          10770000    0x80004368 mv a4, a5                      #; a5  = 0x100207a4, (wrb) a4  <-- 0x100207a4
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10771000    0x8000436c bltu a5, a3, -20               #; a5  = 0x100207a4, a3  = 0x100207a4, not taken
          10772000    0x80004370 j 8                            #; goto 0x80004378
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
          10773000    0x80004378 bltu a5, a2, 20                #; a5  = 0x100207a4, a2  = 0x100207a4, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
          10774000    0x8000437c lw s0, 12(sp)                  #; sp  = 0x1001f728, s0  <~~ Word[0x1001f734]
          10775000    0x80004380 addi sp, sp, 16                #; sp  = 0x1001f728, (wrb) sp  <-- 0x1001f738
          10776000    0x80004384 ret                            #; ra  = 0x80003e98, goto 0x80003e98
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
          10777000    0x80003e98 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
          10778000    0x80003e9c lw a1, 8(sp)                   #; sp  = 0x1001f738, a1  <~~ Word[0x1001f740]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
          10779000    0x80003ea0 ori s8, s7, 1032               #; s7  = 4128, (wrb) s8  <-- 5160
          10787000                                              #; (lsu) s0  <-- 12
          10788000                                              #; (lsu) a0  <-- 0x1001f778
          10789000    0x80003ea4 add a0, a0, s8                 #; a0  = 0x1001f778, s8  = 5160, (wrb) a0  <-- 0x10020ba0
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
          10790000    0x80003ea8 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
          10791000    0x80003eac auipc ra, 0                    #; (wrb) ra  <-- 0x80003eac
          10792000    0x80003eb0 jalr 1124(ra)                  #; ra  = 0x80003eac, (wrb) ra  <-- 0x80003eb4, goto 0x80004310
#; memcpy (memcpy.c:25)
#;   {
          10793000    0x80004310 addi sp, sp, -16               #; sp  = 0x1001f738, (wrb) sp  <-- 0x1001f728
          10794000    0x80004314 sw s0, 12(sp)                  #; sp  = 0x1001f728, 12 ~~> Word[0x1001f734], (lsu) a1  <-- 0x1001f778
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10795000    0x80004318 andi a3, a0, 3                 #; a0  = 0x10020ba0, (wrb) a3  <-- 0
          10796000    0x8000431c andi a4, a1, 3                 #; a1  = 0x1001f778, (wrb) a4  <-- 0
          10797000    0x80004320 xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
          10798000    0x80004324 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
          10799000    0x80004328 li a5, 3                       #; (wrb) a5  <-- 3
          10800000    0x8000432c sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
          10801000    0x80004330 and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
          10802000    0x80004334 add a2, a0, a2                 #; a0  = 0x10020ba0, a2  = 12, (wrb) a2  <-- 0x10020bac
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10803000    0x80004338 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
          10804000    0x8000433c bnez a3, 116                   #; a3  = 0, not taken
          10805000    0x80004340 mv a4, a0                      #; a0  = 0x10020ba0, (wrb) a4  <-- 0x10020ba0
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
          10806000    0x80004344 andi a3, a2, -4                #; a2  = 0x10020bac, (wrb) a3  <-- 0x10020bac
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
          10807000    0x80004348 sub a5, a3, a4                 #; a3  = 0x10020bac, a4  = 0x10020ba0, (wrb) a5  <-- 12
          10808000    0x8000434c li a6, 33                      #; (wrb) a6  <-- 33
          10809000    0x80004350 bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10810000    0x80004354 bgeu a4, a3, 32                #; a4  = 0x10020ba0, a3  = 0x10020bac, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10811000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001f778, a6  <~~ Word[0x1001f778]
          10812000    0x8000435c addi a5, a4, 4                 #; a4  = 0x10020ba0, (wrb) a5  <-- 0x10020ba4
          10813000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001f778, (wrb) a1  <-- 0x1001f77c
          10814000                                              #; (lsu) a6  <-- 0x80005fc0
          10815000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x10020ba0, 0x80005fc0 ~~> Word[0x10020ba0]
          10816000    0x80004368 mv a4, a5                      #; a5  = 0x10020ba4, (wrb) a4  <-- 0x10020ba4
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10817000    0x8000436c bltu a5, a3, -20               #; a5  = 0x10020ba4, a3  = 0x10020bac, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10818000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001f77c, a6  <~~ Word[0x1001f77c]
          10819000    0x8000435c addi a5, a4, 4                 #; a4  = 0x10020ba4, (wrb) a5  <-- 0x10020ba8
          10820000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001f77c, (wrb) a1  <-- 0x1001f780
          10830000                                              #; (lsu) a6  <-- 1
          10831000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x10020ba4, 1 ~~> Word[0x10020ba4]
          10832000    0x80004368 mv a4, a5                      #; a5  = 0x10020ba8, (wrb) a4  <-- 0x10020ba8
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10833000    0x8000436c bltu a5, a3, -20               #; a5  = 0x10020ba8, a3  = 0x10020bac, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10834000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001f780, a6  <~~ Word[0x1001f780]
          10835000    0x8000435c addi a5, a4, 4                 #; a4  = 0x10020ba8, (wrb) a5  <-- 0x10020bac
          10836000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001f780, (wrb) a1  <-- 0x1001f784
          10853000                                              #; (lsu) a6  <-- 1
          10854000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x10020ba8, 1 ~~> Word[0x10020ba8]
          10855000    0x80004368 mv a4, a5                      #; a5  = 0x10020bac, (wrb) a4  <-- 0x10020bac
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10856000    0x8000436c bltu a5, a3, -20               #; a5  = 0x10020bac, a3  = 0x10020bac, not taken
          10857000    0x80004370 j 8                            #; goto 0x80004378
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
          10858000    0x80004378 bltu a5, a2, 20                #; a5  = 0x10020bac, a2  = 0x10020bac, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
          10859000    0x8000437c lw s0, 12(sp)                  #; sp  = 0x1001f728, s0  <~~ Word[0x1001f734]
          10860000    0x80004380 addi sp, sp, 16                #; sp  = 0x1001f728, (wrb) sp  <-- 0x1001f738
          10861000    0x80004384 ret                            #; ra  = 0x80003eb4, goto 0x80003eb4
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
          10863000    0x80003eb4 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
          10864000    0x80003eb8 lw a1, 8(sp)                   #; sp  = 0x1001f738, a1  <~~ Word[0x1001f740]
          10865000    0x80003ebc lui s11, 2                     #; (wrb) s11 <-- 8192
          10866000    0x80003ec0 addi s9, s11, -2000            #; s11 = 8192, (wrb) s9  <-- 6192
          10876000                                              #; (lsu) s0  <-- 12
          10877000                                              #; (lsu) a0  <-- 0x1001f778
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
          10878000    0x80003ec4 add a0, a0, s9                 #; a0  = 0x1001f778, s9  = 6192, (wrb) a0  <-- 0x10020fa8
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
          10879000    0x80003ec8 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
          10880000    0x80003ecc auipc ra, 0                    #; (wrb) ra  <-- 0x80003ecc
          10881000    0x80003ed0 jalr 1092(ra)                  #; ra  = 0x80003ecc, (wrb) ra  <-- 0x80003ed4, goto 0x80004310
#; memcpy (memcpy.c:25)
#;   {
          10882000    0x80004310 addi sp, sp, -16               #; sp  = 0x1001f738, (wrb) sp  <-- 0x1001f728
          10883000    0x80004314 sw s0, 12(sp)                  #; sp  = 0x1001f728, 12 ~~> Word[0x1001f734], (lsu) a1  <-- 0x1001f778
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10884000    0x80004318 andi a3, a0, 3                 #; a0  = 0x10020fa8, (wrb) a3  <-- 0
          10885000    0x8000431c andi a4, a1, 3                 #; a1  = 0x1001f778, (wrb) a4  <-- 0
          10886000    0x80004320 xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
          10887000    0x80004324 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
          10888000    0x80004328 li a5, 3                       #; (wrb) a5  <-- 3
          10889000    0x8000432c sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
          10890000    0x80004330 and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
          10891000    0x80004334 add a2, a0, a2                 #; a0  = 0x10020fa8, a2  = 12, (wrb) a2  <-- 0x10020fb4
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10892000    0x80004338 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
          10893000    0x8000433c bnez a3, 116                   #; a3  = 0, not taken
          10894000    0x80004340 mv a4, a0                      #; a0  = 0x10020fa8, (wrb) a4  <-- 0x10020fa8
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
          10895000    0x80004344 andi a3, a2, -4                #; a2  = 0x10020fb4, (wrb) a3  <-- 0x10020fb4
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
          10896000    0x80004348 sub a5, a3, a4                 #; a3  = 0x10020fb4, a4  = 0x10020fa8, (wrb) a5  <-- 12
          10897000    0x8000434c li a6, 33                      #; (wrb) a6  <-- 33
          10898000    0x80004350 bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10899000    0x80004354 bgeu a4, a3, 32                #; a4  = 0x10020fa8, a3  = 0x10020fb4, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10900000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001f778, a6  <~~ Word[0x1001f778]
          10901000    0x8000435c addi a5, a4, 4                 #; a4  = 0x10020fa8, (wrb) a5  <-- 0x10020fac
          10902000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001f778, (wrb) a1  <-- 0x1001f77c
          10903000                                              #; (lsu) a6  <-- 0x80005fc0
          10904000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x10020fa8, 0x80005fc0 ~~> Word[0x10020fa8]
          10905000    0x80004368 mv a4, a5                      #; a5  = 0x10020fac, (wrb) a4  <-- 0x10020fac
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10906000    0x8000436c bltu a5, a3, -20               #; a5  = 0x10020fac, a3  = 0x10020fb4, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10907000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001f77c, a6  <~~ Word[0x1001f77c]
          10908000    0x8000435c addi a5, a4, 4                 #; a4  = 0x10020fac, (wrb) a5  <-- 0x10020fb0
          10909000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001f77c, (wrb) a1  <-- 0x1001f780
          10929000                                              #; (lsu) a6  <-- 1
          10930000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x10020fac, 1 ~~> Word[0x10020fac]
          10931000    0x80004368 mv a4, a5                      #; a5  = 0x10020fb0, (wrb) a4  <-- 0x10020fb0
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10932000    0x8000436c bltu a5, a3, -20               #; a5  = 0x10020fb0, a3  = 0x10020fb4, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          10933000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001f780, a6  <~~ Word[0x1001f780]
          10934000    0x8000435c addi a5, a4, 4                 #; a4  = 0x10020fb0, (wrb) a5  <-- 0x10020fb4
          10935000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001f780, (wrb) a1  <-- 0x1001f784
          10964000                                              #; (lsu) a6  <-- 1
          10965000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x10020fb0, 1 ~~> Word[0x10020fb0]
          10966000    0x80004368 mv a4, a5                      #; a5  = 0x10020fb4, (wrb) a4  <-- 0x10020fb4
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          10967000    0x8000436c bltu a5, a3, -20               #; a5  = 0x10020fb4, a3  = 0x10020fb4, not taken
          10968000    0x80004370 j 8                            #; goto 0x80004378
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
          10969000    0x80004378 bltu a5, a2, 20                #; a5  = 0x10020fb4, a2  = 0x10020fb4, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
          10970000    0x8000437c lw s0, 12(sp)                  #; sp  = 0x1001f728, s0  <~~ Word[0x1001f734]
          10971000    0x80004380 addi sp, sp, 16                #; sp  = 0x1001f728, (wrb) sp  <-- 0x1001f738
          10972000    0x80004384 ret                            #; ra  = 0x80003ed4, goto 0x80003ed4
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
          10981000    0x80003ed4 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
          10982000    0x80003ed8 lw a1, 8(sp)                   #; sp  = 0x1001f738, a1  <~~ Word[0x1001f740]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
          10983000    0x80003edc ori s10, s9, 1032              #; s9  = 6192, (wrb) s10 <-- 7224
          10991000                                              #; (lsu) s0  <-- 12
          10992000                                              #; (lsu) a0  <-- 0x1001f778
          10993000    0x80003ee0 add a0, a0, s10                #; a0  = 0x1001f778, s10 = 7224, (wrb) a0  <-- 0x100213b0
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
          10994000    0x80003ee4 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
          10995000    0x80003ee8 auipc ra, 0                    #; (wrb) ra  <-- 0x80003ee8
          10996000    0x80003eec jalr 1064(ra)                  #; ra  = 0x80003ee8, (wrb) ra  <-- 0x80003ef0, goto 0x80004310
#; memcpy (memcpy.c:25)
#;   {
          10997000    0x80004310 addi sp, sp, -16               #; sp  = 0x1001f738, (wrb) sp  <-- 0x1001f728
          10998000    0x80004314 sw s0, 12(sp)                  #; sp  = 0x1001f728, 12 ~~> Word[0x1001f734], (lsu) a1  <-- 0x1001f778
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          10999000    0x80004318 andi a3, a0, 3                 #; a0  = 0x100213b0, (wrb) a3  <-- 0
          11000000    0x8000431c andi a4, a1, 3                 #; a1  = 0x1001f778, (wrb) a4  <-- 0
          11001000    0x80004320 xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
          11002000    0x80004324 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
          11003000    0x80004328 li a5, 3                       #; (wrb) a5  <-- 3
          11004000    0x8000432c sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
          11005000    0x80004330 and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
          11006000    0x80004334 add a2, a0, a2                 #; a0  = 0x100213b0, a2  = 12, (wrb) a2  <-- 0x100213bc
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          11007000    0x80004338 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
          11008000    0x8000433c bnez a3, 116                   #; a3  = 0, not taken
          11009000    0x80004340 mv a4, a0                      #; a0  = 0x100213b0, (wrb) a4  <-- 0x100213b0
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
          11010000    0x80004344 andi a3, a2, -4                #; a2  = 0x100213bc, (wrb) a3  <-- 0x100213bc
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
          11011000    0x80004348 sub a5, a3, a4                 #; a3  = 0x100213bc, a4  = 0x100213b0, (wrb) a5  <-- 12
          11012000    0x8000434c li a6, 33                      #; (wrb) a6  <-- 33
          11013000    0x80004350 bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          11014000    0x80004354 bgeu a4, a3, 32                #; a4  = 0x100213b0, a3  = 0x100213bc, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          11015000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001f778, a6  <~~ Word[0x1001f778]
          11016000    0x8000435c addi a5, a4, 4                 #; a4  = 0x100213b0, (wrb) a5  <-- 0x100213b4
          11017000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001f778, (wrb) a1  <-- 0x1001f77c
          11018000                                              #; (lsu) a6  <-- 0x80005fc0
          11019000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x100213b0, 0x80005fc0 ~~> Word[0x100213b0]
          11020000    0x80004368 mv a4, a5                      #; a5  = 0x100213b4, (wrb) a4  <-- 0x100213b4
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          11021000    0x8000436c bltu a5, a3, -20               #; a5  = 0x100213b4, a3  = 0x100213bc, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          11022000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001f77c, a6  <~~ Word[0x1001f77c]
          11023000    0x8000435c addi a5, a4, 4                 #; a4  = 0x100213b4, (wrb) a5  <-- 0x100213b8
          11024000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001f77c, (wrb) a1  <-- 0x1001f780
          11043000                                              #; (lsu) a6  <-- 1
          11044000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x100213b4, 1 ~~> Word[0x100213b4]
          11045000    0x80004368 mv a4, a5                      #; a5  = 0x100213b8, (wrb) a4  <-- 0x100213b8
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          11046000    0x8000436c bltu a5, a3, -20               #; a5  = 0x100213b8, a3  = 0x100213bc, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          11047000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001f780, a6  <~~ Word[0x1001f780]
          11048000    0x8000435c addi a5, a4, 4                 #; a4  = 0x100213b8, (wrb) a5  <-- 0x100213bc
          11049000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001f780, (wrb) a1  <-- 0x1001f784
          11073000                                              #; (lsu) a6  <-- 1
          11074000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x100213b8, 1 ~~> Word[0x100213b8]
          11075000    0x80004368 mv a4, a5                      #; a5  = 0x100213bc, (wrb) a4  <-- 0x100213bc
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          11076000    0x8000436c bltu a5, a3, -20               #; a5  = 0x100213bc, a3  = 0x100213bc, not taken
          11077000    0x80004370 j 8                            #; goto 0x80004378
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
          11078000    0x80004378 bltu a5, a2, 20                #; a5  = 0x100213bc, a2  = 0x100213bc, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
          11079000    0x8000437c lw s0, 12(sp)                  #; sp  = 0x1001f728, s0  <~~ Word[0x1001f734]
          11080000    0x80004380 addi sp, sp, 16                #; sp  = 0x1001f728, (wrb) sp  <-- 0x1001f738
          11081000    0x80004384 ret                            #; ra  = 0x80003ef0, goto 0x80003ef0
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:28)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                    ^
          11088000    0x80003ef0 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:68)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                                                            ^
          11089000    0x80003ef4 lw a1, 8(sp)                   #; sp  = 0x1001f738, a1  <~~ Word[0x1001f740]
          11090000    0x80003ef8 addi s11, s11, 64              #; s11 = 8192, (wrb) s11 <-- 8256
          11095000                                              #; (lsu) s0  <-- 12
          11096000                                              #; (lsu) a0  <-- 0x1001f778
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:36)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;                            ^
          11097000    0x80003efc add a0, a0, s11                #; a0  = 0x1001f778, s11 = 8256, (wrb) a0  <-- 0x100217b8
          11098000                                              #; (lsu) a1  <-- 0x1001f778
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:75:13)
#;     memcpy((void*)(tls_ptr + i * tls_offset), (const void*)tls_ptr, size);
#;     ^
          11100000    0x80003f00 mv a2, s0                      #; s0  = 12, (wrb) a2  <-- 12
          11101000    0x80003f04 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f04
          11102000    0x80003f08 jalr 1036(ra)                  #; ra  = 0x80003f04, (wrb) ra  <-- 0x80003f0c, goto 0x80004310
#; memcpy (memcpy.c:25)
#;   {
          11103000    0x80004310 addi sp, sp, -16               #; sp  = 0x1001f738, (wrb) sp  <-- 0x1001f728
          11104000    0x80004314 sw s0, 12(sp)                  #; sp  = 0x1001f728, 12 ~~> Word[0x1001f734]
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          11105000    0x80004318 andi a3, a0, 3                 #; a0  = 0x100217b8, (wrb) a3  <-- 0
          11106000    0x8000431c andi a4, a1, 3                 #; a1  = 0x1001f778, (wrb) a4  <-- 0
          11107000    0x80004320 xor a4, a3, a4                 #; a3  = 0, a4  = 0, (wrb) a4  <-- 0
          11108000    0x80004324 seqz a4, a4                    #; a4  = 0, (wrb) a4  <-- 1
          11109000    0x80004328 li a5, 3                       #; (wrb) a5  <-- 3
          11110000    0x8000432c sltu a5, a5, a2                #; a5  = 3, a2  = 12, (wrb) a5  <-- 1
          11111000    0x80004330 and a4, a5, a4                 #; a5  = 1, a4  = 1, (wrb) a4  <-- 1
#; memcpy (memcpy.c:34:17)
#;   char *end = a + n;
#;                 ^
          11112000    0x80004334 add a2, a0, a2                 #; a0  = 0x100217b8, a2  = 12, (wrb) a2  <-- 0x100217c4
#; memcpy (memcpy.c:36:7)
#;   if (unlikely ((((uintptr_t)a & msk) != ((uintptr_t)b & msk))
#;       ^
          11113000    0x80004338 beqz a4, 80                    #; a4  = 1, not taken
#; memcpy (memcpy.c:46:7)
#;   if (unlikely (((uintptr_t)a & msk) != 0))
#;       ^
          11114000    0x8000433c bnez a3, 116                   #; a3  = 0, not taken
          11115000    0x80004340 mv a4, a0                      #; a0  = 0x100217b8, (wrb) a4  <-- 0x100217b8
#; .LBB0_3 (memcpy.c:52:40)
#;   long *lend = (long *)((uintptr_t)end & ~msk);
#;                                        ^
          11116000    0x80004344 andi a3, a2, -4                #; a2  = 0x100217c4, (wrb) a3  <-- 0x100217c4
#; .LBB0_3 (memcpy.c:54:7)
#;   if (unlikely (lend - la > 8))
#;       ^
          11117000    0x80004348 sub a5, a3, a4                 #; a3  = 0x100217c4, a4  = 0x100217b8, (wrb) a5  <-- 12
          11118000    0x8000434c li a6, 33                      #; (wrb) a6  <-- 33
          11119000    0x80004350 bge a5, a6, 140                #; a5  = 12, a6  = 33, not taken
#; .LBB0_4 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          11120000    0x80004354 bgeu a4, a3, 32                #; a4  = 0x100217b8, a3  = 0x100217c4, not taken
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          11121000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001f778, a6  <~~ Word[0x1001f778]
          11122000    0x8000435c addi a5, a4, 4                 #; a4  = 0x100217b8, (wrb) a5  <-- 0x100217bc
          11123000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001f778, (wrb) a1  <-- 0x1001f77c
          11124000                                              #; (lsu) a6  <-- 0x80005fc0
          11125000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x100217b8, 0x80005fc0 ~~> Word[0x100217b8]
          11126000    0x80004368 mv a4, a5                      #; a5  = 0x100217bc, (wrb) a4  <-- 0x100217bc
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          11127000    0x8000436c bltu a5, a3, -20               #; a5  = 0x100217bc, a3  = 0x100217c4, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          11128000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001f77c, a6  <~~ Word[0x1001f77c]
          11129000    0x8000435c addi a5, a4, 4                 #; a4  = 0x100217bc, (wrb) a5  <-- 0x100217c0
          11130000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001f77c, (wrb) a1  <-- 0x1001f780
          11136000                                              #; (lsu) a6  <-- 1
          11137000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x100217bc, 1 ~~> Word[0x100217bc]
          11138000    0x80004368 mv a4, a5                      #; a5  = 0x100217c0, (wrb) a4  <-- 0x100217c0
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          11139000    0x8000436c bltu a5, a3, -20               #; a5  = 0x100217c0, a3  = 0x100217c4, taken, goto 0x80004358
#; .LBB0_5 (memcpy.c:80:5)
#;   BODY (la, lb, long);
#;   ^
          11140000    0x80004358 lw a6, 0(a1)                   #; a1  = 0x1001f780, a6  <~~ Word[0x1001f780]
          11141000    0x8000435c addi a5, a4, 4                 #; a4  = 0x100217c0, (wrb) a5  <-- 0x100217c4
          11142000    0x80004360 addi a1, a1, 4                 #; a1  = 0x1001f780, (wrb) a1  <-- 0x1001f784
          11149000                                              #; (lsu) a6  <-- 1
          11150000    0x80004364 sw a6, 0(a4)                   #; a4  = 0x100217c0, 1 ~~> Word[0x100217c0]
          11151000    0x80004368 mv a4, a5                      #; a5  = 0x100217c4, (wrb) a4  <-- 0x100217c4
#; .LBB0_5 (memcpy.c:79:3)
#;   while (la < lend)
#;   ^
          11152000    0x8000436c bltu a5, a3, -20               #; a5  = 0x100217c4, a3  = 0x100217c4, not taken
          11153000    0x80004370 j 8                            #; goto 0x80004378
#; .LBB0_7 (memcpy.c:84:7)
#;   if (unlikely (a < end))
#;       ^
          11154000    0x80004378 bltu a5, a2, 20                #; a5  = 0x100217c4, a2  = 0x100217c4, not taken
#; .LBB0_8 (memcpy.c:87:1)
#;   }
#;   ^
          11155000    0x8000437c lw s0, 12(sp)                  #; sp  = 0x1001f728, s0  <~~ Word[0x1001f734]
          11156000    0x80004380 addi sp, sp, 16                #; sp  = 0x1001f728, (wrb) sp  <-- 0x1001f738
          11157000    0x80004384 ret                            #; ra  = 0x80003f0c, goto 0x80003f0c
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:79:17)
#;     tls_ptr += size;
#;             ^
          11158000    0x80003f0c lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
          11159000                                              #; (lsu) s0  <-- 12
          11161000                                              #; (lsu) a0  <-- 0x1001f778
          11162000    0x80003f10 add a0, a0, s0                 #; a0  = 0x1001f778, s0  = 12, (wrb) a0  <-- 0x1001f784
          11163000    0x80003f14 sw a0, 8(sp)                   #; sp  = 0x1001f738, 0x1001f784 ~~> Word[0x1001f740]
#; .LBB25_24 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
          11164000    0x80003f18 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
#; .LBB25_25 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
          11165000    0x80003f1c auipc a1, 2                    #; (wrb) a1  <-- 0x80005f1c
          11166000    0x80003f20 addi a1, a1, -132              #; a1  = 0x80005f1c, (wrb) a1  <-- 0x80005e98
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
          11167000    0x80003f24 auipc a2, 2                    #; (wrb) a2  <-- 0x80005f24
          11168000    0x80003f28 addi a2, a2, -76               #; a2  = 0x80005f24, (wrb) a2  <-- 0x80005ed8
          11169000    0x80003f2c sub s0, a2, a1                 #; a2  = 0x80005ed8, a1  = 0x80005e98, (wrb) s0  <-- 64
          11170000    0x80003f30 li a1, 0                       #; (wrb) a1  <-- 0
          11171000    0x80003f34 mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
          11172000    0x80003f38 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f38
          11173000    0x80003f3c jalr 764(ra)                   #; ra  = 0x80003f38, (wrb) ra  <-- 0x80003f40, goto 0x80004234
          11174000                                              #; (lsu) a0  <-- 0x1001f784
#; memset (memset.S:30)
#;   li t1, 15
          11176000    0x80004234 li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
          11177000    0x80004238 mv a4, a0                      #; a0  = 0x1001f784, (wrb) a4  <-- 0x1001f784
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
          11178000    0x8000423c bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
          11181000    0x80004240 andi a5, a4, 15                #; a4  = 0x1001f784, (wrb) a5  <-- 4
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
          11182000    0x80004244 bnez a5, 160                   #; a5  = 4, taken, goto 0x800042e4
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
          11185000    0x800042e4 slli a3, a5, 2                 #; a5  = 4, (wrb) a3  <-- 16
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
          11186000    0x800042e8 auipc t0, 0                    #; (wrb) t0  <-- 0x800042e8
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
          11187000    0x800042ec add a3, a3, t0                 #; a3  = 16, t0  = 0x800042e8, (wrb) a3  <-- 0x800042f8
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
          11188000    0x800042f0 mv t0, ra                      #; ra  = 0x80003f40, (wrb) t0  <-- 0x80003f40
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
          11189000    0x800042f4 jalr -96(a3)                   #; a3  = 0x800042f8, (wrb) ra  <-- 0x800042f8, goto 0x80004298
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
          11192000    0x80004298 sb a1, 11(a4)                  #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f78f]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
          11193000    0x8000429c sb a1, 10(a4)                  #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f78e]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
          11194000    0x800042a0 sb a1, 9(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f78d]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
          11195000    0x800042a4 sb a1, 8(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f78c]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
          11196000    0x800042a8 sb a1, 7(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f78b]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
          11197000    0x800042ac sb a1, 6(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f78a]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
          11198000    0x800042b0 sb a1, 5(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f789]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
          11199000    0x800042b4 sb a1, 4(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f788]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          11200000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f787]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          11201000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f786]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          11202000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f785]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          11203000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x1001f784, 0 ~~> Byte[0x1001f784]
#; .Ltable (memset.S:85)
#;   ret
          11204000    0x800042c8 ret                            #; ra  = 0x800042f8, goto 0x800042f8
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
          11205000    0x800042f8 mv ra, t0                      #; t0  = 0x80003f40, (wrb) ra  <-- 0x80003f40
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
          11206000    0x800042fc addi a5, a5, -16               #; a5  = 4, (wrb) a5  <-- -12
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
          11207000    0x80004300 sub a4, a4, a5                 #; a4  = 0x1001f784, a5  = -12, (wrb) a4  <-- 0x1001f790
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
          11208000    0x80004304 add a2, a2, a5                 #; a2  = 64, a5  = -12, (wrb) a2  <-- 52
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
          11209000    0x80004308 bgeu t1, a2, -144              #; t1  = 15, a2  = 52, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
          11210000    0x8000430c j -196                         #; goto 0x80004248
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
          11211000    0x80004248 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
          11212000    0x8000424c andi a3, a2, -16               #; a2  = 52, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
          11213000    0x80004250 andi a2, a2, 15                #; a2  = 52, (wrb) a2  <-- 4
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
          11214000    0x80004254 add a3, a3, a4                 #; a3  = 48, a4  = 0x1001f790, (wrb) a3  <-- 0x1001f7c0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11215000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001f790, 0 ~~> Word[0x1001f790]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11216000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001f790, 0 ~~> Word[0x1001f794]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11219000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001f790, 0 ~~> Word[0x1001f798]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11221000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001f790, 0 ~~> Word[0x1001f79c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11222000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001f790, (wrb) a4  <-- 0x1001f7a0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11223000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001f7a0, a3  = 0x1001f7c0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11224000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001f7a0, 0 ~~> Word[0x1001f7a0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11225000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001f7a0, 0 ~~> Word[0x1001f7a4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11226000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001f7a0, 0 ~~> Word[0x1001f7a8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11227000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001f7a0, 0 ~~> Word[0x1001f7ac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11228000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001f7a0, (wrb) a4  <-- 0x1001f7b0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11229000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001f7b0, a3  = 0x1001f7c0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11230000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001f7b0, 0 ~~> Word[0x1001f7b0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11231000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001f7b0, 0 ~~> Word[0x1001f7b4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11233000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001f7b0, 0 ~~> Word[0x1001f7b8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11235000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001f7b0, 0 ~~> Word[0x1001f7bc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11236000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001f7b0, (wrb) a4  <-- 0x1001f7c0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11237000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001f7c0, a3  = 0x1001f7c0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
          11238000    0x80004270 bnez a2, 8                     #; a2  = 4, taken, goto 0x80004278
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
          11239000    0x80004278 sub a3, t1, a2                 #; t1  = 15, a2  = 4, (wrb) a3  <-- 11
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
          11240000    0x8000427c slli a3, a3, 2                 #; a3  = 11, (wrb) a3  <-- 44
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
          11241000    0x80004280 auipc t0, 0                    #; (wrb) t0  <-- 0x80004280
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
          11242000    0x80004284 add a3, a3, t0                 #; a3  = 44, t0  = 0x80004280, (wrb) a3  <-- 0x800042ac
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
          11243000    0x80004288 jr 12(a3)                      #; a3  = 0x800042ac, goto 0x800042b8
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          11244000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x1001f7c0, 0 ~~> Byte[0x1001f7c3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          11245000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x1001f7c0, 0 ~~> Byte[0x1001f7c2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          11246000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x1001f7c0, 0 ~~> Byte[0x1001f7c1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          11247000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x1001f7c0, 0 ~~> Byte[0x1001f7c0]
#; .Ltable (memset.S:85)
#;   ret
          11248000    0x800042c8 ret                            #; ra  = 0x80003f40, goto 0x80003f40
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
          11251000    0x80003f40 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
          11254000                                              #; (lsu) a0  <-- 0x1001f784
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
          11255000    0x80003f44 addi a0, a0, 1032              #; a0  = 0x1001f784, (wrb) a0  <-- 0x1001fb8c
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
          11256000    0x80003f48 li a1, 0                       #; (wrb) a1  <-- 0
          11257000    0x80003f4c mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
          11258000    0x80003f50 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f50
          11259000    0x80003f54 jalr 740(ra)                   #; ra  = 0x80003f50, (wrb) ra  <-- 0x80003f58, goto 0x80004234
#; memset (memset.S:30)
#;   li t1, 15
          11260000    0x80004234 li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
          11261000    0x80004238 mv a4, a0                      #; a0  = 0x1001fb8c, (wrb) a4  <-- 0x1001fb8c
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
          11262000    0x8000423c bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
          11263000    0x80004240 andi a5, a4, 15                #; a4  = 0x1001fb8c, (wrb) a5  <-- 12
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
          11264000    0x80004244 bnez a5, 160                   #; a5  = 12, taken, goto 0x800042e4
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
          11265000    0x800042e4 slli a3, a5, 2                 #; a5  = 12, (wrb) a3  <-- 48
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
          11266000    0x800042e8 auipc t0, 0                    #; (wrb) t0  <-- 0x800042e8
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
          11267000    0x800042ec add a3, a3, t0                 #; a3  = 48, t0  = 0x800042e8, (wrb) a3  <-- 0x80004318
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
          11268000    0x800042f0 mv t0, ra                      #; ra  = 0x80003f58, (wrb) t0  <-- 0x80003f58
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
          11269000    0x800042f4 jalr -96(a3)                   #; a3  = 0x80004318, (wrb) ra  <-- 0x800042f8, goto 0x800042b8
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          11270000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x1001fb8c, 0 ~~> Byte[0x1001fb8f]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          11271000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x1001fb8c, 0 ~~> Byte[0x1001fb8e]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          11272000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x1001fb8c, 0 ~~> Byte[0x1001fb8d]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          11273000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x1001fb8c, 0 ~~> Byte[0x1001fb8c]
#; .Ltable (memset.S:85)
#;   ret
          11274000    0x800042c8 ret                            #; ra  = 0x800042f8, goto 0x800042f8
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
          11275000    0x800042f8 mv ra, t0                      #; t0  = 0x80003f58, (wrb) ra  <-- 0x80003f58
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
          11276000    0x800042fc addi a5, a5, -16               #; a5  = 12, (wrb) a5  <-- -4
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
          11277000    0x80004300 sub a4, a4, a5                 #; a4  = 0x1001fb8c, a5  = -4, (wrb) a4  <-- 0x1001fb90
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
          11278000    0x80004304 add a2, a2, a5                 #; a2  = 64, a5  = -4, (wrb) a2  <-- 60
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
          11279000    0x80004308 bgeu t1, a2, -144              #; t1  = 15, a2  = 60, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
          11280000    0x8000430c j -196                         #; goto 0x80004248
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
          11281000    0x80004248 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
          11282000    0x8000424c andi a3, a2, -16               #; a2  = 60, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
          11283000    0x80004250 andi a2, a2, 15                #; a2  = 60, (wrb) a2  <-- 12
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
          11284000    0x80004254 add a3, a3, a4                 #; a3  = 48, a4  = 0x1001fb90, (wrb) a3  <-- 0x1001fbc0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11285000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001fb90, 0 ~~> Word[0x1001fb90]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11286000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001fb90, 0 ~~> Word[0x1001fb94]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11287000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001fb90, 0 ~~> Word[0x1001fb98]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11288000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001fb90, 0 ~~> Word[0x1001fb9c]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11289000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001fb90, (wrb) a4  <-- 0x1001fba0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11290000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001fba0, a3  = 0x1001fbc0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11291000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001fba0, 0 ~~> Word[0x1001fba0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11292000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001fba0, 0 ~~> Word[0x1001fba4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11293000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001fba0, 0 ~~> Word[0x1001fba8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11294000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001fba0, 0 ~~> Word[0x1001fbac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11295000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001fba0, (wrb) a4  <-- 0x1001fbb0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11296000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001fbb0, a3  = 0x1001fbc0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11297000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001fbb0, 0 ~~> Word[0x1001fbb0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11298000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001fbb0, 0 ~~> Word[0x1001fbb4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11300000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001fbb0, 0 ~~> Word[0x1001fbb8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11302000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001fbb0, 0 ~~> Word[0x1001fbbc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11303000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001fbb0, (wrb) a4  <-- 0x1001fbc0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11304000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001fbc0, a3  = 0x1001fbc0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
          11305000    0x80004270 bnez a2, 8                     #; a2  = 12, taken, goto 0x80004278
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
          11306000    0x80004278 sub a3, t1, a2                 #; t1  = 15, a2  = 12, (wrb) a3  <-- 3
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
          11307000    0x8000427c slli a3, a3, 2                 #; a3  = 3, (wrb) a3  <-- 12
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
          11308000    0x80004280 auipc t0, 0                    #; (wrb) t0  <-- 0x80004280
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
          11309000    0x80004284 add a3, a3, t0                 #; a3  = 12, t0  = 0x80004280, (wrb) a3  <-- 0x8000428c
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
          11310000    0x80004288 jr 12(a3)                      #; a3  = 0x8000428c, goto 0x80004298
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
          11311000    0x80004298 sb a1, 11(a4)                  #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbcb]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
          11312000    0x8000429c sb a1, 10(a4)                  #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbca]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
          11313000    0x800042a0 sb a1, 9(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc9]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
          11314000    0x800042a4 sb a1, 8(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc8]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
          11315000    0x800042a8 sb a1, 7(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc7]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
          11316000    0x800042ac sb a1, 6(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc6]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
          11317000    0x800042b0 sb a1, 5(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc5]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
          11318000    0x800042b4 sb a1, 4(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc4]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          11319000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          11320000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          11321000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          11322000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x1001fbc0, 0 ~~> Byte[0x1001fbc0]
#; .Ltable (memset.S:85)
#;   ret
          11323000    0x800042c8 ret                            #; ra  = 0x80003f58, goto 0x80003f58
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
          11324000    0x80003f58 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
          11327000                                              #; (lsu) a0  <-- 0x1001f784
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
          11328000    0x80003f5c add a0, a0, s1                 #; a0  = 0x1001f784, s1  = 2064, (wrb) a0  <-- 0x1001ff94
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
          11329000    0x80003f60 li a1, 0                       #; (wrb) a1  <-- 0
          11330000    0x80003f64 mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
          11331000    0x80003f68 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f68
          11332000    0x80003f6c jalr 716(ra)                   #; ra  = 0x80003f68, (wrb) ra  <-- 0x80003f70, goto 0x80004234
#; memset (memset.S:30)
#;   li t1, 15
          11333000    0x80004234 li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
          11334000    0x80004238 mv a4, a0                      #; a0  = 0x1001ff94, (wrb) a4  <-- 0x1001ff94
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
          11335000    0x8000423c bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
          11336000    0x80004240 andi a5, a4, 15                #; a4  = 0x1001ff94, (wrb) a5  <-- 4
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
          11337000    0x80004244 bnez a5, 160                   #; a5  = 4, taken, goto 0x800042e4
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
          11338000    0x800042e4 slli a3, a5, 2                 #; a5  = 4, (wrb) a3  <-- 16
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
          11339000    0x800042e8 auipc t0, 0                    #; (wrb) t0  <-- 0x800042e8
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
          11340000    0x800042ec add a3, a3, t0                 #; a3  = 16, t0  = 0x800042e8, (wrb) a3  <-- 0x800042f8
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
          11341000    0x800042f0 mv t0, ra                      #; ra  = 0x80003f70, (wrb) t0  <-- 0x80003f70
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
          11342000    0x800042f4 jalr -96(a3)                   #; a3  = 0x800042f8, (wrb) ra  <-- 0x800042f8, goto 0x80004298
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
          11343000    0x80004298 sb a1, 11(a4)                  #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9f]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
          11344000    0x8000429c sb a1, 10(a4)                  #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9e]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
          11345000    0x800042a0 sb a1, 9(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9d]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
          11346000    0x800042a4 sb a1, 8(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9c]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
          11347000    0x800042a8 sb a1, 7(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9b]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
          11348000    0x800042ac sb a1, 6(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff9a]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
          11349000    0x800042b0 sb a1, 5(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff99]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
          11350000    0x800042b4 sb a1, 4(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff98]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          11351000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff97]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          11352000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff96]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          11354000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff95]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          11355000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x1001ff94, 0 ~~> Byte[0x1001ff94]
#; .Ltable (memset.S:85)
#;   ret
          11356000    0x800042c8 ret                            #; ra  = 0x800042f8, goto 0x800042f8
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
          11357000    0x800042f8 mv ra, t0                      #; t0  = 0x80003f70, (wrb) ra  <-- 0x80003f70
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
          11358000    0x800042fc addi a5, a5, -16               #; a5  = 4, (wrb) a5  <-- -12
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
          11359000    0x80004300 sub a4, a4, a5                 #; a4  = 0x1001ff94, a5  = -12, (wrb) a4  <-- 0x1001ffa0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
          11360000    0x80004304 add a2, a2, a5                 #; a2  = 64, a5  = -12, (wrb) a2  <-- 52
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
          11361000    0x80004308 bgeu t1, a2, -144              #; t1  = 15, a2  = 52, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
          11362000    0x8000430c j -196                         #; goto 0x80004248
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
          11363000    0x80004248 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
          11364000    0x8000424c andi a3, a2, -16               #; a2  = 52, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
          11365000    0x80004250 andi a2, a2, 15                #; a2  = 52, (wrb) a2  <-- 4
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
          11366000    0x80004254 add a3, a3, a4                 #; a3  = 48, a4  = 0x1001ffa0, (wrb) a3  <-- 0x1001ffd0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11367000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001ffa0, 0 ~~> Word[0x1001ffa0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11368000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001ffa0, 0 ~~> Word[0x1001ffa4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11369000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001ffa0, 0 ~~> Word[0x1001ffa8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11370000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001ffa0, 0 ~~> Word[0x1001ffac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11371000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001ffa0, (wrb) a4  <-- 0x1001ffb0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11372000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001ffb0, a3  = 0x1001ffd0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11373000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001ffb0, 0 ~~> Word[0x1001ffb0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11374000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001ffb0, 0 ~~> Word[0x1001ffb4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11375000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001ffb0, 0 ~~> Word[0x1001ffb8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11376000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001ffb0, 0 ~~> Word[0x1001ffbc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11377000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001ffb0, (wrb) a4  <-- 0x1001ffc0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11378000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001ffc0, a3  = 0x1001ffd0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11379000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x1001ffc0, 0 ~~> Word[0x1001ffc0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11380000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x1001ffc0, 0 ~~> Word[0x1001ffc4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11381000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x1001ffc0, 0 ~~> Word[0x1001ffc8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11382000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x1001ffc0, 0 ~~> Word[0x1001ffcc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11383000    0x80004268 addi a4, a4, 16                #; a4  = 0x1001ffc0, (wrb) a4  <-- 0x1001ffd0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11384000    0x8000426c bltu a4, a3, -20               #; a4  = 0x1001ffd0, a3  = 0x1001ffd0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
          11385000    0x80004270 bnez a2, 8                     #; a2  = 4, taken, goto 0x80004278
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
          11386000    0x80004278 sub a3, t1, a2                 #; t1  = 15, a2  = 4, (wrb) a3  <-- 11
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
          11387000    0x8000427c slli a3, a3, 2                 #; a3  = 11, (wrb) a3  <-- 44
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
          11388000    0x80004280 auipc t0, 0                    #; (wrb) t0  <-- 0x80004280
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
          11389000    0x80004284 add a3, a3, t0                 #; a3  = 44, t0  = 0x80004280, (wrb) a3  <-- 0x800042ac
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
          11390000    0x80004288 jr 12(a3)                      #; a3  = 0x800042ac, goto 0x800042b8
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          11391000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x1001ffd0, 0 ~~> Byte[0x1001ffd3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          11392000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x1001ffd0, 0 ~~> Byte[0x1001ffd2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          11393000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x1001ffd0, 0 ~~> Byte[0x1001ffd1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          11394000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x1001ffd0, 0 ~~> Byte[0x1001ffd0]
#; .Ltable (memset.S:85)
#;   ret
          11395000    0x800042c8 ret                            #; ra  = 0x80003f70, goto 0x80003f70
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
          11396000    0x80003f70 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
          11399000                                              #; (lsu) a0  <-- 0x1001f784
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
          11400000    0x80003f74 add a0, a0, s6                 #; a0  = 0x1001f784, s6  = 3096, (wrb) a0  <-- 0x1002039c
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
          11401000    0x80003f78 li a1, 0                       #; (wrb) a1  <-- 0
          11402000    0x80003f7c mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
          11405000    0x80003f80 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f80
          11406000    0x80003f84 jalr 692(ra)                   #; ra  = 0x80003f80, (wrb) ra  <-- 0x80003f88, goto 0x80004234
#; memset (memset.S:30)
#;   li t1, 15
          11407000    0x80004234 li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
          11408000    0x80004238 mv a4, a0                      #; a0  = 0x1002039c, (wrb) a4  <-- 0x1002039c
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
          11409000    0x8000423c bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
          11410000    0x80004240 andi a5, a4, 15                #; a4  = 0x1002039c, (wrb) a5  <-- 12
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
          11411000    0x80004244 bnez a5, 160                   #; a5  = 12, taken, goto 0x800042e4
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
          11412000    0x800042e4 slli a3, a5, 2                 #; a5  = 12, (wrb) a3  <-- 48
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
          11413000    0x800042e8 auipc t0, 0                    #; (wrb) t0  <-- 0x800042e8
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
          11414000    0x800042ec add a3, a3, t0                 #; a3  = 48, t0  = 0x800042e8, (wrb) a3  <-- 0x80004318
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
          11415000    0x800042f0 mv t0, ra                      #; ra  = 0x80003f88, (wrb) t0  <-- 0x80003f88
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
          11416000    0x800042f4 jalr -96(a3)                   #; a3  = 0x80004318, (wrb) ra  <-- 0x800042f8, goto 0x800042b8
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          11417000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x1002039c, 0 ~~> Byte[0x1002039f]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          11418000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x1002039c, 0 ~~> Byte[0x1002039e]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          11432000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x1002039c, 0 ~~> Byte[0x1002039d]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          11443000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x1002039c, 0 ~~> Byte[0x1002039c]
#; .Ltable (memset.S:85)
#;   ret
          11444000    0x800042c8 ret                            #; ra  = 0x800042f8, goto 0x800042f8
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
          11445000    0x800042f8 mv ra, t0                      #; t0  = 0x80003f88, (wrb) ra  <-- 0x80003f88
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
          11446000    0x800042fc addi a5, a5, -16               #; a5  = 12, (wrb) a5  <-- -4
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
          11447000    0x80004300 sub a4, a4, a5                 #; a4  = 0x1002039c, a5  = -4, (wrb) a4  <-- 0x100203a0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
          11448000    0x80004304 add a2, a2, a5                 #; a2  = 64, a5  = -4, (wrb) a2  <-- 60
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
          11449000    0x80004308 bgeu t1, a2, -144              #; t1  = 15, a2  = 60, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
          11450000    0x8000430c j -196                         #; goto 0x80004248
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
          11451000    0x80004248 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
          11452000    0x8000424c andi a3, a2, -16               #; a2  = 60, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
          11453000    0x80004250 andi a2, a2, 15                #; a2  = 60, (wrb) a2  <-- 12
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
          11454000    0x80004254 add a3, a3, a4                 #; a3  = 48, a4  = 0x100203a0, (wrb) a3  <-- 0x100203d0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11462000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x100203a0, 0 ~~> Word[0x100203a0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11482000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x100203a0, 0 ~~> Word[0x100203a4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11502000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x100203a0, 0 ~~> Word[0x100203a8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11522000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x100203a0, 0 ~~> Word[0x100203ac]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11523000    0x80004268 addi a4, a4, 16                #; a4  = 0x100203a0, (wrb) a4  <-- 0x100203b0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11524000    0x8000426c bltu a4, a3, -20               #; a4  = 0x100203b0, a3  = 0x100203d0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11533000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x100203b0, 0 ~~> Word[0x100203b0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11553000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x100203b0, 0 ~~> Word[0x100203b4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11582000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x100203b0, 0 ~~> Word[0x100203b8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11603000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x100203b0, 0 ~~> Word[0x100203bc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11604000    0x80004268 addi a4, a4, 16                #; a4  = 0x100203b0, (wrb) a4  <-- 0x100203c0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11605000    0x8000426c bltu a4, a3, -20               #; a4  = 0x100203c0, a3  = 0x100203d0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          11633000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x100203c0, 0 ~~> Word[0x100203c0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          11673000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x100203c0, 0 ~~> Word[0x100203c4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          11713000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x100203c0, 0 ~~> Word[0x100203c8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          11753000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x100203c0, 0 ~~> Word[0x100203cc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          11754000    0x80004268 addi a4, a4, 16                #; a4  = 0x100203c0, (wrb) a4  <-- 0x100203d0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          11755000    0x8000426c bltu a4, a3, -20               #; a4  = 0x100203d0, a3  = 0x100203d0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
          11756000    0x80004270 bnez a2, 8                     #; a2  = 12, taken, goto 0x80004278
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
          11757000    0x80004278 sub a3, t1, a2                 #; t1  = 15, a2  = 12, (wrb) a3  <-- 3
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
          11758000    0x8000427c slli a3, a3, 2                 #; a3  = 3, (wrb) a3  <-- 12
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
          11759000    0x80004280 auipc t0, 0                    #; (wrb) t0  <-- 0x80004280
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
          11760000    0x80004284 add a3, a3, t0                 #; a3  = 12, t0  = 0x80004280, (wrb) a3  <-- 0x8000428c
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
          11761000    0x80004288 jr 12(a3)                      #; a3  = 0x8000428c, goto 0x80004298
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
          11793000    0x80004298 sb a1, 11(a4)                  #; a4  = 0x100203d0, 0 ~~> Byte[0x100203db]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
          11833000    0x8000429c sb a1, 10(a4)                  #; a4  = 0x100203d0, 0 ~~> Byte[0x100203da]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
          11873000    0x800042a0 sb a1, 9(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d9]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
          11913000    0x800042a4 sb a1, 8(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d8]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
          11953000    0x800042a8 sb a1, 7(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d7]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
          11993000    0x800042ac sb a1, 6(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d6]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
          12033000    0x800042b0 sb a1, 5(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d5]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
          12073000    0x800042b4 sb a1, 4(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d4]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          12113000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          12153000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          12193000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          12233000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x100203d0, 0 ~~> Byte[0x100203d0]
#; .Ltable (memset.S:85)
#;   ret
          12234000    0x800042c8 ret                            #; ra  = 0x80003f88, goto 0x80003f88
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
          12273000    0x80003f88 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
          12323000                                              #; (lsu) a0  <-- 0x1001f784
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
          12324000    0x80003f8c add a0, a0, s7                 #; a0  = 0x1001f784, s7  = 4128, (wrb) a0  <-- 0x100207a4
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
          12325000    0x80003f90 li a1, 0                       #; (wrb) a1  <-- 0
          12326000    0x80003f94 mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
          12327000    0x80003f98 auipc ra, 0                    #; (wrb) ra  <-- 0x80003f98
          12328000    0x80003f9c jalr 668(ra)                   #; ra  = 0x80003f98, (wrb) ra  <-- 0x80003fa0, goto 0x80004234
#; memset (memset.S:30)
#;   li t1, 15
          12329000    0x80004234 li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
          12330000    0x80004238 mv a4, a0                      #; a0  = 0x100207a4, (wrb) a4  <-- 0x100207a4
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
          12331000    0x8000423c bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
          12332000    0x80004240 andi a5, a4, 15                #; a4  = 0x100207a4, (wrb) a5  <-- 4
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
          12333000    0x80004244 bnez a5, 160                   #; a5  = 4, taken, goto 0x800042e4
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
          12334000    0x800042e4 slli a3, a5, 2                 #; a5  = 4, (wrb) a3  <-- 16
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
          12335000    0x800042e8 auipc t0, 0                    #; (wrb) t0  <-- 0x800042e8
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
          12336000    0x800042ec add a3, a3, t0                 #; a3  = 16, t0  = 0x800042e8, (wrb) a3  <-- 0x800042f8
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
          12337000    0x800042f0 mv t0, ra                      #; ra  = 0x80003fa0, (wrb) t0  <-- 0x80003fa0
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
          12338000    0x800042f4 jalr -96(a3)                   #; a3  = 0x800042f8, (wrb) ra  <-- 0x800042f8, goto 0x80004298
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
          12339000    0x80004298 sb a1, 11(a4)                  #; a4  = 0x100207a4, 0 ~~> Byte[0x100207af]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
          12340000    0x8000429c sb a1, 10(a4)                  #; a4  = 0x100207a4, 0 ~~> Byte[0x100207ae]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
          12353000    0x800042a0 sb a1, 9(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207ad]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
          12393000    0x800042a4 sb a1, 8(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207ac]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
          12433000    0x800042a8 sb a1, 7(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207ab]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
          12473000    0x800042ac sb a1, 6(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207aa]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
          12513000    0x800042b0 sb a1, 5(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207a9]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
          12553000    0x800042b4 sb a1, 4(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207a8]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          12593000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207a7]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          12633000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207a6]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          12673000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207a5]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          12713000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x100207a4, 0 ~~> Byte[0x100207a4]
#; .Ltable (memset.S:85)
#;   ret
          12714000    0x800042c8 ret                            #; ra  = 0x800042f8, goto 0x800042f8
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
          12715000    0x800042f8 mv ra, t0                      #; t0  = 0x80003fa0, (wrb) ra  <-- 0x80003fa0
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
          12716000    0x800042fc addi a5, a5, -16               #; a5  = 4, (wrb) a5  <-- -12
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
          12717000    0x80004300 sub a4, a4, a5                 #; a4  = 0x100207a4, a5  = -12, (wrb) a4  <-- 0x100207b0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
          12718000    0x80004304 add a2, a2, a5                 #; a2  = 64, a5  = -12, (wrb) a2  <-- 52
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
          12719000    0x80004308 bgeu t1, a2, -144              #; t1  = 15, a2  = 52, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
          12720000    0x8000430c j -196                         #; goto 0x80004248
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
          12721000    0x80004248 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
          12722000    0x8000424c andi a3, a2, -16               #; a2  = 52, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
          12723000    0x80004250 andi a2, a2, 15                #; a2  = 52, (wrb) a2  <-- 4
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
          12724000    0x80004254 add a3, a3, a4                 #; a3  = 48, a4  = 0x100207b0, (wrb) a3  <-- 0x100207e0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          12753000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x100207b0, 0 ~~> Word[0x100207b0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          12792000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x100207b0, 0 ~~> Word[0x100207b4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          12823000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x100207b0, 0 ~~> Word[0x100207b8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          12862000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x100207b0, 0 ~~> Word[0x100207bc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          12863000    0x80004268 addi a4, a4, 16                #; a4  = 0x100207b0, (wrb) a4  <-- 0x100207c0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          12864000    0x8000426c bltu a4, a3, -20               #; a4  = 0x100207c0, a3  = 0x100207e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          12893000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x100207c0, 0 ~~> Word[0x100207c0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          12932000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x100207c0, 0 ~~> Word[0x100207c4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          12963000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x100207c0, 0 ~~> Word[0x100207c8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          13002000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x100207c0, 0 ~~> Word[0x100207cc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          13003000    0x80004268 addi a4, a4, 16                #; a4  = 0x100207c0, (wrb) a4  <-- 0x100207d0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          13004000    0x8000426c bltu a4, a3, -20               #; a4  = 0x100207d0, a3  = 0x100207e0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          13033000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x100207d0, 0 ~~> Word[0x100207d0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          13072000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x100207d0, 0 ~~> Word[0x100207d4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          13103000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x100207d0, 0 ~~> Word[0x100207d8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          13142000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x100207d0, 0 ~~> Word[0x100207dc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          13143000    0x80004268 addi a4, a4, 16                #; a4  = 0x100207d0, (wrb) a4  <-- 0x100207e0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          13144000    0x8000426c bltu a4, a3, -20               #; a4  = 0x100207e0, a3  = 0x100207e0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
          13145000    0x80004270 bnez a2, 8                     #; a2  = 4, taken, goto 0x80004278
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
          13146000    0x80004278 sub a3, t1, a2                 #; t1  = 15, a2  = 4, (wrb) a3  <-- 11
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
          13147000    0x8000427c slli a3, a3, 2                 #; a3  = 11, (wrb) a3  <-- 44
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
          13148000    0x80004280 auipc t0, 0                    #; (wrb) t0  <-- 0x80004280
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
          13149000    0x80004284 add a3, a3, t0                 #; a3  = 44, t0  = 0x80004280, (wrb) a3  <-- 0x800042ac
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
          13150000    0x80004288 jr 12(a3)                      #; a3  = 0x800042ac, goto 0x800042b8
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          13173000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x100207e0, 0 ~~> Byte[0x100207e3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          13212000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x100207e0, 0 ~~> Byte[0x100207e2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          13243000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x100207e0, 0 ~~> Byte[0x100207e1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          13282000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x100207e0, 0 ~~> Byte[0x100207e0]
#; .Ltable (memset.S:85)
#;   ret
          13283000    0x800042c8 ret                            #; ra  = 0x80003fa0, goto 0x80003fa0
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
          13313000    0x80003fa0 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
          13362000                                              #; (lsu) a0  <-- 0x1001f784
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
          13363000    0x80003fa4 add a0, a0, s8                 #; a0  = 0x1001f784, s8  = 5160, (wrb) a0  <-- 0x10020bac
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
          13364000    0x80003fa8 li a1, 0                       #; (wrb) a1  <-- 0
          13365000    0x80003fac mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
          13366000    0x80003fb0 auipc ra, 0                    #; (wrb) ra  <-- 0x80003fb0
          13367000    0x80003fb4 jalr 644(ra)                   #; ra  = 0x80003fb0, (wrb) ra  <-- 0x80003fb8, goto 0x80004234
#; memset (memset.S:30)
#;   li t1, 15
          13368000    0x80004234 li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
          13369000    0x80004238 mv a4, a0                      #; a0  = 0x10020bac, (wrb) a4  <-- 0x10020bac
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
          13370000    0x8000423c bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
          13371000    0x80004240 andi a5, a4, 15                #; a4  = 0x10020bac, (wrb) a5  <-- 12
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
          13372000    0x80004244 bnez a5, 160                   #; a5  = 12, taken, goto 0x800042e4
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
          13373000    0x800042e4 slli a3, a5, 2                 #; a5  = 12, (wrb) a3  <-- 48
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
          13374000    0x800042e8 auipc t0, 0                    #; (wrb) t0  <-- 0x800042e8
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
          13375000    0x800042ec add a3, a3, t0                 #; a3  = 48, t0  = 0x800042e8, (wrb) a3  <-- 0x80004318
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
          13376000    0x800042f0 mv t0, ra                      #; ra  = 0x80003fb8, (wrb) t0  <-- 0x80003fb8
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
          13377000    0x800042f4 jalr -96(a3)                   #; a3  = 0x80004318, (wrb) ra  <-- 0x800042f8, goto 0x800042b8
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          13378000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x10020bac, 0 ~~> Byte[0x10020baf]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          13379000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x10020bac, 0 ~~> Byte[0x10020bae]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          13383000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x10020bac, 0 ~~> Byte[0x10020bad]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          13422000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x10020bac, 0 ~~> Byte[0x10020bac]
#; .Ltable (memset.S:85)
#;   ret
          13423000    0x800042c8 ret                            #; ra  = 0x800042f8, goto 0x800042f8
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
          13424000    0x800042f8 mv ra, t0                      #; t0  = 0x80003fb8, (wrb) ra  <-- 0x80003fb8
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
          13425000    0x800042fc addi a5, a5, -16               #; a5  = 12, (wrb) a5  <-- -4
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
          13426000    0x80004300 sub a4, a4, a5                 #; a4  = 0x10020bac, a5  = -4, (wrb) a4  <-- 0x10020bb0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
          13427000    0x80004304 add a2, a2, a5                 #; a2  = 64, a5  = -4, (wrb) a2  <-- 60
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
          13428000    0x80004308 bgeu t1, a2, -144              #; t1  = 15, a2  = 60, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
          13429000    0x8000430c j -196                         #; goto 0x80004248
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
          13430000    0x80004248 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
          13431000    0x8000424c andi a3, a2, -16               #; a2  = 60, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
          13432000    0x80004250 andi a2, a2, 15                #; a2  = 60, (wrb) a2  <-- 12
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
          13433000    0x80004254 add a3, a3, a4                 #; a3  = 48, a4  = 0x10020bb0, (wrb) a3  <-- 0x10020be0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          13453000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x10020bb0, 0 ~~> Word[0x10020bb0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          13492000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x10020bb0, 0 ~~> Word[0x10020bb4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          13523000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x10020bb0, 0 ~~> Word[0x10020bb8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          13562000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x10020bb0, 0 ~~> Word[0x10020bbc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          13563000    0x80004268 addi a4, a4, 16                #; a4  = 0x10020bb0, (wrb) a4  <-- 0x10020bc0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          13564000    0x8000426c bltu a4, a3, -20               #; a4  = 0x10020bc0, a3  = 0x10020be0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          13593000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x10020bc0, 0 ~~> Word[0x10020bc0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          13632000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x10020bc0, 0 ~~> Word[0x10020bc4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          13663000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x10020bc0, 0 ~~> Word[0x10020bc8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          13702000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x10020bc0, 0 ~~> Word[0x10020bcc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          13703000    0x80004268 addi a4, a4, 16                #; a4  = 0x10020bc0, (wrb) a4  <-- 0x10020bd0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          13704000    0x8000426c bltu a4, a3, -20               #; a4  = 0x10020bd0, a3  = 0x10020be0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          13733000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x10020bd0, 0 ~~> Word[0x10020bd0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          13763000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x10020bd0, 0 ~~> Word[0x10020bd4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          13793000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x10020bd0, 0 ~~> Word[0x10020bd8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          13823000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x10020bd0, 0 ~~> Word[0x10020bdc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          13824000    0x80004268 addi a4, a4, 16                #; a4  = 0x10020bd0, (wrb) a4  <-- 0x10020be0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          13825000    0x8000426c bltu a4, a3, -20               #; a4  = 0x10020be0, a3  = 0x10020be0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
          13826000    0x80004270 bnez a2, 8                     #; a2  = 12, taken, goto 0x80004278
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
          13827000    0x80004278 sub a3, t1, a2                 #; t1  = 15, a2  = 12, (wrb) a3  <-- 3
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
          13828000    0x8000427c slli a3, a3, 2                 #; a3  = 3, (wrb) a3  <-- 12
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
          13829000    0x80004280 auipc t0, 0                    #; (wrb) t0  <-- 0x80004280
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
          13830000    0x80004284 add a3, a3, t0                 #; a3  = 12, t0  = 0x80004280, (wrb) a3  <-- 0x8000428c
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
          13831000    0x80004288 jr 12(a3)                      #; a3  = 0x8000428c, goto 0x80004298
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
          13853000    0x80004298 sb a1, 11(a4)                  #; a4  = 0x10020be0, 0 ~~> Byte[0x10020beb]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
          13883000    0x8000429c sb a1, 10(a4)                  #; a4  = 0x10020be0, 0 ~~> Byte[0x10020bea]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
          13913000    0x800042a0 sb a1, 9(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be9]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
          13943000    0x800042a4 sb a1, 8(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be8]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
          13973000    0x800042a8 sb a1, 7(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be7]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
          14003000    0x800042ac sb a1, 6(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be6]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
          14033000    0x800042b0 sb a1, 5(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be5]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
          14063000    0x800042b4 sb a1, 4(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be4]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          14092000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          14122000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          14152000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          14182000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x10020be0, 0 ~~> Byte[0x10020be0]
#; .Ltable (memset.S:85)
#;   ret
          14183000    0x800042c8 ret                            #; ra  = 0x80003fb8, goto 0x80003fb8
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
          14212000    0x80003fb8 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
          14252000                                              #; (lsu) a0  <-- 0x1001f784
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
          14253000    0x80003fbc add a0, a0, s9                 #; a0  = 0x1001f784, s9  = 6192, (wrb) a0  <-- 0x10020fb4
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
          14256000    0x80003fc0 li a1, 0                       #; (wrb) a1  <-- 0
          14257000    0x80003fc4 mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
          14258000    0x80003fc8 auipc ra, 0                    #; (wrb) ra  <-- 0x80003fc8
          14259000    0x80003fcc jalr 620(ra)                   #; ra  = 0x80003fc8, (wrb) ra  <-- 0x80003fd0, goto 0x80004234
#; memset (memset.S:30)
#;   li t1, 15
          14260000    0x80004234 li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
          14261000    0x80004238 mv a4, a0                      #; a0  = 0x10020fb4, (wrb) a4  <-- 0x10020fb4
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
          14262000    0x8000423c bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
          14263000    0x80004240 andi a5, a4, 15                #; a4  = 0x10020fb4, (wrb) a5  <-- 4
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
          14264000    0x80004244 bnez a5, 160                   #; a5  = 4, taken, goto 0x800042e4
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
          14265000    0x800042e4 slli a3, a5, 2                 #; a5  = 4, (wrb) a3  <-- 16
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
          14266000    0x800042e8 auipc t0, 0                    #; (wrb) t0  <-- 0x800042e8
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
          14267000    0x800042ec add a3, a3, t0                 #; a3  = 16, t0  = 0x800042e8, (wrb) a3  <-- 0x800042f8
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
          14268000    0x800042f0 mv t0, ra                      #; ra  = 0x80003fd0, (wrb) t0  <-- 0x80003fd0
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
          14269000    0x800042f4 jalr -96(a3)                   #; a3  = 0x800042f8, (wrb) ra  <-- 0x800042f8, goto 0x80004298
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
          14270000    0x80004298 sb a1, 11(a4)                  #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fbf]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
          14271000    0x8000429c sb a1, 10(a4)                  #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fbe]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
          14293000    0x800042a0 sb a1, 9(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fbd]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
          14323000    0x800042a4 sb a1, 8(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fbc]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
          14352000    0x800042a8 sb a1, 7(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fbb]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
          14382000    0x800042ac sb a1, 6(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fba]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
          14412000    0x800042b0 sb a1, 5(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fb9]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
          14442000    0x800042b4 sb a1, 4(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fb8]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          14463000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fb7]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          14489000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fb6]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          14522000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fb5]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          14547000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x10020fb4, 0 ~~> Byte[0x10020fb4]
#; .Ltable (memset.S:85)
#;   ret
          14548000    0x800042c8 ret                            #; ra  = 0x800042f8, goto 0x800042f8
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
          14549000    0x800042f8 mv ra, t0                      #; t0  = 0x80003fd0, (wrb) ra  <-- 0x80003fd0
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
          14550000    0x800042fc addi a5, a5, -16               #; a5  = 4, (wrb) a5  <-- -12
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
          14553000    0x80004300 sub a4, a4, a5                 #; a4  = 0x10020fb4, a5  = -12, (wrb) a4  <-- 0x10020fc0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
          14554000    0x80004304 add a2, a2, a5                 #; a2  = 64, a5  = -12, (wrb) a2  <-- 52
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
          14555000    0x80004308 bgeu t1, a2, -144              #; t1  = 15, a2  = 52, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
          14556000    0x8000430c j -196                         #; goto 0x80004248
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
          14557000    0x80004248 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
          14558000    0x8000424c andi a3, a2, -16               #; a2  = 52, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
          14559000    0x80004250 andi a2, a2, 15                #; a2  = 52, (wrb) a2  <-- 4
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
          14560000    0x80004254 add a3, a3, a4                 #; a3  = 48, a4  = 0x10020fc0, (wrb) a3  <-- 0x10020ff0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          14572000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x10020fc0, 0 ~~> Word[0x10020fc0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          14597000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x10020fc0, 0 ~~> Word[0x10020fc4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          14622000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x10020fc0, 0 ~~> Word[0x10020fc8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          14647000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x10020fc0, 0 ~~> Word[0x10020fcc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          14648000    0x80004268 addi a4, a4, 16                #; a4  = 0x10020fc0, (wrb) a4  <-- 0x10020fd0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          14649000    0x8000426c bltu a4, a3, -20               #; a4  = 0x10020fd0, a3  = 0x10020ff0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          14672000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x10020fd0, 0 ~~> Word[0x10020fd0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          14697000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x10020fd0, 0 ~~> Word[0x10020fd4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          14722000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x10020fd0, 0 ~~> Word[0x10020fd8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          14747000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x10020fd0, 0 ~~> Word[0x10020fdc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          14748000    0x80004268 addi a4, a4, 16                #; a4  = 0x10020fd0, (wrb) a4  <-- 0x10020fe0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          14749000    0x8000426c bltu a4, a3, -20               #; a4  = 0x10020fe0, a3  = 0x10020ff0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          14772000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x10020fe0, 0 ~~> Word[0x10020fe0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          14797000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x10020fe0, 0 ~~> Word[0x10020fe4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          14822000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x10020fe0, 0 ~~> Word[0x10020fe8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          14847000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x10020fe0, 0 ~~> Word[0x10020fec]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          14848000    0x80004268 addi a4, a4, 16                #; a4  = 0x10020fe0, (wrb) a4  <-- 0x10020ff0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          14849000    0x8000426c bltu a4, a3, -20               #; a4  = 0x10020ff0, a3  = 0x10020ff0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
          14850000    0x80004270 bnez a2, 8                     #; a2  = 4, taken, goto 0x80004278
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
          14851000    0x80004278 sub a3, t1, a2                 #; t1  = 15, a2  = 4, (wrb) a3  <-- 11
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
          14852000    0x8000427c slli a3, a3, 2                 #; a3  = 11, (wrb) a3  <-- 44
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
          14853000    0x80004280 auipc t0, 0                    #; (wrb) t0  <-- 0x80004280
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
          14854000    0x80004284 add a3, a3, t0                 #; a3  = 44, t0  = 0x80004280, (wrb) a3  <-- 0x800042ac
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
          14855000    0x80004288 jr 12(a3)                      #; a3  = 0x800042ac, goto 0x800042b8
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          14867000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x10020ff0, 0 ~~> Byte[0x10020ff3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          14895000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x10020ff0, 0 ~~> Byte[0x10020ff2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          14920000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x10020ff0, 0 ~~> Byte[0x10020ff1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          14945000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x10020ff0, 0 ~~> Byte[0x10020ff0]
#; .Ltable (memset.S:85)
#;   ret
          14946000    0x800042c8 ret                            #; ra  = 0x80003fd0, goto 0x80003fd0
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
          14970000    0x80003fd0 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
          15005000                                              #; (lsu) a0  <-- 0x1001f784
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
          15006000    0x80003fd4 add a0, a0, s10                #; a0  = 0x1001f784, s10 = 7224, (wrb) a0  <-- 0x100213bc
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
          15007000    0x80003fd8 li a1, 0                       #; (wrb) a1  <-- 0
          15008000    0x80003fdc mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
          15009000    0x80003fe0 auipc ra, 0                    #; (wrb) ra  <-- 0x80003fe0
          15010000    0x80003fe4 jalr 596(ra)                   #; ra  = 0x80003fe0, (wrb) ra  <-- 0x80003fe8, goto 0x80004234
#; memset (memset.S:30)
#;   li t1, 15
          15011000    0x80004234 li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
          15012000    0x80004238 mv a4, a0                      #; a0  = 0x100213bc, (wrb) a4  <-- 0x100213bc
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
          15013000    0x8000423c bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
          15014000    0x80004240 andi a5, a4, 15                #; a4  = 0x100213bc, (wrb) a5  <-- 12
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
          15015000    0x80004244 bnez a5, 160                   #; a5  = 12, taken, goto 0x800042e4
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
          15016000    0x800042e4 slli a3, a5, 2                 #; a5  = 12, (wrb) a3  <-- 48
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
          15017000    0x800042e8 auipc t0, 0                    #; (wrb) t0  <-- 0x800042e8
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
          15018000    0x800042ec add a3, a3, t0                 #; a3  = 48, t0  = 0x800042e8, (wrb) a3  <-- 0x80004318
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
          15019000    0x800042f0 mv t0, ra                      #; ra  = 0x80003fe8, (wrb) t0  <-- 0x80003fe8
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
          15020000    0x800042f4 jalr -96(a3)                   #; a3  = 0x80004318, (wrb) ra  <-- 0x800042f8, goto 0x800042b8
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          15021000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x100213bc, 0 ~~> Byte[0x100213bf]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          15022000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x100213bc, 0 ~~> Byte[0x100213be]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          15037000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x100213bc, 0 ~~> Byte[0x100213bd]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          15059000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x100213bc, 0 ~~> Byte[0x100213bc]
#; .Ltable (memset.S:85)
#;   ret
          15060000    0x800042c8 ret                            #; ra  = 0x800042f8, goto 0x800042f8
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
          15061000    0x800042f8 mv ra, t0                      #; t0  = 0x80003fe8, (wrb) ra  <-- 0x80003fe8
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
          15062000    0x800042fc addi a5, a5, -16               #; a5  = 12, (wrb) a5  <-- -4
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
          15063000    0x80004300 sub a4, a4, a5                 #; a4  = 0x100213bc, a5  = -4, (wrb) a4  <-- 0x100213c0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
          15064000    0x80004304 add a2, a2, a5                 #; a2  = 64, a5  = -4, (wrb) a2  <-- 60
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
          15065000    0x80004308 bgeu t1, a2, -144              #; t1  = 15, a2  = 60, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
          15066000    0x8000430c j -196                         #; goto 0x80004248
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
          15067000    0x80004248 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
          15068000    0x8000424c andi a3, a2, -16               #; a2  = 60, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
          15069000    0x80004250 andi a2, a2, 15                #; a2  = 60, (wrb) a2  <-- 12
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
          15070000    0x80004254 add a3, a3, a4                 #; a3  = 48, a4  = 0x100213c0, (wrb) a3  <-- 0x100213f0
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          15079000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x100213c0, 0 ~~> Word[0x100213c0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          15101000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x100213c0, 0 ~~> Word[0x100213c4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          15123000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x100213c0, 0 ~~> Word[0x100213c8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          15145000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x100213c0, 0 ~~> Word[0x100213cc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          15146000    0x80004268 addi a4, a4, 16                #; a4  = 0x100213c0, (wrb) a4  <-- 0x100213d0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          15147000    0x8000426c bltu a4, a3, -20               #; a4  = 0x100213d0, a3  = 0x100213f0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          15162000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x100213d0, 0 ~~> Word[0x100213d0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          15176000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x100213d0, 0 ~~> Word[0x100213d4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          15190000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x100213d0, 0 ~~> Word[0x100213d8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          15204000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x100213d0, 0 ~~> Word[0x100213dc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          15205000    0x80004268 addi a4, a4, 16                #; a4  = 0x100213d0, (wrb) a4  <-- 0x100213e0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          15206000    0x8000426c bltu a4, a3, -20               #; a4  = 0x100213e0, a3  = 0x100213f0, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          15218000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x100213e0, 0 ~~> Word[0x100213e0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          15232000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x100213e0, 0 ~~> Word[0x100213e4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          15246000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x100213e0, 0 ~~> Word[0x100213e8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          15260000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x100213e0, 0 ~~> Word[0x100213ec]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          15261000    0x80004268 addi a4, a4, 16                #; a4  = 0x100213e0, (wrb) a4  <-- 0x100213f0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          15262000    0x8000426c bltu a4, a3, -20               #; a4  = 0x100213f0, a3  = 0x100213f0, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
          15263000    0x80004270 bnez a2, 8                     #; a2  = 12, taken, goto 0x80004278
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
          15264000    0x80004278 sub a3, t1, a2                 #; t1  = 15, a2  = 12, (wrb) a3  <-- 3
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
          15265000    0x8000427c slli a3, a3, 2                 #; a3  = 3, (wrb) a3  <-- 12
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
          15266000    0x80004280 auipc t0, 0                    #; (wrb) t0  <-- 0x80004280
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
          15267000    0x80004284 add a3, a3, t0                 #; a3  = 12, t0  = 0x80004280, (wrb) a3  <-- 0x8000428c
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
          15268000    0x80004288 jr 12(a3)                      #; a3  = 0x8000428c, goto 0x80004298
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
          15274000    0x80004298 sb a1, 11(a4)                  #; a4  = 0x100213f0, 0 ~~> Byte[0x100213fb]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
          15288000    0x8000429c sb a1, 10(a4)                  #; a4  = 0x100213f0, 0 ~~> Byte[0x100213fa]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
          15302000    0x800042a0 sb a1, 9(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f9]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
          15316000    0x800042a4 sb a1, 8(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f8]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
          15330000    0x800042a8 sb a1, 7(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f7]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
          15344000    0x800042ac sb a1, 6(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f6]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
          15358000    0x800042b0 sb a1, 5(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f5]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
          15372000    0x800042b4 sb a1, 4(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f4]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          15384000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f3]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          15393000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f2]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          15407000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f1]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          15421000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x100213f0, 0 ~~> Byte[0x100213f0]
#; .Ltable (memset.S:85)
#;   ret
          15422000    0x800042c8 ret                            #; ra  = 0x80003fe8, goto 0x80003fe8
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:28)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                    ^
          15435000    0x80003fe8 lw a0, 8(sp)                   #; sp  = 0x1001f738, a0  <~~ Word[0x1001f740]
          15456000                                              #; (lsu) a0  <-- 0x1001f784
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:36)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;                            ^
          15457000    0x80003fec add a0, a0, s11                #; a0  = 0x1001f784, s11 = 8256, (wrb) a0  <-- 0x100217c4
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:82:13)
#;     memset((void*)(tls_ptr + i * tls_offset), 0, size);
#;     ^
          15458000    0x80003ff0 li a1, 0                       #; (wrb) a1  <-- 0
          15459000    0x80003ff4 mv a2, s0                      #; s0  = 64, (wrb) a2  <-- 64
          15460000    0x80003ff8 auipc ra, 0                    #; (wrb) ra  <-- 0x80003ff8
          15461000    0x80003ffc jalr 572(ra)                   #; ra  = 0x80003ff8, (wrb) ra  <-- 0x80004000, goto 0x80004234
#; memset (memset.S:30)
#;   li t1, 15
          15462000    0x80004234 li t1, 15                      #; (wrb) t1  <-- 15
#; memset (memset.S:31)
#;   move a4, a0
          15463000    0x80004238 mv a4, a0                      #; a0  = 0x100217c4, (wrb) a4  <-- 0x100217c4
#; memset (memset.S:32)
#;   bleu a2, t1, .Ltiny
          15464000    0x8000423c bgeu t1, a2, 60                #; t1  = 15, a2  = 64, not taken
#; memset (memset.S:33)
#;   and a5, a4, 15
          15465000    0x80004240 andi a5, a4, 15                #; a4  = 0x100217c4, (wrb) a5  <-- 4
#; memset (memset.S:34)
#;   bnez a5, .Lmisaligned
          15466000    0x80004244 bnez a5, 160                   #; a5  = 4, taken, goto 0x800042e4
#; .Lmisaligned (memset.S:100)
#;   sll a3, a5, 2
          15467000    0x800042e4 slli a3, a5, 2                 #; a5  = 4, (wrb) a3  <-- 16
#; .Ltmp2 (memset.S:101)
#;   1:auipc t0, %pcrel_hi(.Ltable_misaligned)
          15468000    0x800042e8 auipc t0, 0                    #; (wrb) t0  <-- 0x800042e8
#; .Ltmp2 (memset.S:102)
#;   add a3, a3, t0
          15469000    0x800042ec add a3, a3, t0                 #; a3  = 16, t0  = 0x800042e8, (wrb) a3  <-- 0x800042f8
#; .Ltmp2 (memset.S:103)
#;   mv t0, ra
          15470000    0x800042f0 mv t0, ra                      #; ra  = 0x80004000, (wrb) t0  <-- 0x80004000
#; .Ltmp2 (memset.S:104)
#;   jalr a3, %pcrel_lo(1b)
          15471000    0x800042f4 jalr -96(a3)                   #; a3  = 0x800042f8, (wrb) ra  <-- 0x800042f8, goto 0x80004298
#; .Ltable (memset.S:72)
#;   sb a1,11(a4)
          15472000    0x80004298 sb a1, 11(a4)                  #; a4  = 0x100217c4, 0 ~~> Byte[0x100217cf]
#; .Ltable (memset.S:73)
#;   sb a1,10(a4)
          15473000    0x8000429c sb a1, 10(a4)                  #; a4  = 0x100217c4, 0 ~~> Byte[0x100217ce]
#; .Ltable (memset.S:74)
#;   sb a1, 9(a4)
          15484000    0x800042a0 sb a1, 9(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217cd]
#; .Ltable (memset.S:75)
#;   sb a1, 8(a4)
          15496000    0x800042a4 sb a1, 8(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217cc]
#; .Ltable (memset.S:76)
#;   sb a1, 7(a4)
          15505000    0x800042a8 sb a1, 7(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217cb]
#; .Ltable (memset.S:77)
#;   sb a1, 6(a4)
          15517000    0x800042ac sb a1, 6(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217ca]
#; .Ltable (memset.S:78)
#;   sb a1, 5(a4)
          15526000    0x800042b0 sb a1, 5(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217c9]
#; .Ltable (memset.S:79)
#;   sb a1, 4(a4)
          15533000    0x800042b4 sb a1, 4(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217c8]
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          15540000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217c7]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          15547000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217c6]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          15559000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217c5]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          15568000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x100217c4, 0 ~~> Byte[0x100217c4]
#; .Ltable (memset.S:85)
#;   ret
          15569000    0x800042c8 ret                            #; ra  = 0x800042f8, goto 0x800042f8
#; .Ltmp2 (memset.S:105)
#;   mv ra, t0
          15570000    0x800042f8 mv ra, t0                      #; t0  = 0x80004000, (wrb) ra  <-- 0x80004000
#; .Ltmp2 (memset.S:107)
#;   add a5, a5, -16
          15571000    0x800042fc addi a5, a5, -16               #; a5  = 4, (wrb) a5  <-- -12
#; .Ltmp2 (memset.S:108)
#;   sub a4, a4, a5
          15572000    0x80004300 sub a4, a4, a5                 #; a4  = 0x100217c4, a5  = -12, (wrb) a4  <-- 0x100217d0
#; .Ltmp2 (memset.S:109)
#;   add a2, a2, a5
          15573000    0x80004304 add a2, a2, a5                 #; a2  = 64, a5  = -12, (wrb) a2  <-- 52
#; .Ltmp2 (memset.S:110)
#;   bleu a2, t1, .Ltiny
          15574000    0x80004308 bgeu t1, a2, -144              #; t1  = 15, a2  = 52, not taken
#; .Ltmp2 (memset.S:111)
#;   j .Laligned
          15575000    0x8000430c j -196                         #; goto 0x80004248
#; .Laligned (memset.S:37)
#;   bnez a1, .Lwordify
          15576000    0x80004248 bnez a1, 132                   #; a1  = 0, not taken
#; .Lwordified (memset.S:40)
#;   and a3, a2, ~15
          15577000    0x8000424c andi a3, a2, -16               #; a2  = 52, (wrb) a3  <-- 48
#; .Lwordified (memset.S:41)
#;   and a2, a2, 15
          15578000    0x80004250 andi a2, a2, 15                #; a2  = 52, (wrb) a2  <-- 4
#; .Lwordified (memset.S:42)
#;   add a3, a3, a4
          15579000    0x80004254 add a3, a3, a4                 #; a3  = 48, a4  = 0x100217d0, (wrb) a3  <-- 0x10021800
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          15580000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x100217d0, 0 ~~> Word[0x100217d0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          15589000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x100217d0, 0 ~~> Word[0x100217d4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          15601000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x100217d0, 0 ~~> Word[0x100217d8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          15610000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x100217d0, 0 ~~> Word[0x100217dc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          15611000    0x80004268 addi a4, a4, 16                #; a4  = 0x100217d0, (wrb) a4  <-- 0x100217e0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          15612000    0x8000426c bltu a4, a3, -20               #; a4  = 0x100217e0, a3  = 0x10021800, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          15622000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x100217e0, 0 ~~> Word[0x100217e0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          15631000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x100217e0, 0 ~~> Word[0x100217e4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          15643000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x100217e0, 0 ~~> Word[0x100217e8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          15652000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x100217e0, 0 ~~> Word[0x100217ec]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          15653000    0x80004268 addi a4, a4, 16                #; a4  = 0x100217e0, (wrb) a4  <-- 0x100217f0
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          15654000    0x8000426c bltu a4, a3, -20               #; a4  = 0x100217f0, a3  = 0x10021800, taken, goto 0x80004258
#; .Ltmp0 (memset.S:48)
#;   1:sw a1, 0(a4)
          15664000    0x80004258 sw a1, 0(a4)                   #; a4  = 0x100217f0, 0 ~~> Word[0x100217f0]
#; .Ltmp0 (memset.S:49)
#;   sw a1, 4(a4)
          15673000    0x8000425c sw a1, 4(a4)                   #; a4  = 0x100217f0, 0 ~~> Word[0x100217f4]
#; .Ltmp0 (memset.S:50)
#;   sw a1, 8(a4)
          15685000    0x80004260 sw a1, 8(a4)                   #; a4  = 0x100217f0, 0 ~~> Word[0x100217f8]
#; .Ltmp0 (memset.S:51)
#;   sw a1, 12(a4)
          15694000    0x80004264 sw a1, 12(a4)                  #; a4  = 0x100217f0, 0 ~~> Word[0x100217fc]
#; .Ltmp0 (memset.S:53)
#;   add a4, a4, 16
          15695000    0x80004268 addi a4, a4, 16                #; a4  = 0x100217f0, (wrb) a4  <-- 0x10021800
#; .Ltmp0 (memset.S:54)
#;   bltu a4, a3, 1b
          15696000    0x8000426c bltu a4, a3, -20               #; a4  = 0x10021800, a3  = 0x10021800, not taken
#; .Ltmp0 (memset.S:56)
#;   bnez a2, .Ltiny
          15697000    0x80004270 bnez a2, 8                     #; a2  = 4, taken, goto 0x80004278
#; .Ltiny (memset.S:60)
#;   sub a3, t1, a2
          15698000    0x80004278 sub a3, t1, a2                 #; t1  = 15, a2  = 4, (wrb) a3  <-- 11
#; .Ltiny (memset.S:61)
#;   sll a3, a3, 2
          15699000    0x8000427c slli a3, a3, 2                 #; a3  = 11, (wrb) a3  <-- 44
#; .Ltmp1 (memset.S:62)
#;   1:auipc t0, %pcrel_hi(.Ltable)
          15700000    0x80004280 auipc t0, 0                    #; (wrb) t0  <-- 0x80004280
#; .Ltmp1 (memset.S:63)
#;   add a3, a3, t0
          15701000    0x80004284 add a3, a3, t0                 #; a3  = 44, t0  = 0x80004280, (wrb) a3  <-- 0x800042ac
#; .Ltable_misaligned (memset.S:67)
#;   jr a3, %pcrel_lo(1b)
          15702000    0x80004288 jr 12(a3)                      #; a3  = 0x800042ac, goto 0x800042b8
#; .Ltable (memset.S:80)
#;   sb a1, 3(a4)
          15703000    0x800042b8 sb a1, 3(a4)                   #; a4  = 0x10021800, 0 ~~> Byte[0x10021803]
#; .Ltable (memset.S:81)
#;   sb a1, 2(a4)
          15708000    0x800042bc sb a1, 2(a4)                   #; a4  = 0x10021800, 0 ~~> Byte[0x10021802]
#; .Ltable (memset.S:82)
#;   sb a1, 1(a4)
          15715000    0x800042c0 sb a1, 1(a4)                   #; a4  = 0x10021800, 0 ~~> Byte[0x10021801]
#; .Ltable (memset.S:83)
#;   sb a1, 0(a4)
          15727000    0x800042c4 sb a1, 0(a4)                   #; a4  = 0x10021800, 0 ~~> Byte[0x10021800]
#; .Ltable (memset.S:85)
#;   ret
          15728000    0x800042c8 ret                            #; ra  = 0x80004000, goto 0x80004000
#; .LBB25_26 (start.c:227:5)
#;   snrt_init_tls (start.c:85:5)
#;     snrt_cluster_hw_barrier (sync.h:174:5)
#;       asm volatile("csrr x0, 0x7C2" ::: "memory");
#;       ^
          15731000    0x80004000 csrr zero, 1986                #; csr@7c2 = 0
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
          15995000    0x80004090 add s0, a3, tp                 #; a3  = 0, tp  = 0x1001f778, (wrb) s0  <-- 0x1001f778
          15996000    0x80004094 sw a1, 64(s0)                  #; s0  = 0x1001f778, 0x1001ffe0 ~~> Word[0x1001f7b8]
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
          16030000    0x800040a8 bltu s5, a3, 84                #; s5  = 2, a3  = 8, taken, goto 0x800040fc
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
          16079000    0x8000410c add a3, a3, tp                 #; a3  = 0, tp  = 0x1001f778, (wrb) a3  <-- 0x1001f778
          16080000    0x80004110 sw zero, 20(a3)                #; a3  = 0x1001f778, 0 ~~> Word[0x1001f78c]
          16081000    0x80004114 sw a2, 16(a3)                  #; a3  = 0x1001f778, 0x10000000 ~~> Word[0x1001f788]
          16082000    0x80004118 addi a3, a3, 16                #; a3  = 0x1001f778, (wrb) a3  <-- 0x1001f788
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:190:5)
#;     snrt_l1_init (alloc_v2.h:119:33)
#;       snrt_l1_allocator_v2()->end = heap_end_addr;
#;                                   ^
          16083000    0x8000411c sw zero, 12(a3)                #; a3  = 0x1001f788, 0 ~~> Word[0x1001f794]
          16084000    0x80004120 lui a4, 65566                  #; (wrb) a4  <-- 0x1001e000
          16085000    0x80004124 addi a4, a4, -1152             #; a4  = 0x1001e000, (wrb) a4  <-- 0x1001db80
          16086000    0x80004128 add a0, a0, a4                 #; a0  = -32, a4  = 0x1001db80, (wrb) a0  <-- 0x1001db60
          16087000    0x8000412c sw a0, 8(a3)                   #; a3  = 0x1001f788, 0x1001db60 ~~> Word[0x1001f790]
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:190:5)
#;     snrt_l1_init (alloc_v2.h:120:34)
#;       snrt_l1_allocator_v2()->next = snrt_l1_allocator_v2()->base;
#;                                    ^
          16088000    0x80004130 sw zero, 20(a3)                #; a3  = 0x1001f788, 0 ~~> Word[0x1001f79c]
          16089000    0x80004134 sw a2, 16(a3)                  #; a3  = 0x1001f788, 0x10000000 ~~> Word[0x1001f798]
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:191:5)
#;     snrt_l3_init (alloc_v2.h:184:34)
#;       snrt_l3_allocator_v2()->base =
#;                                    ^
          16090000    0x80004138 lui a0, 0                      #; (wrb) a0  <-- 0
          16091000    0x8000413c add a0, a0, tp                 #; a0  = 0, tp  = 0x1001f778, (wrb) a0  <-- 0x1001f778
          16102000    0x80004140 sw zero, 44(a0)                #; a0  = 0x1001f778, 0 ~~> Word[0x1001f7a4]
          16103000    0x80004144 addi a1, a1, 7                 #; a1  = 0x80008968, (wrb) a1  <-- 0x8000896f
          16104000    0x80004148 andi a1, a1, -8                #; a1  = 0x8000896f, (wrb) a1  <-- 0x80008968
          16105000    0x8000414c sw a1, 40(a0)                  #; a0  = 0x1001f778, 0x80008968 ~~> Word[0x1001f7a0]
          16106000    0x80004150 addi a0, a0, 40                #; a0  = 0x1001f778, (wrb) a0  <-- 0x1001f7a0
          16107000    0x80004154 li a2, 1                       #; (wrb) a2  <-- 1
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:191:5)
#;     snrt_l3_init (alloc_v2.h:186:33)
#;       snrt_l3_allocator_v2()->end = SNRT_L3_END_ADDR;
#;                                   ^
          16108000    0x80004158 sw a2, 12(a0)                  #; a0  = 0x1001f7a0, 1 ~~> Word[0x1001f7ac]
          16109000    0x8000415c sw zero, 8(a0)                 #; a0  = 0x1001f7a0, 0 ~~> Word[0x1001f7a8]
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:191:5)
#;     snrt_l3_init (alloc_v2.h:187:34)
#;       snrt_l3_allocator_v2()->next = snrt_l3_allocator_v2()->base;
#;                                    ^
          16110000    0x80004160 sw zero, 20(a0)                #; a0  = 0x1001f7a0, 0 ~~> Word[0x1001f7b4]
          16111000    0x80004164 sw a1, 16(a0)                  #; a0  = 0x1001f7a0, 0x80008968 ~~> Word[0x1001f7b0]
#; .LBB25_16 (start.c:243:5)
#;   snrt_init_libs (start.c:192:5)
#;     snrt_comm_init (sync.h:37:48)
#;       inline void snrt_comm_init() { snrt_comm_world = &snrt_comm_world_info; }
#;                                                      ^
          16112000    0x80004168 lui a0, 0                      #; (wrb) a0  <-- 0
          16113000    0x8000416c add a0, a0, tp                 #; a0  = 0, tp  = 0x1001f778, (wrb) a0  <-- 0x1001f778
          16114000    0x80004170 lui a1, 0                      #; (wrb) a1  <-- 0
          16115000    0x80004174 add a1, a1, tp                 #; a1  = 0, tp  = 0x1001f778, (wrb) a1  <-- 0x1001f778
          16116000    0x80004178 mv a1, a1                      #; a1  = 0x1001f778, (wrb) a1  <-- 0x1001f778
          16117000    0x8000417c sw a1, 76(a0)                  #; a0  = 0x1001f778, 0x1001f778 ~~> Word[0x1001f7c4]
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
          16142000    0x80000698 addi sp, sp, -80               #; sp  = 0x1001f738, (wrb) sp  <-- 0x1001f6e8
#; main (matmul_i32.c:76:26)
#;   snrt_cluster_core_idx (team.h:108:12)
#;     snrt_global_core_idx (team.h:80:12)
#;       snrt_hartid (team.h:25:5)
#;         asm("csrr %0, mhartid" : "=r"(hartid));
#;         ^
          16143000    0x8000069c sw ra, 76(sp)                  #; sp  = 0x1001f6e8, 0x8000418c ~~> Word[0x1001f734]
          16144000    0x800006a0 sw s0, 72(sp)                  #; sp  = 0x1001f6e8, 0x1001f778 ~~> Word[0x1001f730]
          16145000    0x800006a4 sw s1, 68(sp)                  #; sp  = 0x1001f6e8, 2064 ~~> Word[0x1001f72c]
          16146000    0x800006a8 sw s2, 64(sp)                  #; sp  = 0x1001f6e8, 2 ~~> Word[0x1001f728]
          16147000    0x800006ac sw s3, 60(sp)                  #; sp  = 0x1001f6e8, 0 ~~> Word[0x1001f724]
          16148000    0x800006b0 sw s4, 56(sp)                  #; sp  = 0x1001f6e8, 0 ~~> Word[0x1001f720]
          16149000    0x800006b4 sw s5, 52(sp)                  #; sp  = 0x1001f6e8, 2 ~~> Word[0x1001f71c]
          16150000    0x800006b8 sw s6, 48(sp)                  #; sp  = 0x1001f6e8, 0x80005ed8 ~~> Word[0x1001f718]
          16151000    0x800006bc sw s7, 44(sp)                  #; sp  = 0x1001f6e8, 0x80005ed8 ~~> Word[0x1001f714]
          16162000    0x800006c0 sw s8, 40(sp)                  #; sp  = 0x1001f6e8, 0x80005ef8 ~~> Word[0x1001f710]
          16163000    0x800006c4 sw s9, 36(sp)                  #; sp  = 0x1001f6e8, 6192 ~~> Word[0x1001f70c]
          16164000    0x800006c8 sw s10, 32(sp)                 #; sp  = 0x1001f6e8, 7224 ~~> Word[0x1001f708]
          16165000    0x800006cc sw s11, 28(sp)                 #; sp  = 0x1001f6e8, 8256 ~~> Word[0x1001f704]
          16166000    0x800006d0 csrr a0, mhartid               #; mhartid = 2, (wrb) a0  <-- 2
          16167000    0x800006d4 lui a1, 233017                 #; (wrb) a1  <-- 0x38e39000
          16168000    0x800006d8 addi a1, a1, -455              #; a1  = 0x38e39000, (wrb) a1  <-- 0x38e38e39
#; main (matmul_i32.c:107:9)
#;   snrt_stop_perf_counter (perf_cnt.h:54:5)
#;     snrt_perf_counters (perf_cnt.h:23:14)
#;       snrt_cluster (snitch_cluster_memory.h:23:48)
#;         snrt_cluster_idx (team.h:99:35)
#;           return snrt_global_core_idx() / snrt_cluster_core_num();
#;                                         ^
          16169000    0x800006dc mulhu a1, a0, a1               #; a0  = 2, a1  = 0x38e38e39
          16171000                                              #; (acc) a1  <-- 0
          16172000    0x800006e0 srli s2, a1, 1                 #; a1  = 0, (wrb) s2  <-- 0
          16173000    0x800006e4 slli a1, s2, 3                 #; s2  = 0, (wrb) a1  <-- 0
          16174000    0x800006e8 add a1, a1, s2                 #; a1  = 0, s2  = 0, (wrb) a1  <-- 0
          16175000    0x800006ec sub a0, a0, a1                 #; a0  = 2, a1  = 0, (wrb) a0  <-- 2
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
          16194000    0x8000070c sw s1, 16(sp)                  #; sp  = 0x1001f6e8, 0x800060c8 ~~> Word[0x1001f6f8]
          16195000    0x80000710 sw s2, 12(sp)                  #; sp  = 0x1001f6e8, 0 ~~> Word[0x1001f6f4]
          16196000    0x80000714 sw a0, 20(sp)                  #; sp  = 0x1001f6e8, 2 ~~> Word[0x1001f6fc]
          16197000    0x80000718 beqz a0, 432                   #; a0  = 2, not taken
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
          22632000    0x80000728 andi a2, a0, 7                 #; a0  = 2, (wrb) a2  <-- 2
#; .LBB2_46 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:88:23)
#;     for (uint32_t i = 2 * (id / c); i < M; i += 2 * (numThreads / c)) {
#;                         ^
          22633000    0x8000072c srli a1, a0, 2                 #; a0  = 2, (wrb) a1  <-- 0
          22634000    0x80000730 andi a5, a1, 2                 #; a1  = 0, (wrb) a5  <-- 0
          22635000    0x80000734 sw a2, 24(sp)                  #; sp  = 0x1001f6e8, 2 ~~> Word[0x1001f700]
          22636000    0x80000738 slli a1, a2, 2                 #; a2  = 2, (wrb) a1  <-- 8
          22637000    0x8000073c add a1, a1, s4                 #; a1  = 8, s4  = 0x800061c8, (wrb) a1  <-- 0x800061d0
          22648000    0x80000740 addi a2, a1, 64                #; a1  = 0x800061d0, (wrb) a2  <-- 0x80006210
          22649000    0x80000744 addi a3, a1, 128               #; a1  = 0x800061d0, (wrb) a3  <-- 0x80006250
          22650000    0x80000748 addi a4, a1, 192               #; a1  = 0x800061d0, (wrb) a4  <-- 0x80006290
          22651000    0x8000074c addi a5, a5, -2                #; a5  = 0, (wrb) a5  <-- -2
          22652000    0x80000750 srli a6, a0, 3                 #; a0  = 2, (wrb) a6  <-- 0
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
          22659000    0x8000076c mv t3, a1                      #; a1  = 0x800061d0, (wrb) t3  <-- 0x800061d0
          22660000    0x80000770 p.lw t4, 4(t2!)                #; t2  = 0x800060c8, t4  <~~ Word[0x800060cc]
          22661000    0x80000774 p.lw t5, t0(t2!)               #; t2  = 0x800060cc, t0  = 28, t5  <~~ Word[0x800060e8]
          22677000    0x80000778 p.lw t6, 4(t2!)                #; t2  = 0x800060e8, t6  <~~ Word[0x800060ec]
          22685000                                              #; (lsu) t4  <-- 1
          22714000    0x8000077c p.lw s1, 0(t2!)                #; t2  = 0x800060ec, s1  <~~ Word[0x800060ec]
          22722000                                              #; (lsu) t5  <-- 2
          22758000    0x80000780 p.lw s4, 4(t3!)                #; t3  = 0x800061d0, s4  <~~ Word[0x800061d4]
          22766000                                              #; (lsu) t6  <-- 2
          22795000    0x80000784 p.lw s5, t0(t3!)               #; t3  = 0x800061d4, t0  = 28, s5  <~~ Word[0x800061f0]
          22803000                                              #; (lsu) s1  <-- 4
          22839000    0x80000788 p.lw s6, 4(t3!)                #; t3  = 0x800061f0, s6  <~~ Word[0x800061f4]
          22847000                                              #; (lsu) s4  <-- 0
          22876000    0x8000078c p.lw s7, 0(t3!)                #; t3  = 0x800061f4, s7  <~~ Word[0x800061f4]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:24)
#;     c00 += val_a00 * val_b00;
#;                    ^
          22877000    0x80000790 mul t2, t4, s4                 #; t4  = 1, s4  = 0
          22879000                                              #; (acc) t2  <-- 0
          22884000                                              #; (lsu) s5  <-- 0
          22928000                                              #; (lsu) s6  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          22929000    0x80000794 p.mac t2, t5, s6               #; t5  = 2, s6  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:24)
#;     c01 += val_a00 * val_b01;
#;                    ^
          22930000    0x80000798 mul t3, t4, s5                 #; t4  = 1, s5  = 0
          22931000                                              #; (acc) t2  <-- 0
          22932000                                              #; (acc) t3  <-- 0
          22965000                                              #; (lsu) s7  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          22966000    0x8000079c p.mac t3, t5, s7               #; t5  = 2, s7  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:24)
#;     c10 += val_a10 * val_b00;
#;                    ^
          22967000    0x800007a0 mul t4, t6, s4                 #; t6  = 2, s4  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          22968000    0x800007a4 addi t5, a7, 8                 #; a7  = 0x800060c8, (wrb) t5  <-- 0x800060d0
          22969000    0x800007a8 mv s4, a2                      #; a2  = 0x80006210, (wrb) s4  <-- 0x80006210
          22970000    0x800007ac mv a0, s0                      #; s0  = 0x80005fc8, (wrb) a0  <-- 0x80005fc8
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          22971000    0x800007b0 p.lw s8, 4(t5!)                #; t5  = 0x800060d0, s8  <~~ Word[0x800060d4]
          22972000    0x800007b4 p.lw s9, t0(t5!)               #; t5  = 0x800060d4, t0  = 28, s9  <~~ Word[0x800060f0]
          22973000                                              #; (acc) t3  <-- 0
          22974000                                              #; (acc) t4  <-- 0
          23001000    0x800007b8 p.lw s10, 4(t5!)               #; t5  = 0x800060f0, s10 <~~ Word[0x800060f4]
          23009000                                              #; (lsu) s8  <-- 3
          23038000    0x800007bc p.lw s11, 0(t5!)               #; t5  = 0x800060f4, s11 <~~ Word[0x800060f4]
          23046000                                              #; (lsu) s9  <-- 4
          23082000    0x800007c0 p.lw ra, 4(s4!)                #; s4  = 0x80006210, ra  <~~ Word[0x80006214]
          23090000                                              #; (lsu) s10 <-- 6
          23119000    0x800007c4 p.lw s2, t0(s4!)               #; s4  = 0x80006214, t0  = 28, s2  <~~ Word[0x80006230]
          23127000                                              #; (lsu) s11 <-- 8
          23163000    0x800007c8 p.lw s0, 4(s4!)                #; s4  = 0x80006230, s0  <~~ Word[0x80006234]
          23171000                                              #; (lsu) ra  <-- 1
          23200000    0x800007cc p.lw s3, 0(s4!)                #; s4  = 0x80006234, s3  <~~ Word[0x80006234]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          23201000    0x800007d0 p.mac t4, s1, s6               #; s1  = 4, s6  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:24)
#;     c11 += val_a10 * val_b01;
#;                    ^
          23202000    0x800007d4 mul t5, t6, s5                 #; t6  = 2, s5  = 0
          23203000                                              #; (acc) t4  <-- 0
          23204000                                              #; (acc) t5  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          23205000    0x800007d8 p.mac t5, s1, s7               #; s1  = 4, s7  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          23206000    0x800007dc p.mac t2, s8, ra               #; s8  = 3, ra  = 1
          23207000                                              #; (acc) t5  <-- 0
          23208000                                              #; (lsu) s2  <-- 0
          23209000                                              #; (acc) t2  <-- 3
          23252000                                              #; (lsu) s0  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          23253000    0x800007e0 p.mac t2, s9, s0               #; s9  = 4, s0  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          23254000    0x800007e4 p.mac t3, s8, s2               #; s8  = 3, s2  = 0
          23255000                                              #; (acc) t2  <-- 3
          23256000                                              #; (acc) t3  <-- 0
          23289000                                              #; (lsu) s3  <-- 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          23290000    0x800007e8 p.mac t3, s9, s3               #; s9  = 4, s3  = 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          23291000    0x800007ec p.mac t4, s10, ra              #; s10 = 6, ra  = 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          23292000    0x800007f0 addi t6, a7, 16                #; a7  = 0x800060c8, (wrb) t6  <-- 0x800060d8
          23293000    0x800007f4 mv s1, a3                      #; a3  = 0x80006250, (wrb) s1  <-- 0x80006250
          23294000    0x800007f8 p.lw s4, 4(t6!)                #; t6  = 0x800060d8, s4  <~~ Word[0x800060dc]
          23295000    0x800007fc p.lw s5, t0(t6!)               #; t6  = 0x800060dc, t0  = 28, s5  <~~ Word[0x800060f8]
          23296000                                              #; (acc) t3  <-- 4
          23297000                                              #; (acc) t4  <-- 6
          23325000    0x80000800 p.lw s6, 4(t6!)                #; t6  = 0x800060f8, s6  <~~ Word[0x800060fc]
          23333000                                              #; (lsu) s4  <-- 5
          23362000    0x80000804 p.lw s7, 0(t6!)                #; t6  = 0x800060fc, s7  <~~ Word[0x800060fc]
          23370000                                              #; (lsu) s5  <-- 6
          23406000    0x80000808 p.lw s8, 4(s1!)                #; s1  = 0x80006250, s8  <~~ Word[0x80006254]
          23414000                                              #; (lsu) s6  <-- 10
          23443000    0x8000080c p.lw s9, t0(s1!)               #; s1  = 0x80006254, t0  = 28, s9  <~~ Word[0x80006270]
          23451000                                              #; (lsu) s7  <-- 12
          23487000    0x80000810 p.lw ra, 4(s1!)                #; s1  = 0x80006270, ra  <~~ Word[0x80006274]
          23495000                                              #; (lsu) s8  <-- 0
          23524000    0x80000814 p.lw t1, 0(s1!)                #; s1  = 0x80006274, t1  <~~ Word[0x80006274]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          23525000    0x80000818 p.mac t4, s11, s0              #; s11 = 8, s0  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          23526000    0x8000081c p.mac t5, s10, s2              #; s10 = 6, s2  = 0
          23527000                                              #; (acc) t4  <-- 6
          23528000                                              #; (acc) t5  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          23529000    0x80000820 p.mac t5, s11, s3              #; s11 = 8, s3  = 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          23530000    0x80000824 p.mac t2, s4, s8               #; s4  = 5, s8  = 0
          23531000                                              #; (acc) t5  <-- 8
          23532000                                              #; (lsu) s9  <-- 0
          23533000                                              #; (acc) t2  <-- 3
          23576000                                              #; (lsu) ra  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          23577000    0x80000828 p.mac t2, s5, ra               #; s5  = 6, ra  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          23578000    0x8000082c p.mac t3, s4, s9               #; s4  = 5, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          23579000    0x80000830 p.mac t4, s6, s8               #; s6  = 10, s8  = 0, (acc) t2  <-- 3
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          23580000    0x80000834 p.mac t5, s6, s9               #; s6  = 10, s9  = 0, (acc) t3  <-- 4
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          23581000    0x80000838 addi t6, a7, 24                #; a7  = 0x800060c8, (wrb) t6  <-- 0x800060e0
          23582000    0x8000083c mv s0, a4                      #; a4  = 0x80006290, (wrb) s0  <-- 0x80006290
          23583000                                              #; (acc) t4  <-- 6
          23584000                                              #; (acc) t5  <-- 8
          23585000    0x80000840 p.lw s1, 4(t6!)                #; t6  = 0x800060e0, s1  <~~ Word[0x800060e4]
          23605000    0x80000844 p.lw s2, t0(t6!)               #; t6  = 0x800060e4, t0  = 28, s2  <~~ Word[0x80006100]
          23613000                                              #; (lsu) t1  <-- 0
          23649000    0x80000848 p.lw s3, 4(t6!)                #; t6  = 0x80006100, s3  <~~ Word[0x80006104]
          23657000                                              #; (lsu) s1  <-- 7
          23686000    0x8000084c p.lw s4, 0(t6!)                #; t6  = 0x80006104, s4  <~~ Word[0x80006104]
          23694000                                              #; (lsu) s2  <-- 8
          23730000    0x80000850 p.lw s6, 4(s0!)                #; s0  = 0x80006290, s6  <~~ Word[0x80006294]
          23738000                                              #; (lsu) s3  <-- 14
          23767000    0x80000854 p.lw s8, t0(s0!)               #; s0  = 0x80006294, t0  = 28, s8  <~~ Word[0x800062b0]
          23775000                                              #; (lsu) s4  <-- 16
          23812000    0x80000858 p.lw s9, 4(s0!)                #; s0  = 0x800062b0, s9  <~~ Word[0x800062b4]
          23820000                                              #; (lsu) s6  <-- 0
          23857000    0x8000085c p.lw s10, 0(s0!)               #; s0  = 0x800062b4, s10 <~~ Word[0x800062b4]
          23858000    0x80000860 mv s0, a0                      #; a0  = 0x80005fc8, (wrb) s0  <-- 0x80005fc8
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          23859000    0x80000864 p.mac t3, s5, t1               #; s5  = 6, t1  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          23860000    0x80000868 p.mac t4, s7, ra               #; s7  = 12, ra  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          23861000    0x8000086c p.mac t5, s7, t1               #; s7  = 12, t1  = 0, (acc) t3  <-- 4
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          23862000    0x80000870 p.mac t2, s1, s6               #; s1  = 7, s6  = 0, (acc) t4  <-- 6
          23863000                                              #; (acc) t5  <-- 8
          23864000                                              #; (acc) t2  <-- 3
          23865000                                              #; (lsu) s8  <-- 0
          23910000                                              #; (lsu) s9  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          23911000    0x80000874 p.mac t2, s2, s9               #; s2  = 8, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          23912000    0x80000878 p.mac t3, s1, s8               #; s1  = 7, s8  = 0
          23913000                                              #; (acc) t2  <-- 3
          23914000                                              #; (acc) t3  <-- 4
          23955000                                              #; (lsu) s10 <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          23956000    0x8000087c p.mac t3, s2, s10              #; s2  = 8, s10 = 0
          23958000                                              #; (acc) t3  <-- 4
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          23966000    0x80000880 p.mac t4, s3, s6               #; s3  = 14, s6  = 0
          23968000                                              #; (acc) t4  <-- 6
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
          23971000                                              #; (acc) t4  <-- 6
          23972000                                              #; (acc) t5  <-- 8
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          23973000    0x8000088c p.mac t5, s4, s10              #; s4  = 16, s10 = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:133:33)
#;     int32_t *idx_c = &C[i * P + j];
#;                               ^
          23974000    0x80000890 lw a0, 24(sp)                  #; sp  = 0x1001f6e8, a0  <~~ Word[0x1001f700]
          23975000                                              #; (acc) t5  <-- 8
          23977000                                              #; (lsu) a0  <-- 2
          23978000    0x80000894 or t1, a0, a6                  #; a0  = 2, a6  = 0, (wrb) t1  <-- 2
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:133:25)
#;     int32_t *idx_c = &C[i * P + j];
#;                       ^
          23979000    0x80000898 slli t1, t1, 2                 #; t1  = 2, (wrb) t1  <-- 8
          23980000    0x8000089c add t1, t1, s0                 #; t1  = 8, s0  = 0x80005fc8, (wrb) t1  <-- 0x80005fd0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:134:7)
#;     __asm__ volatile("p.sw %[s00], 4(%[addr_c]!) \n"
#;     ^
          23981000    0x800008a0 p.sw t2, 4(t1!)                #; t1  = 0x80005fd0, 3 ~~> Word[0x80005fd4]
          23982000    0x800008a4 p.sw t3, t0(t1!)               #; t1  = 0x80005fd4, 4 ~~> Word[0x80005ff0]
          23992000    0x800008a8 p.sw t4, 4(t1!)                #; t1  = 0x80005ff0, 6 ~~> Word[0x80005ff4]
          24040000    0x800008ac p.sw t5, 0(t1!)                #; t1  = 0x80005ff4, 8 ~~> Word[0x80005ff4]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:88:37)
#;     for (uint32_t i = 2 * (id / c); i < M; i += 2 * (numThreads / c)) {
#;                                       ^
          24041000    0x800008b0 addi a5, a5, 2                 #; a5  = -2, (wrb) a5  <-- 0
          24042000    0x800008b4 addi a6, a6, 16                #; a6  = 0, (wrb) a6  <-- 16
          24043000    0x800008b8 addi a7, a7, 64                #; a7  = 0x800060c8, (wrb) a7  <-- 0x80006108
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:88:3)
#;     for (uint32_t i = 2 * (id / c); i < M; i += 2 * (numThreads / c)) {
#;     ^
          24044000    0x800008bc li a0, 6                       #; (wrb) a0  <-- 6
          24047000    0x800008c0 bltu a5, a0, -344              #; a5  = 0, a0  = 6, taken, goto 0x80000768
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          24048000    0x80000768 mv t2, a7                      #; a7  = 0x80006108, (wrb) t2  <-- 0x80006108
          24049000    0x8000076c mv t3, a1                      #; a1  = 0x800061d0, (wrb) t3  <-- 0x800061d0
          24088000    0x80000770 p.lw t4, 4(t2!)                #; t2  = 0x80006108, t4  <~~ Word[0x8000610c]
          24136000    0x80000774 p.lw t5, t0(t2!)               #; t2  = 0x8000610c, t0  = 28, t5  <~~ Word[0x80006128]
          24184000    0x80000778 p.lw t6, 4(t2!)                #; t2  = 0x80006128, t6  <~~ Word[0x8000612c]
          24192000                                              #; (lsu) t4  <-- 3
          24221000    0x8000077c p.lw s1, 0(t2!)                #; t2  = 0x8000612c, s1  <~~ Word[0x8000612c]
          24229000                                              #; (lsu) t5  <-- 6
          24265000    0x80000780 p.lw s4, 4(t3!)                #; t3  = 0x800061d0, s4  <~~ Word[0x800061d4]
          24273000                                              #; (lsu) t6  <-- 4
          24302000    0x80000784 p.lw s5, t0(t3!)               #; t3  = 0x800061d4, t0  = 28, s5  <~~ Word[0x800061f0]
          24310000                                              #; (lsu) s1  <-- 8
          24346000    0x80000788 p.lw s6, 4(t3!)                #; t3  = 0x800061f0, s6  <~~ Word[0x800061f4]
          24354000                                              #; (lsu) s4  <-- 0
          24383000    0x8000078c p.lw s7, 0(t3!)                #; t3  = 0x800061f4, s7  <~~ Word[0x800061f4]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:24)
#;     c00 += val_a00 * val_b00;
#;                    ^
          24384000    0x80000790 mul t2, t4, s4                 #; t4  = 3, s4  = 0
          24386000                                              #; (acc) t2  <-- 0
          24391000                                              #; (lsu) s5  <-- 0
          24435000                                              #; (lsu) s6  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          24436000    0x80000794 p.mac t2, t5, s6               #; t5  = 6, s6  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:24)
#;     c01 += val_a00 * val_b01;
#;                    ^
          24437000    0x80000798 mul t3, t4, s5                 #; t4  = 3, s5  = 0
          24438000                                              #; (acc) t2  <-- 0
          24439000                                              #; (acc) t3  <-- 0
          24472000                                              #; (lsu) s7  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          24473000    0x8000079c p.mac t3, t5, s7               #; t5  = 6, s7  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:24)
#;     c10 += val_a10 * val_b00;
#;                    ^
          24474000    0x800007a0 mul t4, t6, s4                 #; t6  = 4, s4  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          24475000    0x800007a4 addi t5, a7, 8                 #; a7  = 0x80006108, (wrb) t5  <-- 0x80006110
          24476000    0x800007a8 mv s4, a2                      #; a2  = 0x80006210, (wrb) s4  <-- 0x80006210
          24477000    0x800007ac mv a0, s0                      #; s0  = 0x80005fc8, (wrb) a0  <-- 0x80005fc8
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          24478000    0x800007b0 p.lw s8, 4(t5!)                #; t5  = 0x80006110, s8  <~~ Word[0x80006114]
          24479000    0x800007b4 p.lw s9, t0(t5!)               #; t5  = 0x80006114, t0  = 28, s9  <~~ Word[0x80006130]
          24480000                                              #; (acc) t3  <-- 0
          24481000                                              #; (acc) t4  <-- 0
          24508000    0x800007b8 p.lw s10, 4(t5!)               #; t5  = 0x80006130, s10 <~~ Word[0x80006134]
          24516000                                              #; (lsu) s8  <-- 9
          24545000    0x800007bc p.lw s11, 0(t5!)               #; t5  = 0x80006134, s11 <~~ Word[0x80006134]
          24553000                                              #; (lsu) s9  <-- 12
          24589000    0x800007c0 p.lw ra, 4(s4!)                #; s4  = 0x80006210, ra  <~~ Word[0x80006214]
          24597000                                              #; (lsu) s10 <-- 12
          24626000    0x800007c4 p.lw s2, t0(s4!)               #; s4  = 0x80006214, t0  = 28, s2  <~~ Word[0x80006230]
          24634000                                              #; (lsu) s11 <-- 16
          24670000    0x800007c8 p.lw s0, 4(s4!)                #; s4  = 0x80006230, s0  <~~ Word[0x80006234]
          24678000                                              #; (lsu) ra  <-- 1
          24707000    0x800007cc p.lw s3, 0(s4!)                #; s4  = 0x80006234, s3  <~~ Word[0x80006234]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          24708000    0x800007d0 p.mac t4, s1, s6               #; s1  = 8, s6  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:24)
#;     c11 += val_a10 * val_b01;
#;                    ^
          24709000    0x800007d4 mul t5, t6, s5                 #; t6  = 4, s5  = 0
          24710000                                              #; (acc) t4  <-- 0
          24711000                                              #; (acc) t5  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          24712000    0x800007d8 p.mac t5, s1, s7               #; s1  = 8, s7  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          24713000    0x800007dc p.mac t2, s8, ra               #; s8  = 9, ra  = 1
          24714000                                              #; (acc) t5  <-- 0
          24715000                                              #; (lsu) s2  <-- 0
          24716000                                              #; (acc) t2  <-- 9
          24759000                                              #; (lsu) s0  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          24760000    0x800007e0 p.mac t2, s9, s0               #; s9  = 12, s0  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          24761000    0x800007e4 p.mac t3, s8, s2               #; s8  = 9, s2  = 0
          24762000                                              #; (acc) t2  <-- 9
          24763000                                              #; (acc) t3  <-- 0
          24796000                                              #; (lsu) s3  <-- 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          24797000    0x800007e8 p.mac t3, s9, s3               #; s9  = 12, s3  = 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          24798000    0x800007ec p.mac t4, s10, ra              #; s10 = 12, ra  = 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          24799000    0x800007f0 addi t6, a7, 16                #; a7  = 0x80006108, (wrb) t6  <-- 0x80006118
          24800000    0x800007f4 mv s1, a3                      #; a3  = 0x80006250, (wrb) s1  <-- 0x80006250
          24801000    0x800007f8 p.lw s4, 4(t6!)                #; t6  = 0x80006118, s4  <~~ Word[0x8000611c]
          24802000    0x800007fc p.lw s5, t0(t6!)               #; t6  = 0x8000611c, t0  = 28, s5  <~~ Word[0x80006138]
          24803000                                              #; (acc) t3  <-- 12
          24804000                                              #; (acc) t4  <-- 12
          24832000    0x80000800 p.lw s6, 4(t6!)                #; t6  = 0x80006138, s6  <~~ Word[0x8000613c]
          24840000                                              #; (lsu) s4  <-- 15
          24869000    0x80000804 p.lw s7, 0(t6!)                #; t6  = 0x8000613c, s7  <~~ Word[0x8000613c]
          24877000                                              #; (lsu) s5  <-- 18
          24913000    0x80000808 p.lw s8, 4(s1!)                #; s1  = 0x80006250, s8  <~~ Word[0x80006254]
          24921000                                              #; (lsu) s6  <-- 20
          24950000    0x8000080c p.lw s9, t0(s1!)               #; s1  = 0x80006254, t0  = 28, s9  <~~ Word[0x80006270]
          24958000                                              #; (lsu) s7  <-- 24
          24994000    0x80000810 p.lw ra, 4(s1!)                #; s1  = 0x80006270, ra  <~~ Word[0x80006274]
          25002000                                              #; (lsu) s8  <-- 0
          25031000    0x80000814 p.lw t1, 0(s1!)                #; s1  = 0x80006274, t1  <~~ Word[0x80006274]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          25032000    0x80000818 p.mac t4, s11, s0              #; s11 = 16, s0  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          25033000    0x8000081c p.mac t5, s10, s2              #; s10 = 12, s2  = 0
          25034000                                              #; (acc) t4  <-- 12
          25035000                                              #; (acc) t5  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          25036000    0x80000820 p.mac t5, s11, s3              #; s11 = 16, s3  = 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          25037000    0x80000824 p.mac t2, s4, s8               #; s4  = 15, s8  = 0
          25038000                                              #; (acc) t5  <-- 16
          25039000                                              #; (lsu) s9  <-- 0
          25040000                                              #; (acc) t2  <-- 9
          25083000                                              #; (lsu) ra  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          25084000    0x80000828 p.mac t2, s5, ra               #; s5  = 18, ra  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          25085000    0x8000082c p.mac t3, s4, s9               #; s4  = 15, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          25086000    0x80000830 p.mac t4, s6, s8               #; s6  = 20, s8  = 0, (acc) t2  <-- 9
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          25087000    0x80000834 p.mac t5, s6, s9               #; s6  = 20, s9  = 0, (acc) t3  <-- 12
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          25088000    0x80000838 addi t6, a7, 24                #; a7  = 0x80006108, (wrb) t6  <-- 0x80006120
          25089000    0x8000083c mv s0, a4                      #; a4  = 0x80006290, (wrb) s0  <-- 0x80006290
          25090000    0x80000840 p.lw s1, 4(t6!)                #; t6  = 0x80006120, s1  <~~ Word[0x80006124]
          25091000                                              #; (acc) t4  <-- 12
          25092000                                              #; (acc) t5  <-- 16
          25112000    0x80000844 p.lw s2, t0(t6!)               #; t6  = 0x80006124, t0  = 28, s2  <~~ Word[0x80006140]
          25120000                                              #; (lsu) t1  <-- 0
          25156000    0x80000848 p.lw s3, 4(t6!)                #; t6  = 0x80006140, s3  <~~ Word[0x80006144]
          25164000                                              #; (lsu) s1  <-- 21
          25193000    0x8000084c p.lw s4, 0(t6!)                #; t6  = 0x80006144, s4  <~~ Word[0x80006144]
          25201000                                              #; (lsu) s2  <-- 24
          25237000    0x80000850 p.lw s6, 4(s0!)                #; s0  = 0x80006290, s6  <~~ Word[0x80006294]
          25245000                                              #; (lsu) s3  <-- 28
          25282000    0x80000854 p.lw s8, t0(s0!)               #; s0  = 0x80006294, t0  = 28, s8  <~~ Word[0x800062b0]
          25290000                                              #; (lsu) s4  <-- 32
          25327000    0x80000858 p.lw s9, 4(s0!)                #; s0  = 0x800062b0, s9  <~~ Word[0x800062b4]
          25335000                                              #; (lsu) s6  <-- 0
          25372000    0x8000085c p.lw s10, 0(s0!)               #; s0  = 0x800062b4, s10 <~~ Word[0x800062b4]
          25373000    0x80000860 mv s0, a0                      #; a0  = 0x80005fc8, (wrb) s0  <-- 0x80005fc8
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          25374000    0x80000864 p.mac t3, s5, t1               #; s5  = 18, t1  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          25375000    0x80000868 p.mac t4, s7, ra               #; s7  = 24, ra  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          25376000    0x8000086c p.mac t5, s7, t1               #; s7  = 24, t1  = 0, (acc) t3  <-- 12
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          25377000    0x80000870 p.mac t2, s1, s6               #; s1  = 21, s6  = 0, (acc) t4  <-- 12
          25378000                                              #; (acc) t5  <-- 16
          25379000                                              #; (acc) t2  <-- 9
          25380000                                              #; (lsu) s8  <-- 0
          25425000                                              #; (lsu) s9  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          25426000    0x80000874 p.mac t2, s2, s9               #; s2  = 24, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          25427000    0x80000878 p.mac t3, s1, s8               #; s1  = 21, s8  = 0
          25428000                                              #; (acc) t2  <-- 9
          25429000                                              #; (acc) t3  <-- 12
          25469000                                              #; (lsu) s10 <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          25470000    0x8000087c p.mac t3, s2, s10              #; s2  = 24, s10 = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          25471000    0x80000880 p.mac t4, s3, s6               #; s3  = 28, s6  = 0
          25472000                                              #; (acc) t3  <-- 12
          25473000                                              #; (acc) t4  <-- 12
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          25474000    0x80000884 p.mac t4, s4, s9               #; s4  = 32, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          25475000    0x80000888 p.mac t5, s3, s8               #; s3  = 28, s8  = 0
          25476000                                              #; (acc) t4  <-- 12
          25477000                                              #; (acc) t5  <-- 16
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          25478000    0x8000088c p.mac t5, s4, s10              #; s4  = 32, s10 = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:133:33)
#;     int32_t *idx_c = &C[i * P + j];
#;                               ^
          25479000    0x80000890 lw a0, 24(sp)                  #; sp  = 0x1001f6e8, a0  <~~ Word[0x1001f700]
          25480000                                              #; (acc) t5  <-- 16
          25482000                                              #; (lsu) a0  <-- 2
          25483000    0x80000894 or t1, a0, a6                  #; a0  = 2, a6  = 16, (wrb) t1  <-- 18
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:133:25)
#;     int32_t *idx_c = &C[i * P + j];
#;                       ^
          25484000    0x80000898 slli t1, t1, 2                 #; t1  = 18, (wrb) t1  <-- 72
          25485000    0x8000089c add t1, t1, s0                 #; t1  = 72, s0  = 0x80005fc8, (wrb) t1  <-- 0x80006010
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:134:7)
#;     __asm__ volatile("p.sw %[s00], 4(%[addr_c]!) \n"
#;     ^
          25486000    0x800008a0 p.sw t2, 4(t1!)                #; t1  = 0x80006010, 9 ~~> Word[0x80006014]
          25487000    0x800008a4 p.sw t3, t0(t1!)               #; t1  = 0x80006014, 12 ~~> Word[0x80006030]
          25498000    0x800008a8 p.sw t4, 4(t1!)                #; t1  = 0x80006030, 12 ~~> Word[0x80006034]
          25546000    0x800008ac p.sw t5, 0(t1!)                #; t1  = 0x80006034, 16 ~~> Word[0x80006034]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:88:37)
#;     for (uint32_t i = 2 * (id / c); i < M; i += 2 * (numThreads / c)) {
#;                                       ^
          25547000    0x800008b0 addi a5, a5, 2                 #; a5  = 0, (wrb) a5  <-- 2
          25548000    0x800008b4 addi a6, a6, 16                #; a6  = 16, (wrb) a6  <-- 32
          25549000    0x800008b8 addi a7, a7, 64                #; a7  = 0x80006108, (wrb) a7  <-- 0x80006148
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:88:3)
#;     for (uint32_t i = 2 * (id / c); i < M; i += 2 * (numThreads / c)) {
#;     ^
          25550000    0x800008bc li a0, 6                       #; (wrb) a0  <-- 6
          25551000    0x800008c0 bltu a5, a0, -344              #; a5  = 2, a0  = 6, taken, goto 0x80000768
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          25552000    0x80000768 mv t2, a7                      #; a7  = 0x80006148, (wrb) t2  <-- 0x80006148
          25553000    0x8000076c mv t3, a1                      #; a1  = 0x800061d0, (wrb) t3  <-- 0x800061d0
          25594000    0x80000770 p.lw t4, 4(t2!)                #; t2  = 0x80006148, t4  <~~ Word[0x8000614c]
          25642000    0x80000774 p.lw t5, t0(t2!)               #; t2  = 0x8000614c, t0  = 28, t5  <~~ Word[0x80006168]
          25690000    0x80000778 p.lw t6, 4(t2!)                #; t2  = 0x80006168, t6  <~~ Word[0x8000616c]
          25698000                                              #; (lsu) t4  <-- 5
          25727000    0x8000077c p.lw s1, 0(t2!)                #; t2  = 0x8000616c, s1  <~~ Word[0x8000616c]
          25735000                                              #; (lsu) t5  <-- 10
          25771000    0x80000780 p.lw s4, 4(t3!)                #; t3  = 0x800061d0, s4  <~~ Word[0x800061d4]
          25779000                                              #; (lsu) t6  <-- 6
          25808000    0x80000784 p.lw s5, t0(t3!)               #; t3  = 0x800061d4, t0  = 28, s5  <~~ Word[0x800061f0]
          25816000                                              #; (lsu) s1  <-- 12
          25852000    0x80000788 p.lw s6, 4(t3!)                #; t3  = 0x800061f0, s6  <~~ Word[0x800061f4]
          25860000                                              #; (lsu) s4  <-- 0
          25889000    0x8000078c p.lw s7, 0(t3!)                #; t3  = 0x800061f4, s7  <~~ Word[0x800061f4]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:24)
#;     c00 += val_a00 * val_b00;
#;                    ^
          25890000    0x80000790 mul t2, t4, s4                 #; t4  = 5, s4  = 0
          25892000                                              #; (acc) t2  <-- 0
          25897000                                              #; (lsu) s5  <-- 0
          25941000                                              #; (lsu) s6  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          25942000    0x80000794 p.mac t2, t5, s6               #; t5  = 10, s6  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:24)
#;     c01 += val_a00 * val_b01;
#;                    ^
          25943000    0x80000798 mul t3, t4, s5                 #; t4  = 5, s5  = 0
          25944000                                              #; (acc) t2  <-- 0
          25945000                                              #; (acc) t3  <-- 0
          25978000                                              #; (lsu) s7  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          25979000    0x8000079c p.mac t3, t5, s7               #; t5  = 10, s7  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:24)
#;     c10 += val_a10 * val_b00;
#;                    ^
          25980000    0x800007a0 mul t4, t6, s4                 #; t6  = 6, s4  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          25981000    0x800007a4 addi t5, a7, 8                 #; a7  = 0x80006148, (wrb) t5  <-- 0x80006150
          25982000    0x800007a8 mv s4, a2                      #; a2  = 0x80006210, (wrb) s4  <-- 0x80006210
          25983000    0x800007ac mv a0, s0                      #; s0  = 0x80005fc8, (wrb) a0  <-- 0x80005fc8
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          25984000    0x800007b0 p.lw s8, 4(t5!)                #; t5  = 0x80006150, s8  <~~ Word[0x80006154]
          25985000    0x800007b4 p.lw s9, t0(t5!)               #; t5  = 0x80006154, t0  = 28, s9  <~~ Word[0x80006170]
          25986000                                              #; (acc) t3  <-- 0
          25987000                                              #; (acc) t4  <-- 0
          26014000    0x800007b8 p.lw s10, 4(t5!)               #; t5  = 0x80006170, s10 <~~ Word[0x80006174]
          26022000                                              #; (lsu) s8  <-- 15
          26051000    0x800007bc p.lw s11, 0(t5!)               #; t5  = 0x80006174, s11 <~~ Word[0x80006174]
          26059000                                              #; (lsu) s9  <-- 20
          26095000    0x800007c0 p.lw ra, 4(s4!)                #; s4  = 0x80006210, ra  <~~ Word[0x80006214]
          26103000                                              #; (lsu) s10 <-- 18
          26132000    0x800007c4 p.lw s2, t0(s4!)               #; s4  = 0x80006214, t0  = 28, s2  <~~ Word[0x80006230]
          26140000                                              #; (lsu) s11 <-- 24
          26176000    0x800007c8 p.lw s0, 4(s4!)                #; s4  = 0x80006230, s0  <~~ Word[0x80006234]
          26184000                                              #; (lsu) ra  <-- 1
          26213000    0x800007cc p.lw s3, 0(s4!)                #; s4  = 0x80006234, s3  <~~ Word[0x80006234]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          26214000    0x800007d0 p.mac t4, s1, s6               #; s1  = 12, s6  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:24)
#;     c11 += val_a10 * val_b01;
#;                    ^
          26215000    0x800007d4 mul t5, t6, s5                 #; t6  = 6, s5  = 0
          26216000                                              #; (acc) t4  <-- 0
          26217000                                              #; (acc) t5  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          26218000    0x800007d8 p.mac t5, s1, s7               #; s1  = 12, s7  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          26219000    0x800007dc p.mac t2, s8, ra               #; s8  = 15, ra  = 1
          26220000                                              #; (acc) t5  <-- 0
          26221000                                              #; (lsu) s2  <-- 0
          26222000                                              #; (acc) t2  <-- 15
          26265000                                              #; (lsu) s0  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          26266000    0x800007e0 p.mac t2, s9, s0               #; s9  = 20, s0  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          26267000    0x800007e4 p.mac t3, s8, s2               #; s8  = 15, s2  = 0
          26268000                                              #; (acc) t2  <-- 15
          26269000                                              #; (acc) t3  <-- 0
          26302000                                              #; (lsu) s3  <-- 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          26303000    0x800007e8 p.mac t3, s9, s3               #; s9  = 20, s3  = 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          26304000    0x800007ec p.mac t4, s10, ra              #; s10 = 18, ra  = 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          26305000    0x800007f0 addi t6, a7, 16                #; a7  = 0x80006148, (wrb) t6  <-- 0x80006158
          26306000    0x800007f4 mv s1, a3                      #; a3  = 0x80006250, (wrb) s1  <-- 0x80006250
          26307000    0x800007f8 p.lw s4, 4(t6!)                #; t6  = 0x80006158, s4  <~~ Word[0x8000615c]
          26308000    0x800007fc p.lw s5, t0(t6!)               #; t6  = 0x8000615c, t0  = 28, s5  <~~ Word[0x80006178]
          26309000                                              #; (acc) t3  <-- 20
          26310000                                              #; (acc) t4  <-- 18
          26338000    0x80000800 p.lw s6, 4(t6!)                #; t6  = 0x80006178, s6  <~~ Word[0x8000617c]
          26346000                                              #; (lsu) s4  <-- 25
          26375000    0x80000804 p.lw s7, 0(t6!)                #; t6  = 0x8000617c, s7  <~~ Word[0x8000617c]
          26383000                                              #; (lsu) s5  <-- 30
          26419000    0x80000808 p.lw s8, 4(s1!)                #; s1  = 0x80006250, s8  <~~ Word[0x80006254]
          26427000                                              #; (lsu) s6  <-- 30
          26456000    0x8000080c p.lw s9, t0(s1!)               #; s1  = 0x80006254, t0  = 28, s9  <~~ Word[0x80006270]
          26464000                                              #; (lsu) s7  <-- 36
          26500000    0x80000810 p.lw ra, 4(s1!)                #; s1  = 0x80006270, ra  <~~ Word[0x80006274]
          26508000                                              #; (lsu) s8  <-- 0
          26537000    0x80000814 p.lw t1, 0(s1!)                #; s1  = 0x80006274, t1  <~~ Word[0x80006274]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          26538000    0x80000818 p.mac t4, s11, s0              #; s11 = 24, s0  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          26539000    0x8000081c p.mac t5, s10, s2              #; s10 = 18, s2  = 0
          26540000                                              #; (acc) t4  <-- 18
          26541000                                              #; (acc) t5  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          26542000    0x80000820 p.mac t5, s11, s3              #; s11 = 24, s3  = 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          26543000    0x80000824 p.mac t2, s4, s8               #; s4  = 25, s8  = 0
          26544000                                              #; (acc) t5  <-- 24
          26545000                                              #; (lsu) s9  <-- 0
          26546000                                              #; (acc) t2  <-- 15
          26589000                                              #; (lsu) ra  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          26590000    0x80000828 p.mac t2, s5, ra               #; s5  = 30, ra  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          26591000    0x8000082c p.mac t3, s4, s9               #; s4  = 25, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          26592000    0x80000830 p.mac t4, s6, s8               #; s6  = 30, s8  = 0, (acc) t2  <-- 15
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          26593000    0x80000834 p.mac t5, s6, s9               #; s6  = 30, s9  = 0, (acc) t3  <-- 20
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          26594000    0x80000838 addi t6, a7, 24                #; a7  = 0x80006148, (wrb) t6  <-- 0x80006160
          26595000    0x8000083c mv s0, a4                      #; a4  = 0x80006290, (wrb) s0  <-- 0x80006290
          26596000    0x80000840 p.lw s1, 4(t6!)                #; t6  = 0x80006160, s1  <~~ Word[0x80006164]
          26597000                                              #; (acc) t4  <-- 18
          26598000                                              #; (acc) t5  <-- 24
          26618000    0x80000844 p.lw s2, t0(t6!)               #; t6  = 0x80006164, t0  = 28, s2  <~~ Word[0x80006180]
          26626000                                              #; (lsu) t1  <-- 0
          26662000    0x80000848 p.lw s3, 4(t6!)                #; t6  = 0x80006180, s3  <~~ Word[0x80006184]
          26670000                                              #; (lsu) s1  <-- 35
          26699000    0x8000084c p.lw s4, 0(t6!)                #; t6  = 0x80006184, s4  <~~ Word[0x80006184]
          26707000                                              #; (lsu) s2  <-- 40
          26743000    0x80000850 p.lw s6, 4(s0!)                #; s0  = 0x80006290, s6  <~~ Word[0x80006294]
          26751000                                              #; (lsu) s3  <-- 42
          26788000    0x80000854 p.lw s8, t0(s0!)               #; s0  = 0x80006294, t0  = 28, s8  <~~ Word[0x800062b0]
          26796000                                              #; (lsu) s4  <-- 48
          26833000    0x80000858 p.lw s9, 4(s0!)                #; s0  = 0x800062b0, s9  <~~ Word[0x800062b4]
          26841000                                              #; (lsu) s6  <-- 0
          26878000    0x8000085c p.lw s10, 0(s0!)               #; s0  = 0x800062b4, s10 <~~ Word[0x800062b4]
          26879000    0x80000860 mv s0, a0                      #; a0  = 0x80005fc8, (wrb) s0  <-- 0x80005fc8
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          26880000    0x80000864 p.mac t3, s5, t1               #; s5  = 30, t1  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          26881000    0x80000868 p.mac t4, s7, ra               #; s7  = 36, ra  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          26882000    0x8000086c p.mac t5, s7, t1               #; s7  = 36, t1  = 0, (acc) t3  <-- 20
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          26883000    0x80000870 p.mac t2, s1, s6               #; s1  = 35, s6  = 0, (acc) t4  <-- 18
          26884000                                              #; (acc) t5  <-- 24
          26885000                                              #; (acc) t2  <-- 15
          26886000                                              #; (lsu) s8  <-- 0
          26931000                                              #; (lsu) s9  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          26932000    0x80000874 p.mac t2, s2, s9               #; s2  = 40, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          26933000    0x80000878 p.mac t3, s1, s8               #; s1  = 35, s8  = 0
          26934000                                              #; (acc) t2  <-- 15
          26935000                                              #; (acc) t3  <-- 20
          26975000                                              #; (lsu) s10 <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          26976000    0x8000087c p.mac t3, s2, s10              #; s2  = 40, s10 = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          26977000    0x80000880 p.mac t4, s3, s6               #; s3  = 42, s6  = 0
          26978000                                              #; (acc) t3  <-- 20
          26979000                                              #; (acc) t4  <-- 18
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          26980000    0x80000884 p.mac t4, s4, s9               #; s4  = 48, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          26981000    0x80000888 p.mac t5, s3, s8               #; s3  = 42, s8  = 0
          26982000                                              #; (acc) t4  <-- 18
          26983000                                              #; (acc) t5  <-- 24
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          26984000    0x8000088c p.mac t5, s4, s10              #; s4  = 48, s10 = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:133:33)
#;     int32_t *idx_c = &C[i * P + j];
#;                               ^
          26985000    0x80000890 lw a0, 24(sp)                  #; sp  = 0x1001f6e8, a0  <~~ Word[0x1001f700]
          26986000                                              #; (acc) t5  <-- 24
          26988000                                              #; (lsu) a0  <-- 2
          26989000    0x80000894 or t1, a0, a6                  #; a0  = 2, a6  = 32, (wrb) t1  <-- 34
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:133:25)
#;     int32_t *idx_c = &C[i * P + j];
#;                       ^
          26990000    0x80000898 slli t1, t1, 2                 #; t1  = 34, (wrb) t1  <-- 136
          26991000    0x8000089c add t1, t1, s0                 #; t1  = 136, s0  = 0x80005fc8, (wrb) t1  <-- 0x80006050
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:134:7)
#;     __asm__ volatile("p.sw %[s00], 4(%[addr_c]!) \n"
#;     ^
          26992000    0x800008a0 p.sw t2, 4(t1!)                #; t1  = 0x80006050, 15 ~~> Word[0x80006054]
          26993000    0x800008a4 p.sw t3, t0(t1!)               #; t1  = 0x80006054, 20 ~~> Word[0x80006070]
          27004000    0x800008a8 p.sw t4, 4(t1!)                #; t1  = 0x80006070, 18 ~~> Word[0x80006074]
          27052000    0x800008ac p.sw t5, 0(t1!)                #; t1  = 0x80006074, 24 ~~> Word[0x80006074]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:88:37)
#;     for (uint32_t i = 2 * (id / c); i < M; i += 2 * (numThreads / c)) {
#;                                       ^
          27053000    0x800008b0 addi a5, a5, 2                 #; a5  = 2, (wrb) a5  <-- 4
          27054000    0x800008b4 addi a6, a6, 16                #; a6  = 32, (wrb) a6  <-- 48
          27055000    0x800008b8 addi a7, a7, 64                #; a7  = 0x80006148, (wrb) a7  <-- 0x80006188
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:88:3)
#;     for (uint32_t i = 2 * (id / c); i < M; i += 2 * (numThreads / c)) {
#;     ^
          27056000    0x800008bc li a0, 6                       #; (wrb) a0  <-- 6
          27057000    0x800008c0 bltu a5, a0, -344              #; a5  = 4, a0  = 6, taken, goto 0x80000768
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          27058000    0x80000768 mv t2, a7                      #; a7  = 0x80006188, (wrb) t2  <-- 0x80006188
          27059000    0x8000076c mv t3, a1                      #; a1  = 0x800061d0, (wrb) t3  <-- 0x800061d0
          27100000    0x80000770 p.lw t4, 4(t2!)                #; t2  = 0x80006188, t4  <~~ Word[0x8000618c]
          27148000    0x80000774 p.lw t5, t0(t2!)               #; t2  = 0x8000618c, t0  = 28, t5  <~~ Word[0x800061a8]
          27196000    0x80000778 p.lw t6, 4(t2!)                #; t2  = 0x800061a8, t6  <~~ Word[0x800061ac]
          27204000                                              #; (lsu) t4  <-- 7
          27232000    0x8000077c p.lw s1, 0(t2!)                #; t2  = 0x800061ac, s1  <~~ Word[0x800061ac]
          27240000                                              #; (lsu) t5  <-- 14
          27268000    0x80000780 p.lw s4, 4(t3!)                #; t3  = 0x800061d0, s4  <~~ Word[0x800061d4]
          27276000                                              #; (lsu) t6  <-- 8
          27304000    0x80000784 p.lw s5, t0(t3!)               #; t3  = 0x800061d4, t0  = 28, s5  <~~ Word[0x800061f0]
          27312000                                              #; (lsu) s1  <-- 16
          27340000    0x80000788 p.lw s6, 4(t3!)                #; t3  = 0x800061f0, s6  <~~ Word[0x800061f4]
          27348000                                              #; (lsu) s4  <-- 0
          27376000    0x8000078c p.lw s7, 0(t3!)                #; t3  = 0x800061f4, s7  <~~ Word[0x800061f4]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:24)
#;     c00 += val_a00 * val_b00;
#;                    ^
          27377000    0x80000790 mul t2, t4, s4                 #; t4  = 7, s4  = 0
          27379000                                              #; (acc) t2  <-- 0
          27384000                                              #; (lsu) s5  <-- 0
          27420000                                              #; (lsu) s6  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          27421000    0x80000794 p.mac t2, t5, s6               #; t5  = 14, s6  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:24)
#;     c01 += val_a00 * val_b01;
#;                    ^
          27422000    0x80000798 mul t3, t4, s5                 #; t4  = 7, s5  = 0
          27423000                                              #; (acc) t2  <-- 0
          27424000                                              #; (acc) t3  <-- 0
          27456000                                              #; (lsu) s7  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          27457000    0x8000079c p.mac t3, t5, s7               #; t5  = 14, s7  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:24)
#;     c10 += val_a10 * val_b00;
#;                    ^
          27458000    0x800007a0 mul t4, t6, s4                 #; t6  = 8, s4  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          27459000    0x800007a4 addi t5, a7, 8                 #; a7  = 0x80006188, (wrb) t5  <-- 0x80006190
          27460000    0x800007a8 mv s4, a2                      #; a2  = 0x80006210, (wrb) s4  <-- 0x80006210
          27461000    0x800007ac mv a0, s0                      #; s0  = 0x80005fc8, (wrb) a0  <-- 0x80005fc8
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          27462000    0x800007b0 p.lw s8, 4(t5!)                #; t5  = 0x80006190, s8  <~~ Word[0x80006194]
          27463000    0x800007b4 p.lw s9, t0(t5!)               #; t5  = 0x80006194, t0  = 28, s9  <~~ Word[0x800061b0]
          27464000                                              #; (acc) t3  <-- 0
          27465000                                              #; (acc) t4  <-- 0
          27484000    0x800007b8 p.lw s10, 4(t5!)               #; t5  = 0x800061b0, s10 <~~ Word[0x800061b4]
          27492000                                              #; (lsu) s8  <-- 21
          27520000    0x800007bc p.lw s11, 0(t5!)               #; t5  = 0x800061b4, s11 <~~ Word[0x800061b4]
          27528000                                              #; (lsu) s9  <-- 28
          27556000    0x800007c0 p.lw ra, 4(s4!)                #; s4  = 0x80006210, ra  <~~ Word[0x80006214]
          27564000                                              #; (lsu) s10 <-- 24
          27592000    0x800007c4 p.lw s2, t0(s4!)               #; s4  = 0x80006214, t0  = 28, s2  <~~ Word[0x80006230]
          27600000                                              #; (lsu) s11 <-- 32
          27628000    0x800007c8 p.lw s0, 4(s4!)                #; s4  = 0x80006230, s0  <~~ Word[0x80006234]
          27636000                                              #; (lsu) ra  <-- 1
          27664000    0x800007cc p.lw s3, 0(s4!)                #; s4  = 0x80006234, s3  <~~ Word[0x80006234]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          27665000    0x800007d0 p.mac t4, s1, s6               #; s1  = 16, s6  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:24)
#;     c11 += val_a10 * val_b01;
#;                    ^
          27666000    0x800007d4 mul t5, t6, s5                 #; t6  = 8, s5  = 0
          27667000                                              #; (acc) t4  <-- 0
          27668000                                              #; (acc) t5  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          27669000    0x800007d8 p.mac t5, s1, s7               #; s1  = 16, s7  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          27670000    0x800007dc p.mac t2, s8, ra               #; s8  = 21, ra  = 1
          27671000                                              #; (acc) t5  <-- 0
          27672000                                              #; (lsu) s2  <-- 0
          27673000                                              #; (acc) t2  <-- 21
          27708000                                              #; (lsu) s0  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          27709000    0x800007e0 p.mac t2, s9, s0               #; s9  = 28, s0  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          27710000    0x800007e4 p.mac t3, s8, s2               #; s8  = 21, s2  = 0
          27711000                                              #; (acc) t2  <-- 21
          27712000                                              #; (acc) t3  <-- 0
          27744000                                              #; (lsu) s3  <-- 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          27745000    0x800007e8 p.mac t3, s9, s3               #; s9  = 28, s3  = 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          27746000    0x800007ec p.mac t4, s10, ra              #; s10 = 24, ra  = 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          27747000    0x800007f0 addi t6, a7, 16                #; a7  = 0x80006188, (wrb) t6  <-- 0x80006198
          27748000    0x800007f4 mv s1, a3                      #; a3  = 0x80006250, (wrb) s1  <-- 0x80006250
          27749000    0x800007f8 p.lw s4, 4(t6!)                #; t6  = 0x80006198, s4  <~~ Word[0x8000619c]
          27750000    0x800007fc p.lw s5, t0(t6!)               #; t6  = 0x8000619c, t0  = 28, s5  <~~ Word[0x800061b8]
          27751000                                              #; (acc) t3  <-- 28
          27752000                                              #; (acc) t4  <-- 24
          27772000    0x80000800 p.lw s6, 4(t6!)                #; t6  = 0x800061b8, s6  <~~ Word[0x800061bc]
          27780000                                              #; (lsu) s4  <-- 35
          27808000    0x80000804 p.lw s7, 0(t6!)                #; t6  = 0x800061bc, s7  <~~ Word[0x800061bc]
          27816000                                              #; (lsu) s5  <-- 42
          27844000    0x80000808 p.lw s8, 4(s1!)                #; s1  = 0x80006250, s8  <~~ Word[0x80006254]
          27852000                                              #; (lsu) s6  <-- 40
          27880000    0x8000080c p.lw s9, t0(s1!)               #; s1  = 0x80006254, t0  = 28, s9  <~~ Word[0x80006270]
          27888000                                              #; (lsu) s7  <-- 48
          27916000    0x80000810 p.lw ra, 4(s1!)                #; s1  = 0x80006270, ra  <~~ Word[0x80006274]
          27924000                                              #; (lsu) s8  <-- 0
          27952000    0x80000814 p.lw t1, 0(s1!)                #; s1  = 0x80006274, t1  <~~ Word[0x80006274]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          27953000    0x80000818 p.mac t4, s11, s0              #; s11 = 32, s0  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          27954000    0x8000081c p.mac t5, s10, s2              #; s10 = 24, s2  = 0
          27955000                                              #; (acc) t4  <-- 24
          27956000                                              #; (acc) t5  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          27957000    0x80000820 p.mac t5, s11, s3              #; s11 = 32, s3  = 1
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          27958000    0x80000824 p.mac t2, s4, s8               #; s4  = 35, s8  = 0
          27959000                                              #; (acc) t5  <-- 32
          27960000                                              #; (lsu) s9  <-- 0
          27961000                                              #; (acc) t2  <-- 21
          27996000                                              #; (lsu) ra  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          27997000    0x80000828 p.mac t2, s5, ra               #; s5  = 42, ra  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          27998000    0x8000082c p.mac t3, s4, s9               #; s4  = 35, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          27999000    0x80000830 p.mac t4, s6, s8               #; s6  = 40, s8  = 0, (acc) t2  <-- 21
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          28000000    0x80000834 p.mac t5, s6, s9               #; s6  = 40, s9  = 0, (acc) t3  <-- 28
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:100:9)
#;     __asm__ volatile(
#;     ^
          28001000    0x80000838 addi t6, a7, 24                #; a7  = 0x80006188, (wrb) t6  <-- 0x800061a0
          28002000    0x8000083c mv s0, a4                      #; a4  = 0x80006290, (wrb) s0  <-- 0x80006290
          28003000    0x80000840 p.lw s1, 4(t6!)                #; t6  = 0x800061a0, s1  <~~ Word[0x800061a4]
          28004000                                              #; (acc) t4  <-- 24
          28005000                                              #; (acc) t5  <-- 32
          28024000    0x80000844 p.lw s2, t0(t6!)               #; t6  = 0x800061a4, t0  = 28, s2  <~~ Word[0x800061c0]
          28032000                                              #; (lsu) t1  <-- 0
          28060000    0x80000848 p.lw s3, 4(t6!)                #; t6  = 0x800061c0, s3  <~~ Word[0x800061c4]
          28068000                                              #; (lsu) s1  <-- 49
          28096000    0x8000084c p.lw s4, 0(t6!)                #; t6  = 0x800061c4, s4  <~~ Word[0x800061c4]
          28104000                                              #; (lsu) s2  <-- 56
          28132000    0x80000850 p.lw s6, 4(s0!)                #; s0  = 0x80006290, s6  <~~ Word[0x80006294]
          28140000                                              #; (lsu) s3  <-- 56
          28169000    0x80000854 p.lw s8, t0(s0!)               #; s0  = 0x80006294, t0  = 28, s8  <~~ Word[0x800062b0]
          28177000                                              #; (lsu) s4  <-- 64
          28213000    0x80000858 p.lw s9, 4(s0!)                #; s0  = 0x800062b0, s9  <~~ Word[0x800062b4]
          28221000                                              #; (lsu) s6  <-- 0
          28257000    0x8000085c p.lw s10, 0(s0!)               #; s0  = 0x800062b4, s10 <~~ Word[0x800062b4]
          28258000    0x80000860 mv s0, a0                      #; a0  = 0x80005fc8, (wrb) s0  <-- 0x80005fc8
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          28259000    0x80000864 p.mac t3, s5, t1               #; s5  = 42, t1  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          28260000    0x80000868 p.mac t4, s7, ra               #; s7  = 48, ra  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          28261000    0x8000086c p.mac t5, s7, t1               #; s7  = 48, t1  = 0, (acc) t3  <-- 28
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:124:13)
#;     c00 += val_a00 * val_b00;
#;         ^
          28262000    0x80000870 p.mac t2, s1, s6               #; s1  = 49, s6  = 0, (acc) t4  <-- 24
          28263000                                              #; (acc) t5  <-- 32
          28264000                                              #; (acc) t2  <-- 21
          28265000                                              #; (lsu) s8  <-- 0
          28309000                                              #; (lsu) s9  <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:125:13)
#;     c00 += val_a01 * val_b10;
#;         ^
          28310000    0x80000874 p.mac t2, s2, s9               #; s2  = 56, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:126:13)
#;     c01 += val_a00 * val_b01;
#;         ^
          28311000    0x80000878 p.mac t3, s1, s8               #; s1  = 49, s8  = 0
          28312000                                              #; (acc) t2  <-- 21
          28313000                                              #; (acc) t3  <-- 28
          28344000                                              #; (lsu) s10 <-- 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:127:13)
#;     c01 += val_a01 * val_b11;
#;         ^
          28345000    0x8000087c p.mac t3, s2, s10              #; s2  = 56, s10 = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:128:13)
#;     c10 += val_a10 * val_b00;
#;         ^
          28346000    0x80000880 p.mac t4, s3, s6               #; s3  = 56, s6  = 0
          28347000                                              #; (acc) t3  <-- 28
          28348000                                              #; (acc) t4  <-- 24
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:129:13)
#;     c10 += val_a11 * val_b10;
#;         ^
          28349000    0x80000884 p.mac t4, s4, s9               #; s4  = 64, s9  = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:130:13)
#;     c11 += val_a10 * val_b01;
#;         ^
          28350000    0x80000888 p.mac t5, s3, s8               #; s3  = 56, s8  = 0
          28351000                                              #; (acc) t4  <-- 24
          28352000                                              #; (acc) t5  <-- 32
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:131:13)
#;     c11 += val_a11 * val_b11;
#;         ^
          28353000    0x8000088c p.mac t5, s4, s10              #; s4  = 64, s10 = 0
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:133:33)
#;     int32_t *idx_c = &C[i * P + j];
#;                               ^
          28354000    0x80000890 lw a0, 24(sp)                  #; sp  = 0x1001f6e8, a0  <~~ Word[0x1001f700]
          28355000                                              #; (acc) t5  <-- 32
          28357000                                              #; (lsu) a0  <-- 2
          28358000    0x80000894 or t1, a0, a6                  #; a0  = 2, a6  = 48, (wrb) t1  <-- 50
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:133:25)
#;     int32_t *idx_c = &C[i * P + j];
#;                       ^
          28359000    0x80000898 slli t1, t1, 2                 #; t1  = 50, (wrb) t1  <-- 200
          28360000    0x8000089c add t1, t1, s0                 #; t1  = 200, s0  = 0x80005fc8, (wrb) t1  <-- 0x80006090
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:134:7)
#;     __asm__ volatile("p.sw %[s00], 4(%[addr_c]!) \n"
#;     ^
          28361000    0x800008a0 p.sw t2, 4(t1!)                #; t1  = 0x80006090, 21 ~~> Word[0x80006094]
          28362000    0x800008a4 p.sw t3, t0(t1!)               #; t1  = 0x80006094, 28 ~~> Word[0x800060b0]
          28364000    0x800008a8 p.sw t4, 4(t1!)                #; t1  = 0x800060b0, 24 ~~> Word[0x800060b4]
          28403000    0x800008ac p.sw t5, 0(t1!)                #; t1  = 0x800060b4, 32 ~~> Word[0x800060b4]
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:88:37)
#;     for (uint32_t i = 2 * (id / c); i < M; i += 2 * (numThreads / c)) {
#;                                       ^
          28404000    0x800008b0 addi a5, a5, 2                 #; a5  = 4, (wrb) a5  <-- 6
          28405000    0x800008b4 addi a6, a6, 16                #; a6  = 48, (wrb) a6  <-- 64
          28406000    0x800008b8 addi a7, a7, 64                #; a7  = 0x80006188, (wrb) a7  <-- 0x800061c8
#; .LBB2_2 (matmul_i32.c:101:5)
#;   matmul_unrolled_2x2_parallel_i32_xpulpv2 (mempool_matmul_i32p.h:88:3)
#;     for (uint32_t i = 2 * (id / c); i < M; i += 2 * (numThreads / c)) {
#;     ^
          28407000    0x800008bc li a0, 6                       #; (wrb) a0  <-- 6
          28408000    0x800008c0 bltu a5, a0, -344              #; a5  = 6, a0  = 6, not taken
          28409000    0x800008c4 j 1152                         #; goto 0x80000d44
#; .LBB2_5 (matmul_i32.c:105:5)
#;   snrt_cluster_hw_barrier (sync.h:174:5)
#;     asm volatile("csrr x0, 0x7C2" ::: "memory");
#;     ^
          28412000    0x80000d44 csrr zero, 1986                #; csr@7c2 = 0
#; .LBB2_5 (matmul_i32.c:106:9)
#;   if (core_id == 0) {
#;       ^
          28435000    0x80000d48 lw a0, 20(sp)                  #; sp  = 0x1001f6e8, a0  <~~ Word[0x1001f6fc]
          28488000                                              #; (lsu) a0  <-- 2
          28489000    0x80000d4c bnez a0, 584                   #; a0  = 2, taken, goto 0x80000f94
#; .LBB2_43 (matmul_i32.c:150:5)
#;   snrt_cluster_hw_barrier (sync.h:174:5)
#;     asm volatile("csrr x0, 0x7C2" ::: "memory");
#;     ^
          28492000    0x80000f94 csrr zero, 1986                #; csr@7c2 = 0
#; .LBB2_43 (matmul_i32.c:151:5)
#;   return 0;
#;   ^
          45700000    0x80000f98 li a0, 0                       #; (wrb) a0  <-- 0
          45701000    0x80000f9c lw ra, 76(sp)                  #; sp  = 0x1001f6e8, ra  <~~ Word[0x1001f734]
          45702000    0x80000fa0 lw s0, 72(sp)                  #; sp  = 0x1001f6e8, s0  <~~ Word[0x1001f730]
          45703000    0x80000fa4 lw s1, 68(sp)                  #; sp  = 0x1001f6e8, s1  <~~ Word[0x1001f72c]
          45704000    0x80000fa8 lw s2, 64(sp)                  #; sp  = 0x1001f6e8, s2  <~~ Word[0x1001f728], (lsu) ra  <-- 0x8000418c
          45705000    0x80000fac lw s3, 60(sp)                  #; sp  = 0x1001f6e8, s3  <~~ Word[0x1001f724], (lsu) s0  <-- 0x1001f778
          45706000    0x80000fb0 lw s4, 56(sp)                  #; sp  = 0x1001f6e8, s4  <~~ Word[0x1001f720], (lsu) s1  <-- 2064
          45707000    0x80000fb4 lw s5, 52(sp)                  #; sp  = 0x1001f6e8, s5  <~~ Word[0x1001f71c], (lsu) s2  <-- 2
          45708000    0x80000fb8 lw s6, 48(sp)                  #; sp  = 0x1001f6e8, s6  <~~ Word[0x1001f718], (lsu) s3  <-- 0
          45709000    0x80000fbc lw s7, 44(sp)                  #; sp  = 0x1001f6e8, s7  <~~ Word[0x1001f714], (lsu) s4  <-- 0
          45710000                                              #; (lsu) s5  <-- 2
          45711000                                              #; (lsu) s6  <-- 0x80005ed8
          45712000                                              #; (lsu) s7  <-- 0x80005ed8
          45720000    0x80000fc0 lw s8, 40(sp)                  #; sp  = 0x1001f6e8, s8  <~~ Word[0x1001f710]
          45721000    0x80000fc4 lw s9, 36(sp)                  #; sp  = 0x1001f6e8, s9  <~~ Word[0x1001f70c]
          45722000    0x80000fc8 lw s10, 32(sp)                 #; sp  = 0x1001f6e8, s10 <~~ Word[0x1001f708]
          45723000    0x80000fcc lw s11, 28(sp)                 #; sp  = 0x1001f6e8, s11 <~~ Word[0x1001f704], (lsu) s8  <-- 0x80005ef8
          45724000    0x80000fd0 addi sp, sp, 80                #; sp  = 0x1001f6e8, (wrb) sp  <-- 0x1001f738
          45725000    0x80000fd4 ret                            #; ra  = 0x8000418c, (lsu) s9  <-- 6192, goto 0x8000418c
          45726000                                              #; (lsu) s10 <-- 7224
          45727000                                              #; (lsu) s11 <-- 8256
#; .LBB25_16 (start.c:268:5)
#;   snrt_cluster_hw_barrier (sync.h:174:5)
#;     asm volatile("csrr x0, 0x7C2" ::: "memory");
#;     ^
          45731000    0x8000418c csrr zero, 1986                #; csr@7c2 = 0
#; .LBB25_16 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:293:34)
#;         cls (cls.h:9:30)
#;           inline cls_t* cls() { return _cls_ptr; }
#;                                        ^
          45738000    0x80004190 lw a1, 64(s0)                  #; s0  = 0x1001f778, a1  <~~ Word[0x1001f7b8]
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
          45761000                                              #; (lsu) a0  <-- 0
#; .LBB25_16 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:297:5)
#;         snrt_wait_writeback (sync.h:404:5)
#;           asm volatile("mv %0, %0" : "+r"(val)::);
#;           ^
          45762000    0x8000419c mv a0, a0                      #; a0  = 0, (wrb) a0  <-- 0
#; .LBB25_16 (start.c:276:5)
#;   snrt_exit (start.h:20:40)
#;     snrt_exit_default (start.h:11:17)
#;       snrt_global_all_to_all_reduction (sync.h:298:5)
#;         snrt_cluster_hw_barrier (sync.h:174:5)
#;           asm volatile("csrr x0, 0x7C2" ::: "memory");
#;           ^
          45763000    0x800041a0 csrr zero, 1986                #; csr@7c2 = 0
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
          45810000    0x800041f8 lw ra, 60(sp)                  #; sp  = 0x1001f738, ra  <~~ Word[0x1001f774]
          45811000    0x800041fc lw s0, 56(sp)                  #; sp  = 0x1001f738, s0  <~~ Word[0x1001f770]
          45813000                                              #; (lsu) ra  <-- 0x800001c4
          45814000                                              #; (lsu) s0  <-- 0
          45816000    0x80004200 lw s1, 52(sp)                  #; sp  = 0x1001f738, s1  <~~ Word[0x1001f76c]
          45817000    0x80004204 lw s2, 48(sp)                  #; sp  = 0x1001f738, s2  <~~ Word[0x1001f768]
          45818000    0x80004208 lw s3, 44(sp)                  #; sp  = 0x1001f738, s3  <~~ Word[0x1001f764]
          45819000                                              #; (lsu) s1  <-- 0
          45820000    0x8000420c lw s4, 40(sp)                  #; sp  = 0x1001f738, s4  <~~ Word[0x1001f760]
          45821000    0x80004210 lw s5, 36(sp)                  #; sp  = 0x1001f738, s5  <~~ Word[0x1001f75c], (lsu) s2  <-- 0
          45822000    0x80004214 lw s6, 32(sp)                  #; sp  = 0x1001f738, s6  <~~ Word[0x1001f758], (lsu) s3  <-- 0
          45823000    0x80004218 lw s7, 28(sp)                  #; sp  = 0x1001f738, s7  <~~ Word[0x1001f754], (lsu) s4  <-- 0
          45824000    0x8000421c lw s8, 24(sp)                  #; sp  = 0x1001f738, s8  <~~ Word[0x1001f750], (lsu) s5  <-- 0
          45825000                                              #; (lsu) s6  <-- 0
          45826000    0x80004220 lw s9, 20(sp)                  #; sp  = 0x1001f738, s9  <~~ Word[0x1001f74c]
          45827000    0x80004224 lw s10, 16(sp)                 #; sp  = 0x1001f738, s10 <~~ Word[0x1001f748], (lsu) s7  <-- 0
          45828000                                              #; (lsu) s8  <-- 0
          45829000    0x80004228 lw s11, 12(sp)                 #; sp  = 0x1001f738, s11 <~~ Word[0x1001f744]
          45830000    0x8000422c addi sp, sp, 64                #; sp  = 0x1001f738, (wrb) sp  <-- 0x1001f778
          45831000    0x80004230 ret                            #; ra  = 0x800001c4, (lsu) s9  <-- 0, goto 0x800001c4
          45832000                                              #; (lsu) s10 <-- 0
          45833000                                              #; (lsu) s11 <-- 0
#; .Ltmp2 (start.S:183)
#;   wfi
          45834000    0x800001c4 wfi                            #; 

## Performance metrics

Performance metrics for section 0 @ (10, 45832):
tstart                                          12
snitch_loads                                   229
snitch_stores                                  567
tend                                         45834
fpss_loads                                       0
snitch_avg_load_latency                      51.34
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
