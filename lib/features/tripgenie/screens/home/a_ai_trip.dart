import 'package:airsolo/common/widgets/appbar/appbar.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AAIHomeScreen extends StatelessWidget {
  const AAIHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AAppBar(
        title: Text(ATexts.aiScreenTitle, style: Theme.of(context).textTheme.headlineMedium,),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(ASizes.defaultSpace),
            child: Column(
              children: [
                //Header Section
            
                
            
            
                //Item Section
            
                
                  Container(
                    height: 360,
                    width: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all()
                    ),
                    child: const Column(
                      children: [

                        //--heading
                        Text('Super Feature'),

                        //--body
                        Text('Generate Trip Plan'),
                        
                        Icon(Iconsax.message, size: 40, ),
                        SizedBox(height: 10),
                        Text('Voice Chat', textAlign: TextAlign.center,),
                        
                      ],
                    ),
                  ),


                  Container(
                    height: 360,
                    width: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all()
                    ),
                    child: const Column(
                      children: [

                        //--heading
                        Text('Super Feature'),

                        //--body
                        Text('Generate Trip Plan'),
                        
                        Icon(Iconsax.message, size: 40, ),
                        SizedBox(height: 10),
                        Text('Voice Chat', textAlign: TextAlign.center,),
                        
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
    );
  }
}



Widget _aiItemCard(IconData icon, String title, VoidCallback onTap) {
    return Container(
      height: 120,
      width: 65,
      color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          const SizedBox(height: 10),
          Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }