#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Viviane Potocnik <vivianep@iis.ee.ethz.ch>
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import numpy as np
import torch
import pyflexfloat as ff
import sys

import snitch.util.sim.data_utils as du

from snitch.blas import gemm

np.random.seed(42)
torch.manual_seed(42)
np.set_printoptions(formatter={'object': str})


class FlashAttention2DataGen(du.DataGen):

    def torch_golden_model(self, Q, K, V):
        return torch.nn.functional.scaled_dot_product_attention(Q, K, V)

    def exact_golden_model(self, Q, K, V, B_r, B_c):
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

    def exact_flexfloat_golden_model(self, Q, K, V, B_r, B_c, desc):
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

    # Verify layer parameters are valid
    def validate(self, L, S, d, B_r, B_c, dtype, baseline, gemm_impl, **kwargs):
        assert (L % B_r) == 0, 'L is not an integer multiple of B_r'
        assert (S % B_c) == 0, 'S is not an integer multiple of B_c'
        assert dtype != 'FP64', 'FP64 precision is not supported yet'

        # Calculate total TCDM occupation
        prec = du.size_from_precision_t(dtype)
        q_fa_size = B_r * d * prec
        k_fa_size = B_c * d * prec
        v_fa_size = B_c * d * prec
        s_fa_size = B_r * B_c * prec
        p_fa_size = B_r * B_c * prec
        o_fa_size = B_r * d * prec
        m_i_size = B_r * prec
        l_i_size = B_r * prec
        total_size = q_fa_size
        total_size += k_fa_size
        total_size += v_fa_size * 2  # V and V^t
        total_size += s_fa_size
        total_size += p_fa_size
        total_size += o_fa_size
        total_size += m_i_size * 2  # m_i and m_i_prev
        total_size += l_i_size
        du.validate_tcdm_footprint(total_size)

        # Q*K^t
        gemm.GemmDataGen().validate(
            gemm_fp=gemm_impl, parallelize_m=0, parallelize_k=0, m_tiles=1, n_tiles=1,
            k_tiles=1, transa=0, transb=1, m=B_r, n=B_c, k=d, beta=0, load_a=0, load_b=0, load_c=0
        )

        # P*V
        if baseline:
            gemm.GemmDataGen().validate(
                gemm_fp=gemm_impl, parallelize_m=0, parallelize_k=0, m_tiles=1, n_tiles=1,
                k_tiles=1, transa=0, transb=0, m=B_r, n=d, k=B_c, beta=1, load_a=0, load_b=0,
                load_c=0
            )
        else:
            # P*(V^t)^t
            gemm.GemmDataGen().validate(
                gemm_fp=gemm_impl, parallelize_m=0, parallelize_k=0, m_tiles=1, n_tiles=1,
                k_tiles=1, transa=0, transb=1, m=B_r, n=d, k=B_c, beta=1, load_a=0, load_b=0,
                load_c=0
            )

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

    def emit_header(self, **kwargs):
        header = [super().emit_header()]

        L = kwargs['L']
        S = kwargs['S']
        d = kwargs['d']
        B_r = kwargs['B_r']
        B_c = kwargs['B_c']
        prec = kwargs['dtype']
        gemm_impl = self.get_gemm_implementation(kwargs)

        self.validate(gemm_impl=gemm_impl, **kwargs)

        # torch_type = du.torch_type_from_precision_t(prec)
        ff_desc = du.ff_desc_from_precision_t(prec)
        ctype = du.ctype_from_precision_t(prec)

        # Generate same data for all dtypes for easier debugging.
        # To achieve this, we always generate in FP16 and then convert.
        # Q = torch.rand(L, d, requires_grad=False, dtype=torch.float16).to(dtype=torch_type)
        # K = torch.rand(S, d, requires_grad=False, dtype=torch.float16).to(dtype=torch_type)
        # V = torch.rand(S, d, requires_grad=False, dtype=torch.float16).to(dtype=torch_type)
        Q = ff.array(np.random.rand(L, d), ff_desc)
        K = ff.array(np.random.rand(S, d), ff_desc)
        V = ff.array(np.random.rand(S, d), ff_desc)

        output = self.exact_flexfloat_golden_model(Q, K, V, B_r, B_c, ff_desc)

        q_uid = 'Q'
        k_uid = 'K'
        v_uid = 'V'
        o_uid = 'O'

        layer_cfg = {
            **kwargs,
            'gemm_implementation': gemm_impl,
            'Q': q_uid,
            'K': k_uid,
            'V': v_uid,
            'O': o_uid,
        }

        header += [du.format_array_declaration(f'extern {ctype}', q_uid, Q.shape)]
        header += [du.format_array_declaration(f'extern {ctype}', k_uid, K.shape)]
        header += [du.format_array_declaration(f'extern {ctype}', v_uid, V.shape)]
        header += [du.format_array_declaration(ctype, o_uid, output.shape)]
        header += [du.format_struct_definition('flashattention_2_layer_t', 'layer', layer_cfg)]
        header += [du.format_array_definition(ctype, q_uid, Q)]
        header += [du.format_array_definition(ctype, k_uid, K)]
        header += [du.format_array_definition(ctype, v_uid, V)]
        header = '\n\n'.join(header)

        return header


if __name__ == '__main__':
    sys.exit(FlashAttention2DataGen().main())
