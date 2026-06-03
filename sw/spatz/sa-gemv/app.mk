APP              := sa-gemv
$(APP)_BUILD_DIR ?= $(SN_ROOT)/sw/spatz/$(APP)/build
SRC_DIR          := $(SN_ROOT)/sw/spatz/$(APP)
SRCS             := $(SRC_DIR)/main.c
$(APP)_DATAHEADER := data_128_4096_512_16.h
$(APP)_RISCV_CFLAGS += -DPREC=16

include $(SN_ROOT)/sw/spatz/spatz_common.mk
