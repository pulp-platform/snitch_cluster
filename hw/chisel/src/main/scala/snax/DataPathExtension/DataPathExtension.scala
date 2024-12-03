package snax.DataPathExtension

import chisel3._
import chisel3.util._

import snax.utils._
import snax.xdma.DesignParams._
import java.io.File

/** The parent (abstract) Class for the DMA Extension Generation Params This
  * class template is used to isolate the definition of class (when user provide
  * the parameters) and the actual instantiation of Module, and allow other
  * module to read some information about the Extension before the instantiation
  * The idea is similar to Rocketchip's LazyModule and LazyModuleImp.
  *
  * Usage:
  *
  * 1) For every custom extension "CustomExtension", an object
  * "HasCustomExtension" should be declared, extending from
  * HasDataPathExtension.
  *
  * 2) @extensionParam, or basic parameters consumed by DataPathExtension parent
  * class needs to be provided.
  *
  * 3) The instantiate method of the module needs to be provided.
  */

abstract class HasDataPathExtension {
  implicit val extensionParam: DataPathExtensionParam

  def namePostfix = "_DataPathExtension_" + extensionParam.moduleName
  def instantiate(clusterName: String): DataPathExtension
}

/** The parent (abstract) Class for the DMA Extension Implementation (Circuit)
  * All classes need to extends from this parent class like below: class
  * CustomModule(userParams)(implicit extensionParam: DataPathExtensionParam)
  * extends DataPathExtension Inside the body of CustomModule, the following
  * thing must be done:
  *
  * 1) Connect ext_data_i to your module's datapath input: ext_data_i <>
  * userDefinedInput.
  *
  * 2) Connect ext_data_o to your module's datapath output: ext_data_o <>
  * userDefinedOutput.
  *
  * 3) Connect CSR to your module <> userDefinedCSR := ext_csr_i.
  *
  * 4) Connect Start signal: userDefinedStart := ext_start_i. The start signal
  * is used to inform extension a new stream is coming.
  *
  * 5) Connect Busy signal: ext_busy_o := userDefinedBusy. As the extension does
  * not know the length of the stream, the extension should pull down the signal
  * when there is data under processing.
  */

abstract class DataPathExtension(implicit
    extensionParam: DataPathExtensionParam
) extends Module
    with RequireAsyncReset {

  val io = IO(new Bundle {
    val csr_i = Input(
      Vec(extensionParam.userCsrNum, UInt(32.W))
    ) // CSR with the first one always byPass signal
    val start_i = Input(
      Bool()
    ) // The start signal triggers the local register to buffer the csr information
    val bypass_i = Input(
      Bool()
    ) // The signal controlling a pair of mux / demux to bypass the extension
    val data_i = Flipped(Decoupled(UInt(extensionParam.dataWidth.W)))
    val data_o = Decoupled(UInt(extensionParam.dataWidth.W))
    val busy_o = Output(Bool())
  })

  private[this] val bypass_data = Wire(
    Decoupled(UInt(extensionParam.dataWidth.W))
  )

  // Signals under user's namespace
  val ext_data_i = Wire(Decoupled(UInt(extensionParam.dataWidth.W)))
  val ext_data_o = Wire(Decoupled(UInt(extensionParam.dataWidth.W)))
  val ext_csr_i = io.csr_i
  val ext_start_i = io.start_i
  val ext_busy_o = Wire(Bool())
  io.busy_o := ext_busy_o || ext_data_i.valid

  // Structure to bypass extension: Demux
  private[this] val inputDemux = Module(
    new DemuxDecoupled(UInt(extensionParam.dataWidth.W), numOutput = 2) {
      override def desiredName =
        "DataPathExtension_Demux_W" + extensionParam.dataWidth.toString
    }
  )
  inputDemux.io.sel := io.bypass_i
  inputDemux.io.in <> io.data_i
  // When bypass is 0, io.out(0) is connected with extension's input
  inputDemux.io.out(0) <> ext_data_i
  // When bypass is 1, io.out(1) is connected to bypass signal
  inputDemux.io.out(1) <> bypass_data

  // Structure to bypass extension: Mux
  private[this] val outputMux = Module(
    new MuxDecoupled(UInt(extensionParam.dataWidth.W), numInput = 2) {
      override def desiredName =
        "DataPathExtension_Mux_W" + extensionParam.dataWidth.toString
    }
  )
  outputMux.io.sel := io.bypass_i
  outputMux.io.out <> io.data_o
  // When bypass is 0, io.in(0) is connected with extension's output
  outputMux.io.in(0) <> ext_data_o
  // When bypass is 1, io.in(1) is connected to bypass signal
  outputMux.io.in(1) <> bypass_data
}

