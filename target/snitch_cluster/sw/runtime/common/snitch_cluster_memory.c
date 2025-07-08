// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

extern volatile snitch_cluster_t* snrt_cluster_alias();

extern volatile snitch_cluster_t* snrt_cluster(int cluster_idx);

extern volatile snitch_cluster_t* snrt_cluster();
