
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../../utils/helpers/helper_functions.dart';

class ACircularImage extends StatelessWidget {
  const ACircularImage({
    super.key, 
    this.width = 56, 
    this.height = 56, 
    this.padding = ASizes.sm, 
    this.backgroundColor, 
    this.overlayColor, 
    this.isNetworkImage = false, 
    required this.image, 
    this.fit =BoxFit.cover,
  });

  final double width,height,padding;
  final Color? backgroundColor;
  final Color? overlayColor;
  final bool isNetworkImage;
  final String image;
  final BoxFit? fit;



  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(ASizes.sm),
      decoration: BoxDecoration(
        color: backgroundColor ?? (AHelperFunctions.isDarkMode(context) ? AColors.black : AColors.white),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Image(
        fit: fit,
        image: isNetworkImage ? NetworkImage(image) : AssetImage(image) as ImageProvider,
        color: overlayColor,
        ),
    );
  }
}