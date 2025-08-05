package snax.DataPathExtension

import chisel3._
import chisel3.util._

class RescaleUpPE(
  in_elementWidth:  Int,
  out_elementWidth: Int
) extends Module {
  require(
    out_elementWidth % in_elementWidth == 0,
    s"RescaleUpPE: out_elementWidth ($out_elementWidth) must be a multiple of in_elementWidth ($in_elementWidth)"
  )

  val io = IO(new Bundle {
    val data_i     = Flipped(SInt(in_elementWidth.W))
    val data_o     = Output(SInt(out_elementWidth.W))
    val input_zp   = Input(SInt(32.W)) // Zero point for input
    val multiplier = Input(UInt(32.W))
    val output_zp  = Input(SInt(32.W))
    val shift      = Input(UInt(6.W))  // shift can only be 6 bits
  })

  val zero_compensated_data_i = Wire(SInt((in_elementWidth + 1).W))
  zero_compensated_data_i := io.data_i - io.input_zp

  val multiplied_data_i = Wire(SInt((in_elementWidth + 32 + 1).W)) // Length of input data + multiplier
  multiplied_data_i := zero_compensated_data_i * Cat(0.U(1.W), io.multiplier)

  val shifted_one = Wire(SInt((in_elementWidth + 32).W))
  shifted_one := (1.S << (io.shift - 1.U).asUInt).asSInt

  val shifted_data_i = Wire(SInt((in_elementWidth + 32).W))
  shifted_data_i := (multiplied_data_i + shifted_one)

  val shifted_value = Wire(SInt((in_elementWidth + 32).W))
  shifted_value := shifted_data_i >> io.shift

  val long_truncated_value = Wire(SInt(out_elementWidth.W))
  long_truncated_value := shifted_value.asSInt

  val zero_compensated_out = Wire(SInt(out_elementWidth.W))
  zero_compensated_out := long_truncated_value + io.output_zp

  io.data_o := zero_compensated_out.asSInt
}

object CtrlEnumObj {
  object CtrlEnum extends ChiselEnum {
    val Idle, WaitingIdle, Busy0, Busy1, Busy2, Busy3, Waiting = Value
  }
}

class RescaleUpCtrl(
  in_elementWidth:  Int,
  out_elementWidth: Int
) extends Module {
  import CtrlEnumObj.CtrlEnum._
  require(
    out_elementWidth % in_elementWidth == 0,
    s"RescaleUpCtrl: out_elementWidth ($out_elementWidth) must be a multiple of in_elementWidth ($in_elementWidth)"
  )

  val io = IO(new Bundle {
    val start          = Input(Bool())
    val next_ready     = Input(Bool())
    val previous_valid = Input(Bool())
    val counter_out    = Output(UInt(log2Ceil((out_elementWidth / in_elementWidth)).W))
    val self_valid     = Output(Bool())
    val self_ready     = Output(Bool())
    val self_busy      = Output(Bool())
  })

  val state = RegInit(Idle)

  switch(state) {
    is(Idle) {
      when(io.start) {
        when(io.previous_valid) {
          state := Busy0
        }.otherwise {
          state := WaitingIdle
        }
      }.otherwise {
        state := Idle
      }
    }
    is(WaitingIdle) {
      when(io.previous_valid) {
        state := Busy0
      }.otherwise {
        state := WaitingIdle
      }
    }
    is(Busy0) {
      when(io.next_ready) {
        state := Busy1
      }.otherwise {
        state := Busy0
      }
    }
    is(Busy1) {
      when(io.next_ready) {
        state := Busy2
      }.otherwise {
        state := Busy1
      }
    }
    is(Busy2) {
      when(io.next_ready) {
        state := Busy3
      }.otherwise {
        state := Busy2
      }
    }
    is(Busy3) {
      when(io.next_ready) {
        when(io.previous_valid) {
          state := Busy0
        }.otherwise {
          state := Waiting
        }
      }.otherwise {
        state := Busy3
      }
    }
    is(Waiting) {
      when(io.previous_valid) {
        state := Busy0
      }.otherwise {
        state := Waiting
      }
    }
  } // TODO: make logic for when machine is done and should somehow return to initial state

  io.counter_out := DontCare
  io.self_valid  := false.B
  io.self_ready  := false.B
  io.self_busy   := false.B

  switch(state) {
    is(Idle) {
      io.counter_out := DontCare
      io.self_valid  := false.B
      io.self_ready  := false.B
      io.self_busy   := false.B
    }
    is(WaitingIdle) {
      io.counter_out := DontCare
      io.self_valid  := false.B
      io.self_ready  := false.B
      io.self_busy   := false.B
    }
    is(Busy0) {
      io.counter_out := 0.U
      io.self_valid  := true.B
      io.self_ready  := false.B
      io.self_busy   := true.B
    }
    is(Busy1) {
      io.counter_out := 1.U
      io.self_valid  := true.B
      io.self_ready  := false.B
      io.self_busy   := true.B
    }
    is(Busy2) {
      io.counter_out := 2.U
      io.self_valid  := true.B
      io.self_ready  := false.B
      io.self_busy   := true.B
    }
    is(Busy3) {
      io.counter_out := 3.U
      io.self_valid  := true.B
      io.self_busy   := true.B
      when(io.next_ready) {
        io.self_ready := true.B
      }.otherwise {
        io.self_ready := false.B
      }
    }
    is(Waiting) {
      io.counter_out := DontCare
      io.self_valid  := false.B
      io.self_ready  := true.B
      io.self_busy   := false.B
    }
  }

  dontTouch(state)
  dontTouch(io.start)

}

