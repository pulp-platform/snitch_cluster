Run RTL experiments:
```
make clean-vsim
make vsim DEBUG=ON -j
./experiments.py --actions hw sw run visual-trace -j
```

PLS simulations:

To test the PLS results:
```
make clean-vsim
make PL_SIM=1 DEBUG=ON vsim
./experiments.py --actions run -j --run-dir pls_test
```

To run the power simulation:
```
BIN_DIR=$PWD/experiments/frep/hw/<cfg>/bin/ make VSIM_BUILDDIR=$PWD/experiments/frep/hw/<cfg>/work-vsim/ clean-vsim
BIN_DIR=$PWD/experiments/frep/hw/<cfg>/bin/ make PL_SIM=1 DEBUG=ON VCD_DUMP=1 VSIM_BUILDDIR=$PWD/experiments/frep/hw/<cfg>/work-vsim/ $BIN_DIR/snitch_cluster.vsim -j
./experiments.py power.yaml --actions run power -j --run-dir pls_power
```

Command to run a single experiment (from the experiment's run directory) for debugging:
```
../../../../../../../../../sw/blas/gemm/scripts/verify.py ../../../../../hw/zonl48dobu/bin/snitch_cluster.vsim ../../../../../build/zonl48dobu/24/32/8/gemm.elf
```
