#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import json5
from mako.template import Template
from pathlib import Path
import plot
import yaml

from snitch.util.sim import sim_utils
from snitch.target.build import build, annotate_traces, build_visual_trace
from snitch.target.run import get_parser, run_simulations, SIMULATORS
from snitch.target.SimResults import SimResults

ACTIONS = ['build', 'run', 'traces', 'visual-trace', 'plot', 'all']
BUILD_DIR = Path('build').absolute()
RUN_DIR = Path('runs').absolute()


def funcptr_axis(funcptr):
    if funcptr == 'calculate_psum_naive':
        return 'naive'
    elif funcptr == 'calculate_psum_baseline':
        return 'baseline'
    elif funcptr == 'calculate_psum_optimized':
        return 'optimized'
    else:
        raise ValueError(f'Unknown function pointer: {funcptr}')


def get_axis(experiments, axis):
    vals = [experiment['axes'][axis] for experiment in experiments]
    return list(dict.fromkeys(vals))


def get_experiment_name(axes):
    return '/'.join([str(val) for val in axes.values()])


def get_experiment_run_dir(axes):
    return RUN_DIR / get_experiment_name(axes)


def get_simulation_results(axes):
    return SimResults(get_experiment_run_dir(axes))


def main():
    # Parse args
    parser = get_parser()
    parser.add_argument('actions', nargs='*', choices=ACTIONS, help='List of actions')
    args = parser.parse_args()

    # Get experiments from experiments file
    experiments_path = Path(args.testlist).absolute()
    with open(experiments_path, 'r') as f:
        experiments = yaml.safe_load(f)['experiments']

    # Fill experiment information
    for experiment in experiments:
        experiment['axes'] = {
            'app': experiment['app'],
            'prng': experiment['prng'],
            'impl': funcptr_axis(experiment['funcptr']),
            'n_cores': experiment['n_cores'],
            'n_samples': experiment['n_samples'],
            'batch_size': experiment['batch_size'],
        }
        experiment['name'] = get_experiment_name(experiment['axes'])
        experiment['elf'] = BUILD_DIR / experiment['name'] / 'pi_estimation.elf'
        experiment['run_dir'] = get_experiment_run_dir(experiment['axes'])

    # Build all experiments
    if 'build' in args.actions or 'all' in args.actions:
        for experiment in experiments:
            defines = {
                'APPLICATION': ('application_' + experiment['app']).upper(),
                'PRNG': ('prng_' + experiment['prng']).upper(),
                'N_SAMPLES': experiment['n_samples'],
                'N_CORES': experiment['n_cores'],
                'FUNC_PTR': experiment['funcptr'],
                'BATCH_SIZE': experiment['batch_size'],
            }
            experiment['build_dir'] = experiment['elf'].parent
            build('pi_estimation', experiment['build_dir'], defines=defines)

    # Run all experiments
    if 'run' in args.actions or 'all' in args.actions:
        simulations = sim_utils.get_simulations(experiments, SIMULATORS[args.simulator], RUN_DIR)
        run_simulations(simulations, args)

    # Annotate traces
    if 'traces' in args.actions or 'all' in args.actions:
        for experiment in experiments:
            annotate_traces(experiment['run_dir'])

    # Build visual traces
    if 'visual-trace' in args.actions or 'all' in args.actions:
        for experiment in experiments:

            # Render ROI specification template
            with open('roi.json', 'r') as f:
                spec = f.read()
            spec_template = Template(spec)
            spec_data = spec_template.render(**experiment)
            spec_data = json5.loads(spec_data)
            rendered_spec = experiment['run_dir'] / 'roi_spec.json'
            with open(rendered_spec, 'w') as f:
                json5.dump(spec_data, f, indent=4)

            # Build visual trace
            build_visual_trace(experiment['run_dir'], rendered_spec)

    # Plot
    if 'plot' in args.actions or 'all' in args.actions:
        plot.main(experiments)


if __name__ == '__main__':
    main()
