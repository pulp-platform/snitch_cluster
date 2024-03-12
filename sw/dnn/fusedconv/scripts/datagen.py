#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Viviane Potocnik <vivianep@iis.ee.ethz.ch>

import argparse
import pathlib
import hjson
import sys
import os
import torch

sys.path.append(os.path.join(os.path.dirname(__file__), "../../../../util/sim/"))
import data_utils  # noqa: E402
from data_utils import emit_license, \
                       format_struct_definition, format_array_definition, \
                       format_scalar_definition, format_array_declaration  # noqa: E402

torch.manual_seed(42)

# AXI splits bursts crossing 4KB address boundaries. To minimize
# the occurrence of these splits the data should be aligned to 4KB
BURST_ALIGNMENT = 4096


# FusedConv
def golden_model(ifmap, weights, bn_k, bn_l, padding, stride, bn, relu, accumulate, depthwise):

    ih, iw, ci = ifmap.shape
    if not depthwise:
        co, fh, fw, _ = weights.shape
    else:
        fh, fw, co = weights.shape
        ci = co

    ifmap_padded = torch.zeros(ih + padding['padding_y_top'] + padding['padding_y_bottom'], iw +
                               padding['padding_x_left'] + padding['padding_x_right'],
                               ci,
                               requires_grad=False, dtype=ifmap.dtype)
    ifmap_padded[padding['padding_y_top']:ih+padding['padding_y_top'],
                 padding['padding_x_left']:iw+padding['padding_x_left']] = ifmap

    # Don't cover undefined behaviour when there are steps without a complete kernel window
    if (ifmap_padded.shape[0] - (fh - 1) - 1) % stride['stride_y'] != 0:
        print("Warning: rounding h output dimension")
    if (ifmap_padded.shape[1] - (fw - 1) - 1) % stride['stride_x'] != 0:
        print("Warning: rounding w output dimension")

    ofmap = torch.zeros((ifmap_padded.shape[0] - (fh - 1) - 1) // stride['stride_y'] + 1,
                        (ifmap_padded.shape[1] - (fw - 1) - 1) // stride['stride_x'] + 1, co)
    if accumulate:
        ofmap_before = torch.randn_like(ofmap, requires_grad=False)
    else:
        ofmap_before = torch.zeros_like(ofmap, requires_grad=False)

    if (depthwise):
        # depthwise Conv2d
        for h in range(0, ifmap_padded.shape[0] - (fh - 1), stride['stride_y']):
            for w in range(0, ifmap_padded.shape[1] - (fw - 1), stride['stride_x']):
                for c in range(co):
                    ofmap[h//stride['stride_y'], w//stride['stride_x'],
                          c] = torch.dot(
                            ifmap_padded[h:h+fh, w:w+fw, c].flatten(),
                            weights[:, :, c].flatten())
    else:
        # Conv2d
        for h in range(0, ifmap_padded.shape[0] - (fh - 1), stride['stride_y']):
            for w in range(0, ifmap_padded.shape[1] - (fw - 1), stride['stride_x']):
                for c in range(co):
                    ofmap[h//stride['stride_y'], w//stride['stride_x'],
                          c] = torch.dot(
                            ifmap_padded[h:h+fh, w:w+fw].flatten(),
                            weights[c].flatten())

    ofmap += ofmap_before

    # BatchNorm
    if bn:
        ofmap = ofmap * bn_k + bn_l

    # ReLU
    if relu:
        ofmap = torch.nn.functional.relu(ofmap)

    return ofmap, ofmap_before, ifmap_padded


def emit_header(**kwargs):
    # in_channels = kwargs['channels']['in']
    # out_channels = kwargs['channels']['out']
    # input_dim = kwargs['input_dim'] # [mini_batch, height, width]
    # filter = kwargs['filter'] # [height, width, padding, stride]
    prec = kwargs['prec']

    torch_type = data_utils.torch_type_from_precision_t(prec)

    ifmap = torch.randn(kwargs['dim_in_y'],
                        kwargs['dim_in_x'],
                        kwargs['ch_in'], requires_grad=False, dtype=torch_type)

    if not kwargs['depthwise']:
        kernel = torch.randn(kwargs['ch_out'], kwargs['dim_kernel_y'],
                             kwargs['dim_kernel_x'], kwargs['ch_in'],
                             requires_grad=False, dtype=torch_type)
    else:
        kernel = torch.randn(kwargs['dim_kernel_y'],
                             kwargs['dim_kernel_x'], kwargs['ch_out'],
                             requires_grad=False, dtype=torch_type)

    bn_k = torch.randn(kwargs['ch_out'], requires_grad=False, dtype=torch_type)
    bn_l = torch.randn(kwargs['ch_out'], requires_grad=False, dtype=torch_type)

    flag_y_accumulate_start = kwargs['flags']['flag_y_accumulate_start']

    ofmap, ofmap_before, ifmap_padded = golden_model(ifmap, kernel,
                                                     bn_k, bn_l,
                                                     kwargs['padding'],
                                                     kwargs['stride'],
                                                     kwargs['flags']['flag_batch_norm'],
                                                     kwargs['flags']['flag_relu'],
                                                     not flag_y_accumulate_start,
                                                     kwargs['depthwise'])

    if kwargs['chw_layer']:
        ifmap = ifmap.permute(2, 0, 1)
        ifmap_padded = ifmap_padded.permute(2, 0, 1)
        kernel = kernel.permute(0, 3, 1, 2)

    ctype = data_utils.ctype_from_precision_t(prec)

    if kwargs['depthwise']:
        ih, iw, ci = ifmap.shape
        oh, ow, co = ofmap.shape
        fh, fw, co = kernel.shape
        ci = co
        ih_pad, iw_pad, _ = ifmap_padded.shape
    elif kwargs['chw_layer']:
        ci, ih, iw = ifmap.shape
        oh, ow, co = ofmap.shape
        co, ci, fh, fw = kernel.shape
        _, ih_pad, iw_pad = ifmap_padded.shape
    else:
        ih, iw, ci = ifmap.shape
        oh, ow, co = ofmap.shape
        _, fh, fw, _ = kernel.shape
        ih_pad, iw_pad, _ = ifmap_padded.shape

    layer_cfg = {
        'ch_in': ci,
        'ch_out': co,
        'dim_in_x': iw,
        'dim_in_y': ih,
        'dim_kernel_x': fw,
        'dim_kernel_y': fh,
        'dim_out_x': ow,
        'dim_out_y': oh,
        'padding_y_top': kwargs['padding']['padding_y_top'],
        'padding_y_bottom': kwargs['padding']['padding_y_bottom'],
        'padding_x_left': kwargs['padding']['padding_x_left'],
        'padding_x_right': kwargs['padding']['padding_x_right'],
        'stride_x': kwargs['stride']['stride_x'],
        'stride_y': kwargs['stride']['stride_y'],
        'flag_relu': kwargs['flags']['flag_relu'],
        'flag_batch_norm': kwargs['flags']['flag_batch_norm'],
        'depthwise': kwargs['depthwise'],
        'chw_layer': kwargs['chw_layer'],
        'flag_y_accumulate_start': flag_y_accumulate_start,
        'flag_y_accumulate_end': kwargs['flags']['flag_y_accumulate_end'],
        'pInBuffer': 'fusedconv_pInBuffer_dram',
        'pWeight': 'fusedconv_pWeight_dram',
        'lambda': 'fusedconv_lambda_dram',
        'kappa': 'fusedconv_kappa_dram',
        'pOutBuffer': 'fusedconv_pOutBuffer_dram',
        'dtype': prec
    }

    ifmap_padded = data_utils.flatten(ifmap_padded.numpy())
    kernel = data_utils.flatten(kernel.numpy())
    ofmap_before = data_utils.flatten(ofmap_before.numpy())

    data_str = [emit_license()]
    data_str += [format_array_declaration(ctype, 'fusedconv_pInBuffer_dram',
                                          ifmap_padded.shape, BURST_ALIGNMENT)]
    data_str += [format_array_declaration(ctype, 'fusedconv_pWeight_dram',
                                          kernel.shape, BURST_ALIGNMENT)]
    data_str += [format_array_declaration(ctype, 'fusedconv_lambda_dram',
                                          bn_l.numpy().shape, BURST_ALIGNMENT)]
    data_str += [format_array_declaration(ctype, 'fusedconv_kappa_dram',
                                          bn_k.numpy().shape, BURST_ALIGNMENT)]
    data_str += [format_array_declaration(ctype, 'fusedconv_pOutBuffer_dram',
                                          ofmap_before.shape, BURST_ALIGNMENT)]
    data_str += [format_array_declaration(ctype, 'fusedconv_pCheckOutBuffer_dram',
                                          ofmap.numpy().shape, BURST_ALIGNMENT)]
    data_str += [format_struct_definition('kernel_fp32', 'layer', layer_cfg)]
    data_str += [format_scalar_definition('uint32_t', 'dw', kwargs['depthwise'])]
    data_str += [format_scalar_definition('uint32_t', 'chw_layer', kwargs['chw_layer'])]
    data_str += [format_array_definition(ctype, 'fusedconv_pInBuffer_dram',
                                         ifmap_padded, BURST_ALIGNMENT)]
    data_str += [format_array_definition(ctype, 'fusedconv_pWeight_dram',
                                         kernel, BURST_ALIGNMENT)]
    data_str += [format_array_definition(ctype, 'fusedconv_lambda_dram',
                                         bn_l.numpy(), BURST_ALIGNMENT)]
    data_str += [format_array_definition(ctype, 'fusedconv_kappa_dram',
                                         bn_k.numpy(), BURST_ALIGNMENT)]
    data_str += [format_array_definition(ctype, 'fusedconv_pOutBuffer_dram',
                                         ofmap_before, BURST_ALIGNMENT)]
    data_str += [format_array_definition(ctype, 'fusedconv_pCheckOutBuffer_dram',
                                         ofmap.numpy(), BURST_ALIGNMENT)]

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
        param = hjson.loads(f.read())
    param['section'] = args.section

    # Emit header file
    with open(args.output, 'w') as f:
        f.write(emit_header(**param))


if __name__ == '__main__':
    main()
