package snax_acc.gemm

import chisel3._
import chisel3.util._

import snax_acc.utils.DecoupledCut._
import snax_acc.utils._

/** The BlockGemm's control port declaration. */
class BlockGemmCtrlIO(val params: GemmParams) extends Bundle with HasGemmParams {
  val K_i                    = (UInt(sizeConfigWidth.W))
  val N_i                    = (UInt(sizeConfigWidth.W))
  val M_i                    = (UInt(sizeConfigWidth.W))
  val subtraction_constant_i = (UInt(subtractionCfgWidth.W))
}

/** The BlockGemm's data port declaration. Decoupled interface connected to the streamer */
class BlockGemmDataIO(val params: GemmParams) extends Bundle with HasGemmParams {
  val a_i = Flipped(DecoupledIO(UInt((meshRow * tileSize * dataWidthA).W)))
  val b_i = Flipped(DecoupledIO(UInt((tileSize * meshCol * dataWidthB).W)))
  val c_i = Flipped(DecoupledIO(UInt((meshRow * meshCol * dataWidthC).W)))
  val d_o = DecoupledIO(UInt((meshRow * meshCol * dataWidthC).W))
}

/** BlockGemmIO declaration, including control and data as well as two extra output signal */
class BlockGemmIO(params: GemmParams) extends Bundle {
  val ctrl                = Flipped(DecoupledIO(new BlockGemmCtrlIO(params)))
  val data                = new BlockGemmDataIO(params)
  val busy_o              = Output(Bool())
  val performance_counter = Output(UInt(32.W))
}

/** BlockGemm module */
class BlockGemm(val params: GemmParams) extends Module with RequireAsyncReset with HasGemmParams {

  val io         = IO(new BlockGemmIO(params))
  val gemm_array = Module(new GemmArray(params))

  // Registers to store the configurations
  val M = RegInit(0.U(sizeConfigWidth.W))
  val K = RegInit(0.U(sizeConfigWidth.W))
  val N = RegInit(0.U(sizeConfigWidth.W))

  val subtraction_a = RegInit(0.U(dataWidthA.W))
  val subtraction_b = RegInit(0.U(dataWidthB.W))

  // useful counters
  val compute_fire_counter     = RegInit(0.U((sizeConfigWidth).W))
  // counter used to record if need to output to outside (K times array output valid, 1 time output)
  val d_output_ifvalid_counter = RegInit(0.U(sizeConfigWidth.W))
  // counter to record how many output data has been written (M * N times)
  val d_output_counter         = RegInit(0.U((2 * sizeConfigWidth).W))

  val performance_counter = RegInit(0.U(32.W))

  // gemm array data control signals
  val a_b_data_valid = WireInit(0.B)
  val a_b_data_ready = WireInit(0.B)

  val gemm_a_b_input_fire = WireInit(0.B)

  // add c control signal genertaion
  val add_c      = WireInit(0.B)
  val add_c_fire = WireInit(0.B)

  val compute_fire = WireInit(0.B)

  val gemm_output_fire = WireInit(0.B)

  // -----------------------------------
  // state machine start
  // -----------------------------------

  // State declaration
  val sIDLE :: sBUSY :: Nil = Enum(2)
  val cstate                = RegInit(sIDLE)
  val nstate                = WireInit(sIDLE)

  // signals for state transition
  val config_valid       = WireInit(0.B)
  val computation_finish = WireInit(0.B)

  val zeroLoopBoundCase = WireInit(0.B)
  zeroLoopBoundCase := io.ctrl.bits.M_i === 0.U || io.ctrl.bits.K_i === 0.U || io.ctrl.bits.K_i === 0.U

  // Changing states
  cstate := nstate

  chisel3.dontTouch(cstate)
  switch(cstate) {
    is(sIDLE) {
      when(config_valid && !zeroLoopBoundCase) {
        nstate := sBUSY
      }.otherwise {
        nstate := sIDLE
      }

    }
    is(sBUSY) {
      when(computation_finish) {
        nstate := sIDLE
      }.otherwise {
        nstate := sBUSY
      }
    }
  }

