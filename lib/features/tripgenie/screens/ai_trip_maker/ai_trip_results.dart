
import 'package:airsolo/common/widgets/texts/item_title_text.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TripResultsScreen extends StatelessWidget {
  const TripResultsScreen({super.key});

  

  @override
  Widget build(BuildContext context) {
    final darkMode = AHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Trip Plans"), actions: [IconButton(onPressed: (){}, icon: const Icon(Iconsax.recovery_convert))],),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 3,
        itemBuilder: (context, index) {
          
          return Card(
            margin: EdgeInsets.only(bottom: ASizes.defaultSpace),
            color: darkMode ? AColors.darkerGrey : AColors.primary,
            shadowColor: Colors.black,
            child: Column(
              children: [
                const SizedBox(height: ASizes.spaceBtwItems,),
                // -- Title -- Generate Freindly Attractive Name..
                Text('Relax Vacation In Sri Lanka',style: Theme.of(context).textTheme.titleMedium,),

                        
                        
                // Days Count
                Padding(
                  padding: const EdgeInsets.all(ASizes.defaultSpace),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      const SizedBox(
                        width: 56,
                        height: 56,
                        child: Image(image: AssetImage(AImages.darkAppLogo)
                        )),
                  
                      const AItemTitleText(title: 'Sri Lanka'),
                  
                      Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          color: darkMode ? AColors.primary : AColors.white,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(100)
                        ),
                        child: Center(child: Text('14', style: Theme.of(context).textTheme.bodyLarge!.apply(color: AColors.black ),)),
                      ),
                    ],
                  ),
                ),
                // buttons 
                        
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox( width:double.infinity, child: ElevatedButton(onPressed: () {}, child: Text('View Full Trip',style: TextStyle(color: darkMode ? AColors.black : AColors.white),)),
                ),
                )    
              ],
            ),
          );
        },
      ),
    );
  }
}
