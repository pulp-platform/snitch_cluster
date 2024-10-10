package snax.utils

import chisel3._
import chisel3.util._

/** The complexQueue_Concat to do multiple channel in / single concatenated out
  * or single channel in / multiple splitted out fifo The user defined params
  * include:
  * @param inputWidth:
  *   the width of the input
  * @param outputWidth:
  *   the width of the output
  * @param depth:
  *   the depth of the FIFO If inputWidth is smaller than outputWidth, then it
  *   will be the first option If inputWidth is larger than outputWidth, then it
  *   will be the second option No matter which case, the big width one should
  *   equal to integer times of the small width one
  */

class ComplexQueueConcat(
    inputWidth: Int,
    outputWidth: Int,
    depth: Int,
    pipe: Boolean = false
) extends Module
    with RequireAsyncReset {
  val bigWidth = Seq(inputWidth, outputWidth).max
  val smallWidth = Seq(inputWidth, outputWidth).min

  val queueModuleName =
    "Queue_W" + smallWidth.toString + "_D" + depth.toString + "_H" + BigInt(
      numbits = 30,
      scala.util.Random
    ).toString(radix = 32)

  require(
    bigWidth % smallWidth == 0,
    message = "The Bigger datawidth should be interger times of smaller width! "
  )
  val numChannel = bigWidth / smallWidth
  require(depth > 0)

  val io = IO(new Bundle {
    val in = Flipped(
      Vec(
        {
          if (inputWidth == bigWidth) 1 else numChannel
        },
        Decoupled(UInt(inputWidth.W))
      )
    )
    val out = Vec(
      {
        if (outputWidth == bigWidth) 1 else numChannel
      },
      Decoupled(UInt(outputWidth.W))
    )
    val allEmpty = Output(Bool())
    val anyFull = Output(Bool())
  })

  val queues = for (i <- 0 until numChannel) yield {
    val queue = Module(new Queue(UInt(smallWidth.W), depth, pipe) {
      override val desiredName = queueModuleName
    })
    queue
  }

  if (io.in.length != 1 || (io.in.length == 1 && io.out.length == 1)) {
    // Cond 1: io.in is not equals to 1, thus it is a complexQueue
    // Cond 2: io.in is equals to 1 and io.out is equals to 1, thus it is a simpleQueue
    io.in.zip(queues).foreach { case (i, j) => i <> j.io.enq }
  } else {
    // It is a complexQueue with 1 input and multiple output
    val enq_all_ready = queues.map(_.io.enq.ready).reduce(_ & _)
    io.in.head.ready := enq_all_ready
    // Only when all signals are ready, then valid signals in each channels can be passed to FIFO
    queues.foreach(i => i.io.enq.valid := enq_all_ready & io.in.head.valid)
    // Connect all data
    queues.zipWithIndex.foreach {
      case (queue, i) => {
        queue.io.enq.bits := io.in.head
          .bits(i * smallWidth + smallWidth - 1, i * smallWidth)
      }
    }
  }

  // The same thing for the output
  if (io.out.length != 1 || (io.in.length == 1 && io.out.length == 1)) {
    // Cond 1: io.out is not equals to 1, thus it is a complexQueue
    // Cond 2: io.in is equals to 1 and io.out is equals to 1, thus it is a simpleQueue
    io.out.zip(queues).foreach { case (i, j) => i <> j.io.deq }
  } else {
    // It is a complexQueue with 1 output and multiple input
    val deq_all_valid = queues.map(_.io.deq.valid).reduce(_ & _)
    io.out.head.valid := deq_all_valid
    // Only when all signals are valid, then ready signals in each channels can be passed to FIFO
    queues.foreach(i => i.io.deq.ready := deq_all_valid & io.out.head.ready)
    // Connect all data
    io.out.foreach(_.bits := queues.map(i => i.io.deq.bits).reduce { (a, b) =>
      Cat(b, a)
    })
  }

  // All empty signal is a debug signal and derived from sub channels: if all fifo is empty, then this signal is empty
  io.allEmpty := queues.map(queue => ~(queue.io.deq.valid)).reduce(_ & _)

  // Any full signal is a debug signal and derived from sub channels: if any fifo is full, then this signal is full
  io.anyFull := queues.map(queue => ~(queue.io.enq.ready)).reduce(_ | _)
}