/** The parent Class for the integration of DMA Extension written in
  * SystemVerilog Before the integration of the custom extension, please make
  * sure the following:
  *
  * 1) The SystemVerilog module's top module's IO is strict, shown as the
  * following example:
  *
  * module VerilogMemset #(
  *
  * parameter int UserCsrNum = 1,
  *
  * parameter int DataWidth = 512
  *
  * ) (
  *
  * input logic clk,
  *
  * input logic rst_n,
  *
  * output logic ext_data_i_ready,
  *
  * input logic ext_data_i_valid,
  *
  * input logic [DataWidth-1:0] ext_data_i_bits,
  *
  * input logic ext_data_o_ready,
  *
  * output logic ext_data_o_valid,
  *
  * output logic [DataWidth-1:0] ext_data_o_bits,
  *
  * input logic [31:0]ext_csr_i_0,
  *
  * input logic ext_start_i,
  *
  * output logic ext_busy_o
  *
  * );
  *
  * Several reminders for developers:
  *
  * 1> Two parameters is provided by XDMA generator: userCsrNum and dataWidth,
  * which is user-definable in HasDataPathExtension class.
  *
  * 2> rst_ni is the active low asynchronous reset signal.
  *
  * 3> The input and output has the handshake. When both are high, the data is
  * regarded as successfully transferred.
  *
  * 4> csr_i is the CSR signal, and it is an unrolled two-dimensional signal. If
  * userCsrNum is 2, then there is two csrs: ext_csr_i_0 and ext_csr_i_1.
  *
  * 2) After the writing of the SystemVerilog module, give Chisel generator the
  * method to integrate the SystemVerilog module. This is done by the
  * declaration of HasDataPathExtension object. (Take a llok at example in
  * VerilogMemset.scala)
  *
  * 3) The instantiate method should be provided, with a new
  * SystemVerilogDataPathExtension class.This class need two parameters:
  * topmodule and filelist. The topmodule is the name of the SystemVerilog
  * module (very similar to defining the top module in the backend flow), and
  * the filelist is the list of SystemVerilog files that are needed to be
  * integrated. 4) The location of SystemVerilog file doesn't matter. Because
  * Chisel will include all the code you write inside the body of XDMA. However,
  * it is recommended to put it in the src/main/systemverilog folder for the
  * management purpose.
  */

class SystemVerilogDataPathExtension(topmodule: String, filelist: Seq[String])(
    implicit extensionParam: DataPathExtensionParam
) extends DataPathExtension {

  def this(topmodule: String, dir: String)(implicit
      extensionParam: DataPathExtensionParam
  ) = this(
    topmodule, {
      val folder = new File(dir)
      val filelist = if (folder.exists && folder.isDirectory) {
        folder.listFiles.filter(_.isFile).toList
      } else {
        List.empty[File]
      }
      filelist
        .filter(i => i.getName.endsWith(".sv") || i.getName.endsWith(".v"))
        .map(_.toPath.toString)
        .toSeq
    }
  )

  val sv_module = Module(
    new BlackBox(
      Map(
        "UserCsrNum" -> extensionParam.userCsrNum,
        "DataWidth" -> extensionParam.dataWidth
      )
    ) with HasBlackBoxInline {
      val io = IO(new Bundle {
        val clk_i = Input(Bool())
        val rst_ni = Input(Bool())
        val ext_data_i = Flipped(Decoupled(UInt(extensionParam.dataWidth.W)))
        val ext_data_o = Decoupled(UInt(extensionParam.dataWidth.W))
        val ext_csr_i = Input(Vec(extensionParam.userCsrNum, UInt(32.W)))
        val ext_start_i = Input(Bool())
        val ext_busy_o = Output(Bool())
      })
      override def desiredName: String = topmodule
      var inlineSV = ""
      for (file <- filelist) {
        inlineSV += scala.io.Source.fromFile(file).getLines().mkString("\n")
        inlineSV += "\n"
      }
      setInline(extensionParam.moduleName + ".sv", inlineSV)
    }
  )

  sv_module.io.clk_i := clock.asBool
  sv_module.io.rst_ni := ~(reset.asBool)
  sv_module.io.ext_data_i <> ext_data_i
  sv_module.io.ext_data_o <> ext_data_o
  sv_module.io.ext_csr_i := ext_csr_i
  sv_module.io.ext_start_i := ext_start_i
  ext_busy_o := sv_module.io.ext_busy_o
}
