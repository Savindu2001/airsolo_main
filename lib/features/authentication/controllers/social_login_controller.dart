import 'dart:async';
import 'dart:convert';

import 'package:airsolo/config.dart';
import 'package:airsolo/features/authentication/screens/loging/login.dart';
import 'package:airsolo/navigation_menu.dart';
import 'package:airsolo/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class SocialLoginController extends GetxController {
  static SocialLoginController get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    clientId: kIsWeb
      ? '785691024956-sl7fp2jktgtsoh854fr1a5nc9au179e4.apps.googleusercontent.com'
      : null,
  );
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Rx<SocialLoginState> state = SocialLoginState.idle.obs;

  @override
  void onClose() {
    _googleSignIn.signOut();
    super.onClose();
  }

  Future<void> signInWithGoogle() async {
    try {
      state.value = SocialLoginState.loading;

      // 1. Authenticate with Google
      final userCredential = await _signInWithGoogle();
      final user = userCredential.user;
      
      if (user == null) throw Exception('Google authentication failed');

      // 2. Verify email is present
      if (user.email == null) {
        throw Exception('Email not provided by Google');
      }

      // 3. Get fresh ID token
      final idToken = await user.getIdToken(true);

      // 4. Verify with backend
      final response = await http.post(
        Uri.parse(Config.socialLoginEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'idToken': idToken,
          'provider': 'google',
          'deviceToken': await _storage.read(key: 'fcm_token'),
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception('Backend verification failed: ${response.statusCode}');
      }

      // 5. Process successful login
      final responseData = jsonDecode(response.body);
      await _handleSuccessfulLogin(
        token: responseData['token'],
        refreshToken: responseData['refreshToken'],
        userData: responseData['user'],
      );

      state.value = SocialLoginState.success;
    } on FirebaseAuthException catch (e) {
      _handleError(e.message ?? 'Google sign-in failed');
    } on TimeoutException {
      _handleError('Request timed out');
    } catch (e) {
      _handleError(e.toString());
    } finally {
      if (state.value != SocialLoginState.success) {
        state.value = SocialLoginState.idle;
      }
    }
  }

Future<UserCredential> _signInWithGoogle() async {
  try {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Sign-in cancelled');

    final googleAuth = await googleUser.authentication;
    if (googleAuth.idToken == null) throw Exception('Missing Google ID token');

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    return await _auth.signInWithCredential(credential);
  } on PlatformException catch (e) {
    if (e.code == 'sign_in_failed') {
      throw Exception('Google Sign-In configuration error. '
          'Verify client ID and Firebase setup.');
    }
    rethrow;
  } catch (e) {
    await _googleSignIn.signOut();
    rethrow;
  }
}


  /* Commented out Apple Sign-In
  Future<UserCredential> _signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: Config.appleClientId,
          redirectUri: Uri.parse(Config.appleRedirectUri),
        ),
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      return await _auth.signInWithCredential(oauthCredential);
    } catch (e) {
      rethrow;
    }
  }
  */

  Future<void> _handleSuccessfulLogin({
    required String token,
    required String refreshToken,
    required Map<String, dynamic> userData,
  }) async {
    try {
      // Store tokens securely
      await _storage.write(key: 'auth_token', value: token);
      await _storage.write(key: 'refresh_token', value: refreshToken);
      await _storage.write(key: 'user_data', value: jsonEncode(userData));

      // Navigate to home screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAll(() => const NavigationMenu());
      });

      ALoaders.successSnackBar(
        title: 'Welcome ${userData['firstName'] ?? userData['email']?.split('@')[0] ?? ''}',
        message: 'You have successfully logged in',
      );
    } catch (e) {
      await _auth.signOut();
      await _googleSignIn.signOut();
      await _storage.deleteAll();
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      state.value = SocialLoginState.loading;
      await _auth.signOut();
      await _googleSignIn.signOut();
      await _storage.deleteAll();
      state.value = SocialLoginState.idle;
      
      // Navigate to login screen
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      state.value = SocialLoginState.error;
      ALoaders.errorSnackBar(
        title: 'Logout Failed',
        message: e.toString(),
      );
    }
  }

  void _handleError(String message) {
    state.value = SocialLoginState.error;
    ALoaders.errorSnackBar(
      title: 'Login Failed',
      message: message,
    );
  }
}

enum SocialLoginState { idle, loading, success, error }




// Future<String?> refreshAuthToken() async {
//   final refreshToken = await _storage.read(key: 'refresh_token');
//   if (refreshToken == null) return null;
  
//   final response = await http.post(
//     Uri.parse(Config.refreshTokenEndpoint),
//     headers: {'Content-Type': 'application/json'},
//     body: jsonEncode({'refreshToken': refreshToken}),
//   );
  
//   if (response.statusCode == 200) {
//     final newToken = jsonDecode(response.body)['token'];
//     await _storage.write(key: 'auth_token', value: newToken);
//     return newToken;
//   }
//   return null;
// }