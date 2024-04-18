/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:bachat_gat/features/groups/groups_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String rHome = "/home";
  static const String rGroups = "/groups";
  static const String rDashboard = "/dashboard";

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      rGroups: (context) => const GroupsScreen(),
    };
  }
}