class HasRescaleUp(in_elementWidth: Int = 8, out_elementWidth: Int = 32) extends HasDataPathExtension {
  implicit val extensionParam:          DataPathExtensionParam =
    new DataPathExtensionParam(
      moduleName = "RescaleUp",
      userCsrNum = 4,
      dataWidth  = 512
    )
  def instantiate(clusterName: String): RescaleUp              =
    Module(
      new RescaleUp(in_elementWidth, out_elementWidth) {
        override def desiredName = clusterName + namePostfix
      }
    )
}

class RescaleUp(
  in_elementWidth:  Int = 8,
  out_elementWidth: Int = 32
)(implicit extensionParam: DataPathExtensionParam)
    extends DataPathExtension {

  require(
    extensionParam.dataWidth % in_elementWidth == 0,
    s"RescaleUp: dataWidth (${extensionParam.dataWidth}) must be a multiple of in_elementWidth ($in_elementWidth)"
  )

  require(
    out_elementWidth % in_elementWidth == 0,
    s"RescaleUp: in_elementWidth ($in_elementWidth) must be a multiple of out_elementWidth ($out_elementWidth)"
  )

  // Control Logic
  val ctrl = Module(new RescaleUpCtrl(in_elementWidth, out_elementWidth))
  ctrl.io.start          := io.start_i
  ctrl.io.next_ready     := ext_data_o.ready
  ctrl.io.previous_valid := ext_data_i.valid
  val counter_val = WireInit(ctrl.io.counter_out.asUInt)
  ext_data_o.valid := ctrl.io.self_valid
  ext_busy_o       := ctrl.io.self_busy
  ext_data_i.ready := ctrl.io.self_ready
  dontTouch(ctrl.io.counter_out)

  // Csr Logic for RescaleUp
  val input_zp   = WireInit(ext_csr_i(0).asSInt)
  val multiplier = WireInit(ext_csr_i(1).asUInt)
  val output_zp  = WireInit(ext_csr_i(2).asSInt)
  val shift      = WireInit(ext_csr_i(3).asUInt)

  // Data Logic
  val input_vec  = WireInit(
    ext_data_i.bits.asTypeOf(Vec(extensionParam.dataWidth / in_elementWidth, SInt(in_elementWidth.W)))
  )
  val output_vec = Wire(Vec(extensionParam.dataWidth / out_elementWidth, SInt(out_elementWidth.W)))

  val PEs = for (i <- 0.until(extensionParam.dataWidth / out_elementWidth)) yield {
    val PE = Module(new RescaleUpPE(in_elementWidth = in_elementWidth, out_elementWidth = out_elementWidth) {
      // override val desiredName = "RescaleUpPE"
    })
    PE.io.data_i     := input_vec(counter_val * (extensionParam.dataWidth / out_elementWidth).U + i.U)
    PE.io.input_zp   := input_zp.asSInt
    PE.io.multiplier := multiplier.asUInt
    PE.io.output_zp  := output_zp.asSInt
    PE.io.shift      := shift.asUInt

    output_vec(i) := PE.io.data_o.asSInt
  }

  // Output Logic
  ext_data_o.bits := output_vec.asTypeOf(UInt(extensionParam.dataWidth.W))
}
