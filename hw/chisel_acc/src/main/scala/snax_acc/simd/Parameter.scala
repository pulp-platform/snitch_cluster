package snax_acc.simd

case class RescaleSIMDParams(
  inputType:                     Int,
  outputType:                    Int,
  constantType:                  Int,
  constantMulType:               Int,
  dataLen:                       Int,
  laneLen:                       Int,
  readWriteCsrNum:               Int,
  sharedScaleFactorPerGroupSize: Int
)

// parameters for Rescale SIMD accelerator
object RescaleSIMDConstant {

  // data width
  def inputType       = 32
  def outputType      = 8
  def constantType    = 8
  def constantMulType = 32

  // SIMD parallelism
  def dataLen = 64
  def laneLen = 64

  // csrManager parameters, refer to the SIMD spec for more details
  def readWriteCsrNum: Int = 13

  // sharedScaleFactorPerGroupSize
  def sharedScaleFactorPerGroupSize = 8

}

object DefaultConfig {
  val rescaleSIMDConfig = RescaleSIMDParams(
    inputType                     = RescaleSIMDConstant.inputType,
    outputType                    = RescaleSIMDConstant.outputType,
    constantType                  = RescaleSIMDConstant.constantType,
    constantMulType               = RescaleSIMDConstant.constantMulType,
    dataLen                       = RescaleSIMDConstant.dataLen,
    laneLen                       = RescaleSIMDConstant.laneLen,
    readWriteCsrNum               = RescaleSIMDConstant.readWriteCsrNum,
    sharedScaleFactorPerGroupSize = RescaleSIMDConstant.sharedScaleFactorPerGroupSize
  )
}

object PipelinedConfig {
  val rescaleSIMDConfig = RescaleSIMDParams(
    inputType                     = RescaleSIMDConstant.inputType,
    outputType                    = RescaleSIMDConstant.outputType,
    constantType                  = RescaleSIMDConstant.constantType,
    constantMulType               = RescaleSIMDConstant.constantMulType,
    dataLen                       = RescaleSIMDConstant.dataLen,
    laneLen                       = 8,
    readWriteCsrNum               = RescaleSIMDConstant.readWriteCsrNum,
    sharedScaleFactorPerGroupSize = 1
  )
}
