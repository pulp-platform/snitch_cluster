package snax.DataPathExtension

import chisel3._
import chisel3.util._
import snax.utils.DecoupledCut._

class DataPathExtensionHostIO(
    extensionList: Seq[HasDataPathExtension],
    dataWidth: Int = 512
) extends Bundle {
  val data = new Bundle {
    val in = Flipped(
      Decoupled(UInt(dataWidth.W))
    )
    val out = Decoupled(UInt(dataWidth.W))
  }
  val cfg = new Bundle {
    val bypass = Input(UInt(extensionList.length.W))
    val userCsr = Input(
      Vec(extensionList.map(_.extensionParam.userCsrNum).sum, UInt(32.W))
    )
  }
  val start = Input(Bool())
  val busy = Output(Bool())

  def connectCfgWithList(csrList: IndexedSeq[UInt]): IndexedSeq[UInt] = {
    var remaincsrList = csrList
    // If there is no extension, just return the csrList (without any connection)
    if (extensionList.isEmpty) {
      cfg := DontCare
      return remaincsrList
    }
    cfg.bypass := remaincsrList.head
    remaincsrList = remaincsrList.tail
    cfg.userCsr := remaincsrList.take(
      extensionList.map(_.extensionParam.userCsrNum).sum
    )
    remaincsrList =
      remaincsrList.drop(extensionList.map(_.extensionParam.userCsrNum).sum)
    remaincsrList
  }
}

class DataPathExtensionHost(
    extensionList: Seq[HasDataPathExtension],
    dataWidth: Int = 512,
    moduleNamePrefix: String = "unnamed_cluster"
) extends Module {
  override def desiredName = s"${moduleNamePrefix}_DataPathExtensionHost"
  val io = IO(new DataPathExtensionHostIO(extensionList, dataWidth = dataWidth))

  if (extensionList.isEmpty) {
    io.data.out <> io.data.in
    io.busy := false.B
  } else {
    var remainingCSR = io.cfg.userCsr.toIndexedSeq
    var remaingBypass = io.cfg.bypass.asBools.toIndexedSeq

    val extensions = extensionList.zipWithIndex.map {
      case (item, index) => {
        require(
          item.extensionParam.dataWidth == dataWidth,
          "Data width of the extension does not match the host"
        )

        // Instantiate the extension
        val extension =
          item.instantiate(moduleNamePrefix)

        // Connect Start signal
        extension.io.start_i := io.start

        // Recursively connect the bypass signals
        extension.io.bypass_i := remaingBypass.head
        remaingBypass = remaingBypass.tail

        // Recursively connect the CSR signals
        for (i <- extension.io.csr_i) {
          i := remainingCSR.head
          remainingCSR = remainingCSR.tail
        }

        // Suggest a name for the extension
        extension.suggestName(
          s"${moduleNamePrefix}_Extension_${index}_${item.extensionParam.moduleName}"
        )
        // Return the extension for future connection use
        extension
      }
    }

    // Connect busy signal
    io.busy := extensions.map(_.io.busy_o).reduce(_ | _)

    if (remainingCSR.length != 0)
      println(
        "Debug: Some remaining CSRs are unconnected at reader. Check the code. "
      )

    // Connect the data path
    extensions.head.io.data_i <> io.data.in
    extensions.last.io.data_o <> io.data.out
    extensions.zip(extensions.tail).foreach {
      case (a, b) => {
        a.io.data_o -||> b.io.data_i
      }
    }
  }
}
