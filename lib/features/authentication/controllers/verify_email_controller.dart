import 'dart:async';
import 'package:airsolo/common/widgets/success_screen/success_screen.dart';
import 'package:airsolo/features/authentication/screens/loging/login.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/constants/texts.dart';
import 'package:airsolo/utils/helpers/network_manager.dart';
import 'package:airsolo/utils/popups/loaders.dart';
import 'package:airsolo/utils/validators/validations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:airsolo/config.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  final isVerifying = false.obs;
  final canResend = true.obs;
  final resendCountdown = 30.obs;
  Timer? _resendTimer;
  Timer? _autoCheckTimer;
  String? _email;
  int _autoCheckAttempts = 0;
  final int _maxAutoCheckAttempts = 12; 

  @override
  void onInit() {
    super.onInit();
    _initializeUser();
  }

  void setEmail(String email) {
    _email = email;
  }

  /// Send verification email using your backend API
  Future<void> sendEmailVerification() async {
    try {
      isVerifying.value = true;

      // Validate email before sending
      final emailError = AValidator.validateEmail(_email);
      if (emailError != null) {
        throw Exception(emailError);
      }
      
      // Check internet connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;

      // Call your backend API
      final response = await http.post(
        Uri.parse(Config.verifyEmail),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': _email}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Start cooldown timer
        canResend.value = false;
        resendCountdown.value = 30;
        _startResendTimer();

        ALoaders.successSnackBar(
          title: 'Email Sent',
          message: 'Verification email sent to $_email',
        );
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to send verification email');
      }
    } on TimeoutException {
      ALoaders.errorSnackBar(title: 'Timeout', message: 'Request took too long');
    } on http.ClientException {
      ALoaders.errorSnackBar(title: 'Network Error', message: 'Could not connect to server');
    } catch (e) {
      ALoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isVerifying.value = false;
    }
  }

  /// Check if email is verified
  Future<void> checkEmailVerified() async {
    try {
      isVerifying.value = true;
      
      // Check internet connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;

      // Call your backend API to check verification status
      final response = await http.post(
        Uri.parse(Config.verifyEmailCheck),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': _email}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['verified'] == true) {
          _navigateToSuccessScreen();
        } else {
          ALoaders.warningSnackBar(
            title: 'Not Verified',
            message: 'Please check your email and click the verification link',
          );
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to check verification status');
      }
    } on TimeoutException {
      ALoaders.errorSnackBar(title: 'Timeout', message: 'Request took too long');
    } on http.ClientException {
      ALoaders.errorSnackBar(title: 'Network Error', message: 'Could not connect to server');
    } catch (e) {
      ALoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isVerifying.value = false;
    }
  }

  /// Start automatic verification checking
  void startAutoVerificationCheck() {
    _autoCheckTimer?.cancel();
    _autoCheckAttempts = 0;
    
    _autoCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (_autoCheckAttempts >= _maxAutoCheckAttempts) {
        timer.cancel();
        ALoaders.warningSnackBar(
          title: 'Verification Timeout',
          message: 'Please try resending the verification email',
        );
        return;
      }
      
      _autoCheckAttempts++;
      await checkEmailVerified();
    });
  }

  /// Initialize user session
  Future<void> _initializeUser() async {
    try {
      if (_email == null) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          _email = user.email;
        }
      }
    } catch (e) {
      ALoaders.errorSnackBar(title: 'Error', message: 'Failed to initialize user');
    }
  }

  /// Start the resend email cooldown timer
  void _startResendTimer() {
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      resendCountdown.value--;
      if (resendCountdown.value <= 0) {
        timer.cancel();
        canResend.value = true;
      }
    });
  }

  /// Navigate to success screen
  void _navigateToSuccessScreen() {
    _autoCheckTimer?.cancel();
    _resendTimer?.cancel();
    
    Get.offAll(() => SuccessScreen(
      image: AImages.verifiedEmail,
      title: ATexts.yourAccountCreatedTitle,
      subTitle: ATexts.yourAccountCreatedSubTitle,
      buttonText: ATexts.aContinue,
      onPressed: () => Get.offAll(() => const LoginScreen()),
    ));
  }

  @override
  void onClose() {
    _resendTimer?.cancel();
    _autoCheckTimer?.cancel();
    super.onClose();
  }
}