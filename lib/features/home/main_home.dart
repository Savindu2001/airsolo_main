import 'package:airsolo/common/widgets/custome_shapes/containers/primary_hader_container.dart';
import 'package:airsolo/common/widgets/item_cards/horizantal_item_card.dart';
import 'package:airsolo/common/widgets/item_cards/vertical_item_card.dart';
import 'package:airsolo/common/widgets/layout/grid_layout.dart';
import 'package:airsolo/common/widgets/layout/list_layout.dart';
import 'package:airsolo/common/widgets/search_bar/default_searchbar.dart';
import 'package:airsolo/common/widgets/texts/section_heading.dart';
import 'package:airsolo/features/city/controller/city_controller.dart';
import 'package:airsolo/features/city/screen/city_detail_screen.dart';
import 'package:airsolo/features/city/screen/city_screen.dart';
import 'package:airsolo/features/home/widgets/banner_slider.dart';
import 'package:airsolo/features/home/widgets/home_app_bar.dart';
import 'package:airsolo/features/home/widgets/home_category.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
 final cityController = Get.put(CityController());
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
                           const AHomeAppBar(),
                           const SizedBox(height: ASizes.spaceBtwSections,),
                          //SearchBar
                          const ASearchBarContainer( text: 'Where you go next?', showBackground: true, showBorder: true, icon: Iconsax.search_normal,),
                          const SizedBox(height: ASizes.spaceBtwItems+ 5,),

                          // Category Title & Icons

                          ASectionHeading(showActionButton: false, title: 'Find What You Need',  onPressed: (){}, textColor: AColors.white,),
                          const SizedBox(height: ASizes.spaceBtwItems,),


                          // Category Icons

                          const AHomeCategories(),
                          const SizedBox(height: ASizes.spaceBtwSections,),
                          

                        ]
                    ),
                  )
                  ),

                  

                  ///Body Part
                  const Padding(
                    padding: EdgeInsets.only(left: ASizes.defaultSpace),
                    child: ASectionHeading(title: 'Explore Sri Lanka', showActionButton: false),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(ASizes.defaultSpace),
                    child: APromoSlider(autoPlay: true ,banners:  [ AImages.banner1, AImages.banner2, AImages.banner5 ]),
                  ),



                  //Popular City Card
                  _buildPopularCities(),
                  const SizedBox(height: ASizes.spaceBtwSections,),

                  //Popular Hostels Card
                  const Padding(
                    padding: EdgeInsets.only(left: ASizes.defaultSpace),
                    child: ASectionHeading(title: 'Best Hostels', showActionButton: false),
                  ),
                  const SizedBox(height: ASizes.spaceBtwItems/2,),
                    //Hostel Grid
                    AGridLayout(itemCount: 4, itemBuilder: (_, index) => const AItemCardVertical(businessName: 'Tree House Hostel', scoreName: 'Fabolus', city: 'sigiriya', country: 'sri lanka', image: AImages.hostelImage1, score: 9.9, reviewCount: 1503, discount: 35, ), ),
                  

                  // Item Horizantal Card
                  const SizedBox(height: ASizes.spaceBtwItems,),
                  const Padding(
                    padding: EdgeInsets.only(left: ASizes.defaultSpace),
                    child: ASectionHeading(title: 'Get inspired!', showActionButton: false),
                  ),
                  const SizedBox(height: ASizes.spaceBtwItems/2,),
                  SizedBox(
                    height: 420,
                    child: AListLayout(itemCount: 3, itemBuilder: (_, index) => const AItemCardHorizantal(scoreName: 'Super', businessName: 'Cozy Secrets', city: 'dambulla', country: 'sri lanka', image: AImages.hostelImage2, score: 7.5, reviewCount: 134, discount: 40, ))),
                  const SizedBox(height: ASizes.spaceBtwItems,),

                   

            
          ],
        ),
      ),
    );
  }
}



// City Section
Widget _buildPopularCities() {
  final cityController = Get.find<CityController>();
  
  return Obx(() {
    
    final displayedCities = cityController.cities.take(7).toList();
    
    if (displayedCities.isEmpty) {
      return const SizedBox(height: 0); 
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: ASizes.defaultSpace),
          child: Row(
            children: [
              Text('Popular Places', style: Get.textTheme.headlineSmall),
              const Spacer(),
              TextButton(
                onPressed: () => Get.toNamed('/cities'),
                child: const Text('View All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: ASizes.spaceBtwItems),
        SizedBox(
          height: 220, // Fixed height for the horizontal list
          child: ListView.separated( // Using separated for better control
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: displayedCities.length,
            itemBuilder: (_, index) {
              final city = displayedCities[index];
              return SizedBox( // Constrained width
                width: 180,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque, // Better touch handling
                  onTap: () => Get.to(
                    () => CityDetailScreen(city: city),
                    transition: Transition.cupertino,
                  ),
                  child: CityCard(
                    city: city,
                    key: ValueKey(city.id), 
                    onTap: () => Get.to(
                  () => CityDetailScreen(city: cityController.cities[index]),
                  transition: Transition.cupertino,
                ), // Unique key for each card
                ),)
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: ASizes.spaceBtwItems),
          ),
        ),
      ],
    );
  });
}