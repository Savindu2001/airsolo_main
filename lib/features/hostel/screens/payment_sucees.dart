// payment_success_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:airsolo/features/hostel/models/room_model.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:intl/intl.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>;
    final bookingId = arguments['bookingId'] as String;
    final amount = arguments['amount'] as double;
    final paymentMethod = arguments['paymentMethod'] as String;
    final room = arguments['room'] as Room;
    final checkInDate = arguments['checkInDate'] as DateTime;
    final checkOutDate = arguments['checkOutDate'] as DateTime;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(ASizes.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AImages.paymentSuccess, width: 150),
            const SizedBox(height: ASizes.spaceBtwSections),
            Text('Payment Successful!', style: Get.textTheme.headlineMedium),
            const SizedBox(height: ASizes.spaceBtwItems),
            Text('Booking ID: $bookingId', style: Get.textTheme.titleMedium),
            const SizedBox(height: ASizes.spaceBtwSections),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(ASizes.md),
                child: Column(
                  children: [
                    _buildSuccessRow('Room', room.name),
                    _buildSuccessRow('Amount', '\$${amount.toStringAsFixed(2)}'),
                    _buildSuccessRow('Payment Method', paymentMethod),
                    _buildSuccessRow('Check-in', DateFormat('MMM dd, yyyy').format(checkInDate)),
                    _buildSuccessRow('Check-out', DateFormat('MMM dd, yyyy').format(checkOutDate)),
                  ],
                ),
              ),
            ),
            
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
    );
  }

  Widget _buildSuccessRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: ASizes.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Get.textTheme.bodyMedium),
          Text(value, style: Get.textTheme.bodyLarge),
        ],
      ),
    );
  }
}