package snax.xdma.xdmaFrontend

import chisel3._
import chisel3.util._

import snax.utils._
import snax.utils.DecoupledCut._
import snax.utils.BitsConcat._
import snax.utils.DemuxDecoupled

import snax.readerWriter.{BasicCounter, AddressGenUnitCfgIO, Reader, Writer}

import snax.csr_manager._

import snax.xdma.DesignParams.DMADataPathParam

class DMACtrlIO(readerparam: DMADataPathParam, writerparam: DMADataPathParam)
    extends Bundle {
  // clusterBaseAddress to determine if it is the local command or remote command
  val clusterBaseAddress = Input(
    UInt(writerparam.axiParam.addrWidth.W)
  )
  // Local DMADatapath control signal (Which is connected to DMADataPath)
  val localDMADataPath = new Bundle {
    val readerCfg = Output(new DMADataPathCfgInternalIO(readerparam))
    val writerCfg = Output(new DMADataPathCfgInternalIO(writerparam))

    // Two start signal will inform the new cfg is available, trigger agu, and inform all extension that a stream is coming
    val readerStart = Output(Bool())
    val writerStart = Output(Bool())
    // Two busy signal only go down if a stream fully passthrough the reader / writter, which is provided by DataPath
    // These signals should be readable by the outside; these two will also be used to determine whether the next task can be executed.
    val readerBusy = Input(Bool())
    val writerBusy = Input(Bool())
  }
  // Remote control signal, which include the signal from other cluster or signal to other cluster. Both of them is AXI related, serialized signal
  // The remote control signal will contain only src information, in other words, the DMA system can proceed remote read or local read, but only local write
  val remoteDMADataPathCfg = new Bundle {
    val fromRemote = Flipped(Decoupled(UInt(readerparam.axiParam.dataWidth.W)))
    val toRemote = Decoupled(UInt(readerparam.axiParam.dataWidth.W))
  }
  // This is the port for CSR Manager to SNAX port
  val csrIO = new SnaxCsrIO(csrAddrWidth = 32)
}

class SrcConfigRouter(
    dataType: DMADataPathCfgInternalIO,
    clusterName: String = "unnamed_cluster"
) extends Module
    with RequireAsyncReset {

  override val desiredName = s"${clusterName}_xdma_ctrl_srcConfigRouter"

  val io = IO(new Bundle {
    val clusterBaseAddress = Input(dataType.readerPtr)
    val from = Flipped(new Bundle {
      val remote = Decoupled(dataType)
      val local = Decoupled(dataType)
    })
    val to = new Bundle {
      val remote = Decoupled(dataType)
      val local = Decoupled(dataType)
    }
  })

  val i_from_arbiter = Module(new Arbiter(dataType, 2) {
    override val desiredName =
      s"${clusterName}_xdma_ctrl_SrcConfigRouter_Arbiter"
  })
  i_from_arbiter.io.in(0) <> io.from.local
  i_from_arbiter.io.in(1) <> io.from.remote

  val i_to_demux = Module(
    new DemuxDecoupled(dataType = dataType, numOutput = 3) {
      override val desiredName =
        s"${clusterName}_xdma_ctrl_SrcConfigRouter_Demux"
    }
  )
  i_from_arbiter.io.out -|> i_to_demux.io.in

  // At the output of FIFO: Do the rule check
  val cType_local :: cType_remote :: cType_discard :: Nil = Enum(3)
  val cValue = Wire(chiselTypeOf(cType_discard))

  when(
    i_to_demux.io.in.bits.readerPtr(
      i_to_demux.io.in.bits.readerPtr.getWidth - 1,
      i_to_demux.io.in.bits.aguCfg.ptr.getWidth
    ) === io
      .clusterBaseAddress(
        i_to_demux.io.in.bits.readerPtr.getWidth - 1,
        i_to_demux.io.in.bits.aguCfg.ptr.getWidth
      )
  ) {
    cValue := cType_local // When cfg has the Ptr that fall within local TCDM, the data should be forwarded to the local ctrl path
  }.elsewhen(i_to_demux.io.in.bits.readerPtr === 0.U) {
    cValue := cType_discard // When cfg has the Ptr that is zero, This means that the frame need to be thrown away. This is important as when the data is moved from DRAM to TCDM or vice versa, DRAM part is handled by iDMA, thus only one config instead of two is submitted
  }.otherwise {
    cValue := cType_remote // For the remaining condition, the config is forward to remote DMA
  }

  i_to_demux.io.sel := cValue
  // Port local is connected to the outside
  i_to_demux.io.out(cType_local.litValue.toInt) <> io.to.local
  // Port remote is connected to the outside
  i_to_demux.io.out(cType_remote.litValue.toInt) <> io.to.remote
  // Port discard is not connected and will always be discarded
  i_to_demux.io.out(cType_discard.litValue.toInt).ready := true.B
}

