// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "snrt.h"

/**
 * @struct conv_layer_struct
 * @brief This structure contains all parameters necessary for Convolutional
 * layers
 * @var conv_layer_struct::CO
 * Number of output channels
 * @var conv_layer_struct::CI
 * Number of input channels
 * @var conv_layer_struct::IH
 * Height of input feature map
 * @var conv_layer_struct::IW
 * Width of input feature map
 * @var conv_layer_struct::OH
 * Height of output feature map
 * @var conv_layer_struct::OW
 * Width of output feature map
 * @var conv_layer_struct::FH
 * Height of filter
 * @var conv_layer_struct::FW
 * Width of filter
 * @var conv_layer_struct::ifmap
 * Pointer to input feature map
 * @var conv_layer_struct::ofmap
 * Pointer to output feature map
 * @var conv_layer_struct::tile_ci
 * Tiling factor of input channel
 * @var gemm_layer_struct::dtype
 * Precision of Convolution layer
 */
typedef struct maxpool_layer_struct {
    uint32_t CO;
    uint32_t CI;
    uint32_t IH;
    uint32_t IW;
    uint32_t OH;
    uint32_t OW;
    uint32_t FH;
    uint32_t FW;
    uint32_t tile_ci;
    double *ifmap;
    double *ofmap;
    precision_t dtype;
} maxpool_layer_t;

/**
 * @brief implementation of FP64 maxpooling
 *
 * @param ifmap pointer to input feature map
 * @param ofmap pointer to output feature map
 * @param CI number of input channels
 * @param FH height of filter
 * @param FW width of filter
 * @param compute_num number of compute units
 */
static inline void maxpool_fp64(double *ifmap, double *ofmap, uint32_t CI,
                                uint32_t FH, uint32_t FW,
                                uint32_t compute_num) {
    for (uint32_t ci = 0; ci < CI; ci += compute_num) {
        volatile double max = ifmap[ci];
        for (uint32_t fh = 0; fh < FH; fh++) {
            for (uint32_t fw = 0; fw < FW; fw++) {
                if (ifmap[(fh * FW + fw) * CI + ci] > max) {
                    max = ifmap[(fh * FW + fw) * CI + ci];
                }
            }
        }
        ofmap[ci] = max;
    }
}

static inline void maxpool_layer(const maxpool_layer_t *l) {
    uint32_t cluster_num = snrt_cluster_num();
    uint32_t cluster_id = snrt_cluster_idx();
    uint32_t compute_num = snrt_cluster_compute_core_num();
    uint32_t compute_id = snrt_global_core_idx();

    // Each cluster loads one tile of kernel size
    uint32_t ifmap_size = 2 * l->FH * l->FW * l->tile_ci;
    uint32_t ofmap_size = 2 * l->tile_ci;

    double *ptr = (double *)snrt_l1_next();
    double *ifmap = ptr;
    ptr += ifmap_size;
    double *ofmap = ptr;
    ptr += ofmap_size;

    uint32_t read_buf = 0;
    uint32_t write_buf = 0;

    uint32_t prev_oh;
    uint32_t prev_ow;
    uint32_t prev_ci;

    // tiles are distributed across clusters
    for (uint32_t tile = cluster_id; tile < l->OH * l->OW;
         tile += cluster_num) {
        for (uint32_t ci = 0; ci < l->CI; ci += l->tile_ci) {
            uint32_t oh = tile / l->OW;
            uint32_t ow = tile % l->OW;

            if (snrt_is_dm_core()) {
                for (uint32_t fh = 0; fh < l->FH; fh++) {
                    if (l->tile_ci == l->CI) {
                        snrt_dma_start_1d(
                            &ifmap[write_buf * (ifmap_size / 2) +
                                   fh * l->FW * l->tile_ci], /* dst */
                            &l->ifmap[((oh * l->FH + fh) * l->IW + ow * l->FW) *
                                      l->CI], /* src */
                            sizeof(double) * l->tile_ci * l->FW /* size */);
                    } else {
                        // printf("bubu\n");
                        snrt_dma_start_2d(
                            &ifmap[write_buf * (ifmap_size / 2) +
                                   fh * l->FW * l->tile_ci], /* dst */
                            &l->ifmap[((oh * l->FH + fh) * l->IW + ow * l->FW) *
                                          l->CI +
                                      ci],               /* src */
                            sizeof(double) * l->tile_ci, /* size */
                            sizeof(double) * l->tile_ci, /* dst_stride */
                            sizeof(double) * l->CI,      /* src_stride */
                            l->FW /* repetitions */);
                    }
                }
                snrt_dma_wait_all();

                // synchronize with compute cores after loading data
                snrt_cluster_hw_barrier();

                if (!(tile == cluster_id && ci == 0)) {
                    snrt_dma_start_2d(
                        &l->ofmap[(prev_oh * l->OW + prev_ow) * l->CI +
                                  prev_ci],                   /* dst */
                        &ofmap[!read_buf * (ofmap_size / 2)], /* src */
                        sizeof(double) * l->tile_ci,          /* size */
                        sizeof(double) * l->CI,               /* dst_stride */
                        sizeof(double) * l->tile_ci,          /* src_stride */
                        1 /* repetitions */);
                }

                snrt_dma_wait_all();
                write_buf = !write_buf;
                read_buf = !read_buf;
                prev_ci = ci;
                prev_oh = oh;
                prev_ow = ow;
            }

            if (snrt_is_compute_core()) {
                // wait for data to arrive
                snrt_cluster_hw_barrier();

                maxpool_fp64(&ifmap[read_buf * ifmap_size / 2 + compute_id],
                             &ofmap[write_buf * ofmap_size / 2 + compute_id],
                             l->tile_ci, l->FH, l->FW, compute_num);

                write_buf = !write_buf;
                read_buf = !read_buf;
            }
        }
    }

    snrt_cluster_hw_barrier();

    if (snrt_is_dm_core()) {
        snrt_dma_start_2d(
            &l->ofmap[(prev_oh * l->OW + prev_ow) * l->CI + prev_ci], /* dst */
            &ofmap[!read_buf * (ofmap_size / 2)],                     /* src */
            sizeof(double) * l->tile_ci,                              /* size */
            sizeof(double) * l->CI,      /* dst_stride */
            sizeof(double) * l->tile_ci, /* src_stride */
            1 /* repetitions */);
        snrt_dma_wait_all();
    }
}
