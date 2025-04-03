package snax_acc.gemmx

import chisel3._
import chisel3.util._

import snax_acc.gemm._
import snax_acc.simd._
import snax_acc.utils._

// The BlockGemmRescaleSIMD's control port declaration.
class BlockGemmRescaleSIMDCtrlIO(params: BlockGemmRescaleSIMDParams) extends Bundle {

  val gemm_ctrl           = Flipped(DecoupledIO(new BlockGemmCtrlIO(params.gemmParams)))
  val simd_ctrl           = Flipped(
    Decoupled(Vec(params.rescaleSIMDParams.readWriteCsrNum, UInt(32.W)))
  )
  val bypassSIMD          = Input(Bool())
  val busy_o              = Output(Bool())
  val performance_counter = Output(UInt(32.W))

}

// The BlockGemmRescaleSIMD's data port declaration. Decoupled interface connected to the streamer
class BlockGemmRescaleSIMDDataIO(params: BlockGemmRescaleSIMDParams) extends Bundle {
  val gemm_data = new Bundle {
    val a_i        = Flipped(
      Decoupled(
        UInt(
          (params.gemmParams.dataWidthA * params.gemmParams.meshRow * params.gemmParams.tileSize).W
        )
      )
    )
    val b_i        = Flipped(
      Decoupled(
        UInt(
          (params.gemmParams.dataWidthB * params.gemmParams.tileSize * params.gemmParams.meshCol).W
        )
      )
    )
    val c_serial_i = Flipped(Decoupled(UInt(params.C32_D32_width.W)))
    val d_serial_o = Decoupled(UInt(params.C32_D32_width.W))
  }
  val simd_data = new Bundle {
    val d_serial_o = Decoupled(
      UInt(
        params.D8_width.W
      )
    )
  }
}

class BlockGemmRescaleSIMDIO(params: BlockGemmRescaleSIMDParams) extends Bundle {
  val ctrl = new BlockGemmRescaleSIMDCtrlIO(params)
  val data = new BlockGemmRescaleSIMDDataIO(params)
}

class BlockGemmRescaleSIMD(params: BlockGemmRescaleSIMDParams) extends Module with RequireAsyncReset {

  val io = IO(new BlockGemmRescaleSIMDIO(params))

  val gemm = Module(new BlockGemm(params.gemmParams))

  // instiantiate the simd module based on the configuration
  // select if use pipelined simd or not accrording to the configuration
  val simd = params.withPipeline match {
    case true  =>
      Module(new PipelinedRescaleSIMD(params.rescaleSIMDParams))
    case false =>
      Module(new RescaleSIMD(params.rescaleSIMDParams))
  }

  // C32 serial to parallel converter
  val C32_s2p = Module(
    new SerialToParallel(
      SerialToParallelParams(
        parallelWidth = params.gemmParams.dataWidthC * params.gemmParams.meshRow * params.gemmParams.meshCol,
        serialWidth   = params.C32_D32_width
      )
    )
  )

  // D3232 parallel to serial converter
  val D32_p2s = Module(
    new ParallelToSerial(
      ParallelToSerialParams(
        parallelWidth = params.gemmParams.dataWidthC * params.gemmParams.meshRow * params.gemmParams.meshCol,
        serialWidth   = params.C32_D32_width
      )
    )
  )

  // D8 parallel to serial converter
  val D8_p2s = Module(
    new ParallelToSerial(
      ParallelToSerialParams(
        parallelWidth = params.rescaleSIMDParams.dataLen * params.rescaleSIMDParams.outputType,
        serialWidth   = params.D8_width
      )
    )
  )

  // data converter connection
  io.data.gemm_data.c_serial_i <> C32_s2p.io.in
  io.data.gemm_data.d_serial_o <> D32_p2s.io.out
  io.data.simd_data.d_serial_o <> D8_p2s.io.out

  // gemm control signal connection
  gemm.io.ctrl <> io.ctrl.gemm_ctrl
  // gemm input data
  gemm.io.data.a_i <> io.data.gemm_data.a_i
  gemm.io.data.b_i <> io.data.gemm_data.b_i
  gemm.io.data.c_i <> C32_s2p.io.out

