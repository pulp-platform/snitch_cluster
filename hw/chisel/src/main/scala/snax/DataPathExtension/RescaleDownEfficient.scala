package snax.DataPathExtension

import chisel3._
import chisel3.util._

class RescaleDownEfficientPE(
  in_elementWidth:  Int,
  out_elementWidth: Int
) extends Module {
  require(in_elementWidth > out_elementWidth)

  val io = IO(new Bundle {
    val data_i                  = Flipped(Valid(SInt(in_elementWidth.W)))
    val data_o                  = Output(SInt(out_elementWidth.W))
    val input_zp                = Input(SInt(32.W)) // Zero point for input
    val bits_to_shift_input     = Input(UInt(5.W))  // shift can only be 5 bits
    val pre_shifted_multiplier  = Input(UInt(16.W))
    val output_zp               = Input(SInt(8.W))
    val post_shift              = Input(UInt(5.W))  // shift can only be 5 bits
    val double_rounding_account = Input(SInt(32.W)) // Account for double rounding
    val thirty_one_minus_shifts = Input(SInt(6.W))
  })

  // Zero compensate the input data
  val zero_compensated_data_i = Wire(SInt(in_elementWidth.W))
  zero_compensated_data_i := io.data_i.bits - io.input_zp

  // Pre-shift the input data
  val pre_shifted_data_i = Wire(SInt(16.W))
  pre_shifted_data_i := zero_compensated_data_i >> io.bits_to_shift_input

  // Multiply the pre-shifted data with the pre-shifted multiplier
  val multiplied_data_i = Wire(SInt(32.W)) // Length of input data + multiplier
  multiplied_data_i := pre_shifted_data_i * io.pre_shifted_multiplier

  // add value for rounding
  val shifted_one = Wire(SInt(32.W))
  shifted_one := (1.S << (io.post_shift - 1.U)).asSInt

  val shifted_data_i = Wire(SInt(32.W))
  shifted_data_i := (multiplied_data_i + shifted_one)

  val scaled_32_data = Wire(SInt(32.W))
  when(zero_compensated_data_i > 0.S) {
    scaled_32_data := shifted_data_i + io.double_rounding_account
  }.otherwise {
    scaled_32_data := shifted_data_i - io.double_rounding_account
  }

  val correct_shift_value = Wire(SInt(32.W))
  when(Cat(0.U(1.W), io.post_shift).asSInt > io.thirty_one_minus_shifts) {
    correct_shift_value := scaled_32_data
  }.otherwise {
    correct_shift_value := shifted_data_i
  }

  // Shift the data with the remaining bits to be shifted
  val shifted_value = Wire(SInt(32.W))
  shifted_value := correct_shift_value >> io.post_shift

  val zero_compensated_out = Wire(SInt(32.W))
  zero_compensated_out := shifted_value + io.output_zp

  val intervalled_out = Wire(SInt(out_elementWidth.W))

  when(zero_compensated_out >= (1.S << (out_elementWidth - 1).U).asSInt) {
    intervalled_out := ((1.S << (out_elementWidth - 1).U) - 1.S).asSInt
  }.elsewhen(zero_compensated_out < -(1.S << (out_elementWidth - 1).U).asSInt) {
    intervalled_out := -(1.S << (out_elementWidth - 1).U).asSInt
  }.otherwise {
    intervalled_out := zero_compensated_out
  }

  io.data_o := intervalled_out.asSInt
}

class HasRescaleDownEfficient(in_elementWidth: Int = 32, out_elementWidth: Int = 8) extends HasDataPathExtension {
  implicit val extensionParam:          DataPathExtensionParam =
    new DataPathExtensionParam(
      moduleName = "RescaleDownEfficient",
      userCsrNum = 4,
      dataWidth  = 512
    )
  def instantiate(clusterName: String): RescaleDownEfficient   =
    Module(
      new RescaleDownEfficient(in_elementWidth, out_elementWidth) {
        override def desiredName = clusterName + namePostfix
      }
    )
}

