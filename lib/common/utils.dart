import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AppUtils {
  static var uuid = const Uuid();
  static String getUUID() {
    return uuid.v1();
  }

  static void toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }

  static Future<void> navigateTo(BuildContext context, Widget navToWid) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ct) => navToWid,
      ),
    );
  }

  static void close(BuildContext context) {
    Navigator.of(context).pop();
  }
}
