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
import json
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


def read_schema(path):
    """Read a single schema file and return the parsed JSON content.
    Aborts if the JSON file could not be decoed."""
    with open(path, "r") as f:
        try:
            schema = json.load(f)
        except json.decoder.JSONDecodeError as e:
            exit("Invalid schema file: {}".format(e))
    return schema


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
        sbt \"runMain {chisel_param} {gen_path}\" "
    print(f"Running command: {cmd}")
    if os.system(cmd) != 0:
        raise ChildProcessError("Chisel generation error. ")

    return


# Count number of CSRs for streamer
def streamer_csr_num(acc_cfgs):
    # Regardless if shared or not, it is the same total
    # This is the total number of loop dimension registers
    num_t_loop_dim = 0
    if "data_reader_params" in acc_cfgs["snax_streamer_cfg"]:
        num_t_loop_dim += sum(
            acc_cfgs["snax_streamer_cfg"]["data_reader_params"]["temporal_dim"]
        )

    if "data_writer_params" in acc_cfgs["snax_streamer_cfg"]:
        num_t_loop_dim += sum(
            acc_cfgs["snax_streamer_cfg"]["data_writer_params"]["temporal_dim"]
        )

    if "data_reader_writer_params" in acc_cfgs["snax_streamer_cfg"]:
        num_t_loop_dim += sum(
            acc_cfgs["snax_streamer_cfg"]["data_reader_writer_params"]["temporal_dim"]
        )

    num_s_loop_dim = 0
    if "data_reader_params" in acc_cfgs["snax_streamer_cfg"]:
        num_s_loop_dim += sum(
            (
                len(i)
                for i in acc_cfgs["snax_streamer_cfg"]["data_reader_params"][
                    "spatial_bounds"
                ]
            )
        )
    if "data_writer_params" in acc_cfgs["snax_streamer_cfg"]:
        num_s_loop_dim += sum(
            (
                len(i)
                for i in acc_cfgs["snax_streamer_cfg"]["data_writer_params"][
                    "spatial_bounds"
                ]
            )
        )
    if "data_reader_writer_params" in acc_cfgs["snax_streamer_cfg"]:
        num_s_loop_dim += sum(
            (
                len(i)
                for i in acc_cfgs["snax_streamer_cfg"]["data_reader_writer_params"][
                    "spatial_bounds"
                ]
            )
        )

    address_remapper_csr_num = 0
    if (
        "data_reader_params" in acc_cfgs["snax_streamer_cfg"]
        and "tcdm_logic_word_size"
        in acc_cfgs["snax_streamer_cfg"]["data_reader_params"]
    ):
        address_remapper_csr_num += len(
            acc_cfgs["snax_streamer_cfg"]["data_reader_params"]["tcdm_logic_word_size"]
        )
    if (
        "data_writer_params" in acc_cfgs["snax_streamer_cfg"]
        and "tcdm_logic_word_size"
        in acc_cfgs["snax_streamer_cfg"]["data_writer_params"]
    ):
        address_remapper_csr_num += len(
            acc_cfgs["snax_streamer_cfg"]["data_writer_params"]["tcdm_logic_word_size"]
        )
    if (
        "data_reader_writer_params" in acc_cfgs["snax_streamer_cfg"]
        and "tcdm_logic_word_size"
        in acc_cfgs["snax_streamer_cfg"]["data_reader_writer_params"]
    ):
        address_remapper_csr_num += len(
            acc_cfgs["snax_streamer_cfg"]["data_reader_writer_params"][
                "tcdm_logic_word_size"
            ]
        )

    # Calculation of data movers
    num_data_reader = 0
    num_data_writer = 0
    num_data_reader_writer = 0
    num_data_mover = 0

    if "data_reader_params" in acc_cfgs["snax_streamer_cfg"]:
        num_data_reader = len(
            acc_cfgs["snax_streamer_cfg"]["data_reader_params"][
                "num_channel"
            ]  # noqa: E501
        )

    if "data_writer_params" in acc_cfgs["snax_streamer_cfg"]:
        num_data_writer = len(
            acc_cfgs["snax_streamer_cfg"]["data_writer_params"][
                "num_channel"
            ]  # noqa: E501
        )

    if "data_reader_writer_params" in acc_cfgs["snax_streamer_cfg"]:
        num_data_reader_writer = len(
            acc_cfgs["snax_streamer_cfg"]["data_reader_writer_params"][
                "num_channel"
            ]  # noqa: E501
        )

    # This sets the total number of base pointers
    num_data_mover = num_data_reader + num_data_writer + num_data_reader_writer

    num_configurable_channel = 0

    if "data_reader_params" in acc_cfgs["snax_streamer_cfg"]:
        if (
            "configurable_channel"
            in acc_cfgs["snax_streamer_cfg"]["data_reader_params"]
        ):
            num_configurable_channel += sum(
                acc_cfgs["snax_streamer_cfg"]["data_reader_params"][
                    "configurable_channel"
                ]
            )
    if "data_writer_params" in acc_cfgs["snax_streamer_cfg"]:
        if (
            "configurable_channel"
            in acc_cfgs["snax_streamer_cfg"]["data_writer_params"]
        ):
            num_configurable_channel += sum(
                acc_cfgs["snax_streamer_cfg"]["data_writer_params"][
                    "configurable_channel"
                ]
            )
    if "data_reader_writer_params" in acc_cfgs["snax_streamer_cfg"]:
        if (
            "configurable_channel"
            in acc_cfgs["snax_streamer_cfg"]["data_reader_writer_params"]
        ):
            num_configurable_channel += sum(
                acc_cfgs["snax_streamer_cfg"]["data_reader_writer_params"][
                    "configurable_channel"
                ]
            )

    streamer_csr_num = (
        # Total temporal loop dimensions and strides
        2 * num_t_loop_dim  # Number of temporal strides and loopbounds
        + num_s_loop_dim  # Number of spatial strides
        + 2 * num_data_mover  # Number of base pointers, 2 for each
        + num_configurable_channel  # Number of configurable channels
        + address_remapper_csr_num  # Number of address remapper
        + 1  # Performance counter
        + 1  # Busy register
        + 1  # Start register
    )

    # transpose csr
    if "has_transpose" in acc_cfgs["snax_streamer_cfg"]:
        if acc_cfgs["snax_streamer_cfg"]["has_transpose"]:
            streamer_csr_num += 2

    if "has_C_broadcast" in acc_cfgs["snax_streamer_cfg"]:
        if acc_cfgs["snax_streamer_cfg"]["has_C_broadcast"]:
            streamer_csr_num += 1

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
        "--gen_path", type=str, default="./", help="Points to the output directory"
    )
    parser.add_argument(
        "--get_bender_targets",
        action="store_true",
        help="Get the bender targets for the whole system",
    )
    parser.add_argument(
        "--disable_header_gen",
        type=str,
        default="false",
        help="Disable the generation of header files for the streamer.",
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

    # For generating all bender targets
    if args.get_bender_targets:

        def get_bender_targets(cfg):
            targets = []
            # If cfg is dictionary, then first check if it has
            # bender_target, then iterate over the rest
            if isinstance(cfg, dict):
                for name, content in cfg.items():
                    if name == "bender_target":
                        targets.extend(content)
                    else:
                        targets.extend(get_bender_targets(content))
            # If cfg is a list, then iterate over the list
            elif isinstance(cfg, list):
                for item in cfg:
                    targets.extend(get_bender_targets(item))
            # Return the list of targets with removing duplicates
            return list(set(targets))

        bender_targets = get_bender_targets(cfg)
        for i in bender_targets:
            print(" -t " + i, end="")
        print()
        return

    print("------------------------------------------------")
    print("    Generating accelerator specific wrappers    ")
    print("------------------------------------------------")

    if args.bypass_accgen == "false":
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
            # Calculating number of registers for streamer
            acc_cfgs[i]["streamer_csr_num"] = streamer_csr_num(acc_cfgs[i])

        # Generate template out of given configurations
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
            if not acc_cfgs[i].get("snax_disable_csr_manager", False):
                chisel_target_path = (
                    args.chisel_path + "src/main/scala/snax/csr_manager/"
                )
                file_name = "CsrManParamGen.scala"
                tpl_scala_param_file = args.tpl_path + "csrman_param_gen.scala.tpl"
                tpl_scala_param = get_template(tpl_scala_param_file)
                gen_file(
                    cfg=acc_cfgs[i],
                    tpl=tpl_scala_param,
                    target_path=chisel_target_path,
                    file_name=file_name,
                )

            rtl_target_path = args.gen_path + acc_cfgs[i]["snax_acc_name"] + "/"

            # This is for RTL wrapper and chisel generation
            # This first one generates the CSR manager wrapper
            if not acc_cfgs[i].get("snax_disable_csr_manager", False):
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
            tpl_streamer_wrapper_file = (
                args.tpl_path + "snax_streamer_wrapper.sv.tpl"
            )  # noqa: E501
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
                chisel_param="snax.streamer.StreamerGen",
                gen_path=rtl_target_path,
            )

            if args.disable_header_gen == "false":
                # Generate headerfile of streamer
                gen_chisel_file(
                    chisel_path=args.chisel_path,
                    chisel_param="snax.streamer.StreamerHeaderFileGen",
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

        if acc_cfgs[i]["snax_acc_name"] == "snax_streamer_gemmX":
            if not (
                "snax_gemmx_tile_size" in acc_cfgs[i]
                and "snax_gemmx_mesh_row" in acc_cfgs[i]
                and "snax_gemmx_mesh_col" in acc_cfgs[i]
                and "with_pipeline" in acc_cfgs[i]
            ):
                raise ValueError(
                    "Missing gemmX configuration. \n"
                    "Please set snax_gemmx_mesh_row, snax_gemmx_mesh_col, "
                    "snax_gemmx_tile_size, with_pipeline"
                )
            gen_chisel_file(
                chisel_path=chisel_acc_path,
                chisel_param="snax_acc.gemmx.BlockGemmRescaleSIMDGen "
                + " --meshRow "
                + str(acc_cfgs[i]["snax_gemmx_mesh_row"])
                + " --meshCol "
                + str(acc_cfgs[i]["snax_gemmx_mesh_col"])
                + " --tileSize "
                + str(acc_cfgs[i]["snax_gemmx_tile_size"])
                + " --withPipeline "
                + str(acc_cfgs[i]["with_pipeline"]),
                gen_path=rtl_target_path,
            )
        elif acc_cfgs[i]["snax_acc_name"] == "snax_streamer_gemm_add_c":
            gen_chisel_file(
                chisel_path=chisel_acc_path,
                chisel_param="snax_acc.gemm.BlockGemm",
                gen_path=rtl_target_path,
            )
        elif acc_cfgs[i]["snax_acc_name"] == "snax_data_reshuffler":
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
    if snax_xdma_cfg is not None:
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
            gen_path=" --clusterName "
            + str(cfg["cluster"]["name"])
            + " --tcdmDataWidth "
            + str(cfg["cluster"]["data_width"])
            + " --axiDataWidth "
            + str(cfg["cluster"]["dma_data_width"])
            + " --axiAddrWidth "
            + str(cfg["cluster"]["addr_width"])
            + " --tcdmSize "
            + str(cfg["cluster"]["tcdm"]["size"])
            + " --readerSpatialBounds "
            + str(snax_xdma_cfg["reader_agu_spatial_bounds"])
            + " --readerTemporalDimension "
            + str(snax_xdma_cfg["reader_agu_temporal_dimension"])
            + " --writerSpatialBounds "
            + str(snax_xdma_cfg["writer_agu_spatial_bounds"])
            + " --writerTemporalDimension "
            + str(snax_xdma_cfg["writer_agu_temporal_dimension"])
            + " --readerBufferDepth "
            + str(snax_xdma_cfg["reader_buffer"])
            + " --writerBufferDepth "
            + str(snax_xdma_cfg["writer_buffer"])
            + xdma_extension_arg
            + " --hw-target-dir "
            + args.gen_path
            + cfg["cluster"]["name"]
            + "_xdma/"
            + " --sw-target-dir "
            + args.gen_path
            + "../sw/snax/xdma",
        )

    # ---------------------------------------
    # Generation of testharness
    # ---------------------------------------
    cluster_schema_path = "../../docs/schema/snitch_cluster.schema.json"
    harness_cfg = read_schema(cluster_schema_path)

    if "enable_debug" not in cfg["cluster"]:
        cfg["cluster"]["enable_debug"] = harness_cfg["properties"]["enable_debug"][
            "default"
        ]

    if "iso_crossings" not in cfg["cluster"]["timing"]:
        cfg["cluster"]["timing"]["iso_crossings"] = harness_cfg["properties"]["timing"][
            "properties"
        ]["iso_crossings"][
            "default"
        ]  # noqa: E501

    if "sram_cfg_expose" not in cfg["cluster"]:
        cfg["cluster"]["sram_cfg_expose"] = harness_cfg["properties"][
            "sram_cfg_expose"
        ]["default"]

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
