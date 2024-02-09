# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Author: Luca Colagrande <colluca@iis.ee.ethz.ch>
"""Convenience functions for data generation scripts."""


import struct
from datetime import datetime
import torch
import numpy as np


def emit_license():
    """Emit license header.

    Returns:
        A header string.
    """

    s = (f"// Copyright {datetime.now().year} ETH Zurich and University of Bologna.\n"
         f"// Licensed under the Apache License, Version 2.0, see LICENSE for details.\n"
         f"// SPDX-License-Identifier: Apache-2.0\n")
    return s


# Enum value can be a string or an integer, this function uniformizes the result to integers only
def _integer_precision_t(prec):
    if isinstance(prec, str):
        return {'FP64': 8, 'FP32': 4, 'FP16': 2, 'FP8': 1}[prec]
    else:
        return prec


def torch_type_from_precision_t(prec):
    """Convert `precision_t` type to PyTorch type.

    Args:
        prec: A value of type `precision_t`. Accepts both enum strings
            (e.g. "FP64") and integer enumeration values (e.g. 8).
    """
    ctype_to_torch_type_map = {
        8: torch.float64,
        4: torch.float32,
        2: torch.float16,
        1: None
    }
    return ctype_to_torch_type_map[_integer_precision_t(prec)]


# Returns the C type representing a floating-point value of the specified precision
def ctype_from_precision_t(prec):
    """Convert `precision_t` type to a C type string.

    Args:
        prec: A value of type `precision_t`. Accepts both enum strings
            (e.g. "FP64") and integer enumeration values (e.g. 8).
    """
    precision_t_to_ctype_map = {
        8: 'double',
        4: 'float',
        2: '__fp16',
        1: '__fp8'
    }
    return precision_t_to_ctype_map[_integer_precision_t(prec)]


def flatten(array):
    """Flatten various array types with a homogeneous API.

    Args:
        array: Can be a Numpy array, a PyTorch tensor or a nested list.
    """
    if isinstance(array, np.ndarray):
        return array.flatten()
    elif isinstance(array, torch.Tensor):
        return array.numpy().flatten()
    elif isinstance(array, list):
        return np.array(array).flatten()


def _variable_attributes(alignment=None, section=None):
    attributes = ''
    if alignment:
        attributes = f'__attribute__ ((aligned ({alignment})))'
    if section:
        attributes += f' __attribute__ ((section ("{section}")))'
    return attributes


def _alias_dtype(dtype):
    if dtype == '__fp8':
        return 'char'
    else:
        return dtype


def format_array_declaration(dtype, uid, shape, alignment=None, section=None):
    attributes = _variable_attributes(alignment, section)
    s = f'{_alias_dtype(dtype)} {uid}'
    for dim in shape:
        s += f'[{dim}]'
    if attributes:
        s += f' {attributes};'
    else:
        s += ';'
    return s


# In the case of dtype __fp8, array field expects a dictionary of
# sign, exponent and mantissa arrays
def format_array_definition(dtype, uid, array, alignment=None, section=None):
    # Definition starts with the declaration stripped off of the terminating semicolon
    s = format_array_declaration(dtype, uid, array.shape, alignment, section)[:-1]
    s += ' = '
    s += format_array_initializer(dtype, array)
    s += ';'
    return s


def format_scalar_definition(dtype, uid, scalar):
    s = f'{_alias_dtype(dtype)} {uid} = {scalar};'
    return s


def format_array_initializer(dtype, array):
    s = '{\n'
    # Flatten array
    if dtype == '__fp8':
        array = zip(flatten(array['sign']),
                    flatten(array['exponent']),
                    flatten(array['mantissa']))
    else:
        array = flatten(array)
    # Format array elements
    for el in array:
        if dtype == '__fp8':
            sign, exp, mant = el
            el = sign * 2**7 + exp * 2**2 + mant
            el_str = f'0x{el:02x}'
        else:
            el_str = f'{el}'
        s += f'\t{el_str},\n'
    s += '}'
    return s


def format_struct_definition(dtype, uid, map):
    def format_value(value):
        if isinstance(value, list):
            return format_array_initializer(str, value)
        elif isinstance(value, bool):
            return int(value)
        else:
            return str(value)
    s = f'{_alias_dtype(dtype)} {uid} = {{\n'
    s += ',\n'.join([f'\t.{key} = {format_value(value)}' for (key, value) in map.items()])
    s += '\n};'
    return s


def format_ifdef_wrapper(macro, body):
    s = f'#ifdef {macro}\n'
    s += f'{body}\n'
    s += f'#endif // {macro}\n'
    return s


def from_buffer(byte_array, ctype='uint32_t'):
    """Get structured data from raw bytes.

    If `ctype` is a C type string, it returns a homogeneous list of the
    specified type from the raw data.

    Alternatively, a dictionary can be passed to `ctype` to extract a
    struct from the raw data. In this case, it returns a dictionary with
    the same keys as in `ctype`. The values in the `ctype` dictionary
    should be format strings compatible with Python's `struct` library.
    The order of the keys in the `ctype` dictionary should reflect the
    order in which the variables appear in the raw data.
    """
    # Types which have a direct correspondence in Numpy
    NP_DTYPE_FROM_CTYPE = {
        'uint32_t': np.uint32,
        'double': np.float64,
        'float': np.float32,
        '__fp16': np.float16
    }

    if isinstance(ctype, dict):
        # byte_array assumed little-endian
        struct_fields = ctype.keys()
        fmt_specifiers = ctype.values()
        fmt_string = ''.join(fmt_specifiers)
        field_values = struct.unpack(f'<{fmt_string}', byte_array)
        return dict(zip(struct_fields, field_values))
    elif ctype in NP_DTYPE_FROM_CTYPE.keys():
        dtype = NP_DTYPE_FROM_CTYPE[ctype]
        return np.frombuffer(byte_array, dtype=dtype)
    elif ctype == '__fp8':
        array = []
        byte_array = np.frombuffer(byte_array, dtype=np.uint8)
        for byte in byte_array:
            sign = (byte & 0x80) >> 7  # Extract sign (1 bit)
            exponent = (byte & 0x7c) >> 2  # Extract exponent (5 bits)
            mantissa = (byte & 0x03) << 5  # Extract mantissa (2 bits)
            real_exp = exponent - 15  # Convert exponent from excess-7 to excess-127
            value = (1 + mantissa / 4) * (2 ** float(real_exp))  # Calculate value
            if sign:
                value *= -1
            array.append(value)
        return array
