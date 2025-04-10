import 'package:airsolo/features/app/screens/taxi/driverDashboard.dart';
import 'package:airsolo/features/authentication/screens/loging/login.dart';
import 'package:airsolo/navigation_menu.dart';
import 'package:airsolo/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AirsoloApp extends StatelessWidget {
  const AirsoloApp({super.key});




  @override
  Widget build(BuildContext context) {
    // Initialize session listener
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AAppTheme.lightTheme,
      darkTheme: AAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: _determineInitialScreen(),
      getPages: _appRoutes(),
    );
  }

  // Session-based initial screen
  Widget _determineInitialScreen() {
    final box = GetStorage();
    final token = box.read('jwtToken');
    final role = box.read('userRole');

    // Check Firebase auth state as fallback
    final currentUser = FirebaseAuth.instance.currentUser;

    if (token != null && currentUser != null) {
      return role == 'driver' 
          ? const DriverDashboard() 
          : const NavigationMenu();
    } else {
      return const LoginScreen();
    }
  }

  // All app routes
  List<GetPage> _appRoutes() => [
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/home', page: () => const NavigationMenu()),
        GetPage(name: '/driver', page: () => const DriverDashboard()),
        // Add other routes here
      ];
}