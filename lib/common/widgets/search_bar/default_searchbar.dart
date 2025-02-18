
import 'package:airsolo/common/widgets/search_bar/a_search_popup.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/device/device_utility.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class ASearchBarContainer extends StatelessWidget {
  const ASearchBarContainer({
    super.key, 
    required this.text, 
    this.icon, 
    this.showBackground = true,  
    this.showBorder = true, 
    this.padding = const EdgeInsets.symmetric(horizontal: ASizes.defaultSpace),
  });

  final String text;
  final IconData? icon;
  final bool showBackground, showBorder;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final darkMode = AHelperFunctions.isDarkMode(context);
    return Padding(
      padding: padding,
      child: GestureDetector(
        onTap: () {
          //
          showDialog(
            context: context,
            builder: (context) => const SearchPopup(),
          );
        },
        child: Container(
          width: ADeviceUtils.getScreenWidth(),
          padding: const EdgeInsets.all(ASizes.md),
          decoration: BoxDecoration(
            color: showBackground ? darkMode ? AColors.dark : AColors.light : Colors.transparent,
            borderRadius: BorderRadius.circular(ASizes.cardRadiusLg),
            border: showBorder ? Border.all(color:  AColors.grey) :  null
           ),
          child:  Row(
            children: [
              Icon(icon, color: darkMode ? AColors.white : AColors.darkerGrey,),
              const  SizedBox(width: ASizes.spaceBtwItems),
              Text(text,style: Theme.of(context).textTheme.bodySmall!.apply(color: darkMode ? AColors.white : AColors.darkerGrey,)  )
            ],
          ),
        
        ),
      ),
    );
  }
}
