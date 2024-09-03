package snax_acc.gemm

import chisel3._
import chisel3.util._

// The BlockGemm's control port declaration.
class BlockGemmCtrlIO(params: GemmParams) extends Bundle {

  val K_i = (UInt(params.sizeConfigWidth.W))
  val N_i = (UInt(params.sizeConfigWidth.W))
  val M_i = (UInt(params.sizeConfigWidth.W))
  val subtraction_constant_i = (UInt(params.subtractionCfgWidth.W))

}

// The BlockGemm's data port declaration. Decoupled interface connected to the streamer
class BlockGemmDataIO(params: GemmParams) extends Bundle {
  val a_i = Flipped(
    DecoupledIO(
      UInt(
        (params.meshRow * params.tileSize * params.dataWidthA).W
      )
    )
  )
  val b_i = Flipped(
    DecoupledIO(
      UInt(
        (params.tileSize * params.meshCol * params.dataWidthB).W
      )
    )
  )
  val c_i = Flipped(
    DecoupledIO(
      UInt(
        (params.meshRow * params.meshCol * params.dataWidthC).W
      )
    )
  )
  val d_o = DecoupledIO(
    UInt(
      (params.meshRow * params.meshCol * params.dataWidthC).W
    )
  )
}

// BlockGemmIO declaration, including control and data as well as two extra output signal
class BlockGemmIO(params: GemmParams) extends Bundle {

  val ctrl = Flipped(DecoupledIO(new BlockGemmCtrlIO(params)))
  val data = new BlockGemmDataIO(params)
  val busy_o = Output(Bool())
  val performance_counter = Output(UInt(32.W))

}

// BlockGemm module
class BlockGemm(params: GemmParams) extends Module with RequireAsyncReset {

  val io = IO(new BlockGemmIO(params))

  val gemm_array = Module(new GemmArray(params))

  // Registers to store the configurations
  val M = RegInit(0.U(params.sizeConfigWidth.W))
  val K = RegInit(0.U(params.sizeConfigWidth.W))
  val N = RegInit(0.U(params.sizeConfigWidth.W))

  val subtraction_a = RegInit(0.U(params.dataWidthA.W))
  val subtraction_b = RegInit(0.U(params.dataWidthB.W))

  // useful counters
  val compute_fire_counter = RegInit(0.U((3 * params.sizeConfigWidth).W))
  // counter used to record if need to output to outside
  val d_output_ifvalid_counter = RegInit(0.U(params.sizeConfigWidth.W))
  // counter to record how many output data has been written
  val d_output_counter = RegInit(0.U((3 * params.sizeConfigWidth).W))

  val performance_counter = RegInit(0.U(32.W))

  // control signals for the counter incremental
  val accumulation = WireInit(0.B)
  val a_b_data_valid = WireInit(0.B)

  val gemm_a_b_input_fire = WireInit(0.B)
  val gemm_output_fire = WireInit(0.B)

  // add c control signal genertaion
  // in the middle of the K accumulation
  val needs_add_c = RegInit(1.B)
  // after the K accumulation, waiting for add C matrix
  val must_add_c = WireInit(0.B)
  // wire for the addition control signal
  val add_c = WireInit(0.B)
  val add_c_fire = WireInit(0.B)

  val compute_fire = WireInit(0.B)

  // State declaration
  val sIDLE :: sBUSY :: Nil = Enum(2)
  val cstate = RegInit(sIDLE)
  val nstate = WireInit(sIDLE)

