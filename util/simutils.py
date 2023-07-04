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


BANSHEE_CFG = 'src/banshee.yaml'

# Tool settings
SIMULATORS = ['vsim', 'banshee', 'verilator', 'vcs']
DEFAULT_SIMULATOR = SIMULATORS[0]
SIMULATOR_CMDS = {
    'vsim': 'bin/snitch_cluster.vsim {0}',
    'banshee': (f'banshee --no-opt-llvm --no-opt-jit --configuration {BANSHEE_CFG}'
                ' --trace {0} > /dev/null'),
    'verilator': 'bin/snitch_cluster.vlt {0}',
    'vcs': 'bin/snitch_cluster.vcs {0}'
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
    with open(testlist_path, 'r') as f:
        tests = [line for line in f.read().splitlines() if line.partition('#')[0]]
        return tests


def run_test(test, format_elf_path, simulator, dry_run=False):

    # Construct path to executable
    elf = format_elf_path(test)
    cprint(f'Run test {colored(elf, "cyan")}', attrs=["bold"])

    # Construct simulation command
    cmd = SIMULATOR_CMDS[simulator].format(elf)
    print(f'$ {cmd}', flush=True)

    # Run test
    retcode = -1
    result = {}
    if not dry_run:

        # When simulating with vsim, we need to parse the simulation log to catch the
        # application's return code
        if simulator == 'vsim':
            p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, text=True)

            while p.poll() is None:
                line = p.stdout.readline()
                print(line, end='', flush=True)
                regex_failure = r'\[FAILURE\] Finished with exit code\s*(\d*)'
                match = re.search(regex_failure, line)
                if match:
                    retcode = match.group(1)
                    result['location'] = 'test'

                # Capture success return code
                regex_success = r'\[SUCCESS\] Program finished successfully'
                match_success = re.search(regex_success, line)
                if match_success:
                    retcode = 0

            # Check if the subprocess terminated correctly
            if p.poll() != 0:
                retcode = p.poll()
                result['location'] = 'simulator'

        else:
            p = subprocess.Popen(cmd, shell=True)
            p.wait()
            retcode = p.returncode

    # When test fails
    if retcode != 0:

        # Report failure
        cprint(f'Failed with exit code {retcode}', 'red', attrs=['bold'], flush=True)

        # Record failing tests for final summary
        result['success'] = False
        result['test'] = test
        result['retcode'] = retcode
        if 'location' not in result:
            result['location'] = 'binary'

    # When test passes
    else:

        # Report success
        cprint(f'Passed with exit code {retcode}', 'green', attrs=['bold'], flush=True)

        # Record failing tests for final summary
        result['success'] = True
        result['test'] = test
        result['retcode'] = retcode
        result['location'] = ''

    return result


def print_failed_test(success, test, retcode, location):
    if location == 'test':
        print(f'{colored(test, "cyan")} test {colored("failed", "red")} with exit code {retcode}')
    elif location == 'simulator':
        print(f'{colored("Simulator failed", "red")}'
              + f' with exit code {retcode} during {colored(test, "cyan")} test')
    elif location == 'binary':
        print(f'{colored("ELF file not found", "red")}'
              + f' for {colored(test, "cyan")} test')


def print_success_test(success, test, retcode, location):
    print(f'{colored(test, "cyan")} test {colored("passed", "green")} with exit code {retcode}')


def print_test_summary(successful_tests, failed_tests, dry_run=False):
    if not dry_run:
        print('\n==== Test summary ====')
        if successful_tests:
            for successful_test in successful_tests:
                print_success_test(**successful_test)
        if failed_tests:
            for failed_test in failed_tests:
                print_failed_test(**failed_test)
            return 1
        else:
            print(f'All tests {colored("passed", "green")}!')
            return 0


def run_tests(testlist, format_elf_path, simulator, dry_run=False, early_exit=False):
    # Iterate tests
    tests = get_tests(testlist)
    failed_tests = []
    successful_tests = []
    for test in tests:
        # Run test
        result = run_test(test, format_elf_path, simulator, dry_run)
        if result['success']:
            successful_tests.append(result)
        else:
            failed_tests.append(result)
            # End program if requested on first test failure
            if early_exit:
                break

    print_test_summary(successful_tests, failed_tests, dry_run)


# format_elf_path: function which constructs the path to an ELF binary
#                  from a test name as listed in the test list file
def main(format_elf_path):
    args = parse_args()
    run_tests(args.testlist,
              format_elf_path,
              args.simulator,
              args.dry_run,
              args.early_exit)
