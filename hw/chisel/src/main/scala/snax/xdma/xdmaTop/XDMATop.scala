package snax.xdma.xdmaTop

import scala.reflect.runtime.currentMirror
import scala.tools.reflect.ToolBox

import chisel3._
import chisel3.util._

import play.api.libs.json._
import snax.DataPathExtension._
import snax.readerWriter.ReaderWriterParam
import snax.utils._
import snax.xdma.DesignParams._
import snax.xdma.xdmaFrontend._
import snax.xdma.xdmaIO.XDMADataPathCfgIO
import snax.reqRspManager.SnaxReqRspIO

class XDMATopIO(readerParam: XDMAParam, writerParam: XDMAParam) extends Bundle {
  val clusterBaseAddress = Input(
    UInt(writerParam.axiParam.addrWidth.W)
  )
  val csrIO = new SnaxReqRspIO(addrWidth = readerParam.cfgParam.addrWidth, dataWidth = readerParam.cfgParam.dataWidth)

  val remoteXDMACfg = new Bundle {
    val fromRemote = Flipped(
      Decoupled(UInt(readerParam.axiParam.dataWidth.W))
    )
    val toRemote   = Decoupled(UInt(readerParam.axiParam.dataWidth.W))
  }

  val tcdmReader = new Bundle {
    val req = Vec(
      readerParam.rwParam.tcdmParam.numChannel,
      Decoupled(
        new RegReq(
          // The address width of the TCDM => Should be equal to axiAddrWidth
          readerParam.rwParam.tcdmParam.addrWidth,
          readerParam.rwParam.tcdmParam.dataWidth
        )
      )
    )
    val rsp = Vec(
      readerParam.rwParam.tcdmParam.numChannel,
      Flipped(
        Valid(
          new RegRsp(dataWidth = readerParam.rwParam.tcdmParam.dataWidth)
        )
      )
    )
  }
  val tcdmWriter = new Bundle {
    val req = Vec(
      writerParam.rwParam.tcdmParam.numChannel,
      Decoupled(
        new RegReq(
          // The address width of the TCDM => Should be equal to axiAddrWidth
          writerParam.rwParam.tcdmParam.addrWidth,
          writerParam.rwParam.tcdmParam.dataWidth
        )
      )
    )
  }

  val remoteXDMAData = new Bundle {
    val fromRemote               = Flipped(
      Decoupled(
        UInt(
          (writerParam.rwParam.tcdmParam.dataWidth * writerParam.rwParam.tcdmParam.numChannel).W
        )
      )
    )
    val fromRemoteAccompaniedCfg = Output(
      new XDMADataPathCfgIO(
        axiParam          = writerParam.axiParam,
        crossClusterParam = writerParam.crossClusterParam
      )
    )
    val toRemote                 = Decoupled(
      UInt(
        (writerParam.rwParam.tcdmParam.dataWidth * writerParam.rwParam.tcdmParam.numChannel).W
      )
    )
    val toRemoteAccompaniedCfg   = Output(
      new XDMADataPathCfgIO(
        axiParam          = readerParam.axiParam,
        crossClusterParam = readerParam.crossClusterParam
      )
    )
  }

  val remoteTaskFinished = Input(Bool())

  val status = new Bundle {
    val readerBusy = Output(Bool())
    val writerBusy = Output(Bool())
  }
}

class XDMATop(readerParam: XDMAParam, writerParam: XDMAParam, clusterName: String = "unnamed_cluster")
    extends Module
    with RequireAsyncReset {
  override val desiredName = s"${clusterName}_xdma"
  val io                   = IO(
    new XDMATopIO(
      readerParam = readerParam,
      writerParam = writerParam
    )
  )

  val xdmaCtrl = Module(
    new XDMACtrl(
      readerparam = readerParam,
      writerparam = writerParam,
      clusterName = clusterName
    )
  )

  val xdmaDatapath = Module(
    new XDMADataPath(
      readerParam = readerParam,
      writerParam = writerParam,
      clusterName = clusterName
    )
  )

  // Give the dmactrl the current cluster address
  xdmaCtrl.io.clusterBaseAddress := io.clusterBaseAddress

  // IO0: Start to connect datapath to TCDM
  io.tcdmReader <> xdmaDatapath.io.tcdmReader
  io.tcdmWriter <> xdmaDatapath.io.tcdmWriter

  // IO1: Start to connect datapath to axi
  io.remoteXDMAData <> xdmaDatapath.io.remoteXDMAData

  // IO2: Start to coonect ctrl to csr
  io.csrIO <> xdmaCtrl.io.csrIO

  // IO3: Start to connect ctrl to remoteDMADataPath
  io.remoteXDMACfg <> xdmaCtrl.io.remoteXDMACfg

  // Interconnection between ctrl and datapath
  xdmaCtrl.io.localXDMACfg.readerCfg <> xdmaDatapath.io.readerCfg

  xdmaCtrl.io.localXDMACfg.writerCfg <> xdmaDatapath.io.writerCfg

  xdmaDatapath.io.readerStart := xdmaCtrl.io.localXDMACfg.readerStart

  xdmaDatapath.io.writerStart := xdmaCtrl.io.localXDMACfg.writerStart

  xdmaCtrl.io.localXDMACfg.readerBusy := xdmaDatapath.io.readerBusy

  xdmaCtrl.io.localXDMACfg.writerBusy := xdmaDatapath.io.writerBusy

  // The status signal
  io.status.readerBusy := xdmaCtrl.io.localXDMACfg.readerBusy

  io.status.writerBusy := xdmaCtrl.io.localXDMACfg.writerBusy

  // The remote task finished signal
  xdmaCtrl.io.remoteTaskFinished := io.remoteTaskFinished
}

