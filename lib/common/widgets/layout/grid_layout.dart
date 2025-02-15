import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';

class AGridLayout extends StatelessWidget {
  const AGridLayout({
    super.key, 
    this.mainAxisExtent   = 288, 
    required this.itemCount, 
    required this.itemBuilder,
  });


  final double? mainAxisExtent;
  final int itemCount;
  final Widget? Function(BuildContext, int) itemBuilder;


  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: itemCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: ASizes.gridViewSpacing,
        mainAxisSpacing: ASizes.gridViewSpacing,
        mainAxisExtent: mainAxisExtent,
        ), 
      itemBuilder: itemBuilder,
      );
  }
}
