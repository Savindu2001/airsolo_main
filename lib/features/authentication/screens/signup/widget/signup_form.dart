
import 'package:airsolo/common/widgets/login_signup/form_divider.dart';
import 'package:airsolo/common/widgets/login_signup/social_buttons.dart';
import 'package:airsolo/features/authentication/controllers/signup_controller.dart';
import 'package:airsolo/features/authentication/screens/signup/widget/terms_conditions.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/constants/texts.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:airsolo/utils/validators/validations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:country_picker/country_picker.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final dark = AHelperFunctions.isDarkMode(context);
    final controller = Get.put(SignupController(), permanent: true);
   
    return Form(
      key: controller.signupFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
    
          // First & Last Name
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.firstName,
                  validator: (value) => AValidator.validateEmptyText('First Name', value),
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: ATexts.firstName,
                    prefixIcon: Icon(Iconsax.user))
                  ),
              ),
              const SizedBox(width: ASizes.spaceBtwinputFields,),
              Expanded(
                child: TextFormField(
                  controller: controller.lastName,
                  validator: (value) => AValidator.validateEmptyText('Last Name', value),
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: ATexts.lastName,
                    prefixIcon: Icon(Iconsax.user))
                  ),
              ),
              
              
            ],
          ),
          const SizedBox(height: ASizes.spaceBtwinputFields,),
    
          //username
          TextFormField(
            controller: controller.username,
            validator: (value) => AValidator.validateEmptyText('Username', value),
            expands: false,
            decoration: const InputDecoration(
              labelText: ATexts.username,
              prefixIcon: Icon(Iconsax.user_edit))
            ),
    
          const SizedBox(height: ASizes.spaceBtwinputFields,),

          //Country
          TextFormField(
              controller: controller.country,
              readOnly: true,
              onTap: () {
                showCountryPicker(
                  context: context,
                  showPhoneCode: false, 
                  onSelect: (Country country) {
                    controller.country.text = country.name;
                  },
                );
              },
              validator: (value) => AValidator.validateEmptyText('Country', value),
              decoration: const InputDecoration(
                labelText: ATexts.country,
                prefixIcon: Icon(Iconsax.location),
              ),
            ),
    
          const SizedBox(height: ASizes.spaceBtwinputFields,),

        

          // Gender Dropdown
            DropdownButtonFormField<String>(
              value: controller.gender.text.isNotEmpty ? controller.gender.text : null,
              items: ['Male', 'Female', 'Other']
                  .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                        
                      ))
                  .toList(),
              onChanged: (value) {
                controller.gender.text = value!;
              },
              validator: (value) => AValidator.validateEmptyText('Gender', value),
               decoration: const InputDecoration(
                labelText: ATexts.gender,
                prefixIcon: Icon(Iconsax.star),
              ),
            ),

    
          const SizedBox(height: ASizes.spaceBtwinputFields,),
    
          //email
    
          TextFormField(
            controller: controller.email,
            validator: (value) => AValidator.validateEmail(value),
            expands: false,
            decoration: const InputDecoration(
              labelText: ATexts.email,
              prefixIcon: Icon(Iconsax.direct))
            ),
    
            const SizedBox(height: ASizes.spaceBtwinputFields,),
    
          //password
          Obx(
            () => TextFormField(
              controller: controller.password,
              validator: (value) => AValidator.validatePassword(value),
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
    
            const SizedBox(height: ASizes.spaceBtwinputFields,),
    
          //terms & Conditions Checkbox
    
          const ATermsConditions(),
          const SizedBox(height: ASizes.spaceBtwSections,),
    
          //Signup Buttons
          SizedBox( 
            width:double.infinity, 
            child: ElevatedButton(
              onPressed: () => controller.signup(), 
              child: const Text(ATexts.createAccount),)),

          const SizedBox(height: ASizes.spaceBtwSections,),
    
    
          //Divider
    
          AFormDivider(dark: dark, dividerText: ATexts.orSignupWith),
    
          const SizedBox(height: ASizes.spaceBtwSections,),
    
        /// Footer
        const ASocialButton(), 
    
        ],
      ),
      );
  }
   
}
