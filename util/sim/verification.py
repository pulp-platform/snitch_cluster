# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Bettina Lory <blory@iis.ee.ethz.ch>
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import sys
import argparse
import numpy as np
import csv
from elf import Elf
from pathlib import Path

sys.path.append(str(Path(__file__).parent / '../../target/common/test/'))
from SnitchSim import SnitchSim  # noqa: E402


def parse_args():
    # Argument parsing
    parser = argparse.ArgumentParser(allow_abbrev=True)
    parser.add_argument(
        'sim_bin',
        help='The simulator binary to be used to start the simulation',
    )
    parser.add_argument(
        'snitch_bin',
        help='The Snitch binary to be executed by the simulated Snitch hardware')
    parser.add_argument(
        '--symbols-bin',
        help='An optional binary containing the I/O symbols. By default, '
             'these are searched for in snitch_bin. This argument serves as an '
             'alternative.')
    parser.add_argument(
        '--log',
        help='Redirect simulation output to this log file')
    return parser.parse_args()


def simulate(sim_bin, snitch_bin, log, output_uids, symbols_bin=None):
    # Open ELF file for processing
    elf = Elf(snitch_bin)

    # Start simulation
    sim = SnitchSim(sim_bin, snitch_bin, log=log)
    sim.start()

    # Wait for kernel execution to be over
    tohost = elf.get_symbol_address('tohost')
    sim.poll(tohost, 1, 0)

    # Read out results from memory
    if symbols_bin:
        elf = Elf(symbols_bin)
    raw_outputs = {}
    for uid in output_uids:
        address = elf.get_symbol_address(uid)
        size = elf.get_symbol_size(uid)
        raw_outputs[uid] = sim.read(address, size)

    # Terminate
    sim.finish(wait_for_sim=True)

    return raw_outputs


# Takes a set of Numpy arrays (of the same shape), flattens them, zips them
# and dumps them to a CSV file. Arrays may for example be: golden results, actual
# results, absolute errors and relative errors.
def dump_results_to_csv(results, path):
    # Flatten and zip arrays
    flattened = [arr.flatten() for arr in results]
    zipped = np.column_stack(flattened)
    # Write row-by-row to CSV file
    with open(path, 'w') as csv_file:
        csv_writer = csv.writer(csv_file)
        for row in zipped:
            csv_writer.writerow(row)
    # Print path where results were written
    print(f"Wrote results to {path}")
