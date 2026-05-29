APP              := dp-faxpy
$(APP)_BUILD_DIR ?= $(SN_ROOT)/sw/spatz/$(APP)/build
SRC_DIR          := $(SN_ROOT)/sw/spatz/$(APP)
SRCS             := $(SRC_DIR)/main.c
$(APP)_DATAHEADER := data_256.h

include $(SN_ROOT)/sw/spatz/spatz_common.mk
