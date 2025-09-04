#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Tim Fischer <fischeti@iis.ee.ethz.ch>
# Viviane Potocnik <vivianep@iis.ee.ethz.ch>
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import numpy as np
import pyflexfloat as ff
import sys

from snitch.util.sim.data_utils import ctype_from_precision_t, ff_desc_from_precision_t, \
    format_struct_definition, format_array_definition, format_array_declaration, \
    format_ifdef_wrapper, DataGen

np.random.seed(42)

# AXI splits bursts crossing 4KB address boundaries. To minimize
# the occurrence of these splits the data should be aligned to 4KB
BURST_ALIGNMENT = 4096


class TransposeDataGen(DataGen):

    def golden_model(self, inp):
        return np.transpose(inp)

    def emit_header(self, **kwargs):
        header = [super().emit_header()]

        M, N, prec = kwargs['M'], kwargs['N'], kwargs['prec']
        assert (M % 8) == 0, "M must be an integer multiple of the number of cores"

        ff_desc = ff_desc_from_precision_t(prec)
        ctype = ctype_from_precision_t(prec)

        inp = ff.array(np.random.rand(M, N), ff_desc)
        output = self.golden_model(inp)

        input_uid = 'input'
        output_uid = 'output'
        layer_cfg = {
            'M': M,
            'N': N,
            'input': input_uid,
            'output': output_uid,
            'dtype': prec,
            'baseline': kwargs['baseline']
        }

        header += [format_array_declaration(f'extern {ctype}', input_uid, inp.shape,
                                            alignment=BURST_ALIGNMENT)]
        header += [format_array_declaration(ctype, output_uid, output.shape,
                                            alignment=BURST_ALIGNMENT)]
        header += [format_struct_definition('transpose_layer_t', 'layer', layer_cfg)]
        header += [format_array_definition(ctype, input_uid, inp, alignment=BURST_ALIGNMENT)]
        result_def = format_array_definition(ctype, 'golden', output, alignment=BURST_ALIGNMENT)
        header += [format_ifdef_wrapper('BIST', result_def)]
        header = '\n\n'.join(header)

        return header


if __name__ == '__main__':
    sys.exit(TransposeDataGen().main())
