BITS_DIR = include/bits
ALLTYPES_H = $(BITS_DIR)/alltypes.h


.PHONY: all clean

all: $(ALLTYPES_H)

clean:
	rm -rf $(BITS_DIR)
	rm -f $(ALLTYPES_H)

$(BITS_DIR):
	mkdir -p $@

$(ALLTYPES_H): | $(BITS_DIR)
	sed -f tools/mkalltypes.sed arch/riscv64/bits/alltypes.h.in include/alltypes.h.in > $@
