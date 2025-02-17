import 'package:airsolo/common/widgets/category/a_category_showcase.dart';
import 'package:airsolo/common/widgets/item_cards/vertical_item_card.dart';
import 'package:airsolo/common/widgets/layout/grid_layout.dart';
import 'package:airsolo/common/widgets/texts/section_heading.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ACategoryTab extends StatelessWidget {
  const ACategoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
      Padding(
                  padding: EdgeInsets.all(ASizes.defaultSpace),
                  child: Column(
                    children: [
                      ///-- Category
                      ACategoryShowcase(images: [AImages.hostelImage1 ,AImages.hostelImage2, AImages.placeImage2],),
                      SizedBox(height: ASizes.spaceBtwItems,),
                      
                      
                      ///Services
                      ASectionHeading(title: 'You might like', showActionButton: true, onPressed: (){},),
                      SizedBox(height: ASizes.spaceBtwItems,),
      
                      //Service Item
                      AGridLayout(itemBuilder: (_, index) => AItemCardVertical(scoreName: 'Superb', businessName: 'City Hostel', city: 'colombo', country: 'sri lanka', image: AImages.hostelImage1, score: 8.9, reviewCount: 2314, discount: 10), itemCount: 12),
                      SizedBox(height: ASizes.spaceBtwSections,),
                      
                    ],
                  ),
                  ),

                  ]
    );
  }
}