  config_valid := io.ctrl.fire

  // Store the configurations when config valid
  when(config_valid && cstate === sIDLE) {
    when(!zeroLoopBoundCase) {
      M := io.ctrl.bits.M_i
      N := io.ctrl.bits.N_i
      K := io.ctrl.bits.K_i
    }.otherwise {
      assert(
        io.ctrl.bits.M_i =/= 0.U || io.ctrl.bits.K_i =/= 0.U || io.ctrl.bits.K_i =/= 0.U,
        " M==0 or K==0 or N==0, invalid configuration!"
      )
    }

    require(subtractionCfgWidth == 16, "TODO slicing is hardcoded yet the width is a parameter") // TODO
    subtraction_a := io.ctrl.bits.subtraction_constant_i(7, 0)
    subtraction_b := io.ctrl.bits.subtraction_constant_i(15, 8)
  }

  // write counter increment according to output data fire
  when(io.data.d_o.fire) {
    d_output_counter := d_output_counter + 1.U
  }.elsewhen(cstate === sIDLE) {
    d_output_counter := 0.U
  }

  // write all the results out means the operation is done
  computation_finish := d_output_counter === (M * N - 1.U) && io.data.d_o.fire && cstate === sBUSY

  // -----------------------------------
  // state machine end
  // -----------------------------------

  // -----------------------------------
  // register insert start
  // -----------------------------------

  val combined_decoupled_a_b_in  = Wire(Decoupled(new CutBundle(a_bits_len, b_bits_len, sa_bits_len, sb_bits_len)))
  val combined_decoupled_a_b_out = Wire(Decoupled(new CutBundle(a_bits_len, b_bits_len, sa_bits_len, sb_bits_len)))
  val a_split_out                = Wire(UInt(a_bits_len.W))
  val b_split_out                = Wire(UInt(b_bits_len.W))
  val subtraction_a_split_out    = Wire(UInt(sa_bits_len.W))
  val subtraction_b_split_out    = Wire(UInt(sb_bits_len.W))

  val decoupled_subtraction_a = Wire(Decoupled(UInt(sa_bits_len.W)))
  val decoupled_subtraction_b = Wire(Decoupled(UInt(sb_bits_len.W)))

  val a_b_sa_sb_cat = Module(new DecoupledCat4to1(a_bits_len, b_bits_len, sa_bits_len, sb_bits_len))

  // cat several decoupled signals into one for synchronization
  a_b_sa_sb_cat.io.in1 <> io.data.a_i
  a_b_sa_sb_cat.io.in2 <> io.data.b_i
  a_b_sa_sb_cat.io.in3 <> decoupled_subtraction_a
  a_b_sa_sb_cat.io.in4 <> decoupled_subtraction_b
  a_b_sa_sb_cat.io.out <> combined_decoupled_a_b_in

  // insert registers
  combined_decoupled_a_b_in -\\> combined_decoupled_a_b_out
  a_split_out             := combined_decoupled_a_b_out.bits.a
  b_split_out             := combined_decoupled_a_b_out.bits.b
  subtraction_a_split_out := combined_decoupled_a_b_out.bits.c
  subtraction_b_split_out := combined_decoupled_a_b_out.bits.d
  // combined_decoupled_a_b_out will be connected to further control signals

  decoupled_subtraction_a.valid := cstate === sBUSY
  decoupled_subtraction_a.bits  := subtraction_a
  decoupled_subtraction_b.valid := cstate === sBUSY
  decoupled_subtraction_b.bits  := subtraction_b

  // -----------------------------------
  // register insert end
  // -----------------------------------

  // -----------------------------------
  // data a b c control signal generation start
  // -----------------------------------

  // input data valid signal
  // at the first compute cycle, when a, b, and c are valid, the input data is valid
  // at the following compute cycles, when a and b are valid, the input data is valid
  when(compute_fire_counter === 0.B) {
    a_b_data_valid := combined_decoupled_a_b_out.valid && io.data.c_i.valid && cstate === sBUSY
  }.otherwise {
    a_b_data_valid := combined_decoupled_a_b_out.valid && cstate === sBUSY
  }
  a_b_data_ready := gemm_array.io.ctrl.a_b_c_ready_o && cstate === sBUSY

