import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final String bookingId;
  final String driverName;
  final String vehicleModel;
  final String vehicleNumber;

  const BookingConfirmationScreen({
    super.key,
    required this.bookingId,
    required this.driverName,
    required this.vehicleModel,
    required this.vehicleNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking ID: $bookingId',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Driver: $driverName',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Vehicle: $vehicleModel',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Vehicle Number: $vehicleNumber',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Proceed to payment or take further booking actions
                Get.snackbar('Booking Confirmed', 'Your booking is confirmed!');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // You can choose the color as you like
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text('Confirm Booking'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // Go back to the available drivers screen
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey, // A secondary action for going back
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text('Back to Drivers'),
            ),
          ],
        ),
      ),
    );
  }
}
