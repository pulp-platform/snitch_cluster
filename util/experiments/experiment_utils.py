#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>
"""Convenience functions to run software experiments in RTL simulation.
"""

from concurrent.futures import ThreadPoolExecutor, as_completed
from copy import deepcopy
import json5
import mako
import pandas as pd
from pathlib import Path
from snitch.util.experiments.SimResults import SimResults
from snitch.util.experiments import run, build, common
from snitch.util.sim import sim_utils
import sys
from termcolor import colored
import yaml

# Try importing PowerResults module (not available in open-source repo)
try:
    from snitch.nonfree.PowerResults import PowerResults
except ImportError as e:
    print(f'{e}. Power results will not be available.')

# Try importing AreaResults module (not available in open-source repo)
try:
    from snitch.nonfree.AreaResults import AreaResults
except ImportError as e:
    print(f'{e}. Area results will not be available.')


ACTIONS = ['sw', 'hw', 'run', 'traces', 'annotate', 'perf', 'visual-trace', 'power', 'all', 'none']
SNITCH_ROOT = Path(__file__).parent.parent.parent.parent


class ExperimentManager:

    def __init__(self, experiments=None, actions=None, args=None):
        """Initializes the class from the command-line arguments."""
        if args is not None:
            self.args = args
        else:
            self.args = self.parser().parse_args()
        if actions is not None:
            self.actions = actions
        else:
            self.actions = self.args.actions

        # Save directory
        self.dir = Path.cwd()
        self.run_dir = self.dir / self.args.run_dir
        self.power_dir = self.dir / 'power'
        self.area_dir = self.dir / 'area'

        # Get experiments
        if self.args.testlist is not None:
            experiments_path = Path(self.args.testlist).absolute()
            with open(experiments_path, 'r') as f:
                self.yaml = yaml.safe_load(f)

            self.experiments = deepcopy(self.yaml['experiments'])
        elif experiments is not None:
            self.experiments = experiments
            self.yaml = {'experiments': deepcopy(self.experiments)}
        else:
            raise ValueError('No experiments provided.')

        # Derive experiment information
        for experiment in self.experiments:
            self.derive_experiment_info(experiment)

    @staticmethod
    def parser():
        parser = run.get_parser()
        parser.add_argument('--actions', nargs='+', default='none', choices=ACTIONS,
                            help='List of actions')
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
        vars = {}
        if 'vcd_start' in experiment:
            vars['VCD_START'] = str(experiment['vcd_start'])
        if 'vcd_end' in experiment:
            vars['VCD_END'] = str(experiment['vcd_end'])
        return common.extend_environment(vars)

    def derive_experiment_info(self, experiment):
        experiment['axes'] = self.derive_axes(experiment)
        experiment['name'] = self.derive_name(experiment)
        experiment['elf'] = self.derive_elf(experiment)
        experiment['run_dir'] = self.derive_dir(self.run_dir, experiment)
        experiment['power_dir'] = self.derive_dir(self.power_dir, experiment)
        experiment['area_dir'] = self.derive_dir(self.area_dir, experiment)

    def derive_cdefines(self, experiment):
        return {}

    def derive_data_cfg(self, experiment):
        return None

    def derive_hw_cfg(self, experiment):
        return None

    def derive_hw_bin(self, experiment):
        return self.dir / 'hw' / experiment['hw'] / 'bin/snitch_cluster.vsim'

    def derive_vsim_builddir(self, experiment):
        return self.dir / 'hw' / experiment['hw'] / 'work-vsim'

    def run(self):

        dry_run = self.args.dry_run
        n_procs = self.args.n_procs
        experiments = self.experiments

        # Build hardware
        if 'hw' in self.actions or 'all' in self.actions:
            for experiment in experiments:
                bin = self.derive_hw_bin(experiment)
                print(colored('Generate hardware', 'black', attrs=['bold']),
                      colored(bin, 'cyan', attrs=['bold']))
                vars = {
                    'SN_BIN_DIR': bin.parent,
                    'VSIM_BUILDDIR': self.derive_vsim_builddir(experiment),
                    'CFG_OVERRIDE': self.derive_hw_cfg(experiment),
                    'DEBUG': 'ON'
                }
                flags = ['-j']
                common.make(bin, vars, flags=flags, dry_run=dry_run)

        # Build software
        if 'sw' in self.actions or 'all' in self.actions:
            for experiment in experiments:
                defines = self.derive_cdefines(experiment)
                data_cfg = self.derive_data_cfg(experiment)
                hw_cfg = self.derive_hw_cfg(experiment)
                build.build(experiment['app'], experiment['elf'].parent, defines=defines,
                            data_cfg=data_cfg, hw_cfg=hw_cfg)

        # Run experiments
        if 'run' in self.actions or 'all' in self.actions:
            simulations = sim_utils.get_simulations(
                experiments,
                run.SIMULATORS[self.args.simulator],
                self.run_dir
            )
            for i, experiment in enumerate(experiments):
                simulations[i].env = self.derive_env(experiment)
            failed_sims = run.run_simulations(simulations, self.args)
            if failed_sims > 0:
                sys.exit(failed_sims)

        # Generate traces
        if 'traces' in self.actions or 'all' in self.actions:
            for experiment in experiments:
                print(colored('Generate traces', 'black', attrs=['bold']),
                      colored(experiment['run_dir'], 'cyan', attrs=['bold']))
                vars = {'SIM_DIR': experiment['run_dir']}
                if self.args.n_procs:
                    flags = ['-j', self.args.n_procs]
                common.make('traces', vars, flags=flags)

        # Annotate traces
        if 'annotate' in self.actions or 'all' in self.actions:
            for experiment in experiments:
                build.annotate_traces(experiment['run_dir'])

        # Generate joint performance dump
        if 'perf' in self.actions or 'all' in self.actions:
            processes = []
            for experiment in experiments:
                print(
                    colored('Generate performance dump', 'black', attrs=['bold']),
                    colored(experiment['run_dir'], 'cyan', attrs=['bold'])
                )
                vars = {'SIM_DIR': experiment['run_dir']}
                if self.args.n_procs:
                    flags = ['-j', self.args.n_procs]
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
            roi = self.dir / 'roi.json.tpl'
            if roi.exists():
                for experiment in experiments:

                    # Render ROI specification template
                    with open(roi, 'r') as f:
                        spec = f.read()
                    spec_template = mako.template.Template(spec)
                    try:
                        spec_data = spec_template.render(experiment=experiment)
                    except Exception:
                        print(mako.exceptions.text_error_template().render())
                    spec_data = json5.loads(spec_data)
                    rendered_spec = experiment['run_dir'] / 'roi_spec.json'
                    # Only write to the file if it does not exist.
                    # Ensures that rerunning visual-trace doesn't rerun the
                    # make targets if the simulations were not rerun.
                    if not rendered_spec.exists():
                        with open(rendered_spec, 'w') as f:
                            json5.dump(spec_data, f, indent=4)

                    # Build visual trace
                    hw_cfg = self.derive_hw_cfg(experiment)
                    build.build_visual_trace(experiment['run_dir'], rendered_spec,
                                             hw_cfg=hw_cfg)

        # Generate joint performance dump
        if 'power' in self.actions or 'all' in self.actions:
            def run_power(experiment):
                print(
                    colored('Estimate power', 'black', attrs=['bold']),
                    colored(experiment['power_dir'], 'cyan', attrs=['bold'])
                )
                vars = {
                    'SIM_DIR': experiment['run_dir'],
                    'POWER_REPDIR': experiment['power_dir']
                }
                dir = SNITCH_ROOT / 'nonfree'
                return common.make('power', vars, dir=dir, dry_run=dry_run)

            with ThreadPoolExecutor(max_workers=n_procs) as executor:
                futures = [executor.submit(run_power, exp) for exp in experiments]
                for i, future in enumerate(as_completed(futures)):
                    return_code = future.result().returncode
                    if return_code != 0:
                        raise Exception(
                            colored('Power estimation of ', 'red', attrs=['bold']),
                            colored(f'{experiments[i]["name"]}', 'black', attrs=['bold']),
                            colored(' failed.', 'red', attrs=['bold'])
                        )
                    else:
                        print(
                            colored('Power estimation of ', 'green', attrs=['bold']),
                            colored(f'{experiments[i]["name"]}', 'black', attrs=['bold']),
                            colored(' finished.', 'green', attrs=['bold'])
                        )

    def export_experiments(self, path='experiments.yaml'):
        # Save power experiments to a YAML file
        with open(path, 'w') as f:
            yaml.dump(self.yaml, f, sort_keys=False)

    def export_power_experiments(self, start_region, end_region=None, path='power.yaml'):
        # Extract VCD intervals
        df = self.get_results()
        if self.perf_results_available:
            vcd_interval = df.apply(
                lambda row: row['results'].get_interval(start_region, end_region),
                axis=1
            )
        else:
            raise ValueError('Cannot export VCD intervals without performance results.')

        # Extend experiments with VCD intervals
        for i, experiment in enumerate(self.yaml['experiments']):
            vcd_start, vcd_end = vcd_interval.iloc[i]
            experiment['vcd_start'] = vcd_start
            experiment['vcd_end'] = vcd_end

        # Save power experiments to a YAML file
        with open(path, 'w') as f:
            yaml.dump(self.yaml, f, sort_keys=False)

    def get_results(self, source=None):
        """Returns a DataFrame of SimResults objects."""

        # Initialize flags
        self.perf_results_available = False
        self.power_results_available = False
        self.area_results_available = False

        # Create the DataFrame
        df = pd.DataFrame(self.experiments)

        # Expand the 'axes' column into separate columns
        axes = df['axes'].apply(pd.Series)

        # Create SimResults objects from 'run_dir' column
        try:
            results = df['run_dir'].apply(lambda run_dir: SimResults(run_dir, source=source))
            results.rename('results', inplace=True)
            self.perf_results_available = True
        except FileNotFoundError:
            print('Performance results not available.')

        # Create PowerResults objects
        if 'PowerResults' in globals():
            try:
                power_results = df['power_dir'].apply(lambda power_dir: PowerResults(power_dir))
                power_results.rename('power_results', inplace=True)
                self.power_results_available = True
            except FileNotFoundError:
                print('Power results not available.')

        # Combine experiment axes and results into a new DataFrame
        columns = [axes]
        if self.perf_results_available:
            columns.append(results)
        if self.power_results_available:
            columns.append(power_results)
        df = pd.concat(columns, axis=1)

        # If desired, reset the index
        df = df.reset_index(drop=True)

        return df

    def get_area_results(self):
        """Returns a DataFrame of AreaResults objects."""

        # Initialize flags
        self.area_results_available = False

        # Create the DataFrame
        df = pd.DataFrame(self.experiments)

        # Expand the 'axes' column into separate columns
        axes = df['axes'].apply(pd.Series)
        hw_cfg = pd.Series(axes['hw'].unique(),  name="cfg")

        # Create AreaResults objects
        if 'AreaResults' in globals():
            try:
                area_results = hw_cfg.apply(lambda cfg: AreaResults(f'./area/{cfg}'))
                area_results.rename('area_results', inplace=True)
                self.area_results_available = True
            except FileNotFoundError:
                print('Area results not available.')

        # Combine cfg axis and results into a new DataFrame
        columns = [hw_cfg]
        if self.area_results_available:
            columns.append(area_results)
        df = pd.concat(columns, axis=1)

        return df
