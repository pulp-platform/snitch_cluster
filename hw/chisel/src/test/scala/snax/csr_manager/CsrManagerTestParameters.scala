package snax.csr_manager

import chisel3._
import chisel3.util._

object CsrManagerTestParameters {
  def csrNumReadWrite = 10
  def csrNumReadOnly = 2
  def csrAddrWidth = 32
  def csrModuleTagName = "Test"
}
