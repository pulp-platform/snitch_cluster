#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Viviane Potocnik <vivianep@iis.ee.ethz.ch>

import sys
from pathlib import Path
import numpy as np
import torch
from data.datagen import golden_model

sys.path.append(str(Path(__file__).parent / '../../../util/sim/'))
import verification  # noqa: E402
from elf import Elf  # noqa: E402
from data_utils import bytes_to_float, bytes_to_struct, NUMPY_T, \
                        PRECISION_T  # noqa: E402


ERR_THRESHOLD = 1E-6


def main():
    # Run simulation and get outputs
    args = verification.parse_args()
    raw_results = verification.simulate(sim_bin=args.sim_bin,
                                        snitch_bin=args.snitch_bin,
                                        symbols_bin=args.symbols_bin,
                                        log=args.log,
                                        output_uids=['fusedconv_pOutBuffer_dram'])

    # Extract input operands from ELF file
    if args.symbols_bin:
        elf = Elf(args.symbols_bin)
    else:
        elf = Elf(args.snitch_bin)

    layer_struct = {
        'ch_in': 'I',
        'ch_out': 'I',
        'dim_in_x': 'I',
        'dim_in_y': 'I',
        'dim_kernel_x': 'I',
        'dim_kernel_y': 'I',
        'dim_out_x': 'I',
        'dim_out_y': 'I',
        'padding_y_top': 'I',
        'padding_y_bottom': 'I',
        'padding_x_left': 'I',
        'padding_x_right': 'I',
        'stride_x': 'I',
        'stride_y': 'I',
        'flag_relu': 'I',
        'flag_batch_norm': 'I',
        'depthwise': 'I',
        'chw_layer': 'I',
        'flag_y_accumulate_start': 'I',
        'flag_y_accumulate_end': 'I',
        'pInBuffer': 'I',
        'pWeight': 'I',
        'lambda': 'I',
        'kappa': 'I',
        'pOutBuffer': 'I',
        'pIm2ColBuffer': 'I',
        'memory_chan': 'I',
        'bias': 'I',
        'bias_shift': 'I',
        'out_shift': 'I',
        'out_mult': 'I',
        'dtype': 'I'
    }

    layer = bytes_to_struct(elf.get_symbol_contents('layer'), layer_struct)
    ifmap = [np.array(bytes_to_float(
              elf.get_symbol_contents('fusedconv_pInBuffer_dram'),
              PRECISION_T[layer['dtype']]),
              dtype=NUMPY_T[PRECISION_T[layer['dtype']]])]
    ifmap = torch.from_numpy(
                ifmap[0].reshape(layer['dim_in_y'], layer['dim_in_x'], layer['ch_in']))
    kernel = [np.array(bytes_to_float(
               elf.get_symbol_contents('fusedconv_pWeight_dram'),
               PRECISION_T[layer['dtype']]),
               dtype=NUMPY_T[PRECISION_T[layer['dtype']]])]
    if not layer['depthwise']:
        kernel = torch.from_numpy(
                    kernel[0].reshape(layer['ch_out'], layer['dim_kernel_y'],
                                      layer['dim_kernel_x'], layer['ch_in']))
    else:
        kernel = torch.from_numpy(
                    kernel[0].reshape(layer['dim_kernel_y'], layer['dim_kernel_x'],
                                      layer['ch_out']))

    bn_k = [np.array(bytes_to_float(
            elf.get_symbol_contents('fusedconv_kappa_dram'),
            PRECISION_T[layer['dtype']]),
            dtype=NUMPY_T[PRECISION_T[layer['dtype']]])]
    bn_k = torch.from_numpy(bn_k[0])
    bn_l = [np.array(bytes_to_float(
            elf.get_symbol_contents('fusedconv_lambda_dram'),
            PRECISION_T[layer['dtype']]),
            dtype=NUMPY_T[PRECISION_T[layer['dtype']]])]
    bn_l = torch.from_numpy(bn_l[0])

    flag_y_accumulate_start = layer['flag_y_accumulate_start']

    # Verify results
    output_actual = np.array(bytes_to_float(
                             raw_results['fusedconv_pOutBuffer_dram'],
                             PRECISION_T[layer['dtype']]),
                             dtype=NUMPY_T[PRECISION_T[layer['dtype']]])
    output_golden, _, _ = golden_model(ifmap, kernel,
                                       bn_k, bn_l,
                                       layer,
                                       layer,
                                       layer['flag_batch_norm'],
                                       layer['flag_relu'],
                                       not flag_y_accumulate_start,
                                       layer['depthwise'])
    output_golden = output_golden.detach().numpy().flatten()

    # relative_err = np.absolute((output_golden - output_actual) / output_golden)
    # compute relative error only for non-zero elements
    relative_err = np.zeros_like(output_golden)
    non_zero = output_golden != 0
    zero_idx = np.where(output_golden == 0)
    relative_err[non_zero] = np.absolute((output_golden[non_zero] - output_actual[non_zero])
                                         / output_golden[non_zero])
    relative_err[zero_idx] = np.absolute(output_golden[zero_idx] - output_actual[zero_idx])

    fail = np.any(relative_err > ERR_THRESHOLD)
    if (fail):
        verification.dump_results_to_csv(
                    [output_golden, output_actual, relative_err],
                    Path.cwd() / 'results.csv')
        print('Maximum relative error:', np.max(relative_err))

    return int(fail)


if __name__ == "__main__":
    sys.exit(main())
