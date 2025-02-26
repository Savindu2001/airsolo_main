import 'package:airsolo/common/widgets/custome_shapes/curved_edges/curved_edges_widgets.dart';
import 'package:airsolo/common/widgets/images/a_rounded_image.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class AHostelImageSlider extends StatelessWidget {
  const AHostelImageSlider({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final darkMode = AHelperFunctions.isDarkMode(context);
    return ACustomCurvedWidget(
      child: Container(
        color: darkMode ? AColors.darkerGrey : AColors.light,
        child: Stack(
          children: [
            
            // Main Large Image
            const SizedBox(
              height: 400, 
              width: double.infinity,
              child: Padding(
              padding: EdgeInsets.zero,
              child: Center(
                child: Image(image: AssetImage(AImages.hostelImage1))),
            )),
    
            //Image Slider
            Positioned(
              right: 0,
              bottom: 30,
              left: ASizes.defaultSpace,
              child: SizedBox(
                height: 80,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (_, __) => const SizedBox(width: ASizes.spaceBtwItems,), 
                  itemCount: 6,
                  itemBuilder: (_, index) =>  ARoundedImage(
                    applyImageRadius: true,
                    backgroundColor:  AColors.white ,
                    border: Border.all(color: AColors.white ),
                    padding: const EdgeInsets.all(ASizes.sm/8),
                    width: 80,
                    fit: BoxFit.contain,
                    imageUrl: AImages.hostelImage2),
                    
                    ),
              ),
            ),
    
    
            
            
    
          ],
        ),
      ),
    );
  }
}