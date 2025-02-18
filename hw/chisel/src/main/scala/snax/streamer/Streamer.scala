package snax.streamer

import snax.readerWriter._
import snax.csr_manager._
import snax.utils._
import snax.DataPathExtension._

import chisel3._
import chisel3.util._
import play.api.libs.json._
import scala.reflect.runtime.currentMirror
import scala.tools.reflect.ToolBox
import scala.reflect.runtime.universe._

// data to accelerator interface generator
// a vector of decoupled interface with configurable number and configurable width for each port
class DataToAcceleratorX(
    param: StreamerParam
) extends Bundle {
  val data = MixedVec((0 until param.readerNum).map { i =>
    Decoupled(UInt(param.fifoWidthReader(i).W))
    // even for reader, from streamer to accelerator
  } ++ (0 until param.readerWriterNum / 2).map { i =>
    Decoupled(UInt(param.fifoWidthReaderWriter(i * 2).W))
  })
}

// data from accelerator interface generator
// a vector of decoupled interface with configurable number and configurable width for each port
class DataFromAcceleratorX(
    param: StreamerParam
) extends Bundle {
  val data = MixedVec((0 until param.writerNum).map { i =>
    Flipped(Decoupled(UInt(param.fifoWidthWriter(i).W)))
    // oven for writer, from accelerator to streamer
  } ++ (0 until param.readerWriterNum / 2).map { i =>
    Flipped(Decoupled(UInt(param.fifoWidthReaderWriter(i * 2 + 1).W)))
  })
}

// data related io
class StreamerDataIO(
    param: StreamerParam
) extends Bundle {
  // specify the interface to the accelerator
  val streamer2accelerator =
    new DataToAcceleratorX(param)
  val accelerator2streamer =
    new DataFromAcceleratorX(param)

  // specify the interface to the TCDM
  // request interface with q_valid and q_ready
  val tcdm_req =
    (Vec(
      param.tcdmPortsNum,
      Decoupled(new TcdmReq(param.addrWidth, param.tcdmDataWidth))
    ))
  // response interface with p_valid
  val tcdm_rsp = (Vec(
    param.tcdmPortsNum,
    Flipped(Valid(new TcdmRsp(param.tcdmDataWidth)))
  ))
}

/** This class represents the input and output ports of the streamer top module
  *
  * @param param
  *   the parameters class instantiation for the streamer top module
  */
class StreamerIO(
    param: StreamerParam
) extends Bundle {

  // cross clock domain clock from the accelerator
  val accClock = if (param.hasCrossClockDomain) Some(Input(Clock())) else None

  // ports for csr configuration
  val csr = new SnaxCsrIO(param.csrAddrWidth)

  // ports for data in and out
  val data = new StreamerDataIO(
    param
  )
}

