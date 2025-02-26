import 'package:airsolo/common/widgets/appbar/appbar.dart';
import 'package:airsolo/features/app/screens/hostel/widgets/a_default_amentions.dart';
import 'package:airsolo/features/app/screens/hostel/widgets/a_hostel_Image_slider.dart';
import 'package:airsolo/features/app/screens/hostel/widgets/a_hostel_event_card_linkups.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class HostelDetails extends StatelessWidget {
  const HostelDetails({super.key});

  @override
  Widget build(BuildContext context) {
    
    return   Scaffold(
      appBar: AAppBar(
        showBackArrow: true,
        title: Text('Tree House Hostel Sigiriya', style: Theme.of(context).textTheme.titleLarge,),
        actions: [
          //WishList
          IconButton(onPressed: (){}, icon: const Icon(Iconsax.heart5)),
          IconButton(onPressed: (){}, icon: const Icon(Icons.share))
        ],
        ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            // -- Hostel Images Slider
            const AHostelImageSlider(),



            // -- Hostel Details
            Padding(
              padding: const EdgeInsets.only(right: ASizes.defaultSpace, left: ASizes.defaultSpace, bottom: ASizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  /// Rating & Share
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //-- rating
                      Row(
                        children: [
                          const Icon(Iconsax.star5, color: Colors.amber, size: ASizes.iconLg,),
                          const SizedBox(width: ASizes.spaceBtwItems / 2,),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: '9.8',style: Theme.of(context).textTheme.titleLarge),
                                TextSpan(text: ' (1238)',style: Theme.of(context).textTheme.bodyLarge),
                              ]
                            )
                          ),
                        ],
                      ),
                      //--share button
                      IconButton(onPressed: (){}, icon: const Icon(Icons.share, size: ASizes.iconMd,))
                    ],
                  ),
                  ///Hostel Name & Tag
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hostel',style: Theme.of(context).textTheme.titleLarge),
                      Text('Tree House \n Hostel Sigiriya',style: Theme.of(context).textTheme.headlineLarge,),
                      Row(
                        children: [
                          const Icon(Iconsax.location),
                          Text('Sigiriya | Sri lanka',style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: ASizes.spaceBtwItems,),

                  ///  Default Amentions
                  ADefault_Amentions(),

                  const SizedBox(height: ASizes.spaceBtwItems,),


                  // Hostel Events

                  AHostel_Events_Card(),
                  

                  
                  /// price, title, avalibility 
                  
                  /// Bed Details & Book Button
                  /// Description
                  /// Reviews
                ],
              ),
              ),


          ],
        ),
      ),
    );
  }
}
