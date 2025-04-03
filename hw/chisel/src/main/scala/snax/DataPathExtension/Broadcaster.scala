package snax.DataPathExtension

import chisel3._

class HasBroadcaster(inputLength: Int, outputLength: Int) extends HasDataPathExtension {
  implicit val extensionParam: DataPathExtensionParam =
    new DataPathExtensionParam(
      moduleName = s"Broadcaster${inputLength}to${outputLength}",
      userCsrNum = 0,
      dataWidth  = outputLength
    )

  def instantiate(clusterName: String): Broadcaster =
    Module(new Broadcaster(inputLength) { override def desiredName = clusterName + namePostfix })
}

class Broadcaster(inputUsefulDatawidth: Int)(implicit extensionParam: DataPathExtensionParam)
    extends DataPathExtension {

  ext_data_i.ready := ext_data_o.ready
  ext_data_o.valid := ext_data_i.valid

  val inputUsefulData = ext_data_i.bits(inputUsefulDatawidth - 1, 0)
  ext_data_o.bits := VecInit(Seq.fill(extensionParam.dataWidth / inputUsefulDatawidth)(inputUsefulData)).asUInt
  ext_busy_o      := false.B
}