/** The complexQueue to do N-channels in / 1 N-Vec channel out. The user defined
  * params include:
  * @param dataType:
  *   the type of one channel
  * @param N:
  *   the number of seperated channels at the input
  * @param depth:
  *   the depth of the FIFO If inputWidth is smaller than outputWidth, then it
  *   will be the first option If inputWidth is larger than outputWidth, then it
  *   will be the second option No matter which case, the big width one should
  *   equal to integer times of the small width one
  */
class ComplexQueueNtoOne[T <: Data](dataType: T, N: Int, depth: Int)
    extends Module
    with RequireAsyncReset {
  require(
    N > 1,
    message = "N should be greater than 1"
  )
  require(depth > 0)

  val queueModuleName =
    "Queue_W" + dataType.getWidth.toString + "_D" + depth.toString + "_H" + BigInt(
      numbits = 30,
      scala.util.Random
    ).toString(radix = 32)

  val io = IO(new Bundle {
    val in = Flipped(Vec(N, Decoupled(dataType)))
    val out = Decoupled(Vec(N, dataType))
    val allEmpty = Output(Bool())
    val anyFull = Output(Bool())
  })

  val queues = for (i <- 0 until N) yield {
    Module(new Queue(dataType, depth) {
      override val desiredName = queueModuleName
    })
  }

  io.in.zip(queues).foreach { case (i, j) => i <> j.io.enq }
  io.out.bits.zip(queues).foreach { case (i, j) => i := j.io.deq.bits }
  io.out.valid := queues.map(i => i.io.deq.valid).reduce(_ & _)
  val dequeue_ready = io.out.valid & io.out.ready
  queues.foreach(_.io.deq.ready := dequeue_ready)

  // All empty signal is a debug signal and derived from sub channels: if all fifo is empty, then this signal is empty
  io.allEmpty := queues.map(queue => ~(queue.io.deq.valid)).reduce(_ & _)

  // Any full signal is a debug signal and derived from sub channels: if any fifo is full, then this signal is full
  io.anyFull := queues.map(queue => ~(queue.io.enq.ready)).reduce(_ | _)
}

/** The complexQueue to do 1 N-Vec channel in / N-channels out. The user defined
  * params include:
  * @param dataType:
  *   the type of one channel
  * @param N
  *
  * @param depth:
  *   the depth of the FIFO If inputWidth is smaller than outputWidth, then it
  *   will be the first option If inputWidth is larger than outputWidth, then it
  *   will be the second option No matter which case, the big width one should
  *   equal to integer times of the small width one
  */

class ComplexQueueOnetoN[T <: Data](dataType: T, N: Int, depth: Int)
    extends Module
    with RequireAsyncReset {
  require(
    N > 1,
    message = "N should be greater than 1"
  )
  require(depth > 0)

  val queueModuleName =
    "Queue_W" + dataType.getWidth.toString + "_D" + depth.toString + "_H" + BigInt(
      numbits = 30,
      scala.util.Random
    ).toString(radix = 32)

  val io = IO(new Bundle {
    val in = Flipped(Decoupled(Vec(N, dataType)))
    val out = Vec(N, Decoupled(dataType))
    val allEmpty = Output(Bool())
    val anyFull = Output(Bool())
  })

  val queues = for (i <- 0 until N) yield {
    Module(new Queue(dataType, depth) {
      override val desiredName = queueModuleName
    })
  }

  io.out.zip(queues).foreach { case (i, j) => i <> j.io.deq }
  io.in.bits.zip(queues).foreach { case (i, j) => j.io.enq.bits := i }
  io.in.ready := queues.map(i => i.io.enq.ready).reduce(_ & _)
  val enqueue_valid = io.in.valid & io.in.ready
  queues.foreach(_.io.enq.valid := enqueue_valid)

  // All empty signal is a debug signal and derived from sub channels: if all fifo is empty, then this signal is empty
  io.allEmpty := queues.map(queue => ~(queue.io.deq.valid)).reduce(_ & _)

  // Any full signal is a debug signal and derived from sub channels: if any fifo is full, then this signal is full
  io.anyFull := queues.map(queue => ~(queue.io.enq.ready)).reduce(_ | _)
}

object ComplexQueueEmitter extends App {
  println(getVerilogString(new ComplexQueueConcat(64, 512, 16)))
  println(getVerilogString(new ComplexQueueConcat(512, 64, 16)))
  println(getVerilogString(new ComplexQueueConcat(64, 64, 16)))
}
