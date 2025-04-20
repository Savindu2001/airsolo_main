import 'package:airsolo/features/hostel/models/room_model.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final Room room;
  final DateTime checkInDate;
  final DateTime checkOutDate;

  const PaymentSuccessScreen({
    super.key,
    required this.room,
    required this.checkInDate,
    required this.checkOutDate,
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
              Text('Your booking for ${room.name} is confirmed', 
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: ASizes.spaceBtwItems),
              Text('${DateFormat('MMM dd').format(checkInDate)} - ${DateFormat('MMM dd, yyyy').format(checkOutDate)}',
                  style: Theme.of(context).textTheme.bodyMedium),
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