#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import pandas as pd

from experiments import get_simulation_results, get_axis
from snitch.target.SimResults import SimRegion


def calculate_ipc_throughput(results, impl, n_cores, n_samples, batch_size):
    # In baseline implementation, the IPC is that of the single PSUM region.
    # We need to be careful and calculate it correctly across all cores.
    if impl == 'baseline':
        print(f'\nbaseline {n_cores}')
        cycles = 0
        issues = 0
        n_samples_per_core = n_samples // n_cores
        for hartid in range(n_cores):
            hartid = 'hart_' + str(hartid)
            cycles += results.get_metric(SimRegion(hartid, 'psum'), 'cycles')
            snitch_issues = results.get_metric(SimRegion(hartid, 'psum'), 'snitch_issues')
            fpss_issues = results.get_metric(SimRegion(hartid, 'psum'), 'fpss_issues')
            issues += snitch_issues + fpss_issues
            print(f'{hartid}: {snitch_issues / n_samples_per_core} snitch issues, '
                  f'{fpss_issues / n_samples_per_core} fpss issues, '
                  f'{cycles / n_samples_per_core} cycles')
        ipc = issues / cycles
        throughput = 1000 * n_samples / cycles
    # In optimized implementation, the IPC needs to be calculated from a steady-state batch.
    # We need to be careful and calculate it correctly across all cores.
    elif impl == 'optimized':
        print(f'\noptimized {n_cores}')
        n_samples_per_batch = batch_size * n_cores
        n_batches = n_samples // n_samples_per_batch
        assert n_batches >= 4, 'Not enough batches to reach steady state'
        cycles = 0
        issues = 0
        for hartid in range(n_cores):
            hartid = 'hart_' + str(hartid)
            # Measure steady-state iteration (i.e. iteration 3)
            cycles += results.get_metric(SimRegion(hartid, 'iteration', 3), 'cycles')
            snitch_issues = results.get_metric(SimRegion(hartid, 'iteration', 3), 'snitch_issues')
            fpss_issues = results.get_metric(SimRegion(hartid, 'iteration', 3), 'fpss_issues')
            print(f'{hartid}: {snitch_issues / batch_size} snitch issues, '
                  f'{fpss_issues / batch_size} fpss issues, {cycles / batch_size} cycles')
            issues += snitch_issues + fpss_issues
        ipc = issues / cycles
        throughput = 1000 * n_samples_per_batch / cycles
    else:
        raise ValueError(f'Unsupported implementation: {impl}')
    return ipc, throughput


def plot1(experiments):
    # Extract data
    data = []
    apps = get_axis(experiments, 'app')
    prngs = get_axis(experiments, 'prng')
    n_samples = get_axis(experiments, 'n_samples')[0]
    batch_size = get_axis(experiments, 'batch_size')[0]
    all_implementations = get_axis(experiments, 'impl')
    all_n_cores = get_axis(experiments, 'n_cores')
    for app in apps:
        for prng in prngs:
            for impl in all_implementations:
                if impl != 'naive':
                    for n_cores in all_n_cores:
                        results = get_simulation_results({
                            'app': app,
                            'prng': prng,
                            'impl': impl,
                            'n_cores': n_cores,
                            'n_samples': n_samples,
                            'batch_size': batch_size,
                        })
                        ipc, throughput = calculate_ipc_throughput(results, impl, n_cores, n_samples,
                                                                   batch_size)
                        data.append({'app': app, 'prng': prng, 'impl': impl + str(n_cores), 'metric': 'ipc', 'value': ipc})
                        data.append({'app': app, 'prng': prng, 'impl': impl + str(n_cores), 'metric': 'throughput', 'value': throughput})
    df = pd.DataFrame(data)

    for prng in prngs:
        for app in apps:
            print(f'\n{app} {prng}')
            df_app = df[df['app'] == app]
            df_prng = df_app[df_app['prng'] == prng]
            pivot_df = df_prng.pivot(index='metric', columns='impl', values='value')
            pivot_df.index.name = None
            pivot_df.columns.name = None
            print(pivot_df)


def main(experiments):
    plot1(experiments)
