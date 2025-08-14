package snax.DataPathExtension

import chisel3._
import chisel3.util._

class DivisionFinder extends Module {
  val io = IO(new Bundle {
    val input = Input(UInt(32.W))
    val output = Output(UInt(32.W))
    val valid_in = Input(Bool())
    val ready_out = Output(Bool())
    val valid_out = Output(Bool())
    val ready_in = Input(Bool())
  })

  // States for the serial division FSM
  val sIdle :: sCompute :: sDone :: Nil = Enum(3)
  val state = RegInit(sIdle)

  // Division registers
  val dividend = RegInit(0.U(32.W))  // 32-bit dividend (2^32 - 1)
  val divisor = RegInit(0.U(32.W))   // Input value
  val quotient = RegInit(0.U(32.W))  // Result
  val remainder = RegInit(0.U(32.W)) // Remainder
  val counter = RegInit(0.U(6.W))    // Bit counter (0 to 32)

  // Output registers
  val result_reg = RegInit(0.U(32.W))
  val valid_reg = RegInit(false.B)

  // Default outputs
  io.ready_out := state === sIdle
  io.valid_out := valid_reg
  io.output := result_reg

  switch(state) {
    is(sIdle) {
      valid_reg := false.B
      when(io.valid_in && io.input =/= 0.U) {
        // Initialize division: dividend = (2^32 - 1)
        dividend := ~0.U(32.W)  // 0xFFFFFFFF
        divisor := io.input
        quotient := 0.U
        remainder := 0.U
        counter := 31.U  // Count down from 31 to 0 (32 iterations)
        state := sCompute
      }.elsewhen(io.valid_in && io.input === 0.U) {
        // Handle division by zero - return maximum value
        result_reg := ~0.U(32.W)
        valid_reg := true.B
        state := sDone
      }
    }

    is(sCompute) {
      // Serial restoring division algorithm
      // Shift remainder left and bring down next bit from dividend (MSB first)
      val shifted_remainder = Cat(remainder(30, 0), dividend(31))
      
      // Try to subtract divisor from shifted remainder
      when(shifted_remainder >= divisor) {
        // Subtraction successful, set quotient bit to 1
        remainder := shifted_remainder - divisor
        quotient := Cat(quotient(30, 0), 1.U)
      }.otherwise {
        // Subtraction failed, set quotient bit to 0
        remainder := shifted_remainder
        quotient := Cat(quotient(30, 0), 0.U)
      }

      // Shift dividend for next iteration (remove MSB)
      dividend := Cat(dividend(30, 0), 0.U)
      counter := counter - 1.U

      when(counter === 0.U) {
        result_reg := quotient
        valid_reg := true.B
        state := sDone
      }
    }

    is(sDone) {
      when(io.ready_in) {
        valid_reg := false.B
        state := sIdle
      }
    }
  }
}



class HasDivisionFinder(
  elementWidth: Int = 32,
  dataWidth:    Int = 512
) extends HasDataPathExtension {
  implicit val extensionParam: DataPathExtensionParam =
    new DataPathExtensionParam(
      moduleName = s"DivisionFinderBit${elementWidth}",
      userCsrNum = 1,
      dataWidth  = 512
    )

  def instantiate(clusterName: String): DivisionFinderExtension =
    Module(
      new DivisionFinderExtension() {
        override def desiredName = clusterName + namePostfix
      }
    )
}

// Test harness for verification
class DivisionFinderExtension(
)(implicit extensionParam: DataPathExtensionParam)
    extends DataPathExtension {

      val division_finder = Module(new DivisionFinder() {
        override def desiredName = "DivisionFinder"
      })

      division_finder.io.input := ext_csr_i(0)
      division_finder.io.valid_in := true.B
      ext_data_i.ready := division_finder.io.ready_out

      ext_data_o.valid := division_finder.io.valid_out
      ext_data_o.bits := Fill(16, division_finder.io.output)
      division_finder.io.ready_in := ext_data_o.ready

      ext_busy_o := division_finder.io.valid_out
    }