class RescaleDownEfficient(
  in_elementWidth:  Int = 32,
  out_elementWidth: Int = 8
)(implicit extensionParam: DataPathExtensionParam)
    extends DataPathExtension {
  // Efficient Version of RescaleDown with optimizations for area efficiency
  require(
    extensionParam.dataWidth % in_elementWidth == 0,
    s"RescaleDown: dataWidth (${extensionParam.dataWidth}) must be a multiple of in_elementWidth ($in_elementWidth)"
  )

  require(
    in_elementWidth % out_elementWidth == 0,
    s"RescaleDown: in_elementWidth ($in_elementWidth) must be a multiple of out_elementWidth ($out_elementWidth)"
  )

  val counter = Module(new snax.utils.BasicCounter(log2Ceil(in_elementWidth / out_elementWidth)) {
    override val desiredName = "RescaleDownCounter"
  })
  counter.io.ceil := (in_elementWidth / out_elementWidth).asUInt
  counter.io.reset := ext_start_i
  counter.io.tick  := ext_data_i.fire
  ext_busy_o       := counter.io.value =/= 0.U(1.W)

  val input_zp   = Wire(UInt(32.W))
  val multiplier = Wire(UInt(32.W))
  val output_zp  = Wire(UInt(32.W))
  val shift      = Wire(UInt(32.W))

  input_zp   := ext_csr_i(0).asUInt // TODO : should be SInt, but doesnt allow me to
  multiplier := ext_csr_i(1).asUInt
  output_zp  := ext_csr_i(2).asUInt
  shift      := ext_csr_i(3).asUInt

  // Determine the pre-shifts and post-shifts for the multiplier and input data.
  // Multiplier pre-shift is the same for all PEs, input data pre-shift is different for each PE.
  val used_bits_in_multiplier = Wire(UInt(6.W))
  used_bits_in_multiplier := 32.U - PriorityEncoder(multiplier.asBools.reverse) // +1 to have ceil functionality

  val full_bits_to_shift_input      = Wire(SInt(6.W))
  val bits_to_shift_input           = Wire(UInt(5.W))
  val full_bits_to_shift_multiplier = Wire(SInt(6.W))
  val bits_to_shift_multiplier      = Wire(UInt(5.W))
  full_bits_to_shift_input := (9.S + Cat(0.U(1.W), shift).asSInt - Cat(0.U(1.W), used_bits_in_multiplier).asSInt - 16.S)
  bits_to_shift_input      := Mux(full_bits_to_shift_input < 0.S, 0.U, full_bits_to_shift_input.asUInt)
  full_bits_to_shift_multiplier := (used_bits_in_multiplier - 16.U).asSInt
  bits_to_shift_multiplier      := Mux(full_bits_to_shift_multiplier < 0.S, 0.U, full_bits_to_shift_multiplier.asUInt)

  val pre_shifted_multiplier = Wire(UInt(16.W))
  pre_shifted_multiplier := multiplier >> bits_to_shift_multiplier

  val post_shift = Wire(UInt(5.W))
  post_shift := shift - bits_to_shift_input - bits_to_shift_multiplier

  val double_rounding_account = Wire(SInt(32.W))
  val thirty_one_minus_shifts = Wire(SInt(6.W))
  thirty_one_minus_shifts := (31.S - Cat(0.U(1.W), bits_to_shift_input).asSInt - Cat(
    0.U(1.W),
    bits_to_shift_multiplier
  ).asSInt)
  when(thirty_one_minus_shifts > 1.S) {
    double_rounding_account := (1.S << (thirty_one_minus_shifts.asUInt - 1.U)).asSInt
  }.otherwise {
    double_rounding_account := 0.S
  }

  val regs = RegInit(
    VecInit(
      Seq.fill((extensionParam.dataWidth / out_elementWidth) - (extensionParam.dataWidth / in_elementWidth))(
        0.S(out_elementWidth.W)
      )
    )
  )

  val out_wires = Wire(Vec(extensionParam.dataWidth / in_elementWidth, SInt(out_elementWidth.W)))

  val PEs = for (i <- 0 until extensionParam.dataWidth / in_elementWidth) yield {
    val PE = Module(new RescaleDownEfficientPE(in_elementWidth = in_elementWidth, out_elementWidth = out_elementWidth) {
      // override val desiredName = "RescaleDownEfficientPE"
    })
    PE.io.data_i.valid        := ext_data_i.fire // check if this should be here (i dont think it should, but it works)
    PE.io.data_i.bits         := ext_data_i
      .bits(
        (i + 1) * in_elementWidth - 1,
        i * in_elementWidth
      )
      .asSInt
    PE.io.input_zp            := input_zp.asSInt
    PE.io.bits_to_shift_input := bits_to_shift_input.asUInt
    PE.io.pre_shifted_multiplier  := pre_shifted_multiplier.asUInt
    PE.io.output_zp               := output_zp.asSInt
    PE.io.post_shift              := post_shift.asUInt
    PE.io.double_rounding_account := double_rounding_account.asSInt
    PE.io.thirty_one_minus_shifts := thirty_one_minus_shifts.asSInt

    when(ext_data_i.fire) {
      when(counter.io.value =/= ((in_elementWidth / out_elementWidth).U - 1.U)) {
        regs(counter.io.value * (extensionParam.dataWidth / in_elementWidth).U + i.U) := PE.io.data_o.asSInt
      }
    }
    out_wires(i) := PE.io.data_o.asSInt
  }

  ext_data_o.bits  := VecInit(regs ++ out_wires).asTypeOf(ext_data_o.bits)
  ext_data_o.valid := ext_data_i.fire && counter.io.value === ((in_elementWidth / out_elementWidth).U - 1.U)
  ext_data_i.ready := ext_data_o.ready // Check if this can be more efficient
}
