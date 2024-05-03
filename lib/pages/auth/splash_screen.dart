import 'dart:async';

import 'package:chat_app/routes/router_helper.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  bool selected = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(
      const Duration(seconds: 5),
      () => Get.toNamed(
        RouteHelper.getMain(),
      ),
    );

    startAnimation();
  }

  void startAnimation() async {
    await Future.delayed(
      const Duration(
        seconds: 4,
      ),
    ); // Delay to let the widget build
    setState(() {
      selected = !selected;
    });
    startAnimation();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor500,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/message.png',
                      width: 100.0,
                      height: 100.0,
                    ),
                    Text(
                      'Spam',
                      style: SafeGoogleFont(
                        'Montserrat',
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w700, // 600 is semi-bold
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    Text(
                      'Detector',
                      style: SafeGoogleFont(
                        'Montserrat',
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w700, // 600 is semi-bold
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
