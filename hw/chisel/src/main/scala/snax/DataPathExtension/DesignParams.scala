package snax.DataPathExtension

class DataPathExtensionParam(
    val moduleName: String,
    val userCsrNum: Int,
    val dataWidth: Int = 512
) {
  require(dataWidth > 0)
  require(userCsrNum >= 0)
}
