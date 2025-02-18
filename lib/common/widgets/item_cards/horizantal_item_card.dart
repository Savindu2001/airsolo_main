import 'package:airsolo/common/widgets/icon/a_circular_icon.dart';
import 'package:airsolo/common/widgets/images/a_rounded_image.dart';
import 'package:airsolo/common/widgets/texts/item_title_text.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AItemCardHorizantal extends StatelessWidget {
  const AItemCardHorizantal({
    super.key, 
    required this.scoreName, 
    required this.businessName, 
    required this.city, 
    required this.country, 
    required this.image, 
    required this.score, 
    required this.reviewCount, 
    required this.discount, 
    this.showDiscount = true, 
    this.showReviewScore = true,
  });


  final String scoreName,businessName, city, country , image;
  
  final double score, reviewCount, discount;

  final bool showDiscount, showReviewScore;

  @override
  Widget build(BuildContext context) {
    final dark = AHelperFunctions.isDarkMode(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: ASizes.defaultSpace/2),
      padding: const EdgeInsets.all(ASizes.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ASizes.borderRadiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        color: dark 
            ? AColors.black
            : AColors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🔹 Left Side: Image with Tag
          Stack(
            children: [

              SizedBox(
                width: 80,
                height: 80,
                child: ARoundedImage(imageUrl: image, applyImageRadius: true,)),
               Positioned(
                  top: 6,
                  left: 6,
                  child: showDiscount ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '-${discount.toInt()}%',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ) : Container(),
                ),


                
            ],
          ),
    
          const SizedBox(width: 12),
    
          // 🔹 Middle Section: Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AItemTitleText(title: businessName),
                const SizedBox(height: 4),
                AItemTitleText(title: '$city | $country',smallSize: true,),
                
                const SizedBox(height: ASizes.sm),
                Row(
                  children: [
                    const Icon(Iconsax.magic_star1, color: AColors.primary, size: ASizes.md),
                    const SizedBox(width: 4),
                    Text(
                      '$scoreName • (${reviewCount.toInt()})',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
    
          // 🔹 Right Side: Score Badge
          Column(
            children: [


          ///Favourite Icon
          const Positioned(
            top: 0,
            right: 0,
            child: ACircular_Icon(
              icon: Iconsax.heart5, 
              color: Colors.red, 
              size: 24, 
              backgroundColor: AColors.lightGrey,
              
              ),),


            const SizedBox(height: ASizes.sm,),




        if (showReviewScore == true)
          Container(
            padding: const EdgeInsets.all(ASizes.xs),
            decoration: BoxDecoration(
              color: AColors.primary,
              borderRadius: BorderRadius.circular(ASizes.borderRadiusSm),
            ),
            child:  Text(
              '$score',
              style: const TextStyle(color: AColors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),

            ],
          ),
      

      

        ],
      ),
    );
  }
}
