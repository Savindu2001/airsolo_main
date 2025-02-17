
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/device/device_utility.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class ATabBar extends StatelessWidget implements PreferredSizeWidget{

  const ATabBar({super.key, required this.tabs,});

  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    final darkMode = AHelperFunctions.isDarkMode(context);
    return Material(
      color:  darkMode ? AColors.black: AColors.white,
      child: TabBar(
        isScrollable: true,
        indicatorColor: AColors.primary,
        unselectedLabelColor: AColors.darkGrey,
        labelColor: darkMode ? AColors.white : AColors.primary,
        tabs: tabs
        ),
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(ADeviceUtils.getAppBarHeight());


  
}
