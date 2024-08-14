# Copyright 2024 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Ryan Antonio <ryan.antonio@esat.kuleuven.be>

# Usage of absolute paths is required to externally include this Makefile
MK_DIR   := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

# Main source directory a source file
SRC_DIR  := $(realpath $(MK_DIR)/$(APP)/src)

# Get sources list
SRCS     = $(realpath $(SRC_DIR)/$(APP).c)
