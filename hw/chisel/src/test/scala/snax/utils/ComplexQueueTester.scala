package snax.utils

import chisel3._
import org.scalatest.flatspec.AnyFlatSpec
import chiseltest._
import snax.utils.ComplexQueueConcat

class ComplexQueueConcatTester extends AnyFlatSpec with ChiselScalatestTester {
  "The test of complexQueue (64->512)" should " pass" in {
    test(new ComplexQueueConcat(64, 512, 16))
      .withAnnotations(Seq(WriteVcdAnnotation, VerilatorBackendAnnotation)) {
        dut =>
          // Can store 128 data
          // Writing data
          for (i <- 0 until 128) {
            dut.io.in(i % 8).bits.poke(i)
            dut.io.in(i % 8).valid.poke(true.B)
            dut.io.in(i % 8).ready.expect(true.B)
            dut.clock.step()
            dut.io.in(i % 8).valid.poke(false.B)
            print("Input " + i + " is passed. ")
          }
          // Can pop 16 512-bit data
          dut.io.out(0).ready.poke(true.B)
          for (i <- 0 until 16) {
            dut.io
              .out(0)
              .bits
              .expect(
                (BigInt(i * 8 + 7) << (64 * 7)) + (BigInt(
                  i * 8 + 6
                ) << (64 * 6)) + (BigInt(
                  i * 8 + 5
                ) << (64 * 5)) + (BigInt(i * 8 + 4) << (64 * 4)) + (BigInt(
                  i * 8 + 3
                ) << (64 * 3)) + (BigInt(
                  i * 8 + 2
                ) << (64 * 2)) + (BigInt(i * 8 + 1) << (64 * 1)) + (BigInt(
                  i * 8 + 0
                ) << (64 * 0))
              )
            print("Output " + i + " is passed. ")
            dut.clock.step()
          }
          dut.clock.step()
      }
  }

  "The test of complexQueue (512->64)" should " pass" in {
    test(new ComplexQueueConcat(512, 64, 16))
      .withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
        // Can store 16 512-bit data
        // Writing data
        for (i <- 0 until 16) {
          dut.io
            .in(0)
            .bits
            .poke(
              (BigInt(i * 8 + 7) << (64 * 7)) + (BigInt(
                i * 8 + 6
              ) << (64 * 6)) + (BigInt(
                i * 8 + 5
              ) << (64 * 5)) + (BigInt(i * 8 + 4) << (64 * 4)) + (BigInt(
                i * 8 + 3
              ) << (64 * 3)) + (BigInt(
                i * 8 + 2
              ) << (64 * 2)) + (BigInt(i * 8 + 1) << (64 * 1)) + (BigInt(
                i * 8 + 0
              ) << (64 * 0))
            )
          dut.io.in(0).valid.poke(true.B)
          dut.io.in(0).ready.expect(true.B)
          dut.clock.step()
          dut.io.in(0).valid.poke(false.B)
          print("Input " + i + " is passed. ")
        }
        // Can pop 128 64-bit data
        dut.io.out(0).ready.poke(true.B)
        for (i <- 0 until 128) {
          dut.io.out(i % 8).ready.poke(true.B)
          dut.io.out(i % 8).bits.expect(i)
          dut.clock.step()
          dut.io.out(i % 8).ready.poke(false.B)
          print("Output " + i + " is passed. ")

        }
      }
  }
}
