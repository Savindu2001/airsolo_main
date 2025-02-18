
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class AVerticalImageText extends StatelessWidget {
  const AVerticalImageText({
    super.key, required this.image, required this.title,  this.textColor = AColors.white, this.backgroundColor = AColors.white, this.onTap,
  });

  final String image, title;
  final Color textColor;
  final Color? backgroundColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: ASizes.spaceBtwItems),
        child: Column(
          children: [
            
            // Circular
            Container(
              height: 56,
              width: 56,
              padding: const EdgeInsets.all(ASizes.sm),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: backgroundColor ?? (AHelperFunctions.isDarkMode(context) ?  AColors.black : AColors.white),
                 
              ),
              child: Center(
                child: Image(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                  ),
              ),
            ),
        
            //Text
        
            const SizedBox(height: ASizes.spaceBtwItems/2,),
            SizedBox(
              width: 55 ,
              child: Text(title, 
              style: Theme.of(context).textTheme.labelMedium!.apply(color: textColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              )),
          ],
        ),
      ),
    );
  }
}
