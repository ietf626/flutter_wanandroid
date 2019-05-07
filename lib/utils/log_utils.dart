class LogUtils {
  static var isDebug = true;

  static log(String msg, {String tag = "Arron"}) {
    if (isDebug) print("$tag: $msg");
  }
}
