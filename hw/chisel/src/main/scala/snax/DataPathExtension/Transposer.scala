package snax.DataPathExtension

import chisel3._
import chisel3.util._
import snax.xdma.DesignParams._
import snax.utils.DecoupledCut._

class HasTransposer(
    row: Seq[Int],
    col: Seq[Int],
    elementWidth: Seq[Int]
) extends HasDataPathExtension {
  // The length of row, col, and elementBits should be the same
  require(row.length == col.length && col.length == elementWidth.length)
  // DataWidth can be calculated by row, col, and elementBits
  val dataWidth = row.head * col.head * elementWidth.head
  // The product of row, col, and elementBits should be equal to dataWidth
  require {
    row.zip(col).zip(elementWidth).forall { case ((r, c), e) =>
      r * c * e == dataWidth
    }
  }
  implicit val extensionParam: DataPathExtensionParam =
    new DataPathExtensionParam(
      moduleName = s"TransposerRow${row.mkString("_")}Col${col
          .mkString("_")}Bit${elementWidth.mkString("_")}",
      userCsrNum = if (row.length == 1) 0 else 1,
      dataWidth = dataWidth
    )

  def instantiate(clusterName: String): Transposer = Module(
    new Transposer(row, col, elementWidth) {
      override def desiredName = clusterName + namePostfix
    }
  )
}

class Transposer(
    row: Seq[Int],
    col: Seq[Int],
    elementBits: Seq[Int]
)(implicit
    extensionParam: DataPathExtensionParam
) extends DataPathExtension {
  val outputArray = row.zip(col).zip(elementBits).map { case ((r, c), e) =>
    val transposedResult = Wire(Vec(c, Vec(r, UInt(e.W))))
    for (i <- 0 until r) {
      for (j <- 0 until c) {
        transposedResult(j)(i) := ext_data_i.bits(
          i * c * e + j * e + (e - 1),
          i * c * e + j * e
        )
      }
    }
    transposedResult
  }

  if (row.length == 1)
    ext_data_o.bits := outputArray.head.asUInt
  else {
    MuxLookup(ext_csr_i(0), 0.U)(
      0 until row.length map { i =>
        i.U -> outputArray(i).asUInt
      }
    )
  }

  ext_data_i.ready := ext_data_o.ready
  ext_data_o.valid := ext_data_i.valid
  ext_busy_o := false.B
}

object TransposerEmitter extends App {
  println(
    getVerilogString(
      new Transposer(Seq(32), Seq(2), Seq(8))(
        extensionParam = new DataPathExtensionParam(
          moduleName = "Transposer",
          userCsrNum = 0,
          dataWidth = 512
        )
      )
    )
  )
}
