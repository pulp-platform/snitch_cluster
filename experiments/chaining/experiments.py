#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import matplotlib as mpl
import matplotlib.pyplot as plt
import numpy as np
from pathlib import Path
from snitch.util.experiments.experiment_utils import ExperimentManager
from snitch.util.experiments.common import extend_environment
from snitch.util.experiments.SimResults import SimRegion
from statistics import geometric_mean as geomean
import yaml

# Plot parameters
A4_HEIGHT = 11.7
IEEE_TEXT_WIDTH = 7.244
IEEE_TWO_COLUMN_SEP = 0.157
IEEE_COL_WIDTH = (IEEE_TEXT_WIDTH - IEEE_TWO_COLUMN_SEP) / 2

# Files
RESULT_DIR = Path('results')
PLS_TESTLIST = Path('pls.yaml')
POWER_DIR = Path('results')


class ChainingExperimentManager(ExperimentManager):

    def derive_axes(self, experiment):
        return {
            'app': experiment['app'],
            'impl': experiment['impl']
        }

    def derive_cdefines(self, experiment):
        cdefs = {}
        if experiment['impl'] == 'baseline':
            cdefs['IMPL'] = 'IMPL_BASELINE_3'
        elif experiment['impl'] == 'baseline-':
            cdefs['IMPL'] = 'IMPL_BASELINE_2'
        elif experiment['impl'] == 'baseline--':
            cdefs['IMPL'] = 'IMPL_BASELINE_1'
        elif experiment['impl'] == 'chaining':
            cdefs['IMPL'] = 'IMPL_OPTIMIZED_1'
        elif experiment['impl'] == 'chaining+':
            cdefs['IMPL'] = 'IMPL_OPTIMIZED_2'
        else:
            raise ValueError('Unknown implementation')
        return cdefs

    def derive_env(self, experiment):
        if 'vcd_start' in experiment and 'vcd_end' in experiment:
            return extend_environment({
                'VCD_START': str(experiment['vcd_start']),
                'VCD_END': str(experiment['vcd_end'])
            })
        else:
            return None


def get_fpu_utilization(row):
    fpss_fpu_issues = 0
    for roi in range(1, 1 + 14 + 1):
        fpss_fpu_issues += row['results'].get_metric(SimRegion('hart_0', roi), 'fpss_fpu_issues')
    return fpss_fpu_issues / get_runtime(row)


def get_runtime(row):
    cycles = 0
    for roi in range(1, 1 + 14 + 1):
        cycles += row['results'].get_metric(SimRegion('hart_0', roi), 'cycles')
    return cycles


def get_power_interval(row):
    roi = SimRegion('hart_0', 4)
    tstart = row['results'].get_metric(roi, 'tstart')
    tend = row['results'].get_metric(roi, 'tend')
    return tstart, tend


def get_energy(row):
    interval = get_power_interval(row)
    runtime = interval[1] - interval[0]
    power = row['power']
    return power * runtime


