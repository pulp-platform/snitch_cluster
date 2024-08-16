package snax.xdma.xdmaExtension

import chisel3._
import chisel3.util._
import snax.xdma.CommonCells.DecoupledCut._
import snax.xdma.DesignParams._

// MAXPoolPE module
class MAXPoolPE(dataWidth: Int) extends Module with RequireAsyncReset {
  require(dataWidth > 0)

  val io = IO(new Bundle {
    val data_i = Flipped(Valid(SInt(dataWidth.W)))
    val data_o = Output(SInt(dataWidth.W))
    val init_i = Input(Bool())
  })

  val tempValue = Reg(chiselTypeOf(io.data_i.bits))
  when(io.data_i.valid) {
    when(io.init_i) {
      tempValue := io.data_i.bits
    }.otherwise {
      tempValue := Mux(io.data_i.bits > tempValue, io.data_i.bits, tempValue)
    }
  }
  io.data_o := tempValue
}

object HasMaxPool extends HasDMAExtension {
  implicit val extensionParam: DMAExtensionParam = new DMAExtensionParam(
    moduleName = "MaxPool",
    userCsrNum = 1,
    dataWidth = 512
  )
  def instantiate(clusterName: String): MaxPool = Module(
    new MaxPool(elementWidth = 8) {
      override def desiredName = clusterName + namePostfix
    }
  )
}

class MaxPool(elementWidth: Int)(implicit extensionParam: DMAExtensionParam)
    extends DMAExtension {
  require(extensionParam.dataWidth % elementWidth == 0)

  // Counter to record the steps
  // 256-element MaxPool maximum
  val counter = Module(new snax.xdma.xdmaStreamer.BasicCounter(8) {
    override val desiredName = "xdma_extension_MaxPoolCounter"
  })
  counter.io.ceil := ext_csr_i(0)
  counter.io.reset := ext_start_i
  counter.io.tick := ext_data_i.fire
  ext_busy_o := counter.io.value =/= 0.U

  // The wire to connect the output result
  val ext_data_o_bits = Wire(
    Vec(extensionParam.dataWidth / elementWidth, UInt(elementWidth.W))
  )
  ext_data_o.bits := ext_data_o_bits.asUInt

  val PEs = for (i <- 0 until extensionParam.dataWidth / elementWidth) yield {
    val PE = Module(new MAXPoolPE(dataWidth = elementWidth) {
      override val desiredName = "xdma_extension_MaxPoolPE"
    })
    PE.io.init_i := counter.io.value === 0.U
    PE.io.data_i.valid := ext_data_i.fire
    PE.io.data_i.bits := ext_data_i
      .bits((i + 1) * elementWidth - 1, i * elementWidth)
      .asSInt
    ext_data_o_bits(i) := PE.io.data_o.asUInt
    PE
  }
  // FSM to handle handshake signals

  val s_idle :: s_output :: Nil = Enum(2)
  val current_state = RegInit(s_idle)

  // Default values for ready and valid signals
  ext_data_i.ready := false.B
  ext_data_o.valid := false.B

  switch(current_state) {
    is(s_idle) {
      // Under this condition, the system does not need to send the sum to the next stage
      ext_data_i.ready := true.B
      ext_data_o.valid := false.B
      when(ext_data_i.fire && counter.io.lastVal) {
        // The result is about to be ready, switching state to output
        current_state := s_output
      }
    }
    is(s_output) {
      // Under this condition, the system does need to send the sum to the next stage
      ext_data_o.valid := true.B
      // If the output buffer is empty, then the idling is not necessary. Then the next input data can be fed in without problem
      ext_data_i.ready := ext_data_o.fire
      when(ext_data_o.fire) {
        // The result is saved to the output buffer, state is transitted to idle
        current_state := s_idle
      }
    }
  }
}
