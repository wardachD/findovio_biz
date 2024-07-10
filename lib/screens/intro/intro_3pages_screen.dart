import 'package:animated_introduction/animated_introduction.dart';
import 'package:findovio_business/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'widgets/intro_pages_collection.dart';

class Intro3PagesScreen extends StatelessWidget {
  const Intro3PagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedIntroduction(
              isFullScreen: false,
              containerBg: Colors.white,
              containerBorderColor: Color.fromARGB(117, 206, 206, 206),
              footerBgColor: Color.fromARGB(255, 255, 255, 255),
              activeDotColor: const Color.fromARGB(255, 110, 110, 110),
              inactiveDotColor: const Color.fromARGB(255, 153, 153, 153),
              topHeightForFooter: MediaQuery.sizeOf(context).height * 0.62,
              slides: pages,
              indicatorType: IndicatorType.line,
              onDone: () {
                Get.toNamed(Routes.INTRO_LOGIN_EMAIL);
              },
              onRegister: () {
                Get.toNamed(Routes.INTRO_REGISTER_EMAIL_NAME);
              },
            ),
            Positioned(
              top: 25,
              left: 0,
              right: 0,
              child: SvgPicture.asset(
                'assets/images/findovio_business_logo_full.svg',
                fit: BoxFit.fitHeight,
                height: MediaQuery.sizeOf(context).width *
                    0.15, // Adjust height as needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}
