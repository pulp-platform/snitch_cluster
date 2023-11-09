# Usage of absolute paths is required to externally include this Makefile
MK_DIR   := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
DATA_DIR := $(realpath $(MK_DIR))

DATA_CFG ?= $(DATA_DIR)/params.hjson

DATA_H = $(DATA_DIR)/data.h

$(DATA_H): $(DATA_DIR)/datagen.py $(DATA_CFG)
	$< -c $(DATA_CFG) > $@

.PHONY: clean-data clean

clean-data:
	rm -f $(DATA_H)

clean: clean-data
