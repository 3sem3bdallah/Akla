import 'package:akla/screens/onboarding_screen.dart';
import 'package:akla/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkFirstTime();
  }

  void checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isSigned = prefs.getBool('is_sign');

    await Future.delayed(Duration(seconds: 7));

    if (!mounted) return;

    if (isSigned == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Center(
        child: SizedBox(
          child: Lottie.asset('assets/animations/Food_Carousel.json',
              width: 400, height: 400, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