class DstConfigRouter(
    dataType: DMADataPathCfgInternalIO,
    clusterName: String = "unnamed_cluster"
) extends Module
    with RequireAsyncReset {

  override val desiredName = s"${clusterName}_xdma_ctrl_dstConfigRouter"

  val io = IO(new Bundle {
    val clusterBaseAddress = Input(dataType.writerPtr)
    val from = Flipped(new Bundle {
      val local = Decoupled(dataType)
    })
    val to = new Bundle {
      val local = Decoupled(dataType)
    }
  })
  val i_to_demux = Module(
    new DemuxDecoupled(dataType = dataType, numOutput = 2) {
      override val desiredName =
        s"${clusterName}_xdma_ctrl_dstConfigRouter_Demux"
    }
  )
  io.from.local <> i_to_demux.io.in

  // At the output of cut: Do the rule check
  val cType_local :: cType_discard :: Nil = Enum(2)
  val cValue = Wire(chiselTypeOf(cType_discard))

  when(
    i_to_demux.io.in.bits.writerPtr(
      i_to_demux.io.in.bits.writerPtr.getWidth - 1,
      i_to_demux.io.in.bits.aguCfg.ptr.getWidth
    ) === io
      .clusterBaseAddress(
        i_to_demux.io.in.bits.writerPtr.getWidth - 1,
        i_to_demux.io.in.bits.aguCfg.ptr.getWidth
      )
  ) {
    cValue := cType_local // When cfg has the Ptr that fall within local TCDM, the data should be forwarded to the local ctrl path
  }.otherwise {
    cValue := cType_discard // For all other case, this frame needs to be discarded
  }

  i_to_demux.io.sel := cValue
  // Port local is connected to the outside
  i_to_demux.io.out(cType_local.litValue.toInt) <> io.to.local
  // Port discard is not connected and will always be discarded
  i_to_demux.io.out(cType_discard.litValue.toInt).ready := true.B
}

