import 'package:airsolo/features/taxi/screens/booking_confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:airsolo/features/taxi/controllers/taxi_booking_controller.dart';

class FetchingDriverScreen extends StatelessWidget {
  final TaxiBookingController controller = Get.find();

   FetchingDriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetching Driver'),
        centerTitle: true,
      ),
      body: Obx(() {
        // Show loading while searching for driver
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Finding nearest available driver...')
              ],
            ),
          );
        }

        // If no vehicles are found, show a message
        if (controller.availableVehicles.isEmpty) {
          return const Center(child: Text('No drivers available in your area.'));
        }

        // If a driver is found, show booking confirmation
        return ListView.builder(
          itemCount: controller.availableVehicles.length,
          itemBuilder: (context, index) {
            final vehicle = controller.availableVehicles[index];

            return ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(vehicle.driverId ?? 'Driver Not Available'),
              subtitle: Text('${vehicle.model} - ${vehicle.vehicleNumber}'),
              trailing: ElevatedButton(
                child: const Text('Select'),
                onPressed: () async {
                  // Accept the booking and send a notification to the driver
                  // await controller.acceptBooking(
                  //   controller.currentBooking.value?.id ?? '',
                  // );
                  // After accepting, notify the driver using FCM
                  controller;
                  
                  // Navigate to the confirmation page
                  Get.to(() => BookingConfirmationScreen(
                    bookingId: controller.currentBooking.value?.id ?? '',
                    driverName: vehicle.driverId ?? 'Unknown',
                    vehicleModel: vehicle.model,
                    vehicleNumber: vehicle.vehicleNumber,
                  ));
                },
              ),
            );
          },
        );
      }),
    );
  }
}
