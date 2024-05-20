#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import sys
import json
import numpy as np
from textwrap import indent
from mako.template import Template


CHECK_DEF_STRIDE = 17
CHECK_DEF_EPS = 1e-7
ELEMTYPE = 'double'
ELEMS_PER_ROW = 4

# Keep these dimensions aligned with code headers
GRID_DIMS = {
    1: {'s': 1000, 'sm': 1728, 'm': 2744, 'ml': 4096, 'l': 5832, 'xl': 8192},
    2: {'s': 32, 'sm': 42, 'm': 52, 'ml': 64, 'l': 76, 'xl': 128},
    3: {'s': 10, 'sm': 12, 'm': 14, 'ml': 16, 'l': 18, 'xl': 32},
}

CSTRUCT_FMT = 'struct TCDMSPC {prname} {{\n{body}\n}};\n{dtype} {decls};'

CTSTRUCT_FTYPE = 'TCDM PRMD'
CTSTRUCT_DTYPE = 'TCDM PRMXD'

CTSTRUCT_DEFAULT_GRIDS = {
    'xm':    {'seed': 1513, 'dims': [8]},
    'xp':    {'seed': 1514, 'dims': [8]},
    'ym':    {'seed': 1515, 'dims': [8]},
    'yp':    {'seed': 1516, 'dims': [8]},
    'zm':    {'seed': 1517, 'dims': [8]},
    'zp':    {'seed': 1518, 'dims': [8]},
    'cc':    {'seed': 1519},
    'c0':    {'seed': 1520},
    'uffac': {'seed': 1521},
    'c':     {'seed': 1522, 'dims': [6, 6]},
    'c3':    {'seed': 1523, 'dims': [3, 3, 3]}
}

CISTRUCT_FTYPE = 'TCDM PRM'
CISTRUCT_DTYPE = 'TCDM PRMX'


def set_seed(seed: int = None):
    if seed is not None:
        np.random.seed(seed)


def resolve_dim(dim: str) -> int:
    try:
        ret = int(dim)
    except ValueError:
        # If the string does not match our expectations, this will throw accordingly
        return GRID_DIMS[int(dim[0])][dim[1:]]
    if ret <= 0:
        raise ValueError(f'Dimensions must be bigger than 1 (got {ret})')
    return ret


def resolve_dims(grid_args: list) -> list:
    return [resolve_dim(dim) for dim in grid_args]


def gen_subscripts(int_dims: list) -> str:
    return "".join(f'[{d}]' for d in int_dims)


def resolve_check(check: dict, grids: dict):
    # Set defaults as needed
    if 'eps' not in check:
        check['eps'] = CHECK_DEF_EPS
    if 'stride' not in check:
        check['stride'] = CHECK_DEF_STRIDE
    # Resolve grids
    for grid in ('a', 'b'):
        # If either comparison reference is a known grid, resolve it and adopt its length
        gname = check[grid]
        if gname in grids:
            dims = resolve_dims(grids[gname]['dims'])
            check[grid] = f'&{gname}' + '[0]'*len(dims)
            tgt_len = np.product(dims)
            if 'len' in check:
                assert check['len'] == tgt_len, \
                       'Mismatching grid check lengths:' \
                       f'{tgt_len} ({grids[gname]}) vs {check["len"]}'
            else:
                check['len'] = tgt_len
    # Make sure we have a length now
    assert 'len' in check, f'Could not resolve length for check {check}'


def resolve_touches(grids: dict, stride: int = CHECK_DEF_STRIDE) -> dict:
    ret = {}
    for name, grid in grids.items():
        ret[name] = {'stride': stride}
        # Resolve grid
        dims = resolve_dims(grid['dims'])
        ret[name]['ptr'] = f'&{name}' + '[0]'*len(dims)
        ret[name]['len'] = np.product(dims)
    return ret


# Handles one level of nested array initialization.
def generate_array_level(int_dims: list, zero, pos: int = 0) -> str:
    # Handle degenerate scalar case
    if (len(int_dims) == 0):
        return str(np.random.normal(size=1)[0] if not zero else 0.0)
    elif pos == len(int_dims)-1:
        rand_doubles = np.random.normal(size=int_dims[-1]) if \
            not zero else np.zeros(shape=int_dims[-1])
        elems = [str(d) for d in rand_doubles]
        elems_fmt = ",\n".join([", ".join(elems[i:i + ELEMS_PER_ROW])
                               for i in range(0, len(elems), ELEMS_PER_ROW)])
    else:
        elems = [generate_array_level(int_dims, zero, pos+1) for _ in range(int_dims[pos])]
        elems_fmt = ', '.join(elems)
    return f'{{\n{indent(elems_fmt, " " * 4*(pos+1))}\n}}'


