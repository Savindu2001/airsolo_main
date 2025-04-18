import 'package:airsolo/bindings/general_bindings.dart';
import 'package:airsolo/features/authentication/screens/loging/login.dart';
import 'package:airsolo/features/city/screen/city_screen.dart';
import 'package:airsolo/navigation_menu.dart';
import 'package:airsolo/utils/constants/colors.dart';
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
        GetPage(name: '/', page: () => NavigationMenu()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/cities', page: () => CityScreen()),
        
      ],
    );
  }



}