object XDMATopGen extends App {
  val parsedArgs = snax.utils.ArgParser.parse(args)
  // The xdmaCfg region is passed to chisel generator as a JSON string
  val xdmaCfg    = parsedArgs.find(_._1 == "xdmaCfg")
  if (xdmaCfg.isEmpty) {
    println("xdmaCfg is not provided, generation failed. ")
    sys.exit(-1)
  }
  val parsedXdmaCfg: JsValue = Json.parse(xdmaCfg.get._2)

  /*
  Transferred Parameters:
    snax_xdma_cfg: {
        bender_target: ["snax_KUL_cluster_xdma"],
        reader_buffer: 4,
        writer_buffer: 4,
        reader_agu_spatial_bounds: "8",
        reader_agu_temporal_dimension: 6,
        writer_agu_spatial_bounds: "8",
        writer_agu_temporal_dimension: 6,
        HasVerilogMemset: "",
        HasMaxPool: "",
        HasTransposer: "row=Seq(8), col=Seq(8), elementWidth=Seq(8)",
    }
   */

  val cfgParam = new XDMAConfigParam(
    addrWidth = 32,
    dataWidth = (parsedXdmaCfg \ "cfg_io_width").as[Int]
  )

  val axiParam = new XDMAAXIParam(
    addrWidth = parsedArgs("axiAddrWidth").toInt,
    dataWidth = parsedArgs("axiDataWidth").toInt
  )

  val crossClusterParam = new XDMACrossClusterParam(
    maxMulticastDest     = (parsedXdmaCfg \ "max_multicast").as[Int],
    maxTemporalDimension = (parsedXdmaCfg \ "max_dimension").as[Int],
    tcdmSize             = (parsedXdmaCfg \ "max_mem_size").as[Int],
    AxiAddressWidth      = parsedArgs("axiAddrWidth").toInt
  )

  val readerParam = new ReaderWriterParam(
    spatialBounds        = List(
      parsedArgs("axiDataWidth").toInt / parsedArgs("tcdmDataWidth").toInt
    ),
    temporalDimension    = (parsedXdmaCfg \ "reader_agu_temporal_dimension").as[Int],
    tcdmDataWidth        = parsedArgs("tcdmDataWidth").toInt,
    tcdmSize             = parsedArgs("tcdmSize").toInt,
    numChannel           = parsedArgs("axiDataWidth").toInt / parsedArgs("tcdmDataWidth").toInt,
    addressBufferDepth   = (parsedXdmaCfg \ "reader_buffer").as[Int],
    dataBufferDepth      = (parsedXdmaCfg \ "reader_buffer").as[Int],
    configurableChannel  = true,
    configurableByteMask = false
  )

  val writerParam          = new ReaderWriterParam(
    spatialBounds        = List(
      parsedArgs("axiDataWidth").toInt / parsedArgs("tcdmDataWidth").toInt
    ),
    temporalDimension    = (parsedXdmaCfg \ "writer_agu_temporal_dimension").as[Int],
    tcdmDataWidth        = parsedArgs("tcdmDataWidth").toInt,
    tcdmSize             = parsedArgs("tcdmSize").toInt,
    numChannel           = parsedArgs("axiDataWidth").toInt / parsedArgs("tcdmDataWidth").toInt,
    addressBufferDepth   = (parsedXdmaCfg \ "writer_buffer").as[Int],
    dataBufferDepth      = (parsedXdmaCfg \ "writer_buffer").as[Int],
    configurableChannel  = true,
    configurableByteMask = true
  )
  var readerExtensionParam = Seq[HasDataPathExtension]()
  var writerExtensionParam = Seq[HasDataPathExtension]()

