#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Viviane Potocnik <vivianep@iis.ee.ethz.ch>
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import argparse
import numpy as np
import pathlib
import json5
import sys
import os
import torch

sys.path.append(os.path.join(os.path.dirname(__file__), "../../../../util/sim/"))
import data_utils  # noqa: E402
from data_utils import emit_license, \
                       format_struct_definition, format_array_definition, \
                       format_array_declaration, format_ifdef_wrapper  # noqa: E402

torch.manual_seed(42)

# AXI splits bursts crossing 4KB address boundaries. To minimize
# the occurrence of these splits the data should be aligned to 4KB
BURST_ALIGNMENT = 4096


def torch_golden_model(Q, K, V):
    return torch.nn.functional.scaled_dot_product_attention(Q, K, V)


def exact_golden_model(Q, K, V, B_r, B_c):
    # Convert torch tensors to numpy arrays
    Q = Q.numpy()
    K = K.numpy()
    V = V.numpy()
    # Get layer dimensions
    N = Q.shape[0]
    # Calculate tiling parameters
    T_r = N // B_r
    T_c = N // B_c
    # Transpose K
    K_t = np.transpose(K)
    # Iterate tiles
    O_tiles = []
    for i in range(T_r):
        # Tile Q
        start_row = i * B_r
        end_row = start_row + B_r
        Q_i = Q[start_row:end_row, :]
        # Initialize l_i, m_i, O_i
        m_i = np.full((B_r, 1), -np.inf)
        for j in range(T_c):
            # Tile K_t and V
            start_col = j * B_c
            end_col = start_col + B_c
            K_t_j = K_t[:, start_col:end_col]
            V_j = V[start_col:end_col, ]
            # Compute O tile update
            S_ij = np.matmul(Q_i, K_t_j)
            m_i_prev = m_i
            m_i = np.maximum(m_i_prev, np.max(S_ij, 1, keepdims=True))
            shifted_exp = np.exp(m_i_prev - m_i)
            P_ij = np.exp(S_ij - m_i)
            PxV = np.matmul(P_ij, V_j)
            if j == 0:
                l_i = np.sum(P_ij, 1, keepdims=True)
                O_i = PxV
            else:
                l_i = (shifted_exp * l_i) + np.sum(P_ij, 1, keepdims=True)
                diag = np.diag(shifted_exp[:, 0])
                diag_inv = np.linalg.inv(diag)
                O_i = np.matmul(diag_inv, O_i)
                O_i += PxV
        # Finalize O tile
        diag_l_i = np.diag(l_i[:, 0])
        diag_l_inv_i = np.linalg.inv(diag_l_i)
        O_i = np.matmul(diag_l_inv_i, O_i)
        O_tiles.append(O_i)
    return np.concatenate(O_tiles, 0)


def emit_header(section, params):
    N = params['N']
    d = params['d']
    B_r = params['B_r']
    B_c = params['B_c']
    prec = params['dtype']

    # Verify layer parameters are valid
    assert (N % B_r) == 0, 'N is not an integer multiple of B_r'
    assert (N % B_c) == 0, 'N is not an integer multiple of B_c'
    assert (B_r % 8) == 0, 'B_r must be an integer multiple of the number of cores in a cluster'

    torch_type = data_utils.torch_type_from_precision_t(prec)
    ctype = data_utils.ctype_from_precision_t(prec)

    Q = 2 * torch.rand(N, d, requires_grad=False, dtype=torch_type) - 1
    K = 2 * torch.rand(N, d, requires_grad=False, dtype=torch_type) - 1
    V = 2 * torch.rand(N, d, requires_grad=False, dtype=torch_type) - 1

    output = exact_golden_model(Q, K, V, B_r, B_c)

    q_uid = 'Q'
    k_uid = 'K'
    v_uid = 'V'
    o_uid = 'O'

    layer_cfg = {
        **params,
        'Q': q_uid,
        'K': k_uid,
        'V': v_uid,
        'O': o_uid,
    }

    data_str = [emit_license()]
    data_str += [format_array_declaration(ctype, q_uid, Q.shape)]
    data_str += [format_array_declaration(ctype, k_uid, K.shape)]
    data_str += [format_array_declaration(ctype, v_uid, V.shape)]
    data_str += [format_array_declaration(ctype, o_uid, output.shape)]
    data_str += [format_struct_definition('flashattention_2_layer_t', 'layer', layer_cfg)]
    data_str += [format_array_definition(ctype, q_uid, Q)]
    data_str += [format_array_definition(ctype, k_uid, K)]
    data_str += [format_array_definition(ctype, v_uid, V)]
    result_def = format_array_definition(ctype, 'golden', output)
    data_str += [format_ifdef_wrapper('BIST', result_def)]
    data_str = '\n\n'.join(data_str)

    return data_str


def main():

    parser = argparse.ArgumentParser(description='Generate data for layernorm kernel')
    parser.add_argument(
        "-c", "--cfg",
        type=pathlib.Path,
        required=True,
        help='Select param config file kernel'
    )
    parser.add_argument(
        '--section',
        type=str,
        help='Section to store matrices in')
    parser.add_argument(
        'output',
        type=pathlib.Path,
        help='Path of the output header file')
    args = parser.parse_args()

    # Load param config file
    with args.cfg.open() as f:
        param = json5.loads(f.read())

    # Emit header file
    with open(args.output, 'w') as f:
        f.write(emit_header(args.section, param))


if __name__ == '__main__':
    main()
