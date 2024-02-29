#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

from snitch_cluster import parser, get_simulations, run_simulations
import sys


def main():
    args = parser().parse_args()
    simulations = get_simulations(args)
    return run_simulations(simulations, args)


if __name__ == '__main__':
    sys.exit(main())
