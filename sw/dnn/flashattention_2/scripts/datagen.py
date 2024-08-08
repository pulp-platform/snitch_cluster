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
import torch
import pyflexfloat as ff

from snitch.util.sim import data_utils
from snitch.util.sim.data_utils import DataGen, format_struct_definition, \
    format_array_definition, format_array_declaration, emit_license
from snitch.blas import gemm

np.random.seed(42)
torch.manual_seed(42)

np.set_printoptions(formatter={'object': str})


def torch_golden_model(Q, K, V):
    return torch.nn.functional.scaled_dot_product_attention(Q, K, V)


def exact_golden_model(Q, K, V, B_r, B_c):
    # Convert torch tensors to numpy arrays
    Q = Q.numpy()
    K = K.numpy()
    V = V.numpy()
    # Get layer dimensions
    L = Q.shape[0]
    S = K.shape[0]
    # Calculate tiling parameters
    T_r = L // B_r
    T_c = S // B_c
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


np.set_printoptions(formatter={'object': str})


def exact_flexfloat_golden_model(Q, K, V, B_r, B_c, desc):
    # Get layer dimensions
    L = Q.shape[0]
    d = Q.shape[1]
    S = K.shape[0]
    # Calculate tiling parameters
    T_r = L // B_r
    T_c = S // B_c
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
            V_j = V[start_col:end_col,]
            # Compute O tile update
            S_ij = ff.array(np.zeros((B_r, B_c)), desc)
            S_ij = gemm.GemmDataGen().exact_golden_model(1, Q_i, K_t_j, 0, S_ij)
            m_i_prev = m_i
            m_i = np.maximum(m_i_prev, np.max(S_ij, 1, keepdims=True))
            shifted_exp = np.exp((m_i_prev.astype(np.float32) - m_i.astype(np.float32)))
            P_ij = np.exp((S_ij - m_i).astype(np.float32))
            PxV = ff.array(np.zeros((B_r, d)), desc)
            PxV = gemm.GemmDataGen().exact_golden_model(1, P_ij, V_j, 0, PxV)
            row_sum = np.sum(P_ij.astype(np.float32), 1, keepdims=True)
            if j == 0:
                l_i = row_sum
                O_i = PxV
            else:
                l_i = (shifted_exp * l_i) + row_sum
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


def get_gemm_implementation(self, params):
    prec = params['dtype'].lower()
    impl = f'gemm_{prec}_'
    if params['baseline']:
        impl += 'naive'
    else:
        impl += 'opt'
        if prec == 'fp8':
            impl += '_ex'
    return impl


def load_params(self, params):
    self.L = params['L']
    self.S = params['S']
    self.d = params['d']
    self.B_r = params['B_r']
    self.B_c = params['B_c']
    self.dtype = params['dtype']
    self.baseline = params['baseline']
    self.use_mask = params['use_mask']
    self.gemm_impl = self.get_gemm_implementation(params)
    # self.torch_type = data_utils.torch_type_from_precision_t(self.dtype)
    self.ff_desc = data_utils.ff_desc_from_precision_t(self.dtype)
    self.ctype = data_utils.ctype_from_precision_t(self.dtype)
    self.prec = data_utils.size_from_precision_t(self.dtype)

# Verify layer parameters are valid


def validate(self):
    assert (self.L % self.B_r) == 0, 'L is not an integer multiple of B_r'
    assert (self.S % self.B_c) == 0, 'S is not an integer multiple of B_c'
    assert self.dtype != 'FP64', 'FP64 precision is not supported yet'

    # Calculate total TCDM occupation
    q_fa_size = self.B_r * self.d * self.prec
    k_fa_size = self.B_c * self.d * self.prec
    v_fa_size = self.B_c * self.d * self.prec
    s_fa_size = self.B_r * self.B_c * self.prec
    p_fa_size = self.B_r * self.B_c * self.prec
    o_fa_size = self.B_r * self.d * self.prec
    m_i_size = self.B_r * self.prec
    l_i_size = self.B_r * self.prec
    mask_size = self.B_r * self.B_c * self.prec if self.use_mask else 0
    total_size = q_fa_size
    total_size += k_fa_size
    total_size += v_fa_size * 2  # V and V^t
    total_size += s_fa_size
    total_size += p_fa_size
    total_size += o_fa_size
    total_size += m_i_size * 2  # m_i and m_i_prev
    total_size += l_i_size
    total_size += mask_size
    data_utils.validate_tcdm_footprint(total_size)

    # Q*K^t
    gemm_gen = gemm.GemmDataGen()
    gemm_params = {
        'gemm_fp': self.gemm_impl,
        'parallelize_m': 0,
        'parallelize_k': 0,
        'm_tiles': 1,
        'n_tiles': 1,
        'k_tiles': 1,
        'transa': 0,
        'transb': 1,
        'M': self.B_r,
        'N': self.B_c,
        'K': self.d,
        'beta': 0
    }
    gemm_gen.load_params(gemm_params)
    gemm_gen.validate()

    # P*V
    gemm_params = {
        'gemm_fp': self.gemm_impl,
        'parallelize_m': 0,
        'parallelize_k': 0,
        'm_tiles': 1,
        'n_tiles': 1,
        'k_tiles': 1,
        'transa': 0,
        'M': self.B_r,
        'N': self.d,
        'K': self.B_c,
        'beta': 1
    }
    if self.baseline:
        gemm_params['transb'] = 0
        gemm_gen.load_params(gemm_params)
        gemm_gen.validate()
    else:
        # P*(V^t)^t
        gemm_params['transb'] = 1
        gemm_gen.load_params(gemm_params)
        gemm_gen.validate()


def get_gemm_implementation(params):
    prec = params['dtype'].lower()
    impl = f'gemm_{prec}_'
    if params['baseline']:
        impl += 'naive'
    else:
        impl += 'opt'
        if prec == 'fp8':
            impl += '_ex'
    return impl


def emit_header(section, params):
    L = params['L']
    S = params['S']
    d = params['d']
    B_r = params['B_r']
    B_c = params['B_c']
    prec = params['dtype']
    gemm_impl = get_gemm_implementation(params)

    # TODO: Add validation (vivianep)

    # torch_type = data_utils.torch_type_from_precision_t(prec)
    ff_desc = data_utils.ff_desc_from_precision_t(prec)
    ctype = data_utils.ctype_from_precision_t(prec)

    # Generate same data for all dtypes for easier debugging.
    # To achieve this, we always generate in FP16 and then convert.
    # Q = torch.rand(L, d, requires_grad=False, dtype=torch.float16).to(dtype=torch_type)
    # K = torch.rand(S, d, requires_grad=False, dtype=torch.float16).to(dtype=torch_type)
    # V = torch.rand(S, d, requires_grad=False, dtype=torch.float16).to(dtype=torch_type)
    Q = ff.array(np.random.rand(L, d), ff_desc)
    K = ff.array(np.random.rand(S, d), ff_desc)
    V = ff.array(np.random.rand(S, d), ff_desc)

    output = exact_flexfloat_golden_model(Q, K, V, B_r, B_c, ff_desc)

    q_uid = 'Q'
    k_uid = 'K'
    v_uid = 'V'
    o_uid = 'O'

    layer_cfg = {
        **params,
        'gemm_implementation': gemm_impl,
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
