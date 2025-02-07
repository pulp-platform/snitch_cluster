package snax.DataPathExtension

import chisel3._
import chisel3.util._
import snax.xdma.DesignParams._
import snax.utils.DecoupledCut._

class HasTransposer(row: Int = 8, col: Int = 8, elementBits: Int = 8)
    extends HasDataPathExtension {
  implicit val extensionParam: DataPathExtensionParam =
    new DataPathExtensionParam(
      moduleName = "Transposer",
      userCsrNum = 0,
      dataWidth = 512
    )

  def instantiate(clusterName: String): Transposer = Module(
    new Transposer(row, col, elementBits) {
      override def desiredName = clusterName + namePostfix
    }
  )
}

class Transposer(row: Int, col: Int, elementBits: Int)(implicit
    extensionParam: DataPathExtensionParam
) extends DataPathExtension {

  require(
    extensionParam.dataWidth == row * col * elementBits,
    "transposeInWidth must be 512 for now"
  )

  // fixed pattern: transpose 8x8 matrix
  val out_data_array = Wire(Vec(col, Vec(row, UInt(elementBits.W))))

  for (i <- 0 until row) {
    for (j <- 0 until col) {
      out_data_array(j)(i) := ext_data_i.bits(
        i * col * elementBits + j * elementBits + (elementBits - 1),
        i * col * elementBits + j * elementBits + 0
      )
    }
  }

  ext_data_i.ready := ext_data_o.ready
  ext_data_o.valid := ext_data_i.valid
  ext_busy_o := false.B
  ext_data_o.bits := out_data_array.asUInt

}

object TransposerEmitter extends App {
  println(
    getVerilogString(
      new Transposer(32, 2, 8)(
        extensionParam = new DataPathExtensionParam(
          moduleName = "Transposer",
          userCsrNum = 1,
          dataWidth = 512
        )
      )
    )
  )
}
