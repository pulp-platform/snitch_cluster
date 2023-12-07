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

    LOG_FILE = 'sim.txt'

    def __init__(self, elf=None):
        self.elf = elf
        self.testname = Path(self.elf).stem
        self.cmd = []
        self.log = None
        self.process = None

    def launch(self, run_dir=None, dry_run=False):
        # Default to current working directory as simulation directory
        if not run_dir:
            run_dir = Path.cwd()

        # Print launch message and simulation command
        cprint(f'Run test {colored(self.elf, "cyan")}', attrs=["bold"])
        cmd_string = ' '.join(self.cmd)
        print(f'$ {cmd_string}', flush=True)

        # Launch simulation if not doing a dry run
        if not dry_run:
            # Create run directory and log file
            os.makedirs(run_dir, exist_ok=True)
            self.log = run_dir / self.LOG_FILE
            # Launch simulation subprocess
            with open(self.log, 'w') as f:
                self.process = subprocess.Popen(self.cmd, stdout=f, stderr=subprocess.STDOUT,
                                                cwd=run_dir, universal_newlines=True)

    def completed(self):
        if self.process:
            return self.process.poll() is not None
        else:
            return False

    def successful(self):
        return None

    def print_log(self):
        with open(self.log, 'r') as f:
            print(f.read())

    def print_status(self):
        if self.completed():
            if self.successful():
                cprint(f'{self.elf} test passed', 'green', attrs=['bold'], flush=True)
            else:
                cprint(f'{self.elf} test failed', 'red', attrs=['bold'], flush=True)
        else:
            cprint(f'{self.elf} test running', 'black', flush=True)


class BistSimulation(Simulation):

    def __init__(self, elf=None, retcode=0):
        super().__init__(elf)
        self.expected_retcode = retcode
        self.actual_retcode = None

    def get_retcode(self):
        return None

    def successful(self):
        # Simulation is successful if it returned a return code, and
        # the return code matches the expected value
        self.actual_retcode = self.get_retcode()
        if self.actual_retcode is not None:
            return int(self.actual_retcode) == int(self.expected_retcode)
        else:
            return False


class RTLSimulation(BistSimulation):

    def __init__(self, elf=None, retcode=0, sim_bin=None):
        super().__init__(elf, retcode)
        self.cmd = [str(sim_bin), str(self.elf)]


class VerilatorSimulation(RTLSimulation):

    def get_retcode(self):
        return self.process.returncode


class QuestaVCSSimulation(RTLSimulation):

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
                        return match.group(1)

    def successful(self):
        # Check that simulation return code matches expected value (in super class)
        # and that the simulation process terminated correctly
        success = super().successful()
        if self.process.returncode != 0:
            return False
        else:
            return success


class QuestaSimulation(QuestaVCSSimulation):

    def __init__(self, elf=None, retcode=0, sim_bin=None):
        super().__init__(elf, retcode, sim_bin)
        self.cmd += ['', '-batch']


class VCSSimulation(QuestaVCSSimulation):
    pass


class BansheeSimulation(BistSimulation):

    def __init__(self, elf=None, retcode=0, banshee_cfg=None):
        super().__init__(elf, retcode)
        self.cmd = ['banshee', '--no-opt-llvm', '--no-opt-jit', '--configuration',
                    str(banshee_cfg), '--trace', str(self.elf)]

    def get_retcode(self):
        return self.process.returncode


class CustomSimulation(Simulation):

    def __init__(self, elf=None, sim_bin=None, cmd=None):
        super().__init__(elf)
        self.dynamic_args = {'sim_bin': str(sim_bin), 'elf': str(elf)}
        self.cmd = cmd

    def launch(self, run_dir=None, dry_run=False):
        self.dynamic_args['run_dir'] = str(run_dir)
        self.cmd = [Template(arg).render(**self.dynamic_args) for arg in self.cmd]
        super().launch(run_dir, dry_run)

    def successful(self):
        return self.process.returncode == 0
