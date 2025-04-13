import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:airsolo/config.dart';
import 'package:airsolo/utils/popups/loaders.dart';

class SocialLoginController extends GetxController {
  static SocialLoginController get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final RxBool isLoading = false.obs;

  Future<void> socialLogin() async {
    try {
      // Show loading indicator
      isLoading.value = true;

      // 1. Let user select provider (Google, Apple, etc.)
      final provider = await _selectProvider();
      if (provider == null) return;

      // 2. Authenticate with Firebase
      final UserCredential userCredential = await _authenticateWithProvider(provider);

      // 3. Get ID token
      final idToken = await userCredential.user!.getIdToken();

      // 4. Send to your backend
      final response = await http.post(
        Uri.parse(Config.socialLoginEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        // 5. Store token securely
        await _storage.write(key: 'auth_token', value: responseData['token']);
        
        // 6. Navigate to home screen
        _handleSuccessfulLogin(responseData['user']);
      } else {
        throw Exception('Failed to authenticate with backend');
      }
    } on FirebaseAuthException catch (e) {
      ALoaders.errorSnackBar(title: 'Authentication Error', message: e.message ?? 'Unknown error');
    } catch (e) {
      ALoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> _selectProvider() async {
    // You can show a dialog or use platform detection
    // For this example, we'll just use Google
    return 'google';
  }

  Future<UserCredential> _authenticateWithProvider(String provider) async {
    switch (provider) {
      case 'google':
        return await _signInWithGoogle();
      // case 'apple':
      //   return await _signInWithApple();
      default:
        throw Exception('Unsupported provider');
    }
  }

  Future<UserCredential> _signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await _auth.signInWithCredential(credential);
  }

  void _handleSuccessfulLogin(dynamic userData) {
    // Navigate to home screen or profile setup if needed
    Get.offAllNamed('/home');
    
    ALoaders.successSnackBar(
      title: 'Welcome back!',
      message: 'You have successfully logged in',
    );
  }
}