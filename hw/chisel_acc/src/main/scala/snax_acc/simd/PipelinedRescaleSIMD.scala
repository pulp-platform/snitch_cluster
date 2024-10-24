package snax_acc.simd

import chisel3._
import chisel3.util._
import chisel3.VecInit
import snax_acc.utils.DecoupledCut._

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

  val delayed_three_cycle_input_data = Wire(
    Decoupled(UInt((params.laneLen * params.inputType).W))
  )
  current_input_data -\\\> delayed_three_cycle_input_data

  // give each RescalePE right control signal and data
  // collect the result of each RescalePE
  for (i <- 0 until params.laneLen) {
    lane(i).io.input_i.bits := delayed_three_cycle_input_data
      .bits(
        (i + 1) * params.inputType - 1,
        i * params.inputType
      )
      .asSInt
    lane(i).io.input_i.valid := delayed_three_cycle_input_data.valid
    // fake ready, always ready inside the pipeline
    lane(
      i
    ).io.output_o.ready := !keep_output && !output_stall && cstate === sBUSY
  }

  delayed_three_cycle_input_data.ready := lane
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
