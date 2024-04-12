#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

from pathlib import Path
import sys
import subprocess
import functools
import json

sys.path.append(str(Path(__file__).parent / '../../../../../util/'))

ROI_SPEC = Path.cwd() / 'roi.json.tpl'
MODELS = {
    'vit-base': {'N': 192, 'd': 64},
    'vit-large': {'N': 192, 'd': 64},
    'vit-huge': {'N': 192, 'd': 80},
    **{f'gpt-3-xl-forward-{N}': {'N': N, 'd': 128} for N in [128, 256, 512, 1024, 2048]},
    **{f'gpt-j-forward-{N}': {'N': N, 'd': 256} for N in [128, 256, 512, 1024, 2048]},
}


class Simulation():

    def __init__(self, sim_dir):
        """Initializes a simulation object from the run directory."""
        self.sim_dir = sim_dir

    @functools.cached_property
    def performance_data(self):
        """Returns all performance data logged during simulation."""
        roi_json = Path(self.sim_dir) / 'logs' / 'roi.json'
        with open(roi_json, 'r') as f:
            return json.load(f)

    def get_metric(self, thread, region, metric, label_idx=0):
        """Get a specific performance metric from a certain simulation run.

        Args:
            data: All performance metric data as returned by
                `get_performance_data()`.
            thread: The thread to extract the metric from.
            region: The region to extract the metric from. Can be an integer
                index or the label assigned to the region. In case of multiple
                regions with the same label (as e.g. in a loop) you can get
                the n-th occurrence by passing a value to `label_idx`.
            metric: The name of the metric to extract.
            label_idx: See description for `region`.
        """
        # Retrieve region index if supplied `region` argument is a region label.
        reg_idx = None
        if isinstance(region, str):
            cnt = 0
            for i, reg in enumerate(self.performance_data[thread]):
                if reg['label'] == region:
                    if cnt == label_idx:
                        reg_idx = i
                        break
                    else:
                        cnt += 1
        elif isinstance(region, int):
            reg_idx = region
        else:
            raise ValueError('region argument must be of type int or str')
        # Get metric
        return self.performance_data[thread][reg_idx]['attrs'][metric]

    def build_visual_trace(self):
        """Build the visual trace of the simulation."""
        subprocess.run(['make', '-C', '../../../../../', 'visual-trace',
                        f'SIM_DIR={self.sim_dir}',
                        f'ROI_SPEC={ROI_SPEC}', '-j'], check=True)


def load_simulation(model):
    """Returns the simulation object for a given model."""
    return Simulation(Path.cwd() / f'runs/flashattention_2-fp32-opt-{model}')


def get_total_runtime(sim, model):
    # Parameters
    N = MODELS[model]['N']
    Br = 16
    Bc = 64

    # Derived parameters
    Tr = N / Br
    Tc = N / Bc

    # Calculate total runtime
    tc_iter_time = sim.get_metric('hart_8', 'copy K & V', 'cycles') + \
        sim.get_metric('hart_0', 'QxKt', 'cycles') + \
        sim.get_metric('hart_0', 'softmax', 'cycles') + \
        sim.get_metric('hart_0', 'PxV', 'cycles')
    tc_loop_time = tc_iter_time * Tc
    tr_iter_time = sim.get_metric('hart_8', 'copy Q', 'cycles') + \
        sim.get_metric('hart_0', 'init', 'cycles') + \
        tc_loop_time + \
        sim.get_metric('hart_0', 'rescale', 'cycles') + \
        sim.get_metric('hart_0', 'rescale', 'cycles')
    total_time = tr_iter_time * Tr
    return total_time


def main():

    sim = load_simulation('vit-base')
    sim.build_visual_trace()

    for model in MODELS:
        print(f'{model}:')
        total_time = get_total_runtime(sim, model)
        print(f'\tTotal time: {total_time / 10e9}s')


if __name__ == '__main__':
    main()
