// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Covariance Kernel from the Polybench Suite
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
//#define USE_OMP 1

void kernel_covariance(uint32_t M, uint32_t N, double *data, double *mean, double *cov) {

	int i,j,k;
	double float_N  = (double)N         / 1.0;
	double float_N1 = ((double)N -1.0)  / 1.0;
	double tmp=0;

	// Evaluate Mean
	#ifdef USE_OMP
	#ifndef HOST
	#pragma omp parallel private(tmp,i,j) shared(mean,data, float_N)
	{
	#pragma omp for schedule(static)
	#else
	#pragma omp parallel for schedule(static) private(tmp,i,j) shared(data,mean,float_N)
	#endif
	#endif
	for(j = 0; j < M; j++) {
		tmp = 0.0;
		for(i=0; i < N; i++) {
			tmp += data[i+j*M];
		}
		mean[j] = tmp / float_N;
	}
	#if defined USE_OMP && !defined HOST
	}
	#endif

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

	// Evaluate Covariance
	#ifdef USE_OMP
	#ifndef HOST
	#pragma omp parallel private(tmp,i,j,k)  shared(data, cov, float_N1)
	{
	#pragma omp for schedule(static)
	#else
	#pragma omp parallel for schedule(static) private(tmp,i,j,k) shared(data,cov,float_N1)
	#endif
	#endif
	for(i=0; i < M; i++) {
		for(j = i; j < M; j++) {
			tmp = 0.0;
			for(k = 0; k < N; k++) {
				tmp += data[k+i*M] *  data[k+j*M];
			}
			cov[i+j*M] = tmp / float_N1;
			cov[j+i*M] = cov[i+j*M];
		}
	}
	#if defined USE_OMP && !defined HOST
	}
	#endif

}


int main() {
	uint32_t nerr     = 0;
	double *local_mean;
	double *local_cov;
	double *local_data;
	double diff=0;
		
	#ifndef HOST
	unsigned core_idx = 0;
	local_data = snrt_l1alloc(sizeof(double) * M * N);
	local_cov  = snrt_l1alloc(sizeof(double) * M * N);
	local_mean = snrt_l1alloc(sizeof(double) * M);
	core_idx = snrt_cluster_core_idx();
	#else
	local_data = malloc(sizeof(double) * M * N);
	local_cov  = malloc(sizeof(double) * M * N);
	local_mean = malloc(sizeof(double) * M);
	#endif

	// Initialize input matrix
	for (unsigned i = 0; i < M*N; i++) {
		local_data[i] = data_cov[i];
	}
  

	
 	// *************************** SNITCH MODE ***************************//
	// Perform Computations 

	#ifndef HOST
    	__snrt_omp_bootstrap(core_idx);
    	if(snrt_is_compute_core()) {
		#ifndef USE_OMP
		uint32_t sta = mcycle();
		#endif
		kernel_covariance(M, N, local_data, local_mean, local_cov);
		#ifndef USE_OMP
		uint32_t end = mcycle();
		#endif
	}
    	__snrt_omp_destroy(core_idx);
	#endif

 	// *******************************************************************//

 	// **************************** HOST MODE ****************************//
	#if defined HOST && defined USE_OMP
	omp_set_num_threads(8);
	#endif

	#ifdef HOST
	kernel_covariance(M, N, local_data, local_mean, local_cov);
	#endif
 	// ******************************************************************//


	// Check computation is correct
	// Check Mean
	#ifndef HOST
	if(snrt_cluster_core_idx()==0) {
	#endif
		for (int i = 0; i < M; i++) {
			diff = fabs(golden_mean[i] - local_mean[i]);
			if(diff > 0.01) {
				nerr++;
				#ifdef HOST
				printf("Wrong mean sample [%d]: %f vs %f!\n", i, local_mean[i], golden_mean[i]);
				#endif 
			}
		}
		// Evaluate Covariance
		for(int i=0; i < N; i++) {
			for(int j = 0; j < M; j++) {
				diff = fabs(golden_cov[j+i*N] - local_cov[j+i*N]);
				if(diff > 0.01) {
					nerr++;
					#ifdef HOST
					printf("Wrong cov sample [%d]: %f vs %f!\n", i, local_cov[j+i*M], golden_cov[j+i*M]);
					#endif 
				}
			}
		}
	#ifndef HOST
	}
	#endif

	#ifdef HOST
    	printf("Total Number of Errors: %d\n", nerr);
	#endif
    	return nerr;

}
