// controllers/taxi_booking_controller.dart
import 'package:airsolo/config.dart';
import 'package:airsolo/data/repositories/authentication/authentication_repository.dart';
import 'package:airsolo/features/taxi/screens/available_taxi.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/taxi_booking_model.dart';
import '../models/vehicle_model.dart';
import '../models/vehicle_type_model.dart';

class TaxiBookingController extends GetxController {
  final RxList<TaxiBooking> bookings = <TaxiBooking>[].obs;
  final RxList<Vehicle> availableVehicles = <Vehicle>[].obs;
  final RxList<VehicleType> vehicleTypes = <VehicleType>[].obs;
  final Rx<TaxiBooking?> currentBooking = Rx<TaxiBooking?>(null);
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


  // Fetch Vehicle Types
  Future<void> fetchVehicleTypes() async {
  try {
    isLoading(true);
    error(''); // Clear previous errors

    final token = await _getValidToken();
    if (token == null) throw Exception('Authentication required');

    final response = await http.get(
      Uri.parse('${Config.getVehicleType}'),
      headers: {'Authorization': 'Bearer $token'},
    );

    print('Response status: ${response.statusCode}'); // Debug
    print('Response body: ${response.body}'); // Debug

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      print('Parsed ${data.length} items'); // Debug
      
      vehicleTypes.assignAll(data.map((e) => VehicleType.fromJson(e)));
      print('First item: ${vehicleTypes.firstOrNull?.toJson()}'); // Debug
    } else {
      throw Exception('Failed to load vehicle types');
    }
  } catch (e) {
    error(e.toString());
    print('Error fetching vehicle types: $e'); // Debug
  } finally {
    isLoading(false);
  }
}

Future<void> createBooking({
  required String pickupLocation,
  required String dropLocation,
  required double pickupLat,
  required double pickupLng,
  required double dropLat,
  required double dropLng,
  required String vehicleTypeId,
  bool isShared = false,
  int seats = 1,
  DateTime? scheduledAt,
}) async {
  try {
    isLoading(true);
    error('');
    final token = await _getValidToken();
    if (token == null) throw Exception('Authentication required');

    final requestBody = {
      'pickupLocation': pickupLocation,
      'dropLocation': dropLocation,
      'pickupLat': pickupLat,
      'pickupLng': pickupLng,
      'dropLat': dropLat,
      'dropLng': dropLng,
      'vehicleTypeId': vehicleTypeId,
      'isShared': isShared,
      'seatsToShare': isShared ? seats : null,
      'scheduledAt': scheduledAt?.toIso8601String(),
    };

    print('Sending booking request: ${jsonEncode(requestBody)}');

    final response = await http.post(
      Uri.parse('${Config.getTaxiBooking}/create'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      
      // Debug print to see the actual response structure
      print('Parsed response data: $data');
      
      currentBooking.value = TaxiBooking.fromJson(data);
      Get.to(() => AvailableDriversScreen());
    } else {
      throw Exception('Failed to create booking: ${response.body}');
    }
  } catch (e, stackTrace) {
    print('Error creating booking: $e');
    print('Stack trace: $stackTrace');
    error(e.toString());
    Get.snackbar('Error', e.toString());
  } finally {
    isLoading(false);
  }
}

  Future<void> getAvailableDrivers({
    required String vehicleTypeId,
    required double lat,
    required double lng,
  }) async {
    try {
      isLoading(true);
      error('');
      final token = await _getValidToken();
      if (token == null) throw Exception('Authentication required');

      final response = await http.get(
        Uri.parse('${Config.baseUrl}/vehicles/available?vehicleTypeId=$vehicleTypeId&lat=$lat&lng=$lng'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        availableVehicles.assignAll(data.map((e) => Vehicle.fromJson(e)));
      } else {
        throw Exception('Failed to get available drivers');
      }
    } catch (e) {
      error(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> acceptBooking(String bookingId) async {
    try {
      isLoading(true);
      final token = await _getValidToken();
      if (token == null) throw Exception('Authentication required');

      final response = await http.post(
        Uri.parse('${Config.baseUrl}/bookings/$bookingId/accept'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        currentBooking.value = TaxiBooking.fromJson(data['booking']);
        Get.snackbar('Success', 'Booking accepted');
      } else {
        throw Exception('Failed to accept booking');
      }
    } catch (e) {
      error(e.toString());
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      isLoading(true);
      final token = await _getValidToken();
      if (token == null) throw Exception('Authentication required');

      final response = await http.put(
        Uri.parse('${Config.baseUrl}/bookings/$bookingId/status'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'status': status}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        currentBooking.value = TaxiBooking.fromJson(data['booking']);
        Get.snackbar('Success', 'Status updated');
      } else {
        throw Exception('Failed to update status');
      }
    } catch (e) {
      error(e.toString());
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> getUserBookings() async {
    try {
      isLoading(true);
      error('');
      final token = await _getValidToken();
      if (token == null) throw Exception('Authentication required');

      final response = await http.get(
        Uri.parse('${Config.baseUrl}/bookings/user/history'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        bookings.assignAll(data.map((e) => TaxiBooking.fromJson(e)));
      } else {
        throw Exception('Failed to get bookings');
      }
    } catch (e) {
      error(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> getDriverBookings() async {
    try {
      isLoading(true);
      error('');
      final token = await _getValidToken();
      if (token == null) throw Exception('Authentication required');

      final response = await http.get(
        Uri.parse('${Config.baseUrl}/bookings/driver/history'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        bookings.assignAll(data.map((e) => TaxiBooking.fromJson(e)));
      } else {
        throw Exception('Failed to get bookings');
      }
    } catch (e) {
      error(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> getVehicleTypes() async {
    try {
      isLoading(true);
      error('');
      final token = await _getValidToken();
      if (token == null) throw Exception('Authentication required');

      final response = await http.get(
        Uri.parse('${Config.baseUrl}/vehicle-types'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        vehicleTypes.assignAll(data.map((e) => VehicleType.fromJson(e)));
      } else {
        throw Exception('Failed to get vehicle types');
      }
    } catch (e) {
      error(e.toString());
    } finally {
      isLoading(false);
    }
  }
}