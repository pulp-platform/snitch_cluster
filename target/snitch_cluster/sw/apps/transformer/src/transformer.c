// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// SW testbench for profiling a Transformer
// Automatically checks the correctness of the results

#include "dnn.h"
#include "snrt.h"

#include "data.h"

int main() {

    switch(transformer_l.dtype) {
        case FP64:
            // Input data
            transformer_l.ifmap = (double *)transformer_ifmap_dram;
            // Weights for query, key, value
            transformer_l.weights_q = (double *)transformer_weights_q_dram;
            transformer_l.weights_k = (double *)transformer_weights_k_dram;
            transformer_l.weights_v = (double *)transformer_weights_v_dram;
            // transformer_l.weights_o = (double *)transformer_weights_o_dram;
            // Write back location for output in DRAM
            transformer_l.Q_lin = (double *)transformer_Q_lin_dram;
            transformer_l.K_lin = (double *)transformer_K_lin_dram;
            transformer_l.V_lin = (double *)transformer_V_lin_dram;
            // Matrices for FlashAttention-2
            transformer_l.Q_fa = (double *)transformer_q_fa_dram;
            transformer_l.K_fa = (double *)transformer_k_fa_dram;
            transformer_l.V_fa = (double *)transformer_v_fa_dram;
            transformer_l.O = (double *)transformer_O_dram;
            // Matrices for Concatenation
            transformer_l.ifmap_lin2 = (double *)transformer_ifmap_lin2_dram; 
            transformer_l.weights_lin2 = (double *)transformer_weights_lin2_dram;
            transformer_l.O_lin2 = (double *)transformer_O_lin2_dram;

            transformer_layer_fp64(&transformer_l);
            break;

        case FP32:
            // Input data
            transformer_l.ifmap = (float *)transformer_ifmap_dram;
            // Weights for query, key, value
            // transformer_l.weights_q = (float *)transformer_weights_q_dram;
            // transformer_l.weights_k = (float *)transformer_weights_k_dram;
            // transformer_l.weights_v = (float *)transformer_weights_v_dram;
            // transformer_l.weights_o = (float *)transformer_weights_o_dram;
            // Write back location for output in DRAM
            transformer_l.Q_lin = (float *)transformer_Q_lin_dram;
            transformer_l.K_lin = (float *)transformer_K_lin_dram;
            transformer_l.V_lin = (float *)transformer_V_lin_dram;
            transformer_l.O = (float *)transformer_O_dram;

            transformer_layer_fp32(&transformer_l);
            break;


    }

    snrt_global_barrier();

    return 0;

    // return errors;
}
