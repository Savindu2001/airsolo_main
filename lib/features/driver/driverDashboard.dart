import 'package:airsolo/features/authentication/controllers/login_controller.dart';
import 'package:airsolo/features/taxi/controllers/taxi_booking_controller.dart';
import 'package:airsolo/features/taxi/controllers/vehicle_controller.dart';
import 'package:airsolo/features/taxi/models/taxi_booking_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class DriverHomeScreen extends StatelessWidget {
  final TaxiBookingController bookingController = Get.put(TaxiBookingController());
  final VehicleController vehicleController = Get.put(VehicleController());
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Dashboard'),
        actions: [
          Obx(() => Switch(
            value: vehicleController.currentVehicle.value?.isAvailable ?? false,
            onChanged: (value) => vehicleController.toggleAvailability(),
            activeColor: Colors.green,
          )),
          IconButton(
            onPressed: () => loginController.logout(), 
            icon: Icon(Iconsax.logout)
            )

        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: 'Pending'),
                Tab(text: 'Active'),
                Tab(text: 'History'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildPendingBookings(),
                  _buildActiveBookings(),
                  _buildBookingHistory(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingBookings() {
    return Obx(() {
      if (bookingController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      
      final pendingBookings = bookingController.bookings
          .where((b) => b.status == 'pending')
          .toList();
      
      if (pendingBookings.isEmpty) {
        return Center(child: Text('No pending bookings'));
      }
      
      return ListView.builder(
        itemCount: pendingBookings.length,
        itemBuilder: (context, index) {
          final booking = pendingBookings[index];
          return _buildBookingCard(booking);
        },
      );
    });
  }

  Widget _buildActiveBookings() {
    return Obx(() {
      if (bookingController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      
      final activeBookings = bookingController.bookings
          .where((b) => ['driver_accepted', 'driver_arrived', 'ride_started'].contains(b.status))
          .toList();
      
      if (activeBookings.isEmpty) {
        return Center(child: Text('No active bookings'));
      }
      
      return ListView.builder(
        itemCount: activeBookings.length,
        itemBuilder: (context, index) {
          final booking = activeBookings[index];
          return _buildBookingCard(booking);
        },
      );
    });
  }

  Widget _buildBookingHistory() {
    return Obx(() {
      if (bookingController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      
      final completedBookings = bookingController.bookings
          .where((b) => ['ride_completed', 'cancelled'].contains(b.status))
          .toList();
      
      if (completedBookings.isEmpty) {
        return Center(child: Text('No booking history'));
      }
      
      return ListView.builder(
        itemCount: completedBookings.length,
        itemBuilder: (context, index) {
          final booking = completedBookings[index];
          return _buildBookingCard(booking);
        },
      );
    });
  }

  Widget _buildBookingCard(TaxiBooking booking) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Booking #${booking.id.substring(0, 8)}', 
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('From: ${booking.pickupLocation}'),
            Text('To: ${booking.dropLocation}'),
            Text('Status: ${booking.status.replaceAll('_', ' ')}'),
            Text('Price: \$${booking.totalPrice.toStringAsFixed(2)}'),
            SizedBox(height: 16),
            if (booking.status == 'pending')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => bookingController.acceptBooking(booking.id),
                    child: Text('Accept'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                  ElevatedButton(
                    onPressed: () => bookingController.updateBookingStatus(booking.id, 'cancelled'),
                    child: Text('Reject'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),
            if (booking.status == 'driver_accepted')
              ElevatedButton(
                onPressed: () => bookingController.updateBookingStatus(booking.id, 'driver_arrived'),
                child: Text('Mark as Arrived'),
              ),
            if (booking.status == 'driver_arrived')
              ElevatedButton(
                onPressed: () => bookingController.updateBookingStatus(booking.id, 'ride_started'),
                child: Text('Start Ride'),
              ),
            if (booking.status == 'ride_started')
              ElevatedButton(
                onPressed: () => bookingController.updateBookingStatus(booking.id, 'ride_completed'),
                child: Text('Complete Ride'),
              ),
          ],
        ),
      ),
    );
  }
}