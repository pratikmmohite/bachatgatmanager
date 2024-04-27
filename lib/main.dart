/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:bachat_gat/common/db_service.dart';
import 'package:flutter/material.dart';

import 'app_root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var db = DbService();
  await db.initDb();
  runApp(const AppRoot());
}
