package snax_acc.utils

import scala.Float

import chisel3._

import snax_acc.versacore._

trait fpUtils {

  /** Generalized helper function to encode Float as UInt */
  def floatToUInt(expWidth: Int, sigWidth: Int, value: Float): BigInt = {
    val expSigWidth = expWidth + sigWidth
    val totalWidth  = expSigWidth + 1

    // Convert to IEEE 754 32-bit float representation
    val bits32 = java.lang.Float.floatToIntBits(value)

    // Extract sign, exponent, and significand
    val sign     = (bits32 >>> 31) & 0x1
    val exponent = (bits32 >>> 23) & 0xff
    val frac     = bits32 & 0x7fffff

    // Re-normalize the exponent to fit expWidth
    val bias32       = 127 // IEEE 754 bias for 32-bit float
    val biasTarget   = (1 << (expWidth - 1)) - 1
    val maxExpTarget = (1 << expWidth) - 1
    val tentativeExp = (exponent - bias32 + biasTarget)

    val bitsTarget =
      if (exponent == 0xff && frac != 0) {
        // Canonical NaN: all exponent bits 1, MSB of fraction 1, rest 0
        val expAllOnes = (1 << expWidth) - 1
        val fracMSB    = 1 << (sigWidth - 1)
        (sign << expSigWidth) | (expAllOnes << sigWidth) | fracMSB
      } else if (exponent == 0xff && frac == 0) {
        // Infinity: all exponent bits 1, fraction 0
        val expAllOnes = (1 << expWidth) - 1
        (sign << expSigWidth) | (expAllOnes << sigWidth)
      } else if (exponent == 0 && frac == 0) {
        // True zero
        sign << expSigWidth
      } else if (tentativeExp > maxExpTarget) {
        // Overflow -> Inf (all 1's)
        (sign << expSigWidth) | ((1 << expSigWidth) - 1)
      } else if (exponent == 0 && tentativeExp <= 0) {
        // From subnormal to subnormal
        val subnormalShift = -tentativeExp
        val subnormalFrac  = frac >>> (subnormalShift + 23 - sigWidth)
        (sign << expSigWidth) | subnormalFrac
      } else if (exponent == 0 && tentativeExp > 0) {
        // From subnormal to normal
        throw new NotImplementedError("From subnormal to normal")
      } else if (exponent > 0 && tentativeExp <= 0) {
        // From normal to subnormal
        // Add implicit 1 and shift with subnormal location + the difference in mantissa lengths
        val subnormalShift = 1 - tentativeExp
        val subnormalFrac  = (0x800000 | frac) >>> (subnormalShift + 23 - sigWidth)
        (sign << expSigWidth) | subnormalFrac
      } else {
        val fracTarget = frac >>> (23 - sigWidth)
        val expTarget  = tentativeExp.max(0).min(maxExpTarget)
        (sign << expSigWidth) | (expTarget << sigWidth) | fracTarget
      }

    BigInt(bitsTarget & ((1L << totalWidth) - 1)) // Mask to ensure valid bit-width
  }

  /** Generalized helper function to decode UInt to Float */
  def uintToFloat(expWidth: Int, sigWidth: Int, bits: BigInt): Float = {
    // Extract sign, exponent, and significand
    val signSrc     = (bits >> (expWidth + sigWidth)) & 0x1
    val exponentSrc = (bits >> sigWidth) & ((1 << expWidth) - 1)
    val fracSrc     = bits & ((1 << sigWidth) - 1)

    val biasSrc   = (1 << (expWidth - 1)) - 1
    val bias32    = 127 // IEEE 754 bias for 32-bit float
    val maxExpSrc = (1 << expWidth) - 1
    val biasDiff  = bias32 - biasSrc

    val bits32 =
      if (exponentSrc == 0 && fracSrc == 0) {
        // True zero
        signSrc << 31
      } else if (exponentSrc == maxExpSrc) {
        // Inf or NaN
        val isNaN  = fracSrc != 0
        val frac32 = if (isNaN) 0x200000 else 0
        (signSrc << 31) | (0xff << 23) | frac32
      } else if (exponentSrc == 0 && biasDiff > 0) {
        // Subnormal to normal
        val leading    = Integer.numberOfLeadingZeros(fracSrc.toInt) - (32 - sigWidth)
        // Put MSB of source mantissa at implicit 1 position
        val normalized = (fracSrc << (leading + 1)) & ((1 << sigWidth) - 1)
        // Shift source mantissa into FP32 precision
        val frac32     = normalized << (23 - sigWidth)
        // Re-normalize exponent
        val exp32      = biasDiff - leading
        (signSrc << 31) | (exp32 << 23) | frac32
      } else if (exponentSrc == 0 && biasDiff <= 0) {
        // Subnormal to subnormal
        val subnormalFrac = fracSrc >> (-biasDiff + sigWidth - 23)
        (signSrc << 31) | subnormalFrac
      } else if (biasDiff < 0) {
        // Normal to subnormal
        throw new NotImplementedError("From normal to subnormal")
      } else {
        val frac32 = fracSrc.toInt << (23 - sigWidth)
        val exp32  = exponentSrc - biasSrc + bias32
        (signSrc << 31) | (exp32 << 23) | frac32
      }

    java.lang.Float.intBitsToFloat(bits32.toInt)
  }

