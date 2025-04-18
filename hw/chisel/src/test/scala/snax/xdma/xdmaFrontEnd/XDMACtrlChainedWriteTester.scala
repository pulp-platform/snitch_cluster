package snax.xdma.xdmaFrontend

import scala.util.Random
import scala.util.control.Breaks.break
import scala.util.control.Breaks.breakable

import chisel3._

import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import snax.csr_manager._
import snax.readerWriter.ReaderWriterParam
import snax.xdma.DesignParams._

class XDMACtrlChainedWriteTester extends AnyFlatSpec with ChiselScalatestTester {

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

  def extractBits(in: BigInt, upper: Int, lower: Int): BigInt = {
    var temp = in >> lower
    temp = temp & ((BigInt(1) << (upper - lower + 1)) - 1)
    temp
  }

  "The XDMACtrl Chained Write Test" should " pass" in {
    test(
      new XDMACtrl(
        readerparam = new XDMAParam(
          new AXIParam,
          new CrossClusterParam(4),
          new ReaderWriterParam(
            configurableChannel  = true,
            configurableByteMask = false
          ),
          Seq()
        ),
        writerparam = new XDMAParam(
          new AXIParam,
          new CrossClusterParam(4),
          new ReaderWriterParam(
            configurableChannel  = true,
            configurableByteMask = true
          ),
          Seq()
        )
      )
    ).withAnnotations(Seq(WriteVcdAnnotation, VerilatorBackendAnnotation)) { dut =>
      val clusterBaseAddress = 0x1000_0000
      dut.io.clusterBaseAddress.poke(clusterBaseAddress)

      // The threads list (empty at the beginning)
      var concurrent_threads    = new chiseltest.internal.TesterThreadList(Seq())
      val unreceived_reader_cfg = new collection.mutable.HashSet[Int]()
      val unreceived_writer_cfg = new collection.mutable.HashSet[Int]()
      var testTerminated        = false

      val endedThreadList = new collection.mutable.HashSet[String]()

      dut.clock.setTimeout(0)

      // The thread to push the data inside the Ctrl from local side and remote side
      concurrent_threads = concurrent_threads.fork {
        val Reader_PointerAddress   = BigInt(0x1000_0000)
        // Under This Configurations, the full TCDM will be copied
        val Reader_Spatial_Strides  = List(8)
        val Reader_Temporal_Bounds  = List(32, 64)
        val Reader_Temporal_Strides = List(64, 2048)

        val Writer_PointerAddress   =
          List(
            BigInt(0x1000_0000) + (1 << 20),
            BigInt(0x1000_0000) + (2 << 20),
            BigInt(0x1000_0000) + (3 << 20),
            BigInt(0x1000_0000) + (4 << 20)
          )
        // Under This Configurations, the full TCDM will be copied
        val Writer_Spatial_Strides  = List(32)
        val Writer_Temporal_Bounds  = List(32, 16)
        val Writer_Temporal_Strides = List(256, 8192)

        for (i <- 0 until 256 by 2) {
          if (testTerminated) break()
          if (Random.between(0, 2) == 0) {
            // Local Cfg injection
            // Applying Data into the CSRManager
            var currentCSR = 0x0

            val Reader_PointerAddress_ThisLoop =
              Reader_PointerAddress + i
            val Writer_PointerAddress_ThisLoop =
              Writer_PointerAddress.updated(
                0,
                Writer_PointerAddress(0) + Random.between(
                  0,
                  2
                ) * 256 * 1024 + i + 1
              )
            unreceived_reader_cfg.add(Reader_PointerAddress_ThisLoop.toInt)
            unreceived_writer_cfg.add(Writer_PointerAddress_ThisLoop(0).toInt)

            // Reader: Pointers LSB + MSB
            write_csr(
              dut,
              dut.io.csrIO,
              addr = currentCSR,
              data = (Reader_PointerAddress_ThisLoop & 0xffff_ffff).toInt
            )
            currentCSR += 1
            write_csr(
              dut,
              dut.io.csrIO,
              addr = currentCSR,
              data = ((Reader_PointerAddress_ThisLoop >> 32) & 0xffff_ffff).toInt
            )
            currentCSR += 1

            // Writer: Pointers LSB + MSB
            Writer_PointerAddress_ThisLoop.foreach { i =>
              write_csr(
                dut,
                dut.io.csrIO,
                addr = currentCSR,
                data = ((i) & 0xffff_ffff).toInt
              )
              currentCSR += 1
              write_csr(
                dut,
                dut.io.csrIO,
                addr = currentCSR,
                data = (((i) >> 32) & 0xffff_ffff).toInt
              )
              currentCSR += 1
            }

            // Reader: Spatial Strides D0
            Reader_Spatial_Strides.foreach({ i =>
              write_csr(dut, dut.io.csrIO, addr = currentCSR, data = i)
              currentCSR += 1
            })
            // Reader: Temporal Strides D0 -> D1
            Reader_Temporal_Strides.foreach({ i =>
              write_csr(dut, dut.io.csrIO, addr = currentCSR, data = i)
              currentCSR += 1
            })
            // Reader: Temporal Strides D2 -> D5
            for (_ <- 0 until 3) {
              write_csr(dut, dut.io.csrIO, addr = currentCSR, data = 0)
              currentCSR += 1
            }
            // Reader: Temporal Bounds D0 -> D1
            Reader_Temporal_Bounds.foreach({ i =>
              write_csr(dut, dut.io.csrIO, addr = currentCSR, data = i)
              currentCSR += 1
            })
            // Reader: Temporal Bounds D2 -> D5
            for (i <- 0 until 3) {
              write_csr(dut, dut.io.csrIO, addr = currentCSR, data = 1)
              currentCSR += 1
            }
            // Enabled Channels
            write_csr(dut, dut.io.csrIO, addr = currentCSR, data = 0xff)
            currentCSR += 1

            // Writer: Spatial Strides D0
            Writer_Spatial_Strides.foreach({ i =>
              write_csr(dut, dut.io.csrIO, addr = currentCSR, data = i)
              currentCSR += 1
            })
            // Writer: Temporal Strides D0 -> D1
            Writer_Temporal_Strides.foreach({ i =>
              write_csr(dut, dut.io.csrIO, addr = currentCSR, data = i)
              currentCSR += 1
            })
            // Writer: Temporal Strides D2 -> D5
            for (i <- 0 until 3) {
              write_csr(dut, dut.io.csrIO, addr = currentCSR, data = 0)
              currentCSR += 1
            }
            // Writer: Temporal Bounds D0 -> D1
            Writer_Temporal_Bounds.foreach({ i =>
              write_csr(dut, dut.io.csrIO, addr = currentCSR, data = i)
              currentCSR += 1
            })
            // Writer: Temporal Bounds D2 -> D5
            for (i <- 0 until 3) {
              write_csr(dut, dut.io.csrIO, addr = currentCSR, data = 1)
              currentCSR += 1
            }
            // Enabled Channels
            write_csr(dut, dut.io.csrIO, addr = currentCSR, data = 0xff)
            currentCSR += 1
            // Enabled Byte
            write_csr(dut, dut.io.csrIO, addr = currentCSR, data = 0xff)
            currentCSR += 1
            // Commit the config
            write_csr(dut, dut.io.csrIO, addr = currentCSR, data = 1)
            println(
              "[Local Reader Generator] " + Reader_PointerAddress_ThisLoop.toInt.toHexString
            )
            println(
              "[Local Writer Generator] " + Writer_PointerAddress_ThisLoop(
                0
              ).toInt.toHexString
            )

          } else {
            // Remote Cfg injection (Writer side)
            unreceived_writer_cfg.add(
              (Writer_PointerAddress(0) + i - (1 << 20)).toInt
            )
            unreceived_writer_cfg.add((Writer_PointerAddress(1) + i).toInt)
            val writerRemoteConfig: BigInt =
              (1 << 8) +
                // The address for the reader side
                ((Reader_PointerAddress + i + (1 << 20)) << 9) +
                // The address for the writer side
                ((Writer_PointerAddress(0) + i - (1 << 20)) << 57) +
                ((Writer_PointerAddress(1) + i) << 105) +
                (Writer_PointerAddress(2) << 153) +
                (Writer_PointerAddress(3) << 201)

            dut.io.remoteXDMACfg.fromRemote.bits
              .poke(writerRemoteConfig)
            dut.clock.step(Random.between(1, 31))
            dut.io.remoteXDMACfg.fromRemote.valid.poke(true.B)
            while (
              !(dut.io.remoteXDMACfg.fromRemote.ready
                .peekBoolean())
            ) {
              dut.clock.step()
            }
            dut.clock.step()
            dut.io.remoteXDMACfg.fromRemote.valid.poke(false.B)
            println(
              "[Remote Writer Generator] The CFG with chained write destination of " + (Writer_PointerAddress(
                0
              ) + i - (1 << 20)).toInt.toHexString + " and " + (Writer_PointerAddress(
                1
              ) + i).toInt.toHexString + " is sent to XDMACtrl"
            )
          }
        }
        endedThreadList.add("Generator")
        println("Generator thread is terminated. ")
      }

      // The thread to pop the data outside the Ctrl from local reader side
      concurrent_threads = concurrent_threads.fork {
        breakable(
          while (true) {
            while (!dut.io.localXDMACfg.readerStart.peekBoolean()) {
              dut.clock.step()
              if (testTerminated) break()
            }
            println(
              "[Local Reader Checker] " + dut.io.localXDMACfg.readerCfg.readerPtr
                .peekInt()
                .toInt
                .toHexString
            )

            if (
              unreceived_reader_cfg
                .find(_ == dut.io.localXDMACfg.readerCfg.readerPtr.peekInt())
                .isDefined
            ) {
              unreceived_reader_cfg.remove(
                dut.io.localXDMACfg.readerCfg.readerPtr.peekInt().toInt
              )
            } else {
              throw new Exception(
                // println(
                "[Local Reader Checker] The received pointer " + dut.io.localXDMACfg.readerCfg.readerPtr
                  .peekInt()
                  .toInt
                  .toHexString + " is not in the buffer"
              )
            }

            dut.clock.step(Random.between(1, 16) + 32)
            dut.io.localXDMACfg.readerBusy.poke(true)
            dut.clock.step(Random.between(1, 16) + 32)
            dut.io.localXDMACfg.readerBusy.poke(false)
          }
        )
        println("Local Reader Checker is terminated. ")
      }

      // The thread to pop the data outside the Ctrl from local writer side
      concurrent_threads = concurrent_threads.fork {
        breakable(
          while (true) {
            while (!dut.io.localXDMACfg.writerStart.peekBoolean()) {
              dut.clock.step()
              if (testTerminated) break()
            }
            println(
              "[Local Writer Checker] " + dut.io.localXDMACfg.writerCfg
                .writerPtr(0)
                .peekInt()
                .toInt
                .toHexString
            )

            if (
              unreceived_writer_cfg
                .find(
                  _ == dut.io.localXDMACfg.writerCfg.writerPtr(0).peekInt()
                )
                .isDefined
            ) {
              unreceived_writer_cfg.remove(
                dut.io.localXDMACfg.writerCfg.writerPtr(0).peekInt().toInt
              )
            } else {
              throw new Exception(
                // println(
                "[Local Writer Checker] The received pointer " + dut.io.localXDMACfg.writerCfg
                  .writerPtr(0)
                  .peekInt()
                  .toInt
                  .toHexString + " is not in the buffer"
              )
            }

            dut.clock.step(Random.between(1, 16) + 32)
            dut.io.localXDMACfg.writerBusy.poke(true)
            dut.clock.step(Random.between(1, 16) + 32)
            dut.io.localXDMACfg.writerBusy.poke(false)
          }
        )
        println("Local Writer Checker is terminated. ")
      }

      // The thread to pop the data outside the Ctrl from remote side
      concurrent_threads = concurrent_threads.fork {
        dut.io.remoteXDMACfg.toRemote.ready.poke(false)
        breakable(
          while (true) {
            if (testTerminated) break()
            if (dut.io.remoteXDMACfg.toRemote.valid.peekBoolean()) {
              if (
                extractBits(
                  dut.io.remoteXDMACfg.toRemote.bits.peekInt(),
                  8,
                  8
                ) == 0
              ) {
                println(
                  "[Remote Reader Checker] " + extractBits(
                    dut.io.remoteXDMACfg.toRemote.bits
                      .peekInt(),
                    56,
                    9
                  ).toInt.toHexString
                )
                if (
                  !unreceived_reader_cfg.remove(
                    extractBits(
                      dut.io.remoteXDMACfg.toRemote.bits
                        .peekInt(),
                      56,
                      9
                    ).toInt
                  )
                )
                  throw new Exception(
                    "[Remote Reader Checker] The received pointer " + extractBits(
                      dut.io.remoteXDMACfg.toRemote.bits
                        .peekInt(),
                      56,
                      9
                    ).toInt.toHexString + " is not in the buffer"
                  )
              } else {
                println(
                  "[Remote Writer Checker] " + extractBits(
                    dut.io.remoteXDMACfg.toRemote.bits.peekInt(),
                    104,
                    57
                  ).toInt.toHexString
                )
                if (
                  !unreceived_writer_cfg.remove(
                    extractBits(
                      dut.io.remoteXDMACfg.toRemote.bits
                        .peekInt(),
                      104,
                      57
                    ).toInt
                  )
                )
                  throw new Exception(
                    "[Remote Writer Checker] The received pointer " + extractBits(
                      dut.io.remoteXDMACfg.toRemote.bits
                        .peekInt(),
                      104,
                      57
                    ).toInt.toHexString + " is not in the buffer"
                  )
              }
              dut.clock.step(Random.between(1, 16) + 32)
              dut.io.remoteXDMACfg.toRemote.ready.poke(true)
              dut.clock.step(1)
              dut.io.remoteXDMACfg.toRemote.ready.poke(false)

            } else dut.clock.step(1)
          }
        )
        println("Remote Checker is terminated. ")
      }

      // The supervision thread
      concurrent_threads = concurrent_threads.fork {
        dut.clock.step(512)
        while (endedThreadList.size < 1) dut.clock.step()
        while ((!unreceived_reader_cfg.isEmpty) & (!unreceived_writer_cfg.isEmpty)) {
          dut.clock.step()
        }
        println("Testbench finished. The checker will be terminated soon...")
        testTerminated = true
      }

      concurrent_threads.joinAndStep()
    }
  }
}
