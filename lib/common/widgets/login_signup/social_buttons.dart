
import 'package:airsolo/features/authentication/controllers/social_login_controller.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ASocialButton extends StatelessWidget {
  const ASocialButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SocialLoginController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(color: AColors.grey), borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: ()=> controller.signInWithGoogle(), 
            icon: const Image(
              width: ASizes.iconMd,
              height: ASizes.iconMd,
              image: AssetImage(AImages.google)
              )
            ),
        ),
        const SizedBox(width: ASizes.spaceBtwItems,),
        Container(
          decoration: BoxDecoration(border: Border.all(color: AColors.grey), borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: (){
              ALoaders.warningSnackBar(title: 'Coming Soon!', message: 'Facebook Login Coming Soon.. Stay Tuned!');
             
            }, 
            icon: const Image(
              width: ASizes.iconMd,
              height: ASizes.iconMd,
              image: AssetImage(AImages.facebook)
              )
            ),
        ),

        
        
        
    
      ],
    );
  }
}