# Returns declaration and initialization separately
def generate_grids(grids: dict) -> (str, str):
    decls = []
    inits = []
    for name, args in grids.items():
        # First argument provides generation seed
        set_seed(args['seed'])
        int_dims = resolve_dims(args['dims'])
        subscripts = gen_subscripts(int_dims)
        attrs = (args['attrs'] + ' ') if 'attrs' in args else ''
        decls.append('extern __attribute__((visibility("default")))' +
                     f' {attrs}{ELEMTYPE} {name}{subscripts};')
        inits.append(f'{attrs}{ELEMTYPE} {name}{subscripts} =' +
                     f'{generate_array_level(int_dims, args["seed"] == 0)};')
    return '\n'.join(decls), '\n'.join(inits)


# Returns the instantiation of a parameter static class
def generate_ctstruct(grids: dict, prname='ct') -> str:
    body = []
    decls = []
    for name, args in grids.items():
        # First argument provides generation seed
        set_seed(args['seed'])
        int_dims = resolve_dims(args['dims']) if 'dims' in args else []
        subscripts = gen_subscripts(int_dims)
        body.append(f'{CTSTRUCT_FTYPE} {name}{subscripts} = ' +
                    f'{generate_array_level(int_dims, args["seed"] == 0)};')
        decls.append(f'{prname}::{name}{subscripts}')
    return CSTRUCT_FMT.format(prname=prname, body=indent("\n".join(body), " "*4),
                              dtype=CTSTRUCT_DTYPE, decls=", ".join(decls))


# Returns the instantiation of a parameter static class
def generate_cistruct(params: dict, prname='ci') -> str:
    body = []
    decls = []
    for lval, rval in params.items():
        body.append(f'{CISTRUCT_FTYPE} {lval} = {rval};')
        decls.append(f'{prname}::{lval}')
    return CSTRUCT_FMT.format(prname=prname, body=indent("\n".join(body), " "*4),
                              dtype=CISTRUCT_DTYPE, decls=", ".join(decls))


# Returns declaration and initialization separately
def generate_bundles(bundles: dict, grids: dict) -> str:
    decls = []
    for name, grid_names in bundles.items():
        int_dims = resolve_dims(grids[grid_names[0]]['dims'])
        if any(int_dims != resolve_dims(grids[g]['dims']) for g in grid_names[1:]):
            raise ValueError(f'Bundle {name} has mismatching grid dimensions')
        attrs = grids[grid_names[0]]['attrs']
        if any(attrs != grids[g]['attrs'] for g in grid_names[1:]):
            raise ValueError(f'Bundle {name} has mismatching attributes')
        attrs = (attrs + ' ') if attrs else ''
        decls.append(f'{attrs}{ELEMTYPE} (*{name}[{len(grid_names)}])' +
                     f'{gen_subscripts(int_dims)} = {{{", ".join("&" + g for g in grid_names)}}};')
    return '\n'.join(decls)


# Returns a code snippet performing a DMA out transfer
def generate_dma_out(dst_grid: tuple, src_grid: tuple, radius: int) -> str:
    ndim = len(dst_grid['dims'])
    assert ndim == 3 or ndim == 2, 'Only 2D and 3D grids supported'

    dst_dims = resolve_dims(dst_grid['dims'])
    src_dims = resolve_dims(src_grid['dims'])

    args = []
    subscripts = f'[{radius}][{radius}]'
    if ndim == 3:
        subscripts = f'[{radius} + i]{subscripts}'
    args.append(f'(void *)&({dst_grid["uid"]}{subscripts})')             # dst
    args.append(f'(void *)&({src_grid["uid"]}{subscripts})')             # src
    args.append(f'{src_dims[0] - radius * 2} * sizeof(double)')  # size
    args.append(f'{src_dims[0]} * sizeof(double)')               # src_stride
    args.append(f'{dst_dims[0]} * sizeof(double)')               # dst_stride
    args.append(f'{src_dims[1] - radius * 2}')                   # repeat
    args = ',\n'.join(args)

    dma_call = f'__rt_dma_start_2d(\n{indent(args, " "*4)}\n);'
    dma_transfer = f'{dma_call}\n'

    if ndim == 3:
        loop = '#pragma clang loop unroll(disable)\nfor (int i = 0; i < ' + \
            f'{src_dims[2] - radius * 2}; i++) {{\n{indent(dma_transfer, " "*4)}\n}}\n'
        return loop
    else:
        return dma_transfer


