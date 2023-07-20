# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# ATAX Kernel from the Polybench Suite
# Correctness of results are checked automatically
# Author: Jose Pedro Castro Fonseca
# Email: jose.pc.fonseca@gmail, jcastro@ethz.ch


import numpy as np
import sys

def gen_covariance_header_files(M, N):
	golden_in  = np.random.random_integers(-200, 100, size=(N,M))
	golden_out = {
		'mean' : np.mean(golden_in, axis=0),
		'cov'  : np.cov (golden_in, rowvar=False)
	}

	#for i,v in enumerate(dat.flatten()):
	#	print(f"{i}: {v}")

	strf = ""
	with open("data/data.h", "w") as f:
		# Flattened array
		gin_cov = golden_in.flatten('F')
		gout_mean = golden_out['mean'].flatten()
		gout_cov  = golden_out['cov'].flatten()

		# Add sizes
		strf += f"uint32_t M={M};\n"
		strf += f"uint32_t N={N};\n"
		strf += f"\n"
		strf += f"double data_cov[{M*N}] = {{"

		# Golden Input
		for i,v in enumerate(gin_cov):
			strf += f"{v}"
			if(i < len(gin_cov)-1):
				strf += f", "
		strf += "};\n\n"

		# Golden Output - Mean
		strf += f"double golden_mean[{M}] = {{"
		for i,v in enumerate(gout_mean):
			strf += f"{v}"
			if(i < len(gout_mean)-1):
				strf += f", "
		strf += "};\n\n"

		# Golden Output - Cov 
		strf += f"double golden_cov[{N*M}] = {{"
		for i,v in enumerate(gout_cov):
			strf += f"{v}"
			if(i < len(gout_cov)-1):
				strf += f", "
		strf += "};\n\n"

		f.write(strf)

def gen_correlation_header_files(M, N):
	golden_in  = np.random.random_integers(-200, 100, size=(M,N))/100
	golden_out = {
		'mean' : np.mean(golden_in, axis=0),
		'corr'  : np.corrcoef(golden_in, rowvar=False)
	}

	strf = ""
	with open("data/data.h", "a") as f:
		# Flattened array
		gin_corr = golden_in.flatten('F')
		gout_mean = golden_out['mean'].flatten()
		gout_corr  = golden_out['corr'].flatten()

		# Golden Output - Corr
		strf += f"double data_corr[{N*M}] = {{"
		for i,v in enumerate(gin_corr):
			strf += f"{v}"
			if(i < len(gin_corr)):
				strf += f", "
		strf += "};\n\n"
		# Golden Output - Corr
		strf += f"double golden_corr[{N*M}] = {{"
		for i,v in enumerate(gout_corr):
			strf += f"{v}"
			if(i < len(gout_corr)):
				strf += f", "
		strf += "};\n\n"

		f.write(strf)

def gen_atax_header_files(M,N):
	golden_A = np.random.random_integers(-200, 100, size=(M,N))/100
	golden_x = np.random.random_integers(-200, 100, size=(N,1))/100
	golden_y = np.matmul(golden_A.transpose(), np.matmul(golden_A, golden_x))

	strf = ""
	with open("data/data.h", "a") as f:
		# Flattened array

		# Golden Input - A
		A = golden_A.flatten('F')
		strf += f"double golden_A[{N*M}] = {{"
		for i,v in enumerate(A):
			strf += f"{v}"
			if(i < len(A)-1):
				strf += f", "
		strf += "};\n\n"

		# Golden Input - x
		x = golden_x.flatten()
		strf += f"double golden_x[{N}] = {{"
		for i,v in enumerate(x):
			strf += f"{v}"
			if(i < len(x)-1):
				strf += f", "
		strf += "};\n\n"

		# Golden Output - y
		y = golden_y.flatten()
		strf += f"double golden_y[{N}] = {{"
		for i,v in enumerate(y):
			strf += f"{v}"
			if(i < len(y)-1):
				strf += f", "
		strf += "};\n\n"
		f.write(strf)


try:
	N = int(sys.argv[1])
except:
	N = 8

M=N
print(f"Generating problems of size={N}...")

gen_covariance_header_files(M, N)
gen_correlation_header_files(M, N)
gen_atax_header_files(M, N)

