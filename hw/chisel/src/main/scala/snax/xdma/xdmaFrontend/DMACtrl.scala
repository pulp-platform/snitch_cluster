package snax.xdma.xdmaFrontend

import chisel3._
import chisel3.util._

import snax.utils._
import snax.xdma.CommonCells.DecoupledCut._
import snax.xdma.CommonCells.BitsConcat._

import snax.xdma.xdmaStreamer.{AddressGenUnitCfgIO, Reader, Writer}

import snax.csr_manager._
import snax.xdma.xdmaStreamer.BasicCounter
import snax.xdma.CommonCells.DemuxDecoupled
import snax.xdma.DesignParams.DMADataPathParam

class DMACtrlIO(
    readerparam: DMADataPathParam,
    writerparam: DMADataPathParam,
    axiWidth: Int = 512
) extends Bundle {
  // clusterBaseAddress to determine if it is the local command or remote command
  val clusterBaseAddress = Input(
    UInt(readerparam.rwParam.agu_param.addressWidth.W)
  )
  // Local DMADatapath control signal (Which is connected to DMADataPath)
  val localDMADataPath = new Bundle {
    val reader_cfg_o = Output(new DMADataPathCfgInternalIO(readerparam))
    val writer_cfg_o = Output(new DMADataPathCfgInternalIO(writerparam))

    // Two start signal will inform the new cfg is available, trigger agu, and inform all extension that a stream is coming
    val reader_start_o = Output(Bool())
    val writer_start_o = Output(Bool())
    // Two busy signal only go down if a stream fully passthrough the reader / writter, which is provided by DataPath
    // These signals should be readable by the outside; these two will also be used to determine whether the next task can be executed.
    val reader_busy_i = Input(Bool())
    val writer_busy_i = Input(Bool())
  }
  // Remote control signal, which include the signal from other cluster or signal to other cluster. Both of them is AXI related, serialized signal
  // The remote control signal will contain only src information, in other words, the DMA system can proceed remote read or local read, but only local write
  val remoteDMADataPathCfg = new Bundle {
    val fromRemote = Flipped(Decoupled(UInt(axiWidth.W)))
    val toRemote = Decoupled(UInt(axiWidth.W))
  }
  // This is the port for CSR Manager to SNAX port
  val csrIO = new SnaxCsrIO(csrAddrWidth = 32)
}

