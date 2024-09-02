# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch

###################
# Build variables #
###################

$(APP)_HEADERS += $(SNRT_HAL_HDRS)

$(APP)_INCDIRS += $(SNRT_INCDIRS)
$(APP)_INCDIRS += $(SNITCH_ROOT)/sw/deps/riscv-opcodes

$(APP)_RISCV_CFLAGS += $(RISCV_CFLAGS)
$(APP)_RISCV_CFLAGS += $(addprefix -I,$($(APP)_INCDIRS))
ifeq ($(SELECT_RUNTIME), banshee)
$(APP)_RISCV_CFLAGS += -DBIST
endif

$(APP)_LIBS += $(SNRT_LIB)

$(APP)_LIBDIRS  = $(dir $($(APP)_LIBS))
$(APP)_LIBNAMES = $(patsubst lib%,%,$(notdir $(basename $($(APP)_LIBS))))

BASE_LD    = $(SNRT_DIR)/base.ld
MEMORY_LD ?= $(SNITCH_ROOT)/target/snitch_cluster/sw/runtime/memory.ld

$(APP)_RISCV_LDFLAGS += $(RISCV_LDFLAGS)
$(APP)_RISCV_LDFLAGS += -L$(dir $(MEMORY_LD))
$(APP)_RISCV_LDFLAGS += -T$(BASE_LD)
$(APP)_RISCV_LDFLAGS += $(addprefix -L,$($(APP)_LIBDIRS))
$(APP)_RISCV_LDFLAGS += $(addprefix -l,$($(APP)_LIBNAMES))

LD_DEPS += $(MEMORY_LD) $(BASE_LD) $($(APP)_LIBS)

###########
# Outputs #
###########

ELF         := $(abspath $(addprefix $($(APP)_BUILD_DIR)/,$(addsuffix .elf,$(APP))))
DEP         := $(abspath $(addprefix $($(APP)_BUILD_DIR)/,$(addsuffix .d,$(APP))))
DUMP        := $(abspath $(addprefix $($(APP)_BUILD_DIR)/,$(addsuffix .dump,$(APP))))
ALL_OUTPUTS := $(ELF)

ifeq ($(DEBUG), ON)
ALL_OUTPUTS += $(DUMP)
endif

#########
# Rules #
#########

.PHONY: $(APP) clean-$(APP)

sw: $(APP)
clean-sw: clean-$(APP)

$(APP): $(ALL_OUTPUTS)

clean-$(APP): BUILD_DIR := $($(APP)_BUILD_DIR)
clean-$(APP):
	rm -rf $(BUILD_DIR)

$($(APP)_BUILD_DIR):
	mkdir -p $@

$(DEP): ELF := $(ELF)
$(ELF): SRCS := $(SRCS)
# Guarantee that variables used in rule recipes (thus subject to deferred expansion)
# have unique values, despite depending on variables with the same name across
# applications, but which could have different values (e.g. the APP variable itself)
$(DEP) $(ELF): RISCV_CFLAGS := $($(APP)_RISCV_CFLAGS)
$(ELF): RISCV_LDFLAGS := $($(APP)_RISCV_LDFLAGS)

$(DEP): $(SRCS) | $($(APP)_BUILD_DIR) $($(APP)_HEADERS)
	$(RISCV_CC) $(RISCV_CFLAGS) -MM -MT '$(ELF)' $< > $@

$(ELF): $(SRCS) $(DEP) $(LD_DEPS) | $($(APP)_BUILD_DIR)
	$(RISCV_CC) $(RISCV_CFLAGS) $(RISCV_LDFLAGS) $(SRCS) -o $@

$(DUMP): $(ELF) | $($(APP)_BUILD_DIR)
	$(RISCV_OBJDUMP) $(RISCV_OBJDUMP_FLAGS) $< > $@

ifneq ($(filter-out clean%,$(MAKECMDGOALS)),)
-include $(DEP)
endif
