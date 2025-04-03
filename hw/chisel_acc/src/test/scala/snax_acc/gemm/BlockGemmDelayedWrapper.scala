package snax_acc.gemm

import chisel3._

import snax_acc.utils.DecoupledCut._

/** In BlockGemm, c_i.ready depends on a_i.valid and b_i.valid, making it impossible to drive A and C concurrently. This
  * wrapper delays the a_i and b_i signals to break the combinatorial loop.
  */
class BlockGemmDelayedWrapper(val params: GemmParams) extends Module with RequireAsyncReset {

  val io        = IO(new BlockGemmIO(params))
  val blockGemm = Module(new BlockGemm(params))

  io <> blockGemm.io
  io.data.a_i -||> blockGemm.io.data.a_i
  io.data.b_i -||> blockGemm.io.data.b_i

}
