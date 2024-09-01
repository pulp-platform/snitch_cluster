package snax.xdma.xdmaFrontend

import chisel3._
import chisel3.util._

import snax.utils._

import snax.xdma.CommonCells.DecoupledCut._
import snax.xdma.CommonCells.BitsConcat._

import snax.xdma.xdmaStreamer._
import snax.xdma.CommonCells._
import snax.xdma.DesignParams._

// The ReaderWriterCfg Class that used for interface between local Datapath and DMA Ctrl
// The length of addresses is the short version, which is just enough to reside TCDM
class DMADataPathCfgIO(param: DMADataPathParam) extends Bundle {
  val aguCfg =
    new AddressGenUnitCfgIO(param =
      param.rwParam.aguParam
    ) // Buffered within AGU
  val readerwriterCfg = new ReaderWriterCfgIO(param.rwParam)
  val extCfg = if (param.extParam.length != 0) {
    Vec(
      param.extParam.map { i => i.totalCsrNum }.reduce(_ + _) + 1,
      UInt(32.W)
    ) // The total csr required by all extension + 1 for the bypass signal
  } else Vec(0, UInt(32.W))

  // The config forwarding technics is easy to be implemented: Just by reading agu_cfg.Ptr, the destination can be determined
  // However, the data forwarding is still challenging: Shall we use the current DMA to move the data? (I suggest that we do this in the initial implementation)
  // Serialize function to convert config into one long UInt
  def serialize(): UInt = {
    extCfg.asUInt ++ readerwriterCfg.asUInt ++ aguCfg.asUInt
  }

  // Deserialize function to convert long UInt back to config
  // The conversion is done from LSB to MSB
  // After the conversion, the remaining data is returned for further conversion
  def deserialize(data: UInt): UInt = {
    var remainingData = data

    // Assigning aguCfg
    aguCfg := remainingData(aguCfg.asUInt.getWidth - 1, 0).asTypeOf(aguCfg)
    remainingData = remainingData(remainingData.getWidth - 1, aguCfg.getWidth)

    // Assigning readerwriterCfg
    readerwriterCfg := remainingData(readerwriterCfg.asUInt.getWidth - 1, 0)
      .asTypeOf(readerwriterCfg)
      .asTypeOf(readerwriterCfg)
    remainingData =
      remainingData(remainingData.getWidth - 1, readerwriterCfg.asUInt.getWidth)

    // Assigning extCfg
    extCfg := remainingData(extCfg.asUInt.getWidth - 1, 0).asTypeOf(extCfg)
    remainingData =
      remainingData(remainingData.getWidth - 1, extCfg.asUInt.getWidth)
    remainingData
  }
}

// The internal sturctured class that used to store the CFG of reader and writer
// The serialized version of this class will be the actual output and input of the DMACtrl (which is to AXI)
// The full address is included in this class, for the purpose of cross-cluster communication
// Loopback signal is also included in this class, for the purpose of early judgement
class DMADataPathCfgInternalIO(param: DMADataPathParam)
    extends DMADataPathCfgIO(param: DMADataPathParam) {
  val loopBack = Bool()
  val readerPtr = UInt(param.axiParam.addrWidth.W)
  val writerPtr = UInt(param.axiParam.addrWidth.W)
  override def serialize(): UInt = {
    super.serialize() ++ writerPtr ++ readerPtr
  }

  override def deserialize(data: UInt): UInt = {
    var remainingData = data;

    // Assigning readerPtr + writerPtr
    readerPtr := remainingData(readerPtr.getWidth - 1, 0)
    remainingData =
      remainingData(remainingData.getWidth - 1, readerPtr.getWidth)

    writerPtr := remainingData(writerPtr.getWidth - 1, 0)
    remainingData =
      remainingData(remainingData.getWidth - 1, writerPtr.getWidth)

    // Assigning loopBack
    loopBack := false.B

    // Assigning remaining wires
    remainingData = super.deserialize(remainingData)
    remainingData
  }

}

