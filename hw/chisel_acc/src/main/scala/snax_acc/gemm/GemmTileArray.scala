package snax_acc.gemm
import chisel3._
import chisel3.util._

class GemmArrayCtrlIO(params: GemmParams) extends Bundle {
  val dotprod_a_b   = Input(Bool())
  val add_c_i       = Input(Bool())
  val a_b_c_ready_o = Output(Bool())

  val d_valid_o = Output(Bool())
  val d_ready_i = Input(Bool())

  val subtraction_a_i = Input(UInt(params.dataWidthA.W))
  val subtraction_b_i = Input(UInt(params.dataWidthB.W))

}

/** Tile IO definition */
class TileIO(params: GemmParams) extends Bundle {
  val data_a_i = Input(Vec(params.tileSize, UInt(params.dataWidthA.W)))
  val data_b_i = Input(Vec(params.tileSize, UInt(params.dataWidthB.W)))
  val data_c_i = Input(UInt(params.dataWidthC.W))
  val data_d_o = Output(SInt(params.dataWidthC.W))

  val ctrl = new GemmArrayCtrlIO(params)

}

/** Tile implementation, do a vector dot product of two vector
  *
  * ! When dotprod_a_b and a_b_c_ready_o assert, do the computation, and give the result next cycle, with ! a d_valid_o
  * assert
  */
class Tile(params: GemmParams) extends Module with RequireAsyncReset {
  val io = IO(new TileIO(params))

  val accumulation_reg = RegInit(0.S(params.dataWidthAccum.W))

  val data_i_fire     = WireInit(0.B)
  val data_i_fire_reg = RegInit(0.B)

  val keep_output = RegInit(false.B)

  val data_a_i_subtracted = Wire(Vec(params.tileSize, SInt((params.dataWidthA + 1).W)))
  val data_b_i_subtracted = Wire(Vec(params.tileSize, SInt((params.dataWidthB + 1).W)))
  val mul_add_result_vec  = Wire(Vec(params.tileSize, SInt(params.dataWidthMul.W)))
  val mul_add_result      = Wire(SInt(params.dataWidthAccum.W))

  chisel3.dontTouch(mul_add_result)

  // when dotprod_a_b assert, and a_b_c_ready_o assert, do the computation
  data_i_fire     := io.ctrl.dotprod_a_b === 1.B && io.ctrl.a_b_c_ready_o === 1.B
  // give the result next cycle, with a d_valid_o assert
  data_i_fire_reg := data_i_fire

  val add_c_fire = WireInit(0.B)
  add_c_fire := io.ctrl.add_c_i === 1.B && io.ctrl.a_b_c_ready_o === 1.B

  // when out c not ready but having a valid result locally, keep sending d_valid_o
  keep_output := io.ctrl.d_valid_o && !io.ctrl.d_ready_i

  // Subtraction computation
  for (i <- 0 until params.tileSize) {
    data_a_i_subtracted(i) := (io.data_a_i(i).asSInt -& io.ctrl.subtraction_a_i.asSInt).asSInt
    data_b_i_subtracted(i) := (io.data_b_i(i).asSInt -& io.ctrl.subtraction_b_i.asSInt).asSInt
  }

  // Element-wise multiply
  for (i <- 0 until params.tileSize) {
    mul_add_result_vec(i) := (data_a_i_subtracted(i)) * (data_b_i_subtracted(i))
  }

  // Sum of element-wise multiply
  mul_add_result := mul_add_result_vec.reduce((a, b) => (a.asSInt + b.asSInt))

  // Accumulation
  // at the first compute cycle (add_c_fire === 1.B), do the dotprod and outside c addition computation
  // at the following compute cycle, do the dotprod and accumulation reg addition computation
  when(add_c_fire === 1.B && data_i_fire === 1.B) {
    accumulation_reg := io.data_c_i.asSInt + mul_add_result
  }.elsewhen(add_c_fire === 0.B && data_i_fire === 1.B) {
    accumulation_reg := accumulation_reg + mul_add_result
  }.otherwise {
    accumulation_reg := accumulation_reg
  }

  io.data_d_o           := accumulation_reg
  // output valid depends on the data_i_fire_reg and keep_output
  io.ctrl.d_valid_o     := data_i_fire_reg || keep_output
  io.ctrl.a_b_c_ready_o := !keep_output && !(io.ctrl.d_valid_o && !io.ctrl.d_ready_i)

}

/** Mesh IO definition, an extended version of Tile IO */
class MeshIO(params: GemmParams) extends Bundle {
  val data_a_i = Input(Vec(params.meshRow, Vec(params.tileSize, UInt(params.dataWidthA.W))))
  val data_b_i = Input(Vec(params.meshCol, Vec(params.tileSize, UInt(params.dataWidthB.W))))
  val data_c_i = Input(Vec(params.meshRow, Vec(params.meshCol, UInt(params.dataWidthC.W))))
  val data_d_o = Output((Vec(params.meshRow, Vec(params.meshCol, SInt(params.dataWidthC.W)))))

  val ctrl = new GemmArrayCtrlIO(params)

}

