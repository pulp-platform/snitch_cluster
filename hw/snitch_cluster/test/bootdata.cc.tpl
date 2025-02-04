// Copyright 2021 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

#include <tb_lib.hh>

namespace sim {

const BootData BOOTDATA = {.boot_addr = ${hex(cfg['cluster']['boot_addr'])},
                           .core_count = ${cfg['cluster']['nr_cores']},
                           .hartid_base = ${cfg['cluster']['cluster_base_hartid']},
                           .tcdm_start = ${hex(cfg['cluster']['cluster_base_addr'])},
                           .tcdm_size = ${hex(cfg['cluster']['tcdm']['size'] * 1024)},
                           .tcdm_offset = ${hex(cfg['cluster']['cluster_base_offset'])},
                           .global_mem_start = ${hex(next(reg['address'] for reg in cfg['external_addr_regions'] if reg['name'] == 'dram'))},
                           .global_mem_end = ${hex(next(reg['address'] + reg['length'] for reg in cfg['external_addr_regions'] if reg['name'] == 'dram'))},
                           .cluster_count = ${cfg['nr_clusters']},
                           .clint_base = ${hex(next(reg['address'] + reg['length'] for reg in cfg['external_addr_regions'] if reg['name'] == 'clint'))}};

}  // namespace sim
