// Copyright 2025 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Robin Geens <robin.geens@kuleuven.be>

package snax_acc.versacore

import fp_unit.DataType

class IntType(val width: Int) extends DataType

object Int1  extends IntType(1)
object Int2  extends IntType(2)
object Int3  extends IntType(3)
object Int4  extends IntType(4)
object Int8  extends IntType(8)
object Int16 extends IntType(16)
object Int32 extends IntType(32)
