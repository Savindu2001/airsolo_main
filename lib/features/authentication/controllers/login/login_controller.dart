import 'package:airsolo/features/authentication/screens/loging/login.dart';
import 'package:airsolo/navigation_menu.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/helpers/network_manager.dart';
import 'package:airsolo/utils/popups/full_screen_loader.dart';
import 'package:airsolo/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:airsolo/config.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  // Variables
  final hidePassword = true.obs;
  final rememberMe = true.obs;
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  // Login method
  Future<void> login() async {
    try {
      // Start Loading
      AFullScreenLoader.openLoadingDialog('We Are Checking!', AImages.proccessingDocer);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        AFullScreenLoader.stopLoading();
        ALoaders.errorSnackBar(title: 'Connection Error', message: 'No internet connection');
        return;
      }

      // Form Validation
      if (!loginFormKey.currentState!.validate()) {
        AFullScreenLoader.stopLoading();
        return;
      }

      // Prepare login data
      final emailText = email.text.trim();
      final passwordText = password.text.trim();

      // Authenticate using Firebase
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailText,
        password: passwordText,
      );

      // Get the JWT token
      String? token = await userCredential.user?.getIdToken();
      if (token == null) {
        AFullScreenLoader.stopLoading();
        ALoaders.errorSnackBar(title: 'Error', message: 'Could not retrieve token.');
        return;
      }

      // Send token to backend
      final response = await http.post(
        Uri.parse(Config.loginEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String backendToken = data['token'];

        // Store the backend token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwtToken', backendToken);

        // Stop loading before navigation
        AFullScreenLoader.stopLoading();
        
        // Show success message
        ALoaders.successSnackBar(title: 'Login Successful', message: 'Welcome back!');

        // Use Get.offAll to remove all previous routes
        Get.offAll(() => const NavigationMenu());
      } else {
        AFullScreenLoader.stopLoading();
        final errorData = jsonDecode(response.body);
        ALoaders.errorSnackBar(
          title: 'Login Failed', 
          message: errorData['message'] ?? 'Invalid credentials'
        );
      }
    } on FirebaseAuthException catch (e) {
      AFullScreenLoader.stopLoading();
      ALoaders.errorSnackBar(
        title: 'Authentication Error',
        message: _getFirebaseErrorMessage(e),
      );
    } catch (e) {
      AFullScreenLoader.stopLoading();
      ALoaders.errorSnackBar(
        title: 'Oh Snap!', 
        message: 'An unexpected error occurred. Please try again.'
      );
    }
  }

  String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

 //Logout Function
  Future<void> logout() async {
  try {
    // Sign out from Firebase
    await FirebaseAuth.instance.signOut();
    
    // Clear stored tokens
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwtToken');
    
    // Navigate back to login (clear all routes)
    Get.offAll(() => const LoginScreen());
  } catch (e) {
    ALoaders.errorSnackBar(title: 'Logout Error', message: e.toString());
  }
}


}




