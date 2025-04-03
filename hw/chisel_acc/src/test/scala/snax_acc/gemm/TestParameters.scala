package snax_acc.gemm

object TestParameters {

  lazy val MatrixLibBlock_random_M_range = 10
  lazy val MatrixLibBlock_random_K_range = 10
  lazy val MatrixLibBlock_random_N_range = 10

  val testConfig = new GemmParams(
    dataWidthA          = GemmConstant.dataWidthA,
    dataWidthB          = GemmConstant.dataWidthB,
    dataWidthMul        = GemmConstant.dataWidthMul,
    dataWidthC          = GemmConstant.dataWidthC,
    dataWidthAccum      = GemmConstant.dataWidthAccum,
    subtractionCfgWidth = GemmConstant.subtractionCfgWidth,
    meshRow             = 5,
    tileSize            = 5,
    meshCol             = 5,
    addrWidth           = GemmConstant.addrWidth,
    sizeConfigWidth     = GemmConstant.sizeConfigWidth
  )

}
