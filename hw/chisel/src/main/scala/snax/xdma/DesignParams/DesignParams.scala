package snax.xdma.DesignParams
import chisel3.util.log2Ceil

import snax.DataPathExtension.HasDataPathExtension
import snax.readerWriter.ReaderWriterParam

/*
 *  This is the collection of all design Params
 *  Design Params is placed all together with companion object to avoid multiple definition of one config & config conflict
 */

// AXI Params
class XDMAAXIParam(val dataWidth: Int = 512, val addrWidth: Int = 48)

class XDMACrossClusterParam(
  val maxMulticastDest:     Int = 4,
  val maxTemporalDimension: Int = 5,
  val maxSpatialDimension:  Int = 1,
  val tcdmSize:             Int = 4096,
  val AxiAddressWidth:      Int = 48,
  val AxiDataWidth:         Int = 512,
  val wordlineWidth:        Int = 64
) {
  val tcdmAddressWidth: Int =
    log2Ceil(tcdmSize) + 10 - log2Ceil(wordlineWidth / 8)
  val channelNum:       Int = AxiDataWidth / wordlineWidth
}

// Cfg IO Params
class XDMAConfigParam(val addrWidth: Int, val dataWidth: Int)

// DMA Params
class XDMADataPathParam(
  val rwParam:  ReaderWriterParam,
  val extParam: Seq[HasDataPathExtension] = Seq[HasDataPathExtension]()
)

class XDMAParam(
  val cfgParam:          XDMAConfigParam,
  val axiParam:          XDMAAXIParam,
  val crossClusterParam: XDMACrossClusterParam,
  rwParam:               ReaderWriterParam,
  extParam:              Seq[HasDataPathExtension] = Seq[HasDataPathExtension]()
) extends XDMADataPathParam(rwParam, extParam)
