import 'package:airsolo/utils/popups/full_screen_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:airsolo/features/authentication/controllers/verify_email_controller.dart';
import 'package:airsolo/features/authentication/screens/loging/login.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/constants/texts.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyEmailController());
    final dark = AHelperFunctions.isDarkMode(context);

    // Initialize with the provided email
    controller.setEmail(email);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.offAll(() => const LoginScreen()),
            icon: Icon(
              CupertinoIcons.clear,
              color: dark ? Colors.white : Colors.black,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ASizes.defaultSpace),
        child: Column(
          children: [
            // Email verification image
            Image.asset(
              AImages.verifyEmail,
              width: AHelperFunctions.screenWidth() * 0.6,
            ),
            const SizedBox(height: ASizes.spaceBtwSections),

            // Headline
            Text(
              ATexts.confirmEmail,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: ASizes.spaceBtwItems),

            // Email & copy option
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: email));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email copied to clipboard')),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    email,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.copy, size: 16, color: Theme.of(context).primaryColor),
                ],
              ),
            ),

            const SizedBox(height: ASizes.spaceBtwItems),

            // Subtext
            Text(
              ATexts.confirmEmailSubTitle,
              style: Theme.of(context).textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: ASizes.spaceBtwSections),

            // Continue button
            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isVerifying.value
                    ? null
                    : () => controller.checkEmailVerified(),
                child: controller.isVerifying.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(ATexts.aContinue),
              ),
            )),
            
            // Continue button with full-screen loader
// SizedBox(
//   width: double.infinity,
//   child: ElevatedButton(
//     onPressed: () {
//       AFullScreenLoader.openLoadingDialog(
//         'We are processing your information...',
//         AImages.proccessingDocer,
//       );
//       controller.checkEmailVerified();
//     },
//     child: const Text(ATexts.aContinue),
//   ),
// ),

            const SizedBox(height: ASizes.spaceBtwItems),

            // Resend button with cooldown
            Obx(() {
              final canResend = controller.canResend.value;
              return SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: canResend
                      ? () => controller.sendEmailVerification()
                      : null,
                  child: canResend
                      ? const Text(ATexts.resendEmail)
                      : Text('Resend in ${controller.resendCountdown.value}s'),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
