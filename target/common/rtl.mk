# Copyright 2025 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51

# Directories
SN_BOOTROM_DIR ?= $(SN_TARGET_DIR)/test

# Templates
SN_CLUSTER_WRAPPER_TPL = $(SN_HW_DIR)/snitch_cluster/src/snitch_cluster_wrapper.sv.tpl
SN_CLUSTER_PKG_TPL     = $(SN_HW_DIR)/snitch_cluster/src/snitch_cluster_pkg.sv.tpl

# Generated RTL sources
SN_CLUSTER_WRAPPER    = $(SN_GEN_DIR)/snitch_cluster_wrapper.sv
SN_CLUSTER_PKG        = $(SN_GEN_DIR)/snitch_cluster_pkg.sv
SN_CLUSTER_PERIPH_TOP = $(SN_PERIPH_DIR)/snitch_cluster_peripheral_reg_top.sv
SN_CLUSTER_PERIPH_PKG = $(SN_PERIPH_DIR)/snitch_cluster_peripheral_reg_pkg.sv
SN_BOOTROM            = $(SN_BOOTROM_DIR)/snitch_bootrom.sv

# All generated RTL sources
SN_GEN_RTL_SRCS = $(SN_CLUSTER_WRAPPER) $(SN_CLUSTER_PKG) $(SN_CLUSTER_PERIPH_TOP) $(SN_CLUSTER_PERIPH_PKG) $(SN_BOOTROM) 

# CLUSTERGEN rules
$(eval $(call sn_cluster_gen_rule,$(SN_CLUSTER_WRAPPER),$(SN_CLUSTER_WRAPPER_TPL)))
$(eval $(call sn_cluster_gen_rule,$(SN_CLUSTER_PKG),$(SN_CLUSTER_PKG_TPL)))

# REGGEN rules
$(SN_CLUSTER_PERIPH_PKG): $(SN_CLUSTER_PERIPH_TOP)
$(SN_CLUSTER_PERIPH_TOP): $(SN_PERIPH_DIR)/snitch_cluster_peripheral_reg.hjson
	@echo "[REGGEN] Generating peripheral regfile"
	$(REGGEN) -r -t $(SN_PERIPH_DIR) $<

# Bootrom rules
$(SN_BOOTROM_DIR)/bootrom.elf $(SN_BOOTROM_DIR)/bootrom.dump $(SN_BOOTROM_DIR)/bootrom.bin $(SN_BOOTROM): $(SN_BOOTROM_DIR)/bootrom.S $(SN_BOOTROM_DIR)/bootrom.ld $(SN_BOOTROM_GEN) | $(SN_BOOTROM_DIR)
	$(RISCV_CC) -mabi=ilp32d -march=rv32imafd -static -nostartfiles -fuse-ld=$(RISCV_LD) -L$(SN_ROOT)/sw/runtime -T$(SN_BOOTROM_DIR)/bootrom.ld $< -o $(SN_BOOTROM_DIR)/bootrom.elf
	$(RISCV_OBJDUMP) -d $(SN_BOOTROM_DIR)/bootrom.elf > $(SN_BOOTROM_DIR)/bootrom.dump
	$(RISCV_OBJCOPY) -j .text -O binary $(SN_BOOTROM_DIR)/bootrom.elf $(SN_BOOTROM_DIR)/bootrom.bin
	$(SN_BOOTROM_GEN) --sv-module snitch_bootrom $(SN_BOOTROM_DIR)/bootrom.bin > $(SN_BOOTROM)

# General RTL targets
.PHONY: sn-rtl sn-clean-rtl

sn-rtl: $(SN_GEN_RTL_SRCS)

sn-clean-rtl:
	rm -f $(SN_GEN_RTL_SRCS)

$(SN_BOOTROM_DIR):
	mkdir -p $@
