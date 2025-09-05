package snax.utils

import chisel3._

// simplified tcdm interface
class RegReq(addrWidth: Int, tcdmDataWidth: Int) extends Bundle {
  val addr  = UInt(addrWidth.W)
  val write = Bool()
  val data  = UInt(tcdmDataWidth.W)
  val strb  = UInt((tcdmDataWidth / 8).W)
}

class RegRsp(tcdmDataWidth: Int) extends Bundle {
  val data = UInt(tcdmDataWidth.W)
}
