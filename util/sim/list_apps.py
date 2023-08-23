#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import argparse
import yaml


def main():
    # Argument parsing
    parser = argparse.ArgumentParser()
    parser.add_argument(
        'input',
        help='The YAML file containing run information',
    )
    args = parser.parse_args()

    with open(args.input, 'r') as file:
        tests = yaml.safe_load(file)['runs']

    for test in tests:
        print(test['app'])


if __name__ == '__main__':
    main()
