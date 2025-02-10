
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';

class ALoginForm extends StatelessWidget {
  const ALoginForm({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Form(
      child:Padding(
        padding: const EdgeInsets.symmetric(vertical: ASizes.spaceBtwSections),
        child: Column(
          children: [
            ///Email
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: ATexts.email,
              ),
            ),
                          
            const SizedBox(height: ASizes.spaceBtwinputFields,),
            ///Password
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.password_check),
                labelText: ATexts.password ,
                suffixIcon: Icon(Iconsax.eye_slash)
              ),
            ),
            const SizedBox(height: ASizes.spaceBtwinputFields / 2),
                          
            /// Remember Me & Forget Password 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Remember Me
                Row(
                  children: [
                    Checkbox(value: true, onChanged: (value){}),
                    const Text(ATexts.rememberMe),
                  ],
                ),
                
                //Forget Password
                          
                TextButton(onPressed: (){}, child: const Text(ATexts.forgetPassword)),
              ],
            ),
                          
            const SizedBox(height: ASizes.spaceBtwSections,),
                          
            
            //Sign In Button
            SizedBox( width:double.infinity, child: ElevatedButton(onPressed: (){}, child: const Text(ATexts.signIn),style: ElevatedButton.styleFrom(backgroundColor: dark ? AColors.primary : AColors.black),)),
            const SizedBox(height: ASizes.spaceBtwItems,),
            //create Account Button
            SizedBox( width:double.infinity, child: ElevatedButton(onPressed: (){}, child: const Text(ATexts.createAccount ))),
           
          ],
        ),
      ) 
      );
  }
}