  // gemm input fire signal
  gemm_a_b_input_fire := a_b_data_ready && a_b_data_valid

  // counter increment according to input data fire
  compute_fire := gemm_a_b_input_fire
  when(K === 1.U) {
    compute_fire_counter := 0.U
  }.otherwise {
    when(compute_fire && compute_fire_counter =/= (K - 1.U) && cstate =/= sIDLE) {
      compute_fire_counter := compute_fire_counter + 1.U
    }.elsewhen(compute_fire && compute_fire_counter === (K - 1.U) && cstate =/= sIDLE) {
      compute_fire_counter := 0.U
    }.elsewhen(cstate === sIDLE) {
      compute_fire_counter := 0.U
    }
  }

  // add c at the first compute cycle when a, b and c are all valid (first dotprod and add c at the same cycle)
  add_c      := (compute_fire_counter === 0.U) && cstate === sBUSY && io.data.c_i.valid && a_b_data_valid
  add_c_fire := add_c                          && gemm_array.io.ctrl.a_b_c_ready_o

  // -----------------------------------
  // data a b c control signal generation end
  // -----------------------------------

  // gemm output fire signal, asserted when gemm is fire for outputting the result
  gemm_output_fire := gemm_array.io.ctrl.d_valid_o && gemm_array.io.ctrl.d_ready_i

  // counter increment according to gemm array output data fire
  when(K === 1.U) {
    d_output_ifvalid_counter := 0.U
  }.otherwise {
    when(gemm_output_fire && d_output_ifvalid_counter =/= (K - 1.U) && cstate =/= sIDLE) {
      d_output_ifvalid_counter := d_output_ifvalid_counter + 1.U
    }.elsewhen(gemm_output_fire && d_output_ifvalid_counter === (K - 1.U) && cstate =/= sIDLE) {
      d_output_ifvalid_counter := 0.U
    }.elsewhen(cstate === sIDLE) {
      d_output_ifvalid_counter := 0.U
    }
  }

  io.ctrl.ready := cstate === sIDLE

  // Gemm Array signal connection
  // control signals
  gemm_array.io.ctrl.dotprod_a_b := a_b_data_valid
  gemm_array.io.ctrl.add_c_i     := add_c

  // grab gemm output when the d fifo is ready for new data, or when don't need to output d
  gemm_array.io.ctrl.d_ready_i := Mux(io.data.d_o.valid, io.data.d_o.ready, 1.B)

  gemm_array.io.ctrl.subtraction_a_i := subtraction_a_split_out
  gemm_array.io.ctrl.subtraction_b_i := subtraction_b_split_out

  // data signals
  gemm_array.io.data.a_i := a_split_out
  gemm_array.io.data.b_i := b_split_out
  gemm_array.io.data.c_i := io.data.c_i.bits

  combined_decoupled_a_b_out.ready := cstate === sBUSY && gemm_a_b_input_fire

  io.data.c_i.ready := cstate === sBUSY && add_c_fire

  // gemm output signals
  io.data.d_o.bits := gemm_array.io.data.d_o
  // after K times computation, the output is valid
  when(K === 1.U) {
    io.data.d_o.valid := gemm_array.io.ctrl.d_valid_o && cstate =/= sIDLE
  }.otherwise {
    io.data.d_o.valid := (d_output_ifvalid_counter === (K - 1.U)) && gemm_array.io.ctrl.d_valid_o && cstate =/= sIDLE
  }

  when(cstate === sBUSY) {
    performance_counter := performance_counter + 1.U
  }.elsewhen(config_valid) {
    performance_counter := 0.U
  }

  // output control signals for read-only csrs
  io.performance_counter := performance_counter

  io.busy_o := cstate =/= sIDLE

}

// Scala main function for generating system verilog file for the BlockGemm module
object BlockGemm extends App {
  emitVerilog(
    new BlockGemm(DefaultConfig.gemmConfig),
    Array("--target-dir", "generated/gemm")
  )
}
