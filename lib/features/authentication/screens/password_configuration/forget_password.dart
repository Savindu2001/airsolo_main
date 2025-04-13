import 'package:airsolo/features/authentication/controllers/fogot_controller.dart';
import 'package:airsolo/utils/validators/validations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/constants/texts.dart';
import 'package:iconsax/iconsax.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final ForgotPasswordController controller = Get.put(ForgotPasswordController());
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(ASizes.defaultSpace),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              Text(ATexts.forgetPasswordTitle, style: Theme.of(context).textTheme.headlineMedium,),
              const SizedBox(height: ASizes.spaceBtwItems,),
              Text(ATexts.forgetPasswordSubTitle, style: Theme.of(context).textTheme.labelMedium,),
              const SizedBox(height: ASizes.spaceBtwSections * 2,),
          
              // Email Input Field with Validation Feedback
              TextFormField(
                controller: controller.emailController,
                validator: (value) => AValidator.validateEmail(value),
                decoration:const InputDecoration(
                  labelText: ATexts.email,
                  prefixIcon:  Icon(Iconsax.direct_right),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
          
              // Submit Button
              const SizedBox(height: ASizes.spaceBtwSections,),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.submitForgotPassword,
                  child: const Text(ATexts.submit),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
