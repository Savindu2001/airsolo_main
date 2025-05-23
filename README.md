import 'dart:async';

import 'package:airsolo/features/authentication/screens/signup/verify_email.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/helpers/network_manager.dart';
import 'package:airsolo/utils/popups/full_screen_loader.dart';
import 'package:airsolo/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert'; 
import 'package:airsolo/config.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  // --- Form Controllers --- //
  final hidePassword = true.obs;
  final privacyPolicy = false.obs; 
  final email = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final username = TextEditingController();
  final country = TextEditingController();
  final password = TextEditingController();
  final gender = TextEditingController();
  final GlobalKey<FormState>  signupFormKey = GlobalKey<FormState>();

  // --- Signup Logic --- //
  Future<void> signup() async {
    try {

      
      if(!signupFormKey.currentState!.validate()) return;
      //  Check Privacy Policy
      if (!privacyPolicy.value) {
        ALoaders.warningSnackBar(
          title: 'Privacy Policy Required',
          message: 'You must accept the Privacy Policy to register.',
        );
        return;
      }
      
      //  Start Loading
      AFullScreenLoader.openLoadingDialog(
        'We are processing your information...', 
        AImages.proccessingDocer,
      );

      // Check Internet
    final isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      AFullScreenLoader.stopLoading();
      ALoaders.errorSnackBar(title: 'No Internet', message: 'Please check your connection');
      return;
    }

      //  Prepare Data for Node.js Backend
      final userData = {
        'firstName': firstName.text.trim(),
        'lastName': lastName.text.trim(),
        'username': username.text.trim(),
        'email': email.text.trim(),
        'password': password.text.trim(),
        'country': country.text.trim(),
        'gender': gender.text.trim(),
        'role': 'traveler', 
        'profile_photo': 'https://example.com/default_profile.png', 
      };

      // 6. API Call to Node.js Backend
      final response = await http.post(
        Uri.parse(Config.registerEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      ).timeout(const Duration(seconds: 10)); // Add timeout

      // 7. Handle Response
      if (response.statusCode == 200) {
        AFullScreenLoader.stopLoading();
        await Future.delayed(const Duration(milliseconds: 100));
        ALoaders.successSnackBar(
          title: 'Success!',
          message: 'Account created. Please verify your email.',
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.to(() => VerifyEmailScreen(email: email.text.trim()));
        });

      } 
      else if (response.statusCode == 400 || response.statusCode == 409) {
        
        final errorData = jsonDecode(response.body);
        ALoaders.errorSnackBar(
          title: 'Registration Failed',
          message: errorData['message'] ?? 'An error occurred. Please try again.',
        );
      } 
      else {
        // Unknown server error
        throw Exception('Unexpected server error: ${response.statusCode}');
      }
    } 
    on http.ClientException {
      ALoaders.errorSnackBar(
        title: 'Network Error',
        message: 'Could not connect to the server. Check your connection.',
      );
    } 
    on TimeoutException catch (_) {
      ALoaders.errorSnackBar(
        title: 'Timeout',
        message: 'Request took too long. Please try again.',
      );
    } 
    catch (e) {
      // Generic error fallback
      ALoaders.errorSnackBar(
        title: 'Oh Snap!',
        message: e.toString(),
      );
      // Log the error for debugging (use a logger like `logger` or `Firebase Crashlytics`)
      debugPrint('Signup Error: $e');
    } 
    finally {
      // Always remove loader
      AFullScreenLoader.stopLoading();
    }
  }
}