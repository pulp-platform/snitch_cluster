package snax.DataPathExtension

import chisel3._
import chisel3.util._
import snax.xdma.DesignParams._

object HasBroadcaster256to2048 extends HasDataPathExtension {
  implicit val extensionParam: DataPathExtensionParam =
    new DataPathExtensionParam(
      moduleName = "Broadcaster256to2048",
      userCsrNum = 0,
      dataWidth = 2048
    )
  def instantiate(clusterName: String): Broadcaster = Module(
    new Broadcaster(256) {
      override def desiredName = clusterName + namePostfix
    }
  )
}

class Broadcaster(inputUsefulDatawidth: Int)(implicit
    extensionParam: DataPathExtensionParam
) extends DataPathExtension {

  ext_data_i.ready := ext_data_o.ready
  ext_data_o.valid := ext_data_i.valid

  val inputUsefulData = ext_data_i.bits(inputUsefulDatawidth - 1, 0)
  ext_data_o.bits := VecInit(
    Seq.fill(extensionParam.dataWidth / inputUsefulDatawidth)(inputUsefulData)
  ).asUInt
  ext_busy_o := false.B
}
