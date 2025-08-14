package snax.DataPathExtension

import chisel3._
import chisel3.util._

class HasElementwiseAddToLong(
  in_elementWidth:  Int = 8,
  out_elementWidth: Int = 32,
  dataWidth:        Int = 512
) extends HasDataPathExtension {
  implicit val extensionParam: DataPathExtensionParam =
    new DataPathExtensionParam(
      moduleName = s"ElementwiseAddToLongBit${in_elementWidth}To${out_elementWidth}",
      userCsrNum = 1,
      dataWidth  = dataWidth match {
        case 0 => in_elementWidth
        case _ => dataWidth
      }
    )

  def instantiate(clusterName: String): ElementwiseAddToLong =
    Module(
      new ElementwiseAddToLong(in_elementWidth, out_elementWidth) {
        override def desiredName = clusterName + namePostfix
      }
    )
}

object AccumulateCtrlEnumObj {
  object AccumulateCtrlEnum extends ChiselEnum {
    val Busy, WaitingOutput = Value
  }
}

class AccumulateCtrl(
  in_elementWidth:  Int = 8,
  out_elementWidth: Int = 32,
  dataWidth:        Int = 512
) extends Module {

  val io = IO(new Bundle {
    val previous_valid    = Input(Bool())
    val output_ready      = Input(Bool())
    val pooling_size      = Input(UInt(32.W))
    val self_valid        = Output(Bool())
    val self_ready        = Output(Bool())
    val accumulate_reset  = Output(Bool())
    val accumulate_update = Output(Bool())
  })

  import AccumulateCtrlEnumObj.AccumulateCtrlEnum._

  val reset_counter = WireInit(true.B)

  val counter_active     = Wire(Bool())
  // Counter to record the steps
  val accumulate_counter = Module(new snax.utils.BasicCounter(8) {
    override val desiredName = "Accumulate_Counter"
  })
  accumulate_counter.io.ceil := io.pooling_size
  accumulate_counter.io.reset := reset_counter
  accumulate_counter.io.tick  := counter_active & io.previous_valid // Only go up when handshaking is done

  val state = RegInit(Busy)

  switch(state) {
    is(Busy) {
      when(accumulate_counter.io.value === (io.pooling_size - 1.U(8.W))) {
        when(io.output_ready) {
          state := Busy
        }.otherwise {
          state := WaitingOutput
        }
      }.otherwise {
        state := Busy
      }
    }
    is(WaitingOutput) {
      when(io.output_ready) {
        state := Busy
      }.otherwise {
        state := WaitingOutput
      }
    }

  }

  io.self_valid        := false.B
  counter_active       := false.B
  reset_counter        := true.B
  io.self_ready        := true.B
  io.accumulate_reset  := true.B
  io.accumulate_update := false.B

  switch(state) {
    is(Busy) {
      when(accumulate_counter.io.value === (io.pooling_size - 1.U(8.W))) {
        when(io.output_ready) {
          io.self_valid        := true.B
          counter_active       := true.B
          reset_counter        := false.B
          io.self_ready        := true.B
          io.accumulate_reset  := true.B
          io.accumulate_update := true.B
        }.otherwise {
          io.self_valid        := true.B
          counter_active       := false.B
          reset_counter        := false.B
          io.self_ready        := false.B
          io.accumulate_reset  := false.B
          io.accumulate_update := false.B
        }
      }.otherwise {
        io.self_valid        := false.B
        counter_active       := true.B
        reset_counter        := false.B
        io.self_ready        := true.B
        io.accumulate_reset  := false.B
        io.accumulate_update := true.B
      }
    }
    is(WaitingOutput) {
      io.self_valid        := true.B
      counter_active       := io.output_ready
      reset_counter        := false.B
      io.self_ready        := io.output_ready
      io.accumulate_reset  := io.output_ready
      io.accumulate_update := false.B
    }
  }
}

