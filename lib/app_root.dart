import 'package:bachat_gat/common/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'locals/app_local_delegate.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

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
          // theme: ThemeData.light(useMaterial3: true),
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
        // theme: ThemeData.light(useMaterial3: true),
        initialRoute: Routes.rGroups,
        routes: Routes.getRoutes(),
      ),
    );
  }
}
