import 'package:airsolo/common/widgets/appbar/appbar.dart';
import 'package:airsolo/common/widgets/images/a_circular_image.dart';
import 'package:airsolo/common/widgets/texts/section_heading.dart';
import 'package:airsolo/features/personalization/screens/profile/widget/profile_menu.dart';
import 'package:airsolo/features/authentication/screens/password_configuration/resetPassword.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

class AProfileScreen extends StatelessWidget {
  const AProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    const ACircularImage(image: AImages.userProfile, width: 80, height: 80,),
                    TextButton(onPressed: (){}, child: const Text('Change Profile Picture'))
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
              AProfileMenu(onPressed: (){}, title: 'Name', value: 'Savindu Senanayake', ),
              AProfileMenu(onPressed: (){}, title: 'Username', value: 'Savizz_2001', ),

              const SizedBox(height: ASizes.spaceBtwItems ),
              const Divider(),
              const SizedBox(height: ASizes.spaceBtwItems ),

              // Heading Personal Info
              const ASectionHeading(title: 'Personal Information', showActionButton: false),
              const SizedBox(height: ASizes.spaceBtwItems ),

              AProfileMenu(onPressed: (){}, title: 'User ID', value: '24883', icon: Iconsax.copy, ),
              AProfileMenu(onPressed: (){ Get.to(()=>  ResetPasswordScreen());}, title: 'Password', value: '######' ),
              AProfileMenu(onPressed: (){}, title: 'E-mail', value: 'savindu.info@gmail.com', ),
              AProfileMenu(onPressed: (){}, title: 'Phone ', value: '+94-761794522', ),
              AProfileMenu(onPressed: (){}, title: 'Gender', value: 'Male', ),
              AProfileMenu(onPressed: (){}, title: 'Date of Birth', value: '23 Feb, 2001', ),
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
}
