
import 'package:airsolo/common/widgets/images/a_circular_image.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AUserProfileTile extends StatelessWidget {
  const AUserProfileTile({
    super.key, required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const ACircularImage(
        image: AImages.userProfile,
        width: 56,
        padding: 56,
        ),
      title: Text('Savindu Senanayake', style: Theme.of(context).textTheme.headlineSmall!.apply(color: AColors.white),),
      subtitle: Text('savindu.info@gmail.com', style: Theme.of(context).textTheme.bodyMedium!.apply(color: AColors.white),),
      trailing: IconButton(onPressed: onPressed, icon: const Icon(Iconsax.edit, color: AColors.white,)),
      
    );
  }
}