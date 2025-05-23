// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

#include <stdint.h>

#include "args.h"
#include "math.h"
#include "snrt.h"

// Explicitly place in TCDM, through thread-local storage.
// Otherwise every core loads it from DRAM.
__thread double inf = INFINITY;

double euclidean_distance_squared(uint32_t n_features, double* point1,
                                  double* point2) {
    double sum = 0;
    for (uint32_t i = 0; i < n_features; i++) {
        double diff = point1[i] - point2[i];
        sum += diff * diff;
    }
    return sum;
}

static inline void kmeans_iteration(uint32_t n_samples_per_core,
                                    uint32_t n_clusters, uint32_t n_features,
                                    double* samples, uint32_t* membership,
                                    uint32_t* partial_membership_cnt,
                                    double* initial_centroids,
                                    double* partial_centroids) {
    // Distribute work
    uint32_t start_sample_idx;
    uint32_t end_sample_idx;
    if (snrt_is_compute_core()) {
        start_sample_idx = snrt_cluster_core_idx() * n_samples_per_core;
        end_sample_idx = start_sample_idx + n_samples_per_core;

        snrt_mcycle();

        // Assignment step
        for (uint32_t centroid_idx = 0; centroid_idx < n_clusters;
             centroid_idx++) {
            partial_membership_cnt[centroid_idx] = 0;
        }
        snrt_fpu_fence();
        for (uint32_t sample_idx = start_sample_idx;
             sample_idx < end_sample_idx; sample_idx++) {
            double min_dist = inf;
            membership[sample_idx] = 0;

            for (uint32_t centroid_idx = 0; centroid_idx < n_clusters;
                 centroid_idx++) {
                double dist = euclidean_distance_squared(
                    n_features, &samples[sample_idx * n_features],
                    &initial_centroids[centroid_idx * n_features]);
                if (dist < min_dist) {
                    min_dist = dist;
                    membership[sample_idx] = centroid_idx;
                }
            }
            partial_membership_cnt[membership[sample_idx]]++;
        }
    }

    snrt_mcycle();

    // snrt_global_barrier();

    snrt_mcycle();

    if (snrt_is_compute_core()) {
        // Update step
        for (uint32_t centroid_idx = 0; centroid_idx < n_clusters;
             centroid_idx++) {
            for (uint32_t feature_idx = 0; feature_idx < n_features;
                 feature_idx++) {
                // Initialize centroids to zero
                // TODO: Can be optimized w/ DMA
                partial_centroids[centroid_idx * n_features + feature_idx] = 0;
            }
        }
        snrt_fpu_fence();
        for (uint32_t sample_idx = start_sample_idx;
             sample_idx < end_sample_idx; sample_idx++) {
            for (uint32_t feature_idx = 0; feature_idx < n_features;
                 feature_idx++) {
                partial_centroids[membership[sample_idx] * n_features +
                                  feature_idx] +=
                    samples[sample_idx * n_features + feature_idx];
            }
        }
    }

    snrt_mcycle();

    snrt_cluster_hw_barrier();

    snrt_mcycle();

    if (snrt_is_compute_core()) {
        if (snrt_cluster_core_idx() == 0) {
            // Intra-cluster reduction
            for (uint32_t core_idx = 1;
                 core_idx < snrt_cluster_compute_core_num(); core_idx++) {
                // Pointers to variables of the other core
                uint32_t* remote_partial_membership_cnt =
                    (uint32_t*)snrt_compute_core_local_ptr(
                        partial_membership_cnt, core_idx,
                        n_clusters * sizeof(uint32_t));
                double* remote_partial_centroids =
                    (double*)snrt_compute_core_local_ptr(
                        partial_centroids, core_idx,
                        n_clusters * n_features * sizeof(double));
                for (uint32_t centroid_idx = 0; centroid_idx < n_clusters;
                     centroid_idx++) {
                    // Accumulate membership counters
                    partial_membership_cnt[centroid_idx] +=
                        remote_partial_membership_cnt[centroid_idx];
                    // Accumulate centroid features
                    for (uint32_t feature_idx = 0; feature_idx < n_features;
                         feature_idx++) {
                        partial_centroids[centroid_idx * n_features +
                                          feature_idx] +=
                            remote_partial_centroids[centroid_idx * n_features +
                                                     feature_idx];
                    }
                }
            }

            snrt_mcycle();

#if !defined(KMEANS_REDUCTION_ON_HOST)
            snrt_inter_cluster_barrier();

            if (snrt_cluster_idx() == 0) {
                snrt_mcycle();

                // Inter-cluster reduction
                for (uint32_t cluster_idx = 1; cluster_idx < snrt_cluster_num();
                     cluster_idx++) {
                    // Pointers to variables of remote clusters
                    uint32_t* remote_partial_membership_cnt =
                        (uint32_t*)snrt_remote_l1_ptr(partial_membership_cnt, 0,
                                                      cluster_idx);
                    double* remote_partial_centroids =
                        (double*)snrt_remote_l1_ptr(partial_centroids, 0,
                                                    cluster_idx);
                    for (uint32_t centroid_idx = 0; centroid_idx < n_clusters;
                         centroid_idx++) {
                        // Accumulate membership counters
                        partial_membership_cnt[centroid_idx] +=
                            remote_partial_membership_cnt[centroid_idx];
                        // Accumulate centroid features
                        for (uint32_t feature_idx = 0; feature_idx < n_features;
                             feature_idx++) {
                            partial_centroids[centroid_idx * n_features +
                                              feature_idx] +=
                                remote_partial_centroids[centroid_idx *
                                                             n_features +
                                                         feature_idx];
                        }
                    }
                }

                snrt_mcycle();

                // Normalize
                for (uint32_t centroid_idx = 0; centroid_idx < n_clusters;
                     centroid_idx++) {
                    for (uint32_t feature_idx = 0; feature_idx < n_features;
                         feature_idx++) {
                        partial_centroids[centroid_idx * n_features +
                                          feature_idx] /=
                            partial_membership_cnt[centroid_idx];
                    }
                }
            }

            snrt_mcycle();
#endif
        }
    }
}

