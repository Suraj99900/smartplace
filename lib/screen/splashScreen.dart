import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartplace/controller/splashController.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashController splashController = SplashController();
  var sWidth = Get.width;
  var sHeight = Get.height;
  @override
  void initState() {
    super.initState();
    splashController.fadeIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(() {
            return TweenAnimationBuilder(
              curve: Curves.easeInOut,
              tween: Tween<double>(
                begin: splashController.fontSize.value == sWidth * 0.05
                    ? sWidth * 0.05
                    : sWidth * 0.15,
                end: splashController.fontSize.value,
              ),
              duration: const Duration(seconds: 1),
              builder: (BuildContext context, double fontSize, Widget? child) {
                return Text(
                  splashController.splashMessage.value,
                  style: GoogleFonts.barriecito(
                    textStyle: TextStyle(
                      color: splashController.fontSize.value == sWidth * 0.05
                          ? Colors.white10
                          : Colors.white,
                      fontSize: fontSize,
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
