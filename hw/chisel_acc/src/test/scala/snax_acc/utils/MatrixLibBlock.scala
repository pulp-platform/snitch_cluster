package snax_acc.utils

import scala.math.BigInt

import snax_acc.gemm.GemmParams
import snax_acc.gemm.TestParameters
import snax_acc.utils.MatrixLibBase._

/** Scala math submatrix multiplication library for Block Gemm verification Some functions are based on the
  * MatrixLibBase
  */
object MatrixLibBlock {

  /** Generate random M, K, N for testing the Block Gemm The test matrix are (M * meshRow, K * tileSize) and (K *
    * tileSize, N * meshCol)
    */
  def GenRandSizeTest() = {
    val rand = new scala.util.Random
    val M    = rand.between(1, TestParameters.MatrixLibBlock_random_M_range + 1)
    val K    = rand.between(1, TestParameters.MatrixLibBlock_random_K_range + 1)
    val N    = rand.between(1, TestParameters.MatrixLibBlock_random_N_range + 1)
    (M, K, N)
  }

  /** Generate the random test matrices A, B, C to compute D = A*B+C, with sizes:
    *   - A: (M * meshRow, K * tileSize)
    *   - B: (K * tileSize, N * meshCol)
    *   - C: (M * meshRow, N * meshCol)
    */
  def GenBlockMatrices(M: Int, K: Int, N: Int, params: GemmParams) = {
    val matrix_A = snax_acc.utils.MatrixLibBase.GenRandomMatrix(params.meshRow * M, params.tileSize * K)
    val matrix_B = snax_acc.utils.MatrixLibBase.GenRandomMatrix(params.tileSize * K, params.meshCol * N)
    val matrix_C =
      snax_acc.utils.MatrixLibBase.GenRandomMatrix(params.meshRow * M, params.meshCol * N, negative = false)

    (matrix_A, matrix_B, matrix_C)
  }

  /** Translate the large input matrixes to submatrices for inputting to Chisel module and golden result generation The
    * matrixes are arranged according to submatrix multiplication rules
    */
  def SplitBlockMatrix(M: Int, K: Int, N: Int, A: Array[Byte], B: Array[Byte], C: Array[Byte], params: GemmParams) = {
    val split_A = Array.ofDim[BigInt](M * K)
    val split_B = Array.ofDim[BigInt](K * N)
    val split_C = Array.ofDim[BigInt](M * N)

    for (i <- 0 until M) {
      for (j <- 0 until K) {
        val subMatrix_A = A.slice(
          (i * K + j) * params.meshRow * params.tileSize,
          (i * K + j + 1) * params.meshRow * params.tileSize
        )
        split_A(i * K + j) = MatrixArray2BigBus(params.meshRow, params.tileSize, subMatrix_A, params.dataWidthA)
      }
    }

    for (i <- 0 until K) {
      for (j <- 0 until N) {
        val submatrix_B = B.slice(
          (i * N + j) * params.tileSize * params.meshCol,
          (i * N + j + 1) * params.tileSize * params.meshCol
        )
        split_B(i * N + j) = MatrixArray2BigBus(params.tileSize, params.meshCol, submatrix_B, params.dataWidthB)
      }
    }

    for (i <- 0 until M) {
      for (j <- 0 until N) {
        val submatrix_C = C.slice(
          (i * N + j) * params.meshRow * params.meshCol,
          (i * N + j + 1) * params.meshRow * params.meshCol
        )
        split_C(i * N + j) = MatrixArray2BigBus(params.meshRow, params.meshCol, submatrix_C, params.dataWidthC)
      }
    }

    (split_A, split_B, split_C)
  }

  /** Translate the temporal index (i.e. the cycle) to spatial index (i.e. the matrix index).
    *   - The temporal index ranges from 0 to (M*K*N - 1).
    *   - Matrix A (size MxK) needs to be read in row major order, and is stored in row major order. (The testbench only
    *     sees a 1D array of size M*K.)
    *   - Matrix B (size KxN) needs to be read in column major order, and is stored in column major order.
    *   - The temporal index follows the following loop ordering:
    *     - for (m = 0 to M - 1);
    *       - for (n = 0 to N - 1);
    *         - for (k = 0 to K - 1);
    *           - (do operation)
    */
  def temporalToSpatialIndicesAB(temporalIndex: Int, K: Int, N: Int): (Int, Int) = {
    val m = temporalIndex / (K * N) // Row index of D
    val n = (temporalIndex / K) % N // Column index of D
    val k = temporalIndex       % K // Shared dimension index

    val indexA = m * K + k
    val indexB = n * K + k

    (indexA, indexB)
  }

  /** Translate the temporal index (i.e. the cycle) to spatial index (i.e. the matrix index) Matrix D (size MxN) needs
    * to be read in row major order, and is stored in row major order.
    */
  def temporalToSpatialIndexD(temporalIndex: Int, M: Int, N: Int): Int = {
    require(temporalIndex < M * N)
    val spatialIndex = temporalIndex
    spatialIndex
  }

  /** Software model of hardware block matrix multiplication implementation according to submatrix multiplication rule.
    * The matrix A and matrix B also needs to have a right data layout according to the submatrix multiplication rule
    */
  def BlockMatrixMul_1D(
    M:      Int,
    K:      Int,
    N:      Int,
    A:      Array[Byte],
    B:      Array[Byte],
    C:      Array[Byte],
    params: GemmParams
  ): Array[BigInt] = {
    require(A.length == M * K * params.meshRow * params.tileSize)
    require(B.length == K * N * params.tileSize * params.meshCol)
    require(C.length == M * N * params.meshRow * params.meshCol)

    val golden           = Array.ofDim[Int](M * N * params.meshRow * params.meshCol)
    val golden_split_mat = Array.ofDim[BigInt](M * N)

    for (m <- 0 until M) {
      for (n <- 0 until N) {
        for (k <- 0 until K) {

          val tile_A = A.slice(
            (m * K + k) * params.meshRow * params.tileSize,
            (m * K + k + 1) * params.meshRow * params.tileSize
          )
          val tile_B = B.slice(
            (n * K + k) * params.tileSize * params.meshCol,
            (n * K + k + 1) * params.tileSize * params.meshCol
          )

          val submatrix_temp1 =
            MatrixMul_1D(params.meshRow, params.tileSize, params.meshCol, tile_A, tile_B, 0, 0)

          val submatrix_temp = golden // Size meshRow * meshCol
            .slice(
              (m * N + n) * params.meshRow * params.meshCol,
              (m * N + n + 1) * params.meshRow * params.meshCol
            )
            .zip(submatrix_temp1)
            .map { case (a, b) => a + b }

          for (t <- 0 until params.meshRow * params.meshCol) {
            golden((m * N + n) * params.meshRow * params.meshCol + t) = submatrix_temp(t)
          }
        }

        // Add C
        val tile_golden   = golden.slice(
          (m * N + n) * params.meshRow * params.meshCol,
          (m * N + n + 1) * params.meshRow * params.meshCol
        )
        val tile_C        = C.slice(
          (m * N + n) * params.meshRow * params.meshCol,
          (m * N + n + 1) * params.meshRow * params.meshCol
        )
        val tile_golden_C = tile_golden.zip(tile_C).map { case (a, b) => a + b }

        // Pack full tile into bus
        golden_split_mat(m * N + n) =
          MatrixArray2BigBus(params.meshRow, params.meshCol, tile_golden_C, params.dataWidthAccum)
      }
    }
    golden_split_mat
  }

}
