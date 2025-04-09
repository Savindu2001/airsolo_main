import 'package:airsolo/features/authentication/screens/signup/verify_email.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/helpers/network_manager.dart';
import 'package:airsolo/utils/popups/full_screen_loader.dart';
import 'package:airsolo/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert'; 
import 'package:airsolo/config.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  // Variables Get From Signup Form
  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  final email = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final username = TextEditingController();
  final country = TextEditingController();
  final password = TextEditingController();
  final gender = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  // Signup
  void signup() async {
    try {
      // Start Loading
      AFullScreenLoader.openLoadingDialog('We are processing your information..', AImages.proccessingDocer);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;

      // Form Validation
      if (!signupFormKey.currentState!.validate()) return;

      // Privacy Policy Check
      if (!privacyPolicy.value) {
        ALoaders.warningSnackBar(
          title: 'Accept Privacy Policy',
          message: 'In Order to Create Account, you must read and accept Privacy policy & Terms Conditions'
        );
        return;
      }

      // Prepare user data
      final userData = {
        'firstName': firstName.text.trim(),
        'lastName': lastName.text.trim(),
        'username': username.text.trim(),
        'email': email.text.trim(),
        'password': password.text.trim(),
        'country' : country.text.trim(),
        'gender' : gender.text.trim(),
        'role' : 'traveler',
        'profile_photo':'http://www.myimage.com/',
      };

      // Send data to Node.js backend
      final response = await http.post(
        Uri.parse(Config.registerEndpoint), 
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userData),
      );



      if (response.statusCode == 200) {

        AFullScreenLoader.stopLoading();
        ALoaders.successSnackBar(title: 'Succesfully! Registerd', message: 'We Sent Verify Email To Your Email');
        //Get.to(() => VerifyEmailScreen(email: email.text.trim()), transition: Transition.rightToLeft);

        Navigator.of(Get.context!).pushReplacement(
          MaterialPageRoute(builder: (context) => VerifyEmailScreen(email: email.text.trim()))
        );
        
        
      } else {
        // Handle API errors
        final errorData = jsonDecode(response.body);
        ALoaders.errorSnackBar(title: 'Registration Failed', message: errorData['message']);
      }
    } catch (e) {
      // Show Generic Errors to User
      ALoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      // Remove Loader
      AFullScreenLoader.stopLoading();
    }
  }
}
