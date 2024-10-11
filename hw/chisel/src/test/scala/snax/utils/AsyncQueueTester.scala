package snax.utils

import chisel3._
import org.scalatest.flatspec.AnyFlatSpec
import chiseltest._

class AsyncQueueMultiClockShell[T <: Data](dataType: T, depth: Int)
    extends Module
    with RequireAsyncReset {
  val dut = Module(new AsyncQueue(dataType, depth))
  val io = IO(new Bundle {
    val enq = new Bundle {
      val clock = Input(Bool())
      val data = chiselTypeOf(dut.io.enq.data)
    }
    val deq = new Bundle {
      val clock = Input(Bool())
      val data = chiselTypeOf(dut.io.deq.data)
    }
  })
  dut.io.enq.clock := io.enq.clock.asClock
  dut.io.enq.data <> io.enq.data
  dut.io.deq.clock := io.deq.clock.asClock
  dut.io.deq.data <> io.deq.data
}

class AsyncQueueTester extends AnyFlatSpec with ChiselScalatestTester {
  "AsyncQueue Test" should "pass" in {
    test(new AsyncQueueMultiClockShell(UInt(8.W), 16))
      .withAnnotations(Seq(WriteVcdAnnotation, VerilatorBackendAnnotation)) {
        dut =>
          var inputClock = false
          var outputClock = false
          val dataBuffer = scala.collection.mutable.Queue[Int]()

          var concurrentThreads =
            new chiseltest.internal.TesterThreadList(Seq())
          var testTerminated = false

          // Two clock signals
          concurrentThreads = concurrentThreads.fork {
            while (!testTerminated) {
              dut.io.enq.clock.poke(inputClock.B)
              inputClock = !inputClock
              dut.clock.step(7)
            }
          }
          concurrentThreads = concurrentThreads.fork {
            while (!testTerminated) {
              dut.io.deq.clock.poke(outputClock.B)
              outputClock = !outputClock
              dut.clock.step(3)
            }
          }
          concurrentThreads = concurrentThreads.fork {
            while (!testTerminated) {
              if (dut.io.enq.data.ready.peek().litToBoolean) {
                val randomData = scala.util.Random.nextInt(256)
                dut.io.enq.data.valid.poke(true.B)
                dut.io.enq.data.bits.poke(randomData.U)
                dataBuffer.enqueue(randomData)
              } else {
                dut.io.enq.data.valid.poke(false.B)
              }
              dut.clock.step(14)
            }
          }

          concurrentThreads = concurrentThreads.fork {
            // Simulate the full condition
            dut.clock.step(6 * 40)
            // Simulate the empty condition
            while (!testTerminated) {
              if (dut.io.deq.data.valid.peek().litToBoolean) {
                val data = dataBuffer.dequeue()
                dut.io.deq.data.ready.poke(true.B)
                dut.io.deq.data.bits.expect(data.U)
              } else {
                dut.io.deq.data.ready.poke(false.B)
              }
              dut.clock.step(6)
            }
          }

          concurrentThreads = concurrentThreads.fork {
            dut.clock.step(500)
            testTerminated = true
          }

          concurrentThreads.joinAndStep()
      }
  }
}

// This test is aiming to emulate Mace's condition where the relationship between two clocks is 4:1, to see if the AsyncQueue can work without bottleneck.
// Target: The slower clock side's transmission is continuous.
class AsyncQueueMaceTester extends AnyFlatSpec with ChiselScalatestTester {
  "AsyncQueue Test Slow -> Fast" should "pass" in {
    test(new AsyncQueueMultiClockShell(UInt(8.W), 4))
      .withAnnotations(Seq(WriteVcdAnnotation, VerilatorBackendAnnotation)) {
        dut =>
          var inputClock = false
          var outputClock = false
          val dataBuffer = scala.collection.mutable.Queue[Int]()

          var concurrentThreads =
            new chiseltest.internal.TesterThreadList(Seq())
          var testTerminated = false

          // Two clock signals
          concurrentThreads = concurrentThreads.fork {
            while (!testTerminated) {
              dut.io.enq.clock.poke(inputClock.B)
              inputClock = !inputClock
              dut.clock.step(4)
            }
          }
          concurrentThreads = concurrentThreads.fork {
            while (!testTerminated) {
              dut.io.deq.clock.poke(outputClock.B)
              outputClock = !outputClock
              dut.clock.step(1)
            }
          }
          concurrentThreads = concurrentThreads.fork {
            while (!testTerminated) {
              if (dut.io.enq.data.ready.peek().litToBoolean) {
                val randomData = scala.util.Random.nextInt(256)
                dut.io.enq.data.valid.poke(true.B)
                dut.io.enq.data.bits.poke(randomData.U)
                dataBuffer.enqueue(randomData)
              } else {
                dut.io.enq.data.valid.poke(false.B)
              }
              dut.clock.step(8)
            }
          }

          concurrentThreads = concurrentThreads.fork {
            while (!testTerminated) {
              if (dut.io.deq.data.valid.peek().litToBoolean) {
                val data = dataBuffer.dequeue()
                dut.io.deq.data.ready.poke(true.B)
                dut.io.deq.data.bits.expect(data.U)
              } else {
                dut.io.deq.data.ready.poke(false.B)
              }
              dut.clock.step(2)
            }
          }

          concurrentThreads = concurrentThreads.fork {
            dut.clock.step(500)
            testTerminated = true
          }

          concurrentThreads.joinAndStep()
      }
  }

  "AsyncQueue Test Fast -> Slow" should "pass" in {
    test(new AsyncQueueMultiClockShell(UInt(8.W), 4))
      .withAnnotations(Seq(WriteVcdAnnotation, VerilatorBackendAnnotation)) {
        dut =>
          var inputClock = false
          var outputClock = false
          val dataBuffer = scala.collection.mutable.Queue[Int]()

          var concurrentThreads =
            new chiseltest.internal.TesterThreadList(Seq())
          var testTerminated = false

          // Two clock signals
          concurrentThreads = concurrentThreads.fork {
            while (!testTerminated) {
              dut.io.enq.clock.poke(inputClock.B)
              inputClock = !inputClock
              dut.clock.step(1)
            }
          }
          concurrentThreads = concurrentThreads.fork {
            while (!testTerminated) {
              dut.io.deq.clock.poke(outputClock.B)
              outputClock = !outputClock
              dut.clock.step(4)
            }
          }
          concurrentThreads = concurrentThreads.fork {
            while (!testTerminated) {
              if (dut.io.enq.data.ready.peek().litToBoolean) {
                val randomData = scala.util.Random.nextInt(256)
                dut.io.enq.data.valid.poke(true.B)
                dut.io.enq.data.bits.poke(randomData.U)
                dataBuffer.enqueue(randomData)
              } else {
                dut.io.enq.data.valid.poke(false.B)
              }
              dut.clock.step(2)
            }
          }

          concurrentThreads = concurrentThreads.fork {
            while (!testTerminated) {
              if (dut.io.deq.data.valid.peek().litToBoolean) {
                val data = dataBuffer.dequeue()
                dut.io.deq.data.ready.poke(true.B)
                dut.io.deq.data.bits.expect(data.U)
              } else {
                dut.io.deq.data.ready.poke(false.B)
              }
              dut.clock.step(8)
            }
          }

          concurrentThreads = concurrentThreads.fork {
            dut.clock.step(500)
            testTerminated = true
          }

          concurrentThreads.joinAndStep()
      }
  }
}