def fig(df):
    power_results_available = df['power_results'].notna().all()

    # Get metrics of interest for every run
    df['fpu_util'] = df.apply(get_fpu_utilization, axis=1)
    df['runtime'] = df.apply(get_runtime, axis=1)
    if power_results_available:
        df['power'] = df.apply(lambda row: row['power_results'].total_power, axis=1)
        df['energy'] = df.apply(get_energy, axis=1)
    print(df)

    # Prepare data for plotting
    apps = df['app'].unique().tolist()
    impls = df['impl'].unique().tolist()
    num_apps = len(apps)
    num_impls = len(impls)

    # Create the plot
    fig, ax = plt.subplots(1, 2)
    ind = np.arange(num_apps)
    bar_height = 0.8 / num_impls  # Total height divided among implementations
    cmap = mpl.colormaps['plasma']
    colors = [cmap(0.1), cmap(0.25), cmap(0.48), cmap(0.66), cmap(0.82)]
    for i, impl in enumerate(impls):
        y_positions = ind - i * bar_height * 1.1

        # FPU utilization
        fpu_util = df[df['impl'] == impl]['fpu_util']
        bars = ax[0].barh(y_positions, fpu_util, height=bar_height, label=impl, color=colors[i])
        ax[0].bar_label(bars, label_type='center', fmt='{:.2f}', color='white')

        # Power
        power = df[df['impl'] == impl]['power'] if power_results_available else 0
        bars = ax[1].barh(y_positions, power, height=bar_height, label=impl, color=colors[i])
        ax[1].bar_label(bars, label_type='center', fmt='{:.1f}', color='white')

    # Configure plot
    ax[0].set_yticks(
        ind - 1.1 * bar_height * (num_impls - 1) / 2,
        apps,
        rotation=90,
        verticalalignment='center'
    )
    ax[0].set_xlim((0, 1))
    ax[1].set_yticks([], [])
    fig.legend(
        labels=['Base--', 'Base-', 'Base [7]', 'Chaining', 'Chaining+'],
        title='',
        loc='outside upper center',
        ncols=num_impls,
        borderaxespad=0.0
    )

    # Display the plot
    file = RESULT_DIR / 'plot1.pdf'
    file.parent.mkdir(parents=True, exist_ok=True)
    plt.gcf().set_size_inches(IEEE_COL_WIDTH, 0.145 * A4_HEIGHT)
    plt.gcf().subplots_adjust(
        left=0.05,
        bottom=0.08,
        right=1,
        top=0.85
    )
    plt.savefig(file)

    def to_percentage(val):
        return int(round((val - 1) * 100))

    # Performance metrics
    base_df = df[df['impl'] == 'baseline']
    chain_df = df[df['impl'] == 'chaining']
    chain_plus_df = df[df['impl'] == 'chaining+']
    speedup = base_df['runtime'].to_numpy() / chain_plus_df['runtime'].to_numpy()
    max_base_fpu_util = base_df['fpu_util'].max()
    max_opt2_fpu_util = chain_plus_df['fpu_util'].max()
    perf_metrics = {
        'GeomeanSpeedup': '{}'.format(to_percentage(geomean(speedup))),
        'BaselinePeakFPUUtil': '{}'.format(int(max_base_fpu_util * 100)),
        'OptimizedPeakFPUUtil': '{}'.format(int(max_opt2_fpu_util * 100)),
    }

    # Energy metrics
    energy_metrics = {}
    if power_results_available:
        opt1_energy_impr = base_df['energy'].to_numpy() / chain_df['energy'].to_numpy()
        opt2_energy_impr = base_df['energy'].to_numpy() / chain_plus_df['energy'].to_numpy()
        energy_metrics |= {
            'GeomeanEnergyImprovementOptI': '{}'.format(to_percentage(geomean(opt1_energy_impr))),
            'GeomeanEnergyImprovementOptII': '{}'.format(to_percentage(geomean(opt2_energy_impr))),
        }

    return perf_metrics | energy_metrics


def latex_metrics(metrics):
    # Auxiliary function to format a metric as a LaTeX command
    def latex_metric(name, value):
        return f"\\newcommand{{\\Result{name}}}{{{value}}}\n"

    # Create file
    file = RESULT_DIR / 'metrics.tex'
    file.parent.mkdir(parents=True, exist_ok=True)
    with open(file, 'w') as f:
        [f.write(latex_metric(name, value)) for name, value in metrics.items()]


def global_plot_settings():
    # Change global plot settings for export
    # plt.rcParams['font.family'] = 'Latin Modern Roman'
    plt.rcParams['font.size'] = 6
    plt.rcParams['xtick.major.size'] = 3
    plt.rcParams['xtick.major.pad'] = 2
    plt.rcParams['axes.labelpad'] = 2
    plt.rcParams['axes.linewidth'] = 0.5
    plt.rcParams['xtick.major.width'] = 0.5
    plt.rcParams['xtick.minor.width'] = 0.5
    plt.rcParams['ytick.major.width'] = 0.5
    plt.rcParams['ytick.minor.width'] = 0.5
    plt.rcParams['patch.linewidth'] = 0.5
    plt.rcParams['lines.linewidth'] = 1
    plt.rcParams['legend.handletextpad'] = 0.5
    plt.rcParams['legend.columnspacing'] = 1
    # Use Latex backend for rendering
    # plt.rcParams['text.usetex'] = True
    # plt.rcParams['text.latex.preamble'] = r'\usepackage[T1]{fontenc}\usepackage{lmodern}'


def dump_pls_testlist(manager):
    df = manager.get_results()
    vcd_interval = df.apply(lambda row: get_power_interval(row), axis=1)

    experiments = manager.yaml['experiments']
    for i, experiment in enumerate(experiments):
        vcd_start, vcd_end = vcd_interval.iloc[i]
        experiment['vcd_start'] = vcd_start
        experiment['vcd_end'] = vcd_end

    with open(PLS_TESTLIST, 'w') as f:
        [experiment.pop('cmd', None) for experiment in experiments]
        yaml.dump({'experiments': experiments}, f, sort_keys=False)


def main():
    parser = ChainingExperimentManager.parser()
    parser.add_argument('--dump-pls-testlist', action='store_true')
    parser.add_argument('--plot', action='store_true')
    args = parser.parse_args()
    manager = ChainingExperimentManager(args=args)
    manager.run()

    if args.dump_pls_testlist:
        dump_pls_testlist(manager)

    if args.plot:
        global_plot_settings()

        df = manager.get_results()

        metrics = {}
        metrics.update(fig(df))
        latex_metrics(metrics)


if __name__ == '__main__':
    main()
