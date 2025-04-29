import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final String bookingId;
  final String driverName;
  final String vehicleModel;
  final String vehicleNumber;

  const BookingConfirmationScreen({
    Key? key,
    required this.bookingId,
    required this.driverName,
    required this.vehicleModel,
    required this.vehicleNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking ID: $bookingId',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Driver: $driverName',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Vehicle: $vehicleModel',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Vehicle Number: $vehicleNumber',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Proceed to payment or take further booking actions
                Get.snackbar('Booking Confirmed', 'Your booking is confirmed!');
              },
              child: Text('Confirm Booking'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // You can choose the color as you like
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // Go back to the available drivers screen
                Get.back();
              },
              child: Text('Back to Drivers'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey, // A secondary action for going back
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
