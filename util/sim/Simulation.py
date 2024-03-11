# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

from termcolor import colored, cprint
from pathlib import Path
import subprocess
import re
import os
from mako.template import Template


class Simulation(object):
    """Provides a common interface to manage simulations."""

    LOG_FILE = 'sim.txt'

    def __init__(self, elf=None, dry_run=False, retcode=0, run_dir=None, name=None):
        """Constructor for the Simulation class.

        A Simulation object is defined at a minimum by a software
        binary to be simulated on the desired hardware. The hardware is
        implicitly determined by the simulation command.

        Arguments:
            elf: The software binary to simulate.
            run_dir: The directory where to launch the simulation
                command. If none is passed, the current working
                directory is assumed.
            dry_run: A preview of the simulation command will be
                displayed without actually launching the simulation.
        """
        self.elf = elf
        self.dry_run = dry_run
        self.run_dir = run_dir if run_dir is not None else Path.cwd()
        if name is None:
            self.testname = Path(self.elf).stem
        else:
            self.testname = name
        self.cmd = []
        self.log = None
        self.process = None
        self.expected_retcode = int(retcode)

    def launch(self, dry_run=None):
        """Launch the simulation.

        Launch the simulation by invoking the command stored in the
        `cmd` attribute of the class. Subclasses are required to define
        a non-empty `cmd` attribute prior to invoking this method.

        Arguments:
            dry_run: A preview of the simulation command is displayed
                without actually launching the simulation.
        """
        # Override dry_run setting at launch time
        if dry_run is not None:
            self.dry_run = dry_run

        # Print launch message and simulation command
        cprint(f'Run test {colored(self.elf, "cyan")}', attrs=["bold"])
        cmd_string = ' '.join(self.cmd)
        print(f'[{self.run_dir}]$ {cmd_string}', flush=True)

        # Launch simulation if not doing a dry run
        if not self.dry_run:
            # Create run directory and log file
            os.makedirs(self.run_dir, exist_ok=True)
            self.log = self.run_dir / self.LOG_FILE
            # Launch simulation subprocess
            with open(self.log, 'w') as f:
                self.process = subprocess.Popen(self.cmd, stdout=f, stderr=subprocess.STDOUT,
                                                cwd=self.run_dir, universal_newlines=True)

    def launched(self):
        """Return whether the simulation was launched."""
        if self.process:
            return True
        else:
            return False

    def completed(self):
        """Return whether the simulation completed."""
        if self.dry_run:
            return True
        elif self.process:
            return self.process.poll() is not None
        else:
            return False

    def get_retcode(self):
        """Get the return code of the simulation."""
        if self.dry_run:
            return 0
        else:
            if self.completed():
                return int(self.process.returncode)

    def successful(self):
        """Return whether the simulation was successful."""
        actual_retcode = self.get_retcode()
        if actual_retcode is not None:
            return int(actual_retcode) == int(self.expected_retcode)
        else:
            return False

    def get_simulation_time(self):
        """Return the execution time [ns] of the binary in simulation."""
        return None

    def get_cpu_time(self):
        """Return the CPU time [s] taken to run the simulation."""
        return None

    def print_log(self):
        """Print a log of the simulation to stdout."""
        with open(self.log, 'r') as f:
            print(f.read())

    def print_status(self):
        """Print a status message to stdout.

        The status message reports whether the test is still running
        or, if it completed, whether it was successful or failed.
        """
        if self.completed():
            if self.successful():
                cprint(f'{self.elf} test passed', 'green', attrs=['bold'], flush=True)
            else:
                cprint(f'{self.elf} test failed', 'red', attrs=['bold'], flush=True)
        elif self.launched():
            cprint(f'{self.elf} test running', 'yellow', attrs=['bold'], flush=True)
        else:
            cprint(f'{self.elf} test not launched', 'yellow', attrs=['bold'], flush=True)


