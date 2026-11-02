// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Arpan Suravi Prasad <prasadar@iis.ee.ethz.ch>

#include "pace_softmax.h"

int main() {
    pace_softmax_work_t work;
    if (pace_softmax_init_work(&work)) {
        return 1;
    }

    pace_softmax_buffers_t buffers = pace_softmax_init_buffers(&work);

    pace_softmax_configure(&work);
    snrt_cluster_hw_barrier();

    pace_softmax_load_exp_params_and_input(&buffers);
    snrt_cluster_hw_barrier();

    pace_softmax_compute_exp_stage(&work, &buffers);
    snrt_cluster_hw_barrier();

    pace_softmax_load_inv_params(&buffers);
    snrt_cluster_hw_barrier();

    pace_softmax_compute_output_stage(&work, &buffers);
    snrt_cluster_hw_barrier();

    pace_softmax_store_output(&buffers);
    snrt_cluster_hw_barrier();

    // pace_softmax_check();
    // snrt_cluster_hw_barrier();

    return 0;
}
