package snax_acc.simd

import chisel3._
import chisel3.util._

case class RescaleSIMDParams(
    inputType: Int,
    outputType: Int,
    constantType: Int,
    constantMulType: Int,
    dataLen: Int,
    laneLen: Int,
    readWriteCsrNum: Int
)

// parameters for Rescale SIMD accelerator
object RescaleSIMDConstant {

  // data width
  def inputType = 32
  def outputType = 8
  def constantType = 8
  def constantMulType = 32

  // SIMD parallelism
  def dataLen = 64
  def laneLen = 64

  // csrManager parameters, we use 3 CSR for Post-processing SIMD configuration,
  // CSR 4 for the vector length,
  def readWriteCsrNum: Int = 4

}

object DefaultConfig {
  val rescaleSIMDConfig = RescaleSIMDParams(
    inputType = RescaleSIMDConstant.inputType,
    outputType = RescaleSIMDConstant.outputType,
    constantType = RescaleSIMDConstant.constantType,
    constantMulType = RescaleSIMDConstant.constantMulType,
    dataLen = RescaleSIMDConstant.dataLen,
    laneLen = RescaleSIMDConstant.laneLen,
    readWriteCsrNum = RescaleSIMDConstant.readWriteCsrNum
  )
}

object PipelinedConfig {
  val rescaleSIMDConfig = RescaleSIMDParams(
    inputType = RescaleSIMDConstant.inputType,
    outputType = RescaleSIMDConstant.outputType,
    constantType = RescaleSIMDConstant.constantType,
    constantMulType = RescaleSIMDConstant.constantMulType,
    dataLen = RescaleSIMDConstant.dataLen,
    laneLen = 8,
    readWriteCsrNum = RescaleSIMDConstant.readWriteCsrNum
  )
}
