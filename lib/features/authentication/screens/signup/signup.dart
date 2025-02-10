import 'package:airsolo/features/authentication/screens/signup/widget/signup_form.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/constants/texts.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    


    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(ASizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Title
              Text(ATexts.signupTitle, style: Theme.of(context).textTheme.headlineMedium,),
              const SizedBox(height: ASizes.spaceBtwSections,),

              ///Form
              SignupForm(),
            ],
          ),
          ),
      ),
    );
  }
}
