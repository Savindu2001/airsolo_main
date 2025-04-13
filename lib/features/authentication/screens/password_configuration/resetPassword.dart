import 'package:airsolo/features/authentication/controllers/reset_controller.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/constants/texts.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final ResetPasswordController controller = Get.put(ResetPasswordController());

  @override
  void dispose() {
    // If your controller uses animation or other disposables, call this:
    controller.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            /// Image
            Image(
              image: const AssetImage(AImages.sentEmail),
              width: AHelperFunctions.screenWidth() * 0.6,
            ),
            const SizedBox(height: ASizes.spaceBtwSections,),

            /// Title & SubTitle
            Text(
              ATexts.changeYourPasswordTitle,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: ASizes.spaceBtwItems,),
            Text(
              ATexts.changeYourPasswordSubTitle,
              style: Theme.of(context).textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: ASizes.spaceBtwSections,),

            /// New Password Field
            Obx(() => TextFormField(
              controller: controller.newPasswordController,
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                labelText: 'New Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.hidePassword.value
                        ? Iconsax.eye_slash
                        : Iconsax.password_check,
                  ),
                  onPressed: () => controller.hidePassword.toggle(),
                ),
              ),
            )),

            const SizedBox(height: ASizes.spaceBtwItems,),

            /// Confirm Password Field
            Obx(() => TextFormField(
              controller: controller.confirmPasswordController,
              obscureText: controller.hideConfirmPassword.value,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.hideConfirmPassword.value
                        ? Iconsax.eye_slash
                        : Iconsax.password_check,
                  ),
                  onPressed: () => controller.hideConfirmPassword.toggle(),
                ),
              ),
            )),

            const SizedBox(height: 20),

            /// Reset Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.resetPassword,
                child: const Text('Reset Password'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
