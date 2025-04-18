import 'package:airsolo/features/informations/screen/information_screen.dart';
import 'package:airsolo/features/informations/service_screen/service_screen.dart';
import 'package:airsolo/features/home/main_home.dart';
import 'package:airsolo/features/personalization/screens/setting/setting.dart';
import 'package:airsolo/features/tripgenie/screens/home/a_ai_trip.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(NavigationController());
    final darkMode = AHelperFunctions.isDarkMode(context);


    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          backgroundColor: darkMode ? AColors.black : AColors.white,
          indicatorColor: darkMode ? AColors.white.withOpacity(0.1) : AColors.white.withOpacity(0.1),
          destinations: const [
             NavigationDestination(
              icon: Icon(Iconsax.home), 
              label: 'Home'
              ),
        
            NavigationDestination(
              icon: Icon(Iconsax.category), 
              label: 'Services'
              ),

              NavigationDestination(
              icon: Icon(Iconsax.search_favorite), 
              label: 'Informations'
              ),

              NavigationDestination(
              icon: Icon(Iconsax.image), 
              label: 'TripGenie'
              ),
        
               NavigationDestination(
              icon: Icon(Iconsax.user), 
              label: 'Account'
              ),
              
              
        
          ]
          ),
      ),

        body: Obx(()=> controller.screens[controller.selectedIndex.value]),
    );
  }
}


class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [const MainHomeScreen(),const ServiceHomeScreen(), InformationScreen(), const AAIHomeScreen(), const ASettingScreen(),];
}