package snax_acc.gemmx

import chisel3._
import chisel3.util._

import snax_acc.simd._
import snax_acc.gemm._

case class BlockGemmRescaleSIMDParams(
    gemmParams: GemmParams,
    rescaleSIMDParams: RescaleSIMDParams,
    withPipeline: Boolean
)

object BlockGemmRescaleSIMDDefaultConfig {

  // this parameter is to select if use pipelined simd or not
  // by default, it is true
  def withPipeline: Boolean = true

  lazy val blockGemmRescaleSIMDConfig: BlockGemmRescaleSIMDParams = {

    if (withPipeline == true) {
      BlockGemmRescaleSIMDParams(
        snax_acc.gemm.DefaultConfig.gemmConfig,
        snax_acc.simd.PipelinedConfig.rescaleSIMDConfig,
        withPipeline
      )
    } else {
      BlockGemmRescaleSIMDParams(
        snax_acc.gemm.DefaultConfig.gemmConfig,
        snax_acc.simd.DefaultConfig.rescaleSIMDConfig,
        withPipeline
      )
    }

  }

}
