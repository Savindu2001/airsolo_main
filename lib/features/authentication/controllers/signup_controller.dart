import 'dart:async';
import 'dart:convert';

import 'package:airsolo/config.dart';
import 'package:airsolo/features/authentication/screens/signup/verify_email.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/helpers/network_manager.dart';
import 'package:airsolo/utils/popups/full_screen_loader.dart';
import 'package:airsolo/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  // --- Signup Logic --- //
  Future<void> signup() async {
    try {
      // 1. First validate form
      if (!signupFormKey.currentState!.validate()) {
        debugPrint('Form validation failed');
        // Show error message if you want
        ALoaders.warningSnackBar(
          title: 'Validation Error',
          message: 'Please fill all required fields correctly',
        );
        return; // Stop execution if validation fails
      }

    // 2. Check Privacy Policy with more explicit check
    debugPrint('Current privacy policy value: ${privacyPolicy.value}');
    if (privacyPolicy.value != true) {
      ALoaders.warningSnackBar(
        title: 'Privacy Policy Required',
        message: 'You must accept the Privacy Policy to register.',
      );
      // Force UI update
      privacyPolicy.refresh(); 
      return;
    }
      
      // 3. Start Loading - Only if validations passed
      AFullScreenLoader.openLoadingDialog(
        'We are processing your information...', 
        AImages.proccessingDocer,
      );

      // 4. Check Internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        AFullScreenLoader.stopLoading();
        ALoaders.errorSnackBar(title: 'No Internet', message: 'Please check your connection');
        return;
      }

      // 5. Prepare Data
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

      // 6. API Call
      final response = await http.post(
        Uri.parse(Config.registerEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      ).timeout(const Duration(seconds: 10));

      // 7. Handle Response
      if (response.statusCode == 200) {
        AFullScreenLoader.stopLoading();
        ALoaders.successSnackBar(
          title: 'Success!',
          message: 'Account created. Please verify your email.',
        );
        // Only navigate after successful creation
        Get.to(() => VerifyEmailScreen(email: email.text.trim()));
      } 
      else if (response.statusCode == 400 || response.statusCode == 409) {
        AFullScreenLoader.stopLoading();
        final errorData = jsonDecode(response.body);
        ALoaders.errorSnackBar(
          title: 'Registration Failed',
          message: errorData['message'] ?? 'An error occurred. Please try again.',
        );
      } 
      else {
        AFullScreenLoader.stopLoading();
        throw Exception('Unexpected server error: ${response.statusCode}');
      }
    } 
    on http.ClientException {
      AFullScreenLoader.stopLoading();
      ALoaders.errorSnackBar(
        title: 'Network Error',
        message: 'Could not connect to the server. Check your connection.',
      );
    } 
    on TimeoutException catch (_) {
      AFullScreenLoader.stopLoading();
      ALoaders.errorSnackBar(
        title: 'Timeout',
        message: 'Request took too long. Please try again.',
      );
    } 
    catch (e) {
      AFullScreenLoader.stopLoading();
      ALoaders.errorSnackBar(
        title: 'Oh Snap!',
        message: 'An error occurred. Please try again.',
      );
      debugPrint('Signup Error: $e');
    }
  }

  @override
  void onClose() {
    email.dispose();
    firstName.dispose();
    lastName.dispose();
    username.dispose();
    country.dispose();
    password.dispose();
    gender.dispose();
    super.onClose();
  }
}