// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Nico Canzani <ncanzani@ethz.ch>
// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

#include "snrt.h"

void swap(int32_t* a, int32_t* b) {
    int32_t temp = *a;
    *a = *b;
    *b = temp;
}

int32_t* partition(int32_t* low, int32_t* high) {
    int32_t pivot = *high;  // Pivot element (can be chosen randomly)
    int32_t* i = low - 1;   // Index of smaller element

    for (int32_t* j = low; j < high; j++) {
        if (*j <= pivot) {
            i++;
            swap(i, j);
        }
    }
    swap(i + 1, high);
    return (i + 1);
}

void quicksort(int32_t* low, int32_t* high) {
    if (low < high) {
        int32_t* pi = partition(low, high);  // Partitioning index

        quicksort(low, pi - 1);
        quicksort(pi + 1, high);
    }
}

void prefixSum(const int* a, int* b, size_t n) {
    // Initialize the first element of the prefix sum array to 0
    b[0] = 0;

    // Loop through the array and compute prefix sums
    for (size_t i = 1; i < n; ++i) {
        b[i] = b[i - 1] + a[i - 1];
    }
}

void bucketSort(int32_t* x, uint32_t n, uint32_t numBuckets, int32_t maximum,
                int32_t minimum) {
    int32_t ttemp = snrt_mcycle();

    int32_t core_idx = snrt_cluster_core_idx();
    int frac_core = n / snrt_cluster_compute_core_num();
    int offset_core = core_idx * frac_core;

    // Create buckets shared over all cores in Cluster
    int32_t* bucketscratchpad = x + n;
    int32_t* buckets[numBuckets];
    int32_t* bucket_count = (int32_t*)(bucketscratchpad + numBuckets * n);

    // Initialize buckets and bucket counts.
    // Since each core uses the same variables, they need to be initialized only
    // once.
    if (core_idx == 0) {
        for (int32_t i = 0; i < numBuckets; i++) {
            bucket_count[i] = 0;
            buckets[i] = &bucketscratchpad[i * n];
        }
    }
    snrt_cluster_hw_barrier();
    ttemp = snrt_mcycle();

    // Distribute array elements into buckets
    if (snrt_is_compute_core()) {
        int32_t range = (maximum - minimum) / numBuckets + 1;

        for (int32_t i = offset_core; i < offset_core + frac_core; i++) {
            int32_t bucketIndex = (x[i] - minimum) / range;
            int32_t current_index = __atomic_fetch_add(
                &bucket_count[bucketIndex], 1, __ATOMIC_SEQ_CST);
            buckets[bucketIndex][current_index] = x[i];
        }
    }

    // Before sorting the buckets, the data needs to be distributed
    snrt_cluster_hw_barrier();
    ttemp = snrt_mcycle();

    // Sort each bucket
    if (snrt_is_compute_core()) {
        for (uint8_t next_bucket = 0 + core_idx; next_bucket < numBuckets;
             next_bucket += snrt_cluster_compute_core_num()) {
            if (bucket_count[next_bucket] > 0) {
                quicksort(buckets[next_bucket],
                          buckets[next_bucket] + bucket_count[next_bucket] - 1);
            }
        }
    }

    // Before merging the buckets, all of them need to be sorted
    snrt_cluster_hw_barrier();
    ttemp = snrt_mcycle();

    // Make a cumulative sum array, to know the offset per bucket
    int idx_offset[numBuckets];
    prefixSum(bucket_count, idx_offset, numBuckets);

    // Merge buckets and store into x
    if (snrt_is_compute_core()) {
        for (uint8_t next_bucket = 0 + core_idx; next_bucket < numBuckets;
             next_bucket += snrt_cluster_compute_core_num()) {
            uint32_t i_x;
            for (uint32_t j = 0; j < bucket_count[core_idx]; j++) {
                i_x = j + idx_offset[core_idx];
                x[i_x] = buckets[core_idx][j];
            }
        }
    }
    ttemp = snrt_mcycle();
}
