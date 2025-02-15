import 'package:airsolo/common/widgets/custome_shapes/containers/rounded_card.dart';
import 'package:airsolo/common/widgets/icon/a_circular_icon.dart';
import 'package:airsolo/common/widgets/images/a_rounded_image.dart';
import 'package:airsolo/common/widgets/texts/item_title_text.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AItemCardImageVertical extends StatelessWidget {
  const AItemCardImageVertical({super.key, 
  
  required this.image, required this.title, 
  
  });




  final String image, title;
  

  @override
  Widget build(BuildContext context) {
    final dark = AHelperFunctions.isDarkMode(context);
    return Container(
      width: 180,
      margin: EdgeInsets.all(ASizes.sm),
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ASizes.itemImageRadius),
        
      ),

      child: Column(
        children: [

          //Thumbnail
          ARoundedContainer(
            height: 180,
            padding: EdgeInsets.zero,
            backgroundColor: dark ? AColors.dark : AColors.light,
            child:  Stack(
              children: [
                ///-- Thumbnail Image
                 ARoundedImage(imageUrl: image, applyImageRadius: true,),

                ///Favourite Icon
                const Positioned(
                  top: 0,
                  right: 0,
                  child: ACircular_Icon(icon: Iconsax.heart5, color: Colors.red, size: 24, ),),


                   Positioned(
                    top: 125,
                    left: 0,
                    child: Container(
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AItemTitleText(title: title,),
                      ))
                    ),
          


              ],
            ),
          ),

        ],
      ),

    );
  }
}

