import 'package:airsolo/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:iconsax/iconsax.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(ASizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //Heading
            Text(ATexts.forgetPasswordTitle, style: Theme.of(context).textTheme.headlineMedium,),
            const SizedBox(height: ASizes.spaceBtwItems,),
            Text(ATexts.forgetPasswordSubTitle, style: Theme.of(context).textTheme.labelMedium,),
            const SizedBox(height: ASizes.spaceBtwSections * 2,),


            // Text

            TextFormField(
              decoration: const InputDecoration(
                labelText: ATexts.email,
                prefixIcon: Icon(Iconsax.direct_right)
              ),
            ),


            //Submit

            const SizedBox(height: ASizes.spaceBtwSections,),
            SizedBox( width:double.infinity, child: ElevatedButton(onPressed: ()=> Get.off(()=> const ResetPassword()), child: const Text(ATexts.submit),)),



          ],
        ),
        ),
    );
  }
}