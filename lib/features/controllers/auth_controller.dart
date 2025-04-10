// import 'dart:async';


// import 'package:airsolo/features/authentication/screens/loging/login.dart';
// import 'package:airsolo/navigation_menu.dart';
// import 'package:airsolo/utils/constants/image_strings.dart';
// import 'package:airsolo/utils/helpers/network_manager.dart';
// import 'package:airsolo/utils/popups/full_screen_loader.dart';
// import 'package:airsolo/utils/popups/loaders.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:airsolo/config.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class LoginController extends GetxController {
//   static LoginController get instance => Get.find();

//   // --- Form Controllers ---
//   final email = TextEditingController();
//   //GlobalKey<FormState> forgotFormKey = GlobalKey<FormState>();

//   // --- Forgot Password Reset Email ---
//   Future<void> forgotPassword() async {
//     try {
//       // Start Loading
//       AFullScreenLoader.openLoadingDialog('Sending...', AImages.proccessingDocer);

//       // Check Internet
//       final isConnected = await NetworkManager.instance.isConnected();
//       if (!isConnected) {
//         AFullScreenLoader.stopLoading();
//         ALoaders.errorSnackBar(title: 'No Internet', message: 'Please check your connection');
//         return;
//       }

      

//       // Firebase Auth
//       final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: email.text.trim(),
//         password: password.text.trim(),
//       );

//       // Get Firebase Token
//       final String? firebaseToken = await userCredential.user?.getIdToken();
//       if (firebaseToken == null) {
//         AFullScreenLoader.stopLoading();
//         throw Exception('Failed to get Firebase token');
//       }

//       // Backend Verification
//       final response = await http.post(
//         Uri.parse(Config.loginEndpoint),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'token': firebaseToken}),
//       ).timeout(const Duration(seconds: 10));

//       // Parse Response
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final String backendToken = data['token'];
//         final String role = data['role']?.toLowerCase() ?? 'traveler';

//         // Store tokens
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('jwtToken', backendToken);
//         await prefs.setString('userRole', role);

//         // Ensure loader is stopped
//         AFullScreenLoader.stopLoading();


//         // Critical: Wait for next frame before navigation
//         await Future.delayed(const Duration(milliseconds: 50));

//         // Safe Navigation
//         _navigateBasedOnRole(role);
//       } else {
//         throw Exception('Backend error: ${response.statusCode}');
//       }
//     } on FirebaseAuthException catch (e) {
//       AFullScreenLoader.stopLoading();
//       ALoaders.errorSnackBar(title: 'Login Failed', message: _getFirebaseErrorMessage(e));
//     } on TimeoutException catch (_) {
//       AFullScreenLoader.stopLoading();
//       ALoaders.errorSnackBar(title: 'Timeout', message: 'Server took too long to respond');
//     } catch (e) {
//       AFullScreenLoader.stopLoading();
//       ALoaders.errorSnackBar(title: 'Error', message: e.toString());
//     }
//   }

  