  def floatToUInt(fpType: FpType, value: Float):  BigInt = floatToUInt(fpType.expWidth, fpType.sigWidth, value)
  def uintToFloat(fpType: FpType, value: BigInt): Float  = uintToFloat(fpType.expWidth, fpType.sigWidth, value)
  def uintToFloat(fpType: FpType, value: UInt):   Float  = uintToFloat(fpType.expWidth, fpType.sigWidth, value.litValue)
  def quantize(fpType:    FpType, value: Float):  Float  = uintToFloat(fpType, floatToUInt(fpType, value))

  /** Generate a true random value in the given FpType, where exponent and mantissa are sampled independently */
  def getTrueRandomValue(fpType: FpType): Float = {
    val r          = new scala.util.Random()
    val randomBits = BigInt(fpType.width, r)
    uintToFloat(fpType, randomBits)
  }

  /** Generated a bounded random float in the given FpType. Maximum value should be calculated such that a large number
    * of operations on randomly sampled numbers will not overflow with high probability
    */
  def genRandomValue(fpType: FpType): Float = {

    val margin      = 16
    val maxExponent = ((1 << (fpType.expWidth - 1)) - 1) / margin
    val maxVal      = (1 << maxExponent).toFloat / margin
    val r           = new scala.util.Random()
    (2 * r.nextFloat() - 1f) * maxVal
  }

  /** Process two floating point numbers in a given format by introducing the hardware limitations of this format */
  def fpOperationHardware(a: Float, b: Float, typeA: FpType, typeB: FpType, op: (Float, Float) => Float) = {
    op(quantize(typeA, a), quantize(typeB, b))
  }

  /** Multiplies two floating point numbers in a given format by introducing the hardware limitations of this format */
  def fpOperationHardware(a: Float, typeA: FpType, op: Float => Float) = op(quantize(typeA, a))

  /** Returns true iff the hardware result a (as UInt) correctly represents the float While hardware modules use RNE
    * (Round to Nearest, ties to Even), the fp arithmetic in here does not model this. Hence, the value from hardware
    * can be 0 or 1 higher than the expected value, but not smaller.
    *
    * -0 and +0 are also accepted as equal.
    */
  def fpEqualsHardware(expected: Float, from_hw: UInt, typeB: FpType) = {
    val expected_bigint = floatToUInt(typeB, expected)
    val from_hw_bigint  = from_hw.litValue
    val eqZero          = expected_bigint == 0          && isZero(from_hw_bigint, typeB)
    val eqNaN           = isNaN(expected_bigint, typeB) && isNaN(from_hw_bigint, typeB)

    from_hw_bigint == expected_bigint || from_hw_bigint == expected_bigint + 1 || eqZero || eqNaN
  }

  /** Returns true iff the hardware result a (as UInt) correctly represents the float. The result is allowed to differ
    * in `lsbTolerance` LSB bits, as a result from rounding errors propagated through operations.
    */
  def fpAlmostEqualsHardware(expected: Float, from_hw: UInt, typeB: FpType) = {
    val lsbTolerance    = 4
    val expected_bigint = floatToUInt(typeB, expected)
    val from_hw_bigint  = from_hw.litValue
    val eqZero          = expected_bigint == 0          && isZero(from_hw_bigint, typeB)
    val eqNaN           = isNaN(expected_bigint, typeB) && isNaN(from_hw_bigint, typeB)
    (from_hw_bigint - expected_bigint).abs <= ((BigInt(1) << lsbTolerance) - 1) || eqZero || eqNaN
  }

  def isNaN(bits: BigInt, fpType: FpType): Boolean = {
    val expMask = ((BigInt(1) << fpType.expWidth) - 1) << fpType.sigWidth
    val exp     = (bits & expMask) >> fpType.sigWidth
    val frac    = bits & ((BigInt(1) << fpType.sigWidth) - 1)
    exp == (BigInt(1) << fpType.expWidth) - 1 && frac != 0
  }

  def isZero(bits: BigInt, fpType: FpType): Boolean = bits == BigInt(1) << fpType.width - 1

  /** Define operator symbol for mulFpHardware. Signature:  ((Float, FpType), (Float, FpType)) => Float */
  implicit class FpHardwareOps(a: (Float, FpType)) {
    def *(b: (Float, FpType)): Float = fpOperationHardware(a._1, b._1, a._2, b._2, _ * _)
    def +(b: (Float, FpType)): Float = fpOperationHardware(a._1, b._1, a._2, b._2, _ + _)

    /** FP results are exactly the same, except for a +1 bit rounding error (RNE instead of floor). Not to be confused
      * with the Chisel3 === operator
      */
    def ===(b: UInt): Boolean = fpEqualsHardware(a._1, b, a._2)

    /** FP results are similar, tolerating an accumulated rounding error */
    def =~=(b: UInt): Boolean = fpAlmostEqualsHardware(a._1, b, a._2)
  }

  def uintToStr(bits: BigInt, fpType: FpType): String =
    bits.toString(2).reverse.padTo(fpType.width, '0').reverse.grouped(4).mkString("_")
}
