
import 'package:airsolo/common/widgets/custome_shapes/containers/circle_container.dart';
import 'package:airsolo/common/widgets/images/a_rounded_image.dart';
import 'package:airsolo/features/home/controllers/home_controller.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class APromoSlider extends StatelessWidget {
  const APromoSlider({
    super.key, required this.banners,  this.autoPlay = true,
  });

  final List<String> banners;
  final bool autoPlay;

  @override
  Widget build(BuildContext context) {
     final controller = Get.put(HomeController());
    return Column(
      children: [
    
        // Slider Images   
        CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 1,
            onPageChanged: (index, _) => controller.updatePageIndicator(index), 
            autoPlay: autoPlay,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
          ),
        
          items: banners.map((url) =>  ARoundedImage(imageUrl: url, applyImageRadius: true,)).toList(),
          
        ),
    
        const SizedBox(height: ASizes.spaceBtwItems,),
    
         Center(
           child: Obx(
             () =>  Row(
              mainAxisSize: MainAxisSize.min,
              children: [ 
                for (int i =0; i < banners.length; i++)  
                  ACircularContainer(
                    width: 20, 
                    height: 4, 
                    margin: const EdgeInsets.only(right: 10), 
                    backgroundColor: controller.carouselIndex.value == i ? AColors.primary : AColors.grey 
                    ),
              ], 
                     ),
           ),
         ),
      ],
    
     
    
     
    );
  }
}
