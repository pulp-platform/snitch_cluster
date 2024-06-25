package snax_acc.gemm
import chisel3._
import chisel3.util._

case class GemmParams(
    dataWidthA: Int,
    dataWidthB: Int,
    dataWidthMul: Int,
    dataWidthC: Int,
    dataWidthAccum: Int,
    subtractionCfgWidth: Int,
    meshRow: Int,
    tileSize: Int,
    meshCol: Int,
    addrWidth: Int,
    sizeConfigWidth: Int
)

object GemmConstant {

  def dataWidthA = 8
  def dataWidthB = dataWidthA
  def dataWidthMul = dataWidthA * 4
  def dataWidthC = dataWidthA * 4
  def dataWidthAccum = dataWidthA * 4

  def subtractionCfgWidth = 32

  def meshRow = 8
  def tileSize = 8
  def meshCol = 8

  def addrWidth = 32
  def sizeConfigWidth = 32

}

object DefaultConfig {
  val gemmConfig = GemmParams(
    GemmConstant.dataWidthA,
    GemmConstant.dataWidthB,
    GemmConstant.dataWidthMul,
    GemmConstant.dataWidthC,
    GemmConstant.dataWidthAccum,
    GemmConstant.subtractionCfgWidth,
    GemmConstant.meshRow,
    GemmConstant.tileSize,
    GemmConstant.meshCol,
    GemmConstant.addrWidth,
    GemmConstant.sizeConfigWidth
  )
}
