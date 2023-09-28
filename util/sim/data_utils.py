# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

import struct
from datetime import datetime


def emit_license():
    s = (f"// Copyright {datetime.now().year} ETH Zurich and University of Bologna.\n"
         f"// Licensed under the Apache License, Version 2.0, see LICENSE for details.\n"
         f"// SPDX-License-Identifier: Apache-2.0\n\n")
    return s


def variable_attributes(alignment=None, section=None):
    attributes = ''
    if alignment:
        attributes = f'__attribute__ ((aligned ({alignment})))'
    if section:
        attributes += f' __attribute__ ((section ("{section}")))'
    return attributes


def format_vector_definition(type, uid, vector, alignment=None, section=None):
    attributes = variable_attributes(alignment, section)
    s = f'{type} {uid}[{len(vector)}] {attributes} = ' + '{\n'
    for el in vector:
        if type != 'char':
            el_str = f'{el}'
        else:
            el_str = f'0x{el:02x}'
        s += f'\t{el_str},\n'
    s += '};'
    return s


def format_vector_declaration(type, uid, vector, alignment=None, section=None):
    attributes = variable_attributes(alignment, section)
    s = f'{type} {uid}[{len(vector)}] {attributes};'
    return s


def format_scalar_definition(type, uid, scalar):
    s = f'{type} {uid} = {scalar};'
    return s


def format_ifdef_wrapper(macro, body):
    s = f'#ifdef {macro}\n'
    s += f'{body}\n'
    s += f'#endif // {macro}\n'
    return s


# bytearray assumed little-endian
def bytes_to_doubles(byte_array):
    double_size = struct.calcsize('d')  # Size of a double in bytes
    num_doubles = len(byte_array) // double_size

    # Unpack the byte array into a list of doubles
    doubles = []
    for i in range(num_doubles):
        double_bytes = byte_array[i * double_size:(i + 1) * double_size]
        double = struct.unpack('<d', double_bytes)[0]
        doubles.append(double)
    return doubles


def bytes_to_uint32s(byte_array):
    uint32_size = struct.calcsize('I')  # Size of a uint32 in bytes
    num_uints = len(byte_array) // uint32_size

    # Unpack the byte array into a list of uints
    uints = []
    for i in range(num_uints):
        uint32_bytes = byte_array[i * uint32_size:(i + 1) * uint32_size]
        uint = struct.unpack('<I', uint32_bytes)[0]
        uints.append(uint)
    return uints
