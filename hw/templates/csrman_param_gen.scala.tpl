// Copyright 2024 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

package snax.csr_manager

import snax.utils._

import chisel3._
import chisel3.util._

// Scala main function for generating CsrManager system verilog file
object CsrManagerGen {
  def main(args: Array[String]) : Unit = {
    val outPath = args.headOption.getOrElse("../../target/snitch_cluster/generated/.")
    emitVerilog(
      new CsrManager(
        csrNum = ${cfg["snax_acc_num_csr"]},
        csrAddrWidth = 32,
        csrModuleTagName = "${cfg["tag_name"]}"
      ),
      Array("--target-dir", outPath)
    )
  }
}
