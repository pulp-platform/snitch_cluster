#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import matplotlib as mpl
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from pathlib import Path
import re
from snitch.util.experiments.experiment_utils import ExperimentManager
from snitch.util.experiments.common import extend_environment
from snitch.util.experiments.SimResults import SimRegion
from statistics import geometric_mean
import yaml

# Plot parameters
A4_HEIGHT = 11.7
IEEE_TEXT_WIDTH = 7.244
IEEE_TWO_COLUMN_SEP = 0.157
IEEE_COL_WIDTH = (IEEE_TEXT_WIDTH - IEEE_TWO_COLUMN_SEP) / 2
RESULT_DIR = Path('results')

# Files
PLS_TESTLIST = Path('pls.yaml')


class CopiftExperimentManager(ExperimentManager):

    def derive_axes(self, experiment):
        # Monte Carlo kernels
        if experiment['app'] == 'pi_estimation':
            return {
                'app': experiment['integrand'] + '_' + experiment['prng'],
                'impl': experiment['impl'],
                'length': experiment['n_samples'],
                'batch_size': experiment['batch_size']
            }
        # LIBC kernels
        else:
            return {
                'app': experiment['app'],
                'impl': experiment['impl'],
                'length': experiment['length'],
                'batch_size': experiment['batch_size']
            }

    def derive_cdefines(self, experiment):
        # Monte Carlo kernels
        if experiment['app'] == 'pi_estimation':
            return {
                'APPLICATION': 'APPLICATION_' + experiment['integrand'].upper(),
                'PRNG': 'PRNG_' + experiment['prng'].upper(),
                'N_SAMPLES': experiment['n_samples'],
                'N_CORES': experiment['n_cores'],
                'FUNC_PTR': 'calculate_psum_' + experiment['impl'],
                'BATCH_SIZE': experiment['batch_size'],
            }
        # LIBC kernels
        else:
            return {
                'IMPL': 'IMPL_' + experiment['impl'].upper(),
                'LEN': experiment['length'],
                'BATCH_SIZE': experiment['batch_size']
            }

    def derive_env(self, experiment):
        if 'vcd_start' in experiment and 'vcd_end' in experiment:
            return extend_environment({
                'VCD_START': str(experiment['vcd_start']),
                'VCD_END': str(experiment['vcd_end'])
            })
        else:
            return None


def get_num_stages(row):
    if row['app'] == 'log':
        if row['impl'] != 'Baseline':
            return 4
        else:
            return 3
    elif row['app'] == 'exp':
        if row['impl'] != 'Baseline':
            return 5
        else:
            return 3
    else:
        if row['impl'] != 'Baseline':
            return 3
        else:
            return 1


def get_num_iterations(row):
    n_batches = row['length'] // row['batch_size']
    n_stages = get_num_stages(row)
    return n_stages + n_batches - 1


