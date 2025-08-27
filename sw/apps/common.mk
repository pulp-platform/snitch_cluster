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
$(APP)_INCDIRS += $(SN_ROOT)/sw/deps/riscv-opcodes

$(APP)_RISCV_CFLAGS += $(RISCV_CFLAGS)
$(APP)_RISCV_CFLAGS += $(addprefix -I,$($(APP)_INCDIRS))

$(APP)_LIBS += $(SNRT_LIB)

$(APP)_LIBDIRS  = $(dir $($(APP)_LIBS))
$(APP)_LIBNAMES = $(patsubst lib%,%,$(notdir $(basename $($(APP)_LIBS))))

SNRT_BASE_LD    = $(SNRT_DIR)/base.ld
SNRT_MEMORY_LD ?= $(SNRT_HAL_SRC_DIR)/memory.ld

$(APP)_RISCV_LDFLAGS += $(RISCV_LDFLAGS)
$(APP)_RISCV_LDFLAGS += -L$(dir $(SNRT_MEMORY_LD))
$(APP)_RISCV_LDFLAGS += -T$(SNRT_BASE_LD)
$(APP)_RISCV_LDFLAGS += $(addprefix -L,$($(APP)_LIBDIRS))
$(APP)_RISCV_LDFLAGS += $(addprefix -l,$($(APP)_LIBNAMES))

SNRT_LD_DEPS += $(SNRT_MEMORY_LD) $(SNRT_BASE_LD) $($(APP)_LIBS)

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
$(DEP) $(ELF): RISCV_CFLAGS := $($(APP)_RISCV_CFLAGS)
$(ELF): RISCV_LDFLAGS := $($(APP)_RISCV_LDFLAGS)

$(DEP): $(SRCS) | $($(APP)_BUILD_DIR) $($(APP)_HEADERS)
	$(RISCV_CXX) $(RISCV_CFLAGS) -MM -MT '$(ELF)' -x c++ $< > $@

$(ELF): $(SRCS) $(DEP) $(SNRT_LD_DEPS) | $($(APP)_BUILD_DIR)
	$(RISCV_CXX) $(RISCV_CFLAGS) $(RISCV_LDFLAGS) -x c++ $(SRCS) -o $@

$(DUMP): $(ELF) | $($(APP)_BUILD_DIR)
	$(RISCV_OBJDUMP) $(RISCV_OBJDUMP_FLAGS) $< > $@

ifneq ($(filter-out sn-clean%,$(MAKECMDGOALS)),)
-include $(DEP)
endif