class SrcConfigRouter(
    dataType: DMADataPathCfgInternalIO,
    tcdmSize: Int,
    clusterName: String = "unnamed_cluster"
) extends Module
    with RequireAsyncReset {

  override val desiredName = s"${clusterName}_xdma_ctrl_srcConfigRouter"

  val io = IO(new Bundle {
    val clusterBaseAddress = Input(dataType.agu_cfg.Ptr)
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
    i_to_demux.io.in.bits.agu_cfg
      .Ptr(
        i_to_demux.io.in.bits.agu_cfg.Ptr.getWidth - 1,
        log2Up(tcdmSize) + 10
      ) === io
      .clusterBaseAddress(
        i_to_demux.io.in.bits.agu_cfg.Ptr.getWidth - 1,
        log2Up(tcdmSize) + 10
      )
  ) {
    cValue := cType_local // When cfg has the Ptr that fall within local TCDM, the data should be forwarded to the local ctrl path
  }.elsewhen(i_to_demux.io.in.bits.agu_cfg.Ptr === 0.U) {
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
    tcdmSize: Int,
    clusterName: String = "unnamed_cluster"
) extends Module
    with RequireAsyncReset {

  override val desiredName = s"${clusterName}_xdma_ctrl_dstConfigRouter"

  val io = IO(new Bundle {
    val clusterBaseAddress = Input(dataType.agu_cfg.Ptr)
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
    i_to_demux.io.in.bits.agu_cfg
      .Ptr(
        i_to_demux.io.in.bits.agu_cfg.Ptr.getWidth - 1,
        log2Up(tcdmSize) + 10
      ) === io
      .clusterBaseAddress(
        i_to_demux.io.in.bits.agu_cfg.Ptr.getWidth - 1,
        log2Up(tcdmSize) + 10
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
    axiWidth: Int = 512,
    csrAddrWidth: Int = 32,
    clusterName: String = "unnamed_cluster"
) extends Module
    with RequireAsyncReset {
  val io = IO(
    new DMACtrlIO(
      readerparam = readerparam,
      writerparam = writerparam,
      axiWidth = axiWidth
    )
  )

  override val desiredName = s"${clusterName}_xdma_ctrl"

  val i_csrmanager = Module(
    new CsrManager(
      csrNumReadWrite = 2 + // Reader Pointer needs two CSRs
        readerparam.rwParam.agu_param.dimension * 2 + // Strides + Bounds for reader
        0 + // The strb for reader: non-effective, so donot assign CSR
        {
          if (readerparam.extParam.length == 0) 0
          else readerparam.extParam.map { i => i.totalCsrNum }.reduce(_ + _)
        } + // The total num of param on reader extension
        2 + // Writer Pointer needs two CSRs
        writerparam.rwParam.agu_param.dimension * 2 + // Strides + Bounds for writer
        1 + // The strb for writer: effective, so assign one CSR
        {
          if (writerparam.extParam.length == 0) 0
          else writerparam.extParam.map { i => i.totalCsrNum }.reduce(_ + _)
        } + // The total num of param on writer
        1, // The start CSR
      csrNumReadOnly = 2,
      // Set to two at current, 1) The number of submitted request; 2) The number of finished request. Since the reader path may be forward to remote, here I only count the writer branch
      csrAddrWidth = csrAddrWidth,
      // Set a name for the module class so that it will not overlapped with other csrManagers in user-defined accelerators
      csrModuleTagName = s"${clusterName}_xdma_"
    )
  )

  i_csrmanager.io.csr_config_in <> io.csrIO

  val structuredCfg_src = Wire(new DMADataPathCfgIO(readerparam))
  val structuredCfg_dst = Wire(new DMADataPathCfgIO(writerparam))
  var remainingCSR = i_csrmanager.io.csr_config_out.bits.toIndexedSeq

  // Pack the unstructured signal from csrManager to structured signal: Src side
  // Connect agu_cfg.Ptr
  structuredCfg_src.agu_cfg.Ptr := Cat(remainingCSR(1), remainingCSR(0))
  remainingCSR = remainingCSR.tail.tail

  // Connect agu_cfg.Bounds
  for (i <- 0 until structuredCfg_src.agu_cfg.Bounds.length) {
    structuredCfg_src.agu_cfg.Bounds(i) := remainingCSR.head
    remainingCSR = remainingCSR.tail
  }

  // Connect agu_cfg.Strides
  for (i <- 0 until structuredCfg_src.agu_cfg.Strides.length) {
    structuredCfg_src.agu_cfg.Strides(i) := remainingCSR.head
    remainingCSR = remainingCSR.tail
  }

  // Connect strb signal. As the strb is not effective, so assign all true, and not take any value from CSR right now
  structuredCfg_src.streamer_cfg.strb := VecInit(
    Seq.fill(readerparam.rwParam.tcdm_param.dataWidth / 8)(true.B)
  ).asUInt

  // Connect extension signal
  for (i <- 0 until structuredCfg_src.ext_cfg.length) {
    structuredCfg_src.ext_cfg(i) := remainingCSR.head
    remainingCSR = remainingCSR.tail
  }

  // Pack the unstructured signal from csrManager to structured signal: Dst side
  // Connect agu_cfg.Ptr
  structuredCfg_dst.agu_cfg.Ptr := Cat(remainingCSR(1), remainingCSR(0))
  remainingCSR = remainingCSR.tail.tail

  // Connect agu_cfg.Bounds
  for (i <- 0 until structuredCfg_dst.agu_cfg.Bounds.length) {
    structuredCfg_dst.agu_cfg.Bounds(i) := remainingCSR.head
    remainingCSR = remainingCSR.tail
  }

  // Connect agu_cfg.Strides
  for (i <- 0 until structuredCfg_dst.agu_cfg.Strides.length) {
    structuredCfg_dst.agu_cfg.Strides(i) := remainingCSR.head
    remainingCSR = remainingCSR.tail
  }

  // Connect strb signal. As the strb is effective, so assign the value from CSR
  structuredCfg_dst.streamer_cfg.strb := remainingCSR.head
  remainingCSR = remainingCSR.tail

  // Connect extension signal
  for (i <- 0 until structuredCfg_dst.ext_cfg.length) {
    structuredCfg_dst.ext_cfg(i) := remainingCSR.head
    remainingCSR = remainingCSR.tail
  }

  if (remainingCSR.length > 1)
    println("There is some error in CSR -> Structured CFG assigning")

  // New class that pack the loopBack signal with the ReaderWriterCfg -> ReaderWriterCfgInternal (Local command)
  val preRoute_src_local = Wire(
    Decoupled(new DMADataPathCfgInternalIO(readerparam))
  )
  val preRoute_dst_local = Wire(
    Decoupled(new DMADataPathCfgInternalIO(writerparam))
  )
  val preRoute_loopBack =
    structuredCfg_src.agu_cfg.Ptr(
      structuredCfg_src.agu_cfg.Ptr.getWidth - 1,
      log2Up(readerparam.rwParam.tcdm_param.tcdmSize) + 10
    ) === structuredCfg_dst.agu_cfg.Ptr(
      structuredCfg_dst.agu_cfg.Ptr.getWidth - 1,
      log2Up(readerparam.rwParam.tcdm_param.tcdmSize) + 10
    )

  // Connect bits
  preRoute_src_local.bits.agu_cfg := structuredCfg_src.agu_cfg
  preRoute_src_local.bits.streamer_cfg := structuredCfg_src.streamer_cfg
  preRoute_src_local.bits.ext_cfg := structuredCfg_src.ext_cfg
  preRoute_dst_local.bits.agu_cfg := structuredCfg_dst.agu_cfg
  preRoute_dst_local.bits.streamer_cfg := structuredCfg_dst.streamer_cfg
  preRoute_dst_local.bits.ext_cfg := structuredCfg_dst.ext_cfg
  preRoute_src_local.bits.loopBack := preRoute_loopBack
  preRoute_dst_local.bits.loopBack := preRoute_loopBack
  preRoute_src_local.bits.oppositePtr := preRoute_dst_local.bits.agu_cfg.Ptr
  preRoute_dst_local.bits.oppositePtr := preRoute_src_local.bits.agu_cfg.Ptr

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
      tcdmSize = readerparam.rwParam.tcdm_param.tcdmSize,
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
      tcdmSize = writerparam.rwParam.tcdm_param.tcdmSize,
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
  val s_idle :: s_waitbusy :: s_busy :: Nil = Enum(3)

  s_idle.suggestName("s_idle")
  s_waitbusy.suggestName("s_waitbusy")
  s_busy.suggestName("s_busy")

  // Two registers to store the current state
  val current_state_src = RegInit(s_idle)
  val current_state_dst = RegInit(s_idle)

  // Two Data Cut to store the buffer the current cfg
  val current_cfg_src = Wire(chiselTypeOf(i_srcCfgArbiter.io.out))
  val current_cfg_dst = Wire(chiselTypeOf(i_dstCfgArbiter.io.out))
  i_srcCfgArbiter.io.out -|> current_cfg_src
  i_dstCfgArbiter.io.out -|> current_cfg_dst

  // Default value: Not pop out config, not start reader/writer, not change state
  io.localDMADataPath.reader_start_o := false.B
  io.localDMADataPath.writer_start_o := false.B
  current_cfg_src.ready := false.B
  current_cfg_dst.ready := false.B

  // Control signals in Src Path
  switch(current_state_src) {
    is(s_idle) {
      when(current_cfg_src.valid & (~io.localDMADataPath.reader_busy_i)) {
        current_state_src := s_waitbusy
        io.localDMADataPath.reader_start_o := true.B
      }
    }
    is(s_waitbusy) {
      when(io.localDMADataPath.reader_busy_i) {
        current_state_src := s_busy
      }
    }
    is(s_busy) {
      when(~io.localDMADataPath.reader_busy_i) {
        current_state_src := s_idle
        current_cfg_src.ready := true.B
      }
    }
  }

  // Control signals in Dst Path
  switch(current_state_dst) {
    is(s_idle) {
      when(current_cfg_dst.valid & (~io.localDMADataPath.writer_busy_i)) {
        current_state_dst := s_waitbusy
        io.localDMADataPath.writer_start_o := true.B
      }
    }
    is(s_waitbusy) {
      when(io.localDMADataPath.writer_busy_i) {
        current_state_dst := s_busy
      }
    }
    is(s_busy) {
      when(~io.localDMADataPath.writer_busy_i) {
        current_state_dst := s_idle
        current_cfg_dst.ready := true.B
      }
    }
  }

  // Data Signals in Src Path
  io.localDMADataPath.reader_cfg_o := current_cfg_src.bits
  // Data Signals in Dst Path
  io.localDMADataPath.writer_cfg_o := current_cfg_dst.bits

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
    io.localDMADataPath.writer_busy_i,
    init = false.B
  ) === true.B) && (io.localDMADataPath.writer_busy_i === false.B)
  i_csrmanager.io.read_only_csr(1) := i_finishedTaskCounter.io.value
}
