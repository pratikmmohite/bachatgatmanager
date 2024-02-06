import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'app_local.dart';

class AppLocalDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalDelegate();

  @override
  bool isSupported(Locale locale) {
    return true;
  }

  @override
  Future<AppLocalization> load(Locale locale) {
    return SynchronousFuture<AppLocalization>(AppLocal.load(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalization> old) {
    return false;
  }
}

class AppLocal {
  static final AppLocal _instance = AppLocal._internal();
  AppLocal._internal();

  factory AppLocal() {
    return _instance;
  }

  static ValueNotifier<Locale> l() => _instance.currentLocal;

  static void c(String code) {
    _instance.currentLocal.value = Locale(code);
  }

  ValueNotifier<Locale> currentLocal =
      ValueNotifier<Locale>(const Locale("en"));

  static const LocalizationsDelegate<AppLocalization> delegate =
      AppLocalDelegate();

  static AppLocalization load(Locale locale) {
    switch (locale.languageCode) {
      case "mr":
        return MrAppLocalization();
      case "en":
      default:
        return EnAppLocalization();
    }
  }

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization)!;
  }
}
