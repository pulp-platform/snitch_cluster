package snax.streamer

import chisel3._
import chisel3.util._

/** This class represents some common parameters used in several modules
  * @param addrWidth
  *   The bit width of the address.
  * @param tcdmDataWidth
  *   data width for each TCDm port
  */
trait CommonParams {

  def addrWidth = 32
  def tcdmDataWidth = 64

}

/** This class represents all the parameters for the Temporal Address Generation
  * Unit.
  * @param loopDim
  *   The dimension of the temporal loops = the number of for loops.
  * @param loopBoundWidth
  *   The bit width of the loop bounds.
  * @param addrWidth
  *   The bit width of the address.
  */
case class TemporalAddrGenUnitParams(
    loopDim: Int,
    loopBoundWidth: Int,
    addrWidth: Int
)

/** This class represents all the parameters for the Spatial Address Generation
  * Unit.
  * @param loopDim
  *   The number of nested for loops.
  * @param loopBounds
  *   The bounds of each loop dimension.
  * @param addrWidth
  *   The bit width of the address.
  */
case class SpatialAddrGenUnitParams(
    loopDim: Int,
    loopBounds: Seq[Int],
    addrWidth: Int
)

/** This class represents all the parameters for the Data Mover (including Data
  * Reader and Data Writer).
  *
  * @param tcdmPortsNum
  *   the number of TCDM ports connected to each data mover
  * @param spatialBounds
  *   spatial unrolling factors (your parfor) for each data mover
  * @param spatialDim
  *   the dimension of spatial unrolling factors (your parfor) for each data
  *   mover
  * @param elementWidth
  *   single data element width for each data mover, useful for generating
  *   spatial addresses
  * @param fifoWidth
  *   FIFO width
  */
case class DataMoverParams(
    tcdmPortsNum: Int,
    spatialBounds: Seq[Int],
    spatialDim: Int,
    elementWidth: Int,
    fifoWidth: Int
) extends CommonParams

/** FIFO parameters
  *
  * @param width
  *   the width of the FIFO
  * @param depth
  *   the depth of the FIFO
  */
case class FIFOParams(width: Int, depth: Int)

/** trait for Streamer core parameters
  * @param temporalAddrGenUnitParams
  *   a parameters case class instantiation for temporal address generation unit
  * @param stationarity
  *   accelerator stationarity feature for each data mover (data reader and data
  *   writer)
  * @param dataReaderParams
  *   a seq of case class DataMoverParams instantiation for the Data Readers
  * @param dataWriterParams
  *   a seq of case class DataMoverParams instantiation for the Data Writers
  * @param fifoReaderParams
  *   a seq of case class FIFOParams instantiation for the FIFO connected to
  *   Data Readers
  * @param fifoReaderParams
  *   a seq of case class FIFOParams instantiation for the FIFO connected to
  *   Data Writers
  */
trait HasStreamerCoreParams {

  val temporalAddrGenUnitParams: Seq[TemporalAddrGenUnitParams]

  val stationarity: Seq[Int]

  val dataReaderParams: Seq[DataMoverParams]
  val dataWriterParams: Seq[DataMoverParams]

  val fifoReaderParams: Seq[FIFOParams]
  val fifoWriterParams: Seq[FIFOParams]

  val readOnlyCsrNum: Int
  val csrAddrWidth: Int

  val ifShareTempAddrGenLoopBounds: Boolean
}

/** trait for Streamer inferred parameters
  * @param temporalDim
  *   the dimension of the temporal loop
  * @param temporalBoundWidth
  *   the register width for storing the temporal loop bound
  * @param spatialDim
  *   a Seq contains the spatial dimensions for both data reader and data writer
  * @param tcdmDataWidth
  *   data width for each TCDm port
  * @param addrWidth
  *   the address width
  * @param dataReaderNum
  *   number of data readers
  * @param dataWriterNum
  *   number of data writers
  * @param dataMoverNum
  *   the number of data movers (including data reader and writer)
  * @param dataReaderTcdmPorts
  *   a Seq contains the number of TCDM ports connected to each data reader
  * @param dataWriterTcdmPorts
  *   a Seq contains the number of TCDM ports connected to each data writer
  * @param tcdmPortsNum
  *   the total number of TCDM ports connected the data movers (including data
  *   reader and writer)
  * @param fifoWidthReader
  *   FIFO width for the data readers
  * @param fifoWidthWriter
  *   FIFO width for the data writers
  */
trait HasStreamerInferredParams extends HasStreamerCoreParams {

  val temporalDimInt: Int =
    temporalAddrGenUnitParams(0).loopDim.asInstanceOf[Int]
  val temporalDimSeq: Seq[Int] =
    temporalAddrGenUnitParams.map(_.loopDim).asInstanceOf[Seq[Int]]
  val temporalBoundWidth: Int = temporalAddrGenUnitParams(0).loopBoundWidth

  val spatialDim: Seq[Int] =
    dataReaderParams.map(_.spatialDim) ++ dataWriterParams.map(_.spatialDim)

  val dataReaderNum: Int = dataReaderParams.length
  val dataWriterNum: Int = dataWriterParams.length
  val dataMoverNum: Int = dataReaderNum + dataWriterNum
  val dataReaderTcdmPorts: Seq[Int] = dataReaderParams.map(_.tcdmPortsNum)
  val dataWriterTcdmPorts: Seq[Int] = dataWriterParams.map(_.tcdmPortsNum)
  val tcdmPortsNum: Int = dataReaderTcdmPorts.sum + dataWriterTcdmPorts.sum

  val fifoWidthReader: Seq[Int] = fifoReaderParams.map(_.width)
  val fifoWidthWriter: Seq[Int] = fifoWriterParams.map(_.width)

}

/** This case class represents all the parameters for the Streamer
  * @param temporalAddrGenUnitParams
  * @param stationarity
  * @param dataReaderParams
  * @param dataWriterParams
  * @param fifoReaderParams
  * @param fifoWriterParams
  *   the meaning of these parameters can be found at the top of this file the
  *   default value of these parameters is from the StreamerTestConstant object
  */
case class StreamerParams(
    temporalAddrGenUnitParams: Seq[TemporalAddrGenUnitParams],
    stationarity: Seq[Int],
    dataReaderParams: Seq[DataMoverParams],
    dataWriterParams: Seq[DataMoverParams],
    fifoReaderParams: Seq[FIFOParams],
    fifoWriterParams: Seq[FIFOParams],
    readOnlyCsrNum: Int = 1,
    csrAddrWidth: Int = 32,
    ifShareTempAddrGenLoopBounds: Boolean = true,
    tagName: String = ""
) extends HasStreamerCoreParams
    with HasStreamerInferredParams
    with CommonParams
