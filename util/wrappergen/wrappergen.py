#!/usr/bin/env python3

# Copyright 2023 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Ryan Antonio <ryan.antonio@esat.kuleuven.be>

# -------------------------------------------------------
# This wrappergen is specific to configure the templates
# and wrappers towards the SNAX shell
# -------------------------------------------------------
from mako.lookup import TemplateLookup
from mako.template import Template
from jsonref import JsonRef
import hjson
import argparse
import os
import math


# Extract json file
def get_config(cfg_path: str):
    with open(cfg_path, "r") as jsonf:
        srcfull = jsonf.read()

    # Format hjson file
    cfg = hjson.loads(srcfull, use_decimal=True)
    cfg = JsonRef.replace_refs(cfg)
    return cfg


# Read template
def get_template(tpl_path: str) -> Template:
    dir_name = os.path.dirname(tpl_path)
    file_name = os.path.basename(tpl_path)
    tpl_list = TemplateLookup(directories=[dir_name], output_encoding="utf-8")
    tpl = tpl_list.get_template(file_name)
    return tpl


# Generate file
def gen_file(cfg, tpl, target_path: str, file_name: str) -> None:
    # Check if path exists first if no, create directory
    if not (os.path.exists(target_path)):
        os.makedirs(target_path)

    # Writing file
    file_path = target_path + file_name
    with open(file_path, "w") as f:
        f.write(str(tpl.render_unicode(cfg=cfg)))
    return


def gen_chisel_file(chisel_path, chisel_param, gen_path):
    # Call chisel environment and generate the system verilog file
    cmd = f" cd {chisel_path} && \
        mill Snax.runMain {chisel_param} {gen_path}"
    os.system(cmd)

    return


