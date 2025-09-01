package snax.DataPathExtension

import chisel3._
import chisel3.util._

import snax.utils._

class HasTransposer(row: Seq[Int], col: Seq[Int], elementWidth: Seq[Int], dataWidth: Int = 0)
    extends HasDataPathExtension {
  // The length of row, col, and elementWidth should be the same
  require(row.length == col.length && col.length == elementWidth.length)

  val realDataWidth = dataWidth match {
    case 0 =>
      row
        .zip(col)
        .zip(elementWidth)
        .map { case ((r, c), e) =>
          r * c * e
        }
        .min
    // row.head * col.head * elementWidth.head
    case _ => dataWidth
  }

  implicit val extensionParam: DataPathExtensionParam =
    new DataPathExtensionParam(
      moduleName = s"TransposerRow${row.mkString("_")}Col${col
          .mkString("_")}Bit${elementWidth.mkString("_")}",
      userCsrNum = if (row.length == 1) 0 else 1,
      dataWidth  = realDataWidth
    )

  def instantiate(clusterName: String): Transposer =
    Module(
      new Transposer(row, col, elementWidth) {
        override def desiredName = clusterName + namePostfix
      }
    )
}

class TransposerUnit(row: Int, col: Int, ioWidth: Int, elementWidth: Int) extends Module {
  val elementPerTransfer   = ioWidth / elementWidth
  val transferPerTranspose = row * col / elementPerTransfer
  val transposedRow        = col
  val transposedCol        = row
  val io                   = IO(new Bundle {
    val in    = Flipped(Decoupled(UInt(ioWidth.W)))
    val out   = Decoupled(UInt(ioWidth.W))
    val start = Input(Bool())
  })
  val matrixBitWidth       = row * col * elementWidth
  val matrixInput          = Wire(Vec(row, Vec(col, UInt(elementWidth.W))))
  val matrixOutput         = Wire(Vec(col, Vec(row, UInt(elementWidth.W))))
  for (i <- 0 until row) {
    for (j <- 0 until col) {
      matrixOutput(j)(i) := matrixInput(i)(j)
    }
  }

  if (transferPerTranspose == 1) {
    io.out.bits  := matrixOutput.asTypeOf(chiselTypeOf(io.out.bits))
    matrixInput  := io.in.bits.asTypeOf(chiselTypeOf(matrixInput))
    io.out.valid := io.in.valid
    io.in.ready  := io.out.ready
  } else {
    val inputMatrixType  = Vec(row, Vec(col / transferPerTranspose, UInt(elementWidth.W)))
    val outputMatrixType = Vec(transposedRow, Vec(transposedCol / transferPerTranspose, UInt(elementWidth.W)))

    val upConverter   = Module(
      new WidthUpConverter(inputMatrixType, transferPerTranspose)
    )
    val downConverter = Module(
      new WidthDownConverter(outputMatrixType, transferPerTranspose)
    )

    // Connect the control signal
    upConverter.io.start       := io.start
    downConverter.io.start     := io.start
    upConverter.io.in.valid    := io.in.valid
    io.in.ready                := upConverter.io.in.ready
    downConverter.io.in.valid  := upConverter.io.out.valid
    upConverter.io.out.ready   := downConverter.io.in.ready
    io.out.valid               := downConverter.io.out.valid
    downConverter.io.out.ready := io.out.ready

    // Connect the data signal
    io.out.bits            := downConverter.io.out.bits.asTypeOf(chiselTypeOf(io.out.bits))
    upConverter.io.in.bits := io.in.bits.asTypeOf(chiselTypeOf(upConverter.io.in.bits))

    // Connect the upperConverter to matrixInput
    for (i <- 0 until row) {
      for (j <- 0 until col) {
        matrixInput(i)(j) := upConverter.io.out.bits(j / (col / transferPerTranspose))(i)(
          j % (col / transferPerTranspose)
        )
      }
    }

    // Connect the lowerConverter to matrixOutput
    for (i <- 0 until transposedRow) {
      for (j <- 0 until transposedCol) {
        downConverter.io.in.bits(j / (transposedCol / transferPerTranspose))(i)(
          j % (transposedCol / transferPerTranspose)
        ) := matrixOutput(i)(j)
      }
    }
  }
}

class Transposer(row: Seq[Int], col: Seq[Int], elementWidth: Seq[Int])(implicit extensionParam: DataPathExtensionParam)
    extends DataPathExtension {

  val demux = Module(new DemuxDecoupled(UInt(extensionParam.dataWidth.W), row.length) {
    override def desiredName = extensionParam.moduleName + "_demux"
  })

  ext_data_i <> demux.io.in

  val mux = Module(new MuxDecoupled(UInt(extensionParam.dataWidth.W), row.length) {
    override def desiredName = extensionParam.moduleName + "_mux"
  })

  ext_data_o <> mux.io.out

  val transposerArray = row.zip(col).zip(elementWidth).map { case ((r, c), e) =>
    Module(
      new TransposerUnit(r, c, extensionParam.dataWidth, e) {
        override def desiredName = extensionParam.moduleName + "_transposer_" + r + "_" + c + "_" + e
      }
    )
  }

  transposerArray.zipWithIndex.foreach { case (transposer, i) =>
    transposer.io.in <> demux.io.out(i)
    mux.io.in(i) <> transposer.io.out
    transposer.io.start := ext_start_i
  }

  if (transposerArray.length == 1) {
    mux.io.sel   := 0.U
    demux.io.sel := 0.U
  } else {
    mux.io.sel   := ext_csr_i(0)
    demux.io.sel := ext_csr_i(0)
  }
  ext_busy_o := false.B
}

object TransposerEmitter extends App {
  println(
    getVerilogString(
      new Transposer(Seq(8), Seq(8), Seq(16))(
        extensionParam = new DataPathExtensionParam(
          moduleName = "Transposer",
          userCsrNum = 0,
          dataWidth  = 512
        )
      )
    )
  )
}
