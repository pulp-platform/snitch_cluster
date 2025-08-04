package snax.DataPathExtension

import chisel3._
import chisel3.util._

class RescaleDownPE(
  in_elementWidth:  Int,
  out_elementWidth: Int
) extends Module {
  require(in_elementWidth > out_elementWidth)

  val io = IO(new Bundle {
    val data_i     = Flipped(Valid(SInt(in_elementWidth.W)))
    val data_o     = Output(SInt(out_elementWidth.W))
    val input_zp   = Input(SInt(32.W)) // Zero point for input
    val multiplier = Input(UInt(32.W))
    val output_zp  = Input(SInt(32.W))
    val shift      = Input(UInt(8.W))  // shift can only be 8 bits
  })

  val zero_compensated_data_i = Wire(SInt(in_elementWidth.W))
  zero_compensated_data_i := io.data_i.bits - io.input_zp

  val multiplied_data_i = Wire(SInt((in_elementWidth + 32).W)) // Length of input data + multiplier
  multiplied_data_i := zero_compensated_data_i * Cat(0.U(1.W), io.multiplier)

  val shifted_one = Wire(SInt((in_elementWidth + 32).W))
  shifted_one := (1.S << (io.shift - 1.U).asUInt).asSInt

  val shifted_data_i = Wire(SInt((in_elementWidth + 32).W))
  shifted_data_i := (multiplied_data_i + shifted_one)

  val scaled_32_data = Wire(SInt((in_elementWidth + 32).W))
  when(zero_compensated_data_i >= 0.S) {
    scaled_32_data := shifted_data_i + (1.S << 30).asSInt
  }.otherwise {
    scaled_32_data := shifted_data_i - (1.S << 30).asSInt
  }

  val correct_shift_value = Wire(SInt((in_elementWidth + 32).W))
  when(io.shift > 31.U) {
    correct_shift_value := scaled_32_data
  }.otherwise {
    correct_shift_value := shifted_data_i
  }

  val shifted_value = Wire(SInt((in_elementWidth + 32).W))
  shifted_value := correct_shift_value >> io.shift

  val long_truncated_value = Wire(SInt(in_elementWidth.W))
  long_truncated_value := shifted_value.asSInt

  val zero_compensated_out = Wire(SInt(in_elementWidth.W))
  zero_compensated_out := long_truncated_value + io.output_zp

  val intervalled_out = Wire(SInt(in_elementWidth.W))

  when(zero_compensated_out >= (1.S << (out_elementWidth - 1).U).asSInt) {
    intervalled_out := ((1.S << (out_elementWidth - 1).U) - 1.S).asSInt
  }.elsewhen(zero_compensated_out < -(1.S << (out_elementWidth - 1).U).asSInt) {
    intervalled_out := -(1.S << (out_elementWidth - 1).U).asSInt
  }.otherwise {
    intervalled_out := zero_compensated_out
  }

  io.data_o := intervalled_out.asSInt
}

class HasRescaleDown(in_elementWidth: Int = 32, out_elementWidth: Int = 8) extends HasDataPathExtension {
  implicit val extensionParam:          DataPathExtensionParam =
    new DataPathExtensionParam(
      moduleName = "RescaleDown",
      userCsrNum = 4,
      dataWidth  = 512
    )
  def instantiate(clusterName: String): RescaleDown            =
    Module(
      new RescaleDown(in_elementWidth, out_elementWidth) {
        override def desiredName = clusterName + namePostfix
      }
    )
}

class RescaleDown(
  in_elementWidth:  Int = 32,
  out_elementWidth: Int = 8
)(implicit extensionParam: DataPathExtensionParam)
    extends DataPathExtension {
  // Exact Version of RescaleDown with no optimizations for area efficiency, not meant to be used in production, only for testing purposes
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

  val input_zp   = WireInit(ext_csr_i(0).asSInt)
  val multiplier = WireInit(ext_csr_i(1).asUInt)
  val output_zp  = WireInit(ext_csr_i(2).asSInt)
  val shift      = WireInit(ext_csr_i(3).asUInt)

  val regs = RegInit(
    VecInit(
      Seq.fill((extensionParam.dataWidth / out_elementWidth) - (extensionParam.dataWidth / in_elementWidth))(
        0.S(out_elementWidth.W)
      )
    )
  )

  val out_wires = Wire(Vec(extensionParam.dataWidth / in_elementWidth, SInt(out_elementWidth.W)))

  val PEs = for (i <- 0 until extensionParam.dataWidth / in_elementWidth) yield {
    val PE = Module(new RescaleDownPE(in_elementWidth = in_elementWidth, out_elementWidth = out_elementWidth) {
      // override val desiredName = "RescaleDownPE"
    })
    PE.io.data_i.valid := ext_data_i.fire
    PE.io.data_i.bits  := ext_data_i
      .bits(
        (i + 1) * in_elementWidth - 1,
        i * in_elementWidth
      )
      .asSInt
    PE.io.input_zp     := input_zp.asSInt
    PE.io.multiplier   := multiplier.asUInt
    PE.io.output_zp    := output_zp.asSInt
    PE.io.shift        := shift.asUInt

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
