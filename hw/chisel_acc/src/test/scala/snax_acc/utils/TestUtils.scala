package snax_acc.utils

import chisel3._

import chiseltest._

object CommonTestUtils {

  // Function to convert UInt to SInt manually
  def toSInt(value: Int, bitWidth: Int): Int = {
    val mask     = (1L << bitWidth) - 1
    val unsigned = value.toLong & mask
    val signBit  = 1L << (bitWidth - 1)
    if ((unsigned & signBit) != 0) (unsigned - (1L << bitWidth)).toInt
    else unsigned.toInt
  }

  /** Step the clock until the given signal asserts, or stop after timeout
    * @param signal
    *   Signal to wait for until it is asserted
    * @param timeout
    *   Assert after this number of cycles
    */
  def WaitOrTimeout(signalToAssert: Bool, clock: Clock, timeout: Int = 100) = {
    var waitCnt = 0
    while (!signalToAssert.peekBoolean()) {
      if (waitCnt > timeout) {
        println(s"Timeout at cycle ${clock.getStepCount} for signal ${signalToAssert}")
        assert(false)
      }
      clock.step(1)
      waitCnt += 1
    }
  }

}
