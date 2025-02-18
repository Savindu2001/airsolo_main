
import 'package:airsolo/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';


class AFormDivider extends StatelessWidget {
  const AFormDivider({
    super.key,
    required this.dark, required this.dividerText,
  });

  final bool dark;
  final String dividerText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
    
        Flexible(child: Divider(color: dark ? AColors.darkGrey : AColors.grey, thickness: 0.5, indent: 60, endIndent: 5,)),
        Text(AHelperFunctions.capitalize(dividerText), style: Theme.of(context).textTheme.labelMedium,),
        Flexible(child: Divider(color: dark ? AColors.darkGrey : AColors.grey, thickness: 0.5, indent: 5, endIndent: 60,)), 
    
      ],);
  }
}
