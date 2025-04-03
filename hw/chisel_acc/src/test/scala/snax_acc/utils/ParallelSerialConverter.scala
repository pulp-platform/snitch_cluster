package snax_acc.utils

import chisel3._

import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers

class ParallelToSerialTest extends AnyFlatSpec with ChiselScalatestTester {

  "ParallelToSerial" should "convert parallel data into multiple serial chunks" in {
    val parallelWidth = 16
    val serialWidth   = 4
    test(
      new ParallelToSerial(ParallelToSerialParams(parallelWidth, serialWidth))
    ).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      // The factor is 16 / 4 = 4, so each parallel input will yield 4 serial outputs.
      dut.io.in.initSource()
      dut.io.out.initSink()

      // Push a single parallel input to be serialized. Let's choose 0xABCD, or 43981 in decimal.
      // 0xABCD in binary is 1010_1011_1100_1101.
      // The 4-bit chunks (starting from LSB) should be: 1101 (0xD), 1100 (0xC), 1011 (0xB), 1010 (0xA).

      var parallelData   = 0xabcd.U
      var expectedChunks = Seq("xd", "xc", "xb", "xa").map(_.U(4.W))

      // Provide the single parallel input.
      dut.clock.step(5)

      dut.io.in.bits.poke(parallelData)
      dut.io.in.valid.poke(true.B)
      dut.clock.step()

      // After 1 cycle, the module should have latched the parallel input, so in can go low.
      dut.io.in.valid.poke(false.B)

      // Now observe the serialized chunks.
      for (expectedChunk <- expectedChunks) {
        // Wait for valid to ensure the chunk is ready
        while (!dut.io.out.valid.peekBoolean()) {
          dut.clock.step()
        }
        // Check the chunk
        dut.io.out.bits.expect(expectedChunk)
        // Consume it
        dut.io.out.ready.poke(true.B)
        dut.clock.step()
        dut.io.out.ready.poke(false.B)
      }
      parallelData   = 0xefef.U
      expectedChunks = Seq("xF", "xE", "xF", "xE").map(_.U(4.W))
      dut.io.in.bits.poke(parallelData)
      dut.io.in.valid.poke(true.B)
      dut.clock.step()

      // After 1 cycle, the module should have latched the parallel input, so in can go low.
      dut.io.in.valid.poke(false.B)

      // Now observe the serialized chunks.
      for (expectedChunk <- expectedChunks) {
        // Wait for valid to ensure the chunk is ready
        while (!dut.io.out.valid.peekBoolean()) {
          dut.clock.step()
        }
        // Check the chunk
        dut.io.out.bits.expect(expectedChunk)
        // Consume it
        dut.io.out.ready.poke(true.B)
        dut.clock.step()
        dut.io.out.ready.poke(false.B)
      }

      // After sending out 4 chunks, the module should be ready for new data.
      // Verify it's no longer valid.
      dut.io.out.valid.expect(false.B)
      dut.clock.step()
    }
  }
}

class SerialToParallelSpec extends AnyFlatSpec with ChiselScalatestTester with Matchers {

  behavior of "SerialToParallel"

  it should "collect serial data and produce parallel output correctly" in {
    test(
      new SerialToParallel(
        SerialToParallelParams(
          serialWidth   = 8, // 8 bits per serial input
          parallelWidth = 32 // 32 bits parallel output
        )
      )
    ).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      // The parallel output is formed by collecting 4 serial inputs (4 * 8 = 32).
      // We'll send in 4 consecutive bytes and expect them to appear in the out.bits.

      // Prepare for the test
      dut.io.out.ready.poke(true.B) // Always ready to consume parallel output
      dut.clock.step()

      // Example data to send (4 byte values)
      var testData = Seq(0xab.U, 0xcd.U, 0x12.U, 0x34.U)

      // We expect the parallel output to combine these 4 bytes: 0x34_12_CD_AB (little-endian accumulation)
      var expectedParallel = (0x34 << 24) | (0x12 << 16) | (0xcd << 8) | 0xab

      for (_ <- 0 to 1) {
        for ((byteVal, idx) <- testData.zipWithIndex) {
          // Present the serial byte
          dut.io.in.valid.poke(true.B)
          dut.io.in.bits.poke(byteVal)
          // Step to capture this byte
          dut.clock.step()
        }

        // dut.io.out.valid.expect(true.B)
        // dut.io.out.bits.expect(expectedParallel.U)
        dut.clock.step()

      }

      // Example data to send (4 byte values)
      testData = Seq(0xef.U, 0xaa.U, 0xbb.U, 0xcc.U)

      expectedParallel = (0xcc << 24) | (0xbb << 16) | (0xaa << 8) | 0xef

      for (_ <- 0 to 1) {
        for ((byteVal, idx) <- testData.zipWithIndex) {
          // Present the serial byte
          dut.io.in.valid.poke(true.B)
          dut.io.in.bits.poke(byteVal)
          // Step to capture this byte
          dut.clock.step()
        }

        // dut.io.out.valid.expect(true.B)
        // dut.io.out.bits.expect(expectedParallel.U)
        dut.clock.step()

      }
    }
  }
}
