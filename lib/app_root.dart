/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:bachat_gat/common/common_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_theme.dart';
import 'locals/app_local_delegate.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  @override
  void initState() {
    loadLocal();
    super.initState();
  }

  Future<void> loadLocal() async {
    try {
      var code = await StorageService.getLocal();
      AppLocal.c(code);
    } catch (e) {
      // do nothing
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: AppLocal.l(),
      builder: (context, local, child) {
        return MaterialApp(
          title: 'Saving Group',
          localizationsDelegates: const [
            AppLocal.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: local,
          supportedLocales: const [
            Locale('en'),
            Locale('mr'),
          ],
          debugShowCheckedModeBanner: false,
          theme: AppTheme.of(context),
          initialRoute: Routes.rGroups,
          routes: Routes.getRoutes(),
        );
      },
      child: MaterialApp(
        title: 'Saving Group',
        localizationsDelegates: const [
          AppLocal.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: AppLocal.l().value,
        supportedLocales: const [
          Locale('en'),
          Locale('mr'),
        ],
        debugShowCheckedModeBanner: false,
        theme: AppTheme.of(context),
        initialRoute: Routes.rGroups,
        routes: Routes.getRoutes(),
      ),
    );
  }
}
