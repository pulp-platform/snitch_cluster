# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

from elftools.elf.elffile import ELFFile
from elftools.elf.sections import SymbolTableSection
from snitch.util.sim.data_utils import from_buffer


class Elf(object):
    """Minimal wrapper around `pyelftools` to easily inspect ELF files."""

    def __init__(self, elf_path):
        """Default constructor.

        Arguments:
            elf_path: Path to an ELF binary.
        """
        self.elf_path = elf_path
        self.stream = open(self.elf_path, 'rb')
        self.elf = ELFFile(self.stream)
        # Get symbol table
        section = self.elf.get_section_by_name('.symtab')
        if not section or not isinstance(section, SymbolTableSection):
            print('No symbol table found. Perhaps this ELF has been stripped?')
            self.symtab = None
        else:
            self.symtab = section

    def get_symbol_address(self, uid):
        """Returns the address of a global symbol.

        Arguments:
            uid: A global symbol.
        """
        symbols = self.symtab.get_symbol_by_name(uid)
        if symbols is None:
            raise ValueError(f"Symbol '{uid}' not found in ELF file.")
        elif len(symbols) > 1:
            raise ValueError(f"Symbol '{uid}' is not unique in ELF file.")
        return symbols[0].entry["st_value"]

    def get_symbol_size(self, uid):
        """Returns the size of a global symbol.

        Arguments:
            uid: A global symbol.
        """
        symbols = self.symtab.get_symbol_by_name(uid)
        if symbols is None:
            raise ValueError(f"Symbol '{uid}' not found in ELF file.")
        elif len(symbols) > 1:
            raise ValueError(f"Symbol '{uid}' is not unique in ELF file.")
        return symbols[0].entry["st_size"]

    def get_raw_symbol_contents(self, uid):
        """Returns a bytearray with the contents of a global symbol.

        Arguments:
            uid: A global symbol.
        """
        addr = self.get_symbol_address(uid)
        size = self.get_symbol_size(uid)
        try:
            fpos = list(self.elf.address_offsets(addr, size))[0]
            self.elf.stream.seek(fpos)
            contents = self.elf.stream.read(size)
        except IndexError:
            # We assume all segments in our ELF are of type PT_LOAD and
            # that the only section whose contents are not stored in
            # the ELF file is the .bss section. Therefore, whenever
            # `address_offsets()` fails to return a valid offset into the
            # file we assume that the address falls in the .bss section.
            contents = bytearray([0] * size)
        return contents

    def from_symbol(self, uid, ctype):
        """Returns an array with the contents of a global symbol.

        The array is formatted from the raw byte contents returned by
        [`get_raw_symbol_contents()`][Elf.Elf.get_raw_symbol_contents]
        using the [`from_buffer()`][data_utils.from_buffer] function.

        Arguments:
            uid: A global symbol.
            ctype: C type identifier passed on to the
                [`from_buffer()`][data_utils.from_buffer] function.
        """
        return from_buffer(self.get_raw_symbol_contents(uid), ctype)
