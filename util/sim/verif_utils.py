# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Bettina Lory <blory@iis.ee.ethz.ch>
# Luca Colagrande <colluca@iis.ee.ethz.ch>
"""Convenience functions and classes for verification scripts."""


import argparse
import numpy as np
import csv
from pathlib import Path

from snitch.util.sim.Elf import Elf
from snitch.util.sim.data_utils import flatten, from_buffer
from snitch.util.sim import SnitchSim


def dump_results_to_csv(expected_results, actual_results, error, max_error, path):
    """Dumps results and errors to a CSV file.

    Takes a set of arrays (of the same shape or, at least, same flattened
    size), flattens them, and dumps them to a CSV file. Each array is
    mapped to a different column of the CSV, in the same order as they
    appear as arguments in the function signature.
    Also dumps an additional column, indicating pass (or failure) status,
    calculated as `error <= max_error`.

    Args:
        expected_results: Array of expected results.
        actual_results: Array of actual results.
        error: Array with the absolute error
            `abs(expected_results - actual_results)`.
        max_error: Array with the maximum allowed error per element.
            Can also be a function of `expected_results` e.g. to
            implement relative error checks.
        path: Path of the output CSV file.
    """
    # Flatten and zip arrays
    arrays = (expected_results, actual_results, error, max_error)
    flattened = [flatten(arr) for arr in arrays]
    flattened.append((flattened[2] <= flattened[3]).astype(bool).astype(str))
    zipped = np.column_stack(flattened)
    # Write row-by-row to CSV file
    with open(path, 'w') as csv_file:
        csv_writer = csv.writer(csv_file)
        csv_writer.writerow(['expected', 'actual', 'error', 'max_error', 'pass'])
        for row in zipped:
            csv_writer.writerow(row)
    # Print path where results were written
    print(f"Wrote results to {path}")


class MemoryDumpReader:

    def __init__(self, file_path, base_address):
        self.base_address = base_address
        # Read file contents and save size
        with open(file_path, 'rb') as f:
            self.data = f.read()
        self.size = len(self.data)

    def read(self, start_address, size):
        # Check that address lies within bounds
        offset = start_address - self.base_address
        if offset < 0 or offset + size > self.size:
            raise ValueError(
                f'Requested range [{hex(start_address)}, {hex(start_address + size)}) is out of '
                f'bounds of the memory dump [{hex(self.base_address)}, '
                f'{hex(self.base_address + self.size)}).')
        # Read data
        return self.data[offset:offset + size]


