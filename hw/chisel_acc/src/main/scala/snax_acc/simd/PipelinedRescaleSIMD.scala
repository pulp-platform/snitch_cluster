package snax_acc.simd

import chisel3._
import chisel3.util._
import chisel3.VecInit
import snax_acc.utils.DecoupledCut._
import snax_acc.utils.DecoupledCat2to1

// Define the Combined Output Bundle with multiple RescalePECtrl
class SIMDCombinedCutBundle(aWidth: Int, params: RescaleSIMDParams, n: Int)
    extends Bundle {
  val input_data = UInt(aWidth.W)
  val ctrl_data =
    Vec(n, new RescalePECtrl(params)) // Vector of RescalePECtrl Bundles
}

// Rescale SIMD module
// This module implements this spec: specification: https://gist.github.com/jorendumoulin/83352a1e84501ec4a7b3790461fee2bf in parallel
class PipelinedRescaleSIMD(params: RescaleSIMDParams)
    extends RescaleSIMD(params) {

  val lane_comp_cycle = params.dataLen / params.laneLen

  val keep_output = RegInit(0.B)
  val output_stall = WireInit(0.B)

  // store the input data for params.laneLen - 1 lane
  val input_data_reg = RegInit(
    0.U(((params.dataLen - params.laneLen) * params.inputType).W)
  )
  val current_input_data = Wire(
    Decoupled(UInt((params.laneLen * params.inputType).W))
  )

  // lane computation process counter
  val lane_input_valid = WireInit(0.B)
  val pipe_input_counter = RegInit(0.U(32.W))

  io.data.input_i.ready := cstate === sBUSY && pipe_input_counter === 0.U
  when(io.data.input_i.fire) {
    input_data_reg := io.data.input_i.bits(
      params.dataLen * params.inputType - 1,
      params.laneLen * params.inputType
    )
  }.elsewhen(current_input_data.fire) {
    input_data_reg := input_data_reg >> (params.inputType.U * params.laneLen.U)
  }

  current_input_data.bits := Mux(
    io.data.input_i.fire,
    io.data.input_i.bits(params.laneLen * params.inputType - 1, 0),
    input_data_reg(params.laneLen * params.inputType - 1, 0)
  )

  lane_input_valid := io.data.input_i.fire || pipe_input_counter =/= 0.U
  when(
    current_input_data.fire && pipe_input_counter =/= lane_comp_cycle.U - 1.U
  ) {
    pipe_input_counter := pipe_input_counter + 1.U
  }.elsewhen(
    current_input_data.fire && pipe_input_counter === lane_comp_cycle.U - 1.U
  ) {
    pipe_input_counter := 0.U
  }

  current_input_data.valid := lane_input_valid

  // delay the input data for 3 cycles
  val cat_cur_input_ctrl = Module(
    new DecoupledCat2to1(
      params.laneLen * params.inputType,
      params,
      ctrl_csr_set_num
    )
  )
  cat_cur_input_ctrl.io.in1 <> current_input_data
  cat_cur_input_ctrl.io.in2.bits := ctrl_csr
  cat_cur_input_ctrl.io.in2.valid := cstate === sBUSY
  val cat_cur_input_ctrl_out = cat_cur_input_ctrl.io.out

  val delayed_three_cycle_cur_input_ctrl = Wire(
    Decoupled(
      new SIMDCombinedCutBundle(
        params.laneLen * params.inputType,
        params,
        ctrl_csr_set_num
      )
    )
  )
  cat_cur_input_ctrl_out -\\\> delayed_three_cycle_cur_input_ctrl

  // give each RescalePE right control signal and data
  // collect the result of each RescalePE
  for (i <- 0 until params.laneLen) {
    lane(i).io.input_i.bits := delayed_three_cycle_cur_input_ctrl.bits
      .input_data(
        (i + 1) * params.inputType - 1,
        i * params.inputType
      )
      .asSInt
    lane(i).io.input_i.valid := delayed_three_cycle_cur_input_ctrl.valid
    lane(
      i
    ).io.output_o.ready := !keep_output && !output_stall && cstate === sBUSY
    lane(i).io.ctrl_i := delayed_three_cycle_cur_input_ctrl.bits.ctrl_data(
      i % ctrl_csr_set_num
    )
  }

  delayed_three_cycle_cur_input_ctrl.ready := lane
    .map(_.io.input_i.ready)
    .reduce(_ && _) && (cstate === sBUSY)

  // lane output valid process counter
  val pipe_out_counter = RegInit(0.U(16.W))
  val lane_output_valid = lane.map(_.io.output_o.valid).reduce(_ && _)
  when(
    lane_output_valid && pipe_out_counter =/= lane_comp_cycle.U - 1.U
  ) {
    pipe_out_counter := pipe_out_counter + 1.U
  }.elsewhen(
    lane_output_valid && pipe_out_counter === lane_comp_cycle.U - 1.U
  ) {
    pipe_out_counter := 0.U
  }

  // collect the valid output data
  val output_data_reg = RegInit(0.U((params.dataLen * params.outputType).W))
  when(lane_output_valid) {
    output_data_reg := Cat(
      Cat(result.reverse),
      output_data_reg(
        params.dataLen * params.outputType - 1,
        params.laneLen * params.outputType
      )
    )
  }

  output_stall := io.data.output_o.valid & !io.data.output_o.ready
  keep_output := output_stall

  // concat every result to a big data bus for output
  // if is keep sending output, send the stored result
  when(lane_output_valid && pipe_out_counter === lane_comp_cycle.U - 1.U) {
    io.data.output_o.bits := Cat(
      Cat(result.reverse),
      output_data_reg(
        params.dataLen * params.outputType - 1,
        params.laneLen * params.outputType
      )
    )
  }.otherwise {
    io.data.output_o.bits := output_data_reg
  }

  // first valid from RescalePE or keep sending valid if receiver side is not ready
  io.data.output_o.valid := (lane_output_valid && pipe_out_counter === lane_comp_cycle.U - 1.U) || keep_output

}

// Scala main function for generating system verilog file for the Rescale SIMD module
object PipelinedRescaleSIMD extends App {
  emitVerilog(
    new PipelinedRescaleSIMD(PipelinedConfig.rescaleSIMDConfig),
    Array("--target-dir", "generated/simd")
  )
}
