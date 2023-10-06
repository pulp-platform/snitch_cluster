# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>
#
# This class implements a minimal wrapper around pyelftools
# to easily inspect ELF files.

from elftools.elf.elffile import ELFFile
from elftools.elf.sections import SymbolTableSection


class Elf(object):

    def __init__(self, elf_path):
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
        symbol = self.symtab.get_symbol_by_name(uid)[0]
        return symbol.entry["st_value"]

    def get_symbol_size(self, uid):
        symbol = self.symtab.get_symbol_by_name(uid)[0]
        return symbol.entry["st_size"]

    def get_symbol_contents(self, uid):
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
