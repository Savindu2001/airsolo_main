
import 'package:airsolo/common/widgets/login_signup/form_divider.dart';
import 'package:airsolo/common/widgets/login_signup/social_buttons.dart';
import 'package:airsolo/features/authentication/screens/signup/verify_email.dart';
import 'package:airsolo/features/authentication/screens/signup/widget/terms_conditions.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/constants/texts.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:iconsax/iconsax.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final dark = AHelperFunctions.isDarkMode(context);
    return Form(
      child: Column(
        children: [
    
          // First & Last Name
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: ATexts.firstName,
                    prefixIcon: Icon(Iconsax.user))
                  ),
              ),
              const SizedBox(width: ASizes.spaceBtwinputFields,),
              Expanded(
                child: TextFormField(
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: ATexts.lastName,
                    prefixIcon: Icon(Iconsax.user))
                  ),
              ),
              
              
            ],
          ),
          const SizedBox(height: ASizes.spaceBtwinputFields,),
    
          //username
          TextFormField(
            expands: false,
            decoration: const InputDecoration(
              labelText: ATexts.username,
              prefixIcon: Icon(Iconsax.user_edit))
            ),
    
          const SizedBox(height: ASizes.spaceBtwinputFields,),
    
          //email
    
          TextFormField(
            expands: false,
            decoration: const InputDecoration(
              labelText: ATexts.email,
              prefixIcon: Icon(Iconsax.direct))
            ),
    
            const SizedBox(height: ASizes.spaceBtwinputFields,),
    
          //phone number
          TextFormField(
            expands: false,
            decoration: const InputDecoration(
              labelText: ATexts.phoneNo,
              prefixIcon: Icon(Iconsax.mobile))
            ),
    
            const SizedBox(height: ASizes.spaceBtwinputFields,),
    
          //password
          TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.password_check),
                labelText: ATexts.password ,
                suffixIcon: Icon(Iconsax.eye_slash)
              ),
            ),
    
            const SizedBox(height: ASizes.spaceBtwinputFields,),
    
          //terms & Conditions Checkbox
    
          ATermsConditions(),
          const SizedBox(height: ASizes.spaceBtwSections,),
    
          //Signup Buttons
          SizedBox( width:double.infinity, child: ElevatedButton(onPressed: () => Get.to(()=> const VerifyEmailScreen()), child: const Text(ATexts.createAccount),)),
          const SizedBox(height: ASizes.spaceBtwSections,),
    
    
          //Divider
    
          AFormDivider(dark: dark, dividerText: ATexts.orSignupWith),
    
          const SizedBox(height: ASizes.spaceBtwSections,),
    
        /// Footer
        const ASocialButton(), 
    
        ],
      ),
      );
  }
}
