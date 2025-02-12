
import 'package:airsolo/common/widgets/appbar/appbar.dart';
import 'package:airsolo/common/widgets/cart_bag/cart_bag_menu.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/texts.dart';
import 'package:flutter/material.dart';

class AHomeAppBar extends StatelessWidget {
  const AHomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(ATexts.homeAppBarTitle, style: Theme.of(context).textTheme.labelMedium!.apply(color: AColors.grey)),
          Text(ATexts.homeAppBarSubTitle, style: Theme.of(context).textTheme.headlineSmall!.apply(color: AColors.white)),
        ],
        
      ),
      actions: [
        ACartBag_Widget(onPressed: (){}, iconColor: AColors.white,)
      ],
    );
  }
}