  // The following complex code is to dynamically load the extension modules
  // The target is that: 1) the sequence of the extension can be specified by the user 2) users can add their own extensions in the minimal effort (Does not need to modify the generation code)
  // The mechanism is that a small and temporary scala binary is compiled during the execution, to retrieve the instantiation object from the name
  // E.g. "HasMaxPool" -> HasMaxPool object
  // Thus, the generation function does not need to be modified by the extension developers.
  // Extension developers only need to 1) Add the Extension source code 2) Add Has...: #priority in hjson configuration file

  val toolbox = currentMirror.mkToolBox()

  // Writer Side
  val writerDatapathExtensionParam = (parsedXdmaCfg \ "writer_extensions").as[JsObject] match {
    case obj: JsObject =>
      obj.fields.filter { case (k, _) =>
        k.startsWith("Has")
      }.toSeq.map { case (k, v) =>
        (k, v.as[Map[String, Seq[Int]]].values)
      }
    case _ => Seq.empty
  }

  writerDatapathExtensionParam
    .foreach(i => {
      writerExtensionParam = writerExtensionParam :+ toolbox
        .compile(toolbox.parse(s"""
import snax.DataPathExtension._
return new ${i._1}(${i._2
            .map(list => s"Seq(${list.mkString(",")})")
            .mkString(", ")})
      """))()
        .asInstanceOf[HasDataPathExtension]
    })

  // Reader Side
  val readerDatapathExtensionParam = (parsedXdmaCfg \ "reader_extensions").as[JsObject] match {
    case obj: JsObject =>
      obj.fields.filter { case (k, _) =>
        k.startsWith("Has")
      }.toSeq.map { case (k, v) =>
        (k, v.as[Map[String, Seq[Int]]].values)
      }
    case _ => Seq.empty
  }

  readerDatapathExtensionParam
    .foreach(i => {
      readerExtensionParam = readerExtensionParam :+ toolbox
        .compile(toolbox.parse(s"""
import snax.DataPathExtension._
return new ${i._1}(${i._2
            .map(list => s"Seq(${list.mkString(",")})")
            .mkString(", ")})
      """))()
        .asInstanceOf[HasDataPathExtension]
    })

  // Generation of the hardware
  var sv_string = getVerilogString(
    new XDMATop(
      clusterName = parsedArgs.getOrElse("clusterName", ""),
      readerParam = new XDMAParam(
        cfgParam,
        axiParam,
        crossClusterParam,
        readerParam,
        readerExtensionParam
      ),
      writerParam = new XDMAParam(
        cfgParam,
        axiParam,
        crossClusterParam,
        writerParam,
        writerExtensionParam
      )
    )
  )

  // Perform dirty fix on the Chisel's bug that append the file list at the end of the file
  sv_string = sv_string
    .split("\n")
    .takeWhile(
      !_.contains(
        """// ----- 8< ----- FILE "firrtl_black_box_resource_files.f" ----- 8< -----"""
      )
    )
    .mkString("\n")

  // Write the sv_string to the SystemVerilog file
  val hardware_dir = parsedArgs.getOrElse(
    "hw-target-dir",
    "generated"
  ) + "/" + s"${parsedArgs.getOrElse("clusterName", "")}_xdma.sv"
  java.nio.file.Files.write(
    java.nio.file.Paths.get(hardware_dir),
    sv_string.getBytes(java.nio.charset.StandardCharsets.UTF_8)
  )

  // Generation of the software #define macros
  val macro_dir = parsedArgs.getOrElse(
    "sw-target-dir",
    "generated"
  ) + "/include/snax-xdma-csr-addr.h"

