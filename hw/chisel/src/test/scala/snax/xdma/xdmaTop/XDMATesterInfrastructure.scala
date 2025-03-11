package snax.xdma.xdmaTop
import chisel3._
import chisel3.util._
import chiseltest._

import snax.csr_manager.SnaxCsrIO


class AGUParamTest(
    val address: Long,
    val spatialStrides: Array[Int],
    val temporalStrides: Array[Int],
    val temporalBounds: Array[Int]
)

class RWParamTest(
    val enabledChannel: Int,
    val enabledByte: Int
)

class ExtParam(
    val bypassMemset: Int,
    val memsetValue: Int,
    val bypassMaxPool: Int,
    val maxPoolPeriod: Int,
    val bypassTransposer: Int
)

object XDMATesterInfrastructure{
  def write_csr(dut: Module, port: SnaxCsrIO, addr: Int, data: Int) = {

    // give the data and address to the right ports
    port.req.bits.write.poke(true.B)

    port.req.bits.data.poke(data.U)
    port.req.bits.addr.poke(addr.U)
    port.req.valid.poke(1.B)

    // wait for grant
    while (port.req.ready.peekBoolean() == false) {

      dut.clock.step(1)
    }

    dut.clock.step(1)

    port.req.valid.poke(0.B)
  }

  def read_csr(dut: Module, port: SnaxCsrIO, addr: Int) = {
    dut.clock.step(1)

    // give the data and address to the right ports
    port.req.bits.write.poke(0.B)
    port.req.bits.addr.poke(addr.U)
    port.req.valid.poke(1.B)

    // wait for grant
    while (port.req.ready.peekBoolean() == false) {
      dut.clock.step(1)
    }
    dut.clock.step(1)
    port.req.valid.poke(0.B)

    port.rsp.ready.poke(true)
    // wait for valid signal
    while (port.rsp.valid.peekBoolean() == false) {
      dut.clock.step(1)
    }
    val result = port.rsp.bits.data.peekInt()
    dut.clock.step(1)
    port.rsp.ready.poke(false)

    result
  }

  def setXDMA(readerAGUParam: AGUParamTest, writerAGUParam: AGUParamTest, readerRWParam: RWParamTest, writerRWParam: RWParamTest, writerExtParam: ExtParam, dut: Module, port: SnaxCsrIO):Int = {
    var currentAddress = 0

        // Pointer Address
        // Reader Side
        write_csr(
          dut = dut,
          port = port,
          addr = currentAddress,
          data = (readerAGUParam.address & 0xffff_ffff).toInt
        )
        currentAddress += 1
        write_csr(
          dut = dut,
          port = port,
          addr = currentAddress,
          data = ((readerAGUParam.address >> 32) & 0xffff_ffff).toInt
        )
        currentAddress += 1

        // Writer Side
        // Ptr 0
        write_csr(
          dut = dut,
          port = port,
          addr = currentAddress,
          data = (writerAGUParam.address & 0xffff_ffff).toInt
        )
        currentAddress += 1
        write_csr(
          dut = dut,
          port = port,
          addr = currentAddress,
          data = ((writerAGUParam.address >> 32) & 0xffff_ffff).toInt
        )
        currentAddress += 1

        // Ptr 1-3 is 0
        currentAddress += 6

        // Reader side Strides + Bounds
        readerAGUParam.spatialStrides.foreach { i =>
          write_csr(
            dut = dut,
            port = port,
            addr = currentAddress,
            data = i
          )
          currentAddress += 1
        }

        readerAGUParam.temporalBounds.foreach { i =>
          write_csr(
            dut = dut,
            port = port,
            addr = currentAddress,
            data = i
          )
          currentAddress += 1
        }

        readerAGUParam.temporalStrides.foreach { i =>
          write_csr(
            dut = dut,
            port = port,
            addr = currentAddress,
            data = i
          )
          currentAddress += 1
        }

        // Enabled Channel and Byte
        write_csr(
          dut = dut,
          port = port,
          addr = currentAddress,
          data = readerRWParam.enabledChannel
        )
        currentAddress += 1
        // Enabled Byte is not valid for the reader
        // No extension for the reader

        // Writer side Strides + Bounds
        writerAGUParam.spatialStrides.foreach { i =>
          write_csr(
            dut = dut,
            port = port,
            addr = currentAddress,
            data = i
          )
          currentAddress += 1
        }

        writerAGUParam.temporalBounds.foreach { i =>
          write_csr(
            dut = dut,
            port = port,
            addr = currentAddress,
            data = i
          )
          currentAddress += 1
        }

        writerAGUParam.temporalStrides.foreach { i =>
          write_csr(
            dut = dut,
            port = port,
            addr = currentAddress,
            data = i
          )
          currentAddress += 1
        }

        // Enabled Channel and Byte
        write_csr(
          dut = dut,
          port = port,
          addr = currentAddress,
          data = writerRWParam.enabledChannel
        )
        currentAddress += 1
        write_csr(
          dut = dut,
          port = port,
          addr = currentAddress,
          data = writerRWParam.enabledByte
        )
        currentAddress += 1

        // Data Extension Region
        // Bypass signals
        write_csr(
          dut = dut,
          port = port,
          addr = currentAddress,
          data =
            (writerExtParam.bypassMemset << 0) + (writerExtParam.bypassMaxPool << 1) + (writerExtParam.bypassTransposer << 2)
        )
        currentAddress += 1

        write_csr(
          dut = dut,
          port = port,
          addr = currentAddress,
          data = writerExtParam.memsetValue
        )
        currentAddress += 1

        write_csr(
          dut = dut,
          port = port,
          addr = currentAddress,
          data = writerExtParam.maxPoolPeriod
        )
        currentAddress += 1

        // Start the DMA
        write_csr(
          dut = dut,
          port = port,
          addr = currentAddress,
          data = 1
        )
        currentAddress += 1
        currentAddress
  }
}