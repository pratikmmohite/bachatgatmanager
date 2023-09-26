import 'package:flutter/material.dart';

import 'features/home/home.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saving Group',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
          useMaterial3: true
      ),
      home: const Home(),
    );
  }
}
