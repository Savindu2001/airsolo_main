
import 'package:airsolo/common/widgets/custome_shapes/containers/rounded_card.dart';
import 'package:airsolo/common/widgets/images/a_circular_image.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ACategoryCard extends StatelessWidget {
  const ACategoryCard({
    super.key, required this.title, required this.subTitle, required this.image,
  });


  final String title,subTitle,image;
  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
                          onTap: (){},
                          child: ARoundedContainer(
     padding:  EdgeInsets.all(ASizes.sm),
     showBorder: true,
     backgroundColor: Colors.transparent,
     child: Row(
    
       children: [
         //Icon
         Flexible(
           child: ACircularImage(
             image: image,
             isNetworkImage: false,
             backgroundColor: Colors.transparent,
             overlayColor: AHelperFunctions.isDarkMode(context) ? AColors.white : AColors.dark,
             ),
         ),
                          
                          
           const SizedBox(width: ASizes.spaceBtwItems/2,),
                          
           //Text
                          
           Expanded(
             child: Column(
               mainAxisSize: MainAxisSize.min,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                                   
                 Row(
                   children: [
                     //Title
                       Text(title, style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 14)),
                       const SizedBox(width: ASizes.xs,),
                       //Badged
                       const Icon(Iconsax.verify5, color: AColors.primary, size: ASizes.iconXs,)
                   ],
                 ),
                                   
                 //
                 Text(
                   subTitle,
                   overflow: TextOverflow.ellipsis,
                   style: Theme.of(context).textTheme.labelMedium,
                 ),
                                   
                                   
               ],
             ),
           ),
       ],
     ),
                          
                          ),
                        );
  }
}