# Returns a code snippet performing a DMA in transfer
def generate_dma_in(dst_grid: tuple, src_grid: tuple, radius: int) -> str:
    ndim = len(dst_grid['dims'])
    assert ndim == 3 or ndim == 2, 'Only 2D and 3D grids supported'

    dst_dims = resolve_dims(dst_grid['dims'])
    src_dims = resolve_dims(src_grid['dims'])

    args = []
    subscripts = '[0][0]'
    if ndim == 3:
        subscripts = f'[i]{subscripts}'
    args.append(f'(void *)&({dst_grid["uid"]}{subscripts})')  # dst
    args.append(f'(void *)&({src_grid["uid"]}{subscripts})')  # src
    args.append(f'{dst_dims[0]} * sizeof(double)')    # size
    args.append(f'{src_dims[0]} * sizeof(double)')    # src_stride
    args.append(f'{dst_dims[0]} * sizeof(double)')    # dst_stride
    args.append(f'{dst_dims[1]}')                     # repeat
    args = ',\n'.join(args)

    dma_call = f'__rt_dma_start_2d(\n{indent(args, " "*4)}\n);'
    dma_transfer = f'{dma_call}\n'

    if ndim == 3:
        loop = '#pragma clang loop unroll(disable)\nfor (int i = 0; i < ' + \
            f'{dst_dims[2]}; i++) {{\n{indent(dma_transfer, " "*4)}\n}}\n'
        return loop
    else:
        return dma_transfer


# Returns a grid dictionary from the grids dictionary,
# where the key in the grids dictionary is appended to the value
# as the 'uid' field.
def get_grid(grids: dict, grid_uid: str) -> tuple:
    grid = grids[grid_uid]
    grid['uid'] = grid_uid
    return grid


def resolve_dma_transfers(transfers: list, radius: int) -> list:
    # Uniformize single transfer and multiple transfer cases
    if not isinstance(transfers[0], list):
        transfers = [transfers]
    # Expand bidirectional transfers into unidirectional transfers
    unidir_transfers = []
    for transfer in transfers:
        if len(transfer) < 3:
            unidir_transfers.append([*transfer, "in"])
            unidir_transfers.append([*transfer, "out"])
        else:
            unidir_transfers.append(transfer)
    # Add default radius if absent
    for transfer in unidir_transfers:
        if len(transfer) < 4:
            transfer.append(radius)
    return unidir_transfers


# Returns a code snippet performing DMA transfers
def generate_dma_transfers(grids: dict, transfers: list) -> str:
    s = ''
    for transfer in transfers:
        l1_grid_name, l3_grid_name, direction, radius = transfer
        l1_grid = get_grid(grids, l1_grid_name)
        l3_grid = get_grid(grids, l3_grid_name)
        if direction == 'out':
            s += generate_dma_out(l3_grid, l1_grid, radius)
        elif direction == 'in':
            s += generate_dma_in(l1_grid, l3_grid, radius)
        else:
            raise ValueError()
    s += '\n__rt_dma_wait_all();'
    return s


def main(cfg_file: str, tpl_file: str, program: str):
    # Load programs to generate from config
    with open(cfg_file) as f:
        progs = json.load(f)
    # Generate code for test program according to its config entry
    cfg = progs[program]
    grids = cfg['grids']
    cfg['datadecls'], cfg['datainits'] = generate_grids(grids)
    cfg['bundledecls'] = ""
    if 'bundles' in cfg:
        cfg['bundledecls'] = generate_bundles(cfg['bundles'], grids)
    ctgrids = CTSTRUCT_DEFAULT_GRIDS
    if 'ctgrids' in cfg:
        ctgrids.update(cfg['ctgrids'])
    cfg['ctgrids'] = generate_ctstruct(ctgrids)
    cfg['ciparams'] = ""
    if 'params' in cfg:
        cfg['ciparams'] = generate_cistruct(cfg['params'])
    if 'checks' not in cfg:
        cfg['checks'] = []
    for check in cfg['checks']:
        resolve_check(check, grids)
    cfg['touches'] = {}
    if 'touch' in cfg:
        touches = {grid_name: grids[grid_name] for grid_name in cfg['touch']}
        cfg['touches'] = resolve_touches(touches)
    cfg['dma_transfers'] = ''
    if 'dma' in cfg:
        transfers = resolve_dma_transfers(cfg['dma'], cfg['radius'])
        cfg['dma_transfers'] = generate_dma_transfers(grids, transfers)
    cfg["nbarriers"] = sum(k[0] for k in cfg['kernels'])
    cfg['indent'] = indent
    print(Template(filename=tpl_file).render(**cfg))


if __name__ == '__main__':
    main(*sys.argv[1:])
