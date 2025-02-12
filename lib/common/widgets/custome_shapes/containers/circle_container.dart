import 'package:airsolo/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class ACircularContainer extends StatelessWidget {
  const ACircularContainer({
    super.key,
    this.width = 400,
    this.height = 400,
    this.padding = 0,
    this.margin ,
    this.radius = 400,
    this.backgroundColor = AColors.white,
    this.child,
  });

  final double width;
  final double height;
  final double padding;
  final EdgeInsets? margin;
  final double radius;
  final Color backgroundColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius), // Use dynamic radius
        color: backgroundColor,
      ),
      child: child,
    );
  }
}
