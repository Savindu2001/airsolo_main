
import 'package:airsolo/common/widgets/appbar/appbar.dart';
import 'package:airsolo/common/widgets/cart_bag/cart_bag_menu.dart';
import 'package:airsolo/features/users/user_controller.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AHomeAppBar extends StatelessWidget {
  const AHomeAppBar({
    super.key,
  });

  

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.find<UserController>();
    final userName = controller.currentUser?.fullName;
    return AAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(ATexts.homeAppBarTitle, style: Theme.of(context).textTheme.labelMedium!.apply(color: AColors.grey)),
          Text(userName.toString(), style: Theme.of(context).textTheme.headlineSmall!.apply(color: AColors.white)),
        ],
        
      ),
      actions: [
        ACartBag_Widget(onPressed: (){}, iconColor: AColors.white,)
      ],
    );
  }
}