class DMADataPath(
    readerparam: DMADataPathParam,
    writerparam: DMADataPathParam,
    clusterName: String = "unnamed_cluster"
) extends Module
    with RequireAsyncReset {

  override val desiredName = s"${clusterName}_xdma_datapath"

  val io = IO(new Bundle {
    // All config signal for reader and writer
    val readerCfg = Input(new DMADataPathCfgInternalIO(readerparam))
    val writerCfg = Input(new DMADataPathCfgInternalIO(writerparam))

    // Two start signal will inform the new cfg is available, trigger agu, and inform all extension that a stream is coming
    val readerStart = Input(Bool())
    val writerStart = Input(Bool())
    // Two busy signal only go down if a stream fully passthrough the reader / writter.
    // reader_busy_o signal == 0 indicates that the reader side is available for next task
    val readerBusy = Output(Bool())
    // writer_busy_o signal == 0 indicates that the writer side is available for next task
    val writerBusy = Output(Bool())

    // TCDM request and response signal
    val tcdmReader = new Bundle {
      val req = Vec(
        readerparam.rwParam.tcdmParam.numChannel,
        Decoupled(
          new TcdmReq(
            readerparam.rwParam.tcdmParam.addrWidth,
            readerparam.rwParam.tcdmParam.dataWidth
          )
        )
      )
      val rsp = Vec(
        readerparam.rwParam.tcdmParam.numChannel,
        Flipped(
          Valid(
            new TcdmRsp(tcdmDataWidth = readerparam.rwParam.tcdmParam.dataWidth)
          )
        )
      )
    }
    val tcdmWriter = new Bundle {
      val req = Vec(
        writerparam.rwParam.tcdmParam.numChannel,
        Decoupled(
          new TcdmReq(
            writerparam.rwParam.tcdmParam.addrWidth,
            writerparam.rwParam.tcdmParam.dataWidth
          )
        )
      )
    }

    // The data for the cluster-level in/out
    // Cluster-level input <> Writer
    // Cluster-level output <> Reader
    val remoteDMADataPath = new Bundle {
      val fromRemote = Flipped(
        Decoupled(
          UInt(
            (writerparam.rwParam.tcdmParam.dataWidth * writerparam.rwParam.tcdmParam.numChannel).W
          )
        )
      )
      val toRemote =
        Decoupled(
          UInt(
            (writerparam.rwParam.tcdmParam.dataWidth * writerparam.rwParam.tcdmParam.numChannel).W
          )
        )
    }
  })

  val reader = Module(
    new Reader(readerparam.rwParam, clusterName = clusterName)
  )
  val i_writer = Module(
    new Writer(writerparam.rwParam, clusterName = clusterName)
  )

  // Connect TCDM memory to reader and writer
  reader.io.tcdmReq <> io.tcdmReader.req
  reader.io.tcdmRsp <> io.tcdmReader.rsp
  i_writer.io.tcdmReq <> io.tcdmWriter.req

  // Connect the wire (ctrl plane)
  reader.io.aguCfg := io.readerCfg.aguCfg
  reader.io.readerwriterCfg := io.readerCfg.readerwriterCfg
  reader.io.start := io.readerStart
  // reader_busy_o is connected later as the busy signal from the signal is needed

  i_writer.io.aguCfg := io.writerCfg.aguCfg
  i_writer.io.readerwriterCfg := io.writerCfg.readerwriterCfg
  i_writer.io.start := io.writerStart
  // writer_busy_o is connected later as the busy signal from the signal is needed

  // Connect the extension
  // Reader Side
  val reader_data_after_extension = Wire(chiselTypeOf(reader.io.data))

  // No extension is provided, the reader.io.data is directly connected to the out
  if (readerparam.extParam.length == 0) {
    reader.io.data <> reader_data_after_extension
    io.readerBusy := reader.io.busy | (~reader.io.bufferEmpty)
  } else {
    // There is some extension available: connect them
    // Connect CSR interface
    var bypassCSR = io.readerCfg.extCfg.head.asBools
    var remainingCSR =
      io.readerCfg.extCfg.tail // Give an alias to all extension's csr for a easier manipulation
    val readerExtensionList = for (i <- readerparam.extParam) yield {
      // Instantiate the extension
      val extension = i.instantiate(clusterName = clusterName)
      // Connect the CSR
      extension.io.csr_i := remainingCSR.take(extension.io.csr_i.length)
      remainingCSR = remainingCSR.drop(extension.io.csr_i.length)
      // Connect the bypass signal
      extension.io.bypass_i := bypassCSR.head
      bypassCSR = bypassCSR.tail
      // Return the extension for the future usage
      extension
    }
    if (remainingCSR.length != 0)
      println(
        "Debug: Some remaining CSRs are unconnected at reader. Check the code. "
      )

    // Connect Start signal
    readerExtensionList.foreach { i => i.io.start_i := io.readerStart }

    // Connect Data
    reader.io.data <> readerExtensionList.head.io.data_i
    readerExtensionList.last.io.data_o <> reader_data_after_extension
    if (readerExtensionList.length > 1)
      readerExtensionList.zip(readerExtensionList.tail).foreach { case (a, b) =>
        a.io.data_o -||> b.io.data_i
      }

    // Connect busy
    // Reader side is busy if reader is busy (addressgen is busy or addressgen fifo is non-empty) or data fifo is non-empty or any extension is busy
    // TODO: Is it better to implement a counter at the end of readerpath / at the beginning of writerpath to ensure all the data flows through the datapath?
    io.readerBusy := reader.io.busy | (~reader.io.bufferEmpty) | (readerExtensionList
      .map { _.io.busy_o }
      .reduce(_ | _))

    // Suggest a name for each extension
    for (i <- 0 until readerExtensionList.length)
      readerExtensionList(i)
        .suggestName(
          "reader_ext_" + i.toString() + "_" + readerparam
            .extParam(i)
            .extensionParam
            .moduleName
        )
  }

  // Writer side
  val writer_data_before_extension = Wire(chiselTypeOf(i_writer.io.data))

  // No extension is provided, the writer_data_before_extension is directly connected to the writer.io.data
  if (writerparam.extParam.length == 0) {
    writer_data_before_extension <> i_writer.io.data
    io.writerBusy := i_writer.io.busy | (~i_writer.io.bufferEmpty)
  } else {
    // There is some extension available: connect them
    // Connect CSR interface
    var bypassCSR = io.writerCfg.extCfg.head.asBools
    var remainingCSR =
      io.writerCfg.extCfg.tail // Give an alias to all extension's csr for a easier manipulation
    val i_writer_extentionList = for (i <- writerparam.extParam) yield {
      // Instantiate the extension
      val extension = i.instantiate(clusterName = clusterName)
      // Connect the CSR
      extension.io.csr_i := remainingCSR.take(extension.io.csr_i.length)
      remainingCSR = remainingCSR.drop(extension.io.csr_i.length)
      // Connect the bypass signal
      extension.io.bypass_i := bypassCSR.head
      bypassCSR = bypassCSR.tail
      // Return the extension for the future usage
      extension
    }
    if (remainingCSR.length != 0)
      println(
        "Debug: Some remaining CSRs are unconnected at writer. Check the XDMA Extension that number of CSRs in config file is coherent with number of CSRs required in the actually instantiated module. "
      )

    // Connect Start signal
    i_writer_extentionList.foreach { i => i.io.start_i := io.readerStart }

    // Connect Data
    // The new -|[||]> operator to implement a Decoupled Signal Cut had been implemented, and used in between each extension.
    writer_data_before_extension <> i_writer_extentionList.head.io.data_i
    i_writer_extentionList.last.io.data_o <> i_writer.io.data
    if (i_writer_extentionList.length > 1)
      i_writer_extentionList.zip(i_writer_extentionList.tail).foreach {
        case (a, b) =>
          a.io.data_o -||> b.io.data_i
      }

    // Connect busy
    // Writer side is busy if writer is busy (addressgen is busy or addressgen fifo is non-empty) or data fifo is non-empty or any extension is busy
    io.writerBusy := i_writer.io.busy | (~i_writer.io.bufferEmpty) | (i_writer_extentionList
      .map { _.io.busy_o }
      .reduce(_ | _))

    // Suggest a name for each extension
    for (i <- 0 until i_writer_extentionList.length)
      i_writer_extentionList(i)
        .suggestName(
          "writer_ext_" + i.toString() + "_" + writerparam
            .extParam(i)
            .extensionParam
            .moduleName
        )
  }

  // The following code only tackle with reader_data_after_extension and writer_data_before_extension: they should be either loopbacked or forwarded to the external interface (cluster_data_i / cluster_data_o)
  val readerDemux = Module(
    new DemuxDecoupled(
      chiselTypeOf(reader_data_after_extension.bits),
      numOutput = 2
    )
  )
  val writerMux = Module(
    new MuxDecoupled(
      chiselTypeOf(writer_data_before_extension.bits),
      numInput = 2
    )
  )

  readerDemux.io.sel := io.readerCfg.loopBack
  writerMux.io.sel := io.writerCfg.loopBack
  reader_data_after_extension <> readerDemux.io.in
  writerMux.io.out <> writer_data_before_extension

  readerDemux.io.out(1) <> writerMux.io.in(1)
  readerDemux.io.out(0) <> io.remoteDMADataPath.toRemote
  writerMux.io.in(0) <> io.remoteDMADataPath.fromRemote
}

// Below is the class to determine if chisel generate Verilog correctly

object DMADataPathEmitter extends App {
  println(
    getVerilogString(
      new DMADataPath(
        readerparam = new DMADataPathParam(
          axiParam = new AXIParam,
          rwParam = new ReaderWriterParam,
          extParam = Seq()
        ),
        writerparam = new DMADataPathParam(
          axiParam = new AXIParam,
          rwParam = new ReaderWriterParam,
          extParam = Seq()
        )
      )
    )
  )
}