# Main function run and parsing
def main():
    # Parse all arguments
    parser = argparse.ArgumentParser(
        description="Wrapper generator for any file. \
            Inputs are simply the template and configuration files."
    )
    parser.add_argument(
        "--cfg_path",
        type=str,
        default="./",
        help="Points to the configuration file path",
    )
    parser.add_argument(
        "--tpl_path",
        type=str,
        default="./",
        help="Points to the streamer template file path",
    )
    parser.add_argument(
        "--chisel_path",
        type=str,
        default="./",
        help="Points to the streamer chisel source path",
    )
    parser.add_argument(
        "--gen_path", type=str, default="./", help="Points to the output directory"
    )

    # Get the list of parsing
    args = parser.parse_args()

    # Grab config and template then generate the combination of two
    cfg = get_config(args.cfg_path)

    # First grab all accelerator configurations
    num_cores = len(cfg["cluster"]["hives"][0]["cores"])
    cfg_cores = cfg["cluster"]["hives"][0]["cores"]

    # Cycle through each core and check if they have accelerator configs
    # Then dump them into a dictionary set
    num_core_w_acc = 0
    acc_cfgs = []

    for i in range(num_cores):
        if "snax_acc_cfg" in cfg_cores[i]:
            num_core_w_acc += 1
            acc_cfgs.append(cfg_cores[i]["snax_acc_cfg"].copy())

    # Placing the TCDM components again into accelerator configurations
    # Because they are part of the cluster-level configurations
    for i in range(len(acc_cfgs)):
        # TCDM configurations
        tcdm_data_width = cfg["cluster"]["data_width"]
        acc_cfgs[i]["tcdm_data_width"] = tcdm_data_width
        acc_cfgs[i]["tcdm_dma_data_width"] = cfg["cluster"]["dma_data_width"]
        tcdm_depth = (
            cfg["cluster"]["tcdm"]["size"]
            * 1024
            // cfg["cluster"]["tcdm"]["banks"]
            // 8
        )
        acc_cfgs[i]["tcdm_depth"] = tcdm_depth
        tcdm_num_banks = cfg["cluster"]["tcdm"]["banks"]
        acc_cfgs[i]["tcdm_num_banks"] = tcdm_num_banks
        tcdm_addr_width = tcdm_num_banks * tcdm_depth * (tcdm_data_width // 8)
        tcdm_addr_width = int(math.log2(tcdm_addr_width))
        acc_cfgs[i]["tcdm_addr_width"] = tcdm_addr_width
        # Chisel parameter tag names
        acc_cfgs[i]["tag_name"] = acc_cfgs[i]["snax_acc_name"]
        # Pre-calculate streamer CSRs
        if (acc_cfgs[i]["snax_streamer_cfg"]["temporal_addrgen_unit_params"]["share_temp_addr_gen_loop_bounds"]):  # noqa: E501
            num_loop_dim = acc_cfgs[i]["snax_streamer_cfg"]["temporal_addrgen_unit_params"]["loop_dim"][0]  # noqa: E501
            num_data_mover = len(acc_cfgs[i]["snax_streamer_cfg"]["data_reader_params"]["tcdm_ports_num"]) + len(acc_cfgs[i]["snax_streamer_cfg"]["data_writer_params"]["tcdm_ports_num"])  # noqa: E501
            num_dmove_x_loop_dim = num_data_mover * num_loop_dim
            num_spatial_dim = sum(acc_cfgs[i]["snax_streamer_cfg"]["data_reader_params"]["spatial_dim"]) + sum(acc_cfgs[i]["snax_streamer_cfg"]["data_writer_params"]["spatial_dim"])  # noqa: E501
            streamer_csr_num = num_loop_dim + num_dmove_x_loop_dim + num_data_mover + num_spatial_dim + 1 + 1  # noqa: E501
        else:
            num_loop_dim = sum(acc_cfgs[i]["snax_streamer_cfg"]["temporal_addrgen_unit_params"]["loop_dim"])  # noqa: E501
            num_data_mover = len(acc_cfgs[i]["snax_streamer_cfg"]["data_reader_params"]["tcdm_ports_num"]) + len(acc_cfgs[i]["snax_streamer_cfg"]["data_writer_params"]["tcdm_ports_num"])  # noqa: E501
            num_spatial_dim = sum(acc_cfgs[i]["snax_streamer_cfg"]["data_reader_params"]["spatial_dim"]) + sum(acc_cfgs[i]["snax_streamer_cfg"]["data_writer_params"]["spatial_dim"])  # noqa: E501
            streamer_csr_num = 2 * num_loop_dim + num_data_mover + num_spatial_dim + 1 + 1  # noqa: E501
        acc_cfgs[i]["streamer_csr_num"] = streamer_csr_num

    # Generate template out of given configurations
    # TODO: Make me a generation for the necessary files!
    for i in range(len(acc_cfgs)):
        # First part is for chisel generation
        # Generate the parameter files for chisel streamer generation
        chisel_target_path = args.chisel_path + "src/main/scala/snax/streamer/"
        file_name = "StreamParamGen.scala"
        tpl_scala_param_file = args.tpl_path + "stream_param_gen.scala.tpl"
        tpl_scala_param = get_template(tpl_scala_param_file)
        gen_file(
            cfg=acc_cfgs[i],
            tpl=tpl_scala_param,
            target_path=chisel_target_path,
            file_name=file_name,
        )

        # CSR manager scala parameter generation
        chisel_target_path = args.chisel_path + "src/main/scala/snax/csr_manager/"
        file_name = "CsrManParamGen.scala"
        tpl_scala_param_file = args.tpl_path + "csrman_param_gen.scala.tpl"
        tpl_scala_param = get_template(tpl_scala_param_file)
        gen_file(
            cfg=acc_cfgs[i],
            tpl=tpl_scala_param,
            target_path=chisel_target_path,
            file_name=file_name,
        )

        # This is for RTL wrapper and chisel generation
        # This first one generates the CSR manager wrapper
        rtl_target_path = args.gen_path + acc_cfgs[i]["snax_acc_name"] + "/"
        file_name = acc_cfgs[i]["snax_acc_name"] + "_csrman_wrapper.sv"
        tpl_csrman_wrapper_file = args.tpl_path + "snax_csrman_wrapper.sv.tpl"
        tpl_csrman_wrapper = get_template(tpl_csrman_wrapper_file)
        gen_file(
            cfg=acc_cfgs[i],
            tpl=tpl_csrman_wrapper,
            target_path=rtl_target_path,
            file_name=file_name,
        )

        # This first one generates the streamer wrapper
        file_name = acc_cfgs[i]["snax_acc_name"] + "_streamer_wrapper.sv"
        tpl_streamer_wrapper_file = args.tpl_path + "snax_streamer_wrapper.sv.tpl"
        tpl_streamer_wrapper = get_template(tpl_streamer_wrapper_file)
        gen_file(
            cfg=acc_cfgs[i],
            tpl=tpl_streamer_wrapper,
            target_path=rtl_target_path,
            file_name=file_name,
        )

        # This generates the top wrapper
        file_name = acc_cfgs[i]["snax_acc_name"] + "_wrapper.sv"
        tpl_rtl_wrapper_file = args.tpl_path + "snax_acc_wrapper.sv.tpl"
        tpl_rtl_wrapper = get_template(tpl_rtl_wrapper_file)
        gen_file(
            cfg=acc_cfgs[i],
            tpl=tpl_rtl_wrapper,
            target_path=rtl_target_path,
            file_name=file_name,
        )

        # Generate chisel component using chisel generation script
        gen_chisel_file(
            chisel_path=args.chisel_path,
            chisel_param="snax.csr_manager.CsrManagerGen",
            gen_path=rtl_target_path,
        )

        # Generate chisel component using chisel generation script
        gen_chisel_file(
            chisel_path=args.chisel_path,
            chisel_param="snax.streamer.StreamerTopGen",
            gen_path=rtl_target_path,
        )

    print("Generation done!")


if __name__ == "__main__":
    main()
