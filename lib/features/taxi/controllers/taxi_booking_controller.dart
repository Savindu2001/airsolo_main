// controllers/taxi_booking_controller.dart
import 'package:airsolo/config.dart';
import 'package:airsolo/data/repositories/authentication/authentication_repository.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/taxi_booking_model.dart';
import '../models/vehicle_model.dart';
import '../models/vehicle_type_model.dart';

class TaxiBookingController extends GetxController {
  final RxList<TaxiBooking> bookings = <TaxiBooking>[].obs;
  final nearbyBookings = <TaxiBooking>[].obs;
  final historyBookings = <TaxiBooking>[].obs;
  final availableDrivers = <Map<String, dynamic>>[].obs;
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
      Uri.parse(Config.getVehicleType),
      headers: {'Authorization': 'Bearer $token'},
    );

    // print('Response status: ${response.statusCode}'); // Debug
    // print('Response body: ${response.body}'); // Debug

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      //print('Parsed ${data.length} items'); // Debug
      
      vehicleTypes.assignAll(data.map((e) => VehicleType.fromJson(e)));
      //print('First item: ${vehicleTypes.firstOrNull?.toJson()}'); // Debug
    } else {
      throw Exception('Failed to load vehicle types');
    }
  } catch (e) {
    error(e.toString());
    //print('Error fetching vehicle types: $e'); // Debug
  } finally {
    isLoading(false);
  }
}

// Create Booking
Future<TaxiBooking?> createBooking({
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
    isLoading(true); // Show loading spinner
    error(''); // Clear any previous error

    // Get the valid token
    final token = await _getValidToken();
    if (token == null) throw Exception('Authentication required');

    // Prepare the request body for the API call
    final requestBody = {
      'pickupLocation': pickupLocation,
      'dropLocation': dropLocation,
      'pickupLat': pickupLat,
      'pickupLng': pickupLng,
      'dropLat': dropLat,
      'dropLng': dropLng,
      'vehicleTypeId': vehicleTypeId,
      'isShared': isShared,
      'seatsToBook': seats, 
      'scheduledAt': scheduledAt?.toIso8601String(),
    };

    //print('Sending booking request: ${jsonEncode(requestBody)}');

    final response = await http.post(
      Uri.parse('${Config.getTaxiBooking}/create'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    ).timeout(const Duration(seconds: 30));

    // Debugging logs
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    // Check if the response is successful
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      //print('Parsed response data: $data');
      // if (data['bookingId'] != null) {
      //   currentBooking.value = TaxiBooking.fromJson(data);
      //   return currentBooking.value;

       
      // } else {
      //   throw Exception('Booking creation failed, no booking ID returned');
      // }
      if (data['booking'] != null && data['booking']['id'] != null) {
        currentBooking.value = TaxiBooking.fromJson(data['booking']);
        return currentBooking.value;
      } else {
        throw Exception('Booking creation failed, no booking ID returned');
      }

    } else {
      throw Exception('Failed to create booking: ${response.body}');
    }
  } catch (e, stackTrace) {
    print('Error creating booking: $e');
    print('Stack trace: $stackTrace');
    error(e.toString()); // Set error message
    Get.snackbar('Error', e.toString()); // Show error to user
  } finally {
    isLoading(false); // Hide loading spinner
  }
  return null;
}


//cancel booking
Future<void> cancelBooking(String bookingId) async {
  try {
    isLoading(true);
    final token = await _getValidToken();
    if (token == null) throw Exception('Authentication required');

    // update status

    await updateBookingStatus(bookingId: bookingId, status: 'cancelled');

    
  } catch (e) {
    Get.snackbar('Error', 'Failed to cancel booking: ${e.toString()}');
  } finally {
    isLoading(false);
  }
}


