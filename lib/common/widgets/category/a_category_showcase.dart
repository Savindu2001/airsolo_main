import 'package:airsolo/common/widgets/category/a_category_card.dart';
import 'package:airsolo/common/widgets/custome_shapes/containers/rounded_card.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class ACategoryShowcase extends StatelessWidget {
  const ACategoryShowcase({
    super.key, required this.images,
  });

  final List<String> images;


  @override
  Widget build(BuildContext context) {
    
    return ARoundedContainer(
      showBorder: true,
      borderColor: AColors.darkGrey,
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.only(bottom: ASizes.spaceBtwItems),
      padding: EdgeInsets.all(ASizes.md),
      child: Column(
      children: [
    
        //Category -- with service Count 
        ACategoryCard(showBorder: false,),
    
        //Category -- with 3 images 
        Row(
          children: images.map((image) => categoryTopServiceImageWidget(image, context)).toList(),
        ),
      ],
      ),
    );
  }
}


Widget categoryTopServiceImageWidget (String image, context){

  return Expanded(
              child: ARoundedContainer(
                height: 100,
                backgroundColor: AHelperFunctions.isDarkMode(context) ? AColors.darkGrey : AColors.light,
                margin: EdgeInsets.only(right: ASizes.sm),
                padding: EdgeInsets.all(ASizes.sm),
                child: Image(image: AssetImage(image), fit: BoxFit.contain, ),
              ),
            );

}
