// Copyright 2025 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Xiaoling Yi <xiaoling.yi@kuleuven.be>
// Yunhao Deng <yunhao.deng@kuleuven.be>

package snax_acc.utils

import chisel3._

class BasicCounter(width: Int, hasCeil: Boolean = true, nameTag: String = "Default")
    extends Module
    with RequireAsyncReset {
  val io        = IO(new Bundle {
    val tick  = Input(Bool())
    val reset = Input(Bool())
    val ceil  = Input(UInt(width.W))

    val value   = Output(UInt(width.W))
    val lastVal = Output(Bool())
  })
  override def desiredName: String = "BasicCounter_" + nameTag + "_" + width.toString + "_" + hasCeil.toString
  // 32.W should be enough to count any loops
  val nextValue = Wire(UInt(width.W))
  val value     = RegNext(nextValue, 0.U)
  nextValue := {
    if (hasCeil) {
      Mux(
        io.reset,
        0.U,
        Mux(io.tick, Mux(value < io.ceil - 1.U, value + 1.U, 0.U), value)
      )
    } else {
      Mux(io.reset, 0.U, Mux(io.tick, value + 1.U, value))
    }
  }

  io.value   := value
  io.lastVal := {
    (if (hasCeil) (value === io.ceil - 1.U) else (value.andR)) && io.tick
  }
}

class NestCounter(width: Int, loopNum: Int) extends Module with RequireAsyncReset {
  val io = IO(new Bundle {
    val tick  = Input(Bool())
    val reset = Input(Bool())
    val ceil  = Input(Vec(loopNum, UInt(width.W)))

    val value   = Output(Vec(loopNum, UInt(width.W)))
    val lastVal = Output(Vec(loopNum, Bool()))
  })

  val counter = Seq.fill(loopNum)(Module(new BasicCounter(width, true)))

  counter.zipWithIndex.map { case (c, i) =>
    c.io.reset := io.reset
    c.io.ceil  := io.ceil(i)
  }

  // Connect the tick signal to the first counter
  counter(0).io.tick := io.tick

  // Connect the tick signal to the rest of the counters
  counter.zip(counter.tail).map { case (c1, c2) =>
    c2.io.tick := c1.io.lastVal && io.tick
  }

  io.value   := counter.map(_.io.value)
  io.lastVal := counter.map(_.io.lastVal)
}

object NestCounterEmitter extends App {
  val width   = 4
  val loopNum = 3
  emitVerilog(
    new NestCounter(width, loopNum),
    Array("--target-dir", "generated/SpatialArray")
  )
}
