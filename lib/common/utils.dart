import 'package:uuid/uuid.dart';

class Utils {
  static var uuid = const Uuid();
  static String getUUID() {
    return uuid.v1();
  }
}
