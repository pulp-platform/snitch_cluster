# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import ctypes
from pathlib import Path
import os
import signal
import subprocess
import sys
from termcolor import colored

MK_DIR = Path(__file__).resolve().parent / '../../'


# Set the parent-death signal of the current process to `sig`.
def _set_pdeathsig(sig=signal.SIGTERM):
    libc = ctypes.CDLL("libc.so.6", use_errno=True)
    PR_SET_PDEATHSIG = 1
    if libc.prctl(PR_SET_PDEATHSIG, sig) != 0:
        e = ctypes.get_errno()
        raise OSError(e, "prctl(PR_SET_PDEATHSIG) failed")


def join_cdefines(defines):
    return ' '.join([f'-D{key}={value}' for key, value in defines.items()])


def extend_environment(vars, env=None):
    if env is None:
        env = os.environ.copy()
    env.update(vars)
    return env


def run(cmd, env=None, dry_run=False, sync=True):
    cmd = [str(arg) for arg in cmd]
    if dry_run:
        print(' '.join(cmd))
        return None
    else:
        if sync:
            return subprocess.run(cmd, env=env, preexec_fn=_set_pdeathsig)
        else:
            return subprocess.Popen(cmd, env=env, preexec_fn=_set_pdeathsig)


def make(target, vars={}, flags=[], dir=MK_DIR, env=None, dry_run=False, sync=True):
    var_assignments = [f'{key}={value}' for key, value in vars.items()]
    cmd = ['make', *var_assignments, target]
    if dir is not None:
        cmd.extend(['-C', dir])
    cmd.extend(flags)
    return run(cmd, env=env, dry_run=dry_run, sync=sync)


def wait_processes(processes, dry_run=False):
    if not dry_run:
        for i, p in enumerate(processes):
            retcode = p.wait()
            if retcode != 0:
                print(
                    colored(f'Process failed with exit code {retcode}:\n', 'red', attrs=['bold']),
                    colored(f'{" ".join(p.args)}', 'black')
                )
                sys.exit(1)
