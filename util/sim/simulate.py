#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

# TODO colluca: timeout feature

import argparse
from pathlib import Path
import subprocess
from termcolor import colored, cprint
import re
import sys
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
    'vsim': '{sim_bin} {elf}',
    'banshee': ('{{sim_bin}} --no-opt-llvm --no-opt-jit --configuration {cfg}'
                ' --trace {{elf}} > /dev/null').format(cfg=BANSHEE_CFG),
    'verilator': '{sim_bin} {elf}',
    'vcs': '{sim_bin} {elf}'
}


def parse_args():
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
    args = parser.parse_args()
    return args


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


def run_simulation(cmd, simulator, test):
    # Defaults
    result = 1

    # Spawn simulation subprocess
    p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, universal_newlines=True)

    # Poll simulation subprocess and log its output
    while p.poll() is None:
        line = p.stdout.readline()
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

    return result


def run_test(test, args):
    # Extract args
    simulator = args.simulator
    sim_bin = args.sim_bin if args.sim_bin else SIMULATOR_BINS[simulator]
    dry_run = args.dry_run
    testlist = args.testlist

    # Check if simulator is supported for this test
    if 'simulators' in test:
        if simulator not in test['simulators']:
            return 0

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
    print(f'$ {cmd}', flush=True)

    # Run simulation
    result = 0
    if not dry_run:
        result = run_simulation(cmd, simulator, test)

    # Report failure or success
    if result != 0:
        cprint(f'{elf} test failed', 'red', attrs=['bold'], flush=True)
    else:
        cprint(f'{elf} test passed', 'green', attrs=['bold'], flush=True)

    return result


def print_failed_test(test):
    print(f'{colored(test["elf"], "cyan")} test {colored("failed", "red")}')


def print_test_summary(failed_tests, dry_run=False):
    if not dry_run:
        print('\n==== Test summary ====')
        if failed_tests:
            for failed_test in failed_tests:
                print_failed_test(failed_test)
            return 1
        else:
            print(f'{colored("All tests passed!", "green")}')
            return 0
    return 0


def run_tests(args):
    # Iterate tests
    tests = get_tests(args.testlist)
    failed_tests = []
    for test in tests:
        # Run test
        result = run_test(test, args)
        if result != 0:
            failed_tests.append(test)
            # End program if requested on first test failure
            if args.early_exit:
                break
    return print_test_summary(failed_tests, args.dry_run)


def main():
    args = parse_args()
    sys.exit(run_tests(args))


if __name__ == '__main__':
    main()
