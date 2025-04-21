import 'package:airsolo/common/widgets/custome_shapes/containers/rounded_card.dart';
import 'package:airsolo/common/widgets/icon/a_circular_icon.dart';
import 'package:airsolo/common/widgets/images/a_rounded_image.dart';
import 'package:airsolo/common/widgets/item_cards/item_review_score_vertical.dart';
import 'package:airsolo/common/widgets/texts/item_title_text.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/shadows.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AItemCardVertical extends StatelessWidget {
  const AItemCardVertical({super.key, 
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
  this.applyImageRadius = true, 
  this.smallSize = true});




  final String scoreName,businessName, city, country , image;
  
  final double score, reviewCount, discount;

  final bool showDiscount, showReviewScore,applyImageRadius,smallSize;

  @override
  Widget build(BuildContext context) {
    final dark = AHelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ASizes.itemImageRadius),
          boxShadow: [AShadowStyle.verticalItemShadow] ,
          color: dark ? AColors.black : AColors.white,
        ),
      
        child: Column(
          children: [
      
            //Thumbnail
            ARoundedContainer(
              height: 180,
              padding: const EdgeInsets.all(ASizes.sm),
              backgroundColor: dark ? AColors.dark : AColors.light,
              child:  Stack(
                children: [
                  ///-- Thumbnail Image
                   ARoundedImage(imageUrl: image, applyImageRadius: applyImageRadius,),
      
                  /// Sales Tag
                  if(showDiscount == true)
                  Positioned(
                    top: 12,
                    left: 2,
                    child: ARoundedContainer(
                      radius: ASizes.sm,
                      backgroundColor: AColors.itemSaleTag.withOpacity(0.8 ),
                      padding: const EdgeInsets.symmetric(horizontal: ASizes.sm, vertical: ASizes.xs),
                      child: Text('-$discount%' ,  style: Theme.of(context).textTheme.labelLarge!.apply(color: AColors.white),),
                    ),
                  ),
      
                  ///Favourite Icon
                  const Positioned(
                    top: 0,
                    right: 0,
                    child: ACircular_Icon(icon: Iconsax.heart5, color: Colors.red, size: 24, ),),
            
      
      
                ],
              ),
            ),
      
            // -- Datils
      
             Padding(
              padding:  const EdgeInsets.only(left: ASizes.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
      
                      // -- Business Name
                      AItemTitleText(title: businessName,),
      
      
                      
      
      
                      // -- City/Country
                      AItemTitleText(title: '$city | $country',smallSize: smallSize,),
                      const SizedBox(height: ASizes.spaceBtwItems/2,),
      
      
      
      
                      // -- Review Score Lable (Average Name Ex - score =< 6 super , )
                      AItemReviewScoreVertical(reviewTitle: scoreName, score: score, reviewCount: reviewCount,),
                      const SizedBox(height: ASizes.spaceBtwItems/2,),
                    ],
                  ),),
      
            
      
            
      
            
      
      
      
            
      
      
      
      
      
          ],
        ),
      
      ),
    );
  }
}

