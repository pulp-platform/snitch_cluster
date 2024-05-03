#define MSTATUS_MIE 8

.global _snitch_park
_snitch_park:
    # Set core id
    csrr    a0, mhartid
    # Set trap vector
    la      t0, _snitch_resume
    csrw    mtvec, t0
    # Enable software and cluster interrupts
    csrsi   mstatus, MSTATUS_MIE # CSR set (uimm) 
    lui     t0, 0x80  # (1 << 19) cluster interrupts
    addi    t0, t0, 8 # (1 << 3) software interrupts
    csrw    mie, t0
    wfi

_snitch_resume:
    la      t0, ctrl_scratch1
    lw      t0, 0(t0)
    jalr    ra, 0(t0)
    j       _snitch_park
