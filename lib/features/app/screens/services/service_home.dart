import 'package:airsolo/common/widgets/appbar/tabbar.dart';
import 'package:airsolo/common/widgets/category/a_category_card.dart';
import 'package:airsolo/common/widgets/layout/grid_layout.dart';
import 'package:airsolo/common/widgets/search_bar/default_searchbar.dart';
import 'package:airsolo/common/widgets/texts/section_heading.dart';
import 'package:airsolo/features/app/screens/services/widgets/category_tab.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/constants/texts.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ServiceHomeScreen extends StatelessWidget {
  const ServiceHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = AHelperFunctions.isDarkMode(context);
    return  DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title:  Text(ATexts.serviceScreenTitle, style: Theme.of(context).textTheme.headlineMedium,),
        ),
      
        body: NestedScrollView(
          headerSliverBuilder: (_, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                backgroundColor: dark ? AColors.black : AColors.white,
                expandedHeight: 440,
      
      
                flexibleSpace: Padding(
                  padding:  const EdgeInsets.all(ASizes.defaultSpace),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children:  [
                      
                      
                      //SearchBar
      
                      const SizedBox(height: ASizes.spaceBtwItems,),
                      const ASearchBarContainer(text: 'Where do you go next?', showBorder: true, showBackground: false,icon: Iconsax.search_normal,padding: EdgeInsets.zero,),
                      const SizedBox(height: ASizes.spaceBtwSections,),
      
                      //Services Categories
      
                      ASectionHeading(title: 'Featured Sevices', showActionButton: true,onPressed: (){} ,),
                      const SizedBox(height: ASizes.spaceBtwItems/ 1.5),
      
                      //
                      AGridLayout(
                        itemCount: 4, 
                        mainAxisExtent: 80,
                        itemBuilder: (_, index) {
                         return const ACategoryCard(showBorder: true,);
                        }
                        ),
      
                    ],
                  ),
                  ),
      
      
                  //Tabs - Categories
      
                  bottom:  const ATabBar(
                    tabs:  [
                      Tab(child: Text('Hostels'),),
                      Tab(child: Text('Taxi'),),
                      Tab(child: Text('Safari'),),
                      Tab(child: Text('Resturants'),),
                      Tab(child: Text('Events'),),
                      
                          
                          
                    ]
                  ),
      
      
              ),
            ];
          } , 
          body: const TabBarView(
            children: [
              
              ACategoryTab(),
              ACategoryTab(),
              ACategoryTab(),
              ACategoryTab(),
              ACategoryTab(),

            ]
            ),
          ),
      ),
    );
  }
}

