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

#include "fgemv_fp32.h"

void gemv(float *a, float *b, float *c, const unsigned int M,
          const unsigned int M_core, const unsigned int N) {
    unsigned int vl, avl = M_core;
    float *a_, *a_start = a;
    float *b_ = b;
    float *c_ = c;

    do {
        a_ = a_start;
        asm volatile("vsetvli %0, %1, e32, m4, ta, ma" : "=r"(vl) : "r"(avl));
        for (unsigned int col = 0; col < N; col += 2) {
            // Load chunk a
            asm volatile("vle32.v v0, (%0)" ::"r"(a_));
            a_ += M;

            // Multiply and accumulate
            if (col == 0) {
                asm volatile("vfmul.vf v4, v0, %0" ::"f"(*b_));
            } else {
                asm volatile("vfmacc.vf v4, %0, v0" ::"f"(*b_));
            }
            b_++;

            // Load chunk a
            asm volatile("vle32.v v8, (%0)" ::"r"(a_));
            a_ += M;

            // Multiply and accumulate
            if (col == 0) {
                asm volatile("vfmul.vf v12, v8, %0" ::"f"(*b_));
            } else {
                asm volatile("vfmacc.vf v12, %0, v8" ::"f"(*b_));
            }
            b_++;
        }
        asm volatile("vfadd.vv v12, v12, v4");
        asm volatile("vse32.v v12, (%0)" ::"r"(c_));
        avl -= vl;
        c_ += vl;
        b_ = b;
        a_start += vl;
    } while (avl > 0);
}
