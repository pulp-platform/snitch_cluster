package snax.streamer

import chisel3._
import chisel3.util._

/* the meaning of these testing parameters can be found at Parameter.scala */

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

object TestParameters {
  val streamer = StreamerParams(
    temporalAddrGenUnitParams = StreamerTestConstant.temporalAddrGenUnitParams,
    stationarity = StreamerTestConstant.stationarity,
    dataReaderParams = StreamerTestConstant.dataReaderParams,
    dataWriterParams = StreamerTestConstant.dataWriterParams,
    fifoReaderParams = StreamerTestConstant.fifoReaderParams,
    fifoWriterParams = StreamerTestConstant.fifoWriterParams,
    tagName = "abc"
  )

  val temporalAddrGenUnit =  TemporalAddrGenUnitParams(
    loopDim = 3,
    loopBoundWidth = 8,
    addrWidth = 32
  )

  val spatialAddrGenUnit = SpatialAddrGenUnitParams (
    loopBounds = Seq(8, 8),
    loopDim = 2,
    addrWidth = 32
  )

  val dataMover = DataMoverParams (
    tcdmPortsNum = 8,
    spatialBounds = Seq(8, 8),
    fifoWidth = 512,
    elementWidth = 8,
    spatialDim = 2,
    )

  val fifo = FIFOParams (
    width = 512,
    depth = 4
  ) 
}

