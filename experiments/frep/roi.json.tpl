# Copyright 2025 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

[
    // Compute cores
    % for j in range(8):
    {
        "thread": "${f'hart_{j}'}",
        "roi": [
        % for i in range(experiment['m_tiles'] * experiment['n_tiles']):
            {"idx": ${2 * i + 1}, "label": "${f'tile_{i}'}"},
        % endfor
        ]
    },
    % endfor
]
