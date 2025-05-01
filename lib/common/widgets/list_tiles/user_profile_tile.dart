
import 'package:airsolo/common/widgets/images/a_circular_image.dart';
import 'package:airsolo/features/users/user_controller.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

class AUserProfileTile extends StatelessWidget {
  const AUserProfileTile({
    super.key, required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.find<UserController>();
    final userName = controller.currentUser!.fullName;
    final email = controller.currentUser!.email;
    final photo = controller.currentUser!.profilePhoto.toString();
    return ListTile(
      leading: CachedNetworkImage(
        imageUrl: photo,
        fit: BoxFit.contain,
        width: 56,
        height: 56,
        errorWidget: (context, url, error) => _buildDefaultImage(),
        ),
      title: Text(userName, style: Theme.of(context).textTheme.headlineSmall!.apply(color: AColors.white),),
      subtitle: Text(email, style: Theme.of(context).textTheme.bodyMedium!.apply(color: AColors.white),),
      trailing: IconButton(onPressed: onPressed, icon: const Icon(Iconsax.edit, color: AColors.white,)),
      
    );
  }



Widget _buildDefaultImage(){

  return ACircularImage(
        image: AImages.userProfile,
        width: 56,
        padding: 56,
        );
}


}

