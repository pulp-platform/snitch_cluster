package snax.reqRspManager

import chisel3._

import org.scalatest.flatspec.AnyFlatSpec
import snax.reqRspManager.ReqRspManager

class ReqRspManagerTopGenerate extends AnyFlatSpec {

  emitVerilog(
    new ReqRspManager(
      IO32R32ReqRspManagerTestParameters.numReadWriteReg,
      IO32R32ReqRspManagerTestParameters.numReadOnlyReg,
      IO32R32ReqRspManagerTestParameters.addrWidth
    ),
    Array("--target-dir", "generated/reqRspManager")
  )
}
