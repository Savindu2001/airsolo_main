import 'package:airsolo/features/driver/driverDashboard.dart';
import 'package:airsolo/features/authentication/screens/loging/login.dart';
import 'package:airsolo/features/authentication/screens/onboarding/onboarding.dart';
import 'package:airsolo/navigation_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _deviceStorage = GetStorage();
  final _firebaseAuth = FirebaseAuth.instance;
  final _initialized = false.obs;
  final _isLoggedIn = false.obs;
  final _userRole = 'traveler'.obs;

  @override
  void onReady() {
    if (!_initialized.value) {
      FlutterNativeSplash.remove();
      _initialized.value = true;
    }
  }

  Future<void> initializeAuthState() async {
    if (_initialized.isFalse) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwtToken');
      final currentUser = _firebaseAuth.currentUser;

      if (token != null && currentUser != null) {
        _isLoggedIn.value = true;
        _userRole.value = prefs.getString('userRole') ?? 'traveler';
        await _navigateBasedOnRole(_userRole.value);
      } else {
        await _redirectToAppropriateScreen();
      }
    } catch (e) {
      await _redirectToLogin();
    }
  }

  Future<void> handleSuccessfulLogin({
    required String token,
    required String role,
    required Map<String, dynamic> userData,
  }) async {
    try {
      _isLoggedIn.value = true;
      _userRole.value = role;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwtToken', token);
      await prefs.setString('userRole', role);
      await prefs.setString('userEmail', userData['email'] ?? '');
      await prefs.setString('userName', '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}');
      await prefs.setString('userPhoto', userData['profile_photo'] ?? '');
      await _deviceStorage.write('isFirstTime', false);

      await _navigateBasedOnRole(role);
    } catch (e) {
      throw Exception('Failed to handle login: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      _isLoggedIn.value = false;
      await _redirectToLogin();
    } catch (e) {
      throw Exception('Failed to logout: ${e.toString()}');
    }
  }


  Future<void> _navigateBasedOnRole(String role) async {
    await Future.delayed(const Duration(milliseconds: 50));
    Get.offAll(
      () => role == 'driver' ? const DriverDashboard() : const NavigationMenu(),
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> _redirectToAppropriateScreen() async {
    final isFirstTime = _deviceStorage.read('isFirstTime') ?? true;
    if (isFirstTime) {
      Get.offAll(() => const Onboarding());
    } else {
      await _redirectToLogin();
    }
  }

  Future<void> _redirectToLogin() async {
    try {
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      Get.reset();
    }
  }

  refreshToken() {}

}
