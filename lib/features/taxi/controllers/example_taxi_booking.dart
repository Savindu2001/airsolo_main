// // Create a booking
// TaxiBookingController.instance.createTaxiBooking(
//   pickupLocation: '123 Main St',
//   dropLocation: '456 Park Ave',
//   pickupLat: 37.7749,
//   pickupLng: -122.4194,
//   dropLat: 37.7749,
//   dropLng: -122.4194,
//   vehicleTypeId: 'vehicle_type_123',
//   isShared: false,
// );

// // Get nearby bookings (for driver)
// TaxiBookingController.instance.getNearByBookings();

// // Accept a booking
// TaxiBookingController.instance.acceptBooking('booking_id_123');

// // Update booking status
// TaxiBookingController.instance.updateBookingStatus(
//   bookingId: 'booking_id_123',
//   status: 'ride_started',
// );






// Obx(() {
//   if (TaxiBookingController.instance.isLoading.value) {
//     return CircularProgressIndicator();
//   }
  
//   if (TaxiBookingController.instance.error.value.isNotEmpty) {
//     return Text('Error: ${TaxiBookingController.instance.error.value}');
//   }
  
//   return ListView.builder(
//     itemCount: TaxiBookingController.instance.nearbyBookings.length,
//     itemBuilder: (context, index) {
//       final booking = TaxiBookingController.instance.nearbyBookings[index];
//       return BookingCard(booking: booking);
//     },
//   );
// })




// ------------------------------------ CODE -----------EXAMPLE------------------------------------


// // Access nearby bookings
// Obx(() {
//   return ListView.builder(
//     itemCount: TaxiBookingController.instance.nearbyBookings.length,
//     itemBuilder: (context, index) {
//       final booking = TaxiBookingController.instance.nearbyBookings[index];
//       return BookingCard(booking: booking);
//     },
//   );
// })

// // Access available drivers
// Obx(() {
//   return ListView.builder(
//     itemCount: TaxiBookingController.instance.availableDrivers.length,
//     itemBuilder: (context, index) {
//       final driver = TaxiBookingController.instance.availableDrivers[index];
//       return DriverCard(driver: driver);
//     },
//   );
// })





// ------------------------------------ CODE -----------EXAMPLE------------------------------------




// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:airsolo/features/taxi/models/taxi_booking_model.dart';
// import 'package:airsolo/utils/constants/config.dart';

// class TaxiBookingController extends GetxController {
//   static TaxiBookingController get instance => Get.find();

//   // Observable variables
//   final isLoading = false.obs;
//   final error = ''.obs;
//   final bookings = <TaxiBooking>[].obs;
//   final nearbyBookings = <TaxiBooking>[].obs;
//   final availableDrivers = <Map<String, dynamic>>[].obs;
//   final currentBooking = Rx<TaxiBooking?>(null);

//   // Helper method to get auth token
//   Future<String?> _getAuthToken() async {
//     // Implement your token retrieval logic here
//     // For example, from shared preferences or auth controller
//     return 'your_auth_token';
//   }

//   // Create a new taxi booking
//   Future<void> createTaxiBooking({
//     required String pickupLocation,
//     required String dropLocation,
//     required double pickupLat,
//     required double pickupLng,
//     required double dropLat,
//     required double dropLng,
//     required String vehicleTypeId,
//     bool isShared = false,
//     DateTime? scheduledAt,
//     int seatsToBook = 1,
//   }) async {
//     try {
//       isLoading(true);
//       error('');

//       final token = await _getAuthToken();
//       if (token == null) throw Exception('Authentication required');

//       final response = await http.post(
//         Uri.parse('${Config.apiUrl}/taxi-bookings'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'pickupLocation': pickupLocation,
//           'dropLocation': dropLocation,
//           'pickupLat': pickupLat,
//           'pickupLng': pickupLng,
//           'dropLat': dropLat,
//           'dropLng': dropLng,
//           'vehicleTypeId': vehicleTypeId,
//           'isShared': isShared,
//           'scheduledAt': scheduledAt?.toIso8601String(),
//           'seatsToBook': seatsToBook,
//         }),
//       );

