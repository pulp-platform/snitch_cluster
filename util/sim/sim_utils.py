# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import argparse
from termcolor import colored, cprint
from pathlib import Path
import os
import time
import yaml
import signal
import psutil

POLL_PERIOD = 0.2


def parser(default_simulator='vsim', simulator_choices=['vsim']):
    # Argument parsing
    parser = argparse.ArgumentParser()
    parser.add_argument(
        'testlist',
        nargs="+",
        help='File(s) specifying a list of apps to run')
    parser.add_argument(
        '--simulator',
        action='store',
        nargs='?',
        default=default_simulator,
        choices=simulator_choices,
        help='Choose a simulator to run the test with')
    parser.add_argument(
        '--run-dir',
        action='store',
        default='runs',
        nargs='?',
        help='Parent directory of each test run directory')
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
    return parser


# Checks if a string s represents a valid relative path w.r.t. to a certain base_path and resolves
# it to an absolute path, if this is the case. Otherwise returns the original string.
def resolve_relative_path(base_path, s):
    try:
        base_path = Path(base_path).resolve()  # Get the absolute path of the base directory
        input_path = Path(s)
        if input_path.is_absolute() or not s.startswith(("./", "../")):
            return s
        else:
            # Resolve the path against the base directory and check existence
            absolute_path = (base_path / input_path).resolve()
            return str(absolute_path)
    except (TypeError, ValueError):
        # Handle invalid base_path or s
        return s
    except Exception as e:
        # Handle other exceptions like permission errors, etc.
        print(f"An error occurred: {str(e)}")
        return s


# Create simulation objects from a test list file
def get_simulations(testlists, simulator):
    # Get tests from test list file
    all_tests = []
    for testlist in testlists:
        testlist_path = Path(testlist).absolute()
        with open(testlist_path, 'r') as f:
            tests = yaml.safe_load(f)['runs']
        # Convert relative paths in testlist file to absolute paths
        for test in tests:
            test['elf'] = testlist_path.parent / test['elf']
            if 'cmd' in test:
                resolved_paths = []
                for arg in test['cmd']:
                    resolved_path = resolve_relative_path(testlist_path.parent, arg)
                    resolved_paths.append(resolved_path)
                test['cmd'] = resolved_paths
        all_tests.extend(tests)
    # Create simulation object for every test which supports the specified simulator
    simulations = [simulator.get_simulation(test) for test in all_tests if simulator.supports(test)]
    return simulations


def print_summary(failed_sims, early_exit=False, dry_run=False):
    if not dry_run:
        header = f'==== Test summary {"(early exit)" if early_exit else ""} ===='
        cprint(header, attrs=['bold'])
        if failed_sims:
            [sim.print_status() for sim in failed_sims]
        else:
            print(f'{colored("All tests passed!", "green")}')


def terminate_simulations():
    print('Terminating simulations')
    # Get PID and PGID of parent process (current Python script)
    ppid = os.getpid()
    pgid = os.getpgid(0)
    # Kill processes in current process group, except parent process
    for proc in psutil.process_iter(['pid', 'name']):
        pid = proc.info['pid']
        if os.getpgid(pid) == pgid and pid != ppid:
            os.kill(pid, signal.SIGKILL)


def run_simulations(simulations, n_procs=1, run_dir=None, dry_run=False, early_exit=False):
    # Register SIGTERM handler, used to gracefully terminate all simulation subprocesses
    signal.signal(signal.SIGTERM, lambda _, __: terminate_simulations())

    # Spawn a process for every test, wait for all running tests to terminate and check results
    running_sims = []
    failed_sims = []
    early_exit_requested = False
    uniquify_run_dir = len(simulations) > 1
    try:
        while (len(simulations) or len(running_sims)) and not early_exit_requested:
            # If there are still simulations to run and there are less running simulations than
            # the maximum number of processes allowed in parallel, spawn new simulation
            if len(simulations) and len(running_sims) < n_procs:
                running_sims.append(simulations.pop(0))
                # Launch simulation in current working directory, by default
                if run_dir is None:
                    run_dir = Path.cwd()
                # Create unique subdirectory for each test under run directory, if multiple tests
                if uniquify_run_dir:
                    unique_run_dir = run_dir / running_sims[-1].testname
                else:
                    unique_run_dir = run_dir
                running_sims[-1].launch(run_dir=unique_run_dir, dry_run=dry_run)
            # Remove completed sims from running sims list
            idcs = [i for i, sim in enumerate(running_sims) if dry_run or sim.completed()]
            completed_sims = [running_sims.pop(i) for i in sorted(idcs, reverse=True)]
            # Check completed sims and report status
            for sim in completed_sims:
                if sim.successful():
                    sim.print_status()
                else:
                    failed_sims.append(sim)
                    sim.print_log()
                    sim.print_status()
                    # If in early-exit mode, terminate as soon as any simulation fails
                    if early_exit:
                        early_exit_requested = True
                        break
            time.sleep(POLL_PERIOD)
    except KeyboardInterrupt:
        early_exit_requested = True

    # Clean up after early exit
    if early_exit_requested:
        terminate_simulations()

    # Print summary
    print_summary(failed_sims, early_exit_requested)
    return len(failed_sims)
