# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>
"""Convenience functions to set up a Python simulation framework.

Such a framework enables you to transparently run a software test suite
on any simulator of choice, provided that the latter is supported by
the framework. It can be used in CIs, regression testing or to conduct
systematic evaluation experiments.

Three interfaces are required to implement a common framework:

1. a test suite specification interface to specify the software tests
2. a command-line interface used to launch the simulations
3. an interface to the simulators supported by the framework

The framework can be divided into three components each managing one of
the defined interfaces:

1. a test suite frontend
2. a command-line frontend
3. a simulation backend

A fourth component, the core, serves to glue all other components
together.

The [parser()][sim_utils.parser] function provides a minimum
command-line interface to control the tool.

The [get_simulations()][sim_utils.get_simulations] function
provides a common means to implement the test suite frontend. At the
input interface it assumes a test suite specification file in YAML
syntax, and returns a list of simulation objects which implement a
common interface to the simulation backend. This interface is defined
by the [Simulation][Simulation.Simulation] class.

The core logic of the framework is implemented in the
[run_simulations()][sim_utils.run_simulations] function. It takes
the output from [get_simulations()][sim_utils.get_simulations] and
launches the simulations through the interface to the simulation
backend.

The simulation backend is implemented by the
[Simulation][Simulation.Simulation] and
[Simulator][Simulator.Simulator] classes and their subclasses.
"""

import argparse
from pathlib import Path
import os
import time
import yaml
import signal
import psutil
import pandas as pd
from prettytable import PrettyTable


POLL_PERIOD = 0.2
DEFAULT_REPORT_PATH = 'sim_report.csv'


def parser(default_simulator='vsim', simulator_choices=['vsim']):
    """Default command-line parser for Python simulation frameworks.

    Returns a Python `argparse` parser with common options used to
    simulate one or multiple binaries on an RTL design. Can be extended
    by adding arguments to it.

    Args:
        default_simulator: The simulator to be used when none is
            specified on the command-line.
        simulator_choices: All simulator choices which can be passed on
            the command-line.
    """
    # Argument parsing
    parser = argparse.ArgumentParser()
    parser.add_argument(
        'testlist',
        help='File specifying a list of apps to run')
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
        '--verbose',
        action='store_true',
        help='Activate verbose printing')
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


def _resolve_relative_path(base_path, s):
    """Resolve a relative path string w.r.t. a ceratin base.

    Checks if an input string represents a valid relative path w.r.t.
    to a certain base path and resolves it to an absolute path, if this
    is the case. Otherwise returns the original string.

    Args:
        s: The input string
        base_path: The base path
    """
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


def get_simulations(testlist, simulator, run_dir=None):
    """Create simulation objects from a test list file.

    Args:
        testlist: Path to a test list file. A test list file is a YAML
            file describing a set of tests.
        simulator: The simulator to use to run the tests. A test run on
            a specific simulator defines a simulation.
        run_dir: A directory under which all tests should be run. If
            provided, a unique subdirectory for each test will be
            created under this directory, based on the test name.

    Returns:
        A list of `Simulation` objects. The list contains a
            `Simulation` object for every test which supports the given
            `simulator`. This object defines a simulation of the test on
            that particular `simulator`.
    """
    # Get tests from test list file
    testlist_path = Path(testlist).absolute()
    with open(testlist_path, 'r') as f:
        tests = yaml.safe_load(f)['runs']
    # Convert relative paths in testlist file to absolute paths
    for test in tests:
        test['elf'] = testlist_path.parent / test['elf']
        if 'cmd' in test:
            test['cmd'] = [_resolve_relative_path(testlist_path.parent, arg) for arg in test['cmd']]
    # Create simulation object for every test which supports the specified simulator
    simulations = [simulator.get_simulation(test) for test in tests if simulator.supports(test)]
    # Set simulation run directory
    if run_dir is not None:
        for sim in simulations:
            sim.run_dir = Path(run_dir) / sim.testname
    return simulations