class AccumulateStage(
  in_elementWidth:  Int,
  out_elementWidth: Int,
  dataWidth:        Int = 512
) extends Module {

  val io = IO(new Bundle {
    val data_i         = Flipped(UInt(dataWidth.W))
    val data_o         =
      Output(Vec(out_elementWidth / in_elementWidth, Vec(dataWidth / out_elementWidth, SInt(out_elementWidth.W))))
    val previous_valid = Input(Bool())
    val output_ready   = Input(Bool())
    val pooling_size   = Input(UInt(32.W))
    val self_valid     = Output(Bool())
    val self_ready     = Output(Bool())
  })

  val accumulate_ctrl = Module(
    new AccumulateCtrl(in_elementWidth, out_elementWidth)
  )
  accumulate_ctrl.io.previous_valid := io.previous_valid
  accumulate_ctrl.io.output_ready   := io.output_ready
  accumulate_ctrl.io.pooling_size   := io.pooling_size
  io.self_valid                     := accumulate_ctrl.io.self_valid
  io.self_ready                     := accumulate_ctrl.io.self_ready

  val accumulate_regs = RegInit(
    VecInit.fill(out_elementWidth / in_elementWidth, dataWidth / out_elementWidth)(0.S(out_elementWidth.W))
  )

  val output_data = Wire(
    Vec(out_elementWidth / in_elementWidth, Vec(dataWidth / out_elementWidth, SInt(out_elementWidth.W)))
  )

  val input_data = io.data_i.asTypeOf(
    Vec(dataWidth / in_elementWidth, SInt(in_elementWidth.W))
  )

  for (i <- 0 until dataWidth / out_elementWidth) {
    for (j <- 0 until out_elementWidth / in_elementWidth) {

      output_data(j)(i) := accumulate_regs(j)(i) + input_data(j * dataWidth / out_elementWidth + i)

      when(accumulate_ctrl.io.accumulate_reset) {
        accumulate_regs(j)(i) := 0.S
      }.elsewhen(accumulate_ctrl.io.accumulate_update & io.previous_valid) {
        accumulate_regs(j)(i) := output_data(j)(i)
      }.otherwise {
        accumulate_regs(j)(i) := accumulate_regs(j)(i)
      }

    }
  }

  io.data_o := output_data

}

object OutputCtrlEnumObj {
  object OutputCtrlEnum extends ChiselEnum {
    val WaitingInput, Busy = Value
  }
}

class OutputCtrl(
  in_elementWidth:  Int = 8,
  out_elementWidth: Int = 32,
  dataWidth:        Int = 512
) extends Module {
  val io = IO(new Bundle {
    val accumulate_valid     = Input(Bool())
    val next_ready           = Input(Bool())
    val self_valid           = Output(Bool())
    val self_ready           = Output(Bool())
    val output_counter_value = Output(UInt(log2Ceil(out_elementWidth / in_elementWidth).W))
  })
  import OutputCtrlEnumObj.OutputCtrlEnum._

  val counter_active = WireInit(false.B)
  val reset_counter  = WireInit(true.B)

  // Counter to record the steps
  val output_counter = Module(new snax.utils.BasicCounter(8) {
    override val desiredName = "Output_Counter"
  })
  output_counter.io.ceil := (out_elementWidth / in_elementWidth).U(8.W)
  output_counter.io.reset := reset_counter
  output_counter.io.tick  := counter_active & io.next_ready // Only go up when handshaking is done

  io.output_counter_value := output_counter.io.value

  val state = RegInit(WaitingInput)

  switch(state) {
    is(WaitingInput) {
      when(io.accumulate_valid) {
        state := Busy
      }
    }
    is(Busy) {
      when(output_counter.io.value === (out_elementWidth / in_elementWidth - 1).U(8.W)) {
        when(io.next_ready) {
          when(io.accumulate_valid) {
            state := Busy
          }.otherwise {
            state := WaitingInput
          }
        }.otherwise {
          state := Busy
        }
      }.otherwise {
        state := Busy
      }
    }
  }

  io.self_valid := false.B
  io.self_ready := true.B

  switch(state) {
    is(WaitingInput) {
      io.self_valid  := false.B
      reset_counter  := true.B
      counter_active := false.B
      io.self_ready  := true.B
    }
    is(Busy) {
      when(output_counter.io.value === (out_elementWidth / in_elementWidth - 1).U(8.W)) {
        io.self_valid  := true.B
        reset_counter  := false.B
        counter_active := true.B
        io.self_ready  := io.next_ready
      }.otherwise {
        io.self_valid  := true.B
        reset_counter  := false.B
        counter_active := true.B
        io.self_ready  := false.B
      }
    }
  }

}

