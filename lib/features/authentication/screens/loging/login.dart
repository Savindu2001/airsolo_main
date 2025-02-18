import 'package:airsolo/common/styles/spacing_styles.dart';
import 'package:airsolo/common/widgets/login_signup/form_divider.dart';
import 'package:airsolo/common/widgets/login_signup/social_buttons.dart';
import 'package:airsolo/features/authentication/screens/loging/widgets/login_form.dart';
import 'package:airsolo/features/authentication/screens/loging/widgets/login_header.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/constants/texts.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = AHelperFunctions.isDarkMode(context);
    return  Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: ASpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              /// Logo , Title & Subtitle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  ///Header Section
                  ALoginHeader(dark: dark),

                  ///Form 
                  ALoginForm(dark: dark),

                  ///Divider
                  AFormDivider(dark: dark, dividerText: ATexts.orSignInWith),
                  const SizedBox(height: ASizes.spaceBtwSections,),

                  /// Footer
                  const ASocialButton(),  
                  

                ],
              ),
            ],
          ),
          ),
      ),
    );
  }
}
