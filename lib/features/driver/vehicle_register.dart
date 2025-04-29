// screens/driver/vehicle_registration_screen.dart
import 'package:airsolo/features/taxi/controllers/taxi_booking_controller.dart';
import 'package:airsolo/features/taxi/controllers/vehicle_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehicleRegistrationScreen extends StatelessWidget {
  final VehicleController controller = Get.put(VehicleController());
  final TaxiBookingController bookingController = Get.find();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController vehicleNumberController = TextEditingController();
  final TextEditingController makeController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController seatsController = TextEditingController();
  String? selectedVehicleTypeId;

  VehicleRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Vehicle'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: vehicleNumberController,
                decoration: const InputDecoration(labelText: 'Vehicle Number'),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              TextFormField(
                controller: makeController,
                decoration: const InputDecoration(labelText: 'Make'),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              TextFormField(
                controller: modelController,
                decoration: const InputDecoration(labelText: 'Model'),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              TextFormField(
                controller: yearController,
                decoration: const InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              TextFormField(
                controller: colorController,
                decoration: const InputDecoration(labelText: 'Color'),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              TextFormField(
                controller: seatsController,
                decoration: const InputDecoration(labelText: 'Number of Seats'),
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Obx(() {
                if (bookingController.vehicleTypes.isEmpty) {
                  return const CircularProgressIndicator();
                }
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Vehicle Type'),
                  items: bookingController.vehicleTypes.map((type) {
                    return DropdownMenuItem(
                      value: type.id,
                      child: Text(type.type),
                    );
                  }).toList(),
                  onChanged: (value) => selectedVehicleTypeId = value,
                  validator: (value) => value == null ? 'Required' : null,
                );
              }),
              const SizedBox(height: 24),
              Obx(() {
                if (controller.isLoading.value) {
                  return const CircularProgressIndicator();
                }
                return ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      controller.registerVehicle(
                        vehicleNumber: vehicleNumberController.text,
                        make: makeController.text,
                        model: modelController.text,
                        year: int.parse(yearController.text),
                        color: colorController.text,
                        numberOfSeats: int.parse(seatsController.text),
                        vehicleTypeId: selectedVehicleTypeId!,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Register Vehicle'),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}