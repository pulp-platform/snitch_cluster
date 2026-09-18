import numpy as np
import os
from scipy.signal import correlate2d

# Input feature map dimension (square)
FM_ROWS = 64

# Output dimension after valid (no-padding) 3x3 cross-correlation
OUT_ROWS = FM_ROWS - 2   # FM_ROWS - KERNEL_SIZE + 1

# Generate random input feature map and 3x3 kernel
input_fm = np.random.rand(FM_ROWS, FM_ROWS).astype(np.float32)
kernel   = np.random.rand(3, 3).astype(np.float32)

golden = correlate2d(input_fm, kernel, mode='valid').astype(np.float32)

# ──────────────────────────────────────────────
def matrix_to_c_array(name, mat, r):
    flat  = mat.flatten()
    c_str = f"float {name}[{r} * {r}] = {{\n"
    for i in range(r):
        row = ", ".join(f"{flat[i * r + j]:.6f}f" for j in range(r))
        c_str += f"    {row},\n"
    c_str += "};\n"
    return c_str

def kernel_to_c_array(name, mat):
    flat  = mat.flatten()
    c_str = f"float {name}[9] = {{\n"
    for i in range(3):
        row = ", ".join(f"{flat[i * 3 + j]:.6f}f" for j in range(3))
        c_str += f"    {row},\n"
    c_str += "};\n"
    return c_str

# ──────────────────────────────────────────────
script_dir = os.path.dirname(os.path.abspath(__file__))
file_path  = os.path.join(script_dir, "data.h")

with open(file_path, "w") as f:
    f.write("#ifndef DATA_H\n")
    f.write("#define DATA_H\n\n")

    f.write("/* Square input feature-map dimension */\n")
    f.write("#ifndef FM_ROWS\n")
    f.write(f"#define FM_ROWS {FM_ROWS}\n")
    f.write("#endif\n")
    f.write(f"#define KERNEL_SIZE 3\n")
    f.write(f"/* Output dimension (valid, no-padding): FM_ROWS - KERNEL_SIZE + 1 */\n")
    f.write(f"#define OUT_ROWS (FM_ROWS - KERNEL_SIZE + 1)\n\n")

    f.write("/* TCDM pointers (filled at runtime) */\n")
    f.write("float *input_TCDM;\n")
    f.write("float *kernel_TCDM;\n")
    f.write("float *dst_TCDM;\n\n")

    f.write("/* Input feature map – row-major, FM_ROWS x FM_ROWS */\n")
    f.write(matrix_to_c_array("input_fm", input_fm, FM_ROWS) + "\n")

    f.write("/* 3x3 kernel – row-major (h[0..8] in scan order) */\n")
    f.write(kernel_to_c_array("conv_kernel", kernel) + "\n")

    f.write("/* Golden output (cross-correlation, valid/no-padding) – row-major, OUT_ROWS x OUT_ROWS */\n")
    f.write(matrix_to_c_array("golden", golden, OUT_ROWS) + "\n")

    f.write("#endif /* DATA_H */\n")

print(f"data.h successfully generated at: {file_path}")