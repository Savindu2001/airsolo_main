
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AHostel_Events_Card extends StatelessWidget {
  const AHostel_Events_Card({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Container(
        color: Colors.purple,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //-- event section title & sub title
              Text('Events Linkups',style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 24, color: Colors.white),),
              const SizedBox(height: ASizes.sm,),
              Text('Join these social events at your hostel',style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),),
              
              const SizedBox(height: ASizes.lg,),
              // events card
    
              SizedBox(
                height: 100,
                child: ListView.separated(
                 itemCount: 6,
                 separatorBuilder: (_,__)=> const SizedBox(width: ASizes.md,),
                 scrollDirection: Axis.horizontal,
                 itemBuilder: (_, index)=> Card(
                  color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         const Row(
                          children: [
                            //--  image
                        SizedBox(
                          width: 86,
                          height: 86,
                          child: Padding(
                            padding: EdgeInsets.all(ASizes.sm),
                            child: Image(image: AssetImage(AImages.hostelImage1),fit: BoxFit.cover,),
                          )),
                          SizedBox(width: ASizes.md,),
                        //-- title
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // -- title
                              Text('Sunset tour',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,),
                              SizedBox(height: ASizes.sm,),
                              Row(children: [
                                Icon(Iconsax.clock,color: Colors.white,),
                                Text('27 Feb', style: TextStyle(color: Colors.white),),
                              ],),
                              SizedBox(height: ASizes.sm,),
                              Row(children: [
                                Icon(Iconsax.money, color: Colors.white,),
                                Text('Free', style: TextStyle(color: Colors.white),),
                              ],),
                            ],
                          ),
                          ],
                        ),
                          //--button
                          IconButton(onPressed: (){}, icon: const Icon(Iconsax.eye, color: Colors.white,))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
