#!/usr/bin/env python3
# Copyright 2020 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51
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
        fpos = list(self.elf.address_offsets(addr, size))[0]
        self.elf.stream.seek(fpos)
        return self.elf.stream.read(size)
