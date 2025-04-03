package snax_acc.utils

import scala.math.BigInt
import scala.math.abs

import chisel3._

/** Scala math matrix multiplication library for Gemm verification */
object MatrixLibBase {

  /** Generate a random data matrix of 8-bit ints (Byte in Scala) */
  def GenRandomMatrix(nRow: Int, nCol: Int, negative: Boolean = true) = {
    val random_matrix = Array.ofDim[Byte](nRow * nCol)
    val rand          = new scala.util.Random
    val minVal        = if (negative) -128 else 0
    val maxVal        = 127

    for (r <- 0 until nRow) {
      for (c <- 0 until nCol) {
        random_matrix(r * nCol + c) = rand.between(minVal, maxVal).toByte
      }
    }
    random_matrix
  }

  def GenRandomSubtractionValue() = {
    val rand = new scala.util.Random
    (rand.between(0, 127).toByte, rand.between(0, 127).toByte)
  }

  /** Translate Byte / Int data to hex data for interaction with the Chisel module
    *
    * @param width
    *   The number of hex symbols
    */
  def int2hex(width: Int, intValue: Int): String = {
    require(abs(intValue) <= (BigInt(1) << (4 * width - 1)))

    val paddingChar = if (intValue >= 0) '0' else 'f'
    val baseString  = f"$intValue%x".reverse
    if (baseString.length > width) {
      baseString.slice(0, width).reverse
    } else {
      baseString.padTo(width, paddingChar).reverse
    }
  }

  /** Translate matrix to big bus for inputting to Chisel module The data type is Array[Int]
    *   - e.g., A = [1, 2, 3, 4] and nbBits = 16 -> 0x0004000300020001
    *
    * @param nbBits
    *   The number of bits where each data element is packed into.
    */
  def MatrixArray2BigBus(nRow: Int, nCol: Int, A: Array[Int], nbBits: Int) = {
    require(A.length == nRow * nCol)
    require(nbBits % 4 == 0, "nbBits must be a multiple of 4")
    val nbHexSymbols    = nbBits / 4
    var flattenedUInt_A = ""

    for (i <- 0 until nRow) {
      for (j <- 0 until nCol) {
        flattenedUInt_A = int2hex(nbHexSymbols, A(i * nCol + j)) + flattenedUInt_A
      }
    }

    BigInt(flattenedUInt_A, 16)
  }

  /** Translate matrix to big bus for inputting to Chisel module The data type is Array[Byte] */
  def MatrixArray2BigBus(nRow: Int, nCol: Int, A: Array[Byte], nbBits: Int): BigInt =
    MatrixArray2BigBus(nRow, nCol, A.map(_.toInt), nbBits)

  // Translate the Chisel output big data bus to matrix for checking with the golden results
  def BigBus2Matrix(nRow: Int, nCol: Int, matrix: UInt) = {
    val result = Array.ofDim[Int](nRow * nCol)
    for (i <- 0 until nRow) {
      for (j <- 0 until nCol) {
        result(i + j * nRow) = matrix((i + j * nRow + 1) * 32, (i + j * nRow) * 32).litValue.toInt
      }
    }
    result
  }

  /** Assert the Chisel output results equal golden vector. The equality check happens within the bus-domain, where each
    * assertion checks a whole tile of the data.
    */
  def CheckResults[T: Integral](A: Array[T], B: Array[T]): Unit = {
    val num = implicitly[Integral[T]]
    for (i <- 0 until A.length) {
      assert(num.equiv(A(i), B(i)), f"Error: ${A(i)} != ${B(i)} at index $i")
    }
  }

  /** Matrix multiplication with one dimension Array[Byte] data type */
  def MatrixMul_1D(
    meshRow:       Int,
    tileSize:      Int,
    meshCol:       Int,
    A:             Array[Byte],
    B:             Array[Byte],
    subtraction_a: Byte,
    subtraction_b: Byte
  ): Array[Int] = {
    val golden = Array.ofDim[Int](meshRow * meshCol)
    for (i <- 0 until meshRow) {
      for (j <- 0 until meshCol) {
        golden(i * meshCol + j) = 0
        for (k <- 0 until tileSize) {
          // assuming the matrix B is arranged as N data layout
          golden(i * meshCol + j) =
            golden(i * meshCol + j) + (A(i * tileSize + k) - subtraction_a) * (B(k + j * tileSize) - subtraction_b)
        }
      }
    }
    golden
  }

}
