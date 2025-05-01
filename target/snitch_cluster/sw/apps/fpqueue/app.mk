APP              := fpqueue
$(APP)_BUILD_DIR := $(ROOT)/target/snitch_cluster/sw/apps/$(APP)/build
SRCS             := $(ROOT)/target/snitch_cluster/sw/apps/$(APP)/src/$(APP).c
$(APP)_INCDIRS   := $(ROOT)/target/snitch_cluster/sw/apps/$(APP)/data

include $(ROOT)/target/snitch_cluster/sw/apps/common.mk
