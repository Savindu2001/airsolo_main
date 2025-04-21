import 'package:airsolo/bindings/general_bindings.dart';
import 'package:airsolo/features/activity/activities_screen.dart';
import 'package:airsolo/features/authentication/screens/loging/login.dart';
import 'package:airsolo/features/city/screen/city_screen.dart';
import 'package:airsolo/features/hostel/screens/hostel_list_screen.dart';
import 'package:airsolo/features/tripGenie/screens/ai_home_screen.dart';
import 'package:airsolo/features/tripGenie/screens/place_guide_screen.dart';
import 'package:airsolo/features/tripGenie/screens/trip_maker_screen.dart';
import 'package:airsolo/navigation_menu.dart';
import 'package:airsolo/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AirsoloApp extends StatelessWidget {
  const AirsoloApp({super.key});




  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AAppTheme.lightTheme,
      darkTheme: AAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialBinding: GeneralBindings(),
      //home: const Scaffold(backgroundColor: AColors.buttonPrimary, body: Center(child: CircularProgressIndicator(color: Colors.white,),),),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const NavigationMenu()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/cities', page: () => CityScreen()),
        GetPage(name: '/hostels', page: () => HostelListScreen()),
        GetPage(name: '/activities',page: () => const ActivityScreen(),),
        GetPage(name: '/ai',page: () => const AIHomeScreen(),),
        GetPage(name: '/ai/place-guide',page: () => const PlaceGuideScreen(),),
        GetPage(name: '/ai/trip-maker',page: () => const TripMakerScreen(),),
        
      ],
    );
  }



}
