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
