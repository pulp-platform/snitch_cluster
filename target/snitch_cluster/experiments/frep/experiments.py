#!/usr/bin/env python3
# Copyright 2025 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

from copy import deepcopy
from snitch.target.SimResults import SimRegion
from snitch.target.experiment_utils import ExperimentManager
import random

from mako.template import Template
from pathlib import Path

NUM_GEMM_SIZES = 50
HW_CFGS = [
    'base32fc',
    'zonl32fc',
    'zonl64fc',
    'zonl64dobu',
    'zonl48dobu',
]
NUM_TILES = 3
ROI = 'tile_1'

POWER_GROUPS = {
    'muldiv': '*i_snitch_shared_muldiv',
    'cc': '*i_snitch_cc',
    'fpu': '*i_snitch_fp_ss_i_fpu',
    'fpu_8': 'i_cluster_gen_core_8__i_snitch_cc/gen_fpu_i_snitch_fp_ss_i_fpu',
    'dma': '*i_idma_inst64*',
    'icache': '*i_snitch_icache*',
    'tcdm': '*i_data_mem*',
    'dma_xbar': '*i_axi_dma_xbar',
    'zero_mem': '*i_axi_zeromem',
}

AREA_GROUPS = {
    'muldiv': '*i_snitch_shared_muldiv',
    'cc': '*i_snitch_cc',
    # '*i_snitch_cc',
    'fpu': '*i_snitch_fp_ss_i_fpu',
    'fpu_8': 'i_cluster_gen_core_8__i_snitch_cc/gen_fpu_i_snitch_fp_ss_i_fpu',
    'dma': '*i_idma_inst64*',
    'icache': '*i_snitch_icache*',
    'tcdm': '*i_data_mem*',
    'dma_xbar': '*i_axi_dma_xbar',
    'zero_mem': '*i_axi_zeromem',
}


VSIM_BINS = {
    'base32fc':   str(Path.cwd() / 'hw/base32fc/bin/snitch_cluster.vsim'),
    'zonl32fc':   str(Path.cwd() / 'hw/zonl32fc/bin/snitch_cluster.vsim'),
    'zonl64fc':   str(Path.cwd() / 'hw/zonl64fc/bin/snitch_cluster.vsim'),
    'zonl64dobu': str(Path.cwd() / 'hw/zonl64dobu/bin/snitch_cluster.vsim'),
    'zonl48dobu': str(Path.cwd() / 'hw/zonl48dobu/bin/snitch_cluster.vsim'),
}
DATA_DIR = Path('data').absolute()
VERIFY_PY = Path('../../../../sw/blas/gemm/scripts/verify.py').absolute()


class FrepExperimentManager(ExperimentManager):

    def derive_axes(self, experiment):
        return {
            'hw': experiment['hw'],
            'm': experiment['m'],
            'n': experiment['n'],
            'k': experiment['k'],
        }

    def derive_data_cfg(self, experiment):
        # Create parent directory for configuration file
        cfg_path = DATA_DIR / experiment['name'] / 'cfg.json'
        cfg_path.parent.mkdir(parents=True, exist_ok=True)

        # Fill in configuration template and write configuration file
        with open('cfg.json.tpl') as f:
            cfg = Template(f.read()).render(experiment=experiment)
        with open(cfg_path, 'w') as f:
            f.write(cfg)
        return cfg_path

    def derive_hw_cfg(self, experiment):
        return Path.cwd() / 'cfg' / f'{experiment["hw"]}.json'


def generate_mat_size():
    sizes = list(range(8, 257, 8))
    return random.choice(sizes)


def calculate_total_size(m, n, k):
    prec = 8
    a_size = m * k * prec
    b_size = k * n * prec
    c_size = m * n * prec
    return 2 * (a_size + b_size + c_size)


