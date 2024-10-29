#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>
"""Convenience functions to run software experiments in RTL simulation.
"""

from copy import deepcopy
import json5
from mako.template import Template
import pandas as pd
from pathlib import Path
from snitch.target.SimResults import SimResults
from snitch.target import run, build, common
from snitch.util.sim import sim_utils
from termcolor import colored
import yaml

ACTIONS = ['sw', 'run', 'traces', 'annotate', 'perf', 'visual-trace', 'power', 'all', 'none']
SNITCH_ROOT = Path(__file__).parent.parent.parent.parent


class ExperimentManager:

    def __init__(self, experiments=None, actions=None):
        """Initializes the class from the command-line arguments."""
        self.args = self.parser().parse_args()
        if actions is not None:
            self.actions = actions
        else:
            self.actions = self.args.actions

        # Save directory
        self.dir = Path.cwd()
        self.run_dir = self.dir / self.args.run_dir

        # Get experiments
        if experiments is not None:
            self.experiments = experiments
        else:
            experiments_path = Path(self.args.testlist).absolute()
            with open(experiments_path, 'r') as f:
                self.yaml = yaml.safe_load(f)

            self.experiments = deepcopy(self.yaml['experiments'])

        # Derive experiment information
        for experiment in self.experiments:
            self.derive_experiment_info(experiment)

    def parser(self):
        parser = run.get_parser()
        parser.add_argument('actions', nargs='*', default='none', choices=ACTIONS, help='List of actions')
        return parser

    def derive_axes(self, experiment):
        return experiment.copy()

    def derive_name(self, experiment):
        return '/'.join([str(val) for val in experiment['axes'].values()])

    def derive_elf(self, experiment):
        return self.dir / 'build' / experiment['name'] / (experiment['app'] + '.elf')

    def derive_dir(self, base, experiment):
        return base / experiment['name']

    def derive_env(self, experiment):
        return None

    def derive_experiment_info(self, experiment):
        experiment['axes'] = self.derive_axes(experiment)
        experiment['name'] = self.derive_name(experiment)
        experiment['elf'] = self.derive_elf(experiment)
        experiment['run_dir'] = self.derive_dir(self.run_dir, experiment)

    def derive_cdefines(self, experiment):
        return {}

    def run(self):
        # Build software
        if 'sw' in self.actions or 'all' in self.actions:
            for experiment in self.experiments:
                defines = self.derive_cdefines(experiment)
                build.build(experiment['app'], experiment['elf'].parent, defines=defines)

        # Run experiments
        if 'run' in self.actions or 'all' in self.actions:
            simulations = sim_utils.get_simulations(
                self.experiments,
                run.SIMULATORS[self.args.simulator],
                self.run_dir
            )
            for i, experiment in enumerate(self.experiments):
                simulations[i].env = self.derive_env(experiment)
            run.run_simulations(simulations, self.args)

        # Generate traces
        if 'traces' in self.actions or 'all' in self.actions:
            for experiment in self.experiments:
                print(colored('Generate traces', 'black', attrs=['bold']),
                    colored(experiment['run_dir'], 'cyan', attrs=['bold']))
                vars = {'SIM_DIR': experiment['run_dir']}
                flags = ['-j']
                common.make('traces', vars, flags=flags)

        # Annotate traces
        if 'annotate' in self.actions or 'all' in self.actions:
            for experiment in self.experiments:
                build.annotate_traces(experiment['run_dir'])

        # Generate joint performance dump
        if 'perf' in self.actions or 'all' in self.actions:
            processes = []
            for experiment in self.experiments:
                print(
                    colored('Generate performance dump', 'black', attrs=['bold']),
                    colored(experiment['run_dir'], 'cyan', attrs=['bold'])
                )
                vars = {'SIM_DIR': experiment['run_dir']}
                flags = ['-j']
                process = common.make('perf', vars, flags=flags, sync=False)
                processes.append(process)

            # Wait for all processes to complete
            for i, process in enumerate(processes):
                return_code = process.wait()
                if return_code != 0:
                    raise Exception(f'Failed to generate performance dump for experiment {i}')

        # Build visual traces
        if 'visual-trace' in self.actions or 'all' in self.actions:

            # Check for existence of a ROI specification
            roi = self.dir / 'roi.json'
            if roi.exists():
                for experiment in self.experiments:

                    # Render ROI specification template
                    with open(spec, 'r') as f:
                        spec = f.read()
                    spec_template = Template(spec)
                    spec_data = spec_template.render(**experiment['axes'])
                    spec_data = json5.loads(spec_data)
                    rendered_spec = self.run_dir / 'roi_spec.json'
                    with open(rendered_spec, 'w') as f:
                        json5.dump(spec_data, f, indent=4)

                    # Build visual trace
                    build.build_visual_trace(self.run_dir, rendered_spec)

        # Generate joint performance dump
        if 'power' in self.actions or 'all' in self.actions:
            processes = []
            for experiment in self.experiments:
                power_dir = self.derive_dir(self.dir / 'power', experiment)
                print(
                    colored('Estimate power', 'black', attrs=['bold']),
                    colored(power_dir, 'cyan', attrs=['bold'])
                )
                vars = {
                    'SIM_DIR': experiment['run_dir'],
                    'POWER_REPDIR': power_dir
                }
                dir = SNITCH_ROOT / 'nonfree'
                process = common.make('power', vars, dir=dir, sync=False)
                processes.append(process)

            # Wait for all processes to complete
            for i, process in enumerate(processes):
                return_code = process.wait()
                if return_code != 0:
                    raise Exception(f'Failed to estimate power for experiment {i}')

    def get_results(self, source=None):
        """Returns a DataFrame of SimResults objects."""

        # Create the DataFrame
        df = pd.DataFrame(self.experiments)

        # Create SimResults objects from 'run_dir' column
        results = df['run_dir'].apply(lambda run_dir: SimResults(run_dir, source=source))
        results.rename('results', inplace=True)

        # Expand the 'axes' column into separate columns
        axes = df['axes'].apply(pd.Series)

        # Combine 'axes' and 'results' into a new DataFrame
        df = pd.concat([axes, results], axis=1)

        # If desired, reset the index
        df = df.reset_index(drop=True)

        return df