def get_rois(row, start_iter=-1, end_iter=-1):
    def iter_to_region_idx(iter):
        if row['app'] not in ['exp', 'log'] and row['impl'] == 'Baseline':
            # Baseline Monte Carlo iterations are smaller than batch size
            # (and process exactly only 4 samples) so we adjust it here
            return 2 + iter * (row['batch_size'] // 4)
        else:
            return 2 + iter

    start = iter_to_region_idx(start_iter)

    if end_iter == -1:
        end = iter_to_region_idx(get_num_iterations(row) - 1)
    else:
        end = iter_to_region_idx(end_iter)

    return [SimRegion('hart_0', i) for i in range(start, end)]


def get_interval(row, start_iter=-1, end_iter=-1):
    rois = get_rois(row, start_iter, end_iter)
    tstart = row['results'].get_metric(rois[0], 'tstart')
    tend = row['results'].get_metric(rois[-1], 'tend')
    return tstart, tend


def get_runtime(row, start_iter=-1, end_iter=-1):
    interval = get_interval(row, start_iter, end_iter)
    return interval[1] - interval[0]


def get_ipc(row, start_iter=-1, end_iter=-1):
    rois = get_rois(row, start_iter, end_iter)
    interval = get_interval(row, start_iter, end_iter)
    cycles = interval[1] - interval[0]
    instructions = 0
    for roi in rois:
        instructions += row['results'].get_metric(roi, 'snitch_issues')
        instructions += row['results'].get_metric(roi, 'fpss_issues')
    return instructions / cycles


def fig1(df):
    # Calculate IPC for every run
    df['ipc'] = df.apply(lambda row: get_ipc(row, 4, 8), axis=1)

    # Pivot the DataFrame to reshape it for plotting
    df = df.pivot(index='app', columns='impl', values='ipc').reset_index()

    # Prepare data for plotting
    apps = df['app']
    x = np.arange(len(apps))
    width = 0.35

    # Create the plot
    _, ax = plt.subplots()
    ax.axhline(1, color='black', linewidth=0.5, zorder=1)
    cmap = mpl.colormaps['plasma']
    base_bars = ax.bar(x - width/2, df['Baseline'], width, label='Base', color=cmap(0.48))
    copift_bars = ax.bar(x + width/2, df['COPIFT'], width, label='COPIFT', color=cmap(0.82))
    ax.bar_label(base_bars, label_type='center', fmt='{:.2f}', rotation=90, color='white')
    ax.bar_label(copift_bars, label_type='center', fmt='{:.2f}', rotation=90, color='white')

    # Draw speedup lines
    ipc_increases = df['COPIFT'] / df['Baseline']
    for i in range(len(apps)):
        # Get the coordinates for the line
        base_x = x[i] - width/2
        base_y = df['Baseline'][i]
        copift_y = df['COPIFT'][i]
        label_y = (base_y + copift_y) / 2

        # Draw vertical line
        bottom_margin, top_margin = 18, 24
        label_y_pt = ax.transData.transform((0, label_y))[1]
        label_y_plus_margin, label_y_minus_margin = [
            point[1] for point in ax.transData.inverted().transform(
                [(0, label_y_pt + top_margin), (0, label_y_pt - bottom_margin)]
            )
        ]
        ax.plot([base_x, base_x], [base_y, label_y_minus_margin], color='black', linewidth=0.5)
        ax.plot([base_x, base_x], [label_y_plus_margin, copift_y], color='black', linewidth=0.5)

        # Draw horizontal line
        ax.plot([base_x - width/2, base_x + width/2], [copift_y, copift_y], color='black',
                linewidth=0.5)

        # Draw IPC improvement label in middle of vertical line
        ipc_increase = ipc_increases[i]
        ax.text(base_x, label_y, f"{ipc_increase:.1f}x", ha='center', va='center')

    # Draw expected IPC values
    exp_ipc_increases = [1.28, 1.4, 1.78, 1.9, 1.63, 1.84]
    exp_copift_ipc = df['Baseline'] * exp_ipc_increases
    for i in range(len(apps)):
        # Get the coordinates for the line
        base_x = x[i] + width/2
        copift_y = df['COPIFT'][i]
        exp_copift_y = exp_copift_ipc[i]

        # Draw vertical line
        ax.plot([base_x, base_x], [copift_y, exp_copift_y], color='black', linewidth=0.5,
                linestyle='--')

        # Draw horizontal line
        ax.plot([base_x - width/2, base_x + width/2], [exp_copift_y, exp_copift_y], color='black',
                linewidth=0.5, linestyle='--')

    # Customize the plot
    ax.set_axisbelow(True)
    ax.grid(color='gainsboro', which='both', axis='y', linewidth=0.5)
    ax.set_xlabel('')
    ax.set_ylabel('(a) IPC')
    ax.set_xticks([])
    ax.set_xticklabels([])
    ax.legend(title='', ncols=2)
    plt.tight_layout()

    # Display the plot
    file = RESULT_DIR / 'plot1.pdf'
    file.parent.mkdir(parents=True, exist_ok=True)
    plt.gcf().set_size_inches(IEEE_COL_WIDTH, 0.09 * A4_HEIGHT)
    plt.gcf().subplots_adjust(
        left=0.1,
        bottom=0.04,
        right=1,
        top=1
    )
    plt.savefig(file)

    # Return metrics
    df_poly_lcg = df[df['app'] == 'poly_lcg']
    poly_lcg_increase = (df_poly_lcg['COPIFT'] / df_poly_lcg['Baseline']).item()
    return {
        'GeomeanIPCIncrease': '{:.2f}'.format(geometric_mean(ipc_increases)),
        'PeakIPC': '{:.2f}'.format(df['COPIFT'].max()),
        'GeomeanIPC': '{:.2f}'.format(geometric_mean(df['COPIFT'])),
        'PolyLCGIPCIncrease': '{:.2f}'.format(poly_lcg_increase),
    }


def fig2(df):

    # Prepare data for plotting
    apps = df['app'].unique()
    x = np.arange(len(apps))
    width = 0.35

    # Create the plot
    base_powers = df[df['impl'] == 'Baseline']['total_power'].values
    copift_powers = df[df['impl'] == 'COPIFT']['total_power'].values
    _, ax = plt.subplots()
    cmap = mpl.colormaps['plasma']
    base_bars = ax.bar(x - width/2, base_powers, width, label='Base', color=cmap(0.48))
    copift_bars = ax.bar(x + width/2, copift_powers, width, label='COPIFT', color=cmap(0.82))
    ax.bar_label(base_bars, label_type='center', fmt='{:.2f}', rotation=90, color='white')
    ax.bar_label(copift_bars, label_type='center', fmt='{:.2f}', rotation=90, color='white')

    # Draw speedup lines
    power_increases = copift_powers / base_powers
    for i in range(len(apps)):
        # Get the coordinates for the line
        base_x = x[i] - width/2
        base_y = base_powers[i]
        copift_y = copift_powers[i]

        # Draw vertical line
        ax.plot([base_x, base_x], [base_y, copift_y], color='black', linewidth=0.5)

        # Draw horizontal line
        ax.plot([base_x - width/2, base_x + width/2], [copift_y, copift_y], color='black',
                linewidth=0.5)

        # Draw label on top of horizontal line
        ax.text(base_x, copift_y + 2, f"{power_increases[i]:.2f}x", ha='center', va='center')

    # Customize the plot
    ax.set_axisbelow(True)
    ax.grid(color='gainsboro', which='both', axis='y', linewidth=0.5)
    ax.set_xlabel('')
    ax.set_ylabel('(b) Power [mW]')
    ax.set_ylim(0, copift_powers.max() * 1.2)
    ax.set_xticks([])
    ax.set_xticklabels([])
    ax.legend(title='', ncols=2)
    plt.tight_layout()

    # Display the plot
    file = RESULT_DIR / 'plot2.pdf'
    file.parent.mkdir(parents=True, exist_ok=True)
    plt.gcf().set_size_inches(IEEE_COL_WIDTH, 0.09 * A4_HEIGHT)
    plt.gcf().subplots_adjust(
        left=0.1,
        bottom=0.04,
        right=1,
        top=1
    )
    plt.savefig(file)

    # Return metrics
    return {
        'MaxPowerIncrease': '{:.2f}'.format(power_increases.max()),
        'GeomeanPowerIncrease': '{:.2f}'.format(geometric_mean(power_increases)),
    }


def fig3(df):
    df['runtime'] = df.apply(lambda row: get_runtime(row, 4, 8), axis=1)

    # Prepare data for plotting
    apps = df['app'].unique()
    x = np.arange(len(apps))
    width = 0.35
    base_runtimes = df[df['impl'] == 'Baseline']['runtime'].values
    copift_runtimes = df[df['impl'] == 'COPIFT']['runtime'].values
    base_powers = df[df['impl'] == 'Baseline']['total_power'].values
    copift_powers = df[df['impl'] == 'COPIFT']['total_power'].values
    speedup = base_runtimes / copift_runtimes
    energy_saving = (base_powers * base_runtimes) / (copift_powers * copift_runtimes)

    # Create the plot
    _, ax = plt.subplots()
    ax.axhline(1, color='black', linewidth=0.5, zorder=1)
    cmap = mpl.colormaps['plasma']
    speedup_bars = ax.bar(x - width/2, speedup, width, label='Speedup', color=cmap(0.48))
    energy_saving_bars = ax.bar(x + width/2, energy_saving, width, label='Energy improvement',
                                color=cmap(0.82))

    # Add labels to the bars
    ax.bar_label(speedup_bars, label_type='center', fmt='{:.2f}', rotation=90, color='white')
    ax.bar_label(energy_saving_bars, label_type='center', fmt='{:.2f}', rotation=90, color='white')

    # Draw expected speedup values
    exp_speedups = [1.14, 1.26, 1.39, 1.55, 1.6, 2.21]
    for i in range(len(apps)):
        # Get the coordinates for the line
        base_x = x[i] - width/2
        speedup_y = speedup[i]
        exp_speedup_y = exp_speedups[i]

        # Draw vertical line
        ax.plot([base_x, base_x], [speedup_y, exp_speedup_y], color='black', linewidth=0.5,
                linestyle='--')

        # Draw horizontal line
        ax.plot([base_x - width/2, base_x + width/2], [exp_speedup_y, exp_speedup_y],
                color='black', linewidth=0.5, linestyle='--')

    # Customize the plot
    ax.set_axisbelow(True)
    ax.grid(color='gainsboro', which='both', axis='y', linewidth=0.5)
    ax.set_xlabel('')
    ax.set_ylabel('(c) Speedup/Energy impr.')
    ax.set_xticks(x)
    ax.set_xticklabels(apps, rotation=30)
    ax.legend(title='', ncols=2)
    plt.tight_layout()

    # Display the plot
    file = RESULT_DIR / 'plot3.pdf'
    file.parent.mkdir(parents=True, exist_ok=True)
    plt.gcf().set_size_inches(IEEE_COL_WIDTH, 0.131 * A4_HEIGHT)
    plt.gcf().subplots_adjust(
        left=0.1,
        bottom=0.34,
        right=1,
        top=0.98
    )
    plt.savefig(file)

    # Return metrics
    return {
        'PeakSpeedup': '{:.2f}'.format(speedup.max()),
        'GeomeanSpeedup': '{:.2f}'.format(geometric_mean(speedup)),
        'PeakEnergySaving': '{:.2f}'.format(energy_saving.max()),
        'GeomeanEnergySaving': '{:.2f}'.format(geometric_mean(energy_saving)),
    }


def group_power_breakdown(df):
    import fnmatch
    patterns = [
        '*i_snitch_shared_muldiv*',
        '*gen_core_1*i_snitch_fp_ss*',
        '*gen_core_1*i_idma_inst64*',
        '*i_snitch_icache*',
        '*i_data_mem*',
        '*i_axi_dma_xbar*',
        '*gen_core_0*i_snitch_fp_ss*'
    ]
    power_summary = []
    for pattern in patterns:
        matching_entries = df[df['name'].apply(lambda x: fnmatch.fnmatch(x, pattern))]
        int_power_sum = matching_entries['int_power'].sum()
        switch_power_sum = matching_entries['switch_power'].sum()
        leak_power_sum = matching_entries['leak_power'].sum()
        total_power_sum = matching_entries['total_power'].sum()
        power_summary.append({
            'name': pattern,
            'int_power': int_power_sum,
            'switch_power': switch_power_sum,
            'leak_power': leak_power_sum,
            'total_power': total_power_sum
        })
    return pd.DataFrame(power_summary)


def dump_pls_testlist(testlist, df):
    vcd_interval = df.apply(lambda row: get_interval(row, 4, 8), axis=1)

    for i, experiment in enumerate(testlist['experiments']):
        vcd_start, vcd_end = vcd_interval.iloc[i]
        experiment['vcd_start'] = vcd_start
        experiment['vcd_end'] = vcd_end

    with open(PLS_TESTLIST, 'w') as f:
        yaml.dump(testlist, f, sort_keys=False)


def latex_metrics(metrics):
    # Auxiliary function to format a metric as a LaTeX command
    def latex_metric(name, value):
        return f"\\newcommand{{\\Result{name}}}{{{value}}}\n"

    # Create file
    with open(RESULT_DIR / 'metrics.tex', 'w') as f:
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


def parse_summary_power_report(report_dir):
    total_power_regex = r'Total Power\s*=\s*([0-9.]+)\s*'
    clock_power_regex = r'clock_network\s+'
    clock_power_regex += r'[0-9]*\.?[0-9]+[eE]?[+-]?[0-9]+\s+'  # Internal power
    clock_power_regex += r'[0-9]*\.?[0-9]+[eE]?[+-]?[0-9]+\s+'  # Switching power
    clock_power_regex += r'[0-9]*\.?[0-9]+[eE]?[+-]?[0-9]+\s+'  # Leakage power
    clock_power_regex += r'([0-9]*\.?[0-9]+[eE]?[+-]?[0-9]+)\s+'  # Total power
    with open(report_dir / 'power.rpt', 'r') as file:
        for line in file:
            match = re.search(total_power_regex, line)
            if match:
                total_power = float(match.group(1)) * 1000
            match = re.search(clock_power_regex, line)
            if match:
                clock_power = float(match.group(1)) * 1000
    return total_power, clock_power


def parse_hierarchical_power_report(report_dir):
    regex = r'^(\s*)'  # Indentation
    regex += r'(\S+)\s+'  # Instance name
    regex += r'(\([^)]+\))?\s+'  # Module name
    regex += r'([0-9]*\.?[0-9]+[eE]?[+-]?[0-9]+)\s+'  # Internal power
    regex += r'([0-9]*\.?[0-9]+[eE]?[+-]?[0-9]+)\s+'  # Switching power
    regex += r'([0-9]*\.?[0-9]+[eE]?[+-]?[0-9]+)\s+'  # Leakage power
    regex += r'([0-9]*\.?[0-9]+[eE]?[+-]?[0-9]+)\s+'  # Total power
    regex += r'([0-9]*\.?[0-9]+)'
    data = []
    stack = []
    level_indent = 2
    previous_indent = 0
    previous_name = ''
    with open(report_dir / 'power_hier.rpt', 'r') as file:
        for line in file:
            line = line.rstrip()
            match = re.match(regex, line)
            if match:
                indent = len(match.group(1))
                name = match.group(2)
                int_power = float(match.group(4)) * 1000
                switch_power = float(match.group(5)) * 1000
                leak_power = float(match.group(6)) * 1000
                total_power = float(match.group(7)) * 1000
                percentage = float(match.group(8))

                # Flatten hierarchy
                if indent > previous_indent:
                    stack.append(previous_name)
                elif indent < previous_indent:
                    levels_up = (previous_indent - indent) // level_indent
                    for _ in range(levels_up):
                        if stack:
                            stack.pop()
                full_name = '_'.join(stack + [name])
                previous_indent = indent
                previous_name = name

                data.append({
                    'name': full_name,
                    'int_power': int_power,
                    'switch_power': switch_power,
                    'leak_power': leak_power,
                    'total_power': total_power,
                    'percentage': percentage
                })
    return pd.DataFrame(data)


def main():
    parser = CopiftExperimentManager.parser()
    parser.add_argument('--dump-pls-testlist', action='store_true')
    parser.add_argument('--plot', action='store_true')
    args = parser.parse_args()
    manager = CopiftExperimentManager(args=args)
    manager.run()
    df = manager.get_results()

    power_results_available = Path('power').exists()

    if power_results_available:
        data = []
        for experiment in manager.experiments:
            report_dir = manager.derive_dir(Path('power'), experiment)
            total_power, clock_power = parse_summary_power_report(report_dir)
            data.append({
                'total_power': total_power,
                'clock_power': clock_power,
                'power_breakdown': parse_hierarchical_power_report(report_dir)
            })
        power_df = pd.DataFrame(data)
        df = pd.concat([df, power_df], axis=1)

    # Rename implementations for consistency
    df['impl'] = df['impl'].replace({
        'issr': 'COPIFT',
        'optimized': 'COPIFT',
        'baseline': 'Baseline'
    })

    global_plot_settings()

    if args.dump_pls_testlist:
        dump_pls_testlist(manager.yaml, df)

    # Reorder columns according to Base IR
    desired_order = ['pi_xoshiro128p', 'poly_xoshiro128p', 'pi_lcg', 'poly_lcg', 'log', 'exp']
    df['app'] = pd.Categorical(df['app'], categories=desired_order, ordered=True)
    df = df.sort_values('app').reset_index(drop=True)

    metrics = {}
    metrics.update(fig1(df))
    if power_results_available:
        metrics.update(fig2(df))
        metrics.update(fig3(df))
    latex_metrics(metrics)


if __name__ == '__main__':
    main()
