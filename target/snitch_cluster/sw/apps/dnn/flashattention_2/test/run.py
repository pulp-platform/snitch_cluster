#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>
# Viviane Potocnik <vivianep@iis.ee.ethz.ch>

import os
from pathlib import Path
import subprocess
import sys
import yaml

sys.path.append(str(Path(__file__).parent / '../../../../../util/'))
import snitch_cluster  # noqa: E402

ROI_SPEC = Path.cwd() / 'roi.json.tpl'


def parser():
    # Argument parsing
    parser = snitch_cluster.parser()
    parser.add_argument(
        '--cfg',
        nargs='*',
        help='List of configurations')
    parser.add_argument(
        '--post-process-only',
        action='store_true',
        help='Only post-process simulation logs')
    return parser


def parse_args():
    return parser().parse_args()


def extend_environment(env=None, **kwargs):
    if env is None:
        env = os.environ.copy()
    env.update(kwargs)
    return env


# Build software for a specific configuration
def build_sw(cfg):
    env = extend_environment(
        DATA_CFG=cfg,
        DATA_H=Path(f'include/{cfg.stem}/data.h').resolve(),
        APP_BUILDDIR=Path(f'build/{cfg.stem}').resolve()
    )
    subprocess.run(['make', '-C', '../../../../../', 'DEBUG=ON', 'sw/apps/dnn/flashattention_2'],
                   check=True, env=env)


# Build test specification for a specific configuration
def build_test(cfg):
    return {
        'elf': f'build/{cfg.stem}/flashattention_2.elf',
        'name': f'flashattention_2-{cfg.stem}',
        'cmd': [
            '../../../../../../../sw/dnn/flashattention_2/scripts/verify.py',
            "${sim_bin}",
            "${elf}",
            '--dump-results'
        ]
    }


# Build testlist file
def build_testlist(tests, outfile):
    with open(outfile, 'w') as f:
        yaml.dump({'runs': tests}, f)


def post_process(cfg):
    sim_dir = Path(f'sw/apps/dnn/flashattention_2/tests/runs/flashattention_2-{Path(cfg).stem}')
    binary = Path(f'sw/apps/dnn/flashattention_2/tests/build/\
                  {Path(cfg).stem}/flashattention_2.elf')
    subprocess.run(['make', '-C', '../../../../../', f'SIM_DIR={sim_dir}',
                    'annotate', f'BINARY={binary}', '-j'],
                   check=True)


def main():

    args = parse_args()

    if not args.post_process_only:

        # Build software and test specifications
        tests = []
        for cfg in args.cfg:
            cfg = Path(cfg)
            build_sw(cfg)
            tests.append(build_test(cfg))

        # Build the testlist
        build_testlist(tests, args.testlist)

        # Run the simulations
        simulations = snitch_cluster.get_simulations(args)
        snitch_cluster.run_simulations(simulations, args)

    for cfg in args.cfg:
        post_process(cfg)


if __name__ == '__main__':
    main()
