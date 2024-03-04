#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

from pathlib import Path
import sys

sys.path.append(str(Path(__file__).parent / '../../../util/sim'))
import sim_utils  # noqa: E402
from Simulator import QuestaSimulator, VCSSimulator, VerilatorSimulator, \
                      BansheeSimulator  # noqa: E402


SIMULATORS = {
    'vsim': QuestaSimulator(Path(__file__).parent.resolve() / '../bin/snitch_cluster.vsim'),
    'vcs': VCSSimulator(Path(__file__).parent.resolve() / '../bin/snitch_cluster.vcs'),
    'verilator': VerilatorSimulator(Path(__file__).parent.resolve() / '../bin/snitch_cluster.vlt'),
    'banshee': BansheeSimulator(Path(__file__).parent.resolve() / '../src/banshee.yaml')
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
