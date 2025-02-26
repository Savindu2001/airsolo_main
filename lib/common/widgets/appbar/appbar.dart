import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
class AAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AAppBar({super.key, this.title,  this.showBackArrow = false, this.leadingIcon,  this.actions,  this.leadingOnPressed});


  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: ASizes.md),
      child: AppBar(
        automaticallyImplyLeading: false,
        leading: showBackArrow 
            ? IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back_ios)) 
            : leadingIcon != null ? IconButton(onPressed: leadingOnPressed, icon: Icon(leadingIcon)) : null,
        title: title,
        actions: actions,

      ),
      );
  }
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(ADeviceUtils.getAppBarHeight());
}