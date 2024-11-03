package snax_acc.utils

import chisel3._
import chisel3.util._

import snax_acc.simd.RescalePECtrl
import snax_acc.simd.RescaleSIMDParams
import snax_acc.simd.SIMDCombinedCutBundle

class CutBundle(aWidth: Int, bWidth: Int, cWidth: Int, dWidth: Int)
    extends Bundle {
  val a = UInt(aWidth.W)
  val b = UInt(bWidth.W)
  val c = UInt(cWidth.W)
  val d = UInt(dWidth.W)
}

class DecoupledCat2to1(
    aWidth: Int,
    params: RescaleSIMDParams,
    n: Int
) extends Module {
  val io = IO(new Bundle {
    // First decoupled input interface (UInt)
    val in1 = Flipped(Decoupled(UInt(aWidth.W)))

    // Second decoupled input interface (Vec of RescalePECtrl)
    val in2 = Flipped(Decoupled(Vec(n, new RescalePECtrl(params))))

    // Combined decoupled output interface
    val out = Decoupled(new SIMDCombinedCutBundle(aWidth, params, n))
  })

  // Assign the UInt input to the 'input_data' field of the output Bundle
  io.out.bits.input_data := io.in1.bits

  // Assign the Vec of RescalePECtrl inputs to the 'ctrl_data' field of the output Bundle
  io.out.bits.ctrl_data := io.in2.bits

  // The output is valid only when both inputs are valid
  io.out.valid := io.in1.valid && io.in2.valid

  // When the output is ready and valid, both inputs can accept new data
  io.in1.ready := io.out.ready && io.out.valid
  io.in2.ready := io.out.ready && io.out.valid
}

class DecoupledCat4to1[T <: Data](
    aWidth: Int,
    bWidth: Int,
    cWidth: Int,
    dWith: Int
) extends Module {
  val io = IO(new Bundle {
    val in1 =
      Flipped(Decoupled(UInt(aWidth.W))) // First decoupled input interface
    val in2 =
      Flipped(Decoupled(UInt(bWidth.W))) // Second decoupled input interface
    val in3 =
      Flipped(Decoupled(UInt(cWidth.W))) // Third decoupled input interface
    val in4 =
      Flipped(Decoupled(UInt(dWith.W))) // Fourth decoupled input interface
    val out = Decoupled(
      new CutBundle(aWidth, bWidth, cWidth, dWith)
    ) // Decoupled output interface
  })

  // Combine the bits of in1 and in2, in1 in higher bits
  io.out.bits.a := io.in1.bits
  io.out.bits.b := io.in2.bits
  io.out.bits.c := io.in3.bits
  io.out.bits.d := io.in4.bits

  // Output is valid only when both inputs are valid
  io.out.valid := io.in1.valid && io.in2.valid && io.in3.valid && io.in4.valid

  // Ready is asserted to inputs when the output is ready
  io.in1.ready := io.out.ready && io.out.valid
  io.in2.ready := io.out.ready && io.out.valid
  io.in3.ready := io.out.ready && io.out.valid
  io.in4.ready := io.out.ready && io.out.valid

}

class DecoupledSplit1to2(cWidth: Int, aWidth: Int, bWidth: Int) extends Module {
  require(
    cWidth == aWidth + bWidth,
    "cWidth must be the sum of aWidth and bWidth"
  )

  val io = IO(new Bundle {
    val in = Flipped(Decoupled(UInt(cWidth.W))) // Large decoupled input (c)
    val out1 = Decoupled(UInt(aWidth.W)) // Smaller decoupled output (a)
    val out2 = Decoupled(UInt(bWidth.W)) // Smaller decoupled output (b)
  })

  // Split the input bits into two parts
  io.out1.bits := io.in.bits(cWidth - 1, bWidth) // Upper bits go to out1 (a)
  io.out2.bits := io.in.bits(bWidth - 1, 0) // Lower bits go to out2 (b)

  // Both outputs are valid when the input is valid
  io.out1.valid := io.in.valid && io.out1.ready && io.out2.ready
  io.out2.valid := io.in.valid && io.out1.ready && io.out2.ready

  // Input is ready when both outputs are ready
  io.in.ready := io.out1.ready && io.out2.ready
}
