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
        counter := 32.U  // Count down from 32 to 0 (32 iterations)
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

class SoftMaxCtrl() extends Module {
    val io = IO(new Bundle {
        // Control signals for the overall block
        val start = Input(Bool())
        val valid_in = Input(Bool())
        val ready_in = Output(Bool())
        val valid_out = Output(Bool())
        val ready_out = Input(Bool())
        val softmax_cycles = Input(UInt(32.W))
        // Control signals for the max finder
        val update_max = Output(Bool())
        // Control signals for the exponentiation
        val update_adders = Output(Bool())
        // Control signals for the divider
        val start_divider = Output(Bool())
        val divider_valid = Input(Bool())
        val busy = Output(Bool())
    })

    val cIdle :: cMaxSearch :: cExponentiation :: cEndOfExponentiation :: cDivide :: cOutput :: cEndOfOutput :: Nil = Enum(7)
    val state = RegInit(cIdle)

    val reset_counter = Wire(Bool())

    val counter = Module(new snax.utils.BasicCounter(8) {
    override val desiredName = "SoftMaxCounter"
  })
    counter.io.ceil := io.softmax_cycles + 4.U // +4 for the end of exponentiation and divide
    counter.io.reset := reset_counter
    counter.io.tick := io.valid_in

    switch(state) {
        is(cIdle) {
            when(io.start) {
                state := cMaxSearch
            }
        }
        is(cMaxSearch) {
            when(counter.io.value === (io.softmax_cycles - 1.U)) {
                state := cExponentiation
            }
        }
        is(cExponentiation) {
            when(counter.io.value === (io.softmax_cycles - 1.U)) {
                state := cEndOfExponentiation
            }
        }

        is(cEndOfExponentiation) {
            when(counter.io.value === (io.softmax_cycles + 2.U)) {
                state := cDivide
            }
        }
        is(cDivide) {
            when(io.divider_valid && io.valid_in) {
                state := cOutput
            }
        }
        is(cOutput) {
            when(counter.io.value === (io.softmax_cycles - 1.U)) {
                state := cEndOfOutput
            }
        }
        is(cEndOfOutput) {
            when(counter.io.value === (io.softmax_cycles + 2.U)) {
                state := cIdle
            }
        }
    }

    reset_counter := true.B
    io.ready_in := true.B
    io.valid_out := false.B
    io.update_max := false.B
    io.start_divider := false.B
    io.busy := state =/= cIdle
    io.update_adders := false.B

    switch(state) {
        is(cIdle) {
            reset_counter := true.B
            io.ready_in := false.B
            io.valid_out := false.B
            io.update_max := false.B
            io.start_divider := false.B
            io.update_adders := false.B
        }
        is(cMaxSearch) {
            io.ready_in := true.B
            io.valid_out := true.B
            io.update_max := true.B
            io.start_divider := false.B
            when (counter.io.value === (io.softmax_cycles - 1.U)) {
                reset_counter := true.B
            } .otherwise {
                reset_counter := false.B
            }
            io.update_adders := false.B 
        }
        is(cExponentiation) {
            reset_counter := false.B
            io.ready_in := (counter.io.value =/= (io.softmax_cycles - 1.U)) // Dont allow input on last cycle
            io.valid_out := true.B
            io.update_max := false.B
            io.start_divider := false.B
            io.update_adders := (counter.io.value >= 3.U)
        }
        is(cEndOfExponentiation) {
            io.ready_in := false.B
            io.valid_out := true.B  
            io.update_max := false.B
            io.start_divider := (counter.io.value === (io.softmax_cycles + 2.U)) //Start up on last cycle
            when (counter.io.value === (io.softmax_cycles + 2.U)) {
                reset_counter := true.B
            } .otherwise {
                reset_counter := false.B
            }
            io.update_adders := (counter.io.value >= 3.U) // Allow adders to update until the end of exponentiation
        }
        is(cDivide) {
            reset_counter := true.B
            io.ready_in := io.divider_valid
            io.valid_out := true.B
            io.update_max := false.B
            io.start_divider := false.B
            io.update_adders := false.B
        }
        is(cOutput) {
            reset_counter := false.B
            io.ready_in := (counter.io.value =/= (io.softmax_cycles - 1.U))
            io.valid_out := (counter.io.value >= 3.U)
            io.update_max := false.B
            io.start_divider := false.B
            io.update_adders := false.B
        }
        is(cEndOfOutput) {
            io.ready_in := false.B
            io.valid_out := (counter.io.value >= 3.U)
            io.update_max := false.B
            io.start_divider := false.B
            when (counter.io.value === (io.softmax_cycles + 2.U)) {
                reset_counter := true.B
            } .otherwise {
                reset_counter := false.B
            }
            io.update_adders := false.B
        }
    }


}

