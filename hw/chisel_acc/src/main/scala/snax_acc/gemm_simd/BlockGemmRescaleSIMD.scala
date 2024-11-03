package snax_acc.gemmx

import chisel3._
import chisel3.util._

import snax_acc.simd._
import snax_acc.gemm._

// The BlockGemmRescaleSIMD's control port declaration.
class BlockGemmRescaleSIMDCtrlIO(params: BlockGemmRescaleSIMDParams)
    extends Bundle {

  val gemm_ctrl = Flipped(DecoupledIO(new BlockGemmCtrlIO(params.gemmParams)))
  val simd_ctrl = Flipped(
    Decoupled(Vec(params.rescaleSIMDParams.readWriteCsrNum, UInt(32.W)))
  )
  val bypassSIMD = Input(Bool())
  val busy_o = Output(Bool())
  val performance_counter = Output(UInt(32.W))

}

// The BlockGemmRescaleSIMD's data port declaration. Decoupled interface connected to the streamer
class BlockGemmRescaleSIMDDataIO(params: BlockGemmRescaleSIMDParams)
    extends Bundle {
  val gemm_data = new BlockGemmDataIO(params.gemmParams)
  val simd_data = Decoupled(
    UInt(
      (params.rescaleSIMDParams.dataLen * params.rescaleSIMDParams.outputType).W
    )
  )
}

class BlockGemmRescaleSIMDIO(params: BlockGemmRescaleSIMDParams)
    extends Bundle {
  val ctrl = new BlockGemmRescaleSIMDCtrlIO(params)
  val data = new BlockGemmRescaleSIMDDataIO(params)
}

class BlockGemmRescaleSIMD(params: BlockGemmRescaleSIMDParams)
    extends Module
    with RequireAsyncReset {

  val io = IO(new BlockGemmRescaleSIMDIO(params))

  val gemm = Module(new BlockGemm(params.gemmParams))

  // instiantiate the simd module based on the configuration
  // select if use pipelined simd or not accrording to the configuration
  val simd = params.withPipeline match {
    case true =>
      Module(new PipelinedRescaleSIMD(params.rescaleSIMDParams))
    case false =>
      Module(new RescaleSIMD(params.rescaleSIMDParams))
    case _ => throw new Exception("Unknown SIMD configuration")
  }

  // gemm control signal connection
  gemm.io.ctrl <> io.ctrl.gemm_ctrl
  // gemm input data
  gemm.io.data.a_i <> io.data.gemm_data.a_i
  gemm.io.data.b_i <> io.data.gemm_data.b_i
  gemm.io.data.c_i <> io.data.gemm_data.c_i

  // simd signal connection
  when(io.ctrl.bypassSIMD) {
    simd.io.ctrl.valid := false.B
    io.ctrl.simd_ctrl.ready := false.B
  }.otherwise {
    simd.io.ctrl.valid := io.ctrl.simd_ctrl.valid
    io.ctrl.simd_ctrl.ready := simd.io.ctrl.ready
  }
  simd.io.ctrl.bits := io.ctrl.simd_ctrl.bits

  // simd data input
  // gemm output
  when(io.ctrl.bypassSIMD) {
    // input driver
    simd.io.data.input_i.valid := false.B

    // gemm output to outside directly
    io.data.gemm_data.d_o.valid := gemm.io.data.d_o.valid
    // directly connect the ready signal
    gemm.io.data.d_o.ready := io.data.gemm_data.d_o.ready

  }.otherwise {
    // insert a register to improve frequency
    simd.io.data.input_i.valid := gemm.io.data.d_o.valid
    // directly connect the ready signal
    gemm.io.data.d_o.ready := simd.io.data.input_i.ready

    // output driver
    io.data.gemm_data.d_o.valid := false.B

  }
  simd.io.data.input_i.bits := gemm.io.data.d_o.bits
  io.data.gemm_data.d_o.bits := gemm.io.data.d_o.bits

  // simd output
  when(io.ctrl.bypassSIMD) {
    // output driver
    io.data.simd_data.valid <> false.B
    // fake ready signal
    simd.io.data.output_o.ready := false.B
  }.otherwise {
    io.data.simd_data.valid := simd.io.data.output_o.valid
    simd.io.data.output_o.ready := io.data.simd_data.ready
  }
  io.data.simd_data.bits := simd.io.data.output_o.bits

  io.ctrl.busy_o := gemm.io.busy_o || simd.io.busy_o
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
      if (parsed_args.size != 4) {
        throw new Exception(
          "Please provide the meshRow, meshCol, tileSize, and withPipeline. Example usage: sbt 'runMain snax_acc.gemmx.BlockGemmRescaleSIMDGen --meshRow 2 --meshCol 2 --tileSize 16 --withPipeline true'"
        )
      }
      parsed_args
    }

    // Parse the arguments
    val argMap = parseArgs(args)

    // Retrieve the specific values, providing defaults or error handling
    val meshRow = argMap("meshRow")
    val meshCol = argMap("meshCol")
    val tileSize = argMap("tileSize")

    // set the parameters for the gemm module
    // other parameters are set to default values
    val gemmParams = GemmParams(
      GemmConstant.dataWidthA,
      GemmConstant.dataWidthB,
      GemmConstant.dataWidthMul,
      GemmConstant.dataWidthC,
      GemmConstant.dataWidthAccum,
      GemmConstant.subtractionCfgWidth,
      meshRow.toInt,
      tileSize.toInt,
      meshCol.toInt,
      GemmConstant.addrWidth,
      GemmConstant.sizeConfigWidth
    )

    val withPipeline = argMap("withPipeline").toBoolean

    emitVerilog(
      new BlockGemmRescaleSIMD(
        BlockGemmRescaleSIMDParams(
          gemmParams,
          (if (withPipeline == true)
             snax_acc.simd.PipelinedConfig.rescaleSIMDConfig
           else snax_acc.simd.DefaultConfig.rescaleSIMDConfig),
          withPipeline
        )
      ),
      Array("--target-dir", "generated/gemmx")
    )
  }
}
