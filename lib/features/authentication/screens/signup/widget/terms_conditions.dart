
import 'package:airsolo/features/controllers/signup_controller.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/constants/texts.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class ATermsConditions extends StatelessWidget {
  const ATermsConditions({
    super.key,
  });

  

  @override
  Widget build(BuildContext context) {
    final controller = SignupController.instance;
    final dark = AHelperFunctions.isDarkMode(context);
    return Row(
      children: [
        SizedBox(height: 24,width: 24,
        child: Obx(()=> Checkbox(
          value: controller.privacyPolicy.value, 
          onChanged: (value) => controller.privacyPolicy.value = !controller.privacyPolicy.value ))),
        const SizedBox(height: ASizes.spaceBtwItems,),
        Text.rich(TextSpan(
          children:[
            TextSpan(text: ATexts.iAgreeTo, style: Theme.of(context).textTheme.bodySmall),
        
            TextSpan(text: ATexts.privacyPolicy, style: Theme.of(context).textTheme.bodyMedium!.apply(
              color: dark ? AColors.white : AColors.primary,
              decoration: TextDecoration.underline,
              decorationColor: dark ? AColors.white : AColors.primary, 
            )),
        
            TextSpan(text: ATexts.and, style: Theme.of(context).textTheme.bodySmall),
        
            TextSpan(text: ATexts.termsOfUse, style: Theme.of(context).textTheme.bodyMedium!.apply(
              color: dark ? AColors.white : AColors.primary,
              decoration: TextDecoration.underline,
              decorationColor: dark ? AColors.white : AColors.primary, 
            )),
          ] 
          )),
      ],
    );
  }
}