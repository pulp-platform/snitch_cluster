#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>


import numpy as np
import sys

import pyflexfloat as ff

from snitch.util.sim.verif_utils import Verifier
import snitch.util.sim.data_utils as du
from snitch.blas.gemm.scripts.datagen import GemmDataGen
from snitch.dnn.flashattention_2.scripts.datagen import FlashAttention2DataGen


class MhaVerifier(Verifier):

    OUTPUT_UIDS = ['O']
    # To verify the outputs from the individual heads
    # OUTPUT_UIDS = ['O_0', 'O_1']

    ERR_THRESHOLD = {4: 1e-6, 2: 8e-3, 1: 3e-1}

    def __init__(self):
        super().__init__()
        self.layer_struct = {
            'num_heads': 'I',
            'L': 'I',
            'S': 'I',
            'd': 'I',
            'B_r': 'I',
            'B_c': 'I',
            'dtype': 'I',
            'baseline': 'I',
            'gemm_implementation': 'I',
            'Q': 'I',
            'K': 'I',
            'V': 'I',
            'W': 'I',
            'head_outputs': 'I',
            'O': 'I'
        }
        self.layer = self.get_input_from_symbol('layer', self.layer_struct)
        self.L = self.layer['L']
        self.S = self.layer['S']
        self.d = self.layer['d']
        self.B_r = self.layer['B_r']
        self.B_c = self.layer['B_c']
        self.prec = self.layer['dtype']
        self.num_heads = self.layer['num_heads']
        self.W = self.layer['W']
        self.Q = [self.get_input_from_symbol('Q_' + str(head), du.ctype_from_precision_t(self.prec))
                  for head in range(self.num_heads)]

    def get_actual_results(self):
        # Iterates over OUTPUT_UIDS in case we want to verify the intermediate outputs
        # from every head
        outputs = []
        for uid in self.OUTPUT_UIDS:
            outputs.append(self.get_output_from_symbol(uid, du.ctype_from_precision_t(self.prec)))
        results = np.concatenate(outputs, axis=None)
        return results

    def get_expected_results(self):
        # FlashAttention-2 calculation for each head
        head_outputs = []
        for head in range(self.num_heads):

            # Get input tensors for the current head (raw bytes)
            Q = self.get_input_from_symbol('Q_' + str(head), du.ctype_from_precision_t(self.prec))
            K = self.get_input_from_symbol('K_' + str(head), du.ctype_from_precision_t(self.prec))
            V = self.get_input_from_symbol('V_' + str(head), du.ctype_from_precision_t(self.prec))

            # Convert input tensors to float using ff.FlexFloat.__float__
            Q_f = np.array([q.__float__() for q in Q])
            K_f = np.array([k.__float__() for k in K])
            V_f = np.array([v.__float__() for v in V])

            # Reshape input tensors
            ff_desc = du.ff_desc_from_precision_t(self.prec)
            Q = ff.array(Q_f.reshape(self.L, self.d), ff_desc)
            V = ff.array(V_f.reshape(self.S, self.d), ff_desc)
            K = ff.array(K_f.reshape(self.S, self.d), ff_desc)

            # Calculate head output
            O_head = FlashAttention2DataGen().exact_flexfloat_golden_model(Q, K, V, self.B_r,
                                                                           self.B_c, ff_desc)
            head_outputs.append(O_head)

        # Verify outputs from individual heads (change OUTPUT_UIDS accordingly)
        # return np.concatenate(head_outputs, axis=None)

        # Concatenate heads
        concat_output = np.concatenate(head_outputs, axis=1)

        # Final projection
        W = self.get_input_from_symbol('W', du.ctype_from_precision_t(self.prec))
        W = np.array([w.__float__() for w in W])
        W = np.reshape(W, (self.d*self.num_heads, self.d))
        W = ff.array(W, du.ff_desc_from_precision_t(self.prec))
        O_mha = np.zeros((self.L, self.d), dtype=du.ctype_from_precision_t(self.prec))
        O_mha = GemmDataGen().exact_golden_model(1, concat_output, W, 0, O_mha)
        return O_mha.flatten()

    def check_results(self, *args):
        return super().check_results(*args, rtol=self.ERR_THRESHOLD[self.prec])


if __name__ == "__main__":
    sys.exit(MhaVerifier().main())
