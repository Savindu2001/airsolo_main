
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ADefault_Amentions extends StatelessWidget {
  const ADefault_Amentions({
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
                const Icon(Icons.desk, color: Colors.amber, size: ASizes.iconLg,),
                const SizedBox(width: ASizes.spaceBtwItems / 2,),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '24 Hour Reception',style: Theme.of(context).textTheme.bodyLarge),
                    ]
                  )
                ),
              ],
            ),
      ),
    );
  }
}