  // simd signal connection
  when(io.ctrl.bypassSIMD) {
    simd.io.ctrl.valid      := false.B
    io.ctrl.simd_ctrl.ready := false.B
  }.otherwise {
    simd.io.ctrl.valid      := io.ctrl.simd_ctrl.valid
    io.ctrl.simd_ctrl.ready := simd.io.ctrl.ready
  }
  simd.io.ctrl.bits := io.ctrl.simd_ctrl.bits

  // simd data input
  // gemm output
  when(io.ctrl.bypassSIMD) {
    // input driver
    simd.io.data.input_i.valid := false.B

    // gemm output to outside directly
    D32_p2s.io.in.valid    := gemm.io.data.d_o.valid
    // directly connect the ready signal
    gemm.io.data.d_o.ready := D32_p2s.io.in.ready

  }.otherwise {
    // insert a register to improve frequency
    simd.io.data.input_i.valid := gemm.io.data.d_o.valid
    // directly connect the ready signal
    gemm.io.data.d_o.ready     := simd.io.data.input_i.ready

    // output driver
    D32_p2s.io.in.valid := false.B

  }
  simd.io.data.input_i.bits := gemm.io.data.d_o.bits
  D32_p2s.io.in.bits        := gemm.io.data.d_o.bits

  // simd output
  when(io.ctrl.bypassSIMD) {
    // output driver
    D8_p2s.io.in.valid <> false.B
    // fake ready signal
    simd.io.data.output_o.ready := false.B
  }.otherwise {
    D8_p2s.io.in.valid          := simd.io.data.output_o.valid
    simd.io.data.output_o.ready := D8_p2s.io.in.ready
  }
  D8_p2s.io.in.bits := simd.io.data.output_o.bits

  io.ctrl.busy_o := gemm.io.busy_o || simd.io.busy_o || D8_p2s.io.out.valid || D32_p2s.io.out.valid
  when(io.ctrl.bypassSIMD) {
    io.ctrl.performance_counter := gemm.io.performance_counter
  }.otherwise {
    io.ctrl.performance_counter := simd.io.performance_counter
  }

}

object BlockGemmRescaleSIMD extends App {
  emitVerilog(
    new BlockGemmRescaleSIMD(
      BlockGemmRescaleSIMDDefaultConfig.blockGemmRescaleSIMDConfig
    ),
    Array("--target-dir", "generated/gemmx")
  )
}

