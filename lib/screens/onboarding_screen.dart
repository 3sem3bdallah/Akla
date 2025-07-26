import 'package:carousel_slider/carousel_slider.dart';
import 'package:akla/screens/home_screen.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<String> title = [
    'title-1'.tr(),
    'title-2'.tr(),
    'title-3'.tr(),
  ];
  final List<String> desc = [
    'description-1'.tr(),
    'description-2'.tr(),
    'description-3'.tr(),
  ];
  final CarouselSliderController controller = CarouselSliderController();
  int curIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/img/onbording.png'),
                    fit: BoxFit.cover)),
          ),
          Positioned(
            bottom: 30,
            left: 32,
            right: 32,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32),
              height: 470,
              width: 311,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(48),
                // ignore: deprecated_member_use
                color: Colors.orange.withOpacity(0.9),
              ),
              child: CarouselSlider(
                carouselController: controller,
                options: CarouselOptions(
                  height: 470,
                  disableCenter: true,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      curIndex = index;
                    });
                  },
                ),
                items: List.generate(title.length, (index) {
                  return Builder(
                    // ignore: avoid_types_as_parameter_names
                    builder: (context) {
                      return Column(
                        children: [
                          SizedBox(height: 40),
                          Text(
                            title[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            desc[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 40),
                          DotsIndicator(
                            dotsCount: title.length,
                            position: curIndex.toDouble(),
                            onTap: (index) {
                              controller.animateToPage(index,
                                  duration: Duration(milliseconds: 250));
                            },
                            decorator: DotsDecorator(
                              size: Size(30, 10),
                              color: Color(0xffC2C2C2),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              activeSize: Size(30, 10),
                              activeColor: Colors.white,
                              activeShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          Spacer(),
                          curIndex == 2
                              ? InkWell(
                                  onTap: () async {
                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setBool('is_sign', true);
                                    Navigator.pushReplacement(
                                      // ignore: use_build_context_synchronously
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomeScreen()),
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 40,
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Colors.orange,
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        final SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        prefs.setBool('is_sign', true);
                                        Navigator.pushReplacement(
                                            // ignore: use_build_context_synchronously
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeScreen()));
                                      },
                                      child: Text(
                                        'Skip'.tr(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      hoverColor: Colors.green,
                                      onTap: () async {
                                        final SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        prefs.setBool('is_sign', false);
                                        if (curIndex < 2) {
                                          setState(() {
                                            curIndex++;
                                          });
                                          controller.animateToPage(curIndex);
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(10),
                                      focusColor: Colors.yellow,
                                      child: Text(
                                        'Next'.tr(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          SizedBox(height: 30),
                        ],
                      );
                    },
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
