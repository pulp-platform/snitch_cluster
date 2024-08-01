#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Viviane Potocnik <vivianep@iis.ee.ethz.ch>
# Luca Colagrande <colluca@iis.ee.ethz.ch>
"""Utility to build a software app using multiple configuration files.

This utility builds multiple executables from the same application code,
provided with different data.

It assumes a build system with a specific interface which most existing
kernels comply with. In particular, it assumes the following:

- the build command should be a make target defined by the Snitch cluster
target.
- the data generation can be configured through a JSON file. The path to
this file is provided to the build system in the `$(APP)_DATA_CFG`
environment variable, where `$(APP)` coincides with the build command
name.
- all build artifacts are created in the directory specified by the
`$(APP)_BUILD_DIR` environment variable.

This utility takes a list of data configuration files as input and builds
the application with the data generated from each configuration. Build
artifacts are stored in a separate directory for each configuration.

The utility can optionally generate a testlist file which can be used to
run the generated executables using the [`run.py`][run] utility.
"""

import argparse
import os
from pathlib import Path
import subprocess
import yaml


def parser():
    # Argument parsing
    parser = argparse.ArgumentParser()
    parser.add_argument(
        'target',
        help='Make target to use for the build')
    parser.add_argument(
        '--cfg',
        nargs='*',
        required=True,
        help='List of configurations')
    parser.add_argument(
        '--testlist',
        help='Output a testlist with the generated executables to this file')
    parser.add_argument(
        '--testlist-cmd',
        help='A custom command to use in the testlist')

    return parser


def extend_environment(vars, env=None):
    if env is None:
        env = os.environ.copy()
    env.update(vars)
    return env


# Build software target with a specific data configuration
def build(target, cfg):
    # Define configuration-specific variables for build system
    env = extend_environment({
        f'{target}_DATA_CFG': cfg,
        f'{target}_BUILD_DIR': Path(f'build/{cfg.stem}').resolve()
    })

    # Build the software
    mk_dir = Path(__file__).resolve().parent.parent
    subprocess.run(['make', '-C', mk_dir, 'DEBUG=ON', target],
                   check=True, env=env)


# Create test specification for a specific configuration
def create_test(target, cfg, cmd=None):
    cmd_list = cmd.split()
    cfg = cfg.stem
    app = Path(target).stem
    test = {
        'elf': f'build/{cfg}/{app}.elf',
        'name': f'{app}-{cfg}',
    }
    if cmd:
        test['cmd'] = cmd_list
    return test


# Build testlist file
def dump_testlist(tests, outfile):
    if outfile:
        with open(outfile, 'w') as f:
            yaml.dump({'runs': tests}, f)


def main():

    # Parse arguments
    args = parser().parse_args()
    cfgs = [Path(cfg) for cfg in args.cfg]

    # Build software
    for cfg in cfgs:
        build(args.target, cfg)

    # Build testlist
    tests = [create_test(args.target, cfg, args.testlist_cmd) for cfg in cfgs]
    dump_testlist(tests, args.testlist)


if __name__ == '__main__':
    main()
