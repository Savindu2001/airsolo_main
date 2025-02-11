import 'package:airsolo/common/widgets/success_screen/success_screen.dart';
import 'package:airsolo/features/authentication/screens/loging/login.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/constants/texts.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: () => Get.offAll(()=> const LoginScreen()), icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body:  SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(ASizes.defaultSpace),
          child: Column(
            children: [
              ///Image
              Image(image: const AssetImage(AImages.verifyEmail), width: AHelperFunctions.screenWidth() * 0.6,),
              const SizedBox(height: ASizes.spaceBtwSections,),
              
              
              ///Title & SubTitle
              Text(ATexts.confirmEmail, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center,),
              const SizedBox(height: ASizes.spaceBtwItems,),
              Text('savindu.info@gmail.com', style: Theme.of(context).textTheme.labelLarge, textAlign: TextAlign.center,),
              const SizedBox(height: ASizes.spaceBtwItems,),
              Text(ATexts.confirmEmailSubTitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center,),
              const SizedBox(height: ASizes.spaceBtwSections,),
              

              SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                            onPressed: () => Get.to(() => SuccessScreen(
                                  image: AImages.verifiedEmail,
                                  title: ATexts.yourAccountCreatedTitle,
                                  subTitle: ATexts.yourAccountCreatedSubTitle,
                                  buttonText: ATexts.aContinue,
                                  onPressed: () => Get.to(() => const LoginScreen()), // Clears backstack
                                )),
                            child: const Text(ATexts.aContinue),
                      ),
                    ),

              SizedBox(height: ASizes.spaceBtwItems,),
              SizedBox(width: double.infinity, child: TextButton(onPressed: (){}, child: const Text(ATexts.resendEmail)),),
              

            ],
          ),
          ),
      ),
    );
  }
}