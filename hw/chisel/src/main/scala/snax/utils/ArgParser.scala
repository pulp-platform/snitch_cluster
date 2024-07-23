package snax.utils

object ArgParser {

  /*
   * Function to parse the arguments provided to the program
   * Arguments are expected to be in the form of --arg_name arg_value or --arg_name
   * Returns a map of argument names to their values
   */
  def parse(args: Array[String]): collection.mutable.Map[String, String] = {
    val parsed_args = collection.mutable.Map[String, String]()
    var i = 0
    while (i < args.length) {
      if (args(i)(0) == '-' && args(i)(1) == '-') {
        if (
          i == args.length - 1 || (args(i + 1)(0) == '-' && args(i + 1)(
            1
          ) == '-')
        ) {
          // Last argument or next argument is also a flag
          parsed_args(args(i).substring(2)) = "NoArg"
        } else parsed_args(args(i).substring(2)) = args(i + 1)
      }
      i += 1
    }
    if (parsed_args.size == 0) {
      println("No arguments provided. Please provide arguments")
      sys.exit(1)
    }
    parsed_args
  }
}
