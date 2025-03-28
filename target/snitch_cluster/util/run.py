#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>
"""Utility to simulate a list of tests on the Snitch cluster target.

This utility is built on top of the [`sim_utils`][sim_utils] module,
so it inherits the same command-line interface.
"""

from pathlib import Path
import sys

from snitch.util.sim import sim_utils
from snitch.util.sim.Simulator import QuestaSimulator, VCSSimulator, VerilatorSimulator, \
    GvsocSimulator


SIMULATORS = {
    'vsim': QuestaSimulator(Path(__file__).parent.resolve() / '../bin/snitch_cluster.vsim'),
    'vcs': VCSSimulator(Path(__file__).parent.resolve() / '../bin/snitch_cluster.vcs'),
    'verilator': VerilatorSimulator(Path(__file__).parent.resolve() / '../bin/snitch_cluster.vlt'),
    'gvsoc': GvsocSimulator(Path(__file__).parent.resolve() / '../bin/snitch_cluster.gvsoc')
}


def parser():
    return sim_utils.parser('vsim', SIMULATORS.keys())


def get_simulations(args):
    return sim_utils.get_simulations(args.testlist, SIMULATORS[args.simulator], args.run_dir)


def run_simulations(simulations, args):
    return sim_utils.run_simulations(simulations,
                                     n_procs=args.n_procs,
                                     dry_run=args.dry_run,
                                     early_exit=args.early_exit,
                                     verbose=args.verbose,
                                     report_path=Path(args.run_dir) / 'report.csv')


def main():
    args = parser().parse_args()
    simulations = get_simulations(args)
    return run_simulations(simulations, args)


if __name__ == '__main__':
    sys.exit(main())
