APP              := spatz-axpy
$(APP)_BUILD_DIR ?= $(SN_ROOT)/sw/kernels/blas/$(APP)/build
SRC_DIR          := $(SN_ROOT)/sw/kernels/blas/$(APP)/src
SRCS             := $(SRC_DIR)/main.c

include $(SN_ROOT)/sw/kernels/datagen.mk
# For layer.h, shared with the other spatz-* kernels
$(APP)_INCDIRS += $(DATA_DIR)

include $(SN_ROOT)/sw/kernels/common.mk
