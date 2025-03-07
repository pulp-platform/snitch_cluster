package snax.xdma.xdmaFrontend

import chisel3._
import chisel3.util._

// Hardware and its Generation Param
import snax.csr_manager._
import snax.xdma.DesignParams._
import snax.readerWriter.ReaderWriterParam

// Import Chiseltest
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

// Import Random number generator
import scala.util.Random

// Import break support for loops
import scala.util.control.Breaks.{break, breakable}

class XDMACtrlTester extends AnyFlatSpec with ChiselScalatestTester {

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

  "The DMACtrl" should " pass" in {
    test(
      new XDMACtrl(
        readerparam = new XDMAParam(
          new AXIParam,
          new CrossClusterParam(1),
          new ReaderWriterParam(
            configurableChannel = true,
            configurableByteMask = false
          ),
          Seq()
        ),
        writerparam = new XDMAParam(
          new AXIParam,
          new CrossClusterParam(1),
          new ReaderWriterParam(
            configurableChannel = true,
            configurableByteMask = true
          ),
          Seq()
        )
      )
    ).withAnnotations(Seq(WriteVcdAnnotation, VerilatorBackendAnnotation)) {
      dut =>
        val clusterBaseAddress = 0x1000_0000
        dut.io.clusterBaseAddress.poke(clusterBaseAddress)

        // The threads list (empty at the beginning)
        var concurrent_threads = new chiseltest.internal.TesterThreadList(Seq())
        val unreceived_reader_cfg = new collection.mutable.HashSet[Int]()
        val unreceived_writer_cfg = new collection.mutable.HashSet[Int]()
        var testTerminated = false

        val endedThreadList = new collection.mutable.HashSet[String]()

        dut.clock.setTimeout(0)

        // The thread to push the data inside the Ctrl from local side and remote side
        concurrent_threads = concurrent_threads.fork {
          val Reader_PointerAddress = BigInt(0x1000_0000)
          // Under This Configurations, the full TCDM will be copied
          val Reader_Spatial_Strides = List(8)
          val Reader_Temporal_Bounds = List(32, 64)
          val Reader_Temporal_Strides = List(64, 2048)

          val Writer_PointerAddress = BigInt(0x1000_0000)
          // Under This Configurations, the full TCDM will be copied
          val Writer_Spatial_Strides = List(32)
          val Writer_Temporal_Bounds = List(32, 16)
          val Writer_Temporal_Strides = List(256, 8192)

          for (i <- 0 until 256 by 2) {
            if (testTerminated) break()
            if (Random.between(0, 2) == 0) {
              // Local Cfg injection
              // Applying Data into the CSRManager
              var currentCSR = 0x0

              val Reader_PointerAddress_ThisLoop =
                Reader_PointerAddress + Random.between(0, 2) * 256 * 1024 + i
              val Writer_PointerAddress_ThisLoop =
                Writer_PointerAddress + Random.between(
                  0,
                  2
                ) * 256 * 1024 + i + 1
              unreceived_reader_cfg.add(Reader_PointerAddress_ThisLoop.toInt)
              unreceived_writer_cfg.add(Writer_PointerAddress_ThisLoop.toInt)

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
                data =
                  ((Reader_PointerAddress_ThisLoop >> 32) & 0xffff_ffff).toInt
              )
              currentCSR += 1

              // Writer: Pointers LSB + MSB
              write_csr(
                dut,
                dut.io.csrIO,
                addr = currentCSR,
                data = ((Writer_PointerAddress_ThisLoop) & 0xffff_ffff).toInt
              )
              currentCSR += 1
              write_csr(
                dut,
                dut.io.csrIO,
                addr = currentCSR,
                data =
                  (((Writer_PointerAddress_ThisLoop) >> 32) & 0xffff_ffff).toInt
              )
              currentCSR += 1

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
              // Reader: Temporal Bounds D0 -> D1
              Reader_Temporal_Bounds.foreach({ i =>
                write_csr(dut, dut.io.csrIO, addr = currentCSR, data = i)
                currentCSR += 1
              })
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
              // Writer: Temporal Bounds D0 -> D1
              Writer_Temporal_Bounds.foreach({ i =>
                write_csr(dut, dut.io.csrIO, addr = currentCSR, data = i)
                currentCSR += 1
              })
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
                "[Local Writer Generator] " + Writer_PointerAddress_ThisLoop.toInt.toHexString
              )

            } else {

              // Remote Cfg injection (Reader side)
              unreceived_reader_cfg.add(
                (Reader_PointerAddress + i).toInt
              )
              val readerRemoteConfig: BigInt =
                // The address for the reader side
                (Reader_PointerAddress + i) +
                  // The address for the writer side
                  (BigInt(0x2000_0000) << 48) +
                  (BigInt(Reader_Spatial_Strides(0) >> 3) << 96) +
                  (BigInt(Reader_Temporal_Bounds(0) >> 3) << 115) +
                  (BigInt(Reader_Temporal_Bounds(1) >> 3) << 134) +
                  // 2, 3, 4, 5 are all 1
                  (BigInt(1) << 153) +
                  (BigInt(1) << 172) +
                  (BigInt(1) << 191) +
                  (BigInt(1) << 210) +
                  (BigInt(Reader_Temporal_Strides(0)) << 229) +
                  (BigInt(Reader_Temporal_Strides(1)) << 248) +
                  // 2, 3, 4, 5 are all 0
                  // Enabled channels
                  (BigInt(0xff) << 343) +
                  // Enabled Byte
                  (BigInt(0xff) << 351)
              dut.io.remoteDMADataPathCfg.reader.fromRemote.bits
                .poke(readerRemoteConfig)
              dut.clock.step(Random.between(1, 31))
              dut.io.remoteDMADataPathCfg.reader.fromRemote.valid.poke(true.B)
              while (
                !(dut.io.remoteDMADataPathCfg.reader.fromRemote.ready
                  .peekBoolean())
              ) {
                dut.clock.step()
              }
              dut.clock.step()
              dut.io.remoteDMADataPathCfg.reader.fromRemote.valid.poke(false.B)
              println(
                "[Remote Reader Generator] " + (Reader_PointerAddress + i).toInt.toHexString
              )

              // Remote Cfg injection (Writer side)
              unreceived_writer_cfg.add(
                (Writer_PointerAddress + i + 1).toInt
              )
              val writerRemoteConfig: BigInt =
                // The address for the reader side
                BigInt(0x2000_0000) +
                  // The address for the writer side
                  ((Writer_PointerAddress + i + 1) << 48) +
                  (BigInt(Writer_Spatial_Strides(0) >> 3) << 96) +
                  (BigInt(Writer_Temporal_Bounds(0) >> 3) << 115) +
                  (BigInt(Writer_Temporal_Bounds(1) >> 3) << 134) +
                  // 2, 3, 4, 5 are all 1
                  (BigInt(1) << 153) +
                  (BigInt(1) << 172) +
                  (BigInt(1) << 191) +
                  (BigInt(1) << 210) +
                  (BigInt(Writer_Temporal_Strides(0)) << 229) +
                  (BigInt(Writer_Temporal_Strides(1)) << 248) +
                  // 2, 3, 4, 5 are all 0
                  // Enabled channels
                  (BigInt(0xff) << 343) +
                  // Enabled Byte
                  (BigInt(0xff) << 351)

              dut.io.remoteDMADataPathCfg.writer.fromRemote.bits
                .poke(writerRemoteConfig)
              dut.clock.step(Random.between(1, 31))
              dut.io.remoteDMADataPathCfg.writer.fromRemote.valid.poke(true.B)
              while (
                !(dut.io.remoteDMADataPathCfg.writer.fromRemote.ready
                  .peekBoolean())
              ) {
                dut.clock.step()
              }
              dut.clock.step()
              dut.io.remoteDMADataPathCfg.writer.fromRemote.valid.poke(false.B)
              println(
                "[Remote Writer Generator] " + (Writer_PointerAddress + i + 1).toInt.toHexString
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
              while (!dut.io.localDMADataPath.readerStart.peekBoolean()) {
                dut.clock.step()
                if (testTerminated) break()
              }
              dut.clock.step(Random.between(1, 16) + 32)
              dut.io.localDMADataPath.readerBusy.poke(true)
              println(
                "[Local Reader Checker] " + dut.io.localDMADataPath.readerCfg.aguCfg.ptr
                  .peekInt()
                  .toInt
                  .toHexString
              )

              if (
                unreceived_reader_cfg
                  .find(i =>
                    (i & 0xffff) == dut.io.localDMADataPath.readerCfg.aguCfg.ptr
                      .peekInt()
                  )
                  .isDefined
              ) {
                unreceived_reader_cfg.remove(
                  unreceived_reader_cfg
                    .find(i =>
                      (i & 0xffff) == dut.io.localDMADataPath.readerCfg.aguCfg.ptr
                        .peekInt()
                    )
                    .get
                )

              } else {
                throw new Exception(
                  "[Local Reader Checker] The received pointer " + dut.io.localDMADataPath.readerCfg.aguCfg.ptr
                    .peekInt()
                    .toInt
                    .toHexString + " is not in the buffer"
                )
              }

              dut.clock.step(Random.between(1, 16) + 32)
              dut.io.localDMADataPath.readerBusy.poke(true)
              dut.clock.step(Random.between(1, 16) + 32)
              dut.io.localDMADataPath.readerBusy.poke(false)
            }
          )
          println("Local Reader Checker is terminated. ")
        }

        // The thread to pop the data outside the Ctrl from local writer side
        concurrent_threads = concurrent_threads.fork {
          breakable(
            while (true) {
              while (!dut.io.localDMADataPath.writerStart.peekBoolean()) {
                dut.clock.step()
                if (testTerminated) break()
              }
              println(
                "[Local Writer Checker] " + dut.io.localDMADataPath.writerCfg.aguCfg.ptr
                  .peekInt()
                  .toInt
                  .toHexString
              )
              if (
                unreceived_writer_cfg
                  .find(i =>
                    (i & 0xffff) == dut.io.localDMADataPath.writerCfg.aguCfg.ptr
                      .peekInt()
                  )
                  .isDefined
              ) {
                unreceived_writer_cfg.remove(
                  unreceived_writer_cfg
                    .find(i =>
                      (i & 0xffff) == dut.io.localDMADataPath.writerCfg.aguCfg.ptr
                        .peekInt()
                    )
                    .get
                )

              } else {
                throw new Exception(
                  "[Local Writer Checker] The received pointer " + dut.io.localDMADataPath.writerCfg.aguCfg.ptr
                    .peekInt()
                    .toInt
                    .toHexString + " is not in the buffer"
                )
              }

              dut.clock.step(Random.between(1, 16) + 32)
              dut.io.localDMADataPath.writerBusy.poke(true)
              dut.clock.step(Random.between(1, 16) + 32)
              dut.io.localDMADataPath.writerBusy.poke(false)
            }
          )
          println("Local Writer Checker is terminated. ")
        }

        // The thread to pop the data outside the Ctrl from remote reader side
        concurrent_threads = concurrent_threads.fork {
          dut.io.remoteDMADataPathCfg.reader.toRemote.ready.poke(false)
          breakable(
            while (true) {
              if (testTerminated) break()
              if (
                dut.io.remoteDMADataPathCfg.reader.toRemote.valid.peekBoolean()
              ) {
                println(
                  "[Remote Reader Checker] " + extractBits(
                    dut.io.remoteDMADataPathCfg.reader.toRemote.bits.peekInt(),
                    47,
                    0
                  ).toInt.toHexString
                )
                if (
                  !unreceived_reader_cfg.remove(
                    extractBits(
                      dut.io.remoteDMADataPathCfg.reader.toRemote.bits
                        .peekInt(),
                      47,
                      0
                    ).toInt
                  )
                )
                  throw new Exception(
                    "[Remote Reader Checker] The received pointer " + extractBits(
                      dut.io.remoteDMADataPathCfg.reader.toRemote.bits
                        .peekInt(),
                      47,
                      0
                    ).toInt.toHexString + " is not in the buffer"
                  )
                dut.clock.step(Random.between(1, 16) + 32)
                dut.io.remoteDMADataPathCfg.reader.toRemote.ready.poke(true)
                dut.clock.step(1)
                dut.io.remoteDMADataPathCfg.reader.toRemote.ready.poke(false)
              } else dut.clock.step(1)
            }
          )
          println("Remote Reader Checker is terminated. ")
        }

        // The thread to pop the data outside the Ctrl from remote writer side
        concurrent_threads = concurrent_threads.fork {
          dut.io.remoteDMADataPathCfg.writer.toRemote.ready.poke(false)
          breakable(
            while (true) {
              if (testTerminated) break()
              if (
                dut.io.remoteDMADataPathCfg.writer.toRemote.valid.peekBoolean()
              ) {
                println(
                  "[Remote Writer Checker] " + extractBits(
                    dut.io.remoteDMADataPathCfg.writer.toRemote.bits.peekInt(),
                    95,
                    48
                  ).toInt.toHexString
                )
                if (
                  !unreceived_writer_cfg.remove(
                    extractBits(
                      dut.io.remoteDMADataPathCfg.writer.toRemote.bits
                        .peekInt(),
                      95,
                      48
                    ).toInt
                  )
                )
                  throw new Exception(
                    "[Remote Writer Checker] The received pointer " + extractBits(
                      dut.io.remoteDMADataPathCfg.writer.toRemote.bits
                        .peekInt(),
                      95,
                      48
                    ).toInt.toHexString + " is not in the buffer"
                  )
                dut.clock.step(Random.between(1, 16) + 32)
                dut.io.remoteDMADataPathCfg.writer.toRemote.ready.poke(true)
                dut.clock.step(1)
                dut.io.remoteDMADataPathCfg.writer.toRemote.ready.poke(false)
              } else dut.clock.step(1)
            }
          )
          println("Remote Writer Checker is terminated. ")
        }

        // The supervision thread
        concurrent_threads = concurrent_threads.fork {
          dut.clock.step(512)
          while (endedThreadList.size < 1) dut.clock.step()
          while (
            (!unreceived_reader_cfg.isEmpty) & (!unreceived_writer_cfg.isEmpty)
          ) {
            dut.clock.step()
          }
          println("Testbench finished. The checker will be terminated soon...")
          testTerminated = true
        }

        concurrent_threads.joinAndStep()
    }
  }
}

object XDMACtrlEmitter extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilogFile(
    new XDMACtrl(
      readerparam = new XDMAParam(
        new AXIParam,
        new CrossClusterParam(1),
        new ReaderWriterParam(
          configurableChannel = true,
          configurableByteMask = false
        ),
        Seq()
      ),
      writerparam = new XDMAParam(
        new AXIParam,
        new CrossClusterParam(1),
        new ReaderWriterParam(
          configurableChannel = true,
          configurableByteMask = true
        ),
        Seq()
      )
    ),
    args = Array("--target-dir", "generated/xdma")
  )
}
