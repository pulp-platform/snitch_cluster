import math

import numpy as np

scaling_factor = 0.0001
inverse_scaling_factor = math.floor(1 / scaling_factor)


def find_max(array: np.ndarray):
    """Find the maximum value in an array."""
    max_value = array[0]
    for value in array:
        if value > max_value:
            max_value = value
    return max_value


def subtract_max(array: np.ndarray, max_value: np.int32):
    """Subtract the maximum value from each element in the array."""
    new_array = np.empty_like(array, dtype=np.int32)
    for i in range(len(array)):
        if (int(array[i]) - int(max_value)) < np.iinfo(np.int32).min:
            new_array[i] = np.iinfo(np.int32).min
        else:
            new_array[i] = array[i] - max_value
    return new_array

def integer_poly(x: np.int32, inverse_scaling_factor: int, a: float, b: float, c: float):
    a_scaled = int(a * inverse_scaling_factor)
    b_scaled = int(b * inverse_scaling_factor)
    c_scaled = int(c * (inverse_scaling_factor ** 3)) >> math.floor(math.log2(inverse_scaling_factor) * 2)

    output = np.int32(((a_scaled * (int(x) + b_scaled) ** 2) >>  math.floor(math.log2(inverse_scaling_factor)  * 2)) + c_scaled)

    scaling_factor_out = (inverse_scaling_factor ** 3) >> math.floor(math.log2(inverse_scaling_factor) * 2)

    return output, scaling_factor_out


def integer_exp(array: np.ndarray, inverse_scaling_factor: int):
    """Calculate the exponential of each element in the array."""
    exp_array = np.empty_like(array, dtype=np.int32)
    a = 0.3585
    b = 1.353
    c = 0.344
    q_ln2 = int(math.log(2) * inverse_scaling_factor)
    for i in range(len(array)):
        z = math.floor(-array[i] / q_ln2) #TODO: make this a multiplication
        q_p = array[i] + z * q_ln2
        q_l, scaling_factor_exp = integer_poly(q_p, inverse_scaling_factor, a, b, c)
        exp_array[i] = int(int(q_l) >> z)
    return exp_array, scaling_factor_exp

def integer_softmax(array: np.ndarray, scaling_factor_exp: int):
    max = find_max(array)
    array = subtract_max(array, max)
    array, scaling_factor_exp = integer_exp(array, scaling_factor_exp)
    sum_exp = sum(array)
    array_out = array / np.float32(sum_exp)
    return array_out


np.random.seed(42)
array = np.random.randint(-40000, 40000, size=10).astype(np.int32)
print("input array:", array * scaling_factor)
print("golden array:", np.exp(array*scaling_factor)/ np.sum(np.exp(array*scaling_factor)))
print("received array:", integer_softmax(array, inverse_scaling_factor))