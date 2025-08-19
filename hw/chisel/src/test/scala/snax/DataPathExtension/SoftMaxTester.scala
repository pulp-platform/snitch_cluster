package snax.DataPathExtension
import scala.util.Random
import scala.math.BigInt

import chiseltest._
import snax.DataPathExtension.HasSoftMax

class SoftMaxTester extends DataPathExtensionTester(TreadleBackendAnnotation) {

  def GoldenModel(in_array: Array[Array[Int]], inverseScalingFactor: Int): Array[Array[Long]] = {

    def findMax(array: Array[Int]): Int = {
      array.max
    }

    def subtractMax(array: Array[Int], maxValue: Int): Array[Int] = {
      array.map { value =>
        val result = value - maxValue
        if (result < Int.MinValue) Int.MinValue else result
      }
    }

    def integerPoly(x: Int, inverseScalingFactor: Int, a: Float, b: Float, c: Float): (Long, Int) = {
      val aScaled: BigInt = BigInt((a * inverseScalingFactor).toInt)
      val bScaled: BigInt = BigInt((b * inverseScalingFactor).toInt)
      val logInverseScaling = math.floor(math.log(inverseScalingFactor) / math.log(2)).toInt
      val big_cScaled: BigInt = BigInt((c * math.pow(inverseScalingFactor, 3)).toLong)
      val cScaled = big_cScaled >> (logInverseScaling * 2)

      val temp: BigInt = BigInt(x) + bScaled
      val output: Long = (((aScaled * temp * temp) >> (logInverseScaling * 2)) + cScaled).toLong
      val scalingFactorOut = (math.pow(inverseScalingFactor, 3).toInt) >> (logInverseScaling * 2)

      (output, scalingFactorOut)
    }

    def integerExp(array: Array[Int], inverseScalingFactor: Int): (Array[Long], Int) = {
      val a = 0.3585f
      val b = 1.353f
      val c = 0.344f
      val qLn2 = (math.log(2) * inverseScalingFactor).toInt
      
      var scalingFactorExp = 0
      val expArray = array.map { value =>
        val z = math.floor(-value.toFloat / qLn2).toInt
        val qP = value + z * qLn2
        val (qL, scalingFactor) = integerPoly(qP, inverseScalingFactor, a, b, c)
        scalingFactorExp = scalingFactor
        if (z < 16) qL >> z else 0
      }
      
      (expArray, scalingFactorExp)
    }

    def integerSoftmax(array: Array[Int], scalingFactorExp: Int): Array[Long] = {
      val maxValue = findMax(array)
      val arraySubtracted = subtractMax(array, maxValue)
      val (expArray, _) = integerExp(arraySubtracted, scalingFactorExp)
      println("expArray:", expArray.mkString(", "))
      val sumExp = expArray.map(_.toLong).sum

      val divider = 4294967295L / sumExp
      println("sumExp:", sumExp)
      println("divider:", divider)
      // Convert to softmax probabilities and scale to byte range (0-255)
      expArray.map { value =>
        value.toLong * divider
      }
    }

    in_array.transpose.map { column =>
      println(column.mkString("InputArray(", ", ", ")"))
      println(integerSoftmax(column, inverseScalingFactor).mkString("GoldenArray(", ", ", ")"))
      println("")
    }

    // Process each row of the input array
    in_array.transpose.map { column =>
      integerSoftmax(column, inverseScalingFactor)
    }.transpose
  }

  def hasExtension = new HasSoftMax()

  val scaled_ln2     = 6931
  val scaled_a   = 3585
  val scaled_b    = 13530
  val scaled_c        = 5125
  val shift       = 26
  val softmax_cycles = 8
  val csr_vec      = Seq(scaled_ln2, scaled_a, scaled_b, scaled_c, shift, softmax_cycles)

  val inputData  = collection.mutable.Buffer[BigInt]()
  val outputData = collection.mutable.Buffer[BigInt]()

  Random.setSeed(1) // For reproducibility

  for (_ <- 0 until 128) {
    // val inputMatrix: Array[Int] = Array.fill(64)(-5956158)
    val inputMatrix: Array[Array[Int]] = Array.fill(8,16)(Random.between(-40000, 40000))
    val inputMatrix1 = inputMatrix(0)
    val inputMatrix2 = inputMatrix(1)
    val inputMatrix3 = inputMatrix(2)
    val inputMatrix4 = inputMatrix(3)
    val inputMatrix5 = inputMatrix(4)
    val inputMatrix6 = inputMatrix(5)
    val inputMatrix7 = inputMatrix(6)
    val inputMatrix8 = inputMatrix(7)

    inputData.append(BigInt(inputMatrix1.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix2.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix3.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix4.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix5.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix6.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix7.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix8.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))

    inputData.append(BigInt(inputMatrix1.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix2.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix3.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix4.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix5.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix6.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix7.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix8.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))

    inputData.append(BigInt(inputMatrix1.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix2.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix3.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix4.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix5.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix6.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix7.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix8.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))

    val outputMatrix = GoldenModel(inputMatrix, 10000)
    val outputMatrix1 = outputMatrix(0)
    val outputMatrix2 = outputMatrix(1)
    val outputMatrix3 = outputMatrix(2)
    val outputMatrix4 = outputMatrix(3)
    val outputMatrix5 = outputMatrix(4)
    val outputMatrix6 = outputMatrix(5)
    val outputMatrix7 = outputMatrix(6)
    val outputMatrix8 = outputMatrix(7)
    outputData.append(BigInt(outputMatrix1.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    outputData.append(BigInt(outputMatrix2.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    outputData.append(BigInt(outputMatrix3.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    outputData.append(BigInt(outputMatrix4.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    outputData.append(BigInt(outputMatrix5.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    outputData.append(BigInt(outputMatrix6.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    outputData.append(BigInt(outputMatrix7.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    outputData.append(BigInt(outputMatrix8.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
  }
  val input_data_vec = inputData.toSeq

  val output_data_vec = outputData.toSeq

}

