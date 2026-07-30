# Copyright 2025 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51

# bootrom build is dependent on toolchain.mk and must thus be deferred
# after the toolchain.mk file is included and read.
ifdef SN_TOOLCHAIN_MK_READ

# Sentinel to test that rtl.mk has been included and read
SN_RTL_MK_READ = 1

# Directories
SN_BOOTROM_DIR ?= $(SN_HW_DIR)/bootrom

# Templates
SN_CLUSTER_WRAPPER_PKG_TPL = $(SN_HW_DIR)/snitch_cluster/src/snitch_cluster_wrapper_pkg.sv.tpl
SN_CLUSTER_RDL_TPL         = $(SN_HW_DIR)/snitch_cluster/src/snitch_cluster.rdl.tpl
SN_SPATZ_CFG_TPL           = $(SN_HW_DIR)/snitch_cc/src/spatz_cfg.json.tpl

# Generated RTL sources
SN_CLUSTER_WRAPPER_PKG = $(SN_GEN_DIR)/snitch_cluster_wrapper_pkg.sv
SN_CLUSTER_ADDRMAP_SVH = $(SN_GEN_DIR)/snitch_cluster_addrmap.svh
SN_CLUSTER_PERIPH      = $(SN_PERIPH_DIR)/snitch_cluster_peripheral_reg.sv
SN_CLUSTER_PERIPH_PKG  = $(SN_PERIPH_DIR)/snitch_cluster_peripheral_reg_pkg.sv
SN_BOOTROM             = $(SN_BOOTROM_DIR)/snitch_bootrom.sv
SN_CLUSTER_RDL         = $(SN_GEN_DIR)/snitch_cluster.rdl

# Spatz package generation
SN_SPATZ_HW_DIR  = $(shell $(SN_BENDER) path spatz_vpu)/hw
SN_SPATZ_CFG     = $(SN_GEN_DIR)/spatz_cfg.json
SN_SPATZ_PKG_TPL = $(SN_SPATZ_HW_DIR)/src/spatz_pkg.sv.tpl
SN_SPATZ_PKG     = $(SN_GEN_DIR)/spatz_pkg.sv

# All generated RTL sources
SN_GEN_RTL_SRCS = $(SN_CLUSTER_WRAPPER_PKG) $(SN_CLUSTER_ADDRMAP_SVH) $(SN_CLUSTER_PERIPH) $(SN_CLUSTER_PERIPH_PKG) $(SN_BOOTROM) $(SN_SPATZ_PKG)

# Intermediate artifacts
SN_BOOTROM_ELF       = $(SN_BOOTROM_DIR)/bootrom.elf
SN_BOOTROM_DUMP      = $(SN_BOOTROM_DIR)/bootrom.dump
SN_BOOTROM_BIN       = $(SN_BOOTROM_DIR)/bootrom.bin
SN_BOOTROM_ARTIFACTS = $(SN_BOOTROM_ELF) $(SN_BOOTROM_DUMP) $(SN_BOOTROM_BIN)

# CLUSTERGEN rules
$(eval $(call sn_cluster_gen_rule,$(SN_CLUSTER_WRAPPER_PKG),$(SN_CLUSTER_WRAPPER_PKG_TPL)))
$(eval $(call sn_cluster_gen_rule,$(SN_CLUSTER_RDL),$(SN_CLUSTER_RDL_TPL)))
$(eval $(call sn_cluster_gen_rule,$(SN_SPATZ_CFG),$(SN_SPATZ_CFG_TPL)))

# Spatz package generation via the Spatz hw/Makefile flow:
#   import_cfg.py extracts Spatz VFU fields from the cluster config,
#   apply_cfg.py renders spatz_pkg.sv.tpl into the generated file.
$(SN_SPATZ_PKG): $(SN_SPATZ_CFG) $(SN_SPATZ_PKG_TPL) | $(SN_GEN_DIR) $(SN_SPATZ_HW_DIR)
	@echo "[SPATZ] Generating $@"
	cd $(SN_SPATZ_HW_DIR) && python import_cfg.py $(abspath $(SN_SPATZ_CFG))
	cd $(SN_SPATZ_HW_DIR) && python apply_cfg.py $(basename $(notdir $(SN_SPATZ_CFG)))
	cp $(SN_SPATZ_HW_DIR)/src/generated/spatz_pkg.sv $@

# peakRDL rules
$(SN_CLUSTER_PERIPH_PKG): $(SN_CLUSTER_PERIPH)
$(SN_CLUSTER_PERIPH): $(SN_PERIPH_DIR)/snitch_cluster_peripheral_reg.rdl
	@echo "[peakrdl] Generating $@"
	$(SN_PEAKRDL) regblock $< -o $(SN_PERIPH_DIR) --cpuif apb4-flat --default-reset arst_n
$(SN_CLUSTER_ADDRMAP_SVH): $(SN_CLUSTER_RDL)
	@echo "[peakrdl] Generating $@"
	$(SN_PEAKRDL) raw-header $< -o $@ --format svh -I $(SN_PERIPH_DIR)

# Bootrom rules: explicit dependency on toolchain.mk ensures that the bootrom is rebuilt if the toolchain is updated
$(SN_BOOTROM_ELF): $(SN_BOOTROM_DIR)/bootrom.S $(SN_BOOTROM_DIR)/bootrom.ld $(SN_TOOLCHAIN_MK) | $(SN_BOOTROM_DIR)
	$(SN_RISCV_CC) -mabi=ilp32d -march=rv32imafd -static -nostartfiles -fuse-ld=$(SN_RISCV_LD) -L$(SN_ROOT)/sw/runtime -T$(SN_BOOTROM_DIR)/bootrom.ld $< -o $@
$(SN_BOOTROM_DUMP): $(SN_BOOTROM_ELF)
	$(SN_RISCV_OBJDUMP) -d $< > $@
$(SN_BOOTROM_BIN): $(SN_BOOTROM_ELF)
	$(SN_RISCV_OBJCOPY) -j .text -O binary $< $@
$(SN_BOOTROM): $(SN_BOOTROM_BIN) $(SN_BOOTROM_GEN)
	$(SN_BOOTROM_GEN) --sv-module snitch_bootrom $< > $@

# General RTL targets
.PHONY: sn-rtl sn-clean-rtl

sn-rtl: $(SN_GEN_RTL_SRCS)

sn-clean-rtl:
	rm -f $(SN_GEN_RTL_SRCS) $(SN_CLUSTER_RDL) $(SN_BOOTROM_ARTIFACTS) $(SN_SPATZ_CFG)

$(SN_BOOTROM_DIR):
	mkdir -p $@

endif
