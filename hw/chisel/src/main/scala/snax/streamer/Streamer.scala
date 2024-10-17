package snax.streamer

import snax.readerWriter._
import snax.csr_manager._
import snax.utils._
import snax.DataPathExtension._

import chisel3._
import chisel3.util._

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

  // --------------------------------------------------------------------------------
  // ---------------------- csr manager instantiation--------------------------------
  // --------------------------------------------------------------------------------

  val reader_csr =
    param.readerParams.map(_.csrNum).reduceLeftOption(_ + _).getOrElse(0)
  val writer_csr =
    param.writerParams.map(_.csrNum).reduceLeftOption(_ + _).getOrElse(0)
  val reader_writer_csr =
    param.readerWriterParams.map(_.csrNum).reduceLeftOption(_ + _).getOrElse(0)

  // extra one is the start csr
  val csrNumReadWrite =
    reader_csr + writer_csr + reader_writer_csr + (if (param.hasTranspose)
                                                     param.readerParams.length
                                                   else
                                                     0) + (if (
                                                             param.hasCBroadcast
                                                           ) param.readerWriterParams.length / 2
                                                           else 0) + 1

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

  // transpose module instantiation
  val readerExtensions = (0 until param.readerParams.length).map { i =>
    Module(
      new DataPathExtensionHost(
        extensionList = param.dataPathABExtensionParam,
        dataWidth = param.fifoWidthReader(i),
        headCut = false,
        tailCut = false,
        halfCut = false,
        moduleNamePrefix = param.tagName
      )
    )
  }

  // c broadcast module instantiation for reader
  val readerCExtention = (0 until param.readerWriterParams.length / 2).map {
    i =>
      Module(
        new DataPathExtensionHost(
          extensionList = param.dataPathCExtensionParam,
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
    .getOrElse(0.B) || readerExtensions
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

  for (i <- 0 until param.readerParams.length) {
    readerExtensions(i).io.start := streamer_config_fire
  }

  for (i <- 0 until param.readerWriterParams.length / 2) {
    readerCExtention(i).io.start := streamer_config_fire
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

  // transpose

  // connect the csr configuration to the extension
  for (i <- 0 until param.readerParams.length) {
    remainingCSR = readerExtensions(i).io.connectCfgWithList(
      remainingCSR
    )
  }

  // c broadcast
  for (i <- 0 until param.readerWriterParams.length / 2) {
    remainingCSR = readerCExtention(i).io.connectCfgWithList(remainingCSR)
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

  for (i <- 0 until param.dataMoverNum) {
    // reader
    if (i < param.readerNum) {
      // --------------------------------------------------------------------------------
      // connect the data path extension
      // --------------------------------------------------------------------------------
      readerExtensions(i).io.data.in <> reader(i).io.data
      readerExtensions(i).io.data.out <> io.data.streamer2accelerator.data(
        i
      )
    } else {
      // writer
      if (i < param.readerNum + param.writerNum) {
        writer(
          i - param.readerNum
        ).io.data <> io.data.accelerator2streamer
          .data(i - param.readerNum)
      } else {
        // reader_writer
        // reader C broadcast extension
        reader_writer_idx = (i - param.readerNum - param.writerNum) / 2
        reader_writer(
          reader_writer_idx
        ).io.readerInterface.data <> readerCExtention(
          reader_writer_idx
        ).io.data.in
        readerCExtention(
          reader_writer_idx
        ).io.data.out <> io.data.streamer2accelerator.data(
          reader_writer_idx + param.readerNum
        )

        reader_writer(
          reader_writer_idx
        ).io.writerInterface.data <> io.data.accelerator2streamer
          .data(
            reader_writer_idx + param.writerNum
          )
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

}

class StreamerHeaderFile(param: StreamerParam) {

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
      csrOffset = csrOffset + 1
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

  // writer csr configuration
  csrBase = 960 + param.readerParams.map(_.csrNum).sum
  for (i <- 0 until param.writerNum) {
    csrBase_i = csrBase + param.writerParams
      .take(i)
      .map(_.csrNum)
      .reduceLeftOption(_ + _)
      .getOrElse(0)
    csrMap = csrMap + genCSRMap(csrBase_i, param.writerParams(i), "WRITER_" + i)
  }

  // reader_writer csr configuration
  csrBase = csrBase + param.writerParams
    .map(_.csrNum)
    .sum
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

  // extension csr configuration
  csrBase = csrBase + param.readerWriterParams
    .map(_.csrNum)
    .sum
  if (param.hasTranspose) {
    csrMap = csrMap + "#define TRANSPOSE_EXTENSION_ENABLE \n"
    for (i <- 0 until param.readerParams.length) {
      csrBase_i = csrBase + i
      csrMap =
        csrMap + "#define TRANSPOSE_CSR_READER_" + i + " " + csrBase_i + "\n"
    }
  }

  // c broadcast csr configuration
  csrBase = csrBase + (if (param.hasTranspose)
                         param.readerParams.length
                       else 0)
  if (param.hasCBroadcast) {
    csrMap = csrMap + "#define C_BROADCAST_EXTENSION_ENABLE \n"
    for (i <- 0 until param.readerWriterParams.length / 2) {
      csrBase_i = csrBase + i
      csrMap =
        csrMap + "#define C_BROADCAST_CSR_READER_WRITER_" + i + " " + csrBase_i + "\n"
    }
  }

  // start csr
  csrMap = csrMap + "// Other resgiters\n"
  csrMap = csrMap + "// Status register\n"
  csrBase = csrBase + (if (param.hasCBroadcast)
                         param.readerWriterParams.length / 2
                       else 0)
  csrMap = csrMap + "#define STREAMER_START_CSR " + csrBase + "\n"

  // streamer busy csr
  csrMap = csrMap + "// Read only CSRs\n"
  csrBase = csrBase + 1
  csrMap = csrMap + "#define STREAMER_BUSY_CSR " + csrBase + "\n"

  // streamer performance counter csr
  csrBase = csrBase + 1
  csrMap = csrMap + "#define STREAMER_PERFORMANCE_COUNTER_CSR " + csrBase + "\n"

  println(csrMap)

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
