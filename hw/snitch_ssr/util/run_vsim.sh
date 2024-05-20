#!/bin/bash
# Copyright 2024 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51
#
# Fabian Schuiki <fschuiki@iis.ee.ethz.ch>
# Andreas Kurth  <akurth@iis.ee.ethz.ch>
# Paul Scheffler <paulsc@iis.ee.ethz.ch>

set -e
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

[ ! -z "$VSIM" ] || VSIM=vsim

call_vsim() {
    # We treat accessing unwritten associative array (memory) locations as fatal
    echo "log -r /*; run -all" | $QUESTA_SEPP $VSIM -c -coverage -voptargs='+acc +cover=sbecft' "$@" -fatal vsim-3829 | tee vsim.log 2>&1
    (grep "SUCCESS" transcript)
    (! grep -n "Fatal:" transcript)
    (! grep -n "Error:" transcript)
}

call_vsim tb_simple_ssr
call_vsim tb_simple_ssr_streamer
