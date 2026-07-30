# Copyright 2020 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

SN_TOOLCHAIN_MK     = $(SN_ROOT)/sw/toolchain.mk
SN_TOOLCHAIN_MK_TPL = $(SN_ROOT)/sw/toolchain.mk.tpl

# Toolchain flags are generated from the cluster configuration
$(eval $(call sn_cluster_gen_rule,$(SN_TOOLCHAIN_MK),$(SN_TOOLCHAIN_MK_TPL)))

include $(SN_TOOLCHAIN_MK)

.PHONY: sn-clean-toolchain
sn-clean-toolchain:
	rm -f $(SN_TOOLCHAIN_MK)
