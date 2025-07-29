package snax.DataPathExtension

import chisel3._
import chisel3.util._

class HasElementwiseAdd(
  elementWidth: Int = 32,
  dataWidth:    Int = 512
) extends HasDataPathExtension {
  implicit val extensionParam: DataPathExtensionParam =
    new DataPathExtensionParam(
      moduleName = s"ElementwiseAddBit${elementWidth}",
      userCsrNum = 1,
      dataWidth  = dataWidth match {
        case 0 => elementWidth
        case _ => dataWidth
      }
    )

  def instantiate(clusterName: String): ElementwiseAdd =
    Module(
      new ElementwiseAdd(elementWidth) {
        override def desiredName = clusterName + namePostfix
      }
    )
}

class ElementwiseAdd(
  elementWidth: Int
)(implicit extensionParam: DataPathExtensionParam)
    extends DataPathExtension {
  require(
    extensionParam.dataWidth % elementWidth == 0,
    s"Data width ${extensionParam.dataWidth} must be a multiple of element width $elementWidth"
  )

  // Counter to record the steps
  val counter = Module(new snax.utils.BasicCounter(8) {
    override val desiredName = "ElementwiseAddCounter"
  })
  counter.io.ceil := ext_csr_i(0)
  counter.io.reset := ext_start_i
  counter.io.tick  := ext_data_i.fire
  ext_busy_o       := counter.io.value =/= 0.U

  // The wire to connect the output result
  val ext_data_o_bits = Wire(
    Vec(extensionParam.dataWidth / elementWidth, UInt(elementWidth.W))
  )

  // The register to hold the sum of each Element
  val regs = RegInit(
    VecInit(
      Seq.fill(extensionParam.dataWidth / elementWidth)(0.U(elementWidth.W))
    )
  )

  val input_data = ext_data_i.bits.asTypeOf(
    Vec(extensionParam.dataWidth / elementWidth, UInt(elementWidth.W))
  )
  for (i <- 0 until extensionParam.dataWidth / elementWidth) {
    ext_data_o_bits(i) := regs(i) + input_data(i)
  }

  when(ext_data_i.fire) {
    when(counter.io.value === (ext_csr_i(0) - 1.U(8.W))) {
      // Reset the registers when the counter reaches the end
      for (i <- 0 until extensionParam.dataWidth / elementWidth) {
        regs(i) := 0.U
      }
    } otherwise {
      // Add the input data to the corresponding register
      for (i <- 0 until extensionParam.dataWidth / elementWidth) {
        regs(i) := regs(i) + input_data(i)
      }
    }
  }

  ext_data_o.bits  := Cat(ext_data_o_bits.reverse)
  ext_data_o.valid := (counter.io.value === (ext_csr_i(0) - 1.U)(7, 0))
  ext_data_i.ready := ext_data_o.ready
}
