import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/taxi_booking_controller.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final TaxiBookingController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Confirm Booking')),
      body: Obx(() {
        if (controller.currentBooking.value == null) {
          return Center(child: Text('No booking found'));
        }
        final booking = controller.currentBooking.value!;
        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Trip Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      //Text('From: ${booking.pickupLocation}'),
                      //Text('To: ${booking.dropLocation}'),
                      Text('Distance: ${booking.distance} km'),
                      Text('Price: \$${booking.totalPrice.toStringAsFixed(2)}'),
                      //Text('Vehicle Type: ${booking.vehicleTypeId}'),
                      if (booking.isShared)
                        Text('Shared Ride: ${booking.bookedSeats} seat(s)'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Driver Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('Driver Name: John Doe'), // Replace with actual driver data
                      Text('Vehicle Number: ABC-1234'),
                      Text('Contact: +94 77 123 4567'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: controller.confirmBooking,
                child: Text('Confirm & Pay Now'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}