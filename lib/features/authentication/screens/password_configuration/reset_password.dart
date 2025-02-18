import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/constants/texts.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: () => Get.back(), icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ASizes.defaultSpace),
          child: Column(
            children: [
              ///Image
              Image(image:  const AssetImage(AImages.sentEmail), width: AHelperFunctions.screenWidth() * 0.6,),
              const SizedBox(height: ASizes.spaceBtwSections,),
              
              
              ///Title & SubTitle
              Text(ATexts.changeYourPasswordTitle, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center,),
              const SizedBox(height: ASizes.spaceBtwItems,),
              Text(ATexts.changeYourPasswordSubTitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center,),
              const SizedBox(height: ASizes.spaceBtwSections,),
              

              ///Button
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: (){}, child: const  Text(ATexts.done)),),
              const SizedBox(height: ASizes.spaceBtwItems,),
              SizedBox(width: double.infinity, child: TextButton(onPressed: (){}, child:  const Text(ATexts.resendEmail)),),
            ],
          ),
          ),
      ),
    );
  }
}