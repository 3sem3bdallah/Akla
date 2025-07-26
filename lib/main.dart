import 'package:flutter/material.dart';
import 'package:akla/screens/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:akla/localization/localization_setup.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalizationHelper.init(); 
  
  runApp(
    EasyLocalization(
      supportedLocales: LocalizationHelper.supportedLocales,
      path: LocalizationHelper.path,
      fallbackLocale: LocalizationHelper.fallbackLocale,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      home: const SplashScreen(),
    );
  }
}