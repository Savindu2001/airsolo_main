
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ASectionHeading extends StatelessWidget {
  const ASectionHeading({
    super.key, this.textColor, required this.title,  this.buttonText = 'View All', required this.showActionButton, this.onPressed,
  });

  final Color? textColor;
  final String title, buttonText;
  final bool showActionButton;
  final void Function()? onPressed;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: ASizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineSmall!.apply(color: textColor), maxLines: 1, overflow: TextOverflow.ellipsis),
              if(showActionButton)  TextButton(onPressed: onPressed, child: Text(buttonText)),
            ],
          )
        ],
      ),
      );
  }
}
