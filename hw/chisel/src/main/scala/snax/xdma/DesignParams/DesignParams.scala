package snax.xdma.DesignParams

import chisel3.util.log2Up
import chisel3.util.log2Ceil
import snax.DataPathExtension.DataPathExtensionParam
import snax.readerWriter.ReaderWriterParam
import snax.DataPathExtension.HasDataPathExtension
import snax.DataPathExtension.HasDataPathExtension

/*
 *  This is the collection of all design Params
 *  Design Params is placed all together with companion object to avoid multiple definition of one config & config conflict
 */

// AXI Params
class AXIParam(
    val dataWidth: Int = 512,
    val addrWidth: Int = 48
)

class CrossClusterParam(
    val maxMulticastDest: Int = 4,
    val maxDimension: Int = 6,
    val maxMemSize: Int = 4096,
    val AxiAddressWidth: Int = 48,
    val AxiDataWidth: Int = 512,
    val wordlineWidth: Int = 64
) {
  val maxLocalAddressWidth: Int =
    log2Ceil(maxMemSize) + 10 - log2Ceil(wordlineWidth / 8)
  val channelNum: Int = AxiDataWidth / wordlineWidth
}

// DMA Params
class XDMADataPathParam(
    val rwParam: ReaderWriterParam,
    val extParam: Seq[HasDataPathExtension] = Seq[HasDataPathExtension]()
)

class XDMAParam(
    val axiParam: AXIParam,
    val crossClusterParam: CrossClusterParam,
    rwParam: ReaderWriterParam,
    extParam: Seq[HasDataPathExtension] = Seq[HasDataPathExtension]()
) extends XDMADataPathParam(rwParam, extParam)
