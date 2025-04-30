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
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:airsolo/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  
  final hidePassword = true.obs;
  final rememberMe = true.obs;
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState>  loginFormKey = GlobalKey<FormState>();


  


  // --- check existing sessions ---
  Future<void> checkExistingSession() async {
    final box = GetStorage();
    final token = box.read('jwtToken');
    final currentUser = FirebaseAuth.instance.currentUser;

    if (token != null && currentUser != null) {
      final role = box.read('userRole') ?? 'traveler';
      Get.offAllNamed(role == 'driver' ? '/driver/home' : '/home');
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

        // After user is logged in successfully \
          // final fcmToken = await FirebaseMessaging.instance.getToken();
          // if (fcmToken != null) {
          //   print('Device FCM Token: $fcmToken');
          //   await _saveFcmTokenToBackend(fcmToken, user['id'] ?? userCredential.user?.uid ?? '');
          // }

        
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
    ALoaders.errorSnackBar(title: 'Login Failed', message: '$e');
  } on TimeoutException catch (_) {
    AFullScreenLoader.stopLoading();
    ALoaders.errorSnackBar(title: 'Timeout', message: 'Server took too long to respond');
  } catch (e) {
    AFullScreenLoader.stopLoading();
  if (e is FirebaseAuthException) {
    ALoaders.errorSnackBar(title: 'Login Failed', message: '$e');
  } else if (e is PlatformException && e.code == 'apns-token-not-set') {
    // Ignore this specific error
    print('APNS token not set (iOS-specific)');
  } else {
    print('Login error: $e');
    ALoaders.errorSnackBar(title: 'Error', message: 'An unexpected error occurred');
  }
}



 


}

// --- Logout ---
Future<void> logout() async {
  try {
    // Sign out from Firebase Auth
    await FirebaseAuth.instance.signOut();
    
    // Clear any stored preferences (e.g., user data)
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    // Navigate to LoginScreen and clear the navigation stack
    Navigator.of(Get.context!, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()), 
      (route) => false, // This removes all the previous routes
    );
  } catch (e) {
    // If an error occurs, show an error snackbar
    ALoaders.errorSnackBar(title: 'Logout Failed', message: e.toString());
  }
}


// Future<void> _saveFcmTokenToBackend(String token, String userId) async {
//   try {
//     if (userId.isEmpty) {
//       print('⚠️ User ID is empty - cannot save FCM token');
//       return;
//     }

//     final prefs = await SharedPreferences.getInstance();
//     final jwtToken = prefs.getString('jwtToken');

//     if (jwtToken == null) {
//       print('⚠️ JWT Token not found');
//       return;
//     }

//     final response = await http.put(
//       Uri.parse('${Config.saveFcmTokenEndpoint}/$userId'), 
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $jwtToken',
//       },
//       body: jsonEncode({'fcm_token': token}),
//     ).timeout(const Duration(seconds: 10));

//     if (response.statusCode != 200) {
//       print('❌ Failed to save FCM Token: ${response.statusCode} - ${response.body}');
//     }
//   } catch (e) {
//     print('❌ Error saving FCM Token: $e');
//   }
// }

  // --- Safe Navigation Method ---
void _navigateBasedOnRole(String role) {
  Future.delayed(Duration.zero, () {
    Get.offAll(
      () => role == 'driver' ?  DriverHomeScreen() : const NavigationMenu(),
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  });
  
  // Show role-specific success message
  Future.delayed(const Duration(milliseconds: 100), () {
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


  @override
void dispose() {
  email.dispose();
  password.dispose();
  super.dispose();
}
  }