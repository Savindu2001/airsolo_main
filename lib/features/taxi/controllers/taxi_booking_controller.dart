import 'package:airsolo/config.dart';
import 'package:airsolo/data/repositories/authentication/authentication_repository.dart';
import 'package:airsolo/features/taxi/screens/booking_confirmation_screen.dart';
import 'package:airsolo/features/taxi/screens/boooking_sucess_screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/taxi_booking_model.dart';
import '../models/vehicle_type_model.dart';

class TaxiBookingController extends GetxController {
  final Rx<BookingRequest?> bookingRequest = Rx<BookingRequest?>(null);
  final Rx<TaxiBooking?> currentBooking = Rx<TaxiBooking?>(null);
  final RxList<VehicleType> vehicleTypes = <VehicleType>[].obs;
  final RxList<TaxiBooking> sharedBookings = <TaxiBooking>[].obs;
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


  // --------- ###################################### --------- //

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


  // Fetch Driver Details









  // create bookings
  Future<void> createBooking(BookingRequest request, bool isShared) async {
    try {
      isLoading(true);
      final token = await _getValidToken();
      if (token == null) throw Exception('Authentication required');

      final response = await http.post(
        Uri.parse('${Config.baseUrl}/taxi-booking'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'pickupLocation': request.pickupLocation,
          'dropLocation': request.dropLocation,
          'pickupLat': request.pickupLat,
          'pickupLng': request.pickupLng,
          'dropLat': request.dropLat,
          'dropLng': request.dropLng,
          'date': request.date.toIso8601String(),
          'time': '${request.time.hour}:${request.time.minute}',
          'vehicleTypeId': request.vehicleTypeId,
          'isShared': isShared,
          'status': 'pending',
        }),
      );

      if (response.statusCode == 201) {
        currentBooking.value = TaxiBooking.fromJson(jsonDecode(response.body));
        Get.to(() => BookingConfirmationScreen());
      } else {
        throw Exception('Failed to create booking');
      }
    } catch (e) {
      error(e.toString());
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }



 // Fetch Shared Booking
  Future<void> fetchSharedBookings(BookingRequest request) async {
    try {
      isLoading(true);
      final token = await _getValidToken();
      if (token == null) throw Exception('Authentication required');

      final response = await http.get(
        Uri.parse('${Config.baseUrl}/taxi-booking/shared?'
            'date=${request.date.toIso8601String()}'
            '&pickupLat=${request.pickupLat}'
            '&pickupLng=${request.pickupLng}'
            '&dropLat=${request.dropLat}'
            '&dropLng=${request.dropLng}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        sharedBookings.assignAll((jsonDecode(response.body)['sharedBookings'] as List)
            .map((e) => TaxiBooking.fromJson(e)));
      } else {
        throw Exception('Failed to load shared bookings');
      }
    } catch (e) {
      error(e.toString());
    } finally {
      isLoading(false);
    }
  }




// after done payments in payment controller and call this
  Future<void> confirmBooking() async {
    try {
      isLoading(true);
      final token = await _getValidToken();
      if (token == null) throw Exception('Authentication required');

      final response = await http.put(
        Uri.parse('${Config.baseUrl}/taxi-booking/${currentBooking.value?.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'status': 'confirmed',
        }),
      );

      if (response.statusCode == 200) {
        Get.offAll(() => BookingSuccessScreen());
      } else {
        throw Exception('Failed to confirm booking');
      }
    } catch (e) {
      error(e.toString());
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
  
}