def gen_experiments():
    # new layout requires checking that individual matrices fit in 8banks
    BANK_SIZE = 1 * 1024  # 2KiB
    MAX_ALLOWED_SIZE = 8 * BANK_SIZE  # Every matrix can take up maximum 8 banks

    unique_experiments = set()
    while len(unique_experiments) < NUM_GEMM_SIZES:
        # generate random values in [8, 16, 24, ..., 256] for m, n, k
        m = generate_mat_size()
        n = generate_mat_size()
        k = generate_mat_size()

        # check if the matrices fit in TCDM
        # new layout requires checking that individual matrices fit in 8banks
        prec = 8
        a_size = m * k * prec
        b_size = k * n * prec
        c_size = m * n * prec
        max_size = max(a_size, b_size, c_size)

        if max_size <= MAX_ALLOWED_SIZE:
            experiment = (m, n, k)
            if experiment not in unique_experiments:
                unique_experiments.add((m, n, k))

    experiments = [{'m': experiment[0], 'n': experiment[1], 'k': experiment[2]}
                   for experiment in unique_experiments]
    return experiments


def get_average_fpu_util(row):
    util = []
    for i in range(0, 8):
        util.append(row['results'].get_metric(SimRegion(f'hart_{i}', ROI), 'fpss_fpu_occupancy'))
    return sum(util) / len(util)


def get_area(row, key):
    return row['area_results'].qor_area[key]


def get_area_component(row, val):
    df = row['area_groups']
    return df[df['name'] == val]['area'].item()


def get_power_component(breakdown, pattern):
    return breakdown[breakdown['name'] == pattern]['total_power'].item()


def main():

    seed = 31

    random.seed(seed)

    # m, n and k are the dimensions of the tile
    experiments = gen_experiments()
    experiments = [deepcopy(exp) for _ in range(len(HW_CFGS)) for exp in experiments]

    for i in range(len(HW_CFGS)):
        for j in range(NUM_GEMM_SIZES):
            k = i * NUM_GEMM_SIZES + j
            experiments[k]['hw'] = HW_CFGS[i]
            experiments[k]['app'] = 'gemm'
            experiments[k]['m_tiles'] = NUM_TILES
            experiments[k]['n_tiles'] = 1
            experiments[k]['cmd'] = [str(VERIFY_PY), VSIM_BINS[HW_CFGS[i]], "${elf}"]

    manager = FrepExperimentManager(experiments)
    manager.run()
    manager.export_power_experiments(SimRegion('hart_0', ROI))

    df = manager.get_results()

    if manager.perf_results_available:
        df['fpu_util'] = df.apply(get_average_fpu_util, axis=1)
        df.drop(labels=['results'], inplace=True, axis=1)

    if manager.power_results_available:
        df['total_power'] = df.apply(lambda row: row['power_results'].total_power, axis=1)
        df['clock_power'] = df.apply(lambda row: row['power_results'].clock_power, axis=1)
        breakdowns = df['power_results'].apply(
            lambda results: results.group_power_breakdown(POWER_GROUPS.values()))
        for key, val in POWER_GROUPS.items():
            df[key] = breakdowns.apply(lambda breakdown: get_power_component(breakdown, val))
        df.drop(labels=['power_results'], inplace=True, axis=1)

    df_area = manager.get_area_results()
    if manager.area_results_available:
        for key in ['tot_area', 'comb_area', 'seq_area', 'macro_area', 'bufinv_area', 'net_len']:
            df_area[key] = df_area.apply(lambda row: get_area(row, key), axis=1)

        df_area['area_groups'] = df_area.apply(
            lambda row: row['area_results'].group_area_breakdown(AREA_GROUPS.values()), axis=1)
        for key, val in AREA_GROUPS.items():
            df_area[key] = df_area.apply(lambda row: get_area_component(row, val), axis=1)

        df_area.drop(labels=['area_results', 'area_groups'], inplace=True, axis=1)
        df_area.to_csv('area.csv', index=False)

    # Export results to file
    print(df)
    print(df_area)
    df.to_csv('results.csv', index=False)


if __name__ == '__main__':
    main()
