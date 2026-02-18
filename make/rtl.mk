# Copyright 2025 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51

# Directories
SN_BOOTROM_DIR ?= $(SN_HW_DIR)/bootrom

# Templates
SN_CLUSTER_WRAPPER_TPL = $(SN_HW_DIR)/snitch_cluster/src/snitch_cluster_wrapper.sv.tpl
SN_CLUSTER_PKG_TPL     = $(SN_HW_DIR)/snitch_cluster/src/snitch_cluster_pkg.sv.tpl
SN_CLUSTER_RDL_TPL	   = $(SN_HW_DIR)/snitch_cluster/src/snitch_cluster.rdl.tpl

# Generated RTL sources
SN_CLUSTER_WRAPPER     = $(SN_GEN_DIR)/snitch_cluster_wrapper.sv
SN_CLUSTER_PKG         = $(SN_GEN_DIR)/snitch_cluster_pkg.sv
SN_CLUSTER_ADDRMAP_SVH = $(SN_GEN_DIR)/snitch_cluster_addrmap.svh
SN_CLUSTER_PERIPH      = $(SN_PERIPH_DIR)/snitch_cluster_peripheral_reg.sv
SN_CLUSTER_PERIPH_PKG  = $(SN_PERIPH_DIR)/snitch_cluster_peripheral_reg_pkg.sv
SN_BOOTROM             = $(SN_BOOTROM_DIR)/snitch_bootrom.sv
SN_CLUSTER_RDL         = $(SN_GEN_DIR)/snitch_cluster.rdl

# All generated RTL sources
SN_GEN_RTL_SRCS = $(SN_CLUSTER_WRAPPER) $(SN_CLUSTER_PKG) $(SN_CLUSTER_ADDRMAP_SVH) $(SN_CLUSTER_PERIPH) $(SN_CLUSTER_PERIPH_PKG) $(SN_BOOTROM)

# Intermediate artifacts
SN_BOOTROM_ELF       = $(SN_BOOTROM_DIR)/bootrom.elf
SN_BOOTROM_DUMP      = $(SN_BOOTROM_DIR)/bootrom.dump
SN_BOOTROM_BIN       = $(SN_BOOTROM_DIR)/bootrom.bin
SN_BOOTROM_ARTIFACTS = $(SN_BOOTROM_ELF) $(SN_BOOTROM_DUMP) $(SN_BOOTROM_BIN)

# CLUSTERGEN rules
$(eval $(call sn_cluster_gen_rule,$(SN_CLUSTER_WRAPPER),$(SN_CLUSTER_WRAPPER_TPL)))
$(eval $(call sn_cluster_gen_rule,$(SN_CLUSTER_PKG),$(SN_CLUSTER_PKG_TPL)))
$(eval $(call sn_cluster_gen_rule,$(SN_CLUSTER_RDL),$(SN_CLUSTER_RDL_TPL)))

# peakRDL rules
$(SN_CLUSTER_PERIPH_PKG): $(SN_CLUSTER_PERIPH)
$(SN_CLUSTER_PERIPH): $(SN_PERIPH_DIR)/snitch_cluster_peripheral_reg.rdl
	@echo "[peakrdl] Generating $@"
	$(SN_PEAKRDL) regblock $< -o $(SN_PERIPH_DIR) --cpuif apb4-flat --default-reset arst_n
$(SN_CLUSTER_ADDRMAP_SVH): $(SN_CLUSTER_RDL)
	@echo "[peakrdl] Generating $@"
	$(SN_PEAKRDL) raw-header $< -o $@ --format svh -I $(SN_PERIPH_DIR)

# Bootrom rules
$(SN_BOOTROM_ELF) $(SN_BOOTROM_DUMP) $(SN_BOOTROM_BIN) $(SN_BOOTROM): $(SN_BOOTROM_DIR)/bootrom.S $(SN_BOOTROM_DIR)/bootrom.ld $(SN_BOOTROM_GEN) | $(SN_BOOTROM_DIR)
	$(SN_RISCV_CC) -mabi=ilp32d -march=rv32imafd -static -nostartfiles -fuse-ld=$(SN_RISCV_LD) -L$(SN_ROOT)/sw/runtime -T$(SN_BOOTROM_DIR)/bootrom.ld $< -o $(SN_BOOTROM_ELF)
	$(SN_RISCV_OBJDUMP) -d $(SN_BOOTROM_ELF) > $(SN_BOOTROM_DUMP)
	$(SN_RISCV_OBJCOPY) -j .text -O binary $(SN_BOOTROM_ELF) $(SN_BOOTROM_BIN)
	$(SN_BOOTROM_GEN) --sv-module snitch_bootrom $(SN_BOOTROM_BIN) > $(SN_BOOTROM)

# General RTL targets
.PHONY: sn-rtl sn-clean-rtl

sn-rtl: $(SN_GEN_RTL_SRCS)

sn-clean-rtl:
	rm -f $(SN_GEN_RTL_SRCS) $(SN_CLUSTER_RDL) $(SN_BOOTROM_ARTIFACTS)

$(SN_BOOTROM_DIR):
	mkdir -p $@
