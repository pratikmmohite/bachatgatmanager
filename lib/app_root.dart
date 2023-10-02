import 'package:bachat_gat/common/routes.dart';
import 'package:flutter/material.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saving Group',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      initialRoute: Routes.rGroups,
      routes: Routes.getRoutes(),
    );
  }
}
