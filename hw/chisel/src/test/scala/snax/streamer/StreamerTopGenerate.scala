package snax.streamer

import chisel3._
import org.scalatest.flatspec.AnyFlatSpec
import chiseltest._

class StreamerTopGenerate extends AnyFlatSpec {

  emitVerilog(
    new StreamerTop(TestParameters.streamer),
    Array("--target-dir", "generated/streamer")
  )

}

class StreamerWithReaderWriterTopGenerate extends AnyFlatSpec {

  emitVerilog(
    new StreamerTop(TestParameters.streamerWithReaderWriter),
    Array("--target-dir", "generated/streamer")
  )

}
