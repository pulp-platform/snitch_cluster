#include "snrt.h"
#include "math.h"
#include "stdint.h"
#include "stdbool.h"

#include "common.h"

#include "box3d1r_naive.h"
#include "box3d1r_baseline1.h"
#include "box3d1r_baseline2.h"
#include "box3d1r_baseline3.h"
#include "box3d1r_baseline4.h"
#include "box3d1r_opt1.h"
#include "box3d1r_opt2.h"

#define IMPL_NAIVE 0
#define IMPL_BASELINE_1 1
#define IMPL_BASELINE_2 2
#define IMPL_BASELINE_3 3
#define IMPL_BASELINE_4 4
#define IMPL_OPTIMIZED_1 5
#define IMPL_OPTIMIZED_2 6

#ifndef IMPL
#define IMPL IMPL_OPTIMIZED_2
#endif

#if IMPL == IMPL_NAIVE
#define FUNC_PTR box3d1r_naive
#elif IMPL == IMPL_BASELINE_1
#define FUNC_PTR box3d1r_baseline1
#elif IMPL == IMPL_BASELINE_2
#define FUNC_PTR box3d1r_baseline2
#elif IMPL == IMPL_BASELINE_3
#define FUNC_PTR box3d1r_baseline3
#elif IMPL == IMPL_BASELINE_4
#define FUNC_PTR box3d1r_baseline4
#elif IMPL == IMPL_OPTIMIZED_1
#define FUNC_PTR box3d1r_opt1
#elif IMPL == IMPL_OPTIMIZED_2
#define FUNC_PTR box3d1r_opt2
#endif

// The Kernel
static inline void box3d1r(int r, int nx, int ny, int nz, double* c, double* A, double* A_) {
    FUNC_PTR(r, nx, ny, nz, c, A, A_);
}
