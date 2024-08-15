package snax.xdma.DesignParams

import chisel3.util.log2Up
import snax.xdma.xdmaExtension._
import chisel3.util.log2Ceil

/*
 *  This is the collection of all design Params
 *  Design Params is placed all together with companion object to avoid multiple definition of one config & config conflict
 */

// TCDM Params

class TCDMParam(
    val addrWidth: Int = 17, // 128kB tcdm size
    val dataWidth: Int = 64, // Connect to narrow xbar
    val numChannel: Int = 8, // With eight channels
    val tcdmSize: Int = 128 // The size of tcdm
)

object TCDMParam {
  def apply(dataWidth: Int, numChannel: Int, tcdmSize: Int) =
    new TCDMParam(log2Ceil(tcdmSize) + 10, dataWidth, numChannel, tcdmSize)
  def apply() = new TCDMParam(
    addrWidth = 17,
    dataWidth = 64,
    numChannel = 8,
    tcdmSize = 128
  )
}

// Streamer Params

class AddressGenUnitParam(
    val dimension: Int,
    val addressWidth: Int,
    val numChannel: Int,
    val outputBufferDepth: Int,
    val tcdmSize: Int
)

object AddressGenUnitParam {
  // The Very Simple instantiation of the Param
  def apply() = new AddressGenUnitParam(
    dimension = 2,
    addressWidth = 17, // For the address of 128kB tcdm size
    numChannel = 8,
    outputBufferDepth = 8,
    tcdmSize = 128
  )
  def apply(
      dimension: Int,
      numChannel: Int,
      outputBufferDepth: Int,
      tcdmSize: Int
  ) = new AddressGenUnitParam(
    dimension = dimension,
    addressWidth = log2Ceil(tcdmSize) + 10,
    numChannel = numChannel,
    outputBufferDepth = outputBufferDepth,
    tcdmSize = tcdmSize
  )
}

class ReaderWriterParam(
    dimension: Int = 3,
    tcdmDataWidth: Int = 64,
    tcdmSize: Int = 128,
    numChannel: Int = 8,
    addressBufferDepth: Int = 8,
    dataBufferDepth: Int = 8
) {
  val agu_param = AddressGenUnitParam(
    dimension = dimension,
    numChannel = numChannel,
    outputBufferDepth = addressBufferDepth,
    tcdmSize = tcdmSize
  )

  val tcdm_param = TCDMParam(
    dataWidth = tcdmDataWidth,
    numChannel = numChannel,
    tcdmSize = tcdmSize
  )

  // Data buffer's depth
  val bufferDepth = dataBufferDepth
}

// AXI Params
class AXIParam(
    val dataWidth: Int = 512,
    val addrWidth: Int = 48
)

object AXIParam {
  def apply() = new AXIParam()
  def apply(dataWidth: Int, addrWidth: Int) = new AXIParam(dataWidth, addrWidth)
}

// DMA Params
class DMADataPathParam(
    val axiParam: AXIParam,
    val rwParam: ReaderWriterParam,
    val extParam: Seq[HasDMAExtension] = Seq[HasDMAExtension]()
)

class DMAExtensionParam(
    val moduleName: String,
    val userCsrNum: Int,
    val dataWidth: Int = 512
) {
  require(dataWidth > 0)
  require(userCsrNum >= 0)
}

class DMACtrlParam(
    val readerparam: ReaderWriterParam,
    val writerparam: ReaderWriterParam,
    val readerextparam: Seq[DMAExtensionParam] = Seq[DMAExtensionParam](),
    val writerextparam: Seq[DMAExtensionParam] = Seq[DMAExtensionParam]()
)
