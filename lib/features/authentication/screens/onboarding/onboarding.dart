 import 'package:airsolo/features/controllers/onboarding_controller.dart';
import 'package:airsolo/features/authentication/screens/onboarding/widgets/onboarding_navigation_dot.dart';
import 'package:airsolo/features/authentication/screens/onboarding/widgets/onboarding_next_button.dart';
import 'package:airsolo/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:airsolo/features/authentication/screens/onboarding/widgets/onboarding_skip.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());
    return  Scaffold(
      body: Stack(
        children: [
          //Horizantal Scroll Page
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator ,
            children:  const [
              OnBoardingPage(
                image: AImages.onboard1,
                title: ATexts.onboardingTitle1,
                subTitle: ATexts.onboardingSubTitle1,
              ), 

              OnBoardingPage(
                image: AImages.onboard2,
                title: ATexts.onboardingTitle2,
                subTitle: ATexts.onboardingSubTitle2,
              ), 

              OnBoardingPage(
                image: AImages.onboard3,
                title: ATexts.onboardingTitle3,
                subTitle: ATexts.onboardingSubTitle3,
              ), 
            ]
            ),





          //Skip Button

          const OnBoardingSkip(),

          //Dot Navigation SmoothPageIndicator

          const OnBoardingNavigationDot(),

          //Circle Button

          const OnBoardingNextButton(),

        ],
      ),
    );
  }
}
