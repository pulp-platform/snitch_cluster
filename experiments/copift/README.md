Build the hardware (in `target/snitch_cluster`):
```
make CFG_OVERRIDE=experiments/copift/cfg.json bin/snitch_cluster.vsim -j
```

Run RTL experiments:
```
./experiments.py experiments.yaml --actions sw run perf --dump-pls-testlist -j
```

Run PLS experiments:
```
make clean-vsim
make PL_SIM=1 DEBUG=ON VCD_DUMP=1 bin/snitch_cluster.vsim
./experiments.py pls.yaml --actions run power -j --run-dir pls
```

Run MATRIX experiments:
```
./matrix.py none.yaml sw run -j
```