// streamer generator module
class Streamer(
    param: StreamerParam
) extends Module
    with RequireAsyncReset {

  override val desiredName = param.tagName + "Streamer"

  val io = IO(
    new StreamerIO(
      param
    )
  )

  require(
    param.readerParams.length == param.readerDatapathExtention.length,
    "The number of reader and reader extension should be the same"
  )
  require(
    param.writerParams.length == param.writerDatapathExtention.length,
    "The number of writer and writer extension should be the same"
  )
  require(
    param.readerWriterParams.length == param.readerWriterDatapathExtention.length,
    "The number of reader_writer and reader_writer extension should be the same"
  )

  // --------------------------------------------------------------------------------
  // ---------------------- csr manager instantiation--------------------------------
  // --------------------------------------------------------------------------------

  val reader_csr =
    param.readerParams.map(_.csrNum).reduceLeftOption(_ + _).getOrElse(0)
  val writer_csr =
    param.writerParams.map(_.csrNum).reduceLeftOption(_ + _).getOrElse(0)
  val reader_writer_csr =
    param.readerWriterParams.map(_.csrNum).reduceLeftOption(_ + _).getOrElse(0)

  def get_extension_list_csr_num(
      extensionSeqSeq: Seq[Seq[HasDataPathExtension]]
  ): Int = {
    extensionSeqSeq
      .map {
        case seq if seq.nonEmpty =>
          seq
            .map(_.extensionParam.userCsrNum)
            .reduceLeftOption(_ + _)
            .getOrElse(0) + 1
        case _ => 0
      }
      .reduceLeftOption(_ + _)
      .getOrElse(0)
  }

  val reader_extension_csr = get_extension_list_csr_num(
    param.readerDatapathExtention
  )

  val writer_extension_csr = get_extension_list_csr_num(
    param.writerDatapathExtention
  )

  val reader_writer_extension_csr = get_extension_list_csr_num(
    param.readerWriterDatapathExtention
  )

  // extra one is the start csr
  val csrNumReadWrite =
    reader_csr + writer_csr + reader_writer_csr + reader_extension_csr + writer_extension_csr + reader_writer_extension_csr + 1

  // csrManager instantiation
  val csrManager = Module(
    new CsrManager(
      csrNumReadWrite,
      // 2 ready only csr for every streamer
      2,
      param.csrAddrWidth,
      param.tagName
    )
  )

  // --------------------------------------------------------------------------------
  // ---------------------- data reader/writer instantiation--------------------------
  // --------------------------------------------------------------------------------

  // data readers instantiation
  // a vector of data reader generator instantiation with different parameters for each module
  val reader = Seq((0 until param.readerNum).map { i =>
    Module(
      new Reader(
        param.readerParams(i),
        param.tagName + "_C" + i.toString()
      )
    )
  }: _*)

  // data writers instantiation
  // a vector of data writer generator instantiation with different parameters for each module
  val writer = Seq((0 until param.writerNum).map { i =>
    Module(
      new Writer(
        param.writerParams(i),
        param.tagName + "_C" + i.toString()
      )
    )
  }: _*)

  // data reader_writers instantiation
  val reader_writer = Seq((0 until param.readerWriterNum / 2).map { i =>
    Module(
      new ReaderWriter(
        param.readerWriterParams(i / 2),
        param.readerWriterParams(i / 2 + 1),
        param.tagName + "_C" + i.toString()
      )
    )
  }: _*)

  // datapath extension module instantiation
  val readerDatapathExtention = (0 until param.readerParams.length).map { i =>
    Module(
      new DataPathExtensionHost(
        extensionList = param.readerDatapathExtention(i),
        dataWidth = param.fifoWidthReader(i),
        headCut = false,
        tailCut = false,
        halfCut = false,
        moduleNamePrefix = param.tagName
      )
    )
  }

  val writerDatapathExtention = (0 until param.writerParams.length).map { i =>
    Module(
      new DataPathExtensionHost(
        extensionList = param.writerDatapathExtention(i),
        dataWidth = param.fifoWidthWriter(i),
        headCut = false,
        tailCut = false,
        halfCut = false,
        moduleNamePrefix = param.tagName
      )
    )
  }

  val readerWriterDatapathExtention =
    (0 until param.readerWriterParams.length).map { i =>
      Module(
        new DataPathExtensionHost(
          extensionList = param.readerWriterDatapathExtention(i),
          dataWidth = param.fifoWidthReaderWriter(i),
          headCut = false,
          tailCut = false,
          halfCut = false,
          moduleNamePrefix = param.tagName
        )
      )
    }

  // --------------------------------------------------------------------------------
  // ---------------------- streamer state machine-----------------------------------
  // --------------------------------------------------------------------------------

  val streamer_config_fire = Wire(Bool())
  val streamer_finish = Wire(Bool())
  val streamer_busy = Wire(Bool())
  val streamer_ready = Wire(Bool())

  // State declaration
  val sIDLE :: sBUSY :: Nil = Enum(2)
  val cstate = RegInit(sIDLE)
  val nstate = WireInit(sIDLE)

  // Changing states
  cstate := nstate

  chisel3.dontTouch(cstate)
  switch(cstate) {
    is(sIDLE) {
      when(streamer_config_fire) {
        nstate := sBUSY
      }.otherwise {
        nstate := sIDLE
      }

    }
    is(sBUSY) {
      when(streamer_finish) {
        nstate := sIDLE
      }.otherwise {
        nstate := sBUSY
      }
    }
  }

  var reader_writer_idx: Int = 0
  var reader_writer_extension_idx: Int = 0

  streamer_config_fire := csrManager.io.csr_config_out.fire
  streamer_busy := cstate === sBUSY
  streamer_ready := cstate === sIDLE

  // if every data reader/writer is not busy
  streamer_finish := !(reader
    .map(_.io.busy)
    .reduceLeftOption(_ || _)
    .getOrElse(0.B) || writer
    .map(_.io.busy)
    .reduceLeftOption(_ || _)
    .getOrElse(0.B) || reader_writer
    .map(_.io.readerInterface.busy)
    .reduceLeftOption(_ || _)
    .getOrElse(0.B) || reader_writer
    .map(_.io.writerInterface.busy)
    .reduceLeftOption(_ || _)
    .getOrElse(0.B) || readerDatapathExtention
    .map(_.io.busy)
    .reduceLeftOption(_ || _)
    .getOrElse(0.B) || writerDatapathExtention
    .map(_.io.busy)
    .reduceLeftOption(_ || _)
    .getOrElse(0.B) || readerWriterDatapathExtention
    .map(_.io.busy)
    .reduceLeftOption(_ || _)
    .getOrElse(0.B))
  dontTouch(streamer_finish)

  // --------------------------------------------------------------------------------
  // -----------------------data movers start-----------------------------------------
  // --------------------------------------------------------------------------------

  // one clock cycle delay for the start signal to store the configuration first
  for (i <- 0 until param.dataMoverNum) {
    if (i < param.readerNum) {
      reader(i).io.start := streamer_config_fire
    } else {
      if (i < param.readerNum + param.writerNum) {
        writer(i - param.readerNum).io.start := streamer_config_fire
      } else {
        reader_writer_idx = (i - param.readerNum - param.writerNum) / 2
        reader_writer(
          reader_writer_idx
        ).io.readerInterface.start := streamer_config_fire
        reader_writer(
          reader_writer_idx
        ).io.writerInterface.start := streamer_config_fire
      }
    }
  }

  // --------------------------------------------------------------------------------
  // -----------------------extension start-----------------------------------------
  // --------------------------------------------------------------------------------

  for (i <- 0 until param.readerDatapathExtention.length) {
    readerDatapathExtention(i).io.start := streamer_config_fire
  }

  for (i <- 0 until param.writerDatapathExtention.length) {
    writerDatapathExtention(i).io.start := streamer_config_fire
  }
  for (i <- 0 until param.readerWriterDatapathExtention.length) {
    readerWriterDatapathExtention(i).io.start := streamer_config_fire
  }

  // --------------------------------------------------------------------------------
  // ---------------------- csr manager connection----------------------------------------------
  // --------------------------------------------------------------------------------

  // connect the csrManager input and streamertop csr req input
  csrManager.io.csr_config_in.req <> io.csr.req

  // io.csr and csrManager input connection
  csrManager.io.csr_config_in.rsp <> io.csr.rsp

  // connect the reader/writer ready and csrManager output ready
  csrManager.io.csr_config_out.ready := streamer_ready

  // add performance counter for streamer
  val streamerIdle2Busy = WireInit(false.B)

  streamerIdle2Busy := streamer_busy && !RegNext(streamer_busy)

  val performance_counter = RegInit(0.U(32.W))
  when(streamerIdle2Busy) {
    performance_counter := 0.U
  }.elsewhen(streamer_busy) {
    performance_counter := performance_counter + 1.U
  }

  // connect the performance counter to the first ready only csr
  csrManager.io.read_only_csr(0) := streamer_busy
  csrManager.io.read_only_csr(1) := performance_counter

  // store the configuration csr for each data mover when config fire
  val csrCfgReg = RegInit(VecInit(Seq.fill(csrNumReadWrite)(0.U(32.W))))
  val csrCfg = Wire(Vec(csrNumReadWrite, UInt(32.W)))
  when(streamer_config_fire) {
    csrCfgReg := csrManager.io.csr_config_out.bits
  }
  csrCfg := Mux(
    streamer_config_fire,
    csrManager.io.csr_config_out.bits,
    csrCfgReg
  )

  // --------------------------------------------------------------------------------
  // ------------------------------------ csr mapping -------------------------------
  // --------------------------------------------------------------------------------

  var remainingCSR = csrCfg.toIndexedSeq

  // reader
  for (i <- 0 until param.readerNum) {
    remainingCSR = reader(i).io.connectCfgWithList(
      remainingCSR
    )
  }

  // writer
  for (i <- 0 until param.writerNum) {
    remainingCSR = writer(i).io.connectCfgWithList(
      remainingCSR
    )
  }

  // reader_writer
  for (i <- 0 until param.readerWriterNum) {
    if (i % 2 == 0) {
      remainingCSR = reader_writer(i / 2).io.readerInterface.connectCfgWithList(
        remainingCSR
      )
    } else {
      remainingCSR = reader_writer(i / 2).io.writerInterface.connectCfgWithList(
        remainingCSR
      )
    }
  }

  // connect the csr configuration to the extension
  for (i <- 0 until param.readerDatapathExtention.length) {
    remainingCSR = readerDatapathExtention(i).io.connectCfgWithList(
      remainingCSR
    )
  }

  for (i <- 0 until param.writerDatapathExtention.length) {
    remainingCSR =
      writerDatapathExtention(i).io.connectCfgWithList(remainingCSR)
  }

  for (i <- 0 until param.readerWriterDatapathExtention.length) {
    remainingCSR = readerWriterDatapathExtention(i).io.connectCfgWithList(
      remainingCSR
    )
  }

  // 1 left csr for start signal
  require(remainingCSR.length == 1)

  // --------------------------------------------------------------------------------
  // ---------------------- data reader/writer <> TCDM connection-------------------
  // --------------------------------------------------------------------------------

  def tcdm_read_ports_num =
    param.readerTcdmPorts.reduceLeftOption(_ + _).getOrElse(0)
  def tcdm_write_ports_num =
    param.writerTcdmPorts.reduceLeftOption(_ + _).getOrElse(0)

  def flattenSeq(inputSeq: Seq[Int]): Seq[(Int, Int, Int)] = {
    var flattenedIndex = -1
    val flattenedSeq = inputSeq.zipWithIndex.flatMap { case (size, dimIndex) =>
      (0 until size).map { innerIndex =>
        flattenedIndex = flattenedIndex + 1
        (dimIndex, innerIndex, flattenedIndex)
      }
    }
    flattenedSeq
  }

  // data reader <> TCDM read ports
  val read_flatten_seq = flattenSeq(param.readerTcdmPorts)
  for ((dimIndex, innerIndex, flattenedIndex) <- read_flatten_seq) {
    // read request to TCDM
    io.data.tcdm_req(flattenedIndex) <> reader(dimIndex).io.tcdmReq(
      innerIndex
    )

    // signals from TCDM responses
    reader(dimIndex).io.tcdmRsp(innerIndex) <> io.data.tcdm_rsp(
      flattenedIndex
    )
  }

  // data writer <> TCDM write ports
  // TCDM request port bias based on the read TCDM ports number
  val write_flatten_seq = flattenSeq(param.writerTcdmPorts)
  for ((dimIndex, innerIndex, flattenedIndex) <- write_flatten_seq) {
    // write request to TCDM
    io.data.tcdm_req(flattenedIndex + tcdm_read_ports_num) <> writer(
      dimIndex
    ).io.tcdmReq(innerIndex)
  }

  // data reader writer <> TCDM read and write ports
  val read_write_flatten_seq = flattenSeq(param.readerWriterTcdmPorts)
  for ((dimIndex, innerIndex, flattenedIndex) <- read_write_flatten_seq) {
    // read request to TCDM
    io.data.tcdm_req(
      flattenedIndex + tcdm_read_ports_num + tcdm_write_ports_num
    ) <> reader_writer(dimIndex).io.readerInterface.tcdmReq(
      innerIndex
    )

    // signals from TCDM responses
    reader_writer(dimIndex).io.readerInterface.tcdmRsp(innerIndex) <> io.data
      .tcdm_rsp(
        flattenedIndex + tcdm_read_ports_num + tcdm_write_ports_num
      )
  }

  // --------------------------------------------------------------------------------
  // ---------------------- data reader/writer <> accelerator data connection-------
  // --------------------------------------------------------------------------------
  // --------------------------------------------------------------------------------
  // connect the data path extension
  // --------------------------------------------------------------------------------
  for (i <- 0 until param.dataMoverNum) {
    if (i < param.readerNum) {
      // reader
      readerDatapathExtention(i).io.data.in <> reader(i).io.data
      readerDatapathExtention(i).io.data.out <> io.data.streamer2accelerator
        .data(
          i
        )
    } else {
      // writer
      if (i < param.readerNum + param.writerNum) {
        io.data.accelerator2streamer
          .data(i - param.readerNum) <> writerDatapathExtention(
          i - param.readerNum
        ).io.data.in
        writer(
          i - param.readerNum
        ).io.data <> writerDatapathExtention(i - param.readerNum).io.data.out
      } else {
        // reader_writer
        reader_writer_idx = (i - param.readerNum - param.writerNum) / 2
        reader_writer_extension_idx = (i - param.readerNum - param.writerNum)
        // reader first
        if (reader_writer_extension_idx % 2 == 0) {
          reader_writer(
            reader_writer_idx
          ).io.readerInterface.data <> readerWriterDatapathExtention(
            reader_writer_extension_idx
          ).io.data.in
          readerWriterDatapathExtention(
            reader_writer_extension_idx
          ).io.data.out <> io.data.streamer2accelerator.data(
            reader_writer_idx + param.readerNum
          )

        } else {
          // writer
          reader_writer(
            reader_writer_idx
          ).io.writerInterface.data <> readerWriterDatapathExtention(
            reader_writer_extension_idx
          ).io.data.out
          io.data.accelerator2streamer
            .data(
              reader_writer_idx + param.writerNum
            ) <> readerWriterDatapathExtention(
            reader_writer_extension_idx
          ).io.data.in
        }

      }
    }
  }

  // --------------------------------------------------------------------------------
  // ---------------------- data reader/writer <> clock from accelerator connection--
  // --------------------------------------------------------------------------------

  if (param.hasCrossClockDomain) {
    for (i <- 0 until param.dataMoverNum) {
      if (i < param.readerNum) {
        reader(i).io.accClock.get := io.accClock.get
      } else {
        if (i < param.readerNum + param.writerNum) {
          writer(i - param.readerNum).io.accClock.get := io.accClock.get
        } else {
          reader_writer_idx = (i - param.readerNum - param.writerNum) / 2
          reader_writer(
            reader_writer_idx
          ).io.readerInterface.accClock.get := io.accClock.get
          reader_writer(
            reader_writer_idx
          ).io.writerInterface.accClock.get := io.accClock.get
        }
      }
    }
  }

  // --------------------------------------------------------------------------------
  // ------------------ csr address map header file generation-----------------------
  // --------------------------------------------------------------------------------

  def genCSRMap(csrBase: Int, param: ReaderWriterParam, tag: String = "") = {
    var csrMap = "// CSR Map for " + tag + "\n"
    var csrOffset = csrBase
    // base pointer
    csrMap = csrMap + "#define BASE_PTR_" + tag + "_LOW " + csrOffset + "\n"
    csrOffset = csrOffset + 1
    csrMap = csrMap + "#define BASE_PTR_" + tag + "_HIGH " + csrOffset + "\n"
    csrOffset = csrOffset + 1

    // spatial bounds
    for (i <- 0 until param.aguParam.spatialBounds.length) {
      csrMap =
        csrMap + "#define " + "S_STRIDE_" + tag + "_" + i + " " + csrOffset + "\n"
      csrOffset = csrOffset + 1
    }

    // temporal bounds
    for (i <- 0 until param.aguParam.temporalDimension) {
      csrMap =
        csrMap + "#define " + "T_BOUND_" + tag + "_" + i + " " + csrOffset + "\n"
      csrOffset = csrOffset + 1
    }

    // temporal stride
    for (i <- 0 until param.aguParam.temporalDimension) {
      csrMap =
        csrMap + "#define " + "T_STRIDE_" + tag + "_" + i + " " + csrOffset + "\n"
      csrOffset = csrOffset + 1
    }

    // address remap index
    if (param.aguParam.tcdmLogicWordSize.length > 1) {
      csrMap =
        csrMap + "#define " + "ADDR_REMAP_INDEX_" + tag + " " + csrOffset + "\n"
      csrOffset = csrOffset + 1
    }

    // channel enable
    if (param.configurableChannel) {
      csrMap =
        csrMap + "#define " + "ENABLED_CHANNEL_" + tag + " " + csrOffset + "\n"
      csrMap =
        csrMap + "#define " + "ENABLED_CHANNEL_" + tag + "_CSR_NUM " + ((param.aguParam.numChannel + 31) / 32) + "\n"
      csrOffset = csrOffset + ((param.aguParam.numChannel + 31) / 32)
    }

    // byte mask enable
    if (param.configurableByteMask) {
      csrMap =
        csrMap + "#define " + "ENABLED_BYTE_" + tag + " " + csrOffset + "\n"
      csrOffset = csrOffset + 1
    }

    csrMap
  }

  var csrBase = 0
  var csrBase_i = 0
  var csrMap = ""

  // reader csr configuration
  csrBase = 960
  for (i <- 0 until param.readerNum) {
    csrBase_i = csrBase + param.readerParams
      .take(i)
      .map(_.csrNum)
      .reduceLeftOption(_ + _)
      .getOrElse(0)
    csrMap = csrMap + genCSRMap(csrBase_i, param.readerParams(i), "READER_" + i)
  }
  csrBase = csrBase + param.readerParams.map(_.csrNum).sum

  // writer csr configuration
  for (i <- 0 until param.writerNum) {
    csrBase_i = csrBase + param.writerParams
      .take(i)
      .map(_.csrNum)
      .reduceLeftOption(_ + _)
      .getOrElse(0)
    csrMap = csrMap + genCSRMap(csrBase_i, param.writerParams(i), "WRITER_" + i)
  }
  csrBase = csrBase + param.writerParams
    .map(_.csrNum)
    .sum

  // reader_writer csr configuration
  for (i <- 0 until param.readerWriterNum) {
    csrBase_i = csrBase + param.readerWriterParams
      .take(i)
      .map(_.csrNum)
      .reduceLeftOption(_ + _)
      .getOrElse(0)
    csrMap = csrMap + genCSRMap(
      csrBase_i,
      param.readerWriterParams(i),
      "READER_WRITER_" + i
    )
  }
  csrBase = csrBase + param.readerWriterParams
    .map(_.csrNum)
    .sum

  // extension csr configuration
  csrMap = csrMap + "// Datapath extension CSRs\n"
  var extension_csr_num = 0

  def get_extension_csr_num(extensionSeq: Seq[HasDataPathExtension]): Int = {
    extension_csr_num = extensionSeq match {
      case seq if seq.nonEmpty =>
        seq
          .map(_.extensionParam.userCsrNum)
          .reduceLeftOption(_ + _)
          .getOrElse(0) + 1
      case _ => 0
    }
    extension_csr_num
  }

  // reader extension csr configuration
  for (i <- 0 until param.readerDatapathExtention.length) {
    extension_csr_num = get_extension_csr_num(param.readerDatapathExtention(i))
    if (extension_csr_num > 0) {
      csrBase_i = csrBase + get_extension_list_csr_num(
        param.readerDatapathExtention.take(i)
      )
      csrMap =
        csrMap + "#define READER_EXTENSION_" + i + "_CSR_BASE " + csrBase_i + "\n"
      csrMap =
        csrMap + s"#define READER_EXTENSION_${i}_CSR_NUM ${extension_csr_num}\n"
    }
  }
  csrBase = csrBase + reader_extension_csr

  // writer extension csr configuration
  for (i <- 0 until param.writerDatapathExtention.length) {
    extension_csr_num = get_extension_csr_num(param.writerDatapathExtention(i))
    if (extension_csr_num > 0) {
      csrBase_i = csrBase + get_extension_list_csr_num(
        param.writerDatapathExtention.take(i)
      )
      csrMap =
        csrMap + "#define WRITER_EXTENSION_" + i + "_CSR_BASE " + csrBase_i + "\n"
      csrMap =
        csrMap + s"#define WRITER_EXTENSION_${i}_CSR_NUM ${extension_csr_num}\n"
    }
  }
  csrBase = csrBase + writer_extension_csr

  // reader_writer extension csr configuration
  for (i <- 0 until param.readerWriterDatapathExtention.length) {
    extension_csr_num = get_extension_csr_num(
      param.readerWriterDatapathExtention(i)
    )
    if (extension_csr_num > 0) {
      csrBase_i = csrBase + get_extension_list_csr_num(
        param.readerWriterDatapathExtention
          .take(i)
      )
      csrMap =
        csrMap + "#define READER_WRITER_EXTENSION_" + i + "_CSR_BASE " + csrBase_i + "\n"
      csrMap =
        csrMap + s"#define READER_WRITER_EXTENSION_${i}_CSR_NUM ${extension_csr_num}\n"
    }
  }
  csrBase = csrBase + reader_writer_extension_csr

  // start csr
  csrMap = csrMap + "// Other resgiters\n"
  csrMap = csrMap + "// Status register\n"
  csrMap = csrMap + "#define STREAMER_START_CSR " + csrBase + "\n"
  csrBase = csrBase + 1

  // streamer busy csr
  csrMap = csrMap + "// Read only CSRs\n"
  csrMap = csrMap + "#define STREAMER_BUSY_CSR " + csrBase + "\n"
  csrBase = csrBase + 1

  // streamer performance counter csr
  csrMap = csrMap + "#define STREAMER_PERFORMANCE_COUNTER_CSR " + csrBase + "\n"

  val macro_dir = param.headerFilepath + "/streamer_csr_addr_map.h"
  val macro_template =
    s"""// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>
// This file is generated by Streamer module in hw/chisel to map the CSR address of Streamer automatically, do not modify it manually
// Generated at ${java.time.Instant.now()}

""" ++ csrMap

  java.nio.file.Files.write(
    java.nio.file.Paths.get(macro_dir),
    macro_template.getBytes(java.nio.charset.StandardCharsets.UTF_8)
  )

}

