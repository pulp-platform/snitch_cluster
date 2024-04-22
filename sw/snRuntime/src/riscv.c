
#include "riscv_decls.h"

#include "riscv.h"

extern inline void snrt_wfi();

extern inline void snrt_nop();

extern uint32_t snrt_mcycle();

extern void snrt_interrupt_enable(uint32_t irq);

extern void snrt_interrupt_disable(uint32_t irq);

extern void snrt_interrupt_global_enable(void);

extern void snrt_interrupt_global_disable(void);
