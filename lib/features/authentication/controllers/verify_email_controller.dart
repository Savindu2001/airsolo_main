import 'dart:async';
import 'package:airsolo/common/widgets/success_screen/success_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:airsolo/features/authentication/screens/loging/login.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/constants/texts.dart';

class VerifyEmailController extends GetxController {
  final isVerifying = false.obs;
  final canResend = true.obs;
  final resendCountdown = 30.obs; // 30 seconds cooldown
  Timer? _resendTimer;
  Timer? _autoCheckTimer;
  String? _email;

  void setEmail(String email) {
    _email = email;
  }

  /// Send verification email
  Future<void> sendEmailVerification() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();

      // Start cooldown
      canResend.value = false;
      resendCountdown.value = 30;

      _resendTimer?.cancel();
      _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        resendCountdown.value--;

        if (resendCountdown.value <= 0) {
          timer.cancel();
          canResend.value = true;
        }
      });

      // Optionally, show a success message
      Get.snackbar("Verification Email Sent", "Please check your inbox.");

    } catch (e) {
      Get.snackbar("Error", "Failed to send email: ${e.toString()}");
    }
  }

  /// Manual check if user verified
  Future<void> checkEmailVerified() async {
    isVerifying.value = true;

    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.reload(); // 🔁 Force refresh user data
      final refreshedUser = FirebaseAuth.instance.currentUser;

      if (refreshedUser != null && refreshedUser.emailVerified) {
        _autoCheckTimer?.cancel(); // stop auto-check if running

        Get.offAll(() => SuccessScreen(
          image: AImages.verifiedEmail,
          title: ATexts.yourAccountCreatedTitle,
          subTitle: ATexts.yourAccountCreatedSubTitle,
          buttonText: ATexts.aContinue,
          onPressed: () => Get.offAll(() => const LoginScreen()),
        ));
      } else {
        Get.snackbar("Not Verified", "Please verify your email first.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isVerifying.value = false;
    }
  }

  /// Optional: Start auto-checking every few seconds
  void startAutoVerificationCheck() {
    _autoCheckTimer?.cancel(); // clear previous

    _autoCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;

      if (user != null && user.emailVerified) {
        timer.cancel();

        Get.offAll(() => SuccessScreen(
          image: AImages.verifiedEmail,
          title: ATexts.yourAccountCreatedTitle,
          subTitle: ATexts.yourAccountCreatedSubTitle,
          buttonText: ATexts.aContinue,
          onPressed: () => Get.offAll(() => const LoginScreen()),
        ));
      }
    });
  }

  @override
  void onClose() {
    _resendTimer?.cancel();
    _autoCheckTimer?.cancel();
    super.onClose();
  }
}
