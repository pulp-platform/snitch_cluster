# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch

###################
# Build variables #
###################

$(APP)_HEADERS += $(SN_RUNTIME_HAL_HDRS)

$(APP)_INCDIRS += $(SN_RUNTIME_INCDIRS)
$(APP)_INCDIRS += $(SN_ROOT)/sw/deps/riscv-opcodes

$(APP)_RISCV_CFLAGS += $(SN_RISCV_CFLAGS)
$(APP)_RISCV_CFLAGS += $(addprefix -I,$($(APP)_INCDIRS))

$(APP)_LIBS += $(SN_RUNTIME_LIB)

$(APP)_LIBDIRS  = $(dir $($(APP)_LIBS))
$(APP)_LIBNAMES = $(patsubst lib%,%,$(notdir $(basename $($(APP)_LIBS))))

SN_RUNTIME_BASE_LD    = $(SN_RUNTIME_DIR)/base.ld
SN_RUNTIME_MEMORY_LD ?= $(SN_RUNTIME_SRCDIR)/memory.ld

$(APP)_RISCV_LDFLAGS += $(SN_RISCV_LDFLAGS)
$(APP)_RISCV_LDFLAGS += -L$(dir $(SN_RUNTIME_MEMORY_LD))
$(APP)_RISCV_LDFLAGS += -T$(SN_RUNTIME_BASE_LD)
$(APP)_RISCV_LDFLAGS += $(addprefix -L,$($(APP)_LIBDIRS))
$(APP)_RISCV_LDFLAGS += $(addprefix -l,$($(APP)_LIBNAMES))

SN_RUNTIME_LD_DEPS += $(SN_RUNTIME_MEMORY_LD) $(SN_RUNTIME_BASE_LD) $($(APP)_LIBS)

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

sn-apps: $(APP)
sn-clean-apps: clean-$(APP)

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
$(DEP) $(ELF): SN_RISCV_CFLAGS := $($(APP)_RISCV_CFLAGS)
$(ELF): SN_RISCV_LDFLAGS := $($(APP)_RISCV_LDFLAGS)

$(DEP): $(SRCS) | $($(APP)_BUILD_DIR) $($(APP)_HEADERS)
	$(SN_RISCV_CXX) $(SN_RISCV_CFLAGS) -MM -MT '$(ELF)' -x c++ $< > $@

$(ELF): $(SRCS) $(DEP) $(SN_RUNTIME_LD_DEPS) | $($(APP)_BUILD_DIR)
	$(SN_RISCV_CXX) $(SN_RISCV_CFLAGS) $(SN_RISCV_LDFLAGS) -x c++ $(SRCS) -o $@

$(DUMP): $(ELF) | $($(APP)_BUILD_DIR)
	$(SN_RISCV_OBJDUMP) $(SN_RISCV_OBJDUMP_FLAGS) $< > $@

SN_DEPS += $(DEP)
