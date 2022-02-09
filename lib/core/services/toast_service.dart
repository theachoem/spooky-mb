import 'package:fluttertoast/fluttertoast.dart';

class ToastService {
  static Future<void> show(String msg) async {
    await Fluttertoast.showToast(
      msg: msg,
      toastLength: msg.length > 50 ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static Future<void> close() async {
    await Fluttertoast.cancel();
  }
}
