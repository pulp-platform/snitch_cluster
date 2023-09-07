# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

import struct


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
        s += f'\t{el},\n'
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
