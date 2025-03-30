package snax.xdma.xdmaFrontend

import chisel3._
import chisel3.util._

import snax.utils._

import snax.utils.DecoupledCut._
import snax.utils.BitsConcat._

import snax.readerWriter.{
  AddressGenUnitCfgIO,
  ReaderWriterCfgIO,
  Reader,
  Writer,
  ReaderWriterParam
}
import snax.xdma.DesignParams._
import snax.DataPathExtension._
import snax.xdma.io._

class XDMADataPath(
    readerParam: XDMAParam,
    writerParam: XDMAParam,
    clusterName: String = "unnamed_cluster"
) extends Module
    with RequireAsyncReset {

  override val desiredName = s"${clusterName}_xdma_datapath"

  val io = IO(new Bundle {
    // All config signal for reader and writer
    val readerCfg = Input(new XDMAIntraClusterCfgIO(readerParam))
    val writerCfg = Input(new XDMAIntraClusterCfgIO(writerParam))

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
        readerParam.rwParam.tcdmParam.numChannel,
        Decoupled(
          new TcdmReq(
            readerParam.rwParam.tcdmParam.addrWidth,
            readerParam.rwParam.tcdmParam.dataWidth
          )
        )
      )
      val rsp = Vec(
        readerParam.rwParam.tcdmParam.numChannel,
        Flipped(
          Valid(
            new TcdmRsp(tcdmDataWidth = readerParam.rwParam.tcdmParam.dataWidth)
          )
        )
      )
    }
    val tcdmWriter = new Bundle {
      val req = Vec(
        writerParam.rwParam.tcdmParam.numChannel,
        Decoupled(
          new TcdmReq(
            writerParam.rwParam.tcdmParam.addrWidth,
            writerParam.rwParam.tcdmParam.dataWidth
          )
        )
      )
    }

    // The data for the cluster-level in/out
    // Cluster-level input -> fromRemote <> Writer
    // Cluster-level output -> toRemote <> Reader
    val remoteXDMAData = new Bundle {
      val fromRemote = Flipped(
        Decoupled(
          UInt(
            (writerParam.rwParam.tcdmParam.dataWidth * writerParam.rwParam.tcdmParam.numChannel).W
          )
        )
      )
      val fromRemoteAccompaniedCfg = Output(
        new XDMADataPathCfgIO(
          axiParam = writerParam.axiParam,
          crossClusterParam = writerParam.crossClusterParam
        )
      )

      val toRemote =
        Decoupled(
          UInt(
            (readerParam.rwParam.tcdmParam.dataWidth * readerParam.rwParam.tcdmParam.numChannel).W
          )
        )
      val toRemoteAccompaniedCfg = Output(
        new XDMADataPathCfgIO(
          axiParam = readerParam.axiParam,
          crossClusterParam = readerParam.crossClusterParam
        )
      )
    }
  })

  val reader = Module(
    new Reader(readerParam.rwParam, moduleNamePrefix = clusterName)
  )
  val writer = Module(
    new Writer(writerParam.rwParam, moduleNamePrefix = clusterName)
  )

  // Connect TCDM memory to reader and writer
  reader.io.tcdmReq <> io.tcdmReader.req
  reader.io.tcdmRsp <> io.tcdmReader.rsp
  writer.io.tcdmReq <> io.tcdmWriter.req

  // Connect the wire (ctrl plane)
  reader.io.aguCfg := io.readerCfg.aguCfg
  reader.io.readerwriterCfg := io.readerCfg.readerwriterCfg
  reader.io.start := io.readerStart
  // reader_busy_o is connected later as the busy signal from the signal is needed

  writer.io.aguCfg := io.writerCfg.aguCfg
  writer.io.readerwriterCfg := io.writerCfg.readerwriterCfg
  writer.io.start := io.writerStart
  // writer_busy_o is connected later as the busy signal from the signal is needed

  // Connect the extension
  // Reader Side
  val readerDataAfterExtension = Wire(chiselTypeOf(reader.io.data))

  val readerExtensions = Module(
    new DataPathExtensionHost(
      readerParam.extParam,
      dataWidth =
        readerParam.rwParam.tcdmParam.dataWidth * readerParam.rwParam.tcdmParam.numChannel,
      headCut = false,
      tailCut = false,
      halfCut = false,
      moduleNamePrefix = clusterName
    )
  )
  readerExtensions.io.data.in <> reader.io.data
  readerExtensions.io.data.out <> readerDataAfterExtension
  readerExtensions.io.connectCfgWithList(io.readerCfg.extCfg)
  readerExtensions.io.start := io.readerStart
  io.readerBusy := reader.io.busy | (~reader.io.bufferEmpty) | readerExtensions.io.busy

  // Writer side
  val writerDataBeforeExtension = Wire(chiselTypeOf(writer.io.data))

  val writerExtensions = Module(
    new DataPathExtensionHost(
      writerParam.extParam,
      dataWidth =
        writerParam.rwParam.tcdmParam.dataWidth * writerParam.rwParam.tcdmParam.numChannel,
      headCut = false,
      tailCut = false,
      halfCut = false,
      moduleNamePrefix = clusterName
    )
  )

  writerExtensions.io.data.in <> writerDataBeforeExtension
  writerExtensions.io.data.out <> writer.io.data
  writerExtensions.io.connectCfgWithList(io.writerCfg.extCfg)
  writerExtensions.io.start := io.writerStart
  io.writerBusy := writer.io.busy | (~writer.io.bufferEmpty) | writerExtensions.io.busy

  // The following muxes and demuxes are used to do the local loopback and remote loopback, the wires connected to the reader and writer are: readerDataAfterExtension and writerDataBeforeExtension. The wires between all the demuxes and muxes should not be cutted
  // LocalLoopbackDemux takes the data from the Reader side, and send it to either the remote cluster (0) or loopback to the writer side (1)
  val localLoopbackDemux = Module(
    new DemuxDecoupled(
      chiselTypeOf(readerDataAfterExtension.bits),
      numOutput = 2
    ) {
      override def desiredName = clusterName + "_xdma_datapath_local_demux"
    }
  )
  // LocalLoopbackMux takes the data from either loopback or the remote side, and send it to writer
  val localLoopbackMux = Module(
    new MuxDecoupled(
      chiselTypeOf(writerDataBeforeExtension.bits),
      numInput = 2
    ) {
      override def desiredName = clusterName + "_xdma_datapath_local_mux"
    }
  )

  localLoopbackDemux.io.sel := io.readerCfg.localLoopback
  localLoopbackMux.io.sel := io.writerCfg.localLoopback
  readerDataAfterExtension <> localLoopbackDemux.io.in
  localLoopbackMux.io.out <> writerDataBeforeExtension

  val readerLocaltoRemoteLoopback = Wire(chiselTypeOf(readerDataAfterExtension))
  val writerLocaltoRemoteLoopback = Wire(
    chiselTypeOf(writerDataBeforeExtension)
  )

  localLoopbackDemux.io.out(1) <> localLoopbackMux.io.in(1)
  localLoopbackDemux.io.out(0) <> readerLocaltoRemoteLoopback
  localLoopbackMux.io.in(0) <> writerLocaltoRemoteLoopback

  // RemoteLoopbackMux takes the data from readerLocaltoRemoteLoopback(0) or the remote loopback side (1), and send it to the remote side
  val remoteLoopbackMux = Module(
    new MuxDecoupled(
      chiselTypeOf(readerLocaltoRemoteLoopback.bits),
      numInput = 2
    ) {
      override def desiredName = clusterName + "_xdma_datapath_remote_mux"
    }
  )

  // The remoteLoopbackSplitter takes the data from the remote side, and always send it to writerLocaltoRemoteLoopback (0) and selectively send it to the remote loopback side (1)
  val remoteLoopbackSplitter = Module(
    new SplitterDecoupled(
      chiselTypeOf(io.remoteXDMAData.fromRemote.bits),
      numOutput = 2
    ) {
      override def desiredName = clusterName + "_xdma_datapath_remote_splitter"
    }
  )
  remoteLoopbackMux.io.sel := io.writerCfg.remoteLoopback && io.writerBusy
  remoteLoopbackSplitter.io.sel(0) := true.B
  remoteLoopbackSplitter.io.sel(
    1
  ) := io.writerCfg.remoteLoopback && io.writerBusy

  remoteLoopbackMux.io.in(0) <> readerLocaltoRemoteLoopback
  remoteLoopbackMux.io.in(1) <> remoteLoopbackSplitter.io.out(1)
  remoteLoopbackSplitter.io.out(0) <> writerLocaltoRemoteLoopback

  // The output of the remoteLoopbackMux is the data that will be sent to the remote side
  io.remoteXDMAData.toRemote <> remoteLoopbackMux.io.out
  // The input of the remoteLoopbackSplitter is the data that will be get from the remote side
  io.remoteXDMAData.fromRemote <> remoteLoopbackSplitter.io.in

  // Connect the AccompaniedCfg signal
  // Create three intermediate wires to convert from XDMAIntraClusterCfgIO to XDMADataPathCfgIO
  // Normal Read: toRemoteAccompaniedCfg <- Coming from reader side
  // Normal Write: fromRemoteAccompaniedCfg <- Coming from writer side
  // Chained Write (Reader side's cfg): toRemoteChainedWriteAccompaniedCfg <- Coming from writer side
  val fromRemoteAccompaniedCfg = Wire(
    chiselTypeOf(io.remoteXDMAData.fromRemoteAccompaniedCfg)
  )
  fromRemoteAccompaniedCfg.convertFromXDMAIntraClusterCfgIO(
    cfg = io.writerCfg,
    isChainedWrite = false
  )

  val toRemoteAccompaniedCfg = Wire(
    chiselTypeOf(io.remoteXDMAData.toRemoteAccompaniedCfg)
  )
  toRemoteAccompaniedCfg.convertFromXDMAIntraClusterCfgIO(
    cfg = io.readerCfg,
    isChainedWrite = false
  )

  val toRemoteChainedWriteAccompaniedCfg = Wire(
    chiselTypeOf(io.remoteXDMAData.toRemoteAccompaniedCfg)
  )
  toRemoteChainedWriteAccompaniedCfg.convertFromXDMAIntraClusterCfgIO(
    cfg = io.writerCfg,
    isChainedWrite = true
  )

  // The readyToSubmit signal should only be high when the localLoopback is false
  // (The data needs to come from / to the remote side)
  fromRemoteAccompaniedCfg.readyToTransfer := Mux(
    io.writerCfg.localLoopback,
    false.B,
    writer.io.busy
  )

  fromRemoteAccompaniedCfg.taskType := Mux(
    io.writerCfg.origination === io.writerCfg.originationIsFromLocal.B,
    fromRemoteAccompaniedCfg.taskTypeIsRemoteRead.B,
    fromRemoteAccompaniedCfg.taskTypeIsRemoteWrite.B
  )

  toRemoteAccompaniedCfg.readyToTransfer := Mux(
    io.readerCfg.localLoopback,
    false.B,
    reader.io.busy
  )

  toRemoteAccompaniedCfg.taskType := Mux(
    io.readerCfg.origination === io.readerCfg.originationIsFromLocal.B,
    toRemoteAccompaniedCfg.taskTypeIsRemoteWrite.B,
    toRemoteAccompaniedCfg.taskTypeIsRemoteRead.B
  )

  toRemoteChainedWriteAccompaniedCfg.readyToTransfer := io.writerCfg.remoteLoopback && io.writerBusy
  toRemoteChainedWriteAccompaniedCfg.taskType := toRemoteChainedWriteAccompaniedCfg.taskTypeIsRemoteWrite.B

  // The actual output of AccompaniedCfg is determined by the remoteLoopback signal:
  // If the remoteLoopback signal is high, toRemoteAccompaniedCfg needs to be shifted
  io.remoteXDMAData.fromRemoteAccompaniedCfg := fromRemoteAccompaniedCfg
  io.remoteXDMAData.toRemoteAccompaniedCfg := Mux(
    io.writerCfg.remoteLoopback && io.writerBusy,
    toRemoteChainedWriteAccompaniedCfg,
    toRemoteAccompaniedCfg
  )
}

// Below is the class to determine if chisel generate Verilog correctly
object XDMADataPathEmitter extends App {
  emitVerilog(
    new XDMADataPath(
      readerParam = new XDMAParam(
        axiParam = new AXIParam,
        crossClusterParam = new CrossClusterParam,
        rwParam = new ReaderWriterParam,
        extParam = Seq()
      ),
      writerParam = new XDMAParam(
        axiParam = new AXIParam,
        crossClusterParam = new CrossClusterParam,
        rwParam = new ReaderWriterParam,
        extParam = Seq()
      )
    ),
    Array("--target-dir", "generated")
  )

}
