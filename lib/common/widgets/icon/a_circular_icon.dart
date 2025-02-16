import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class ACircular_Icon extends StatelessWidget {
  const ACircular_Icon({
    super.key, 
    required this.icon, 
     this.color, 
     this.backgroundColor, 
     this.width, 
     this.height, 
     this.size = ASizes.lg, 
    this.onPressed, 
  });


  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final double? width ,height, size;
  final VoidCallback? onPressed;


  

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      
      decoration: BoxDecoration(
        color: backgroundColor != null 
        ? backgroundColor!
        : AHelperFunctions.isDarkMode(context)
            ? AColors.black.withOpacity(0.5)
            : AColors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(100)
      ),
      child: IconButton(
        onPressed: onPressed, 
        icon: Icon(icon, color: color, size: size,)),
                  );
  }
}