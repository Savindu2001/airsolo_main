// controllers/vehicle_controller.dart
import 'package:airsolo/config.dart';
import 'package:airsolo/data/repositories/authentication/authentication_repository.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/vehicle_model.dart';

class VehicleController extends GetxController {
  final Rx<Vehicle?> currentVehicle = Rx<Vehicle?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  // Get valid token 
  Future<String?> _getValidToken() async {
    try {
      Get.find<AuthenticationRepository>();
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('jwtToken');
    } catch (e) {
      error('Failed to get authentication token');
      return null;
    }
  }

  Future<void> registerVehicle({
    required String vehicleNumber,
    required String make,
    required String model,
    required int year,
    required String color,
    required int numberOfSeats,
    required String vehicleTypeId,
  }) async {
    try {
      isLoading(true);
      error('');
      final token = await _getValidToken();
      if (token == null) throw Exception('Authentication required');

      final response = await http.post(
        Uri.parse('${Config.baseUrl}/vehicles'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'vehicleNumber': vehicleNumber,
          'make': make,
          'model': model,
          'year': year,
          'color': color,
          'numberOfSeats': numberOfSeats,
          'vehicleTypeId': vehicleTypeId,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        currentVehicle.value = Vehicle.fromJson(data['vehicle']);
        Get.snackbar('Success', 'Vehicle registered successfully');
      } else {
        throw Exception('Failed to register vehicle');
      }
    } catch (e) {
      error(e.toString());
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateVehicle({
    required String vehicleId,
    required String make,
    required String model,
    required int year,
    required String color,
    required int numberOfSeats,
    required String vehicleTypeId,
  }) async {
    try {
      isLoading(true);
      error('');
      final token = await _getValidToken();
      if (token == null) throw Exception('Authentication required');

      final response = await http.put(
        Uri.parse('${Config.baseUrl}/vehicles/$vehicleId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'make': make,
          'model': model,
          'year': year,
          'color': color,
          'numberOfSeats': numberOfSeats,
          'vehicleTypeId': vehicleTypeId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        currentVehicle.value = Vehicle.fromJson(data['vehicle']);
        Get.snackbar('Success', 'Vehicle updated successfully');
      } else {
        throw Exception('Failed to update vehicle');
      }
    } catch (e) {
      error(e.toString());
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> getVehicle(String vehicleId) async {
    try {
      isLoading(true);
      error('');
      final token = await _getValidToken();
      if (token == null) throw Exception('Authentication required');

      final response = await http.get(
        Uri.parse('${Config.baseUrl}/vehicles/$vehicleId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        currentVehicle.value = Vehicle.fromJson(data);
      } else {
        throw Exception('Failed to get vehicle');
      }
    } catch (e) {
      error(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> toggleAvailability() async {
    try {
      isLoading(true);
      final token = await _getValidToken();
      if (token == null) throw Exception('Authentication required');

      final response = await http.put(
        Uri.parse('${Config.baseUrl}/vehicles/${currentVehicle.value?.id}/availability'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        currentVehicle.value = Vehicle.fromJson(data);
        Get.snackbar('Success', 'Availability updated');
      } else {
        throw Exception('Failed to toggle availability');
      }
    } catch (e) {
      error(e.toString());
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateLocation(double lat, double lng) async {
    try {
      final token = await _getValidToken();
      if (token == null) return;

      await http.put(
        Uri.parse('${Config.baseUrl}/vehicles/${currentVehicle.value?.id}/location'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'lat': lat, 'lng': lng}),
      );
    } catch (e) {
      print('Error updating location: $e');
    }
  }
}