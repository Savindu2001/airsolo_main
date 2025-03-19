import 'package:airsolo/common/widgets/appbar/appbar.dart';
import 'package:airsolo/features/app/screens/hostel/widgets/a_hostel_awards_batch.dart';
import 'package:airsolo/features/app/screens/hostel/widgets/a_hostel_Image_slider.dart';
import 'package:airsolo/features/app/screens/hostel/widgets/a_hostel_book_bottom_sheet.dart';
import 'package:airsolo/features/app/screens/hostel/widgets/a_hostel_event_card_linkups.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/constants/texts.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:airsolo/features/app/screens/hostel/widgets/a_hostel_bottom_sheet.dart';

class HostelDetails extends StatelessWidget {
  const HostelDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = AHelperFunctions.isDarkMode(context);
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
              padding: const EdgeInsets.only(right: ASizes.defaultSpace, left: ASizes.defaultSpace, bottom: ASizes.defaultSpace/2),
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
                  const SizedBox(height: ASizes.spaceBtwItems/2,),

                  ///  Default Amentions
                  const AHostel_Awards_Badge(),

                  const SizedBox(height: ASizes.spaceBtwItems /2,),
                ],
              ),
              ),

              // Hostel Events
              const AHostel_Events_Card(),
              const SizedBox(height: ASizes.spaceBtwItems /2,),


              Padding(
              padding: const EdgeInsets.only(right: ASizes.defaultSpace, left: ASizes.defaultSpace, top: ASizes.defaultSpace/2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  //About
                  Row(
                    children: [
                       Text('About',style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 24, ),),
                    ],
                  ),
                  const SizedBox(height: ASizes.sm,),

                  Text('Hey Guys!! Come As Guest And Go As Friend we are from sigiriya, near to the jungle, welcome to srilanka and please contact us',
                  style: Theme.of(context).textTheme.bodyLarge,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                       TextButton(onPressed: ()=> showCustomBottomSheet(context, 0), child: Row(
                         children: [
                           Text('Read more',style: Theme.of(context).textTheme.titleLarge,),
                           const Icon(Icons.arrow_right_sharp)
                         ],
                       ))
                    ],
                  ),

                  const Divider(),
                  const SizedBox(height: ASizes.md,),

                  // Check in & out Time Show
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                      //--check in
                      Row(
                        children: [
                          Icon(Iconsax.login, size: 36, color: Colors.green,),
                          SizedBox(width: ASizes.sm,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Check in'),
                              Text('14:00 - 23:00')
                            ],
                          ),
                        ],
                      ),

                      //--check out
                      Row(
                        children: [
                          Icon(Iconsax.login, size: 36, color: Colors.red,),
                          SizedBox(width: ASizes.sm,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Check out'),
                              Text('12:00')
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: ASizes.md,),
                  const Divider(),

                  //Tax & Hosuse Rule Section
                  Text('Tax included',
                  style: Theme.of(context).textTheme.bodyLarge,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                       TextButton(onPressed: ()=> showCustomBottomSheet(context, 2), child: Row(
                         children: [
                           Text('View all House rules',style: Theme.of(context).textTheme.titleLarge,),
                           const Icon(Icons.arrow_right_sharp)
                         ],
                       ))
                    ],
                  ),

                  const Divider(),
                  const SizedBox(height: ASizes.md,),


                // Facility ItemS
                  SizedBox(
                    height: 60,
                    child: ListView.separated(
                      itemCount: 6,
                      shrinkWrap: true,
                      separatorBuilder: (_,__)=> const SizedBox(width: ASizes.sm,),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, index)=> Container(
                        decoration: BoxDecoration(
                          color: dark ? AColors.white : AColors.black,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Iconsax.wifi, size: 24, color: dark ? AColors.black : AColors.white,),
                              const SizedBox(width: ASizes.sm,),
                              Text('Free Wifi', style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: dark ? AColors.black : AColors.white),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: ASizes.md,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                       TextButton(onPressed: () => showCustomBottomSheet(context, 1), child: Row(
                                        children: [
                                          Text('View all facilities',style: Theme.of(context).textTheme.titleLarge,),
                                          const Icon(Icons.arrow_right_sharp)
                                        ],
                       ))
                    ],
                  ),
                  const SizedBox(height: ASizes.defaultSpace/2),


                  // Book Hostel Button
                  SizedBox( width:double.infinity, child: ElevatedButton(onPressed: () => BookHostelStayBottomSheet.show(context,0)
                  , child: const Text(ATexts.bookH), )),

                  const SizedBox(height: ASizes.defaultSpace,),

                      
                    ],
                  ),

              ),
              




          ],
        ),
      ),
    );
  }

}