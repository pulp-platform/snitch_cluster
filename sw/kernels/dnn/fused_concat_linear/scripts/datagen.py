#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>
# Viviane Potocnik <vivianep@iis.ee.ethz.ch>

import numpy as np
import torch
import sys

import snitch.util.sim.data_utils as du


class FusedConcatLinearDataGen(du.DataGen):

    def golden_model(self, inputs, weights):
        innermost_dim = len(inputs[0].shape) - 1
        concat_output = torch.cat(inputs, dim=innermost_dim)
        linear_output = torch.matmul(concat_output, weights)
        return linear_output, concat_output

    def emit_header(self, **kwargs):
        header = [super().emit_header()]

        num_inputs = kwargs['num_inputs']
        input_shape = kwargs['input_shape']
        output_shape = kwargs['output_shape']
        prec = kwargs['dtype']

        assert input_shape[0] == output_shape[0], 'Inconsistent input and output shapes'

        torch_type = du.torch_type_from_precision_t(prec)

        inputs = [torch.rand(*input_shape, requires_grad=False, dtype=torch_type)
                  for _ in range(num_inputs)]
        weights = torch.rand([input_shape[1]*num_inputs, output_shape[1]],
                             requires_grad=False, dtype=torch_type)
        linear_output, concat_output = self.golden_model(inputs, weights)

        ctype = du.ctype_from_precision_t(prec)

        layer_cfg = {
            **kwargs,
            'inputs': 'inputs',
            'weights': 'weights',
            'concat_output': 'concat_output',
            'linear_output': 'linear_output'
        }

        header += [du.format_array_declaration(f'extern {ctype}', f'input_{i}', input_shape)
                   for i in range(num_inputs)]
        header += [du.format_array_declaration('extern void*', 'inputs', [num_inputs])]
        header += [du.format_array_declaration(ctype, 'concat_output', concat_output.shape)]
        header += [du.format_array_declaration(ctype, 'linear_output', linear_output.shape)]
        header += [du.format_array_declaration(f'extern {ctype}', 'weights', weights.shape)]
        header += [du.format_struct_definition('fused_concat_linear_layer_t', 'layer', layer_cfg)]
        header += [du.format_array_definition(ctype, f'input_{i}', t)
                   for i, t in enumerate(inputs)]
        header += [du.format_array_definition('void*', 'inputs', np.array([f'input_{i}'
                   for i in range(num_inputs)]))]
        header += [du.format_array_definition(ctype, 'weights', weights)]
        header = '\n\n'.join(header)

        return header


if __name__ == '__main__':
    sys.exit(FusedConcatLinearDataGen().main())