// Mesh implementation, just create a mesh of TIles and do the connection
class Mesh(params: GemmParams) extends Module with RequireAsyncReset {

  val io = IO(new MeshIO(params))

  chisel3.dontTouch(io)

  val mesh = Seq.fill(params.meshRow, params.meshCol)(Module(new Tile(params)))

  for (r <- 0 until params.meshRow) {
    for (c <- 0 until params.meshCol) {
      // data connect
      mesh(r)(c).io.data_a_i <> io.data_a_i(r)
      mesh(r)(c).io.data_b_i <> io.data_b_i(c)
      mesh(r)(c).io.data_c_i <> io.data_c_i(r)(c)
      io.data_d_o(r)(c) := mesh(r)(c).io.data_d_o

      // input control signal, broadcast to each PE
      mesh(r)(c).io.ctrl.dotprod_a_b <> io.ctrl.dotprod_a_b
      mesh(r)(c).io.ctrl.add_c_i <> io.ctrl.add_c_i

      mesh(r)(c).io.ctrl.d_ready_i <> io.ctrl.d_ready_i

      mesh(r)(c).io.ctrl.subtraction_a_i <> io.ctrl.subtraction_a_i
      mesh(r)(c).io.ctrl.subtraction_b_i <> io.ctrl.subtraction_b_i
    }
  }
  // output control signal, gather one signal for output,
  // all the PE should have the same output control signal
  io.ctrl.d_valid_o := mesh(0)(0).io.ctrl.d_valid_o
  io.ctrl.a_b_c_ready_o := mesh(0)(0).io.ctrl.a_b_c_ready_o
}

class GemmDataIO(params: GemmParams) extends Bundle {
  val a_i = Input(UInt((params.meshRow * params.tileSize * params.dataWidthA).W))
  val b_i = Input(UInt((params.tileSize * params.meshCol * params.dataWidthB).W))
  val c_i = Input(UInt((params.meshRow * params.meshCol * params.dataWidthC).W))
  val d_o = Output(UInt((params.meshRow * params.meshCol * params.dataWidthC).W))
}

/** Gemm IO definition */
class GemmArrayIO(params: GemmParams) extends Bundle {
  val ctrl = new GemmArrayCtrlIO(params)
  val data = new GemmDataIO(params)
}

/** Gemm implementation, create a Mesh and give out input data and collect results of each Tile. */
class GemmArray(val params: GemmParams) extends Module with RequireAsyncReset {

  val io   = IO(new GemmArrayIO(params))
  val mesh = Module(new Mesh(params))

  // define wires for data partition
  val a_i_wire     = Wire(Vec(params.meshRow, Vec(params.tileSize, UInt(params.dataWidthA.W))))
  val b_i_wire     = Wire(Vec(params.meshCol, Vec(params.tileSize, UInt(params.dataWidthB.W))))
  val c_i_wire     = Wire(Vec(params.meshRow, Vec(params.meshCol, UInt(params.dataWidthC.W))))
  val d_out_wire   = Wire(Vec(params.meshRow, Vec(params.meshCol, SInt(params.dataWidthC.W))))
  val d_out_wire_2 = Wire(Vec(params.meshRow, UInt((params.meshCol * params.dataWidthC).W)))

  // data partition
  for (r <- 0 until params.meshRow) {
    for (c <- 0 until params.tileSize) {
      a_i_wire(r)(c) := io.data.a_i(
        (r * params.tileSize + c + 1) * params.dataWidthA - 1,
        (r * params.tileSize + c) * params.dataWidthA
      )
    }
  }

  for (r <- 0 until params.meshCol) {
    for (c <- 0 until params.tileSize) {
      b_i_wire(r)(c) := io.data.b_i(
        (r * params.tileSize + c + 1) * params.dataWidthB - 1,
        (r * params.tileSize + c) * params.dataWidthB
      )
    }
  }

  for (r <- 0 until params.meshRow) {
    for (c <- 0 until params.meshCol) {
      c_i_wire(r)(c) := io.data.c_i(
        (r * params.meshCol + c + 1) * params.dataWidthC - 1,
        (r * params.meshCol + c) * params.dataWidthC
      )
    }
  }

  for (r <- 0 until params.meshRow) {
    for (c <- 0 until params.meshCol) {
      d_out_wire(r)(c) := mesh.io.data_d_o(r)(c)
    }
    d_out_wire_2(r) := Cat(d_out_wire(r).reverse)
  }

  // data and control signal connect
  a_i_wire <> mesh.io.data_a_i
  b_i_wire <> mesh.io.data_b_i
  c_i_wire <> mesh.io.data_c_i

  io.data.d_o := Cat(d_out_wire_2.reverse)

  mesh.io.ctrl <> io.ctrl

}

object GemmArray extends App {
  val params   = DefaultConfig.gemmConfig
  val dir_name = "GemmArray_%s_%s_%s_%s".format(
    params.meshRow,
    params.tileSize,
    params.meshCol,
    params.dataWidthA
  )
  emitVerilog(
    new GemmArray(params),
    Array("--target-dir", "generated/%s".format(dir_name))
  )
}
