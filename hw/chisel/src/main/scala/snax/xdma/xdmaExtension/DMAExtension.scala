package snax.xdma.xdmaExtension

import chisel3._
import chisel3.util._

import snax.utils._
import snax.xdma.CommonCells._
import snax.xdma.DesignParams._

/** The parent (abstract) Class for the DMA Extension Generation Params This
  * class template is used to isolate the definition of class (when user provide
  * the parameters) and the actual instantiation of Module, and allow other
  * module to read some information about the Extension before the instantiation
  * The idea is similar to Rocketchip's LazyModule and LazyModuleImp.
  *
  * Usage: 1) For every custom extension "CustomExtension", an object
  * "HasCustomExtension" should be declared, extending from HasDMAExtension. 2)
  * \@extensionParam, or basic parameters consumed by DMAExtension parent class
  * needs to be provided 3) The instantiate method of the module needs to be
  * provided
  */

abstract class HasDMAExtension {
  implicit val extensionParam: DMAExtensionParam

  def totalCsrNum = extensionParam.userCsrNum + 1
  def instantiate: DMAExtension
}

/** The parent (abstract) Class for the DMA Extension Implementation (Circuit)
  * All classes need to extends from this parent class like below: class
  * CustomModule(userParams)(implicit extensionParam: DMAExtensionParam) extends
  * DMAExtension Inside the body of CustomModule, the following thing must be
  * done: 1) Connect ext_data_i to your module's datapath input: ext_data_i <>
  * userDefinedInput 2) Connect ext_data_o to your module's datapath output:
  * ext_data_o <> userDefinedOutput 3) Connect CSR to your module <>
  * userDefinedCSR := ext_csr_i 4) Connect Start signal: userDefinedStart :=
  * ext_start_i. The start signal is used to inform extension a new stream is
  * coming 5) Connect Busy signal: ext_busy_o := userDefinedBusy. As the
  * extension does not know the length of the stream, the extension should pull
  * down the signal when there is data under processing
  */

abstract class DMAExtension(implicit extensionParam: DMAExtensionParam)
    extends Module
    with RequireAsyncReset {

  override def desiredName: String = extensionParam.moduleName

  val io = IO(new Bundle {
    val csr_i = Input(
      Vec(extensionParam.userCsrNum + 1, UInt(32.W))
    ) // CSR with the first one always byPass signal
    val start_i = Input(
      Bool()
    ) // The start signal triggers the local register to buffer the csr information
    val data_i = Flipped(Decoupled(UInt(extensionParam.dataWidth.W)))
    val data_o = Decoupled(UInt(extensionParam.dataWidth.W))
    val busy_o = Output(Bool())
  })

  private[this] val bypass = io.csr_i.head(0)
  private[this] val bypass_data = Wire(
    Decoupled(UInt(extensionParam.dataWidth.W))
  )

  // Signals under user's namespace
  val ext_data_i = Wire(Decoupled(UInt(extensionParam.dataWidth.W)))
  val ext_data_o = Wire(Decoupled(UInt(extensionParam.dataWidth.W)))
  val ext_csr_i = io.csr_i.tail
  val ext_start_i = io.start_i
  val ext_busy_o = Wire(Bool())
  io.busy_o := ext_busy_o || ext_data_i.valid

  // Structure to bypass extension: Demux
  private[this] val inputDemux = Module(
    new DemuxDecoupled(UInt(extensionParam.dataWidth.W), numOutput = 2)
  )
  inputDemux.io.sel := bypass
  inputDemux.io.in <> io.data_i
  // When bypass is 0, io.out(0) is connected with extension's input
  inputDemux.io.out(0) <> ext_data_i
  // When bypass is 1, io.out(1) is connected to bypass signal
  inputDemux.io.out(1) <> bypass_data

  // Structure to bypass extension: Mux
  private[this] val outputMux = Module(
    new MuxDecoupled(UInt(extensionParam.dataWidth.W), numInput = 2)
  )
  outputMux.io.sel := bypass
  outputMux.io.out <> io.data_o
  // When bypass is 0, io.in(0) is connected with extension's output
  outputMux.io.in(0) <> ext_data_o
  // When bypass is 1, io.in(1) is connected to bypass signal
  outputMux.io.in(1) <> bypass_data
}
