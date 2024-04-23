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

EXPERIMENTS = []
for prec in [8, 16, 32]:
    EXPERIMENTS.append({'name': f'fp{prec}-opt-vit-base', 'L': 192, 'S': 192})
    EXPERIMENTS.append({'name': f'fp{prec}-opt-vit-large', 'L': 192, 'S': 192})
    EXPERIMENTS.append({'name': f'fp{prec}-opt-vit-huge', 'L': 192, 'S': 192})
    for S in [128, 256, 512, 1024, 2048]:
        EXPERIMENTS.append({'name': f'fp{prec}-opt-gpt-3-xl-forward-{S}', 'L': S, 'S': S})
        EXPERIMENTS.append({'name': f'fp{prec}-opt-gpt-j-forward-{S}', 'L': S, 'S': S})
        EXPERIMENTS.append({'name': f'fp{prec}-opt-gpt-3-xl-inf-{S}', 'L': 1, 'S': S})
        EXPERIMENTS.append({'name': f'fp{prec}-opt-gpt-j-inf-{S}', 'L': 1, 'S': S})


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
    L = experiment['L']
    S = experiment['S']
    Br = experiment['Br']
    Bc = experiment['Bc']

    # Derived parameters
    Tr = L / Br
    Tc = S / Bc

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


def get_model(experiment):
    name = experiment['name']
    if any(model in name for model in ['vit-base', 'vit-large']):
        return 'vit-base'
    elif 'vit-huge' in name:
        return 'vit-huge'
    elif 'gpt-j-inf' in name:
        return 'gpt-j-inf'
    elif 'gpt-3-xl-inf' in name:
        return 'gpt-3-xl-inf'
    elif 'gpt-j' in name:
        return 'gpt-j'
    elif 'gpt-3-xl' in name:
        return 'gpt-3-xl'
    else:
        raise ValueError(f'Experiment {name} uses an unsupported model')


def get_implementation(experiment):
    name = experiment['name']
    if 'fp32-opt' in name:
        return 'fp32-opt'
    elif 'fp16-opt' in name:
        return 'fp16-opt'
    elif 'fp8-opt' in name:
        return 'fp8-opt'
    else:
        raise ValueError(f'Experiment {name} uses an unsupported implementation')


def get_fpu_width(experiment):
    name = experiment['name']
    if 'fp32' in name:
        return 2
    elif 'fp16' in name:
        return 4
    elif 'fp8' in name:
        return 8
    else:
        raise ValueError(f'Experiment {name} uses an unsupported implementation')


def get_simulation_name(experiment):
    return f'{get_implementation(experiment)}-{get_model(experiment)}'


def populate_from_cfg_file(experiment):
    cfg_file = Path.cwd() / 'cfg' / f'{get_simulation_name(experiment)}.json'
    with open(cfg_file, 'r') as f:
        cfg = json5.load(f)
        experiment['Br'] = cfg['B_r']
        experiment['Bc'] = cfg['B_c']
        experiment['d'] = cfg['d']
        experiment['simulated_L'] = cfg['L']
        experiment['simulated_S'] = cfg['S']
        experiment['simulated_Tr'] = int(experiment['simulated_L'] / experiment['Br'])
        experiment['simulated_Tc'] = int(experiment['simulated_S'] / experiment['Bc'])


def gflop(experiment):
    if 'inf' in experiment['name']:
        return (2 * experiment['d'] + 5) * experiment['S'] * 10e-9
    else:
        assert experiment['S'] == experiment['L'], 'Unsupported GFLOPs calculation for L!=S'
        return (2 * experiment['d'] + 5) * (experiment['S'] ** 2) * 10e-9


def main():
    for experiment in EXPERIMENTS:
        # Read experiment details from cfg file
        populate_from_cfg_file(experiment)
        # Load performance metrics logged by corresponding simulation
        experiment['sim'] = load_simulation(experiment)
        # experiment['sim'].make_perf()
    for experiment in EXPERIMENTS:
        name = experiment['name']
        time = get_total_runtime(experiment) / 10e9
        GFLOPs = gflop(experiment)
        GFLOPS = GFLOPs/time
        peak = 8 * get_fpu_width(experiment)
        util = GFLOPS / peak
        print(f'{name}:')
        print(f'\t{"GFLOPs":<30} {GFLOPs:>10.3f}')
        print(f'\t{"Total time [ms]":<30} {time * 1000:>10.3f}')
        print(f'\t{"GFLOPS":<30} {GFLOPS:>10.3f}')
        print(f'\t{"Utilization":<30} {util:>10.3f}')


if __name__ == '__main__':
    main()
