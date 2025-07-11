package snax_acc.utils

import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import snax_acc.versacore.{BF16, FP16, FP32, FpType}

class FpUtilsTest extends AnyFlatSpec with Matchers with fpUtils {
  behavior of "FpUtils floatToUInt and uintToFloat conversions"

  val fpTypes: Seq[FpType] = Seq(FP16, FP32, BF16)
  val numTests = 100

  // Special values
  val zeros      = Seq(0.0f, -0.0f)
  val subnormals = Seq(
    java.lang.Float.intBitsToFloat(0x00000001), // Smallest subnormal
    java.lang.Float.intBitsToFloat(0x007fffff)  // Largest subnormal
  )
  val infinities = Seq(Float.PositiveInfinity, Float.NegativeInfinity)
  val nans       = Seq(Float.NaN, java.lang.Float.intBitsToFloat(0x7fc00001))

  /** Helper: get max/min finite value for a given FpType */
  def maxFinite(fpType: FpType): Float = {
    val maxExp  = (1 << (fpType.expWidth - 1)) - 1
    val maxFrac = (1 << fpType.sigWidth) - 1
    val bits    = (0 << (fpType.expWidth + fpType.sigWidth)) | (maxExp << fpType.sigWidth) | maxFrac
    uintToFloat(fpType, BigInt(bits))
  }
  def minFinite(fpType: FpType): Float = -maxFinite(fpType)

  /** Helper: get largest and smallest normal values for a given FpType */
  def largestNormal(fpType: FpType): Float = maxFinite(fpType)
  def smallestNormal(fpType: FpType): Float = {
    val minNormalBits = (1 << fpType.sigWidth) // exponent=1, fraction=0
    uintToFloat(fpType, BigInt(minNormalBits))
  }

  /** Helper: is value representable as finite in fpType? */
  def isFiniteInType(fpType: FpType, v: Float): Boolean = {
    val max = maxFinite(fpType)
    val min = minFinite(fpType)
    v <= max && v >= min && !v.isNaN && !v.isInfinite
  }

  /** Helper: generate random normal values within representable range (excluding subnormals) */
  def randomNormals(fpType: FpType, n: Int, seed: Int = 0): Seq[Float] = {
    val r   = new scala.util.Random(seed)
    val max = maxFinite(fpType)
    val min = -max // Use symmetric range around zero
    (0 until n).map(_ => min + r.nextFloat() * (max - min))
  }

  it should "convert zeros correctly for all FP types" in {
    for (fpType <- fpTypes) {
      val typeName = fpType.getClass.getSimpleName
      for (v <- zeros) {
        val uint = floatToUInt(fpType, v)
        val back = uintToFloat(fpType, uint)
        withClue(s"$typeName zero $v: uint=$uint back=$back") {
          back should (be(0.0f) or be(-0.0f))
        }
      }
    }
  }

  it should "convert normal values correctly for all FP types" in {
    for (fpType <- fpTypes) {
      val typeName  = fpType.getClass.getSimpleName
      val normals   = randomNormals(fpType, numTests)
      val tolerance = if (fpType eq BF16) 1e-1f else 1e-3f
      for (v <- normals :+ largestNormal(fpType) :+ smallestNormal(fpType)) {
        val uint = floatToUInt(fpType, v)
        val back = uintToFloat(fpType, uint)
        val tol  = Math.max(Math.ulp(v) * 2, tolerance)
        if (isFiniteInType(fpType, v))
          withClue(s"$typeName normal $v: uint=$uint back=$back tol=$tol") { back shouldBe (v +- tol) }
        else
          withClue(s"$typeName normal $v (out of range): uint=$uint back=$back") {
            back.isInfinite || back.isNaN shouldBe true
          }
      }
    }
  }

  it should "convert subnormals correctly for all FP types" in {
    for (fpType <- fpTypes) {
      val typeName = fpType.getClass.getSimpleName
      for (v <- subnormals) {
        val uint = floatToUInt(fpType, v)
        val back = uintToFloat(fpType, uint)
        withClue(s"$typeName subnormal $v: uint=$uint back=$back") {
          back.isNaN shouldBe false
        }
      }
    }
  }

