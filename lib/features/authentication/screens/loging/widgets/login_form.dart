import 'package:airsolo/features/controllers/login_controller.dart';
import 'package:airsolo/features/authentication/screens/password_configuration/forget_password.dart';
import 'package:airsolo/features/authentication/screens/signup/signup.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/constants/texts.dart';
import 'package:airsolo/utils/validators/validations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ALoginForm extends StatelessWidget {
  const ALoginForm({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController()); // Create an instance of LoginController
    final controller = Get.put(LoginController());
    return Form(
      key: loginController.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: ASizes.spaceBtwSections),
        child: Column(
          children: [
            /// Email
            TextFormField(
              controller: loginController.email,
              validator: (value) => AValidator.validateEmail(value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: ATexts.email,
              ),
            ),
            const SizedBox(height: ASizes.spaceBtwinputFields),

          

            //password
          Obx(
            () => TextFormField(
              controller: loginController.password,
              obscureText: controller.hidePassword.value,
                decoration:  InputDecoration(
                  prefixIcon: const Icon(Iconsax.password_check),
                  labelText: ATexts.password ,
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value = !controller.hidePassword.value, 
                    icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.password_check )
                    ),
                ),
              ),
          ),
            const SizedBox(height: ASizes.spaceBtwinputFields / 2),

            /// Remember Me & Forget Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Remember Me
                Row(
                  children: [
                    Obx(()=> Checkbox(
                      value: controller.rememberMe.value, 
                      onChanged: (value) => controller.rememberMe.value = !controller.rememberMe.value )),
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
                onPressed: ()=> controller.login(),
                child: const Text(ATexts.signIn)),
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
