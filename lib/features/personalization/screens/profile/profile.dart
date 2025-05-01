import 'package:airsolo/common/widgets/appbar/appbar.dart';
import 'package:airsolo/common/widgets/images/a_circular_image.dart';
import 'package:airsolo/common/widgets/texts/section_heading.dart';
import 'package:airsolo/features/personalization/screens/profile/widget/profile_menu.dart';
import 'package:airsolo/features/authentication/screens/password_configuration/resetPassword.dart';
import 'package:airsolo/features/users/user_controller.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AProfileScreen extends StatelessWidget {
  const AProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.find<UserController>();
    final fullName = controller.currentUser!.fullName;
    final userName = controller.currentUser!.username;
    final userId = controller.currentUser!.id.substring(0,8).toUpperCase();
    final email =controller.currentUser!.email;
    final gender = controller.currentUser!.gender;
    final country = controller.currentUser!.country;
    final profilePhoto = controller.currentUser!.profilePhoto.toString(); 

    return Scaffold(
      appBar: const AAppBar(showBackArrow: true, title: Text('Profile'),),
      /// -- Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ASizes.defaultSpace),
          child: Column(
            children: [
              //-- Profile
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl: profilePhoto,
                      fit: BoxFit.contain,
                      width: 80,
                      height: 80,
                      errorWidget: (context, url, error) => _buildDefaultImage(),
                      ),
                    
                    TextButton(onPressed: (){
                    }, child: const Text('Change Profile Picture'))
                  ],
                ),
              ),

              //-- Details
              const SizedBox(height: ASizes.spaceBtwItems /2),
              const Divider(),
              const SizedBox(height: ASizes.spaceBtwItems ),
              const ASectionHeading(title: 'Profile Information', showActionButton: false),
              const SizedBox(height: ASizes.spaceBtwItems ),


              // Heading Profile Menu
              AProfileMenu(onPressed: (){}, title: 'Name', value: fullName, ),
              AProfileMenu(onPressed: (){}, title: 'Username', value: userName, ),

              const SizedBox(height: ASizes.spaceBtwItems ),
              const Divider(),
              const SizedBox(height: ASizes.spaceBtwItems ),

              // Heading Personal Info
              const ASectionHeading(title: 'Personal Information', showActionButton: false),
              const SizedBox(height: ASizes.spaceBtwItems ),

              AProfileMenu(onPressed: (){}, title: 'User ID', value: userId, icon: Iconsax.copy, ),
              AProfileMenu(onPressed: (){}, title: 'E-mail', value: email, ),
              AProfileMenu(onPressed: (){}, title: 'Phone ', value: '+94-761794522', ),
              
              AProfileMenu(onPressed: (){}, title: 'Country', value: country, ),
              AProfileMenu(onPressed: (){}, title: 'Gender', value: gender, ),
              const SizedBox(height: ASizes.spaceBtwItems ),

              Center(
                child: TextButton(onPressed: (){}, child: const Text('Close Account', style: TextStyle(color: Colors.red),)),
              )
              
            ],
          ),
      ),
    ),
    );
  }



  Widget _buildDefaultImage (){
    return ACircularImage(image: AImages.userProfile, width: 80, height: 80,);
  }
}
