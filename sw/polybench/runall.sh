# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# ATAX Kernel from the Polybench Suite
# Correctness of results are checked automatically
# Author: Jose Pedro Castro Fonseca
# Email: jose.pc.fonseca@gmail, jcastro@ethz.ch


cp Makefile makesnitch
cp hostMakefile Makefile

make  clean_data
make  PROB_SIZE=$1 gen_data
make  HOST=1 USE_OMP=1 TEST=COV  host_dbg_compile && make  TEST=COV  host_dbg_run
make  HOST=1 USE_OMP=1 TEST=CORR host_dbg_compile && make  TEST=CORR host_dbg_run
make  HOST=1 USE_OMP=1 TEST=ATAX host_dbg_compile && make  TEST=ATAX host_dbg_run

cp Makefile hostMakefile
cp makesnitch Makefile
