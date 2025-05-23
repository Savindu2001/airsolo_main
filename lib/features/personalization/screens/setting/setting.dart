import 'package:airsolo/common/widgets/appbar/appbar.dart';
import 'package:airsolo/common/widgets/custome_shapes/containers/primary_hader_container.dart';
import 'package:airsolo/common/widgets/list_tiles/setting_menu_tile.dart';
import 'package:airsolo/common/widgets/list_tiles/user_profile_tile.dart';
import 'package:airsolo/common/widgets/texts/section_heading.dart';
import 'package:airsolo/features/payments/screens/card_all_screen.dart';
import 'package:airsolo/features/personalization/screens/setting/privacy.dart';
import 'package:airsolo/features/users/coupon.dart';
import 'package:airsolo/features/users/user_history.dart';
import 'package:airsolo/features/wishlist/wishlist.dart';
import 'package:airsolo/features/authentication/controllers/login_controller.dart';
import 'package:airsolo/features/personalization/screens/profile/profile.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ASettingScreen extends StatelessWidget {
  const ASettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return  Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            /// Header
            APrimaryHeaderContainer(child: Column(
              children: [

                /// Appbar
                AAppBar(title: Text('Account', style: Theme.of(context).textTheme.headlineMedium!.apply(color: AColors.white),),),
                

                /// User Profile Card
                AUserProfileTile(onPressed: () => Get.to(() => const AProfileScreen()),),
                const SizedBox(height: ASizes.spaceBtwSections,),


              ],
            ) ),
            


            /// Body
            Padding(
            padding: const EdgeInsets.all(ASizes.defaultSpace),
            child: Column(
              children: [

                // -- Account Setting
                const ASectionHeading(title: 'Account Setting', showActionButton: false),
                const SizedBox(height: ASizes.spaceBtwItems,),

                
                ASettingMenuTile(title: 'My Bookings', subTitle: 'View My All Bookings of Services', icon: Iconsax.ticket,onTap: () => Get.to(()=>  CustomerBookingHistoryPage()),),
                ASettingMenuTile(title: 'My Wishlist', subTitle: 'View, Add, Edit or Remove Favourites', icon: Iconsax.heart,onTap: () => Get.to(()=> const AWishListPage()),),
                ASettingMenuTile(title: 'My Emergancy', subTitle: 'Add Emergency Contacts for Secure ', icon: Iconsax.format_circle,onTap: () {},),
                ASettingMenuTile(title: 'Wallet', subTitle: 'Manage Your Payments', icon: Iconsax.wallet,onTap: () => Get.to(()=> const CardHomePage()),),
                ASettingMenuTile(title: 'My Coupons', subTitle: 'List of All Discounted Coupons', icon: Iconsax.discount_shape,onTap: () => Get.to(()=>  CouponPage()),),
                ASettingMenuTile(title: 'Notifications', subTitle: 'Set any kind of notification messages', icon: Iconsax.notification,onTap: () {},),
                ASettingMenuTile(title: 'Account Privacy', subTitle: 'Manage data usage and connected accounts', icon: Iconsax.security_card,onTap: () => Get.to(()=>  PrivacyPolicyPage()),),


                // -- App Setting
                const SizedBox(height: ASizes.spaceBtwSections,),
                const ASectionHeading(title: 'App Setting', showActionButton: false),
                const SizedBox(height: ASizes.spaceBtwItems,),

                const ASettingMenuTile(title: 'Geolocation', subTitle: 'set recommendation based on location', icon: Iconsax.location,),
                ASettingMenuTile(
                  title: 'Safe Mode', 
                  subTitle: 'Secure your Account More', 
                  icon: Iconsax.security_user, 
                  trailing: Switch(
                    value: false, 
                    onChanged: (
                      falese){}
                      ),
                    ),

                    ASettingMenuTile(
                  title: 'HD Image Quality', 
                  subTitle: 'Quality Images', 
                  icon: Iconsax.security_user, 
                  trailing: Switch(
                    value: false, 
                    onChanged: (falese){}),
                    ),
                    ASettingMenuTile(title: 'Theme', subTitle: 'Light & Dark Mode', icon: Iconsax.moon,onTap: () {},),
                    ASettingMenuTile(title: 'Privacy & Terms', subTitle: 'Privacy & Terms of App', icon: Iconsax.lock,onTap: () {},),
                    ASettingMenuTile(title: 'About - V.0.0.1', subTitle: 'About Airsolo App', icon: Iconsax.bubble,onTap: () {},),


                // -- Logout Button
                const SizedBox(height: ASizes.spaceBtwSections,),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: (){
                     Get.find<LoginController>().logout();
                    }, 
                    child: const Text('Logout')
                    ),),

                const SizedBox(height: ASizes.spaceBtwSections * 2.5 ),

                  




              ],
            ),)
            ///
            ///
          ],
        ),
      ),
    );
  }
}
