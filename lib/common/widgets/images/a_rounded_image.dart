
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ARoundedImage extends StatelessWidget {
  const ARoundedImage({
    super.key, 
    this.width , 
    this.height , 
    required  this.imageUrl, 
    this.applyImageRadius = false, 
    this.border, 
    this.backgroundColor = AColors.light, 
    this.fit = BoxFit.contain, 
    this.padding, 
    this.isNetworkImage = false, 
    this.onPressed, 
    this.borderRadius = ASizes.md,
  });

  final double? width, height;
  final String imageUrl;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage;
  final VoidCallback? onPressed;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(ASizes.md), border: border , color: backgroundColor ),
        child: ClipRRect(
          borderRadius: applyImageRadius ? BorderRadius.circular(borderRadius) : BorderRadius.zero,
        child: Image(image: isNetworkImage ? NetworkImage(imageUrl) : AssetImage(imageUrl) as ImageProvider , fit: fit,)),
      ),
    );
  }
}

