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

#ifndef FGEMV_FP32_H
#define FGEMV_FP32_H

// a is the M x N matrix stored column-major (i.e. as its N x M transpose),
// b is the N-element vector, c is the M-element result: c = a * b
void gemv(float *a, float *b, float *c, const unsigned int M,
          const unsigned int M_core, const unsigned int N);

#endif
