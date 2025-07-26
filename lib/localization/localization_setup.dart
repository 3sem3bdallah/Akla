// localization_setup.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LocalizationHelper {
  static const supportedLocales = [
    Locale('en'),
    Locale('de'),
    Locale('ar'),
  ];

  static const path = 'assets/translations';
  static const fallbackLocale = Locale('en');

  static Future<void> init() async {
    await EasyLocalization.ensureInitialized();
  }

  static void changeLanguage(BuildContext context) {
    final currentLocale = context.locale;
    Locale newLocale;
    
    if (currentLocale.languageCode == 'en') {
      newLocale = const Locale('de');
    } else if (currentLocale.languageCode == 'de') {
      newLocale = const Locale('ar');
    } else {
      newLocale = const Locale('en');
    }
    
    context.setLocale(newLocale);
  }
}