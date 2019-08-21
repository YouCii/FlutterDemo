import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {

  /// []是位置可选, {}必须指定参数名
  static showToast(String content, {isLong = false}) {
    Fluttertoast.showToast(msg: content, toastLength: isLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT);
  }

}