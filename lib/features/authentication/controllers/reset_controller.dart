import 'dart:async';
import 'dart:convert';
import 'package:airsolo/config.dart';
import 'package:airsolo/features/authentication/controllers/login_controller.dart';
import 'package:airsolo/features/authentication/screens/loging/login.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/helpers/network_manager.dart';
import 'package:airsolo/utils/popups/full_screen_loader.dart';
import 'package:airsolo/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ResetPasswordController extends GetxController {
  // Controllers
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  // Variables
  final hidePassword = true.obs;
  final hideConfirmPassword = true.obs;
  

  // Dispose controllers when not needed
  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> resetPassword() async {
    try {
      // Validate inputs
      if (newPasswordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
        throw 'Please enter both password fields';
      }

      if (newPasswordController.text != confirmPasswordController.text) {
        throw 'Passwords do not match';
      }

      if (newPasswordController.text.length < 6) {
        throw 'Password must be at least 6 characters';
      }

      // Start loading
      AFullScreenLoader.openLoadingDialog('Processing...', AImages.loading);

      // Check internet connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        AFullScreenLoader.stopLoading();
        return;
      }

      

      // Get current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw 'User not authenticated';
      }

      // Call your backend API
      final response = await http.post(
        Uri.parse(Config.resetPassword),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'uid': user.uid,
          'newPassword': newPasswordController.text.trim(),
        }),
      ).timeout(const Duration(seconds: 15));

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        AFullScreenLoader.stopLoading();
        ALoaders.successSnackBar(
          title: 'Success!',
          message: 'Password reset successfully',
        );
        await LoginController.instance.logout();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAll(() => const LoginScreen());
        });

      } else {
        throw responseData['message'] ?? 'Failed to reset password';
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password is too weak.';
          break;
        case 'requires-recent-login':
          errorMessage = 'This operation requires recent authentication. Please log in again.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again.';
      }
      ALoaders.errorSnackBar(title: 'Error', message: errorMessage);
    } on TimeoutException {
      ALoaders.errorSnackBar(title: 'Timeout', message: 'Request took too long. Please try again.');
    } catch (e) {
      ALoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
     
      AFullScreenLoader.stopLoading();
    }
  }
}