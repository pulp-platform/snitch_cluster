package snax.xdma.xdmaExtension

import chisel3._
import chisel3.util._
import snax.xdma.DesignParams.DMAExtensionParam

object HasVerilogMemset extends HasDMAExtension {
  implicit val extensionParam: DMAExtensionParam = new DMAExtensionParam(
    moduleName = "VerilogMemset",
    userCsrNum = 1,
    dataWidth = 512
  )
  def instantiate(clusterName: String): SystemVerilogDMAExtension = Module(
    new SystemVerilogDMAExtension(
      topmodule = "VerilogMemset",
      filelist = Seq("src/main/systemverilog/VerilogMemset/VerilogMemset.sv")
    ) {
      override def desiredName = clusterName + namePostfix
    }
  )
}
