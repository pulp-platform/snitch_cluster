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

    def __init__(self, elf=None, dry_run=False, retcode=0, run_dir=None):
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
        self.testname = Path(self.elf).stem
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
            if self.process:
                return int(self.process.returncode)

    def successful(self):
        """Return whether the simulation was successful."""
        actual_retcode = self.get_retcode()
        if actual_retcode is not None:
            return int(actual_retcode) == int(self.expected_retcode)
        else:
            return False

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
        else:
            cprint(f'{self.elf} test running', 'yellow', attrs=['bold'], flush=True)


class RTLSimulation(Simulation):
    """A simulation run on an RTL simulator.

    An RTL simulation is launched through a simulation binary built
    in advance from some RTL design.
    """

    def __init__(self, sim_bin=None, **kwargs):
        """Constructor for the RTLSimulation class.

        Arguments:
            sim_bin: The simulation binary.
            kwargs: Arguments passed to the base class constructor.
        """
        super().__init__(**kwargs)
        self.cmd = [str(sim_bin), str(self.elf)]


class VerilatorSimulation(RTLSimulation):
    """An RTL simulation running on Verilator.

    The return code of the simulation is returned directly as the
    return code of the command launching the simulation.
    """

    def get_retcode(self):
        return self.process.returncode


class QuestaVCSSimulation(RTLSimulation):
    """An RTL simulation running on QuestaSim or VCS.

    QuestaSim and VCS print out the simulation return code in the
    simulation log. This is parsed to extract the return code.
    """

    def get_retcode(self):
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
        # and that the simulation process terminated correctly
        success = super().successful()
        if self.process.returncode != 0:
            return False
        else:
            return success


class QuestaSimulation(QuestaVCSSimulation):
    """An RTL simulation running on QuestaSim."""

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.cmd += ['', '-batch']


class VCSSimulation(QuestaVCSSimulation):
    """An RTL simulation running on VCS."""
    pass


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


class CustomSimulation(Simulation):
    """A simulation which is run through a custom command.

    The custom command generally invokes an RTL simulator binary behind
    the scenes and executes some additional verification logic after
    the end of the simulation.

    Custom simulations are considered unsuccessful if the return code
    of the custom command is non-null. As a custom command can
    implement any verification logic, there is no reason to implement
    any additional logic here.
    """

    def __init__(self, sim_bin=None, cmd=None, **kwargs):
        """Constructor for the CustomSimulation class.

        Arguments:
            sim_bin: The simulation binary.
            cmd: The custom command used to launch the simulation.
            kwargs: Arguments passed to the base class constructor.
        """
        super().__init__(**kwargs)
        self.dynamic_args = {
            'sim_bin': str(sim_bin),
            'elf': str(self.elf),
            'run_dir': str(self.run_dir)
        }
        self.cmd = cmd

    def launch(self, **kwargs):
        self.cmd = [Template(arg).render(**self.dynamic_args) for arg in self.cmd]
        super().launch(**kwargs)
