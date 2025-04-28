// screens/driver/available_drivers_screen.dart
import 'package:airsolo/features/taxi/controllers/taxi_booking_controller.dart';
import 'package:airsolo/features/taxi/models/vehicle_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AvailableDriversScreen extends StatelessWidget {
  final TaxiBookingController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Available Drivers')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        
        if (controller.availableVehicles.isEmpty) {
          return Center(child: Text('No available drivers found'));
        }

        return ListView.builder(
          itemCount: controller.availableVehicles.length,
          itemBuilder: (context, index) {
            final vehicle = controller.availableVehicles[index];
            return ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text(vehicle.driverId?? 'Driver'),
              subtitle: Text('${vehicle.model} - ${vehicle.vehicleNumber}'),
              trailing: ElevatedButton(
                child: Text('Select'),
                onPressed: () => controller.acceptBooking(controller.currentBooking.value?.id ?? ''),
              ),
            );
          },
        );
      }),
    );
  }
}

