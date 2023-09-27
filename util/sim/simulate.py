#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

# TODO colluca: timeout feature

import argparse
import multiprocessing
from pathlib import Path
import subprocess
from termcolor import colored, cprint
import os
import re
import sys
import time
import yaml


BANSHEE_CFG = 'src/banshee.yaml'

# Tool settings
SIMULATORS = ['vsim', 'banshee', 'verilator', 'vcs', 'other']
DEFAULT_SIMULATOR = SIMULATORS[0]
SIMULATOR_BINS = {
    'vsim': 'bin/snitch_cluster.vsim',
    'banshee': 'banshee',
    'verilator': 'bin/snitch_cluster.vlt',
    'vcs': 'bin/snitch_cluster.vcs'
}
SIMULATOR_CMDS = {
    'vsim': '{sim_bin} {elf} "" -batch',
    'banshee': ('{{sim_bin}} --no-opt-llvm --no-opt-jit --configuration {cfg}'
                ' --trace {{elf}} > /dev/null').format(cfg=BANSHEE_CFG),
    'verilator': '{sim_bin} {elf}',
    'vcs': '{sim_bin} {elf}'
}


def parser():
    # Argument parsing
    parser = argparse.ArgumentParser()
    parser.add_argument(
        'testlist',
        help='File specifying a list of apps to run')
    parser.add_argument(
        '--simulator',
        action='store',
        nargs='?',
        default=DEFAULT_SIMULATOR,
        choices=SIMULATORS,
        help='Choose a simulator to run the test with')
    parser.add_argument(
        '--sim-bin',
        action='store',
        nargs='?',
        help='Override default path to simulator binary')
    parser.add_argument(
        '--dry-run',
        action='store_true',
        help='Preview the simulation commands which will be run')
    parser.add_argument(
        '--early-exit',
        action='store_true',
        help='Exit as soon as any test fails')
    parser.add_argument(
        '-j',
        action='store',
        dest='n_procs',
        nargs='?',
        type=int,
        default=1,
        const=os.cpu_count(),
        help=('Maximum number of tests to run in parallel. '
              'One if the option is not present. Equal to the number of CPU cores '
              'if the option is present but not followed by an argument.'))
    parser.add_argument(
        '--verbose',
        action='store_true',
        help=('Option to print simulation logs when multiple tests are run in parallel.'
              'Logs are always printed when n_procs == 1'))
    return parser


# Get tests from a test list file
def get_tests(testlist_path):
    testlist_path = Path(testlist_path).absolute()
    with open(testlist_path, 'r') as file:
        tests = yaml.safe_load(file)['runs']
    return tests


def check_exit_code(test, exit_code):
    if 'exit_code' in test:
        return not (int(test['exit_code']) == int(exit_code))
    else:
        return exit_code


def multiple_processes(args):
    return args.n_procs != 1


def run_simulation(cmd, simulator, test, quiet=False):
    # Defaults
    result = 1
    log = ''

    # Spawn simulation subprocess
    p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                         universal_newlines=True)

    # Poll simulation subprocess and log its output
    while p.poll() is None:
        line = p.stdout.readline()
        log += line
        if not quiet:
            print(line, end='', flush=True)

        # When simulating with vsim or vcs, we need to parse the simulation
        # log to catch the application's return code
        if simulator in ['vsim', 'vcs']:
            # Capture success
            regex_success = r'\[SUCCESS\] Program finished successfully'
            match_success = re.search(regex_success, line)
            if match_success:
                result = 0
            else:
                regex_fail = r'\[FAILURE\] Finished with exit code\s+(\d+)'
                match = re.search(regex_fail, line)
                if match:
                    exit_code = match.group(1)
                    result = check_exit_code(test, exit_code)

    # Check if the subprocess terminated correctly
    exit_code = p.poll()
    # In Banshee and Verilator the exit code of the Snitch binary is returned
    # through the exit code of the simulation command
    if simulator in ['banshee', 'verilator']:
        result = check_exit_code(test, exit_code)
    # For custom commands the return code is that of the command
    elif simulator == 'other':
        result = exit_code
    # For standard simulation commands the simulated Snitch binary exit
    # code is overriden only if the simulator failed
    else:
        if exit_code != 0:
            result = exit_code

    return result, log


