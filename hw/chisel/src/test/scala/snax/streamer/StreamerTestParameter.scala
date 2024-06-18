package snax.streamer

import chisel3._
import chisel3.util._

/* the meaning of these testing parameters can be found at Parameter.scala */

object StreamerTestConstant extends CommonParams {

  def addrWidth = 17

  def MacScalingFactor = 4

  def temporalAddrGenUnitParams: Seq[TemporalAddrGenUnitParams] =
    Seq(
      TemporalAddrGenUnitParams(
        loopDim = 1,
        loopBoundWidth = 8,
        addrWidth = 17
      )
    )

  def fifoReaderParams: Seq[FIFOParams] = Seq(
    FIFOParams(64 * MacScalingFactor, 2),
    FIFOParams(64 * MacScalingFactor, 2),
    FIFOParams(64, 2)
  )

  def fifoWriterParams: Seq[FIFOParams] = Seq(
    FIFOParams(64 * MacScalingFactor, 2)
  )

  def fifoReaderWriterParams: Seq[FIFOParams] = Seq(
  )

  def stationarity = Seq(0, 0, 1, 1)

  def dataReaderParams: Seq[DataMoverParams] = Seq(
    DataMoverParams(
      tcdmPortsNum = 1 * MacScalingFactor,
      addrWidth,
      spatialBounds = Seq(2 * MacScalingFactor),
      spatialDim = 1,
      elementWidth = 32,
      fifoWidth = fifoReaderParams(0).width
    ),
    DataMoverParams(
      tcdmPortsNum = 1 * MacScalingFactor,
      addrWidth,
      spatialBounds = Seq(2 * MacScalingFactor),
      spatialDim = 1,
      elementWidth = 32,
      fifoWidth = fifoReaderParams(1).width
    ),
    DataMoverParams(
      tcdmPortsNum = 1,
      addrWidth,
      spatialBounds = Seq(2),
      spatialDim = 1,
      elementWidth = 32,
      fifoWidth = fifoReaderParams(2).width
    )
  )

  def dataWriterParams: Seq[DataMoverParams] = Seq(
    DataMoverParams(
      tcdmPortsNum = 1 * MacScalingFactor,
      addrWidth,
      spatialBounds = Seq(2 * MacScalingFactor),
      spatialDim = 1,
      elementWidth = 32,
      fifoWidth = fifoWriterParams(0).width
    )
  )

  def dataReaderWriterParams: Seq[DataMoverParams] = Seq()

  def tagName: String = ""

  def ifShareTempAddrGenLoopBounds = true
}

object StreamerWithReaderWriterTestConstant extends CommonParams {

  def addrWidth = 17
  
  def temporalAddrGenUnitParams: Seq[TemporalAddrGenUnitParams] =
    Seq(
      TemporalAddrGenUnitParams(
        loopDim = 3,
        loopBoundWidth = 32,
        addrWidth
      )
    )

  def fifoReaderParams: Seq[FIFOParams] = Seq(
    FIFOParams(512, 2),
    FIFOParams(512, 2)
  )

  def fifoWriterParams: Seq[FIFOParams] = Seq()

  def fifoReaderWriterParams: Seq[FIFOParams] = Seq(
    FIFOParams(2048, 2)
  )

  def stationarity = Seq(0, 0, 1, 1)

  def dataReaderParams: Seq[DataMoverParams] = Seq(
    DataMoverParams(
      tcdmPortsNum = 8,
      addrWidth,
      spatialBounds = Seq(8, 8),
      spatialDim = 2,
      elementWidth = 8,
      fifoWidth = fifoReaderParams(0).width
    ),
    DataMoverParams(
      tcdmPortsNum = 8,
      addrWidth,
      spatialBounds = Seq(8, 8),
      spatialDim = 2,
      elementWidth = 8,
      fifoWidth = fifoReaderParams(1).width
    )
  )

  def dataWriterParams: Seq[DataMoverParams] = Seq()

  // spatial unrolling should be the same
  def dataReaderWriterParams: Seq[DataMoverParams] = Seq(
    DataMoverParams(
      tcdmPortsNum = 32,
      addrWidth,
      spatialBounds = Seq(8, 8),
      spatialDim = 2,
      elementWidth = 32,
      fifoWidth = fifoReaderWriterParams(0).width
    )
  )

  def tagName: String = ""

  def ifShareTempAddrGenLoopBounds = true
}

object TestParameters {
  val streamer = StreamerParams(
    temporalAddrGenUnitParams = StreamerTestConstant.temporalAddrGenUnitParams,
    stationarity = StreamerTestConstant.stationarity,
    dataReaderParams = StreamerTestConstant.dataReaderParams,
    dataWriterParams = StreamerTestConstant.dataWriterParams,
    dataReaderWriterParams = StreamerTestConstant.dataReaderWriterParams,
    fifoReaderParams = StreamerTestConstant.fifoReaderParams,
    fifoWriterParams = StreamerTestConstant.fifoWriterParams,
    fifoReaderWriterParams = StreamerTestConstant.fifoReaderWriterParams,
    tagName = "abc"
  )

  val streamerWithReaderWriter = StreamerParams(
    temporalAddrGenUnitParams =
      StreamerWithReaderWriterTestConstant.temporalAddrGenUnitParams,
    stationarity = StreamerWithReaderWriterTestConstant.stationarity,
    dataReaderParams = StreamerWithReaderWriterTestConstant.dataReaderParams,
    dataWriterParams = StreamerWithReaderWriterTestConstant.dataWriterParams,
    dataReaderWriterParams =
      StreamerWithReaderWriterTestConstant.dataReaderWriterParams,
    fifoReaderParams = StreamerWithReaderWriterTestConstant.fifoReaderParams,
    fifoWriterParams = StreamerWithReaderWriterTestConstant.fifoWriterParams,
    fifoReaderWriterParams =
      StreamerWithReaderWriterTestConstant.fifoReaderWriterParams,
    tagName = "withReaderWriter"
  )

  val temporalAddrGenUnit = TemporalAddrGenUnitParams(
    loopDim = 3,
    loopBoundWidth = 8,
    addrWidth = 32
  )

  val spatialAddrGenUnit = SpatialAddrGenUnitParams(
    loopBounds = Seq(8, 8),
    loopDim = 2,
    addrWidth = 32
  )

  val dataMover = DataMoverParams(
    tcdmPortsNum = 8,
    addrWidth = 32,
    spatialBounds = Seq(8, 8),
    fifoWidth = 512,
    elementWidth = 8,
    spatialDim = 2
  )

  val fifo = FIFOParams(
    width = 512,
    depth = 4
  )
}
