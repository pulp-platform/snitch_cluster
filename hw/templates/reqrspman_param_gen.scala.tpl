// Copyright 2024 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

package snax.reqRspManager

import snax.utils._

import chisel3._
import chisel3.util._

// Scala main function for generating ReqRspManager system verilog file
object ReqRspManagerGen {
  def main(args: Array[String]) : Unit = {
    val outPath = args.headOption.getOrElse("../../target/snitch_cluster/generated/.")
    emitVerilog(
      new ReqRspManager(
        numReadWriteReg = ${cfg["snax_num_rw_csr"]},
        numReadOnlyReg = ${cfg["snax_num_ro_csr"]},
        addrWidth = 32,
        moduleTagName = "${cfg["tag_name"]}_reqrspman_"
      ),
      Array("--target-dir", outPath)
    )
  }
}
