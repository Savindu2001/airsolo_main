import 'package:airsolo/common/widgets/custome_shapes/containers/primary_hader_container.dart';
import 'package:airsolo/common/widgets/custome_shapes/containers/scroll_item_cards.dart';
import 'package:airsolo/common/widgets/item_cards/horizantal_item_card.dart';
import 'package:airsolo/common/widgets/item_cards/vertical_item_card.dart';
import 'package:airsolo/common/widgets/layout/grid_layout.dart';
import 'package:airsolo/common/widgets/layout/list_layout.dart';
import 'package:airsolo/common/widgets/search_bar/default_searchbar.dart';
import 'package:airsolo/common/widgets/texts/section_heading.dart';
import 'package:airsolo/features/app/screens/home/widgets/banner_slider.dart';
import 'package:airsolo/features/app/screens/home/widgets/home_app_bar.dart';
import 'package:airsolo/features/app/screens/home/widgets/home_category.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            // Custom Circle Design
            APrimaryHeaderContainer(
                  child:   Container(
                      child:  Column(

                        children: [
                          //App Bar
                           AHomeAppBar(),
                           SizedBox(height: ASizes.spaceBtwSections,),
                          //SearchBar
                          ASearchBarContainer( text: 'Where you go next?', showBackground: true, showBorder: true, icon: Iconsax.search_normal,),
                          SizedBox(height: ASizes.spaceBtwItems+ 5,),

                          // Category Title & Icons

                          ASectionHeading(showActionButton: false, title: 'Find What You Need',  onPressed: (){}, textColor: AColors.white,),
                          const SizedBox(height: ASizes.spaceBtwItems,),


                          // Category Icons

                          AHomeCategories(),
                          

                        ]
                    ),
                  )
                  ),

                  ///Body Part
                  const ASectionHeading(title: 'Best Deals', showActionButton: false),
                  const Padding(
                    padding: EdgeInsets.all(ASizes.defaultSpace),
                    child: APromoSlider(autoPlay: true ,banners:  [ AImages.banner1, AImages.banner2, AImages.banner5 , AImages.banner3, AImages.banner4]),
                  ),

                  //Popular Hostels Card
                  const ASectionHeading(title: 'Best Hostels', showActionButton: false),
                  const SizedBox(height: ASizes.spaceBtwItems/2,),
                    //Hostel Grid
                    AGridLayout(itemCount: 4, itemBuilder: (_, index) => const AItemCardVertical(businessName: 'Tree House Hostel', scoreName: 'Fabolus', city: 'sigiriya', country: 'sri lanka', image: AImages.hostelImage1, score: 9.9, reviewCount: 1503, discount: 35, ), ),
                  


                  
                  




                  // Item Horizantal Card
                  const SizedBox(height: ASizes.spaceBtwItems,),
                  const ASectionHeading(title: 'Get inspired!', showActionButton: false),
                  const SizedBox(height: ASizes.spaceBtwItems/2,),
                  SizedBox(
                    height: 420,
                    child: AListLayout(itemCount: 3, itemBuilder: (_, index) => AItemCardHorizantal(scoreName: 'Super', businessName: 'Cozy Secrets', city: 'dambulla', country: 'sri lanka', image: AImages.hostelImage2, score: 7.5, reviewCount: 134, discount: 40, ))),
                  const SizedBox(height: ASizes.spaceBtwItems,),


                  //Popular Places Card
                  const ASectionHeading(title: 'Places!', showActionButton: true),
                  SizedBox(
                    height: 300,
                    child: AItemCardSlider(title: 'Mirissa', image: AImages.placeImage2,))

                   

            
          ],
        ),
      ),
    );
  }
}


