Build the hardware:
```
make -C ../../ CFG_OVERRIDE=$PWD/cfg.json vsim -j
```

Run RTL experiments w/ verification:
```
./experiments.py experiments.yaml --actions sw run perf --bist -j
```

Run RTL experiments w/o verification, use this to shorten PLS time:
```
./experiments.py experiments.yaml --actions sw run perf --dump-pls-testlist -j
```

Run PLS experiments:
```
make -C ../../ clean-vsim
make -C ../../ CFG_OVERRIDE=$PWD/cfg.json TECH=gf12 DEBUG=ON VCD_DUMP=1 vsim -j
./experiments.py pls.yaml --actions run power -j --run-dir pls
```

Run MATRIX experiments:
```
./matrix.py none.yaml sw run -j
```
