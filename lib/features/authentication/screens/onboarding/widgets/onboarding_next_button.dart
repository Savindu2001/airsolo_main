
import 'package:airsolo/features/authentication/controllers/onboarding_controller.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/device/device_utility.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final dark = AHelperFunctions.isDarkMode(context);
    return Positioned(
      right: ASizes.defaultSpace,
      bottom: ADeviceUtils.getBottomNavigationBarHeight(),
      child: ElevatedButton(
        onPressed: ()=> OnboardingController.instance.nextPage(), 
        child: Icon(Iconsax.arrow_right_3),
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          backgroundColor: dark ? AColors.primary : AColors.black
          ),
        )
      );
  }
}
