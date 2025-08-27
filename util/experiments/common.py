# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

from pathlib import Path
import os
import subprocess

MK_DIR = Path(__file__).resolve().parent / '../../'


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
            return subprocess.run(cmd, env=env)
        else:
            return subprocess.Popen(cmd, env=env)


def make(target, vars={}, flags=[], dir=MK_DIR, env=None, dry_run=False, sync=True):
    var_assignments = [f'{key}={value}' for key, value in vars.items()]
    cmd = ['make', *var_assignments, target]
    if dir is not None:
        cmd.extend(['-C', dir])
    cmd.extend(flags)
    return run(cmd, env=env, dry_run=dry_run, sync=sync)
