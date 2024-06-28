package snax_acc.reshuffle

import chisel3._
import chisel3.util._

case class ReshufflerParams(
    transposeInWidth: Int,
    transposeOutWidth: Int,
    inputWidth: Int,
    outputWidth: Int,
    poolLaneLen: Int,
    readWriteCsrNum: Int,
    sizeConfigWidth: Int,
    tagName: String = "Reshuffler"
)

// parameters for Reshuffler accelerator
object ReshufflerConstant {
  def transposeInWidth = 512
  def transposeOutWidth = 512

  // input data type
  def inputWidth = 8
  // output data type
  def outputWidth = 8

  // Pooling parallelism
  def poolLaneLen = 64

  // we use 1 CSR for Reshuffler configuration
  def readWriteCsrNum = 1

  def sizeConfigWidth = 32

}

object DefaultConfig {
  // default configuration for the Reshuffler accelerator
  val ReshufflerConfig = ReshufflerParams(
    transposeInWidth = ReshufflerConstant.transposeInWidth,
    transposeOutWidth = ReshufflerConstant.transposeOutWidth,
    inputWidth = ReshufflerConstant.inputWidth,
    outputWidth = ReshufflerConstant.outputWidth,
    poolLaneLen = ReshufflerConstant.poolLaneLen,
    readWriteCsrNum = ReshufflerConstant.readWriteCsrNum,
    sizeConfigWidth = ReshufflerConstant.sizeConfigWidth
  )
}
