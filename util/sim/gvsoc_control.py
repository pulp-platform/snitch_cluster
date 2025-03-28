#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Author: Germain Haugou <haugoug@iis.ee.ethz.ch>

import gvsoc.gvsoc_control
import struct


def parse_args(parser, args):
    parser.add_argument('--ipc', type=str, help="IPC socket files")


def handle_commands(gv, tx_fd, rx_fd):

    axi = gvsoc.gvsoc_control.Router(gv, path='**/chip/soc/narrow_axi')

    gv.run()

    while True:
        data = rx_fd.read(8)
        if not data:
            return

        command = struct.unpack('=Q', data)[0]

        if command == 2:
            data = rx_fd.read(16)
            addr, mask32, exp32 = struct.unpack('=QLL', data)

            retval = gv.join()
            data = struct.pack('=L', retval)
            tx_fd.write(data)

        elif command == 0:
            data = rx_fd.read(16)
            addr, length = struct.unpack('=QQ', data)
            data = axi.mem_read(addr, length)
            tx_fd.write(data)

        elif command == 1:
            data = rx_fd.read(16)
            addr, length = struct.unpack('=QQ', data)
            data = rx_fd.read(length)
            axi.mem_write(addr, data)
            data = struct.pack('=L', 0)
            tx_fd.write(data)
            pass


def target_control(args, gv=None):
    rx, tx = args.ipc.split(',')

    rx_fd = open(rx, 'rb', buffering=0)
    tx_fd = open(tx, 'wb', buffering=0)

    handle_commands(gv, tx_fd, rx_fd)

    return 0
