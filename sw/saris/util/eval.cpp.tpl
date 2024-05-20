// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "runtime.hpp"
#include "istc.par.hpp"
#include "istc.issr.hpp"

${datadecls}
${bundledecls}

${ctgrids}

${ciparams}

TCDMDECL volatile uint32_t err_sema = 0;

EXTERN_C int smain(uint32_t core_id, uint32_t core_num, void* tcdm_start, void* tcdm_end) {

    // Kick DMCC
    if (core_id == core_num-1) {
        __rt_barrier();

% for i in range(nbarriers):
        // Kernel ${i}
${indent(dma_transfers, " "*8)}
        __rt_barrier();
% endfor
        goto past_knl;
    }

    __rt_barrier();
    __rt_get_timer();
% for k in kernels:
    ${k[1]};
    __rt_get_timer();
% endfor

past_knl:
% for name, touch in touches.items():
    if (core_id == 0) printf("touching `${name}`\n");
    __istc_touch_grid(
        core_id, core_num, ${touch['stride']},
        ${touch['ptr']}, ${touch['len']}, &err_sema
    );
% endfor
% for i, check in enumerate(checks):
    if (core_id == 0) printf("Performing check ${i}\n");
    __istc_cmp_grids(
        core_id, core_num, ${check['stride']},
        ${check['a']}, ${check['b']}, ${check['len']}, ${check['eps']},
        &err_sema
    );
% endfor

    return err_sema;
}

${datainits}
