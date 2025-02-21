import 'package:airsolo/common/widgets/appbar/appbar.dart';
import 'package:airsolo/common/widgets/custome_shapes/containers/primary_hader_container.dart';
import 'package:airsolo/common/widgets/layout/grid_layout.dart';
import 'package:airsolo/common/widgets/texts/item_title_text.dart';
import 'package:airsolo/features/tripgenie/screens/home/widgets/a_ai_features_category_card.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class AAIHomeScreen extends StatelessWidget {
  const AAIHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        body: SingleChildScrollView(
          child: Column(
            children: [
              //Header Section
          
              APrimaryHeaderContainer(
                
                child: Column(
                children: [
          
                  /// Appbar
                  const SizedBox(height: ASizes.spaceBtwSections *2,),
                  AAppBar(title: Center(child: Text('TripGenie', style: Theme.of(context).textTheme.headlineMedium!.apply(color: AColors.white),)),),

                  const SizedBox(height: ASizes.spaceBtwSections *2,),
          
                ],
              )),
          
              
          
              
          
          
              //Item Section
          
              
              Padding(
                padding: const EdgeInsets.all(ASizes.defaultSpace),
                  child: Column(
                    children: [

                      //Title
                      const AItemTitleText(title: 'AirSolo Ai Guide'),
                      const AItemTitleText(title: 'Make your next trip plan esaly', smallSize: true,),
                      const SizedBox(height: ASizes.spaceBtwItems *2,),


                      //Features Boxes
                      AGridLayout(
                        itemCount: 4, 
                        mainAxisExtent: 120,
                        itemBuilder: (_, index) {
                         return const AAiFeaturesCategoryCard(showBorder: true,);
                        }
                        ),

                    ],
                  ),),
                
          
                
            ],
          ),
        ),
    );
  }
}






