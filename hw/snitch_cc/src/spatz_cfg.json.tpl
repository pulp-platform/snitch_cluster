// Copyright 2026 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

<%!
    import dataclasses
    import json

    def _default(obj):
        if dataclasses.is_dataclass(obj):
            return dataclasses.asdict(obj)
        return vars(obj)
%>\
${json.dumps(
    {'spatz': cfg['cluster']['hives'][0]['cores'][0]['spatz']},
    indent=4,
    default=_default
)}