  val macro_template =
    s"""// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Yunhao Deng <yunhao.deng@kuleuven.be>

// This file is automatically generated by XDMA hardware generator corresponding to hardware configuration. 
// Do not modify or commit this file to the repository manually.

#define XDMA_BASE_ADDR 960
#define XDMA_WIDTH ${writerParam.tcdmParam.numChannel * writerParam.tcdmParam.dataWidth / 8}
#define XDMA_SPATIAL_CHAN ${writerParam.tcdmParam.numChannel}

// The base address region of the XDMA
#define XDMA_SRC_ADDR_PTR_LSB XDMA_BASE_ADDR
#define XDMA_SRC_ADDR_PTR_MSB XDMA_SRC_ADDR_PTR_LSB + 1
#define XDMA_MAX_DST_COUNT ${crossClusterParam.maxMulticastDest}
#define XDMA_DST_ADDR_PTR_LSB XDMA_SRC_ADDR_PTR_MSB + 1
#define XDMA_DST_ADDR_PTR_MSB XDMA_DST_ADDR_PTR_LSB + 1

// The stride and bound region of the reader of XDMA
#define XDMA_SRC_TEMP_DIM ${crossClusterParam.maxTemporalDimension}
#define XDMA_SRC_SPATIAL_STRIDE_PTR XDMA_DST_ADDR_PTR_LSB + XDMA_MAX_DST_COUNT * 2
#define XDMA_SRC_TEMP_BOUND_PTR XDMA_SRC_SPATIAL_STRIDE_PTR + 1
#define XDMA_SRC_TEMP_STRIDE_PTR XDMA_SRC_TEMP_BOUND_PTR + XDMA_SRC_TEMP_DIM

// The channel and strobe region of the reader of XDMA
#define XDMA_SRC_ENABLED_CHAN_PTR XDMA_SRC_TEMP_STRIDE_PTR + XDMA_SRC_TEMP_DIM
#define XDMA_SRC_BYPASS_PTR XDMA_SRC_ENABLED_CHAN_PTR + ${if (readerParam.configurableChannel) 1
      else 0}
#define XDMA_SRC_EXT_NUM ${readerExtensionParam.length}
#define XDMA_SRC_EXT_CSR_PTR XDMA_SRC_BYPASS_PTR + ${if (readerExtensionParam.length > 0) 1
      else 0}
#define XDMA_SRC_EXT_CSR_NUM ${readerExtensionParam
        .map(_.extensionParam.userCsrNum)
        .sum}
#define XDMA_SRC_EXT_CUSTOM_CSR_NUM \\
    { ${readerExtensionParam.map(_.extensionParam.userCsrNum).mkString(", ")} }

// The stride and bound region of the writer of XDMA
#define XDMA_DST_TEMP_DIM ${crossClusterParam.maxTemporalDimension}
#define XDMA_DST_SPATIAL_STRIDE_PTR XDMA_SRC_EXT_CSR_PTR + XDMA_SRC_EXT_CSR_NUM
#define XDMA_DST_TEMP_BOUND_PTR XDMA_DST_SPATIAL_STRIDE_PTR + 1
#define XDMA_DST_TEMP_STRIDE_PTR XDMA_DST_TEMP_BOUND_PTR + XDMA_DST_TEMP_DIM

#define XDMA_DST_ENABLED_CHAN_PTR XDMA_DST_TEMP_STRIDE_PTR + XDMA_DST_TEMP_DIM
#define XDMA_DST_ENABLED_BYTE_PTR XDMA_DST_ENABLED_CHAN_PTR + ${if (writerParam.configurableChannel) 1
      else 0}
#define XDMA_DST_BYPASS_PTR XDMA_DST_ENABLED_BYTE_PTR + ${if (writerParam.configurableByteMask) 1
      else 0}
#define XDMA_DST_EXT_NUM ${writerExtensionParam.length}
#define XDMA_DST_EXT_CSR_PTR XDMA_DST_BYPASS_PTR + ${if (writerExtensionParam.length > 0) 1
      else 0}
#define XDMA_DST_EXT_CSR_NUM ${writerExtensionParam
        .map(_.extensionParam.userCsrNum)
        .sum}
#define XDMA_DST_EXT_CUSTOM_CSR_NUM \\
    { ${writerExtensionParam.map(_.extensionParam.userCsrNum).mkString(", ")} }
#define XDMA_START_PTR XDMA_DST_EXT_CSR_PTR + XDMA_DST_EXT_CSR_NUM
#define XDMA_COMMIT_LOCAL_TASK_PTR XDMA_START_PTR + 1
#define XDMA_COMMIT_REMOTE_TASK_PTR XDMA_COMMIT_LOCAL_TASK_PTR + 1
#define XDMA_FINISH_LOCAL_TASK_PTR XDMA_COMMIT_REMOTE_TASK_PTR + 1
#define XDMA_FINISH_REMOTE_TASK_PTR XDMA_FINISH_LOCAL_TASK_PTR + 1
#define XDMA_PERF_CTR_TASK XDMA_FINISH_REMOTE_TASK_PTR + 1
#define XDMA_PERF_CTR_READER XDMA_PERF_CTR_TASK + 1
#define XDMA_PERF_CTR_WRITER XDMA_PERF_CTR_READER + 1
"""

  // Ensure the directory exists before writing the file
  val macro_dir_path   = java.nio.file.Paths.get(macro_dir)
  val macro_dir_parent = macro_dir_path.getParent
  if (macro_dir_parent != null && !java.nio.file.Files.exists(macro_dir_parent)) {
    java.nio.file.Files.createDirectories(macro_dir_parent)
  }
  java.nio.file.Files.write(
    macro_dir_path,
    macro_template.getBytes(java.nio.charset.StandardCharsets.UTF_8)
  )
}