class DMACtrl(
    readerparam: DMADataPathParam,
    writerparam: DMADataPathParam,
    clusterName: String = "unnamed_cluster"
) extends Module
    with RequireAsyncReset {
  val io = IO(
    new DMACtrlIO(
      readerparam = readerparam,
      writerparam = writerparam
    )
  )

  override val desiredName = s"${clusterName}_xdma_ctrl"

  val i_csrmanager = Module(
    new CsrManager(
      csrNumReadWrite = 2 + // Reader Pointer needs two CSRs
        readerparam.rwParam.aguParam.spatialBounds.length + // Spatiaial Strides for reader
        readerparam.rwParam.aguParam.temporalDimension * 2 + // Temporal Strides + Bounds for reader
        {
          if (readerparam.rwParam.configurableChannel) 1 else 0
        } + // Enabled Channel for reader
        0 + // Enabled Byte for reader: non-effective, so donot assign CSR
        {
          if (readerparam.extParam.length == 0) 0
          else
            readerparam.extParam
              .map { i => i.extensionParam.userCsrNum }
              .reduce(_ + _) + 1
        } + // The total num of param on reader extension (custom CSR + bypass CSR)
        2 + // Writer Pointer needs two CSRs
        writerparam.rwParam.aguParam.spatialBounds.length + // Spatiaial Strides for writer
        writerparam.rwParam.aguParam.temporalDimension * 2 + // Strides + Bounds for writer
        {
          if (writerparam.rwParam.configurableChannel) 1 else 0
        } + // Enabled Channel for writer
        {
          if (writerparam.rwParam.configurableByteMask) 1 else 0
        } + // Enabled Byte for writer
        {
          if (writerparam.extParam.length == 0) 0
          else
            writerparam.extParam
              .map { i => i.extensionParam.userCsrNum }
              .reduce(_ + _) + 1
        } + // The total num of param on writer (custom CSR + bypass CSR)
        1, // The start CSR
      csrNumReadOnly = 2,
      // Set to two at current, 1) The number of submitted request; 2) The number of finished request. Since the reader path may be forward to remote, here I only count the writer branch
      csrAddrWidth = 32,
      // Set a name for the module class so that it will not overlapped with other csrManagers in user-defined accelerators
      csrModuleTagName = s"${clusterName}_xdma_"
    )
  )

  i_csrmanager.io.csr_config_in <> io.csrIO

  val preRoute_src_local = Wire(
    Decoupled(new DMADataPathCfgInternalIO(readerparam))
  )
  val preRoute_dst_local = Wire(
    Decoupled(new DMADataPathCfgInternalIO(writerparam))
  )
  var remainingCSR = i_csrmanager.io.csr_config_out.bits.toIndexedSeq

  // Connect reader + writer cfg to the structured signal: Src side
  remainingCSR =
    preRoute_src_local.bits.connectReaderWriterCfgWithList(remainingCSR)

  // Connect extension signal: Src side
  for (i <- 0 until preRoute_src_local.bits.extCfg.length) {
    preRoute_src_local.bits.extCfg(i) := remainingCSR.head
    remainingCSR = remainingCSR.tail
  }

  // Connect reader + writer cfg to the structured signal: Dst side
  remainingCSR =
    preRoute_dst_local.bits.connectReaderWriterCfgWithList(remainingCSR)

  // Connect extension signal: Dst side
  for (i <- 0 until preRoute_dst_local.bits.extCfg.length) {
    preRoute_dst_local.bits.extCfg(i) := remainingCSR.head
    remainingCSR = remainingCSR.tail
  }

  if (remainingCSR.length > 1)
    println("There is some error in CSR -> Structured CFG assigning")

  // Connect the loopBack signal: The loopBack signal is generated by comparing the Ptr of two side

  val loopBack =
    preRoute_dst_local.bits.readerPtr(
      preRoute_dst_local.bits.readerPtr.getWidth - 1,
      preRoute_dst_local.bits.aguCfg.ptr.getWidth
    ) === preRoute_dst_local.bits.writerPtr(
      preRoute_dst_local.bits.writerPtr.getWidth - 1,
      preRoute_dst_local.bits.aguCfg.ptr.getWidth
    )
  preRoute_src_local.bits.loopBack := loopBack
  preRoute_dst_local.bits.loopBack := loopBack

  // Connect Valid and bits: Only when both preRoutes are ready, postRulecheck is ready
  i_csrmanager.io.csr_config_out.ready := preRoute_src_local.ready & preRoute_dst_local.ready
  preRoute_src_local.valid := i_csrmanager.io.csr_config_out.ready & i_csrmanager.io.csr_config_out.valid
  preRoute_dst_local.valid := i_csrmanager.io.csr_config_out.ready & i_csrmanager.io.csr_config_out.valid

  // Cfg Frame Routing at src side
  val preRoute_src_remote = Wire(
    Decoupled(new DMADataPathCfgInternalIO(readerparam))
  )
  preRoute_src_remote.bits.deserialize(io.remoteDMADataPathCfg.fromRemote.bits)
  preRoute_src_remote.valid := io.remoteDMADataPathCfg.fromRemote.valid
  io.remoteDMADataPathCfg.fromRemote.ready := preRoute_src_remote.ready

  // Command Router
  val i_srcCfgRouter = Module(
    new SrcConfigRouter(
      dataType = chiselTypeOf(preRoute_src_local.bits),
      clusterName = clusterName
    )
  )
  i_srcCfgRouter.io.clusterBaseAddress := io.clusterBaseAddress

  i_srcCfgRouter.io.from.local <> preRoute_src_local
  preRoute_src_remote <> i_srcCfgRouter.io.from.remote

  val postRoute_src_local = Wire(
    Decoupled(new DMADataPathCfgInternalIO(readerparam))
  )
  val postRoute_src_remote = Wire(
    Decoupled(new DMADataPathCfgInternalIO(readerparam))
  )
  i_srcCfgRouter.io.to.local <> postRoute_src_local
  i_srcCfgRouter.io.to.remote <> postRoute_src_remote

  // Connect Port 3 to AXI Mst
  io.remoteDMADataPathCfg.toRemote.bits := postRoute_src_remote.bits.serialize()
  io.remoteDMADataPathCfg.toRemote.valid := postRoute_src_remote.valid
  postRoute_src_remote.ready := io.remoteDMADataPathCfg.toRemote.ready

  // Cfg Frame Routing at dst side: The fake router that only buffer the config and pop out invalid command
  // Command Router
  val i_dstCfgRouter = Module(
    new DstConfigRouter(
      dataType = chiselTypeOf(preRoute_dst_local.bits),
      clusterName = clusterName
    )
  )
  i_dstCfgRouter.io.clusterBaseAddress := io.clusterBaseAddress

  i_dstCfgRouter.io.from.local <> preRoute_dst_local

  val postRoute_dst_local = Wire(
    Decoupled(new DMADataPathCfgInternalIO(writerparam))
  )
  postRoute_dst_local <> i_dstCfgRouter.io.to.local

  // Loopback / Non-loopback seperation for pseudo-OoO commit
  val i_src_LoopbackDemux = Module(
    new DemuxDecoupled(chiselTypeOf(postRoute_src_local.bits), numOutput = 2) {
      override val desiredName = s"${clusterName}_xdma_ctrl_src_LoopbackDemux"
    }
  )
  val i_dst_LoopbackDemux = Module(
    new DemuxDecoupled(chiselTypeOf(postRoute_dst_local.bits), numOutput = 2) {
      override val desiredName = s"${clusterName}_xdma_ctrl_dst_LoopbackDemux"
    }
  )

  // (1) is loopback; (0) is non-loopback
  i_src_LoopbackDemux.io.sel := postRoute_src_local.bits.loopBack
  i_dst_LoopbackDemux.io.sel := postRoute_dst_local.bits.loopBack
  i_src_LoopbackDemux.io.in <> postRoute_src_local
  i_dst_LoopbackDemux.io.in <> postRoute_dst_local

  val i_srcCfgArbiter = Module(
    new Arbiter(chiselTypeOf(postRoute_src_local.bits), 2) {
      override val desiredName = s"${clusterName}_xdma_ctrl_srcCfgArbiter"
    }
  )
  // Non-loopback has lower priority, so that it is connect to 1st port of arbiter
  // Optional FIFO for non-loopback cfg is added (depth = 2)
  i_src_LoopbackDemux.io.out(0) -||> i_srcCfgArbiter.io.in(1)
  // Loopback has higher priority, so that it is connect to 0th port of arbiter
  // Optional FIFO for loopback cfg is not added
  i_src_LoopbackDemux.io.out(1) <> i_srcCfgArbiter.io.in(0)

  val i_dstCfgArbiter = Module(
    new Arbiter(chiselTypeOf(postRoute_dst_local.bits), 2) {
      override val desiredName = s"${clusterName}_xdma_ctrl_dstCfgArbiter"
    }
  )
  // Non-loopback has lower priority, so that it is connect to 1st port of arbiter
  // Optional FIFO for non-loopback cfg is added (depth = 2)
  i_dst_LoopbackDemux.io.out(0) -||> i_dstCfgArbiter.io.in(1)
  // Loopback has higher priority, so that it is connect to 0th port of arbiter
  // Optional FIFO for loopback cfg is not added
  i_dst_LoopbackDemux.io.out(1) <> i_dstCfgArbiter.io.in(0)

  // Connect these two cfg to the actual input: Need two small (Mealy) FSMs to manage the start signal and pop out the consumed cfg
  val sIdle :: sWaitBusy :: sBusy :: Nil = Enum(3)

  sIdle.suggestName("sIdle")
  sWaitBusy.suggestName("sWaitBusy")
  sBusy.suggestName("sBusy")

  // Two registers to store the current state
  val current_state_src = RegInit(sIdle)
  val current_state_dst = RegInit(sIdle)

  // Two Data Cut to store the buffer the current cfg
  val current_cfg_src = Wire(chiselTypeOf(i_srcCfgArbiter.io.out))
  val current_cfg_dst = Wire(chiselTypeOf(i_dstCfgArbiter.io.out))
  i_srcCfgArbiter.io.out -|> current_cfg_src
  i_dstCfgArbiter.io.out -|> current_cfg_dst

  // Default value: Not pop out config, not start reader/writer, not change state
  io.localDMADataPath.readerStart := false.B
  io.localDMADataPath.writerStart := false.B
  current_cfg_src.ready := false.B
  current_cfg_dst.ready := false.B

  // Control signals in Src Path
  switch(current_state_src) {
    is(sIdle) {
      when(current_cfg_src.valid & (~io.localDMADataPath.readerBusy)) {
        current_state_src := sWaitBusy
        io.localDMADataPath.readerStart := true.B
      }
    }
    is(sWaitBusy) {
      when(io.localDMADataPath.readerBusy) {
        current_state_src := sBusy
      }
    }
    is(sBusy) {
      when(~io.localDMADataPath.readerBusy) {
        current_state_src := sIdle
        current_cfg_src.ready := true.B
      }
    }
  }

  // Control signals in Dst Path
  switch(current_state_dst) {
    is(sIdle) {
      when(current_cfg_dst.valid & (~io.localDMADataPath.writerBusy)) {
        current_state_dst := sWaitBusy
        io.localDMADataPath.writerStart := true.B
      }
    }
    is(sWaitBusy) {
      when(io.localDMADataPath.writerBusy) {
        current_state_dst := sBusy
      }
    }
    is(sBusy) {
      when(~io.localDMADataPath.writerBusy) {
        current_state_dst := sIdle
        current_cfg_dst.ready := true.B
      }
    }
  }

  // Data Signals in Src Path
  io.localDMADataPath.readerCfg := current_cfg_src.bits
  // Data Signals in Dst Path
  io.localDMADataPath.writerCfg := current_cfg_dst.bits

  // Counter for submitted cfg and finished cfg (With these two values, the control core knows which task is finished)
  val i_submittedTaskCounter = Module(new BasicCounter(32, hasCeil = false) {
    override val desiredName = s"${clusterName}_xdma_ctrl_submittedTaskCounter"
  })
  i_submittedTaskCounter.io.ceil := DontCare
  i_submittedTaskCounter.io.reset := false.B
  i_submittedTaskCounter.io.tick := i_csrmanager.io.csr_config_out.fire
  i_csrmanager.io.read_only_csr(0) := i_submittedTaskCounter.io.value

  val i_finishedTaskCounter = Module(new BasicCounter(32, hasCeil = false) {
    override val desiredName = s"${clusterName}_xdma_ctrl_finishedTaskCounter"
  })
  i_finishedTaskCounter.io.ceil := DontCare
  i_finishedTaskCounter.io.reset := false.B
  i_finishedTaskCounter.io.tick := (RegNext(
    io.localDMADataPath.writerBusy,
    init = false.B
  ) === true.B) && (io.localDMADataPath.writerBusy === false.B)
  i_csrmanager.io.read_only_csr(1) := i_finishedTaskCounter.io.value
}
