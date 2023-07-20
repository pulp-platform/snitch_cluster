// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Correlation Kernel from the Polybench Suite
// Correctness of results are checked automatically
// Author: Jose Pedro Castro Fonseca
// Email: jose.pc.fonseca@gmail, jcastro@ethz.ch


#include <math.h>

#ifdef HOST
#define uint32_t int
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

#else
#include "snrt.h"
#define NTHREADS 8
#endif

#include "data.h" 
#define USE_OMP 1

void kernel_correlation(uint32_t M, uint32_t N, double *data, double *mean, double *stddev, double *corr) {

	int i,j,k;
	double float_N  = (double)N / 1.0;
	
	// Evaluate Mean
	#ifdef USE_OMP
	#ifndef HOST
	#pragma omp parallel priate(i,j) firstprivate(mean) shared(data)
	{
	#pragma omp for schedule(static)
	#else
	#pragma omp parallel for schedule(static) private(i,j) firstprivate(mean) shared(data)
	#endif
	#endif
	for(j = 0; j < M; j++) {
		mean[j] = 0.0;
		for(i=0; i < N; i++) {
			mean[j] += data[i+j*M];
		}
		mean[j] = mean[j] /float_N;
	}
	#if defined USE_OMP && !defined HOST
	}
	#endif

	// Evaluate Stddev
	#ifdef USE_OMP
	#ifndef HOST
	#pragma omp parallel private(i,j) firstprivate(stddev) shared(data,mean)
	{
	#pragma omp for schedule(static)
	#else
	#pragma omp parallel for schedule(static) private(i,j) firstprivate(stddev) shared(data,mean) 
	#endif
	#endif
	for(j=0; j < M; j++) {
		stddev[j] = 0.0;
		for(i=0; i < N; i++) {
			stddev[j] += (data[i+j*M] - mean[j]) * (data[i+j*M] - mean[j]);
		}
		stddev[j] = sqrt(stddev[j] / float_N);
		stddev[j] = stddev[j] <= 0.01 ? 1.0 : stddev[j];
	}
	#if defined USE_OMP && !defined HOST
	}
	#endif


	// De-reference data with mean
	#ifdef USE_OMP
	#ifndef HOST
	#pragma omp parallel private(i,j) firstprivate(data) shared(mean)
	{
	#pragma omp for schedule(static)
	#else
	#pragma omp parallel for schedule(static) private(i,j) firstprivate(data) shared(mean)
	#endif
	#endif
	for(i=0; i < N; i++) {
		for(j = 0; j < M; j++) {
			data[i+j*M] -= mean[j];
		}
	}
	#if defined USE_OMP && !defined HOST
	}
	#endif

	// Evaluate Correlation
	#ifdef USE_OMP
	#ifndef HOST
	#pragma omp parallel private(i,j,k) firstprivate(corr) shared(data, stddev)
	{
	#pragma omp for schedule(static)
	#else
	#pragma omp parallel for schedule(static) private(i,j,k) firstprivate(corr) shared(data, stddev)
	#endif
	#endif
	for(i=0; i < M; i++) {
		for(j = i; j < M; j++) {
			corr[i+j*M] = 0.0;
			for(k = 0; k < N; k++) {
				corr[i+j*M] += data[k+i*M] *  data[k+j*M];
			}
			corr[i+j*M] = corr[i+j*M]/(float_N*stddev[i]*stddev[j]);
			corr[j+i*M] = corr[i+j*M];
		}
	}
	#if defined USE_OMP && !defined HOST
	}
	#endif

	#ifndef HOST
	snrt_fpu_fence();
	#endif
}


int main() {
	uint32_t nerr     = 0;
	double *local_mean;
	double *local_corr;
	double *local_stddev;
	double *local_data;
	double diff;

	#ifndef HOST	
	unsigned core_idx = 0;
	local_data    = snrt_l1alloc(sizeof(double) * M * N);
	local_corr    = snrt_l1alloc(sizeof(double) * M * N);
	local_stddev  = snrt_l1alloc(sizeof(double) * M);
	local_mean    = snrt_l1alloc(sizeof(double) * M);
	core_idx = snrt_cluster_core_idx();
	#else
	local_data    = (double*) malloc(sizeof(double) * M * N);
	local_corr    = (double*) malloc(sizeof(double) * M * N);
	local_stddev  = (double*) malloc(sizeof(double) * M);
	local_mean    = (double*) malloc(sizeof(double) * M);
	#endif

	// Initialize input matrix
	for (unsigned i = 0; i < M*N; i++) {
		local_data[i] = data_corr[i];
	}

   

	// Perform Computations 
	#ifndef HOST
    	__snrt_omp_bootstrap(core_idx);
    	if(snrt_is_compute_core()) {
		#ifndef USE_OMP
		uint32_t sta = mcycle();
		#endif
		kernel_correlation(M, N, local_data, local_mean, local_stddev, local_corr);
		#ifndef USE_OMP
		uint32_t end = mcycle();
		#endif
	}
    	__snrt_omp_destroy(core_idx);

	#else
	#ifdef USE_OMP
	omp_set_num_threads(8);
	#endif
	kernel_correlation(M, N, local_data, local_mean, local_stddev, local_corr);
	#endif
	


    // Check computation is correct
    #ifndef HOST
    if (snrt_cluster_core_idx()==0) {
    #endif
	// Check Mean
	/*
        for (int i = 0; i < M; i++) {
		diff = fabs(golden_mean[i] - local_mean[i]);
		if(diff > 0.01) {
			nerr++;
			#ifdef HOST
			printf("Wrong mean sample [%d]: %f vs %f!\n", i, local_mean[i], golden_mean[i]);
			#endif 
		}
        }
	*/
	// Evaluate Correlation
	for(int i=0; i < M; i++) {
		for(int j = 0; j < N; j++) {
			diff = fabs(golden_corr[i+j*N] - local_corr[i +j*N]);
			if(diff > 0.001) {
				nerr++;
				#ifdef HOST
				printf("Wrong corr sample [%d]: %f vs %f!\n", i+j*N, local_corr[i+j*N], golden_corr[i+j*N]);
				#endif 
			}
		}
	}
    #ifndef HOST
    }
    #endif

    printf("Total Number of Errors: %d\n", nerr);
    return nerr;

}
