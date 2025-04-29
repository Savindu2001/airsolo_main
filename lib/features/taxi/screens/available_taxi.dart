import 'package:airsolo/features/taxi/screens/booking_confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:airsolo/features/taxi/controllers/taxi_booking_controller.dart';

class AvailableDriversScreen extends StatelessWidget {
  final TaxiBookingController controller = Get.find();

   AvailableDriversScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Drivers'),
      ),
      body: Obx(() {
        // Check if the loading flag is true, show loading indicator
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // If no drivers are available, display a message
        if (controller.availableVehicles.isEmpty) {
          return const Center(child: Text('No available drivers found.'));
        }

        // List of available drivers
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
                  // Trigger the accept booking method with the current booking ID and selected driver
                  // await controller.acceptBooking(
                  //   controller.currentBooking.value?.id ?? '',
                  // );

                  // Navigate to the confirmation screen after selecting a driver
                  Get.to(() => BookingConfirmationScreen(
                    bookingId: controller.currentBooking.value?.id ?? '',
                    driverName: vehicle.driverId ?? 'Unknown Driver',
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