//       if (response.statusCode == 201) {
//         final data = jsonDecode(response.body);
//         currentBooking.value = TaxiBooking.fromJson(data['booking']);
//         Get.snackbar('Success', 'Taxi booked successfully');
//       } else {
//         throw Exception('Failed to create booking: ${response.body}');
//       }
//     } catch (e) {
//       error(e.toString());
//       Get.snackbar('Error', 'Failed to create booking');
//     } finally {
//       isLoading(false);
//     }
//   }

//   // Get all taxi bookings (for admin)
//   Future<void> getAllTaxiBookings({String? status, bool? isShared}) async {
//     try {
//       isLoading(true);
//       error('');

//       final token = await _getAuthToken();
//       if (token == null) throw Exception('Authentication required');

//       final queryParams = {
//         if (status != null) 'status': status,
//         if (isShared != null) 'isShared': isShared.toString(),
//       };

//       final uri = Uri.parse('${Config.apiUrl}/taxi-bookings').replace(
//         queryParameters: queryParams,
//       );

//       final response = await http.get(
//         uri,
//         headers: {'Authorization': 'Bearer $token'},
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         bookings.assignAll(data.map((e) => TaxiBooking.fromJson(e)));
//       } else {
//         throw Exception('Failed to get bookings: ${response.body}');
//       }
//     } catch (e) {
//       error(e.toString());
//     } finally {
//       isLoading(false);
//     }
//   }

//   // Join an existing shared booking
//   Future<void> joinSharedBooking({
//     required String bookingId,
//     required int seatsToBook,
//     double? pickupLat,
//     double? pickupLng,
//   }) async {
//     try {
//       isLoading(true);
//       error('');

//       final token = await _getAuthToken();
//       if (token == null) throw Exception('Authentication required');

//       final response = await http.post(
//         Uri.parse('${Config.apiUrl}/taxi-bookings/$bookingId/join'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'seatsToBook': seatsToBook,
//           'pickupLat': pickupLat,
//           'pickupLng': pickupLng,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         currentBooking.value = TaxiBooking.fromJson(data['booking']);
//         Get.snackbar('Success', 'Joined shared booking successfully');
//       } else {
//         throw Exception('Failed to join booking: ${response.body}');
//       }
//     } catch (e) {
//       error(e.toString());
//       Get.snackbar('Error', 'Failed to join booking');
//     } finally {
//       isLoading(false);
//     }
//   }

//   // Update payment status
//   Future<void> updatePaymentStatus({
//     required String bookingId,
//     required String paymentStatus,
//   }) async {
//     try {
//       isLoading(true);
//       error('');

//       final token = await _getAuthToken();
//       if (token == null) throw Exception('Authentication required');

//       final response = await http.put(
//         Uri.parse('${Config.apiUrl}/taxi-bookings/$bookingId/payment'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({'paymentStatus': paymentStatus}),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         currentBooking.value = TaxiBooking.fromJson(data['booking']);
//         Get.snackbar('Success', 'Payment status updated');
//       } else {
//         throw Exception('Failed to update payment status: ${response.body}');
//       }
//     } catch (e) {
//       error(e.toString());
//       Get.snackbar('Error', 'Failed to update payment status');
//     } finally {
//       isLoading(false);
//     }
//   }

//   // Get available drivers
//   Future<void> getAvailableDrivers({
//     required String vehicleTypeId,
//     required double pickupLat,
//     required double pickupLng,
//     double maxDistance = 10,
//   }) async {
//     try {
//       isLoading(true);
//       error('');

//       final token = await _getAuthToken();
//       if (token == null) throw Exception('Authentication required');

