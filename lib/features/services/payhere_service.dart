import 'package:airsolo/features/hostel/screens/payment_sucees.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';

class PayHereService {
  static Future<void> initiatePayment({
    required double amount,
    required String bookingId,
    required String customerName,
    required String customerEmail,
  }) async {
    try {
      // Split name into first and last
      final nameParts = customerName.split(' ');
      final firstName = nameParts.first;
      final lastName = nameParts.length > 1 ? nameParts.last : '';

      final params = {
        "sandbox": true, 
        "merchant_id": "1226795",
        "merchant_secret": "MzM0MDE2MTU1MjkMjM3OTEwNTQ1NzM5NzM2OTczMzc1MTI4MjQzMzM0MDE2MTU1Mjk=",
        "notify_url": "https://your-api-endpoint.com/payments/notify",
        "order_id": bookingId,
        "items": "Room Booking",
        "amount": amount.toStringAsFixed(2),
        "currency": "LKR",
        "first_name": firstName,
        "last_name": lastName,
        "email": customerEmail,
        "phone": "0761794522", // Consider using user's actual phone if available
        "address": "No. 671/2, Tank Road road",
        "city": "Dambulla",
        "country": "Sri Lanka",
        "custom_1": bookingId,
      };

      print('Initiating PayHere payment with params: $params');

      // Start payment
      PayHere.startPayment(
        params,
        (paymentId) {
          // Payment success
          print("Payment Success: $paymentId");
          Get.offAll(() => PaymentSuccessScreen(
            //bookingId: bookingId,
          ));
        },
        (error) {
          // Payment error
          print("Payment Error: $error");
          Get.snackbar(
            'Payment Failed',
            error.toString(),
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        () {
          // Payment cancelled
          print("Payment Cancelled");
          Get.snackbar(
            'Payment Cancelled',
            'You cancelled the payment',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      );

    } catch (e, stack) {
      print('PayHere SDK Error: $e');
      print('Stack trace: $stack');
      rethrow;
    }
  }
}