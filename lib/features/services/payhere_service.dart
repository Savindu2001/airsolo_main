
import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';

class PayHereService {
  static Future<void> initiatePayment({
    required double amount,
    required String bookingId,
    required String customerName,
    required String customerEmail,
  }) async {
    final params = {
      "sandbox": true, 
      "merchant_id": "1226795",
      "merchant_secret": "MzM0MDE2MTU1MjkMjM3OTEwNTQ1NzM5NzM2OTczMzc1MTI4MjQzMzM0MDE2MTU1Mjk=",
      "notify_url": "http://127.0.0.1:3000/api/bookings/payment/:id",
      "order_id": bookingId,
      "items": "Room Booking",
      "amount": amount.toStringAsFixed(2),
      "currency": "LKR",
      "first_name": customerName.split(" ").first,
      "last_name": customerName.split(" ").last,
      "email": customerEmail,
      "phone": "0761794522",
      "address": "No. 671/2, Tank Road road",
      "city": "Dambulla",
      "country": "Sri Lanka",
      "delivery_address": "No. 671/2, Tank Road road, Dambulla",
      "delivery_city": "Dambulla",
      "delivery_country": "Sri Lanka",
      "custom_1": bookingId,
    };

    try {
      PayHere.startPayment(params, (paymentId) {
        // Payment success callback
        print("Payment Success: $paymentId");
      }, (error) {
        // Payment error callback
        print("Payment Error: $error");
      }, () {
        // Payment canceled callback
        print("Payment Cancelled");
      });
    } catch (e) {
      print("PayHere SDK Error: $e");
    }
  }
}