
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentSuccessScreen extends StatelessWidget {
  //final String bookingId;

  const PaymentSuccessScreen({
    super.key, 
    //required this.bookingId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(ASizes.defaultSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: AColors.success, size: 100),
              const SizedBox(height: ASizes.spaceBtwSections),
              Text('Payment Successful!', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: ASizes.spaceBtwItems),
              Text('Your booking {bookingId} is confirmed', 
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: ASizes.spaceBtwItems),
              
              const SizedBox(height: ASizes.spaceBtwSections),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.offAllNamed('/home'),
                  child: const Text('Back to Home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}