void kmeans_job(kmeans_args_t* args) {
    snrt_mcycle();

    // Aliases
    uint32_t n_samples = args->n_samples;
    uint32_t n_features = args->n_features;
    uint32_t n_clusters = args->n_clusters;
    uint32_t n_iter = args->n_iter;
    double* samples = (double*)(args->samples_addr);
    double* centroids = (double*)(args->centroids_addr);

    // Distribute work
    uint32_t n_samples_per_cluster = n_samples / snrt_cluster_num();
    uint32_t n_samples_per_core =
        n_samples_per_cluster / snrt_cluster_compute_core_num();

    // Dynamically allocate space in TCDM
    double* local_samples = (double*)snrt_l1_alloc_cluster_local(
        n_samples_per_cluster * n_features * sizeof(double), sizeof(double));
    double* local_centroids = (double*)snrt_l1_alloc_cluster_local(
        n_clusters * n_features * sizeof(double), sizeof(double));
    uint32_t* membership = (uint32_t*)snrt_l1_alloc_cluster_local(
        n_samples_per_cluster * sizeof(uint32_t), sizeof(uint32_t));
    uint32_t* partial_membership_cnt =
        (uint32_t*)snrt_l1_alloc_compute_core_local(
            n_clusters * sizeof(uint32_t), sizeof(uint32_t));
    // First core's partial centroids will store final centroids
    double* partial_centroids = (double*)snrt_l1_alloc_compute_core_local(
        n_clusters * n_features * sizeof(double), sizeof(double));
    double* final_centroids = (double*)snrt_compute_core_local_ptr(
        partial_centroids, 0, n_clusters * n_features * sizeof(double));
    final_centroids =
        (double*)snrt_remote_l1_ptr(final_centroids, snrt_cluster_idx(), 0);

    snrt_mcycle();

    // Transfer samples and initial centroids with DMA
    size_t size;
    size_t offset;
    if (snrt_is_dm_core()) {
        size = n_samples_per_cluster * n_features;
        offset = snrt_cluster_idx() * size;
        snrt_dma_start_1d(local_samples, samples + offset,
                          size * sizeof(double));
        size = n_clusters * n_features * sizeof(double);
        snrt_dma_start_1d(local_centroids, centroids, size * sizeof(double));
        snrt_dma_wait_all();
    }

    snrt_cluster_hw_barrier();

    snrt_mcycle();

    // Iterations of Lloyd's K-means algorithm
    for (uint32_t iter_idx = 0; iter_idx < n_iter; iter_idx++) {
        kmeans_iteration(n_samples_per_core, n_clusters, n_features,
                         local_samples, membership, partial_membership_cnt,
                         local_centroids, partial_centroids);
        snrt_global_barrier();
        local_centroids = final_centroids;
        snrt_mcycle();
    }

    // Transfer final centroids with DMA
    if (snrt_is_dm_core() && snrt_cluster_idx() == 0) {
        snrt_dma_start_1d((void*)centroids, (void*)final_centroids, size);
        snrt_dma_wait_all();
    }
}