class Verifier:
    """Base verifier class.

    Base verifier class which can be inherited to easily develop a
    custom verification script for any kernel.

    Subclasses must override the `OUTPUT_UIDS` attribute and the
    [`get_actual_results()`][verif_utils.Verifier.get_actual_results],
    [`get_expected_results()`][verif_utils.Verifier.get_expected_results]
    and [`check_results()`][verif_utils.Verifier.check_results] methods,
    at a minimum. With respect to the latter, it suffices to invoke the
    parent method with an explicit value for `rtol` or `atol`.

    Attributes:
        OUTPUT_UIDS: A list of global symbols representing outputs of the
            simulation. See
            [`simulate()`][verif_utils.Verifier.simulate] method
            for details on its use.
    """

    OUTPUT_UIDS = [None]

    def parser(self):
        """Default argument parser for verification scripts.

        It is an instance of the `ArgumentParser` class from the `argparse`
        module. Subclasses can extend this and add custom arguments via
        the parser's `add_argument()` method.
        """
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
        parser.add_argument(
            '--simulator',
            help='Specifies simulator')
        parser.add_argument(
            '--dump-results',
            action='store_true',
            help='Dump results even if the simulation does not fail')
        parser.add_argument(
            '--no-ipc',
            action='store_true',
            help='Do not use IPC interface')
        parser.add_argument(
            '--memdump',
            help='A file containing the memory contents at the end of the simulation')
        parser.add_argument(
            '--memaddr',
            type=lambda x: int(x, 0),
            help='The start address of the memory dumped to the file specified by --memdump,'
                 ' (e.g. 0x80000000 or 2147483648)')
        return parser

    def parse_args(self):
        """Parse default verification script arguments.

        Returns:
            args: The arguments passed to the verification script, parsed
                using the [`parser()`][verif_utils.Verifier.parser]
                method.
        """
        return self.parser().parse_args()

    def __init__(self):
        """Default constructor.

        Parses command-line arguments using the
        [`parse_args()`][verif_utils.Verifier.parse_args] method and
        stores them in `self.args` for use by other methods.
        """
        self.args = self.parse_args()

    def get_output_memory_locations(self):
        """Get details on memory locations of output symbols.

        Returns a dictionary containing, for each output symbol, its
        start address and size in memory. This information is read from
        the binary provided on the command line.
        """
        # Open binary where the output symbols are defined
        symbols_bin = self.args.symbols_bin if self.args.symbols_bin else self.args.snitch_bin
        elf = Elf(symbols_bin)

        # Read the start address and size of each symbol in memory
        output_memory_locations = {}
        for uid in self.OUTPUT_UIDS:
            output_memory_locations[uid] = {
                'address': elf.get_symbol_address(uid),
                'size': elf.get_symbol_size(uid)
            }
        return output_memory_locations

    def simulate(self):
        """Launch simulation and retrieve results.

        Spawns a subprocess to simulate the `snitch_bin` binary, using a
        command of the form `sim_bin snitch_bin <ipc_args>`. It
        communicates with the simulation using inter-process communication
        (IPC) facilities, to poll the program for termination and retrieve
        the memory contents where the results of the simulation are
        stored. The results of the simulation must have global symbols
        associated in `snitch_bin` in order to retrieve their address and
        size in memory from `snitch_bin`. Alternatively, if `symbols_bin`
        is given, the global symbols will be looked up in `symbols_bin`.

        It populates a dictionary, mapping UIDs, as listed in
        `OUTPUT_UIDS`, to their memory contents at the end of the
        simulation, formatted as raw bytes. The dictionary is stored in
        the `self.raw_outputs` attribute.
        """
        # Open ELF file for processing
        elf = Elf(self.args.snitch_bin)

        # Start simulation
        sim = SnitchSim(self.args.sim_bin, self.args.snitch_bin, simulator=self.args.simulator,
                        log=self.args.log)
        sim.start()

        # Wait for kernel execution to be over
        tohost = elf.get_symbol_address('tohost')
        sim.poll(tohost, 1, 0)

        # Read out results from memory
        output_locs = self.get_output_memory_locations()
        self.raw_outputs = {uid: sim.read(loc['address'], loc['size'])
                            for uid, loc in output_locs.items()}

        # Terminate
        sim.finish(wait_for_sim=True)

    def check_results(self, actual, expected, atol=None, rtol=None):
        """Check if the actual results are within the expected range.

        Args:
            expected: The expected results.
            actual: The actual results.
            atol: Absolute tolerance. The maximum absolute difference
                between the expected and actual results. Mutually
                exclusive with `rtol`.
            rtol: Relative tolerance. The maximum relative difference
                between the expected and actual results. Mutually
                exclusive with `atol`.

        Returns:
            retcode: An exit code representing the status of the
                simulation: 1 if the simulation results do not match the
                expected results, 0 otherwise.
        """
        # Compute absolute error
        expected, actual = map(flatten, (expected, actual))
        err = np.abs(expected - actual)
        # Check absolute or relative error
        if atol is not None and rtol is not None:
            raise ValueError('atol and rtol are mutually exclusive.')
        if atol is not None:
            max_err = [atol] * len(flatten(expected))
            # Handle FlexFloat arrays differently
            if expected.dtype == np.dtype(object):
                success = np.all(err <= max_err)
            else:
                success = np.allclose(expected, actual, atol=atol, rtol=0, equal_nan=False)
        elif rtol is not None:
            max_err = rtol * np.abs(expected)
            # Handle FlexFloat arrays differently
            if expected.dtype == np.dtype(object):
                success = np.all(err <= max_err)
            else:
                success = np.allclose(expected, actual, atol=0, rtol=rtol, equal_nan=False)
        else:
            raise ValueError('Either atol or rtol must be specified.')

        # Dump results on failure or if requested
        if not success or self.args.dump_results:
            dump_results_to_csv(expected, actual, err, max_err, Path.cwd() / 'results.csv')

        # Return exit code
        return int(not success)

    def get_actual_results(self):
        """Get actual simulation results.

        Subclasses should override this method to return the simulation
        results in a format comparable to the expected results.
        """
        pass

    def get_expected_results(self):
        """Get expected simulation results.

        Subclasses should override this method to return the expected
        results from the simulation.
        """
        pass

    def get_input_from_symbol(self, *args):
        """Get the value of an input variable from its global symbol.

        Retrieves the contents of a global symbol from `snitch_bin`.
        Alternatively, if `symbols_bin` is provided, it looks up the
        symbol contents from there.

        Args:
            args: Positional arguments accepted by the
                [`from_symbol()`][Elf.Elf.from_symbol] method.
        """
        if self.args.symbols_bin:
            elf = Elf(self.args.symbols_bin)
        else:
            elf = Elf(self.args.snitch_bin)
        return elf.from_symbol(*args)

    def get_output_from_symbol(self, uid, ctype):
        """Get the value of an output variable from its global symbol.

        Retrieves the value of a global symbol from the memory contents
        at the end of the simulation.

        Note:
            Calling this method before a call to the
            [`simulate()`][verif_utils.Verifier.simulate] method results in
            undefined behaviour.

        Args:
            uid: Global symbol to look up in memory.
            ctype: C type specifier used to interpret the data in memory.
        """
        return from_buffer(self.raw_outputs[uid], ctype)

    def main(self):
        """Default main function for data generation scripts."""
        # If the testbench provides an IPC interface, run the simulation through the IPC
        # interface, populating `self.raw_outputs` from the simulation memory contents
        # at the end of the simulation. Otherwise, populate `self.raw_outputs` from a file
        # where the memory contents have been dumped by other means, e.g. by a pure
        # SystemVerilog testbench.
        if not self.args.no_ipc:
            self.simulate()
        else:
            if self.args.memdump and self.args.memaddr:
                # Get memory locations where outputs are stored
                output_locs = self.get_output_memory_locations()
                # Read contents of those memory locations
                dump = MemoryDumpReader(self.args.memdump, self.args.memaddr)
                self.raw_outputs = {uid: dump.read(loc['address'], loc['size'])
                                    for uid, loc in output_locs.items()}
            else:
                raise ValueError('--memdump and --memaddr are required when --no-ipc is supplied')

        # Get actual and expected results
        actual_results = self.get_actual_results()
        expected_results = self.get_expected_results()

        # Compare actual and expected results
        retcode = self.check_results(actual_results, expected_results)

        # Verify that overriden check_results() method returns an exit code
        if retcode is not None:
            return retcode
        else:
            raise ValueError('check_results() method must return an exit code')