object BlockGemmRescaleSIMDGen {
  def main(args: Array[String]): Unit = {
    // Helper function to parse command-line arguments into a Map
    def parseArgs(args: Array[String]): Map[String, String] = {
      val parsed_args = args
        .sliding(2, 2)
        .collect {
          case Array(key, value) if key.startsWith("--") => key.drop(2) -> value
        }
        .toMap
      if (parsed_args.size != 6) {
        throw new Exception(
          "Please provide the meshRow, meshCol, tileSize, serialC32D32Width, serialD8Width, and withPipeline. Example usage: sbt 'runMain snax_acc.gemmx.BlockGemmRescaleSIMDGen --meshRow 2 --meshCol 2 --tileSize 16 --serialC32D32Width --serialD8Width --withPipeline true'"
        )
      }
      parsed_args
    }

    // Parse the arguments
    val argMap = parseArgs(args)

    // Retrieve the specific values, providing defaults or error handling
    val meshRow           = argMap("meshRow").toInt
    val meshCol           = argMap("meshCol").toInt
    val tileSize          = argMap("tileSize").toInt
    val serialC32D32Width = argMap("serialC32D32Width").toInt
    val serialD8Width     = argMap("serialD8Width").toInt

    // set the parameters for the gemm module
    // other parameters are set to default values
    val gemmParams = GemmParams(
      GemmConstant.dataWidthA,
      GemmConstant.dataWidthB,
      GemmConstant.dataWidthMul,
      GemmConstant.dataWidthC,
      GemmConstant.dataWidthAccum,
      GemmConstant.subtractionCfgWidth,
      meshRow,
      tileSize,
      meshCol,
      GemmConstant.addrWidth,
      GemmConstant.sizeConfigWidth
    )

    val withPipeline = argMap("withPipeline").toBoolean

    // set the parameters for the simd module to match the output of the gemm module
    // CSR to support per-channel scale factor
    val SIMDReadWriteCsrNum       = 2 + meshCol / 4 + meshCol + 1
    val SIMDParamsWithoutPipeline = RescaleSIMDParams(
      inputType                     = RescaleSIMDConstant.inputType,
      outputType                    = RescaleSIMDConstant.outputType,
      constantType                  = RescaleSIMDConstant.constantType,
      constantMulType               = RescaleSIMDConstant.constantMulType,
      dataLen                       = meshRow * meshCol,
      laneLen                       = meshRow * meshCol,
      readWriteCsrNum               = SIMDReadWriteCsrNum,
      sharedScaleFactorPerGroupSize = meshRow
    )

    val params = BlockGemmRescaleSIMDParams(
      gemmParams,
      (if (withPipeline == true)
         snax_acc.simd.PipelinedConfig.rescaleSIMDConfig
       else SIMDParamsWithoutPipeline),
      withPipeline,
      C32_D32_width = serialC32D32Width,
      D8_width      = serialD8Width
    )

    emitVerilog(
      new BlockGemmRescaleSIMD(
        params
      ),
      Array("--target-dir", "generated/gemmx")
    )

    val GeMMXReadWriteCsrNum = 4 + SIMDReadWriteCsrNum + 2

    var macro_template = ""
    val macro_dir      = "./src/snax_streamer_gemmX_shell_wrapper.sv"
    val header         = s"""// Copyright 2025 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>
// This file is generated by BlockGemmRescaleSIMD module in hw/chisel_acc to wrap the generated verilog code automatically, do not modify it manually
// Generated at ${java.time.Instant.now()}

//-------------------------------
// Accelerator wrapper
//-------------------------------
"""
    val DataWidthA     = GemmConstant.dataWidthA * meshRow * tileSize
    val DataWidthB     = GemmConstant.dataWidthB * tileSize * meshCol
    val DataWidthC     = params.C32_D32_width
    val DataWidthD32   = params.C32_D32_width
    val DataWidthD8    = params.D8_width

    var SIMDCSRConnect = ""
    for (i <- 4 to (4 + SIMDReadWriteCsrNum - 1)) {
      SIMDCSRConnect += s"      .io_ctrl_simd_ctrl_bits_${i - 4} (csr_reg_set_i[$i]),\n"
    }

    macro_template = header + s"""
module snax_streamer_gemmX_shell_wrapper #(
    // Custom parameters. As much as possible,
    // these parameters should not be taken from outside
    parameter int unsigned RegRWCount   = $GeMMXReadWriteCsrNum,
    parameter int unsigned RegROCount   = 2,
    parameter int unsigned DataWidthA   = $DataWidthA,
    parameter int unsigned DataWidthB   = $DataWidthB,
    parameter int unsigned DataWidthC   = $DataWidthC,
    parameter int unsigned DataWidthD32 = $DataWidthD32,
    parameter int unsigned DataWidthD8  = $DataWidthD8,
    parameter int unsigned RegDataWidth = 32,
    parameter int unsigned RegAddrWidth = 32
) (
    //-------------------------------
    // Clocks and reset
    //-------------------------------
    input logic clk_i,
    input logic rst_ni,

    //-------------------------------
    // Accelerator ports
    //-------------------------------
    // Note, we maintained the form of these signals
    // just to comply with the top-level wrapper

    // Ports from accelerator to streamer
    output logic [DataWidthD8-1:0] acc2stream_0_data_o,
    output logic acc2stream_0_valid_o,
    input logic acc2stream_0_ready_i,

    output logic [DataWidthD32-1:0] acc2stream_1_data_o,
    output logic acc2stream_1_valid_o,
    input logic acc2stream_1_ready_i,

    // Ports from streamer to accelerator
    input logic [DataWidthA-1:0] stream2acc_0_data_i,
    input logic stream2acc_0_valid_i,
    output logic stream2acc_0_ready_o,

    input logic [DataWidthB-1:0] stream2acc_1_data_i,
    input logic stream2acc_1_valid_i,
    output logic stream2acc_1_ready_o,

    input logic [DataWidthC-1:0] stream2acc_2_data_i,
    input logic stream2acc_2_valid_i,
    output logic stream2acc_2_ready_o,

    //-------------------------------
    // CSR manager ports
    //-------------------------------
    input  logic [RegRWCount-1:0][RegDataWidth-1:0] csr_reg_set_i,
    input  logic                                    csr_reg_set_valid_i,
    output logic                                    csr_reg_set_ready_o,
    output logic [RegROCount-1:0][RegDataWidth-1:0] csr_reg_ro_set_o
);

  wire io_ctrl_gemm_ctrl_ready;
  wire io_ctrl_simd_ctrl_ready;
  wire bypassSIMD = csr_reg_set_i[${GeMMXReadWriteCsrNum - 2}][0];
  assign csr_reg_set_ready_o = bypassSIMD ? io_ctrl_gemm_ctrl_ready
                                          : io_ctrl_gemm_ctrl_ready & io_ctrl_simd_ctrl_ready;
  assign csr_reg_ro_set_o[0][31:1] = 0;

  BlockGemmRescaleSIMD inst_block_gemm_simd (
      .clock(clk_i),
      .reset(~rst_ni),
      .io_ctrl_gemm_ctrl_ready(io_ctrl_gemm_ctrl_ready),
      .io_ctrl_gemm_ctrl_valid(csr_reg_set_valid_i),
      .io_ctrl_gemm_ctrl_bits_K_i(csr_reg_set_i[0]),
      .io_ctrl_gemm_ctrl_bits_N_i(csr_reg_set_i[1]),
      .io_ctrl_gemm_ctrl_bits_M_i(csr_reg_set_i[2]),
      .io_ctrl_gemm_ctrl_bits_subtraction_constant_i(csr_reg_set_i[3]),

      .io_ctrl_simd_ctrl_ready  (io_ctrl_simd_ctrl_ready),
      .io_ctrl_simd_ctrl_valid  (csr_reg_set_valid_i),
      ${SIMDCSRConnect}

      .io_ctrl_bypassSIMD(bypassSIMD),

      .io_ctrl_busy_o(csr_reg_ro_set_o[0][0]),
      .io_ctrl_performance_counter(csr_reg_ro_set_o[1]),

      .io_data_gemm_data_a_i_ready(stream2acc_0_ready_o),
      .io_data_gemm_data_a_i_valid(stream2acc_0_valid_i),
      .io_data_gemm_data_a_i_bits (stream2acc_0_data_i),

      .io_data_gemm_data_b_i_ready(stream2acc_1_ready_o),
      .io_data_gemm_data_b_i_valid(stream2acc_1_valid_i),
      .io_data_gemm_data_b_i_bits (stream2acc_1_data_i),

      .io_data_gemm_data_c_serial_i_ready(stream2acc_2_ready_o),
      .io_data_gemm_data_c_serial_i_valid(stream2acc_2_valid_i),
      .io_data_gemm_data_c_serial_i_bits (stream2acc_2_data_i),

      .io_data_gemm_data_d_serial_o_ready(acc2stream_1_ready_i),
      .io_data_gemm_data_d_serial_o_valid(acc2stream_1_valid_o),
      .io_data_gemm_data_d_serial_o_bits (acc2stream_1_data_o),

      .io_data_simd_data_d_serial_o_ready(acc2stream_0_ready_i),
      .io_data_simd_data_d_serial_o_valid(acc2stream_0_valid_o),
      .io_data_simd_data_d_serial_o_bits (acc2stream_0_data_o)
  );

endmodule
"""

    java.nio.file.Files.write(
      java.nio.file.Paths.get(macro_dir),
      macro_template.getBytes(java.nio.charset.StandardCharsets.UTF_8)
    )

    // generate the c runtime file arrording to the hardware configuration
    val c_template = s"""// Copyright 2023 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

#pragma once

#define meshRow $meshRow
#define tileSize $tileSize
#define meshCol $meshCol
"""

    val c_header_file_path =
      "../../target/snitch_cluster/sw/snax/gemmx/include/snax-gemmx-params.h"

    java.nio.file.Files.write(
      java.nio.file.Paths.get(s"${c_header_file_path}"),
      c_template.getBytes(java.nio.charset.StandardCharsets.UTF_8)
    )
  }
}
