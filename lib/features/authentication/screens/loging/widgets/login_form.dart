import 'package:airsolo/features/authentication/screens/password_configuration/forget_password.dart';
import 'package:airsolo/features/authentication/screens/signup/signup.dart';
import 'package:airsolo/navigation_menu.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/constants/texts.dart';
import 'package:airsolo/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http; // Import for HTTP requests
import 'dart:convert'; // Import for JSON encoding/decoding
import 'package:shared_preferences/shared_preferences.dart'; // Import for SharedPreferences

class ALoginForm extends StatefulWidget {
  const ALoginForm({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  _ALoginFormState createState() => _ALoginFormState();
}

class _ALoginFormState extends State<ALoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false; // State to track loading

  Future<void> login() async {
    final String email = emailController.text;
    final String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      
      ALoaders.warningSnackBar(
        title: 'title',
        message: 'Please enter email and password');
      return;
    }

    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.5:3000/api/users/login'), // Your backend login URL
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String token = data['token'];

        // Store the token using SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwtToken', token);

        // Navigate to the next screen
        Get.to(() => const NavigationMenu());
      } else {
        final errorData = jsonDecode(response.body);
        ALoaders.errorSnackBar(
          title: 'Eorror ',
          message: Text(errorData['message'])
          );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging in: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: ASizes.spaceBtwSections),
        child: Column(
          children: [
            /// Email
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: ATexts.email,
              ),
            ),
            const SizedBox(height: ASizes.spaceBtwinputFields),

            /// Password
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.password_check),
                labelText: ATexts.password,
                suffixIcon: Icon(Iconsax.eye_slash),
              ),
              obscureText: true, // Hide password
            ),
            const SizedBox(height: ASizes.spaceBtwinputFields / 2),

            /// Remember Me & Forget Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Remember Me
                Row(
                  children: [
                    Checkbox(value: true, onChanged: (value) {}),
                    const Text(ATexts.rememberMe),
                  ],
                ),

                // Forget Password
                TextButton(
                  onPressed: () => Get.to(() => const ForgetPassword()),
                  child: const Text(ATexts.forgetPassword),
                ),
              ],
            ),
            const SizedBox(height: ASizes.spaceBtwSections),

            // Sign In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : login, // Disable button when loading
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white) // Show loading indicator
                    : const Text(ATexts.signIn),
              ),
            ),
            const SizedBox(height: ASizes.spaceBtwItems),

            // Create Account Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.to(() => const SignupScreen()),
                child: const Text(ATexts.createAccount),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