class RTLSimulation(Simulation):
    """A simulation run on an RTL simulator.

    An RTL simulation is launched through a simulation binary built
    in advance from some RTL design. The path to the simulation binary
    is all that is needed to launch a simulation.

    Alternatively, a custom command can be specified to launch the
    simulation. The custom command generally invokes the RTL simulator
    binary behind the scenes and executes some additional verification
    logic at the end of the simulation. As a custom command can implement
    any verification logic, simulations launched through a custom command
    are considered unsuccessful if the return code of the custom command
    is non-null. The custom command may use Mako templating syntax. See
    the `__init__` method implementation for more details on the dynamic
    arguments which can be used in the command template.
    """

    def __init__(self, sim_bin=None, cmd=None, **kwargs):
        """Constructor for the RTLSimulation class.

        Arguments:
            sim_bin: The simulation binary.
            kwargs: Arguments passed to the base class constructor.
        """
        super().__init__(**kwargs)
        if cmd is None:
            self.cmd = [str(sim_bin), str(self.elf)]
            self.ext_verif_logic = False
        else:
            self.dynamic_args = {
                'sim_bin': str(sim_bin),
                'elf': str(self.elf),
                'run_dir': str(self.run_dir)
            }
            self.cmd = [Template(arg).render(**self.dynamic_args) for arg in cmd]
            self.ext_verif_logic = True


class VerilatorSimulation(RTLSimulation):
    """An RTL simulation running on Verilator.

    The return code of the simulation is returned directly as the
    return code of the command launching the simulation.
    """
    pass


class QuestaVCSSimulation(RTLSimulation):
    """An RTL simulation running on QuestaSim or VCS.

    QuestaSim and VCS print out the simulation return code in the
    simulation log. This must be parsed to extract the return code.

    If the simulation is launched through a custom command which
    implements external verification logic, the return code of the
    command is used to determine the exit status of the simulation.
    """

    def get_retcode(self):
        if self.ext_verif_logic:
            return super().get_retcode()
        elif self.log is not None:
            # Extract the application's return code from the simulation log
            with open(self.log, 'r') as f:
                for line in f.readlines():
                    regex_success = r'\[SUCCESS\] Program finished successfully'
                    match_success = re.search(regex_success, line)
                    if match_success:
                        return 0
                    else:
                        regex_fail = r'\[FAILURE\] Finished with exit code\s+(\d+)'
                        match = re.search(regex_fail, line)
                        if match:
                            return int(match.group(1))

    def successful(self):
        # Check that simulation return code matches expected value (in super class)
        success = super().successful()
        # If not launched through a custom command, check that the simulator process also
        # terminated correctly
        if not self.ext_verif_logic:
            if self.process is None or self.process.returncode != 0:
                return False
        return success

    def get_simulation_time(self):
        # Extract the simulation time from the simulation log
        if self.log is not None:
            with open(self.log, 'r') as f:
                for line in reversed(f.readlines()):
                    regex = r'Time: (\d+) ([a-z]+)\s+'
                    match = re.search(regex, line)
                    if match:
                        val = int(match.group(1))
                        unit = match.group(2)
                        if unit == 'ns':
                            return val
                        elif unit == 'us':
                            return val * 1000
                        elif unit == 'ps':
                            return val / 1000
                        else:
                            raise ValueError(f'Unsupported time unit {unit}')


class QuestaSimulation(QuestaVCSSimulation):
    """An RTL simulation running on QuestaSim."""

    def __init__(self, **kwargs):
        super().__init__(**kwargs)

    def get_cpu_time(self):
        # Extract the CPU time from the simulation log
        if self.log is not None:
            with open(self.log, 'r') as f:
                for line in f.readlines():
                    regex = r'Elapsed time: (\d+):(\d+):(\d+)'
                    match = re.search(regex, line)
                    if match:
                        hours = int(match.group(1))
                        minutes = int(match.group(2))
                        seconds = int(match.group(3))
                        return hours*3600 + minutes*60 + seconds


class VCSSimulation(QuestaVCSSimulation):
    """An RTL simulation running on VCS."""

    def get_cpu_time(self):
        # Extract the CPU time from the simulation log
        if self.log is not None:
            with open(self.log, 'r') as f:
                for line in f.readlines():
                    regex = r'CPU Time: \s*([\d.]+) seconds'
                    match = re.search(regex, line)
                    if match:
                        seconds = float(match.group(1))
                        return seconds


class BansheeSimulation(Simulation):
    """A simulation running on Banshee.

    The return code of the simulation is returned directly as the
    return code of the command launching the simulation.
    """

    def __init__(self, banshee_cfg=None, **kwargs):
        """Constructor for the BansheeSimulation class.

        Arguments:
            banshee_cfg: A Banshee config file.
            kwargs: Arguments passed to the base class constructor.
        """
        super().__init__(**kwargs)
        self.cmd = ['banshee', '--no-opt-llvm', '--no-opt-jit', '--configuration',
                    str(banshee_cfg), '--trace', str(self.elf)]
