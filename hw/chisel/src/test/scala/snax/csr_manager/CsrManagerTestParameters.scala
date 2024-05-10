package snax.csr_manager

import chisel3._
import chisel3.util._

object csrManagerTestParameters {
  def csrNum = 20
  def csrAddrWidth = log2Up(csrNum)
  def csrModuleTagName = "Test"
}
