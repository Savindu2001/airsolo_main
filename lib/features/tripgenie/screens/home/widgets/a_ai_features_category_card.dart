
import 'package:airsolo/common/widgets/custome_shapes/containers/rounded_card.dart';
import 'package:airsolo/common/widgets/icon/a_circular_icon.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AAiFeaturesCategoryCard extends StatelessWidget {
  const AAiFeaturesCategoryCard({
    super.key, this.onTap, required this.showBorder, 
  });

  final void Function()? onTap;
  final bool showBorder;

  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: ARoundedContainer(
            padding:  const EdgeInsets.all(ASizes.sm),
            showBorder: showBorder,
            backgroundColor: Colors.transparent,
            child: Column(
            
              children: [
                //Icon
                const Flexible(
                  child: ACircular_Icon(
                    icon: Iconsax.map,
                    size: 35,
                    )
                    
                ),
                                  
                                  
                  const SizedBox(height: ASizes.spaceBtwItems/2,),
                                  
                  //Text
                                  
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                                          
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //Title
                              Text('Trip Maker', style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 14)),
                              const SizedBox(width: ASizes.xs,),
                              //Badged
                              const Icon(Iconsax.verify5, color: AColors.primary, size: ASizes.iconXs,)
                          ],
                        ),
                                          
                        //
                        Text(
                          'Generate Trip Plan',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                                          
                                          
                      ],
                    ),
                  ),
              ],
            ),
                                  
                                  ),
                                );
          }
        }
