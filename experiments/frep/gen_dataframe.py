#!/usr/bin/env python3
# Copyright 2025 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Lorenzo Leone <lleone@iis.ee.ethz.ch>

import os
import csv
import re


def parse_qor_report(file_path):
    """Parses the qor.rpt file to extract area-related metrics."""
    area_data = {
        "Combinational Area": None,
        "Noncombinational Area": None,
        "Buf/Inv Area": None,
        "Macro/Black Box Area": None,
        "Cell Area (netlist)": None,
        "Net Length": None
    }

    with open(file_path, 'r') as file:
        lines = file.readlines()

    in_area_section = False
    for line in lines:
        line = line.strip()

        if line.startswith("Area"):
            in_area_section = True
        elif in_area_section and line.startswith("-"):
            continue
        elif in_area_section and line == "":
            break
        elif in_area_section:
            for key in area_data.keys():
                match = re.match(rf"{re.escape(key)}:\s+([\d]+(?:\.\d+)?)", line)
                if match:
                    area_data[key] = float(match.group(1))

    return area_data


def read_hardware_configs(file_path):
    """Reads the hardware configuration names from hw_cfg.list file, or
    asks the user if file is missing."""
    if not os.path.exists(file_path):
        print(f"Configuration file {file_path} not found.")
        user_input = input("Enter the hardware directories (space-separated): ")
        return user_input.split()

    with open(file_path, 'r') as file:
        return [line.strip() for line in file.readlines() if line.strip()]


def collect_results(base_dir, hardware_dirs):
    """Iterates through specified hardware directories, extracts area
    metrics, and saves them in a CSV."""
    analyze_dir = os.path.join(base_dir, "analyze")
    os.makedirs(analyze_dir, exist_ok=True)
    output_csv = os.path.join(analyze_dir, "area_results.csv")

    results = []

    for hw_config in hardware_dirs:
        qor_path = os.path.join(base_dir, hw_config, "fusion", "qor.rpt")
        if os.path.exists(qor_path):
            area_metrics = parse_qor_report(qor_path)
            area_metrics["Hardware Config"] = hw_config  # Add hardware name
            results.append(area_metrics)
        else:
            print(f"Warning: qor.rpt not found in {qor_path}")

    if results:
        fieldnames = list(results[0].keys())
        with open(output_csv, "w", newline='') as csvfile:
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(results)
        print(f"Results saved to {output_csv}")
    else:
        print("No results found. CSV file not created.")


if __name__ == "__main__":
    base_directory = os.getcwd()  # Assumes script is executed from the experiment root directory
    config_file = os.path.join(base_directory, "hw_cfg.list")
    hardware_dirs = read_hardware_configs(config_file)

    if hardware_dirs:
        collect_results(base_directory, hardware_dirs)
    else:
        print("No hardware configurations found. Exiting.")