def run_test(test, args):
    # Extract args
    simulator = args.simulator
    dry_run = args.dry_run
    testlist = args.testlist
    quiet = multiple_processes(args)

    # Simulator binary can be overriden on the command-line or test-wise
    sim_bin = SIMULATOR_BINS[simulator]
    if args.sim_bin:
        sim_bin = args.sim_bin
    if 'sim_bin' in test:
        sim_bin = test['sim_bin']

    # Check if simulator is supported for this test
    if 'simulators' in test:
        if simulator not in test['simulators']:
            return (0, '')

    # Construct path to executable
    elf = Path(test['elf'])
    if testlist:
        elf = Path(testlist).absolute().parent / elf
    cprint(f'Run test {colored(elf, "cyan")}', attrs=["bold"])

    # Construct simulation command (override only supported for RTL)
    if 'cmd' in test and simulator != 'banshee':
        cmd = test['cmd']
        cmd = cmd.format(sim_bin=sim_bin, elf=elf, simulator=simulator)
        simulator = 'other'
    else:
        cmd = SIMULATOR_CMDS[simulator]
        cmd = cmd.format(sim_bin=sim_bin, elf=elf)

    # Check if the simulation should be run in a specific directory.
    # This is useful, e.g. to preserve the logs of multiple simulations
    # which are executed in parallel
    if 'rundir' in test:
        cmd = f'cd {test["rundir"]} && {cmd}'
    if not quiet or args.verbose:
        print(f'$ {cmd}', flush=True)

    # Run simulation
    result = 0
    log = ''
    if not dry_run:
        result, log = run_simulation(cmd, simulator, test, quiet)

    # Report failure or success
    if result != 0:
        cprint(f'{elf} test failed', 'red', attrs=['bold'], flush=True)
    else:
        cprint(f'{elf} test passed', 'green', attrs=['bold'], flush=True)

    return (result, log)


def print_failed_test(test):
    print(f'{colored(test["elf"], "cyan")} test {colored("failed", "red")}')


def print_test_summary(failed_tests, args):
    if not args.dry_run:
        header = f'\n==== Test summary {"(early exit)" if args.early_exit else ""} ===='
        cprint(header, attrs=['bold'])
        if failed_tests:
            for failed_test in failed_tests:
                print_failed_test(failed_test)
        else:
            print(f'{colored("All tests passed!", "green")}')


def run_tests(tests, args):

    # Create a process Pool
    with multiprocessing.Pool(args.n_procs) as pool:

        # Create a shared object which parent and child processes can access
        # concurrently to terminate the pool early as soon as one process fails
        exit_early = multiprocessing.Value('B')
        exit_early.value = 0

        # Define callback for early exit
        def completion_callback(return_value):
            result = return_value[0]
            log = return_value[1]
            if args.early_exit and result != 0:
                exit_early.value = 1
            # Printing the log all at once here, rather than line-by-line
            # in run_simulation, ensures that the logs of different processes
            # are not interleaved in stdout.
            # However, as we prefer line-by-line printing when a single process
            # is used, we have to make sure we don't print twice.
            if args.verbose and multiple_processes(args):
                print(log)

        # Queue tests to process pool
        results = []
        for test in tests:
            result = pool.apply_async(run_test, args=(test, args), callback=completion_callback)
            results.append(result)

        # Wait for all tests to complete
        running = range(len(tests))
        while len(running) != 0 and not exit_early.value:
            time.sleep(1)
            running = [i for i in running if not results[i].ready()]

    # Query test results
    failed_tests = []
    for test, result in zip(tests, results):
        if result.ready() and result.get()[0] != 0:
            failed_tests.append(test)

    print_test_summary(failed_tests, args)

    return len(failed_tests)


def main():
    args = parser().parse_args()
    tests = get_tests(args.testlist)
    return run_tests(tests, args)


if __name__ == '__main__':
    sys.exit(main())