class HasSoftMax() extends HasDataPathExtension {
    implicit val extensionParam:          DataPathExtensionParam =
        new DataPathExtensionParam(
        moduleName = "SoftMax",
        userCsrNum = 6,
        dataWidth  = 512
        )
    def instantiate(clusterName: String): SoftMax              =
        Module(
        new SoftMax {
            override def desiredName = clusterName + namePostfix
        }
        )
}

class SoftMax()(implicit extensionParam: DataPathExtensionParam)
    extends DataPathExtension {

    val elementWidth = 32
    val ln2_scaled = ext_csr_i(0).asUInt
    val A_scaled = ext_csr_i(1).asUInt
    val B_scaled = ext_csr_i(2).asUInt
    val C_scaled = ext_csr_i(3).asUInt
    val scaling_shift = ext_csr_i(4).asUInt
    dontTouch(ln2_scaled)
    dontTouch(A_scaled)
    dontTouch(B_scaled)
    dontTouch(C_scaled)
    dontTouch(scaling_shift)

    // Control signals
    val update_max = Wire(Bool())
    val start_divider = Wire(Bool())
    val divider_finder_valid = Wire(Vec(16, Bool()))
    val update_adders = Wire(Bool())

    val ctrl = Module(new SoftMaxCtrl())
    ctrl.io.start := ext_start_i
    ctrl.io.valid_in := ext_data_i.valid
    ext_data_i.ready := ctrl.io.ready_in
    ext_data_o.valid := ctrl.io.valid_out
    ctrl.io.ready_out := ext_data_o.ready
    ctrl.io.softmax_cycles := ext_csr_i(5).asUInt
    update_max := ctrl.io.update_max
    start_divider := ctrl.io.start_divider
    ctrl.io.divider_valid := divider_finder_valid(0)
    ext_busy_o := ctrl.io.busy
    update_adders := ctrl.io.update_adders

    // Stage 1: Find the maximum value in the input vector
    val input_vector = Wire(Vec(16, SInt(elementWidth.W)))
    input_vector := ext_data_i.bits.asTypeOf(Vec(16, SInt(elementWidth.W)))

    val max_value = RegInit(VecInit(Seq.fill(16)(0x80000000.S(elementWidth.W))))
    for (i <- 0 until 16) {
        when(update_max && ext_data_i.valid) {
            when(input_vector(i) > max_value(i)) {
                max_value(i) := input_vector(i)
            }
        }
    }


    // Stage 2: subtract the maximum value from each element and compute exponentials
    // Stage 2a: Subtract the maximum value from each element
    val subtracted_value = Wire(Vec(16, SInt(elementWidth.W)))
    for (i <- 0 until 16) {
        subtracted_value(i) := input_vector(i) - max_value(i) //TODO: make these resettable
    }

    //Stage 2b: Find the value z to limit the input range to ln(2)
    val z = Wire(Vec(16, UInt(4.W)))
    val z_0 = Wire(Vec(16, UInt(1.W)))
    val z_1 = Wire(Vec(16, UInt(1.W)))
    val z_2 = Wire(Vec(16, UInt(1.W)))
    val z_3 = Wire(Vec(16, UInt(1.W)))
    for (i <- 0 until 16) {
        z(i) := Cat(z_3(i), z_2(i), z_1(i), z_0(i))
    }
    val is_big_enough = Wire(Vec(16, Bool()))

    val limited_to_ln2_value_8 = Wire(Vec(16, SInt(elementWidth.W)))
    for (i <- 0 until 16) {
        val added_val = Wire(SInt(elementWidth.W))
        added_val := subtracted_value(i) + (ln2_scaled.asSInt << 3) // Scale by 8
        limited_to_ln2_value_8(i) := Mux(added_val < 0.S, added_val, subtracted_value(i)) // If added_val is negative, use subtracted_value
        z_3(i) := added_val < 0.S // Set the highest bit if the value is >= 0
    }

    val limited_to_ln2_value_4 = Wire(Vec(16, SInt(elementWidth.W)))
    for (i <- 0 until 16) {
        val added_val = Wire(SInt(elementWidth.W))
        added_val := limited_to_ln2_value_8(i) + (ln2_scaled.asSInt << 2) // Scale by 4
        limited_to_ln2_value_4(i) := Mux(added_val < 0.S, added_val, limited_to_ln2_value_8(i))
        z_2(i) := added_val < 0.S // Set the second highest bit if the value is >= 0
    }

    val limited_to_ln2_value_2 = Wire(Vec(16, SInt(elementWidth.W)))
    for (i <- 0 until 16) {
        val added_val = Wire(SInt(elementWidth.W))
        added_val := limited_to_ln2_value_4(i) + (ln2_scaled.asSInt << 1) // Scale by 2
        limited_to_ln2_value_2(i) := Mux(added_val < 0.S,added_val, limited_to_ln2_value_4(i))
        z_1(i) := added_val < 0.S // Set the second lowest bit if the value is >= 0
    }

    val limited_to_ln2_value = Wire(Vec(16, SInt(elementWidth.W)))
    for (i <- 0 until 16) {
        val added_val = Wire(SInt(elementWidth.W))
        added_val := limited_to_ln2_value_2(i) + ln2_scaled.asSInt // Scale by 1
        limited_to_ln2_value(i) := Mux(added_val < 0.S, added_val, limited_to_ln2_value_2(i))
        z_0(i) := added_val < 0.S // Set the lowest bit if the value is >= 0
        is_big_enough(i) := (added_val >= -(ln2_scaled.asSInt))
    }

    // Stage 2c: Compute exponentials with polynomial approximation (a * (x + b)^2 + c)
    val poly_after_b = Wire(Vec(16, UInt(elementWidth.W)))
    for (i <- 0 until 16) {
        poly_after_b(i) := (limited_to_ln2_value(i) + B_scaled.asSInt).asUInt
    }

    val poly_reg_1 = RegInit(VecInit(Seq.fill(16)(0.U(elementWidth.W))))
    val pipeline_z_1 = RegInit(VecInit(Seq.fill(16)(0.U(4.W))))

    when(ext_data_i.valid) { //TODO: make control logic for when register updates
        poly_reg_1 := poly_after_b
        pipeline_z_1 := z
    }
    when(ext_data_i.valid) { //TODO: make control logic for when register updates
        poly_reg_1 := poly_after_b
    }

    val poly_after_square = Wire(Vec(16, UInt((2*elementWidth).W)))
    for (i <- 0 until 16) {
        poly_after_square(i) := (poly_reg_1(i) * poly_reg_1(i)).asUInt
    }

    val poly_reg_2 = RegInit(VecInit(Seq.fill(16)(0.U((2*elementWidth).W))))
    val pipeline_z_2 = RegInit(VecInit(Seq.fill(16)(0.U(4.W))))


    when(ext_data_i.valid) { //TODO: make control logic for when register updates
        poly_reg_2 := poly_after_square
        pipeline_z_2 := z
    }

    val poly_after_a = Wire(Vec(16, UInt((3*elementWidth).W)))
    for (i <- 0 until 16) {
        poly_after_a(i) := (poly_reg_2(i) * A_scaled.asUInt).asUInt
    }

    val poly_reg_3 = RegInit(VecInit(Seq.fill(16)(0.U((3*elementWidth).W))))
    val pipeline_z_3 = RegInit(VecInit(Seq.fill(16)(0.U(4.W))))

    when(ext_data_i.valid) { //TODO: make control logic for when register updates
        poly_reg_3 := poly_after_a
        pipeline_z_3 := z
    }

    val poly_after_static_shift = Wire(Vec(16, UInt((elementWidth).W)))
    for (i <- 0 until 16) {
        poly_after_static_shift(i) := (poly_reg_3(i) >> scaling_shift).asUInt
    }

    val poly_after_c = Wire(Vec(16, UInt(elementWidth.W)))
    for (i <- 0 until 16) {
        poly_after_c(i) := poly_after_static_shift(i) + C_scaled.asUInt
    }

    val poly_after_dynamic_shift = Wire(Vec(16, UInt(elementWidth.W)))
    for (i <- 0 until 16) {
        poly_after_dynamic_shift(i) := (poly_after_c(i) >> pipeline_z_3(i)).asUInt
    }

    val exp_out = Wire(Vec(16, UInt(elementWidth.W)))
    for (i <- 0 until 16) {
        exp_out(i) := Mux(is_big_enough(i), poly_after_dynamic_shift(i), 0.U)
    }

    // Stage 3: Sum the exponentials and find divider for multiplier

    val total_exp_sum = RegInit(VecInit(Seq.fill(16)(0.U(elementWidth.W))))

    when(ext_data_i.valid) { //TODO: make control logic for when register updates
        when(update_adders) {
            for (i <- 0 until 16) {
                total_exp_sum(i) := total_exp_sum(i) + exp_out(i) //TODO: make these resettable
            }
        }
    }

    val divider_finder_output = Wire(Vec(16, UInt(elementWidth.W)))
    val divider_finder_ready = Wire(Vec(16, Bool()))
    for (i <- 0 until 16) {
        val divider_finder = Module(new DivisionFinder())
        divider_finder.io.input := total_exp_sum(i)
        divider_finder.io.valid_in := start_divider
        divider_finder.io.ready_in := true.B
        divider_finder_output(i) := divider_finder.io.output
        divider_finder_ready(i) := divider_finder.io.ready_out
        divider_finder_valid(i) := divider_finder.io.valid_out
    }

    // Stage 4: Compute final output by multiplying each exp_out by divider
    val output_vector_final = Wire(Vec(16, UInt(elementWidth.W)))
    for (i <- 0 until 16) {
        output_vector_final(i) := (exp_out(i) * divider_finder_output(i)).asUInt
    }


    ext_data_o.bits := Cat(output_vector_final.reverse)

}
