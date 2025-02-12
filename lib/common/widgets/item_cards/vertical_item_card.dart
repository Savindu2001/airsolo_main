import 'package:airsolo/common/widgets/custome_shapes/containers/rounded_card.dart';
import 'package:airsolo/common/widgets/icon/a_circular_icon.dart';
import 'package:airsolo/common/widgets/images/a_rounded_image.dart';
import 'package:airsolo/common/widgets/texts/item_title_text.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/constants/shadows.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AItemCardVertical extends StatelessWidget {
  const AItemCardVertical({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = AHelperFunctions.isDarkMode(context);
    return Container(
      width: 180,
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ASizes.itemImageRadius),
        boxShadow: [AShadowStyle.verticalItemShadow] ,
        color: dark ? AColors.darkerGrey : AColors.white,
      ),

      child: Column(
        children: [

          //Thumbnail
          ARoundedContainer(
            height: 180,
            padding: EdgeInsets.all(ASizes.sm),
            backgroundColor: dark ? AColors.dark : AColors.light,
            child:  Stack(
              children: [
                ///-- Thumbnail Image
                ARoundedImage(imageUrl: AImages.hostelImage1, applyImageRadius: true,),

                /// Sales Tag
                Positioned(
                  top: 12,
                  left: 2,
                  child: ARoundedContainer(
                    radius: ASizes.sm,
                    backgroundColor: AColors.itemSaleTag.withOpacity(0.8 ),
                    padding: EdgeInsets.symmetric(horizontal: ASizes.sm, vertical: ASizes.xs),
                    child: Text('30%' ,  style: Theme.of(context).textTheme.labelLarge!.apply(color: AColors.white),),
                  ),
                ),

                ///Favourite Icon
                Positioned(
                  top: 0,
                  right: 0,
                  child: ACircular_Icon(icon: Iconsax.heart5, color: Colors.red, size: 24, ),),
          


              ],
            ),
          ),

          // -- Datils

           Padding(
            padding: const EdgeInsets.only(left: ASizes.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // -- Business Name
              AItemTitleText(title: 'TreeHouse Hostel',),


              


              // -- City/Country
              AItemTitleText(title: 'sigiriya | sri lanka',smallSize: true,),
              SizedBox(height: ASizes.spaceBtwItems/2,),




              // -- Review Score Lable (Average Name Ex - score =< 6 super , )
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Icon(Iconsax.magic_star1, color: AColors.reviewStar,),
                      Text('9.9 ', style: Theme.of(context).textTheme.headlineSmall),

                    ],
                  ),


                  Row(
                    children: [

                       Text('Fabulous'),
                        Text('(1503)'),

                    ],
                  ),
                  
                 
                ],
              ),
              SizedBox(height: ASizes.spaceBtwItems/2,),
            ],
          ),),

          

          

          



          





        ],
      ),

    );
  }
}

