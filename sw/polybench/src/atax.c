// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// ATAX Kernel from the Polybench Suite
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
#endif

#include "data.h" 
#define NTHREADS 8
#define EPS 0.001
#define USE_OMP 1

void kernel_atax(uint32_t M, uint32_t N, double *A, double *x, double *y, double *tmp) {

	int i,j;
	double tmp_fs=0.0;

	// Evaluate y = At * (A * x)
	#ifdef USE_OMP
	#ifndef HOST
	#pragma omp parallel private(tmp_fs,i,j) shared(A,x,tmp)
	{
	#pragma omp for schedule(static)
	#else
	#pragma omp parallel for schedule(static)  private(tmp_fs,i,j) firstprivate(tmp) shared(A,x)
	#endif
	#endif
	for(i = 0; i < M; i++) {
		tmp_fs = 0.0;
		for(j = 0; j < N; j++) {
			tmp_fs += A[i+j*N] * x[j];
		}
		tmp[i] = tmp_fs;
	}
	#if defined USE_OMP && !defined HOST
	}
	#endif

	#ifdef USE_OMP
	#ifndef HOST
	#pragma omp parallel private(tmp_fs,i,j) shared(A,tmp,y)
	{
	#pragma omp for schedule(static)
	#else
	#pragma omp parallel for schedule(static) private(tmp_fs,i,j) firstprivate(y) shared(A,tmp)
	#endif
	#endif
	for(j = 0; j < N; j++) {
		tmp_fs = 0.0;
		for(i = 0; i < M; i++) {
			// The order of the for loops was exchanged, so that each loop reduces in y at position j, iterating through the i positions.
			tmp_fs += A[i+j*N] * tmp[i];
		}
		y[j] = tmp_fs;
	}
	#if defined USE_OMP && !defined HOST
	}
	#endif
}


int main() {
	uint32_t nerr     = 0;
	double *local_A;
	double *local_x;
	double *local_y;
	double *local_tmp;
	double diff;

	#ifndef HOST	
	unsigned core_idx = 0;
	local_A   = snrt_l1alloc(sizeof(double) * M * N);
	local_x   = snrt_l1alloc(sizeof(double) * N);
	local_y   = snrt_l1alloc(sizeof(double) * N);
	local_tmp = snrt_l1alloc(sizeof(double) * M);
	core_idx = snrt_cluster_core_idx();
	#else
	local_A   = (double*) malloc(sizeof(double) * M * N);
	local_x   = (double*) malloc(sizeof(double) * N);
	local_y   = (double*) malloc(sizeof(double) * N);
	local_tmp = (double*) malloc(sizeof(double) * M);
	#endif

	// Initialize input matrix
	for (unsigned i = 0; i < M*N; i++) {
		local_A[i] = golden_A[i];
	}
	for (unsigned i = 0; i < N; i++) {
		local_x[i] = golden_x[i];
		local_y[i] = 0;
	}
	for (unsigned i = 0; i < M; i++) {
		local_tmp[i] = 0;
	}


 	// *************************** SNITCH MODE ***************************//
	// Perform Computations 

	#ifndef HOST
    	__snrt_omp_bootstrap(core_idx);
    	if(snrt_is_compute_core()) {
		#ifndef USE_OMP
		uint32_t sta = mcycle();
		#endif
		kernel_atax(M, N, local_A, local_x, local_y, local_tmp);
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
	kernel_atax(M, N, local_A, local_x, local_y, local_tmp);
	#endif
 	// ******************************************************************//


	// Check computation is correct
	#ifndef HOST
	if (snrt_cluster_core_idx()==0) {
	#endif
		// Check y
		for (int i = 0; i < N; i++) {
			diff = fabs(golden_y[i] - local_y[i]);
			if(diff > EPS) {
				nerr++;
				#ifdef HOST
				printf("Wrong y sample [%d]: %f vs %f!\n", i, local_y[i], golden_y[i]);
				#endif 
			}
		}
	#ifndef HOST
	}
	#endif

	printf("Total Number of Errors: %d\n", nerr);
	return nerr;

}