//       final response = await http.post(
//         Uri.parse('${Config.apiUrl}/taxi-bookings/available-drivers'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'vehicleTypeId': vehicleTypeId,
//           'pickupLat': pickupLat,
//           'pickupLng': pickupLng,
//           'maxDistance': maxDistance,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         availableDrivers.assignAll(data.cast<Map<String, dynamic>>());
//       } else {
//         throw Exception('Failed to get available drivers: ${response.body}');
//       }
//     } catch (e) {
//       error(e.toString());
//     } finally {
//       isLoading(false);
//     }
//   }

//   // Get nearby bookings for driver
//   Future<void> getNearByBookings() async {
//     try {
//       isLoading(true);
//       error('');

//       final token = await _getAuthToken();
//       if (token == null) throw Exception('Authentication required');

//       final response = await http.get(
//         Uri.parse('${Config.apiUrl}/taxi-bookings/nearby'),
//         headers: {'Authorization': 'Bearer $token'},
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         nearbyBookings.assignAll(data.map((e) => TaxiBooking.fromJson(e)));
//       } else {
//         throw Exception('Failed to get nearby bookings: ${response.body}');
//       }
//     } catch (e) {
//       error(e.toString());
//     } finally {
//       isLoading(false);
//     }
//   }

//   // Get accepted booking details
//   Future<void> getAcceptedBooking(String bookingId) async {
//     try {
//       isLoading(true);
//       error('');

//       final token = await _getAuthToken();
//       if (token == null) throw Exception('Authentication required');

//       final response = await http.get(
//         Uri.parse('${Config.apiUrl}/taxi-bookings/$bookingId/accepted'),
//         headers: {'Authorization': 'Bearer $token'},
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         currentBooking.value = TaxiBooking.fromJson(data);
//       } else {
//         throw Exception('Failed to get booking: ${response.body}');
//       }
//     } catch (e) {
//       error(e.toString());
//     } finally {
//       isLoading(false);
//     }
//   }

//   // Update booking status
//   Future<void> updateBookingStatus({
//     required String bookingId,
//     required String status,
//   }) async {
//     try {
//       isLoading(true);
//       error('');

//       final token = await _getAuthToken();
//       if (token == null) throw Exception('Authentication required');

//       final response = await http.put(
//         Uri.parse('${Config.apiUrl}/taxi-bookings/$bookingId/status'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({'status': status}),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         currentBooking.value = TaxiBooking.fromJson(data['booking']);
        
//         // Update the bookings list if needed
//         final index = bookings.indexWhere((b) => b.id == bookingId);
//         if (index != -1) {
//           bookings[index] = currentBooking.value!;
//         }
        
//         Get.snackbar('Success', 'Booking status updated');
//       } else {
//         throw Exception('Failed to update status: ${response.body}');
//       }
//     } catch (e) {
//       error(e.toString());
//       Get.snackbar('Error', 'Failed to update booking status');
//     } finally {
//       isLoading(false);
//     }
//   }

//   // Accept a booking (specific method for driver)
//   Future<void> acceptBooking(String bookingId) async {
//     try {
//       isLoading(true);
//       error('');

//       final token = await _getAuthToken();
//       if (token == null) throw Exception('Authentication required');

//       final response = await http.post(
//         Uri.parse('${Config.apiUrl}/taxi-bookings/$bookingId/accept'),
//         headers: {'Authorization': 'Bearer $token'},
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         currentBooking.value = TaxiBooking.fromJson(data['booking']);
        
//         // Remove from nearby bookings if it exists there
//         nearbyBookings.removeWhere((b) => b.id == bookingId);
        
//         Get.snackbar('Success', 'Booking accepted successfully');
//       } else {
//         throw Exception('Failed to accept booking: ${response.body}');
//       }
//     } catch (e) {
//       error(e.toString());
//       Get.snackbar('Error', 'Failed to accept booking');
//     } finally {
//       isLoading(false);
//     }
//   }
// }