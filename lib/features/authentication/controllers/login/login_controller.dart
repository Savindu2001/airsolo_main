import 'package:airsolo/features/authentication/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController {
  final ApiService apiService;

  LoginController(this.apiService);

  Future<void> loginUser(BuildContext context, String email, String password) async {
    final token = await apiService.login(email, password);
    if (token != null) {
      // Store token using SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwtToken', token);
      
      // Navigate to admin section or main app
      // You can use GetX or Navigator to go to the next screen
      // For example:
      // Get.to(() => const NavigationMenu());
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed')));
    }
  }
}