object StreamerEmitter extends App {
  emitVerilog(
    new Streamer(StreamerParam()),
    Array("--target-dir", "../../target/snitch_cluster/generated")
  )
}

object StreamerGen {
  def main(args: Array[String]): Unit = {

    val parsedArgs = snax.utils.ArgParser.parse(args)

    val outPath = parsedArgs.getOrElse(
      "hw-target-dir",
      "generated"
    )

    // The streamercfg region is passed to chisel generator as a JSON string
    val streamercfg = parsedArgs.find(_._1 == "streamercfg")
    if (streamercfg.isEmpty) {
      println("streamercfg is not provided, generation failed. ")
      sys.exit(-1)
    }
    val parsedstreamercfg = streamercfg.get._2

    // Function to remove the cfg prefix and format the string
    def processInput(input: String): String = {
      val jsonStart = input.indexOf(":") + 1
      val jsonString = input.substring(jsonStart).trim
      val withoutBraces = jsonString.stripSuffix("}")
      withoutBraces
    }

    // Process the input
    var result = processInput(parsedstreamercfg)

    // Parse the JSON string
    // Function to find a specific string and return the string in between the first leftStr and the corresponding rightStr
    def findAndExtract(
        input: String,
        searchString: String,
        leftStr: Char,
        rightStr: Char
    ): String = {
      // Find the index of the search string
      val searchIndex = input.indexOf(searchString)
      if (searchIndex != -1) {
        // Find the index of the first leftStr after the search string
        val startIndex = input.indexOf(leftStr, searchIndex)
        // Initialize a counter for nested braces
        var braceCount = 1
        // Initialize the end index
        var endIndex = startIndex + 1

        // Iterate through the string to find the corresponding closing brace
        while (braceCount > 0 && endIndex < input.length) {
          if (input.charAt(endIndex) == leftStr) {
            braceCount += 1
          } else if (input.charAt(endIndex) == rightStr) {
            braceCount -= 1
          }
          endIndex += 1
        }

        // Extract and return the substring between the indices
        input.substring(startIndex, endIndex)
      } else {
        // If the search string is not found, return an empty string
        ""
      }
    }

    var searchString = "data_reader_params"
    val data_reader_params = findAndExtract(result, searchString, '{', '}')
    val data_reader_extentions =
      findAndExtract(data_reader_params, "datapath_extensions", '[', ']')

    searchString = "data_writer_params"
    val data_writer_params = findAndExtract(result, searchString, '{', '}')
    val data_writer_extentions =
      findAndExtract(data_writer_params, "datapath_extensions", '[', ']')

    searchString = "data_reader_writer_params"
    val data_reader_writer_params =
      findAndExtract(result, searchString, '{', '}')
    val data_reader_writer_extentions =
      findAndExtract(data_reader_writer_params, "datapath_extensions", '[', ']')

    // build the data path extension parameters
    var readerDatapathExtention: Seq[Seq[HasDataPathExtension]] = Seq.fill(
      StreamerParametersGen.readerParams.length
    )(Seq.empty[HasDataPathExtension])
    var writerDatapathExtention: Seq[Seq[HasDataPathExtension]] = Seq.fill(
      StreamerParametersGen.writerParams.length
    )(Seq.empty[HasDataPathExtension])
    var readerWriterDatapathExtention: Seq[Seq[HasDataPathExtension]] =
      Seq.fill(StreamerParametersGen.readerWriterParams.length)(
        Seq.empty[HasDataPathExtension]
      )

    // Function to split the string by one-level brackets
    def splitByOneLevelBrackets(input: String): Seq[String] = {
      val strippedInput = input.stripPrefix("[").stripSuffix("]")
      var result = Seq.empty[String]
      var depth = 0
      var start = 0

      for (i <- strippedInput.indices) {
        strippedInput(i) match {
          case '{' => depth += 1
          case '}' => depth -= 1
          case ',' if depth == 0 =>
            result = result :+ strippedInput.substring(start, i).trim
            start = i + 1
          case _ =>
        }
      }

      result = result :+ strippedInput.substring(start).trim
      result
    }

    def genDatapathExtensionPerStreamer(
        input: String
    ): Seq[HasDataPathExtension] = {

      val readerDatapathExtentionStr =
        Json.parse(input) match {
          case obj: JsObject =>
            obj.fields
              .filter { case (k, v) => k.startsWith("Has") }
              .toSeq
              .map { case (k, v) =>
                // Attempt to parse the value as a Map[String, Either[Int, Seq[Int]]]
                val parsedValue: Map[String, Either[Int, Seq[Int]]] =
                  v.validate[Map[String, JsValue]] match {
                    case JsSuccess(fields, _) =>
                      fields.map { case (key, value) =>
                        // Try to parse each value as Either Int or Seq[Int]
                        key -> (value.validate[Int] match {
                          case JsSuccess(intValue, _) =>
                            Left(intValue) // It's a single Int
                          case JsError(_) =>
                            value.validate[Seq[Int]] match {
                              case JsSuccess(seqValue, _) =>
                                Right(seqValue) // It's a Seq[Int]
                              case JsError(_) =>
                                throw new Exception(
                                  "Invalid data format for " + key
                                )
                            }
                        })
                      }
                    case JsError(_) =>
                      throw new Exception("Invalid data format in JSON")
                  }

                (k, parsedValue)
              }

          case _ => Seq.empty
        }

      var readerDatapathExtentionPerStreamer = Seq[HasDataPathExtension]()
      val toolbox = currentMirror.mkToolBox()

      readerDatapathExtentionStr.foreach(i => {
        readerDatapathExtentionPerStreamer =
          readerDatapathExtentionPerStreamer :+ toolbox
            .compile(toolbox.parse(s"""
              import snax.DataPathExtension._
              return new ${i._1}(${i._2
                .map { list =>
                  list._2 match {
                    case Left(int: Int) => int.toString // Matching Left for Int
                    case Right(seq: Seq[Int]) =>
                      s"Seq(${seq.mkString(",")})" // Matching Right for Seq[Int]
                  }
                }
                .mkString(", ")})
                    """))()
            .asInstanceOf[HasDataPathExtension]
      })

      readerDatapathExtentionPerStreamer
    }

    // reader datapath extension
    if (data_reader_extentions != "") {
      val readerDatapathExtentionList =
        splitByOneLevelBrackets(data_reader_extentions)

      // geenrate the datapath extension parameters for each reader gradually
      readerDatapathExtentionList.zipWithIndex.foreach {
        case (datapath_extension, i) =>
          readerDatapathExtention = readerDatapathExtention.updated(
            i,
            genDatapathExtensionPerStreamer(
              datapath_extension
            )
          )
      }
    }

    // writer datapath extension
    if (data_writer_extentions != "") {
      val writerDatapathExtentionList =
        splitByOneLevelBrackets(data_writer_extentions)

      // geenrate the datapath extension parameters for each writer gradually
      writerDatapathExtentionList.zipWithIndex.foreach {
        case (datapath_extension, i) =>
          writerDatapathExtention = writerDatapathExtention.updated(
            i,
            genDatapathExtensionPerStreamer(
              datapath_extension
            )
          )
      }
    }

    // reader_writer datapath extension
    if (data_reader_writer_extentions != "") {
      val readerWriterDatapathExtentionList =
        splitByOneLevelBrackets(data_reader_writer_extentions)

      readerWriterDatapathExtentionList.zipWithIndex.foreach {
        case (datapath_extension, i) =>
          readerWriterDatapathExtention = readerWriterDatapathExtention.updated(
            i,
            genDatapathExtensionPerStreamer(
              datapath_extension
            )
          )
      }

    }

    emitVerilog(
      new Streamer(
        StreamerParam(
          readerParams = StreamerParametersGen.readerParams,
          writerParams = StreamerParametersGen.writerParams,
          readerWriterParams = StreamerParametersGen.readerWriterParams,
          readerDatapathExtention = readerDatapathExtention,
          writerDatapathExtention = writerDatapathExtention,
          readerWriterDatapathExtention = readerWriterDatapathExtention,
          hasCrossClockDomain = StreamerParametersGen.hasCrossClockDomain,
          csrAddrWidth = 32,
          tagName = StreamerParametersGen.tagName,
          headerFilepath = StreamerParametersGen.headerFilepath
        )
      ),
      Array("--target-dir", outPath)
    )
  }
}
