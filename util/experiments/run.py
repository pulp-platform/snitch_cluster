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

from snitch.util.sim import sim_utils, Simulator

SIMULATORS = {
    'vsim': Simulator.QuestaSimulator('snitch_cluster.vsim'),
    'vcs': Simulator.VCSSimulator('snitch_cluster.vcs'),
    'verilator': Simulator.VerilatorSimulator('snitch_cluster.vlt'),
    'gvsoc': Simulator.GvsocSimulator('snitch_cluster.gvsoc')
}


def get_parser():
    return sim_utils.parser('vsim', SIMULATORS.keys())


def run_simulations(simulations, args):
    return sim_utils.run_simulations(simulations,
                                     n_procs=args.n_procs,
                                     dry_run=args.dry_run,
                                     early_exit=args.early_exit,
                                     verbose=args.verbose,
                                     report_path=Path(args.run_dir) / 'report.csv')


def main():
    # Parse args
    args = get_parser().parse_args()
    testlist = args.testlist
    simulator = SIMULATORS[args.simulator]
    run_dir = args.run_dir

    # Get simulations
    simulations = sim_utils.get_simulations_from_file(testlist, simulator, run_dir)

    # Run simulations
    return run_simulations(simulations, args)


if __name__ == '__main__':
    sys.exit(main())
