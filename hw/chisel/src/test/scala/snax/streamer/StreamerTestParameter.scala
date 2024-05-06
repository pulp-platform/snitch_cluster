package snax.streamer

import chisel3._
import chisel3.util._

/* the meaning of these testing parameters can be found at Parameter.scala */

object TemporalAddrGenUnitTestParameters {
  def loopDim = 3
  def loopBoundWidth = 8
  def addrWidth = 32

}

object SpatialAddrGenUnitTestParameters {
  def loopBounds = Seq(8, 8)
  def loopDim = loopBounds.length
  def addrWidth = 32
}

object DataMoverTestParameters {
  def tcdmPortsNum = 8
  def tcdmDataWidth = 64
  def spatialBounds = Seq(8, 8)
  def addrWidth = 32
  def fifoWidth = 512
  def elementWidth = 8

  def spatialDim = spatialBounds.length

}

object StreamerTestConstant extends CommonParams {

  def MacScalingFactor = 4

  def temporalAddrGenUnitParams: TemporalAddrGenUnitParams =
    TemporalAddrGenUnitParams(
      loopDim = 1,
      loopBoundWidth = 8,
      addrWidth
    )

  def fifoReaderParams: Seq[FIFOParams] = Seq(
    FIFOParams(64 * MacScalingFactor, 2),
    FIFOParams(64 * MacScalingFactor, 2),
    FIFOParams(64, 2)
  )

  def fifoWriterParams: Seq[FIFOParams] = Seq(
    FIFOParams(64 * MacScalingFactor, 2)
  )

  def stationarity = Seq(0, 0, 1, 1)

  def dataReaderParams: Seq[DataMoverParams] = Seq(
    DataMoverParams(
      tcdmPortsNum = 1 * MacScalingFactor,
      spatialBounds = Seq(2 * MacScalingFactor),
      spatialDim = 1,
      elementWidth = 32,
      fifoWidth = fifoReaderParams(0).width
    ),
    DataMoverParams(
      tcdmPortsNum = 1 * MacScalingFactor,
      spatialBounds = Seq(2 * MacScalingFactor),
      spatialDim = 1,
      elementWidth = 32,
      fifoWidth = fifoReaderParams(1).width
    ),
    DataMoverParams(
      tcdmPortsNum = 1,
      spatialBounds = Seq(2),
      spatialDim = 1,
      elementWidth = 32,
      fifoWidth = fifoReaderParams(2).width
    )
  )

  def dataWriterParams: Seq[DataMoverParams] = Seq(
    DataMoverParams(
      tcdmPortsNum = 1 * MacScalingFactor,
      spatialBounds = Seq(2 * MacScalingFactor),
      spatialDim = 1,
      elementWidth = 32,
      fifoWidth = fifoWriterParams(0).width
    )
  )

  def tagName: String = ""
}

object FIFOTestParameters {
  def fifoWidth = 512
  def fifoDepth = 4
}
