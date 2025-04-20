import 'dart:convert';
import 'package:airsolo/config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:airsolo/features/hostel/models/booking_model.dart';
import 'package:airsolo/utils/constants/api_constants.dart';

class BookingController extends GetxController {
  final RxList<HostelBooking> bookings = <HostelBooking>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  Future<HostelBooking?> createPendingBooking({
    required String hostelId,
    required String roomId,
    required String bedType,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required int numGuests,
    String? specialRequests,
  }) async {
    try {
      isLoading(true);
      error('');

      final response = await http.post(
        Uri.parse(Config.bookingEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'hostelId': hostelId,
          'roomId': roomId,
          'bedType': bedType,
          'checkInDate': checkInDate.toIso8601String(),
          'checkOutDate': checkOutDate.toIso8601String(),
          'numGuests': numGuests,
          'specialRequests': specialRequests,
          'status': 'pending',
        }),
      );

      if (response.statusCode == 201) {
        final booking = HostelBooking.fromJson(jsonDecode(response.body));
        bookings.add(booking);
        return booking;
      } else {
        throw Exception('Failed to create booking: ${response.body}');
      }
    } catch (e) {
      error(e.toString());
      return null;
    } finally {
      isLoading(false);
    }
  }

  Future<bool> confirmBooking(String bookingId) async {
    try {
      isLoading(true);
      error('');

      final response = await http.post(
        Uri.parse('${Config.bookingConfirm}$bookingId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Update the booking status in local list
        final index = bookings.indexWhere((b) => b.id == bookingId);
        if (index != -1) {
          bookings[index] = bookings[index].copyWith(status: 'confirmed');
        }
        //await fetchUserBookings(userId);
        return true;
      } else {
        throw Exception('Failed to confirm booking: ${response.body}');
      }
    } catch (e) {
      error(e.toString());
      return false;
    } finally {
      isLoading(false);
    }
  }

  Future<bool> notifyPaymentSuccess({
    required String bookingId,
    required String paymentId,
    required double amount,
  }) async {
    try {
      isLoading(true);
      error('');

      final response = await http.post(
        Uri.parse(Config.payhere),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'bookingId': bookingId,
          'paymentId': paymentId,
          'amount': amount,
          'status': 'success',
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Payment notification failed: ${response.body}');
      }
    } catch (e) {
      error(e.toString());
      return false;
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchUserBookings(String userId) async {
    try {
      isLoading(true);
      error('');

      final response = await http.get(
        Uri.parse('${Config.bookingEndpoint}/userBookings/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        bookings.assignAll(data.map((json) => HostelBooking.fromJson(json)));
      } else {
        throw Exception('Failed to fetch bookings: ${response.body}');
      }
    } catch (e) {
      error(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<bool> checkRoomAvailability({
    required String roomId,
    required DateTime checkInDate,
    required DateTime checkOutDate,
  }) async {
    try {
      isLoading(true);
      error('');

      final response = await http.post(
        Uri.parse('${Config.roomsEndpoint}/availability'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'roomId': roomId,
          'checkInDate': checkInDate.toIso8601String(),
          'checkOutDate': checkOutDate.toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['available'] ?? false;
      } else {
        throw Exception('Availability check failed: ${response.body}');
      }
    } catch (e) {
      error(e.toString());
      return false;
    } finally {
      isLoading(false);
    }
  }
}