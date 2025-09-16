#!/usr/bin/env python3
# Copyright 2020 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import argparse
import json5
import pathlib
import sys
import re
from jsonref import JsonRef
from cluster import SnitchCluster
import mako


def write_template(tpl_path, output_path, **kwargs):

    # Compile a regex to trim trailing whitespaces on lines.
    re_trailws = re.compile(r'[ \t\r]+$', re.MULTILINE)

    if tpl_path:
        tpl_path = pathlib.Path(tpl_path).absolute()
        if tpl_path.exists():
            tpl = mako.template.Template(filename=str(tpl_path))
            with open(output_path, "w") as file:
                try:
                    code = tpl.render_unicode(**kwargs)
                except Exception:
                    print(mako.exceptions.text_error_template().render())
                    raise
                code = re_trailws.sub("", code)
                file.write(code)
        else:
            raise FileNotFoundError


def main():
    """Generate a Snitch cluster TB and all corresponding configuration files."""
    parser = argparse.ArgumentParser(prog="clustergen")
    parser.add_argument("--clustercfg",
                        "-c",
                        metavar="file",
                        type=argparse.FileType('r'),
                        required=True,
                        help="A cluster configuration file")
    parser.add_argument("--output",
                        "-o",
                        type=pathlib.Path,
                        required=True,
                        help="Output file path")
    parser.add_argument("--template",
                        metavar="template",
                        help="Name of the template file")

    args = parser.parse_args()

    # Read and parse JSON5 file
    with args.clustercfg as file:
        try:
            obj = json5.loads(file.read())  # JSON5 natively supports hex & comments
            obj = JsonRef.replace_refs(obj)

        except ValueError:
            raise SystemExit(sys.exc_info()[1])

    cluster = SnitchCluster(obj)

    ####################
    # Generic template #
    ####################

    kwargs = {
        "disclaimer": cluster.DISCLAIMER,
        "cfg": cluster.cfg,
    }

    if args.template:
        write_template(args.template, args.output, **kwargs)


if __name__ == "__main__":
    main()