def print_summary(sims, early_exit=False, dry_run=False):
    """Print a summary of the simulation suite's exit status.

    Args:
        sims: A list of simulations from the simulation suite.
    """
    # Table
    table = PrettyTable()
    table.title = 'Test summary'
    table.field_names = [
        'test',
        'launched',
        'completed',
        'passed',
        'CPU time [s]',
        'simulation time [ns]'
    ]
    table.add_rows([[
        sim.testname,
        sim.launched(),
        sim.completed(),
        sim.successful(),
        sim.get_cpu_time(),
        sim.get_simulation_time()
    ] for sim in sims])
    print(table)


def dump_report(sims, path=None):
    """Print a detailed report on the simulation suite's execution.

    Args:
        sims: A list of simulations from the simulation suite.
    """
    data = [{'elf': sim.elf,
             'launched': sim.launched(),
             'completed': sim.completed(),
             'passed': sim.successful(),
             'CPU time [s]': sim.get_cpu_time(),
             'simulation time [ns]': sim.get_simulation_time()} for sim in sims]
    df = pd.DataFrame(data)
    df = df.set_index('elf')
    if path is None:
        path = DEFAULT_REPORT_PATH
    df.to_csv(path)


def terminate_processes():
    print('Terminate processes')
    # Get PID and PGID of parent process (current Python script)
    ppid = os.getpid()
    pgid = os.getpgid(0)
    # Kill processes in current process group, except parent process
    for proc in psutil.process_iter(['pid', 'name']):
        pid = proc.info['pid']
        if os.getpgid(pid) == pgid and pid != ppid:
            os.kill(pid, signal.SIGKILL)


def get_unique_run_dir(sim, prefix=None):
    """Get unique run directory for a simulation.

    If the simulation was already assigned a run directory at creation
    time, None is returned. Otherwise, return a unique run directory
    based on the testname under an optional prefix directory.

    Args:
        sim: The simulation for which the run directory is
            requested.
        prefix: Get a unique run directory under a directory which
            could be common to multiple simulations. We call this
            a prefix. By default the current working directory is
            assumed as the prefix.
    """
    if sim.run_dir is None:
        if prefix is None:
            prefix = Path.cwd()
        return prefix / sim.testname


def run_simulations(simulations, n_procs=1, dry_run=None, early_exit=False,
                    verbose=False, report_path=None):
    """Run simulations defined by a list of `Simulation` objects.

    Args:
        simulations: A list of `Simulation` objects as returned e.g. by
            [sim_utils.get_simulations][].

    Returns:
        The number of failed simulations.
    """
    # Register SIGTERM handler, used to gracefully terminate all simulation subprocesses
    signal.signal(signal.SIGTERM, lambda _, __: terminate_processes())

    # Spawn a process for every test, wait for all running tests to terminate and check results
    running_sims = []
    failed_sims = []
    successful_sims = []
    early_exit_requested = False
    try:
        while (len(simulations) or len(running_sims)) and not early_exit_requested:
            # If there are still simulations to run and there are less running simulations than
            # the maximum number of processes allowed in parallel, spawn new simulation
            if len(simulations) and len(running_sims) < n_procs:
                running_sims.append(simulations.pop(0))
                running_sims[-1].launch(dry_run=dry_run)
            # Remove completed sims from running sims list
            idcs = [i for i, sim in enumerate(running_sims) if sim.completed()]
            completed_sims = [running_sims.pop(i) for i in sorted(idcs, reverse=True)]
            # Check completed sims and report status
            for sim in completed_sims:
                if sim.successful():
                    successful_sims.append(sim)
                    sim.print_status()
                else:
                    failed_sims.append(sim)
                    if verbose:
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
        terminate_processes()

    # Print summary and dump report
    print_summary(simulations + running_sims + successful_sims + failed_sims)
    dump_report(simulations + running_sims + successful_sims + failed_sims, report_path)

    return len(failed_sims)