class OutputStage(
  in_elementWidth:  Int,
  out_elementWidth: Int,
  dataWidth:        Int = 512
) extends Module {

  val io = IO(new Bundle {
    val data_i           =
      Flipped(Vec(out_elementWidth / in_elementWidth, Vec(dataWidth / out_elementWidth, SInt(out_elementWidth.W))))
    val data_o           = Output(UInt(dataWidth.W))
    val accumulate_valid = Input(Bool())
    val next_ready       = Input(Bool())
    val self_ready       = Output(Bool())
    val self_valid       = Output(Bool())
  })

  val output_ctrl = Module(
    new OutputCtrl(in_elementWidth, out_elementWidth, dataWidth)
  )
  output_ctrl.io.accumulate_valid := io.accumulate_valid
  output_ctrl.io.next_ready       := io.next_ready
  io.self_valid                   := output_ctrl.io.self_valid
  io.self_ready                   := output_ctrl.io.self_ready
  val output_counter_value = Wire(UInt(log2Ceil(out_elementWidth / in_elementWidth).W))
  output_counter_value := output_ctrl.io.output_counter_value

  io.self_ready := output_ctrl.io.self_ready

  // For each input element, on output element is needed
  val output_regs = RegInit(
    VecInit.fill(out_elementWidth / in_elementWidth, dataWidth / out_elementWidth)(0.S(out_elementWidth.W))
  )

  for (i <- 0 until dataWidth / out_elementWidth) {
    for (j <- 0 until out_elementWidth / in_elementWidth) {
      when(output_ctrl.io.self_ready && io.accumulate_valid) {
        output_regs(j)(i) := io.data_i(j)(i)
      }.otherwise {
        output_regs(j)(i) := output_regs(j)(i)
      }
    }
  }

  io.data_o := Cat(output_regs(output_counter_value).reverse)
}

class ElementwiseAddToLong(
  in_elementWidth:  Int,
  out_elementWidth: Int
)(implicit extensionParam: DataPathExtensionParam)
    extends DataPathExtension {
  require(
    extensionParam.dataWidth % in_elementWidth == 0,
    s"Data width ${extensionParam.dataWidth} must be a multiple of element width $in_elementWidth"
  )
  require(
    extensionParam.dataWidth % out_elementWidth == 0,
    s"Data width ${extensionParam.dataWidth} must be a multiple of output element width $out_elementWidth"
  )

  val intermediate_data = VecInit.fill(out_elementWidth / in_elementWidth, extensionParam.dataWidth / out_elementWidth)(
    0.S(out_elementWidth.W)
  )
  val intermediate_valid = Wire(Bool())
  val intermediate_ready = Wire(Bool())

  val accumulate_stage = Module(
    new AccumulateStage(in_elementWidth, out_elementWidth, extensionParam.dataWidth) {
      override def desiredName = "AccumulateStage"
    }
  )
  accumulate_stage.io.data_i := ext_data_i.bits
  accumulate_stage.io.previous_valid := ext_data_i.valid
  accumulate_stage.io.output_ready   := intermediate_ready
  accumulate_stage.io.pooling_size   := ext_csr_i(0).asUInt
  intermediate_data                  := accumulate_stage.io.data_o
  ext_data_i.ready                   := accumulate_stage.io.self_ready
  intermediate_valid                 := accumulate_stage.io.self_valid

  val output_stage = Module(
    new OutputStage(in_elementWidth, out_elementWidth, extensionParam.dataWidth)
  )
  output_stage.io.data_i           := intermediate_data
  output_stage.io.accumulate_valid := intermediate_valid
  output_stage.io.next_ready       := ext_data_o.ready
  ext_data_o.bits                  := output_stage.io.data_o
  ext_data_o.valid                 := output_stage.io.self_valid
  intermediate_ready               := output_stage.io.self_ready

  ext_busy_o := !accumulate_stage.io.self_ready

}
