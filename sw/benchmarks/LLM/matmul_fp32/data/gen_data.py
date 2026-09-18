import numpy as np
import os

# Matrix dimensions (general case)
M = 24
N = M
K = N

# Generate random matrices
mat_a = np.random.rand(M, K).astype(np.float32)
mat_b = np.random.rand(K, N).astype(np.float32)

# Golden model
golden = np.matmul(mat_a, mat_b)

def matrix_to_c_array(name, mat, rows, cols):
    """Convert a numpy matrix into a C 1D row-major array string."""
    flat = mat.flatten()
    c_str = f"float {name}[{rows}*{cols}] = {{\n"
    
    for i in range(rows):
        row = ", ".join(f"{flat[i*cols + j]:.6f}f" for j in range(cols))
        c_str += f"    {row},\n"
    
    c_str += "};\n"
    return c_str

# File path
script_dir = os.path.dirname(os.path.abspath(__file__))
file_path = os.path.join(script_dir, "data.h")

# Generate header
with open(file_path, "w") as f:
    f.write("#ifndef DATA_H\n")
    f.write("#define DATA_H\n\n")

    f.write(f"#define M {M}\n")
    f.write(f"#define N {N}\n")
    f.write(f"#define K {K}\n\n")

    f.write("float *mat_a_TCDM;\n")
    f.write("float *mat_b_TCDM;\n")
    f.write("float *dst_TCDM;\n\n")

    f.write("/* Matrices in row-major 1D order */\n")

    f.write(matrix_to_c_array("mat_a", mat_a, M, K) + "\n")
    f.write(matrix_to_c_array("mat_b", mat_b, K, N) + "\n")
    f.write(matrix_to_c_array("golden", golden, M, N) + "\n")

    f.write("#endif\n")

print(f"data.h successfully generated at: {file_path}")