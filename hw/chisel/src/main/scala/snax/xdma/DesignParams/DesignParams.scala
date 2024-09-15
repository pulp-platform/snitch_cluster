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

// DMA Params
class DMADataPathParam(
    val axiParam: AXIParam,
    val rwParam: ReaderWriterParam,
    val extParam: Seq[HasDataPathExtension] = Seq[HasDataPathExtension]()
)

class DMACtrlParam(
    val readerparam: ReaderWriterParam,
    val writerparam: ReaderWriterParam,
    val readerextparam: Seq[DataPathExtensionParam] =
      Seq[DataPathExtensionParam](),
    val writerextparam: Seq[DataPathExtensionParam] =
      Seq[DataPathExtensionParam]()
)
