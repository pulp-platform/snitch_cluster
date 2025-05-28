#!/usr/bin/env python3
# Copyright 2025 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import argparse


def decode_bank_offset(address, base_address, num_banks, bank_width_bits):
    """Compute the bank index and offset within the bank for a given memory address.

    Args:
        address (int): Target memory address (in bytes).
        base_address (int): Base address of the banked memory.
        num_banks (int): Number of banks.
        bank_width_bits (int): Width of a bank in bits (e.g., 64 for 64-bit words).

    Returns:
        Tuple[int, int]: (bank_index, offset_in_bank), where offset is in word units.

    Raises:
        ValueError: If address is misaligned or below base.
    """
    bank_width_bytes = bank_width_bits // 8
    rel_addr = address - base_address

    if rel_addr < 0:
        raise ValueError("Address is below the base address of the memory banks.")

    if rel_addr % bank_width_bytes != 0:
        raise ValueError(f"Address {hex(address)} is not aligned to bank width of "
                         f"{bank_width_bytes} bytes.")

    word_index = rel_addr // bank_width_bytes
    bank_index = word_index % num_banks
    offset_in_bank = word_index // num_banks

    return bank_index, offset_in_bank


def main():
    """Parses command-line arguments and prints the bank index and offset."""
    parser = argparse.ArgumentParser(
        description="Determine bank index and offset within a bank for a given memory address."
    )

    parser.add_argument(
        "address",
        type=lambda x: int(x, 0),
        help="Memory address to decode (e.g., 0x1A3 or 419)."
    )

    parser.add_argument(
        "--num_banks",
        type=int,
        default=32,
        help="Total number of memory banks (default: 32)."
    )

    parser.add_argument(
        "--base_address",
        type=lambda x: int(x, 0),
        default=0x10000000,
        help="Base address of the banked memory (default: 0x1000000)."
    )

    parser.add_argument(
        "--bank_width",
        type=int,
        default=64,
        help="Bank width in bits (default: 64). Must be a multiple of 8."
    )

    args = parser.parse_args()

    if args.bank_width % 8 != 0:
        raise ValueError("Bank width must be a multiple of 8 (to align with byte addressing).")

    bank_index, offset = decode_bank_offset(
        address=args.address,
        base_address=args.base_address,
        num_banks=args.num_banks,
        bank_width_bits=args.bank_width
    )

    print(f"Bank: {bank_index}")
    print(f"Line: {offset}")


if __name__ == "__main__":
    main()