// Get nearby bookings for drivers
Future<void> getNearByBookings() async {
  try {
    isLoading(true);
    error('');

    final token = await _getValidToken();
    if (token == null) throw Exception('Authentication required');

    final response = await http.get(
      Uri.parse('${Config.getTaxiBooking}/driver-nearby'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      
      // Clear existing bookings
      bookings.clear();
      
      // Add all new bookings
      for (var item in responseData) {
        try {
          bookings.add(TaxiBooking.fromJson(item));
        } catch (e) {
          print('Error parsing booking: $e');
        }
      }
      
      print('Successfully loaded ${bookings.length} bookings');
    } else {
      throw Exception('Failed to load bookings: ${response.statusCode}');
    }
  } catch (e) {
    error(e.toString());
    print('Error in getNearByBookings: $e');
  } finally {
    isLoading(false);
  }
}



// Get History of Booking
Future<void> getHistoryBookings() async {
  try {
    isLoading(true);
    error('');

    final token = await _getValidToken();
    if (token == null) throw Exception('Authentication required');

    final response = await http.get(
      Uri.parse('${Config.getTaxiBooking}/taxiBooking-history'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      historyBookings.assignAll(data.map((e) => TaxiBooking.fromJson(e)));
      print('Successfully loaded ${historyBookings.length} history bookings');
    } else {
      throw Exception('Failed to get history: ${response.body}');
    }
  } catch (e) {
    error(e.toString());
    print('Error fetching history: $e');
  } finally {
    isLoading(false);
  }
}



// Get all taxi bookings (for admin)
  Future<void> getAllTaxiBookings({String? status, bool? isShared}) async {
    try {
      isLoading(true);
      error('');

      final token = await _getValidToken();
      if (token == null) throw Exception('Authentication required');

      final queryParams = {
        if (status != null) 'status': status,
        if (isShared != null) 'isShared': isShared.toString(),
      };

      final uri = Uri.parse('${Config.getTaxiBooking}').replace(
        queryParameters: queryParams,
      );

      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        bookings.assignAll(data.map((e) => TaxiBooking.fromJson(e)));
      } else {
        throw Exception('Failed to get bookings: ${response.body}');
      }
    } catch (e) {
      error(e.toString());
    } finally {
      isLoading(false);
    }
  }



  // Join an existing shared booking
  Future<void> joinSharedBooking({
    required String bookingId,
    required int seatsToBook,
    double? pickupLat,
    double? pickupLng,
  }) async {
    try {
      isLoading(true);
      error('');

      final token = await _getValidToken();
      if (token == null) throw Exception('Authentication required');

      final response = await http.post(
        Uri.parse('${Config.baseUrl}/taxi-bookings/$bookingId/join'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'seatsToBook': seatsToBook,
          'pickupLat': pickupLat,
          'pickupLng': pickupLng,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        currentBooking.value = TaxiBooking.fromJson(data['booking']);
        Get.snackbar('Success', 'Joined shared booking successfully');
      } else {
        throw Exception('Failed to join booking: ${response.body}');
      }
    } catch (e) {
      error(e.toString());
      Get.snackbar('Error', 'Failed to join booking');
    } finally {
      isLoading(false);
    }
  }



// Update payment status (customer)
  Future<void> updatePaymentStatus({
    required String bookingId,
    required String paymentStatus,
  }) async {
    try {
      isLoading(true);
      error('');

      final token = await _getValidToken();
      if (token == null) throw Exception('Authentication required');

      final response = await http.put(
        Uri.parse('${Config.baseUrl}/taxi-bookings/$bookingId/payment'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'paymentStatus': paymentStatus}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        currentBooking.value = TaxiBooking.fromJson(data['booking']);
        Get.snackbar('Success', 'Payment status updated');
      } else {
        throw Exception('Failed to update payment status: ${response.body}');
      }
    } catch (e) {
      error(e.toString());
      Get.snackbar('Error', 'Failed to update payment status');
    } finally {
      isLoading(false);
    }
  }


  // Get available drivers 
  Future<void> getAvailableDrivers({
    required String vehicleTypeId,
    required double pickupLat,
    required double pickupLng,
    double maxDistance = 10,
  }) async {
    try {
      isLoading(true);
      error('');

      final token = await _getValidToken();
      if (token == null) throw Exception('Authentication required');

      final response = await http.post(
        Uri.parse('${Config.baseUrl}/taxi-bookings/available-drivers'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'vehicleTypeId': vehicleTypeId,
          'pickupLat': pickupLat,
          'pickupLng': pickupLng,
          'maxDistance': maxDistance,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        availableDrivers.assignAll(data.cast<Map<String, dynamic>>());
      } else {
        throw Exception('Failed to get available drivers: ${response.body}');
      }
    } catch (e) {
      error(e.toString());
    } finally {
      isLoading(false);
    }
  }



  // Get accepted booking details (driver & traveler)
  Future<void> getAcceptedBooking(String bookingId) async {
    try {
      isLoading(true);
      error('');

      final token = await _getValidToken();
      if (token == null) throw Exception('Authentication required');

      final response = await http.get(
        Uri.parse('${Config.getTaxiBooking}/driver-accept/$bookingId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      //update status

      await updateBookingStatus(bookingId: bookingId, status: 'driver_accepted');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        currentBooking.value = TaxiBooking.fromJson(data);
      } else {
        throw Exception('Failed to get booking: ${response.body}');
      }
    } catch (e) {
      error(e.toString());
    } finally {
      isLoading(false);
    }
  }





  // Update booking status
  Future<void> updateBookingStatus({
    required String bookingId,
    required String status,
  }) async {
    try {
      isLoading(true);
      error('');

      final token = await _getValidToken();
      if (token == null) throw Exception('Authentication required');

      final response = await http.put(
        Uri.parse('${Config.getTaxiBooking}/update-booking/$bookingId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'status': status}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        currentBooking.value = TaxiBooking.fromJson(data['booking']);
        
        // Update the bookings list if needed
        final index = bookings.indexWhere((b) => b.id == bookingId);
        if (index != -1) {
          bookings[index] = currentBooking.value!;
        }
        
        Get.snackbar('Success', 'Booking status updated');
      } else {
        throw Exception('Failed to update status: ${response.body}');
      }
    } catch (e) {
      error(e.toString());
      Get.snackbar('Error', 'Failed to update booking status');
    } finally {
      isLoading(false);
    }
  }





// Just checks status without modifying it
Future<String> checkBookingStatus(String bookingId) async {
  try {
    isLoading(true);
    final token = await _getValidToken();
    if (token == null) throw Exception('Authentication required');

    final response = await http.get(
      Uri.parse('${Config.getTaxiBooking}/status/$bookingId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['status'] ?? 'pending';
    } else {
      throw Exception('Failed to check status: ${response.body}');
    }
  } catch (e) {
    error(e.toString());
    return 'error';
  } finally {
    isLoading(false);
  }
}

// Gets full booking details
Future<void> getBookingDetails(String bookingId) async {
  try {
    isLoading(true);
    final token = await _getValidToken();
    if (token == null) throw Exception('Authentication required');

    final response = await http.get(
      Uri.parse('${Config.getTaxiBooking}/details/$bookingId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      currentBooking.value = TaxiBooking.fromJson(data);
    } else {
      throw Exception('Failed to get booking details: ${response.body}');
    }
  } catch (e) {
    error(e.toString());
  } finally {
    isLoading(false);
  }
}

}







