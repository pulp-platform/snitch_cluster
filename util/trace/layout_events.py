#!/usr/bin/env python3
# Copyright 2020 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# This script takes a CSV of events, compatible with the CSV format produced by
# `perf_csv.py`, and creates another CSV of events, where the events are reordered based
# on a layout CSV file and labeled for viewing with the `eventvis.py` script.
#
# Following is an example CSV of events as output by `perf_csv.py`,
# which could be fed as input to this tool:
#
#  , 0_tstart, 0_tend, 1_tstart, 1_tend, 2_tstart, 2_tend
# 0,      334,  10940,    10940,  10945,    10945,  10995
# 1,     2654,  11061,    11061,  11172,    11172,  11189
# 2,     2654,  11061,    11061,  11172,    11172,  11190
# 3,     2654,  11061,    11061,  11172,    11172,  11191
#
# This is an example layout CSV, which could be fed to the tool
# together with the previous CSV:
#
#             , dma-in, compute, dma-out
#            0,     0,        ,
# "range(1,3)",      ,       1,
#            9,      ,        ,        2
#
# To produce the following output:
#
#  , dma_in,      , compute,      , dma_out,
# 0,    334, 10940,        ,      ,        ,
# 1,       ,      ,   11061, 11172,        ,
# 2,       ,      ,   11061, 11172,        ,
# 3,       ,      ,        ,      ,   11172, 11191
#
# The output CSV can be fed directly to `eventvis.py`.
#
# Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

import sys
import argparse
import csv
import pandas as pd
from math import isnan


def main():
    # Argument parsing
    parser = argparse.ArgumentParser()
    parser.add_argument(
        'csv',
        metavar='<csv>',
        help='Input CSV file')
    parser.add_argument(
        'layout',
        metavar='<layout>',
        help='Layout CSV file')
    parser.add_argument(
        '--num-clusters',
        type=int,
        default=1,
        help='Number of clusters')
    parser.add_argument(
        '-o',
        '--output',
        metavar='<output>',
        nargs='?',
        default='trace.csv',
        help='Output CSV file')
    args = parser.parse_args()

    # Read input CSV
    df = pd.read_csv(args.csv)

    # Output CSV data
    data = []
    columns = []

    # Open layout CSV
    with open(args.layout) as layout_f:
        layout_reader = csv.reader(layout_f, delimiter=',')

        # Get region labels from layout header
        regions = [label for label in next(layout_reader) if label and not label.isspace()]

        # Generate output columns: appropriately spaced region labels
        columns = ['hartid'] + [val for label in regions for val in [label, '']]

        # Iterate layout rows
        for row in layout_reader:

            # First entry in row is a hart ID or a Python expression
            # which generates a list of hart IDs
            expr = row[0]
            code = compile(expr, "<string>", "eval")
            tids = eval(code, {}, {'num_clusters': args.num_clusters})
            if type(tids) == int:
                tids = [tids]

            # Iterate hart IDs
            for tid in tids:

                # Start output row with hart ID
                orow = [tid]

                # Iterate all other cells in layout row (indices of regions to take)
                for cell in row[1:]:

                    # If the cell is not empty, get start and end times
                    # of the region from the input CSV and append them to the
                    # output row. Otherwise, leave cells empty.
                    if cell and not cell.isspace():
                        reg_idx = int(cell)
                        row_idx = tid
                        col_idx = 1 + reg_idx * 2
                        assert row_idx < df.shape[0], f'Hart ID {row_idx} out of bounds'
                        assert (col_idx + 1) < df.shape[1],\
                            f'Region index {reg_idx} out of bounds for hart {tid}'
                        assert not isnan(df.iat[row_idx, col_idx]),\
                            (f'Region {reg_idx} looks empty for hart {tid},'
                             f'check whether it was simulated')
                        orow.append(int(df.iat[row_idx, col_idx]))
                        orow.append(int(df.iat[row_idx, col_idx + 1]))
                    else:
                        orow.append('')
                        orow.append('')

                data.append(orow)

    # Create output dataframe and write to CSV
    df = pd.DataFrame(data, columns=columns)
    df.set_index('hartid', inplace=True)
    df.sort_index(axis='index', inplace=True)
    df.index.name = None
    df.to_csv(args.output)


if __name__ == '__main__':
    sys.exit(main())
