
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/constants/texts.dart';
import 'package:flutter/material.dart';

class ALoginHeader extends StatelessWidget {
  const ALoginHeader({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
      height: 150,
      image: AssetImage(dark ? AImages.lightAppLogo : AImages.darkAppLogo ) 
      ),
        Text(ATexts.loginTitle , style: Theme.of(context).textTheme.headlineMedium,),
        const SizedBox(height: ASizes.sm,),
        Text(ATexts.loginSubTitle , style: Theme.of(context).textTheme.headlineSmall,),
      ],
    );
  }
}