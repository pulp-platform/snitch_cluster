// Copyright 2025 ETH Zurich and University of Bologna.
//
// SPDX-License-Identifier: Apache-2.0
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Author: Navaneeth Kunhi Purayil, ETH Zurich

#include "fgemv_fp16.h"

void gemv(__fp16 *a, __fp16 *b, __fp16 *c, const unsigned int M,
          const unsigned int M_core, const unsigned int N) {
    unsigned int vl, avl = M_core;
    __fp16 *a_, *a_start = a;
    __fp16 *b_ = b;
    __fp16 *c_ = c;

    do {
        a_ = a_start;
        asm volatile("vsetvli %0, %1, e16, m4, ta, ma" : "=r"(vl) : "r"(avl));
        for (unsigned int col = 0; col < N; col += 2) {
            // Load chunk a
            asm volatile("vle16.v v0, (%0)" ::"r"(a_));
            a_ += M;

            // Load chunk a
            asm volatile("vle16.v v8, (%0)" ::"r"(a_));
            a_ += M;

            // Multiply and accumulate. Loaded via flh (not a plain C load)
            // so the scalar operand keeps the raw fp16 bit pattern expected
            // by vfmacc.vf/vfmul.vf under e16 SEW; a plain C load would
            // widen __fp16 to float.
            float t0;
            asm volatile("flh %[t], 0(%[b])" : [t] "=f"(t0) : [b] "r"(b_));
            if (col == 0) {
                asm volatile("vfmul.vf v4, v0, %0" ::"f"(t0));
            } else {
                asm volatile("vfmacc.vf v4, %0, v0" ::"f"(t0));
            }
            b_++;

            // Multiply and accumulate
            float t1;
            asm volatile("flh %[t], 0(%[b])" : [t] "=f"(t1) : [b] "r"(b_));
            if (col == 0) {
                asm volatile("vfmul.vf v12, v8, %0" ::"f"(t1));
            } else {
                asm volatile("vfmacc.vf v12, %0, v8" ::"f"(t1));
            }
            b_++;
        }
        asm volatile("vfadd.vv v12, v12, v4");
        asm volatile("vse16.v v12, (%0)" ::"r"(c_));
        avl -= vl;
        c_ += vl;
        b_ = b;
        a_start += vl;
    } while (avl > 0);
}