  it should "convert infinities correctly for all FP types" in {
    for (fpType <- fpTypes) {
      val typeName = fpType.getClass.getSimpleName
      for (v <- infinities) {
        val uint = floatToUInt(fpType, v)
        val back = uintToFloat(fpType, uint)
        withClue(s"$typeName infinity $v: uint=$uint back=$back") {
          back.isInfinite shouldBe true
          back.sign shouldBe v.sign
        }
      }
    }
  }

  it should "convert NaNs correctly for all FP types" in {
    for (fpType <- fpTypes) {
      val typeName = fpType.getClass.getSimpleName
      for (v <- nans) {
        val uint = floatToUInt(fpType, v)
        val back = uintToFloat(fpType, uint)
        withClue(s"$typeName NaN $v: uint=$uint back=$back") { back.isNaN shouldBe true }
      }
    }
  }

  it should "round-trip float->uint->float for all FP types" in {
    for (fpType <- fpTypes) {
      val typeName  = fpType.getClass.getSimpleName
      val normals   = randomNormals(fpType, numTests)
      val tolerance = if (fpType eq BF16) 1e-1f else 1e-3f
      val values    =
        zeros ++ normals ++ subnormals ++ infinities ++ nans ++ Seq(largestNormal(fpType), smallestNormal(fpType))
      for (v <- values) {
        val uint = floatToUInt(fpType, v)
        val back = uintToFloat(fpType, uint)
        val tol  = Math.max(Math.ulp(v) * 2, tolerance)
        if (isFiniteInType(fpType, v)) {
          withClue(s"$typeName float->uint->float $v: uint=$uint back=$back tol=$tol") {
            back shouldBe (v +- tol)
          }
        } else if (v.isNaN) {
          withClue(s"$typeName float->uint->float $v: uint=$uint back=$back") {
            back.isNaN shouldBe true
          }
        } else if (v == 0.0f || v == -0.0f) {
          withClue(s"$typeName float->uint->float $v: uint=$uint back=$back") {
            back should (be(0.0f) or be(-0.0f))
          }
        } else if (v.isInfinite) {
          withClue(s"$typeName float->uint->float $v: uint=$uint back=$back") {
            back.isInfinite shouldBe true; back.sign shouldBe v.sign
          }
        }
      }
    }
  }

  it should "round-trip uint->float->uint for all FP types" in {
    for (fpType <- fpTypes) {
      val typeName = fpType.getClass.getSimpleName
      val width    = fpType.width
      val r        = new scala.util.Random(0)
      for (_ <- 0 until numTests) {
        val uint = BigInt(width, r)
        val f    = uintToFloat(fpType, uint)
        val back = floatToUInt(fpType, f)
        withClue(s"$typeName uint->float->uint $uint: float=$f back=$back bits=0x${java.lang.Integer
            .toHexString(java.lang.Float.floatToIntBits(f))}") {
          if (f.isNaN) isNaN(back, fpType) shouldBe true
          else if (isNaN(uint, fpType)) isNaN(back, fpType) shouldBe true
          else if (isZero(uint, fpType)) isZero(back, fpType) shouldBe true
          else (back == uint || (back - uint).abs <= 1) shouldBe true
        }
      }
    }
  }

  // Special test for FP32 exact conversions (all finite values, including subnormals)
  it should "perform exact float->uint->float conversions for FP32 (finite values)" in {
    val normals = randomNormals(FP32, 1000)
    val values  = zeros ++ normals ++ subnormals ++ Seq(largestNormal(FP32), smallestNormal(FP32))
    for (v <- values) {
      if (!v.isNaN && !v.isInfinite) {
        val uint = floatToUInt(FP32, v)
        val back = uintToFloat(FP32, uint)
        withClue(s"FP32 exact $v: uint=$uint back=$back bits=${java.lang.Float.floatToIntBits(v).toHexString}") {
          if (v == 0.0f || v == -0.0f) back should (be(0.0f) or be(-0.0f))
          else back shouldBe v // Exact equality for all finite FP32 values
        }
      }
    }
  }
}
