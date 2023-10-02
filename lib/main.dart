import 'package:bachat_gat/common/db_service.dart';
import 'package:flutter/material.dart';

import 'app_root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var db = DbService();
  await db.initDb();
  runApp(const AppRoot());
}
