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
class DMADataPathCfgIO(param: DMADataPathParam) extends Bundle {
  val agu_cfg =
    new AddressGenUnitCfgIO(param =
      param.rwParam.agu_param
    ) // Buffered within AGU
  val streamer_cfg = new Bundle {
    val strb = UInt((param.rwParam.tcdm_param.dataWidth / 8).W)
  }
  val ext_cfg = if (param.extParam.length != 0) {
    Vec(
      param.extParam.map { i => i.totalCsrNum }.reduce(_ + _),
      UInt(32.W)
    ) // Buffered within Extension Base Module
  } else Vec(0, UInt(32.W))

  // The config forwarding technics is easy to be implemented: Just by reading agu_cfg.Ptr, the destination can be determined
  // However, the data forwarding is still challenging: Shall we use the current DMA to move the data? (I suggest that we do this in the initial implementation)
  // Serialize function to convert config into one long UInt
  def serialize(): UInt = {
    ext_cfg.asUInt ++ streamer_cfg.asUInt ++ agu_cfg.Bounds.asUInt ++ agu_cfg.Strides.asUInt ++ agu_cfg.Ptr
  }

  // Deserialize function to convert long UInt back to config
  // The conversion is done from LSB to MSB
  // After the conversion, the remaining data is returned for further conversion
  def deserialize(data: UInt): UInt = {
    var remainingData = data

    // Assigning Ptr
    agu_cfg.Ptr := remainingData(agu_cfg.Ptr.getWidth - 1, 0)
    remainingData =
      remainingData(remainingData.getWidth - 1, agu_cfg.Ptr.getWidth)

    // Assigning Strides
    agu_cfg.Strides := remainingData(agu_cfg.Strides.asUInt.getWidth - 1, 0)
      .asTypeOf(agu_cfg.Strides)
    remainingData =
      remainingData(remainingData.getWidth - 1, agu_cfg.Strides.asUInt.getWidth)

    // Assigning Bounds
    agu_cfg.Bounds := remainingData(agu_cfg.Strides.asUInt.getWidth - 1, 0)
      .asTypeOf(agu_cfg.Bounds)
    remainingData =
      remainingData(remainingData.getWidth - 1, agu_cfg.Bounds.asUInt.getWidth)

    // Assigning streamer_cfg
    streamer_cfg.strb := remainingData(streamer_cfg.strb.getWidth - 1, 0)
    remainingData =
      remainingData(remainingData.getWidth - 1, streamer_cfg.strb.getWidth)
    // Assigning ext_cfg
    ext_cfg := remainingData(ext_cfg.asUInt.getWidth - 1, 0).asTypeOf(ext_cfg)
    remainingData =
      remainingData(remainingData.getWidth - 1, ext_cfg.asUInt.getWidth)
    remainingData
  }
}

