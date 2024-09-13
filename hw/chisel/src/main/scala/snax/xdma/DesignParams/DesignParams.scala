package snax.xdma.DesignParams

import chisel3.util.log2Up
import chisel3.util.log2Ceil
import snax.readerWriter.ReaderWriterParam
import snax.xdma.xdmaExtension._

/*
 *  This is the collection of all design Params
 *  Design Params is placed all together with companion object to avoid multiple definition of one config & config conflict
 */

// AXI Params
class AXIParam(
    val dataWidth: Int = 512,
    val addrWidth: Int = 48
)

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
