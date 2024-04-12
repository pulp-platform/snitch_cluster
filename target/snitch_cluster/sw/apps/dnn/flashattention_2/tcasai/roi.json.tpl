<%
    T_r = 4
    T_c = 1
%>
[
    // Compute cores
    % for i in range(0, 8):
    {
        "thread": "${f'hart_{i}'}",
        "roi": [
        % for t_r in range(T_r):
            <% t_r_offset = (4 + 4*T_c) * t_r %>
            {"idx": ${2 + t_r_offset}, "label": "init"},
            % for t_c in range(T_c):
            {"idx": ${4 + 4*t_c + t_r_offset}, "label": "QxKt"},
            {"idx": ${5 + 4*t_c + t_r_offset}, "label": "softmax"},
            {"idx": ${6 + 4*t_c + t_r_offset}, "label": "PxV"},
            % endfor
            {"idx": ${3 + 4*T_c + t_r_offset}, "label": "rescale"},
        % endfor
        ]
    },
    % endfor

    // DMA core
    {
        "thread": "hart_8",
        "roi": [
    % for t_r in range(T_r):
        <% t_r_offset = (4 + 4*T_c) * t_r %>
            {"idx": ${1 + t_r_offset}, "label": "copy Q"},
        % for t_c in range(T_c):
            {"idx": ${3 + 4*t_c + t_r_offset}, "label": "copy K & V"},
        % endfor
            {"idx": ${4 + 4*T_c + t_r_offset}, "label": "copy O"},
    % endfor
        ]
    },
]