package snax.csr_manager

import chisel3._
import org.scalatest.flatspec.AnyFlatSpec
import chiseltest._

class CsrManagerTopGenerate
extends AnyFlatSpec {

  emitVerilog(
    new CsrManager(10, 32),
    Array("--target-dir", "generated/")
  )    

}

