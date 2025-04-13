import 'package:airsolo/utils/helpers/network_manager.dart';
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
import 'package:airsolo/utils/popups/loaders.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyEmailController());
    final dark = AHelperFunctions.isDarkMode(context);
    final textTheme = Theme.of(context).textTheme;
    
    // Initialize controller with email and start auto-check
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.setEmail(email);
      controller.startAutoVerificationCheck();
    });

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldExit = await showExitConfirmation(context);
        if (shouldExit) {
          Get.offAll(() => const LoginScreen());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () async {
                final shouldExit = await showExitConfirmation(context);
                if (shouldExit) {
                  Get.offAll(() => const LoginScreen());
                }
              },
              icon: Icon(
                CupertinoIcons.clear,
                color: dark ? Colors.white : Colors.black,
              ),
              tooltip: 'Close',
            )
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(ASizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Email verification illustration
                Image.asset(
                  AImages.verifyEmail,
                  width: AHelperFunctions.screenWidth() * 0.6,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: ASizes.spaceBtwSections),

                // Title and subtitle
                Text(
                  ATexts.confirmEmail,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: ASizes.spaceBtwItems),

                // Email address with copy functionality
                _EmailCopyWidget(email: email, dark: dark),
                const SizedBox(height: ASizes.spaceBtwItems),

                // Instructions
                Text(
                  ATexts.confirmEmailSubTitle,
                  style: textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: ASizes.spaceBtwSections),

                // Verification buttons
                _VerificationButtons(controller: controller),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> showExitConfirmation(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Verification?'),
        content: const Text('Are you sure you want to cancel email verification?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }
}

class _EmailCopyWidget extends StatelessWidget {
  const _EmailCopyWidget({
    required this.email,
    required this.dark,
  });

  final String email;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Copy to clipboard',
      child: InkWell(
        borderRadius: BorderRadius.circular(ASizes.borderRadiusMd),
        onTap: () {
          Clipboard.setData(ClipboardData(text: email));
          ALoaders.successSnackBar(title: 'Copied', message: 'Email address copied to clipboard');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: ASizes.md,
            vertical: ASizes.sm,
          ),
          decoration: BoxDecoration(
            color: dark ? Colors.grey[800] : Colors.grey[200],
            borderRadius: BorderRadius.circular(ASizes.borderRadiusMd),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  email,
                  style: Theme.of(context).textTheme.labelLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: ASizes.sm),
              Icon(
                Icons.copy,
                size: 16,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerificationButtons extends StatelessWidget {
  const _VerificationButtons({
    required this.controller,
  });

  final VerifyEmailController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Continue button
        Obx(() {
          final isVerifying = controller.isVerifying.value;
          return SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isVerifying ? null : () async {
                final isConnected = await NetworkManager.instance.isConnected();
                if (!isConnected) return;
                controller.checkEmailVerified();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: ASizes.buttonHeight),
              ),
              child: isVerifying
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(ATexts.aContinue),
            ),
          );
        }),
        const SizedBox(height: ASizes.spaceBtwItems),

        // Resend email button
        Obx(() {
          final canResend = controller.canResend.value;
          final countdown = controller.resendCountdown.value;
          
          return SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: canResend ? () async {
                final isConnected = await NetworkManager.instance.isConnected();
                if (!isConnected) return;
                controller.sendEmailVerification();
              } : null,
              child: canResend
                  ? const Text(ATexts.resendEmail)
                  : RichText(
                      text: TextSpan(
                        text: 'Resend in ',
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: '$countdown',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                          ),
                          const TextSpan(text: 's'),
                        ],
                      ),
                    ),
            ),
          );
        }),
      ],
    );
  }
}