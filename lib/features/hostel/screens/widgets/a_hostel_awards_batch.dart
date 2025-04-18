
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AHostel_Awards_Badge extends StatelessWidget {
  const AHostel_Awards_Badge({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        itemCount: 4,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => const SizedBox(width: ASizes.sm,),
        itemBuilder: (_, index) =>  Row(
              children: [
                const Icon(Iconsax.medal_star, color: Colors.amber, size: ASizes.iconLg,),
                const SizedBox(width: ASizes.spaceBtwItems / 2,),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Best Hostel 2025',style: Theme.of(context).textTheme.bodyLarge),
                    ]
                  )
                ),
              ],
            ),
      ),
    );
  }
}
