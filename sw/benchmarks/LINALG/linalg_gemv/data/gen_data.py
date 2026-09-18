import numpy as np
import os

# Matrix dimensions
M = 64  # rows of A
N = M  # cols of A (= length of x)

# Generate random matrix, vector and scalar
alpha   = np.float32(np.random.rand())
mat_a   = np.random.rand(M, N).astype(np.float32)
vec_x   = np.random.rand(N).astype(np.float32)

# Golden model: y = alpha * A * x
golden = alpha * np.matmul(mat_a, vec_x)  # shape (M,)

def matrix_to_c_array(name, mat, rows, cols):
    flat  = mat.flatten()
    c_str = f"float {name}[{rows}*{cols}] = {{\n"
    for i in range(rows):
        row    = ", ".join(f"{flat[i*cols + j]:.6f}f" for j in range(cols))
        c_str += f"    {row},\n"
    c_str += "};\n"
    return c_str

def vector_to_c_array(name, vec, length):
    c_str  = f"float {name}[{length}] = {{\n    "
    c_str += ", ".join(f"{v:.6f}f" for v in vec)
    c_str += "\n};\n"
    return c_str

# File path in the same folder as the script
script_dir = os.path.dirname(os.path.abspath(__file__))
file_path  = os.path.join(script_dir, "data.h")

with open(file_path, "w") as f:
    f.write("#ifndef DATA_H\n")
    f.write("#define DATA_H\n\n")
    f.write("/* GEMV dimensions: y = alpha * A * x, A is (M x N) */\n")
    f.write("#ifndef M\n")
    f.write(f"#define M {M}\n")
    f.write("#endif\n")
    f.write("#ifndef N\n")
    f.write(f"#define N {N}\n")
    f.write("#endif\n\n")
    f.write("float *mat_a_TCDM;\n")
    f.write("float *vec_x_TCDM;\n")
    f.write("float *dst_TCDM;\n\n")

    f.write("/* Scalar alpha */\n")
    f.write(f"float alpha = {alpha:.6f}f;\n\n")

    f.write("/* Matrix A in row-major 1D order */\n")
    f.write(matrix_to_c_array("mat_a", mat_a, M, N) + "\n")

    f.write("/* Input vector x */\n")
    f.write(vector_to_c_array("vec_x", vec_x, N) + "\n")

    f.write("/* Golden output vector y = alpha * A * x */\n")
    f.write(vector_to_c_array("golden", golden, M) + "\n")

    f.write("#endif\n")

print(f"data.h successfully generated at: {file_path}")