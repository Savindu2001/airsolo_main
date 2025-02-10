
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ASocialButton extends StatelessWidget {
  const ASocialButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(color: AColors.grey), borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: (){}, 
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
            onPressed: (){}, 
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
