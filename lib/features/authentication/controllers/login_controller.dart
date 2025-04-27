import 'dart:async';

import 'package:airsolo/data/repositories/authentication/authentication_repository.dart';
import 'package:airsolo/features/driver/driverDashboard.dart';
import 'package:airsolo/features/authentication/screens/loging/login.dart';
import 'package:airsolo/navigation_menu.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/helpers/network_manager.dart';
import 'package:airsolo/utils/popups/full_screen_loader.dart';
import 'package:airsolo/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:airsolo/config.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  
  final hidePassword = true.obs;
  final rememberMe = true.obs;
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();


  // --- check existing sessions ---
  Future<void> checkExistingSession() async {
    final box = GetStorage();
    final token = box.read('jwtToken');
    final currentUser = FirebaseAuth.instance.currentUser;

    if (token != null && currentUser != null) {
      final role = box.read('userRole') ?? 'traveler';
      Get.offAllNamed(role == 'driver' ? '/driver' : '/home');
    }
  }
  // --- Login Method ---
  Future<void> login() async {
  try {
    // Validate Form
    if (!loginFormKey.currentState!.validate()) return;
    
    // Start Loading
    AFullScreenLoader.openLoadingDialog('Authenticating...', AImages.proccessingDocer);

    // Check Internet
    final isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      AFullScreenLoader.stopLoading();
      ALoaders.errorSnackBar(title: 'No Internet', message: 'Please check your connection');
      return;
    }

    

    // Firebase Auth
    final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.text.trim(),
      password: password.text.trim(),
    );

    // Get Firebase Token
    final String? firebaseToken = await userCredential.user?.getIdToken();
    if (firebaseToken == null) {
      AFullScreenLoader.stopLoading();
      throw Exception('Failed to get Firebase token');
    }

    // Backend Verification
    final response = await http.post(
      Uri.parse(Config.loginEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': firebaseToken}),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String backendToken = data['token'];
      
      // Now fetch cities after successful login
      //await Get.find<CityController>().fetchCities();
      
      final user = data['user'];
      final String role = user['role']?.toLowerCase() ?? 'traveler';

      // Store tokens and user info
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwtToken', backendToken);
      await prefs.setString('userRole', role);
      await prefs.setString('userEmail', user['email'] ?? '');
      await prefs.setString('userName', '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}');
      await prefs.setString('userPhoto', user['profile_photo'] ?? '');

      
      // Update auth state
      await AuthenticationRepository.instance.handleSuccessfulLogin(
          token: data['token'],
          role: role,
          userData: user,
        );
        
      AFullScreenLoader.stopLoading();
      await Future.delayed(const Duration(milliseconds: 50));
      _navigateBasedOnRole(role);
    } else {
      AFullScreenLoader.stopLoading();
      final error = jsonDecode(response.body);
      ALoaders.errorSnackBar(
        title: 'Login Failed',
        message: error['message'] ?? 'Something went wrong',
      );
    }
  } on FirebaseAuthException catch (e) {
    AFullScreenLoader.stopLoading();
    ALoaders.errorSnackBar(title: 'Login Failed', message: _getFirebaseErrorMessage(e));
  } on TimeoutException catch (_) {
    AFullScreenLoader.stopLoading();
    ALoaders.errorSnackBar(title: 'Timeout', message: 'Server took too long to respond');
  } catch (e) {
    AFullScreenLoader.stopLoading();
    print('error = $e');
    ALoaders.errorSnackBar(title: 'Error', message: 'Server Error $e');
    
  }
}

  // --- Safe Navigation Method ---
void _navigateBasedOnRole(String role) {
  Widget destination = role == 'driver' 
      ? const DriverDashboard() 
      : const NavigationMenu();

  // Using GetX with transition
  Get.offAll(
    () => destination,
    transition: Transition.cupertino,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeOut,
  );
  // Show role-specific success message
  Future.delayed(const Duration(milliseconds: 60), () {
    if (role == 'driver') {
      ALoaders.successSnackBar(
        title: 'Welcome Driver!',
        message: 'Ready for new bookings',
      );
    } else {
      ALoaders.successSnackBar(
        title: 'Welcome Back!',
        message: 'Happy travels!',
      );
    }
  });

    
  }

  // --- Firebase Error Messages ---
  String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found': return 'No account found with this email';
      case 'wrong-password': return 'Incorrect password';
      case 'invalid-email': return 'Invalid email format';
      case 'user-disabled': return 'Account disabled';
      case 'too-many-requests': return 'Too many attempts. Try later';
      default: return 'Login failed. Code: ${e.code}';
    }
  }

  // --- Logout ---
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      // Use rootNavigator for logout
      Navigator.of(Get.context!, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      ALoaders.errorSnackBar(title: 'Logout Failed', message: e.toString());
    }
  }

  
}