import 'package:airsolo/common/styles/spacing_styles.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key, required this.image, required this.title, required this.subTitle, required this.buttonText, required this.onPressed});

  final String image, title, subTitle, buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: ASpacingStyle.paddingWithAppBarHeight * 2,
          child: Column(
            children: [
              ///Image
              Image(image:  AssetImage(image), width: AHelperFunctions.screenWidth() * 0.6,),
              const SizedBox(height: ASizes.spaceBtwSections,),
              
              
              ///Title & SubTitle
              Text(title, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center,),
              const SizedBox(height: ASizes.spaceBtwItems,),
              Text(subTitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center,),
              const SizedBox(height: ASizes.spaceBtwSections,),
              

              ///Button
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: onPressed, child:  Text(buttonText)),),
              
            ],
          ),
          ),
      ),
    );
  }
}