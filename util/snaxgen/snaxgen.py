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


# Call chisel environment and generate the system verilog file
def gen_chisel_file(chisel_path, chisel_param, gen_path):
    cmd = f" cd {chisel_path} && \
        mill Snax.runMain {chisel_param} {gen_path}"
    print(f"Running command: {cmd}")
    if os.system(cmd) != 0:
        raise ChildProcessError('Chisel generation error. ')

    return


# Count number of CSRs for streamer
def streamer_csr_num(acc_cfgs):
    # Regardless if shared or not, it is the same total
    # This is the total number of loop dimension registers
    num_loop_dim = sum(
        acc_cfgs["snax_streamer_cfg"]["temporal_addrgen_unit_params"]["loop_dim"]  # noqa: E501
    )

    # Calculation of data movers
    num_data_reader = 0
    num_data_writer = 0
    num_data_reader_writer = 0
    num_data_mover = 0

    # Calculation of spatial dimensions per data mover
    num_spatial_reader = 0
    num_spatial_writer = 0
    num_spatial_reader_writer = 0
    num_spatial_dim = 0

    if "data_reader_params" in acc_cfgs["snax_streamer_cfg"]:
        num_data_reader = len(
            acc_cfgs["snax_streamer_cfg"]["data_reader_params"]["tcdm_ports_num"]  # noqa: E501
        )
        num_spatial_reader = sum(
            acc_cfgs["snax_streamer_cfg"]["data_reader_params"]["spatial_dim"]
        )

    if "data_writer_params" in acc_cfgs["snax_streamer_cfg"]:
        num_data_writer = len(
            acc_cfgs["snax_streamer_cfg"]["data_writer_params"]["tcdm_ports_num"]  # noqa: E501
        )
        num_spatial_writer = sum(
            acc_cfgs["snax_streamer_cfg"]["data_writer_params"]["spatial_dim"]
        )

    if "data_reader_writer_params" in acc_cfgs["snax_streamer_cfg"]:
        num_data_reader_writer = len(
            acc_cfgs["snax_streamer_cfg"]["data_reader_writer_params"]["tcdm_ports_num"]  # noqa: E501
        )
        num_spatial_reader_writer = sum(
            acc_cfgs["snax_streamer_cfg"]["data_reader_writer_params"]["spatial_dim"]  # noqa: E501
        )

    # This sets the total number of base pointers
    num_data_mover = num_data_reader + num_data_writer \
        + num_data_reader_writer * 2
    num_spatial_dim = (
        num_spatial_reader + num_spatial_writer + num_spatial_reader_writer * 2
    )

    if acc_cfgs["snax_streamer_cfg"]["temporal_addrgen_unit_params"][
        "share_temp_addr_gen_loop_bounds"
    ]:
        # num_dmove_x_loop_dim is the total number of stride registers
        num_dmove_x_loop_dim = num_data_mover * num_loop_dim
        streamer_csr_num = (
            num_loop_dim
            + num_dmove_x_loop_dim
            + num_spatial_dim
            + num_data_mover
            + 1
            + 1
            + 1
        )
    else:
        # 2x num_loop_dim is because 1 is for the loop bound
        # while the other is for number of strides
        streamer_csr_num = (
            2 * num_loop_dim + num_spatial_dim + num_data_mover + 1 + 1 + 1
        )  # noqa: E501

    return streamer_csr_num


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
        "--test_path",
        type=str,
        default="./",
        help="Points to the testharness path",
    )
    parser.add_argument(
        "--chisel_path",
        type=str,
        default="./",
        help="Points to the streamer chisel source path",
    )
    parser.add_argument(
        "--bypass_accgen",
        type=str,
        default="false",
        help="Bypass default accelerator generation",
    )
    parser.add_argument(
        "--gen_path", type=str, default="./",
        help="Points to the output directory"
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

    # ---------------------------------------
    # Generate the accelerator specific wrappers
    # ---------------------------------------
    print("------------------------------------------------")
    print("    Generating accelerator specific wrappers")
    print("------------------------------------------------")

    if (args.bypass_accgen == "false"):
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
            acc_cfgs[i]["tcdm_dma_data_width"] = \
                cfg["cluster"]["dma_data_width"]
            tcdm_depth = (
                cfg["cluster"]["tcdm"]["size"]
                * 1024
                // cfg["cluster"]["tcdm"]["banks"]
                // 8
            )
            acc_cfgs[i]["tcdm_depth"] = tcdm_depth
            tcdm_num_banks = cfg["cluster"]["tcdm"]["banks"]
            acc_cfgs[i]["tcdm_num_banks"] = tcdm_num_banks
            tcdm_addr_width = tcdm_num_banks * \
                tcdm_depth * (tcdm_data_width // 8)
            tcdm_addr_width = int(math.log2(tcdm_addr_width))
            acc_cfgs[i]["tcdm_addr_width"] = tcdm_addr_width
            # Chisel parameter tag names
            acc_cfgs[i]["tag_name"] = acc_cfgs[i]["snax_acc_name"]
            # Calculating number of registers for streamer
            acc_cfgs[i]["streamer_csr_num"] = streamer_csr_num(acc_cfgs[i])

        # Generate template out of given configurations
        for i in range(len(acc_cfgs)):
            # First part is for chisel generation
            # Generate the parameter files for chisel streamer generation
            chisel_target_path = args.chisel_path + \
                "src/main/scala/snax/streamer/"
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
            if not acc_cfgs[i].get("snax_disable_csr_manager", False):
                chisel_target_path = args.chisel_path + \
                    "src/main/scala/snax/csr_manager/"
                file_name = "CsrManParamGen.scala"
                tpl_scala_param_file = args.tpl_path + \
                    "csrman_param_gen.scala.tpl"
                tpl_scala_param = get_template(tpl_scala_param_file)
                gen_file(
                    cfg=acc_cfgs[i],
                    tpl=tpl_scala_param,
                    target_path=chisel_target_path,
                    file_name=file_name,
                )

            rtl_target_path = args.gen_path + \
                acc_cfgs[i]["snax_acc_name"] + "/"

            # This is for RTL wrapper and chisel generation
            # This first one generates the CSR manager wrapper
            if not acc_cfgs[i].get("snax_disable_csr_manager", False):
                file_name = acc_cfgs[i]["snax_acc_name"] + "_csrman_wrapper.sv"
                tpl_csrman_wrapper_file = args.tpl_path + \
                    "snax_csrman_wrapper.sv.tpl"
                tpl_csrman_wrapper = get_template(tpl_csrman_wrapper_file)
                gen_file(
                    cfg=acc_cfgs[i],
                    tpl=tpl_csrman_wrapper,
                    target_path=rtl_target_path,
                    file_name=file_name,
                )

            # This first one generates the streamer wrapper
            file_name = acc_cfgs[i]["snax_acc_name"] + "_streamer_wrapper.sv"
            tpl_streamer_wrapper_file = args.tpl_path + "snax_streamer_wrapper.sv.tpl"  # noqa: E501
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
            if not acc_cfgs[i].get("snax_disable_csr_manager", False):
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

        print("Generation of accelerator specific wrappers done!")
    else:
        print("Skipping wrapper generation!")

    # ---------------------------------------
    # Generate SNAX Chisel Accelerators
    # ---------------------------------------
    # TODO: We need to improve this when Xyi is back
    # refactor the accelerator and XDMA generation
    # but the idea is that it needs to come from the
    # configuration file only
    print("------------------------------------------------")
    print("    Generate SNAX Chisel Accelerators")
    print("------------------------------------------------")
    for i in range(len(acc_cfgs)):
        chisel_acc_path = args.chisel_path + "../chisel_acc"
        rtl_target_path = args.gen_path + acc_cfgs[i]["snax_acc_name"] + "/"

        if (acc_cfgs[i]["snax_acc_name"] == "snax_streamer_gemmX"):
            gen_chisel_file(
                        chisel_path=chisel_acc_path,
                        chisel_param="snax_acc.gemmx.BlockGemmRescaleSIMD",
                        gen_path=rtl_target_path,
                    )
        elif (acc_cfgs[i]["snax_acc_name"] == "snax_streamer_gemm_add_c"):
            gen_chisel_file(
                        chisel_path=chisel_acc_path,
                        chisel_param="snax_acc.gemm.BlockGemm",
                        gen_path=rtl_target_path,
                    )
        elif (acc_cfgs[i]["snax_acc_name"] == "snax_data_reshuffler"):
            gen_chisel_file(
                        chisel_path=chisel_acc_path,
                        chisel_param="snax_acc.reshuffle.Reshuffler",
                        gen_path=rtl_target_path,
                    )
        else:
            print("Nothing to generate ")

    # ---------------------------------------
    # Generate xdma for the whole cluster
    # ---------------------------------------
    print("------------------------------------------------")
    print("    Generate xDMA")
    print("------------------------------------------------")
    snax_xdma_cfg = None
    for i in range(num_cores):
        if "snax_xdma_cfg" in cfg_cores[i]:
            snax_xdma_cfg = cfg_cores[i]["snax_xdma_cfg"]
    if (snax_xdma_cfg is not None):
        tpl_rtl_wrapper_file = args.tpl_path + "snax_xdma_wrapper.sv.tpl"

        tpl_rtl_wrapper = get_template(tpl_rtl_wrapper_file)

        gen_file(
            cfg=cfg["cluster"],
            tpl=tpl_rtl_wrapper,
            target_path=args.gen_path + cfg["cluster"]["name"] + "_xdma/",
            file_name=cfg["cluster"]["name"] + "_xdma_wrapper.sv",
        )

        xdma_extension_arg = ""
        for key, value in snax_xdma_cfg.items():
            if key.startswith("Has"):
                xdma_extension_arg += f" --{key} {value}"

        gen_chisel_file(
            chisel_path=args.chisel_path,
            chisel_param="snax.xdma.xdmaTop.xdmaTopGen",
            gen_path=" --clusterName " + str(cfg["cluster"]["name"]) +
            " --tcdmDataWidth " + str(cfg["cluster"]["data_width"]) +
            " --axiDataWidth " + str(cfg["cluster"]["dma_data_width"]) +
            " --axiAddrWidth " + str(cfg["cluster"]["addr_width"]) +
            " --tcdmSize " + str(cfg["cluster"]["tcdm"]["size"]) +
            " --readerDimension " +
            str(snax_xdma_cfg["reader_agu_dimension"]) +
            " --writerDimension " +
            str(snax_xdma_cfg["writer_agu_dimension"]) +
            " --readerBufferDepth " + str(snax_xdma_cfg["reader_buffer"]) +
            " --writerBufferDepth " + str(snax_xdma_cfg["writer_buffer"]) +
            xdma_extension_arg +
            " --hw-target-dir " + args.gen_path +
            cfg["cluster"]["name"] + "_xdma/" +
            " --sw-target-dir " + args.gen_path + "../sw/snax/xdma"
        )

    # ---------------------------------------
    # Generation of testharness
    # ---------------------------------------
    if ("enable_debug" not in cfg["cluster"]):
        cfg["cluster"]["enable_debug"] = False

    if ("iso_crossings" not in cfg["cluster"]["timing"]):
        cfg["cluster"]["timing"]["iso_crossings"] = False

    if ("sram_cfg_expose" not in cfg["cluster"]):
        cfg["cluster"]["sram_cfg_expose"] = False

    test_target_path = args.test_path
    file_name = "testharness.sv"
    tpl_testharness_file = args.tpl_path + "testharness.sv.tpl"  # noqa: E501
    tpl_testharness = get_template(tpl_testharness_file)
    gen_file(
        cfg=cfg,
        tpl=tpl_testharness,
        target_path=test_target_path,
        file_name=file_name,
    )
    print("Testharness generation done!")


if __name__ == "__main__":
    main()
