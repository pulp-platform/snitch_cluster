# Copyright 2025 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51

BENDER ?= bender
REGGEN ?= $(shell $(BENDER) path register_interface)/vendor/lowrisc_opentitan/util/regtool.py

SN_BOOTROM_GEN     = $(SN_ROOT)/util/gen_bootrom.py
SN_CLUSTER_GEN     = $(SN_ROOT)/util/clustergen.py
SN_CLUSTER_GEN_SRC = $(wildcard $(SN_ROOT)/util/clustergen/*.py)
SN_CLUSTER_GEN_TPL = $(SN_ROOT)/hw/snitch_cluster/src/snitch_cluster_wrapper.sv.tpl

SN_TARGET_DIR   = $(SN_ROOT)/target/snitch_cluster
SN_PERIPH_DIR   = $(SN_ROOT)/hw/snitch_cluster/src/snitch_cluster_peripheral
SN_GEN_DIR		 ?= $(SN_TARGET_DIR)/.generated
SN_BOOTROM_DIR ?= $(SN_TARGET_DIR)/test

SN_RTL_SOURCES  = $(SN_PERIPH_DIR)/snitch_cluster_peripheral_reg_top.sv
SN_RTL_SOURCES += $(SN_PERIPH_DIR)/snitch_cluster_peripheral_reg_pkg.sv
SN_RTL_SOURCES += $(SN_GEN_DIR)/snitch_cluster_wrapper.sv
SN_RTL_SOURCES += $(SN_BOOTROM_DIR)/snitch_bootrom.sv

.PHONY: sn-wrapper sn-clean-wrapper
sn-wrapper: $(SN_GEN_DIR)/snitch_cluster_wrapper.sv
$(SN_GEN_DIR)/snitch_cluster_wrapper.sv: $(SN_CFG) $(SN_CLUSTER_GEN) $(SN_CLUSTER_GEN_SRC) $(SN_CLUSTER_GEN_TPL) | $(SN_GEN_DIR)
	$(SN_CLUSTER_GEN) -c $< -o $(SN_GEN_DIR) --template $(SN_CLUSTER_GEN_TPL)

sn-clean-wrapper:
	rm -f $(SN_GEN_DIR)/snitch_cluster_wrapper.sv

$(SN_GEN_DIR)/memories.json: $(SN_CFG) $(SN_CLUSTER_GEN) $(SN_CLUSTER_GEN_SRC) | $(SN_GEN_DIR)
	$(SN_CLUSTER_GEN) -c $< -o $(SN_GEN_DIR) --memories

# REGGEN regfile
SN_PERIPH_REG_CFG ?= $(SN_PERIPH_DIR)/snitch_cluster_peripheral_reg.hjson

$(SN_PERIPH_DIR)/snitch_cluster_peripheral_reg_pkg.sv: $(SN_PERIPH_DIR)/snitch_cluster_peripheral_reg_top.sv
$(SN_PERIPH_DIR)/snitch_cluster_peripheral_reg_top.sv: $(SN_PERIPH_REG_CFG)
	@echo "[REGGEN] Generating peripheral regfile"
	$(REGGEN) -r -t $(SN_PERIPH_DIR) $<

# Bootrom
.PHONY: sn-bootrom
sn-bootrom: $(SN_BOOTROM_DIR)/snitch_bootrom.sv
$(SN_BOOTROM_DIR)/bootrom.elf $(SN_BOOTROM_DIR)/bootrom.dump $(SN_BOOTROM_DIR)/bootrom.bin $(SN_BOOTROM_DIR)/snitch_bootrom.sv: $(SN_BOOTROM_DIR)/bootrom.S $(SN_BOOTROM_DIR)/bootrom.ld $(SN_BOOTROM_GEN)
	$(RISCV_CC) -mabi=ilp32d -march=rv32imafd -static -nostartfiles -fuse-ld=$(RISCV_LD) -L$(SN_ROOT)/sw/runtime -T$(SN_BOOTROM_DIR)/bootrom.ld $< -o $(SN_BOOTROM_DIR)/bootrom.elf
	$(RISCV_OBJDUMP) -d $(SN_BOOTROM_DIR)/bootrom.elf > $(SN_BOOTROM_DIR)/bootrom.dump
	$(RISCV_OBJCOPY) -j .text -O binary $(SN_BOOTROM_DIR)/bootrom.elf $(SN_BOOTROM_DIR)/bootrom.bin
	$(SN_BOOTROM_GEN) --sv-module snitch_bootrom $(SN_BOOTROM_DIR)/bootrom.bin > $(SN_BOOTROM_DIR)/snitch_bootrom.sv

# General RTL targets
.PHONY: sn-rtl sn-clean-rtl

sn-rtl: $(SN_RTL_SOURCES)

sn-clean-rtl:
	rm -f $(SN_RTL_SOURCES)

$(SN_GEN_DIR):
	mkdir -p $@
