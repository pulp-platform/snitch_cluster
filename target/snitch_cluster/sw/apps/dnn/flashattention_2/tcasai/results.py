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
import json5
from mako.template import Template
import math

sys.path.append(str(Path(__file__).parent / '../../../../../util/'))

NR_CORES_PER_CLUSTER = 8
NR_GROUPS = 8

ROI_SPEC = Path.cwd() / 'roi.json.tpl'

EXPERIMENTS = []
for prec in [8, 16, 32]:
    EXPERIMENTS.append({'name': f'fp{prec}-opt-vit-base', 'L': 192, 'S': 192, 'H': 12})
    EXPERIMENTS.append({'name': f'fp{prec}-opt-vit-large', 'L': 192, 'S': 192, 'H': 16})
    EXPERIMENTS.append({'name': f'fp{prec}-opt-vit-huge', 'L': 192, 'S': 192, 'H': 16})
    for S in [128, 256, 512, 1024, 2048]:
        EXPERIMENTS.append({'name': f'fp{prec}-opt-gpt-3-xl-forward-{S}', 'L': S, 'S': S, 'H': 16})
        EXPERIMENTS.append({'name': f'fp{prec}-opt-gpt-j-forward-{S}', 'L': S, 'S': S, 'H': 16})
        EXPERIMENTS.append({'name': f'fp{prec}-opt-gpt-3-xl-inf-{S}', 'L': 1, 'S': S, 'H': 16})
        EXPERIMENTS.append({'name': f'fp{prec}-opt-gpt-j-inf-{S}', 'L': 1, 'S': S, 'H': 16})


class Simulation():

    def __init__(self, sim_dir):
        """Initializes a simulation object from the run directory."""
        self.sim_dir = Path(sim_dir)
        self.roi_spec = Path(self.sim_dir) / 'roi_spec.json'
        self.roi_json = Path(self.sim_dir) / 'logs' / 'roi.json'

    @functools.cached_property
    def performance_data(self):
        """Returns all performance data logged during simulation."""
        with open(self.roi_json, 'r') as f:
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

    def make_perf(self):
        """Build roi.json file for the simulation."""
        subprocess.run(['make', '-C', '../../../../../', f'{self.roi_json}',
                       f'SIM_DIR={self.sim_dir}', f'ROI_SPEC={self.roi_spec}', '-j'], check=True)

    def make_visual_trace(self):
        """Build the visual trace of the simulation."""
        subprocess.run(['make', '-C', '../../../../../', 'visual-trace', f'SIM_DIR={self.sim_dir}',
                       f'ROI_SPEC={self.roi_spec}', '-j'], check=True)


def load_simulation(experiment):
    """Returns the simulation object for a given model."""
    # Fill out ROI spec template with experiment parameters
    # and write to simulation directory
    sim_dir = Path.cwd() / f'runs/flashattention_2-{get_simulation_name(experiment)}'
    with open(ROI_SPEC, 'r') as f:
        spec_template = Template(f.read())
        rendered_spec = spec_template.render(
            T_r=experiment['simulated_Tr'],
            T_c=experiment['simulated_Tc']
        )
        rendered_spec_path = sim_dir / 'roi_spec.json'
        with open(rendered_spec_path, 'w') as of:
            of.write(rendered_spec)
    # Create simulation object
    return Simulation(sim_dir)


def get_total_runtime(experiment):
    # Parameters
    L = experiment['L']
    S = experiment['S']
    Br = experiment['Br']
    Bc = experiment['Bc']
    H = experiment['H']

    # Derived parameters
    Tr = L / Br
    Tc = S / Bc

    # Correct DMA bandwidth by a factor which accounts for contention between
    # clusters in a group (bwcf = bandwidth correction factor).
    # We map each head spatially to a unique cluster.
    bwcf = 1 / math.ceil(H / NR_GROUPS)

    # Define the simulated tc and tr iterations to extract the region runtimes from.
    # The second tc iteration is the worst case, since upon the first iteration
    # several calculations are not performed.
    tc_iteration = 1
    tr_iteration = 0

    # Calculate total runtime
    sim = experiment['sim']
    tc_iter_time = sim.get_metric('hart_8', 'copy K & V', 'cycles', tc_iteration) / bwcf + \
        sim.get_metric('hart_0', 'QxKt', 'cycles', tc_iteration) + \
        sim.get_metric('hart_0', 'softmax', 'cycles', tc_iteration) + \
        sim.get_metric('hart_0', 'PxV', 'cycles', tc_iteration)
    tc_loop_time = tc_iter_time * Tc
    tr_iter_time = sim.get_metric('hart_8', 'copy Q', 'cycles', tr_iteration) / bwcf + \
        sim.get_metric('hart_0', 'init', 'cycles', tr_iteration) + \
        tc_loop_time + \
        sim.get_metric('hart_0', 'rescale', 'cycles', tr_iteration) + \
        sim.get_metric('hart_8', 'copy O', 'cycles', tr_iteration) / bwcf
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
        return (2 * experiment['d'] + 5) * experiment['S'] * 1e-9 * experiment['H']
    else:
        assert experiment['S'] == experiment['L'], 'Unsupported GFLOPs calculation for L!=S'
        return (2 * experiment['d'] + 5) * (experiment['S'] ** 2) * 1e-9 * experiment['H']


def main():
    for experiment in EXPERIMENTS:
        # Read experiment details from cfg file
        populate_from_cfg_file(experiment)
        # Load performance metrics logged by corresponding simulation
        experiment['sim'] = load_simulation(experiment)
        # experiment['sim'].make_perf()
        # experiment['sim'].make_visual_trace()
    for experiment in EXPERIMENTS:
        name = experiment['name']
        time = get_total_runtime(experiment) / 1e9
        GFLOPs = gflop(experiment)
        GFLOPS = GFLOPs/time
        # We are computing the peak performance not based on the total number of clusters
        # in the system but based on the total number of clusters which the network
        # effectively uses, as a measure of the efficiency with which the employed clusters
        # are used.
        peak = 2 * NR_CORES_PER_CLUSTER * get_fpu_width(experiment) * experiment['H']
        util = GFLOPS / peak
        GFLOPS_over_peak_str = f'{int(GFLOPS)}/{int(peak)}'
        print(f'| {name} | {util:.2f} | {time:.2f} | \
              {GFLOPs:.2f} | {GFLOPS:.2f} | {GFLOPS_over_peak_str} |')


if __name__ == '__main__':
    main()
