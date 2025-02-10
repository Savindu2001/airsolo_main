import 'package:airsolo/features/authentication/controllers/onboarding_controller.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: ADeviceUtils.getAppBarHeight(),
      right: ASizes.defaultSpace,
      child: TextButton(
        onPressed: ()=> OnboardingController.instance.skipPage(), 
        child: const Text('Skip')
        )
      );
  }
}