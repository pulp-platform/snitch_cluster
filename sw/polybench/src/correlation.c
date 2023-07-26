// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Correlation Kernel from the Polybench Suite
// Correctness of results are checked automatically
// Author: Jose Pedro Castro Fonseca
// Email: jose.pc.fonseca@gmail.com, jcastro@ethz.ch


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
	double tmp=0.0;

	// Evaluate Mean
	#ifdef USE_OMP
	#ifndef HOST
	#pragma omp parallel private(tmp,i,j) shared(mean,data,float_N)
	{
	#pragma omp for schedule(static)
	#else
	#pragma omp parallel for schedule(static) private(tmp,i,j) shared(mean,data,float_N)
	#endif
	#endif
	for(j = 0; j < M; j++) {
		tmp = 0.0;
		for(i=0; i < N; i++) {
			tmp += data[i+j*M];
		}
		mean[j] = tmp /float_N;
	}
	#if defined USE_OMP && !defined HOST
	}
	#endif

	// Evaluate Stddev
	#ifdef USE_OMP
	#ifndef HOST
	#pragma omp parallel private(tmp,i,j) shared(data,mean,stddev,float_N)
	{
	#pragma omp for schedule(static)
	#else
	#pragma omp parallel for schedule(static) private(tmp,i,j) shared(data,mean,stddev,float_N) 
	#endif
	#endif
	for(j=0; j < M; j++) {
		tmp = 0.0;
		for(i=0; i < N; i++) {
			tmp += (data[i+j*M] - mean[j]) * (data[i+j*M] - mean[j]);
		}
		tmp = sqrt(tmp / float_N);
		stddev[j] = tmp <= 0.01 ? 1.0 : tmp;
	}
	#if defined USE_OMP && !defined HOST
	}
	#endif


	// De-reference data with mean
	#ifdef USE_OMP
	#ifndef HOST
	#pragma omp parallel private(i,j) shared(mean,data)
	{
	#pragma omp for schedule(static)
	#else
	#pragma omp parallel for schedule(static) private(i,j) shared(mean,data)
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
	#pragma omp parallel private(tmp,i,j,k) shared(data,corr,stddev,float_N)
	{
	#pragma omp for schedule(static)
	#else
	#pragma omp parallel for schedule(static) private(tmp,i,j,k) shared(data,corr,stddev,float_N)
	#endif
	#endif
	for(i=0; i < M; i++) {
		for(j = i; j < M; j++) {
			tmp = 0.0;
			for(k = 0; k < N; k++) {
				tmp += data[k+i*M] *  data[k+j*M];
			}
			corr[i+j*M] = tmp/(float_N*stddev[i]*stddev[j]);
			corr[j+i*M] = corr[i+j*M];
		}
	}
	#if defined USE_OMP && !defined HOST
	}
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