  // signals for state transition
  val config_valid = WireInit(0.B)
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
        " M == 0 or K ==0 or N == 0, invalid configuration!"
      )
    }
    subtraction_a := io.ctrl.bits.subtraction_constant_i(7, 0)
    subtraction_b := io.ctrl.bits.subtraction_constant_i(15, 8)
  }

  // write all the results out means the operation is done
  computation_finish := d_output_counter === (M * N - 1.U) && io.data.d_o.fire && cstate === sBUSY

  // write counter increment according to output data fire
  when(io.data.d_o.fire) {
    d_output_counter := d_output_counter + 1.U
  }.elsewhen(cstate === sIDLE) {
    d_output_counter := 0.U
  }

  // input data valid signal, when both a and b are valid, the input data is valid
  a_b_data_valid := io.data.a_i.valid && io.data.b_i.valid && cstate === sBUSY
  // gemm input fire signal, when both a and b are valid and gemm is ready for new input data
  // stall the a b compute if add c
  gemm_a_b_input_fire := gemm_array.io.ctrl.a_b_c_ready_o && a_b_data_valid && !add_c && !must_add_c

  // accumulation counter for generating the accumulation signal for Gemm Array
  // value change according to gemm_a_b_input_fire and add_c_fire
  // (K + 1) computation for 1 reset compute_fire_counter
  compute_fire := gemm_a_b_input_fire || add_c_fire
  when(
    compute_fire && compute_fire_counter =/= K && cstate =/= sIDLE
  ) {
    compute_fire_counter := compute_fire_counter + 1.U
  }.elsewhen(
    compute_fire && compute_fire_counter === K && cstate =/= sIDLE
  ) {
    compute_fire_counter := 0.U
  }.elsewhen(cstate === sIDLE) {
    compute_fire_counter := 0.U
  }

  // accumulation control signal
  // only clean the accumulation register once
  accumulation := compute_fire_counter =/= 0.U

  when(cstate === sBUSY) {
    performance_counter := performance_counter + 1.U
  }.elsewhen(config_valid) {
    performance_counter := 0.U
  }

  // gemm output fire signal, asserted when gemm is fire for outputting the result
  gemm_output_fire := gemm_array.io.ctrl.d_valid_o && gemm_array.io.ctrl.d_ready_i

  // with add C support, now needs K + 1 times acclumation for 1 write
  // (K + 1) computation for 1 reset d_output_ifvalid_counter
  when(
    gemm_output_fire && d_output_ifvalid_counter =/= K && cstate =/= sIDLE
  ) {
    d_output_ifvalid_counter := d_output_ifvalid_counter + 1.U
  }.elsewhen(
    gemm_output_fire && d_output_ifvalid_counter === K && cstate =/= sIDLE
  ) {
    d_output_ifvalid_counter := 0.U
  }.elsewhen(cstate === sIDLE) {
    d_output_ifvalid_counter := 0.U
  }

  // add c control signal generation
  when(add_c_fire) {
    needs_add_c := 0.B
  }.elsewhen(
    // shift needs_add_c to 1 after d valid. it's safe to shift after one cycle as K == 1 at minimum.
    io.data.d_o.valid
  ) {
    needs_add_c := 1.B
  }

  // after K a b dotprod, must need to add c before continue
  // related to input situation
  must_add_c := needs_add_c && (compute_fire_counter === K)

  add_c := cstate === sBUSY && ((needs_add_c && !a_b_data_valid) || must_add_c) && io.data.c_i.valid
  add_c_fire := add_c && gemm_array.io.ctrl.a_b_c_ready_o

  // output control signals for read-only csrs
  io.performance_counter := performance_counter

  io.busy_o := cstate =/= sIDLE

  io.ctrl.ready := cstate === sIDLE

  // Gemm Array signal connection
  // control signals
  gemm_array.io.ctrl.dotprod_a_b := a_b_data_valid && !add_c && !must_add_c
  gemm_array.io.ctrl.add_c_i := add_c
  gemm_array.io.ctrl.accumulate_i := accumulation
  // grap gemm output out
  // when the d fifo is ready for new data
  // or when don't need to output d
  gemm_array.io.ctrl.d_ready_i := Mux(io.data.d_o.valid, io.data.d_o.ready, 1.B)

  gemm_array.io.ctrl.subtraction_a_i := subtraction_a
  gemm_array.io.ctrl.subtraction_b_i := subtraction_b

  // data signals
  gemm_array.io.data.a_i := io.data.a_i.bits
  gemm_array.io.data.b_i := io.data.b_i.bits
  gemm_array.io.data.c_i := io.data.c_i.bits

  // ready for pop out the data from outside
  io.data.a_i.ready := cstate === sBUSY && gemm_a_b_input_fire
  io.data.b_i.ready := cstate === sBUSY && gemm_a_b_input_fire
  io.data.c_i.ready := cstate === sBUSY && add_c_fire

  // gemm output signals
  io.data.d_o.bits := gemm_array.io.data.d_o
  // after K + 1 times accumulation, the output is valid
  io.data.d_o.valid := (d_output_ifvalid_counter === K) && gemm_array.io.ctrl.d_valid_o && cstate =/= sIDLE

}

// Scala main function for generating system verilog file for the BlockGemm module
object BlockGemm extends App {
  emitVerilog(
    new BlockGemm(DefaultConfig.gemmConfig),
    Array("--target-dir", "generated/gemm")
  )
}
