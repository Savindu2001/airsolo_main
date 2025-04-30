import 'package:airsolo/features/taxi/models/taxi_booking_model.dart';
import 'package:airsolo/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shimmer/main.dart';

class TripCompletionScreen extends StatelessWidget {
  final TaxiBooking booking;

  const TripCompletionScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Completed'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () => Get.offAll(() => NavigationMenu()),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 80),
            SizedBox(height: 20),
            Text('Trip Completed!', style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            Text('LKR ${booking.totalPrice}', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Get.offAll(() => NavigationMenu()),
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}