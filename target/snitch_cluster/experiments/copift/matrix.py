#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

from experiments import get_ipc, RESULT_DIR, IEEE_COL_WIDTH, A4_HEIGHT, CopiftExperimentManager
from experiments import global_plot_settings
import matplotlib as mpl
import matplotlib.pyplot as plt
import numpy as np


def fig1(df):

    # Filter data
    copift_df = df[df['impl'] != 'Baseline']
    copift_df['ipc'] = copift_df.apply(lambda row: get_ipc(row, 0, -1), axis=1)
    copift_df = copift_df.pivot(index='length', columns='batch_size', values='ipc')

    # Get convergence points
    lengths = copift_df.index
    batch_sizes = copift_df.columns
    convergence_points = []
    for x, batch_size in enumerate(batch_sizes):
        for y, length in enumerate(lengths):
            ipc = copift_df.loc[length, batch_size]
            asymptote = copift_df.loc[lengths[-1], batch_size]
            if ipc > 0.995 * asymptote:
                convergence_points.append((x, y))
                break

    # Get optimum points
    lengths = copift_df.index
    batch_sizes = copift_df.columns
    optimum_points = []
    for y, length in enumerate(lengths):
        x_opt = 0
        x_max_val = 0
        for x, batch_size in enumerate(batch_sizes):
            x_val = copift_df.loc[length, batch_size]
            if x_val > x_max_val:
                x_opt = x
                x_max_val = x_val
        optimum_points.append((x_opt, y))

    print(optimum_points)

    # Create the plot
    fig, ax = plt.subplots()
    cmap = mpl.colormaps['plasma']
    cmap = mpl.colors.ListedColormap(cmap(np.linspace(0.15, 0.85, 128)))
    im = ax.pcolor(copift_df, cmap=cmap)
    ax.set_yticks(np.arange(0.5, len(lengths), 1), lengths)
    ax.set_xticks(np.arange(0.5, len(batch_sizes), 1), batch_sizes)
    fig.colorbar(im)
    plt.tight_layout()

    # Annotate convergence points
    for (x, y) in convergence_points:
        if (x, y) not in optimum_points:
            ax.text(x + 0.5, y + 0.5, '>99.5%', ha="center", va="center", color="w")
        else:
            ax.text(x + 0.5, y + 0.5, 'both', ha="center", va="center", color="w")

    # Annotate optimum points
    for (x, y) in optimum_points:
        if (x, y) not in convergence_points:
            ax.text(x + 0.5, y + 0.5, 'peak', ha="center", va="center", color="w")

    # Display the plot
    file = RESULT_DIR / 'plot4.pdf'
    file.parent.mkdir(parents=True, exist_ok=True)
    plt.gcf().set_size_inches(IEEE_COL_WIDTH, 0.099 * A4_HEIGHT)
    plt.gcf().subplots_adjust(
        left=0.12,
        bottom=0.13,
        right=1.05,
        top=1
    )
    plt.savefig(file)


def main():

    experiments = []
    for batch_size in [32, 48, 64, 96, 128, 192, 256]:
        for n_samples in [768, 1536, 3072, 6144, 12288, 24576, 49152, 98304]:
            experiments.append({
                'app': 'pi_estimation',
                'integrand': 'poly',
                'prng': 'lcg',
                'impl': 'optimized',
                'n_cores': 1,
                'n_samples': n_samples,
                'batch_size': batch_size,
            })
            experiments.append({
                'app': 'pi_estimation',
                'integrand': 'poly',
                'prng': 'lcg',
                'impl': 'baseline',
                'n_cores': 1,
                'n_samples': n_samples,
                'batch_size': batch_size,
            })

    manager = CopiftExperimentManager(experiments=experiments)
    manager.run()
    df = manager.get_results()

    # Rename implementations for consistency
    df['impl'] = df['impl'].replace({
        'issr': 'COPIFT',
        'optimized': 'COPIFT',
        'baseline': 'Baseline'
    })

    global_plot_settings()

    fig1(df)


if __name__ == '__main__':
    main()
