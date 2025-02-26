import 'package:airsolo/common/widgets/appbar/appbar.dart';
import 'package:airsolo/common/widgets/custome_shapes/containers/primary_hader_container.dart';
import 'package:airsolo/common/widgets/texts/section_heading.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AiResultDetails extends StatelessWidget {
  const AiResultDetails({super.key});

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
                  AAppBar(showBackArrow: true,actions: [IconButton(onPressed: (){}, icon: const Icon(Iconsax.heart5))],),
                  AAppBar(
                    title: Center(child: Text('14 Day Relax Tour Plan', style: Theme.of(context).textTheme.headlineMedium!.apply(color: AColors.white),)),),

                  const SizedBox(height: ASizes.spaceBtwSections *2,),
          
                ],
              )),



              // Result Details

              const Padding(
                padding: EdgeInsets.all(ASizes.defaultSpace),
                child: Column(
                  children: [
                    //-- Title
                    ASectionHeading(title: '14 Day Tour Plan', showActionButton: false),
                    SizedBox(height: ASizes.sm,),
                    //-- description
                    Text('Performing hot reload...   Reloaded 16 of 1005 libraries in 436ms (compile: 56 ms, reload: 165 ms, reassemble: 122 ms).'),

                    
                  ],
                ),
              ),

          ],
        ),
      ),
    );
  }
}