// The internal sturctured class that used to store the CFG of reader and writer
// The serialized version of this class will be the actual output and input of the DMACtrl (which is to AXI)
// It is the ReaderWriterCfg class, with loopBack signal (early judgement) and Ptr of the opposite side (So that the Data can be forwarded to the remote side)
class DMADataPathCfgInternalIO(param: DMADataPathParam)
    extends DMADataPathCfgIO(param: DMADataPathParam) {
  val loopBack = Bool()
  val oppositePtr = UInt(param.rwParam.tcdm_param.addrWidth.W)
  override def serialize(): UInt = {
    super.serialize() ++ oppositePtr
  }

  override def deserialize(data: UInt): UInt = {
    var remainingData = data;

    // Assigning oppositePtr
    oppositePtr := remainingData(oppositePtr.getWidth - 1, 0)
    remainingData =
      remainingData(remainingData.getWidth - 1, oppositePtr.getWidth)

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
    val reader_cfg_i = Input(new DMADataPathCfgInternalIO(readerparam))
    val writer_cfg_i = Input(new DMADataPathCfgInternalIO(writerparam))

    // Two start signal will inform the new cfg is available, trigger agu, and inform all extension that a stream is coming
    val reader_start_i = Input(Bool())
    val writer_start_i = Input(Bool())
    // Two busy signal only go down if a stream fully passthrough the reader / writter.
    // reader_busy_o signal == 0 indicates that the reader side is available for next task
    val reader_busy_o = Output(Bool())
    // writer_busy_o signal == 0 indicates that the writer side is available for next task
    val writer_busy_o = Output(Bool())

    // TCDM request and response signal
    val tcdm_reader = new Bundle {
      val req = Vec(
        readerparam.rwParam.tcdm_param.numChannel,
        Decoupled(
          new TcdmReq(
            readerparam.rwParam.tcdm_param.addrWidth,
            readerparam.rwParam.tcdm_param.dataWidth
          )
        )
      )
      val rsp = Vec(
        readerparam.rwParam.tcdm_param.numChannel,
        Flipped(
          Valid(
            new TcdmRsp(tcdmDataWidth =
              readerparam.rwParam.tcdm_param.dataWidth
            )
          )
        )
      )
    }
    val tcdm_writer = new Bundle {
      val req = Vec(
        writerparam.rwParam.tcdm_param.numChannel,
        Decoupled(
          new TcdmReq(
            writerparam.rwParam.tcdm_param.addrWidth,
            writerparam.rwParam.tcdm_param.dataWidth
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
            (writerparam.rwParam.tcdm_param.dataWidth * writerparam.rwParam.tcdm_param.numChannel).W
          )
        )
      )
      val toRemote =
        Decoupled(
          UInt(
            (writerparam.rwParam.tcdm_param.dataWidth * writerparam.rwParam.tcdm_param.numChannel).W
          )
        )
    }
  })

  val i_reader = Module(
    new Reader(readerparam.rwParam, clusterName = clusterName)
  )
  val i_writer = Module(
    new Writer(writerparam.rwParam, clusterName = clusterName)
  )

  // Connect TCDM memory to reader and writer
  i_reader.io.tcdm_req <> io.tcdm_reader.req
  i_reader.io.tcdm_rsp <> io.tcdm_reader.rsp
  i_writer.io.tcdm_req <> io.tcdm_writer.req

  // Connect the wire (ctrl plane)
  i_reader.io.cfg := io.reader_cfg_i.agu_cfg
  i_reader.io.strb := io.reader_cfg_i.streamer_cfg.strb
  i_reader.io.start := io.reader_start_i
  // reader_busy_o is connected later as the busy signal from the signal is needed

  i_writer.io.cfg := io.writer_cfg_i.agu_cfg
  i_writer.io.strb := io.writer_cfg_i.streamer_cfg.strb
  i_writer.io.start := io.writer_start_i
  // writer_busy_o is connected later as the busy signal from the signal is needed

  // Connect the extension
  // Reader Side
  val reader_data_after_extension = Wire(chiselTypeOf(i_reader.io.data))

  // No extension is provided, the reader.io.data is directly connected to the out
  if (readerparam.extParam.length == 0) {
    i_reader.io.data <> reader_data_after_extension
    io.reader_busy_o := i_reader.io.busy | (~i_reader.io.bufferEmpty)
  } else {
    // There is some extension available: connect them
    // Connect CSR interface
    var remainingCSR =
      io.reader_cfg_i.ext_cfg.toIndexedSeq // Give an alias to all extension's csr for a easier manipulation
    val i_reader_extentionList = for (i <- readerparam.extParam) yield {
      val extension = i.instantiate(clusterName = clusterName)
      extension.io.csr_i := remainingCSR.take(extension.io.csr_i.length)
      remainingCSR = remainingCSR.drop(extension.io.csr_i.length)
      extension
    }
    if (remainingCSR.length != 0)
      println(
        "Debug: Some remaining CSRs are unconnected at reader. Check the code. "
      )

    // Connect Start signal
    i_reader_extentionList.foreach { i => i.io.start_i := io.reader_start_i }

    // Connect Data
    i_reader.io.data <> i_reader_extentionList.head.io.data_i
    i_reader_extentionList.last.io.data_o <> reader_data_after_extension
    if (i_reader_extentionList.length > 1)
      i_reader_extentionList.zip(i_reader_extentionList.tail).foreach {
        case (a, b) =>
          a.io.data_o -||> b.io.data_i
      }

    // Connect busy
    // Reader side is busy if reader is busy (addressgen is busy or addressgen fifo is non-empty) or data fifo is non-empty or any extension is busy
    // TODO: Is it better to implement a counter at the end of readerpath / at the beginning of writerpath to ensure all the data flows through the datapath?
    io.reader_busy_o := i_reader.io.busy | (~i_reader.io.bufferEmpty) | (i_reader_extentionList
      .map { _.io.busy_o }
      .reduce(_ | _))

    // Suggest a name for each extension
    for (i <- 0 until i_reader_extentionList.length)
      i_reader_extentionList(i)
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
    io.writer_busy_o := i_writer.io.busy | (~i_writer.io.bufferEmpty)
  } else {
    // There is some extension available: connect them
    // Connect CSR interface
    var remainingCSR =
      io.writer_cfg_i.ext_cfg.toIndexedSeq // Give an alias to all extension's csr for a easier manipulation
    val i_writer_extentionList = for (i <- writerparam.extParam) yield {
      val extension = i.instantiate(clusterName = clusterName)
      extension.io.csr_i := remainingCSR.take(extension.io.csr_i.length)
      remainingCSR = remainingCSR.drop(extension.io.csr_i.length)
      extension
    }
    if (remainingCSR.length != 0)
      println(
        "Debug: Some remaining CSRs are unconnected at writer. Check the XDMA Extension that number of CSRs in config file is coherent with number of CSRs required in the actually instantiated module. "
      )

    // Connect Start signal
    i_writer_extentionList.foreach { i => i.io.start_i := io.reader_start_i }

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
    io.writer_busy_o := i_writer.io.busy | (~i_writer.io.bufferEmpty) | (i_writer_extentionList
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

  readerDemux.io.sel := io.reader_cfg_i.loopBack
  writerMux.io.sel := io.writer_cfg_i.loopBack
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
          rwParam = new ReaderWriterParam,
          extParam = Seq()
        ),
        writerparam = new DMADataPathParam(
          rwParam = new ReaderWriterParam,
          extParam = Seq()
        )
      )
    )
  )
}
