
import 'package:airsolo/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ACartBag_Widget extends StatelessWidget {
  const ACartBag_Widget({
    super.key, required this.iconColor, required this.onPressed,
  });

final Color iconColor;
final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(onPressed: onPressed, icon:  Icon(HugeIcons.strokeRoundedBackpack02, color: iconColor,)),
        Positioned(
          right: 0,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: AColors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(100)
            ),
    
            child: Center(
              child: Text('2', style: Theme.of(context).textTheme.labelLarge!.apply(color: iconColor, fontSizeFactor: 0.8),),
            ),
          ),
    
        )
      ],
    );
  }
}
