import 'dart:convert';
import 'package:airsolo/config.dart';
import 'package:airsolo/features/authentication/screens/loging/login.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/popups/full_screen_loader.dart';
import 'package:airsolo/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordController extends GetxController {
  // Email controller for form input
  TextEditingController emailController = TextEditingController();
  
  // Rx variables for managing loading and error states
 
  var errorMessage = ''.obs;

  

  // Function to call the API and handle forgot password logic
  Future<void> submitForgotPassword() async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      ALoaders.errorSnackBar(title:'Oh Snap!',message: 'Please enter an email address.');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      ALoaders.errorSnackBar(title:'Oh Snap!',message: 'Please enter a valid email address.');
      return;
    }

    // Loading
    AFullScreenLoader.openLoadingDialog('Sending Reset Link...', AImages.loading);
    errorMessage.value = ''; // Clear previous error messages

    try {
      // API request to trigger password reset
      final response = await http.post(
        Uri.parse(Config.forgotPassword), // Using Config for base URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        AFullScreenLoader.stopLoading();

        // Successfully sent the email
        ALoaders.successSnackBar(title: 'Email Sent!',message: 'Password reset email sent successfully!');
        Get.off(() => const LoginScreen()); 
      } else {
        // Handle API error response
        var errorResponse = jsonDecode(response.body);
        ALoaders.errorSnackBar(title: 'Something went wrong', message: errorResponse);
      }
    } catch (e) {
      // Handle errors in the request
      ALoaders.errorSnackBar(title: 'Something Went Wrong!',message: 'Failed to send the request. Please check email & try again later.');
      print("Error: $e");
    } finally {
      AFullScreenLoader.stopLoading();
    }
  }
}
