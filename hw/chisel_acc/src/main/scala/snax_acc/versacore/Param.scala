// Copyright 2025 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Xiaoling Yi <xiaoling.yi@kuleuven.be>

package snax_acc.versacore

abstract class OpType

object OpType {
  def fromString(str: String): OpType =
    str match {
      case "SIntSInt" => SIntSIntOp
      case "UIntUInt" => UIntUIntOp
      case _          => throw new IllegalArgumentException(s"Unsupported OpType: $str")
    }
}

object UIntUIntOp       extends OpType
object SIntSIntOp       extends OpType
object Float16IntOp     extends OpType
object Float16Float16Op extends OpType

class SpatialArrayParam(
  val opType:                 Seq[OpType],
  val macNum:                 Seq[Int],
  val inputTypeA:             Seq[DataType],
  val inputTypeB:             Seq[DataType],
  val inputTypeC:             Seq[DataType],
  val mulElemWidth:           Seq[Int],
  val outputTypeD:            Seq[DataType],
  val arrayInputAWidth:       Int,
  val arrayInputBWidth:       Int,
  val arrayInputCWidth:       Int,
  val arrayOutputDWidth:      Int,
  val arrayDim:               Seq[Seq[Seq[Int]]],
  val serialInputADataWidth:  Int,
  val serialInputBDataWidth:  Int,
  val serialInputCDataWidth:  Int,
  val serialOutputDDataWidth: Int,
  val adderTreeDelay:         Int         = 0,
  val dataflow:               Seq[String] = Seq("output_stationary", "input_stationary", "weight_stationary"),
  val configWidth:            Int         = 32,
  val csrNum:                 Int         = 7
)

object SpatialArrayParam {
  // test config
  def apply(): SpatialArrayParam =
    apply(
      opType                 = Seq(UIntUIntOp, SIntSIntOp),
      macNum                 = Seq(1024, 2048),
      inputTypeA             = Seq(Int8, Int4),
      inputTypeB             = Seq(Int8, Int4),
      inputTypeC             = Seq(Int32, Int16),
      mulElemWidth           = Seq(16, 8),
      outputTypeD            = Seq(Int32, Int16),
      arrayInputAWidth       = 512,
      arrayInputBWidth       = 512,
      arrayInputCWidth       = 16384,
      arrayOutputDWidth      = 16384,
      // Seq(Mu, Ku, Nu)
      arrayDim               = Seq(
        Seq(Seq(8, 8, 8), Seq(32, 1, 16), Seq(32, 2, 16)),
        Seq(Seq(8, 16, 8), Seq(32, 1, 32), Seq(32, 1, 16))
      ),
      serialInputADataWidth  = 512,
      serialInputBDataWidth  = 512,
      serialInputCDataWidth  = 512,
      serialOutputDDataWidth = 512
    )

  def apply(
    opType:                 Seq[OpType],
    macNum:                 Seq[Int],
    inputTypeA:             Seq[DataType],
    inputTypeB:             Seq[DataType],
    inputTypeC:             Seq[DataType],
    mulElemWidth:           Seq[Int],
    outputTypeD:            Seq[DataType],
    arrayInputAWidth:       Int,
    arrayInputBWidth:       Int,
    arrayInputCWidth:       Int,
    arrayOutputDWidth:      Int,
    arrayDim:               Seq[Seq[Seq[Int]]],
    serialInputADataWidth:  Int,
    serialInputBDataWidth:  Int,
    serialInputCDataWidth:  Int,
    serialOutputDDataWidth: Int,
    adderTreeDelay:         Int         = 0,
    dataflow:               Seq[String] = Seq("output_stationary", "input_stationary", "weight_stationary")
  ): SpatialArrayParam =
    new SpatialArrayParam(
      opType                 = opType,
      macNum                 = macNum,
      inputTypeA             = inputTypeA,
      inputTypeB             = inputTypeB,
      inputTypeC             = inputTypeC,
      mulElemWidth           = mulElemWidth,
      outputTypeD            = outputTypeD,
      arrayInputAWidth       = arrayInputAWidth,
      arrayInputBWidth       = arrayInputBWidth,
      arrayInputCWidth       = arrayInputCWidth,
      arrayOutputDWidth      = arrayOutputDWidth,
      arrayDim               = arrayDim,
      serialInputADataWidth  = serialInputADataWidth,
      serialInputBDataWidth  = serialInputBDataWidth,
      serialInputCDataWidth  = serialInputCDataWidth,
      serialOutputDDataWidth = serialOutputDDataWidth,
      adderTreeDelay         = adderTreeDelay,
      dataflow               = dataflow
    )
}
