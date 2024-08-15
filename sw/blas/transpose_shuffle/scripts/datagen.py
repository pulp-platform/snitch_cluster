#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import numpy as np
import os
import pyflexfloat as ff
import sys

sys.path.append(os.path.join(os.path.dirname(__file__), "../../../../util/sim/"))

from data_utils import ctype_from_precision_t, ff_desc_from_precision_t, \
                       format_array_definition, format_array_declaration, \
                       format_ifdef_wrapper, DataGen, format_scalar_definition  # noqa: E402

np.random.seed(42)

# AXI splits bursts crossing 4KB address boundaries. To minimize
# the occurrence of these splits the data should be aligned to 4KB
BURST_ALIGNMENT = 4096


class TransposeDataGen(DataGen):

    def golden_model(self, inp):
        return np.transpose(inp)

# TODO:
# def validate_config(p**kwargs):
#     pass

    def emit_header(self, **kwargs):
        header = [super().emit_header()]

        M, N, prec = kwargs['M'], kwargs['N'], kwargs['prec']

        ff_desc = ff_desc_from_precision_t(prec)
        ctype = ctype_from_precision_t(prec)

        inp = ff.array(np.random.rand(M, N), ff_desc)
        output = self.golden_model(inp)

        input_uid = 'input'
        output_uid = 'output'

        header += [format_array_declaration(ctype, input_uid, inp.shape,
                                            alignment=BURST_ALIGNMENT)]
        header += [format_array_declaration(ctype, output_uid, output.shape,
                                            alignment=BURST_ALIGNMENT)]
        header += [format_scalar_definition('uint32_t', 'M', M)]
        header += [format_scalar_definition('uint32_t', 'N', N)]
        header += [format_scalar_definition('uint32_t', 'dtype', prec)]
        header += [format_scalar_definition('uint32_t', 'baseline', int(kwargs['baseline']))]
        header += [format_scalar_definition('uint32_t', 'opt_ssr', int(kwargs['opt_ssr']))]
        header += [format_array_definition(ctype, input_uid, inp, alignment=BURST_ALIGNMENT)]
        result_def = format_array_definition(ctype, 'golden', output, alignment=BURST_ALIGNMENT)
        header += [format_ifdef_wrapper('BIST', result_def)]
        header = '\n\n'.join(header)

        return header


if __name__ == '__main__':
    sys.exit(TransposeDataGen().main())
