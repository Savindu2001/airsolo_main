// // payment_screen.dart
// import 'package:airsolo/features/taxi/screens/booking_confirmation_screen.dart';
// import 'package:get/get_core/src/get_main.dart';

// class PaymentScreen extends StatelessWidget {
//   final String bookingId;
//   final TaxiBookingController bookingController = Get.find();

//   PaymentScreen({required this.bookingId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Complete Payment')),
//       body: FutureBuilder(
//         future: bookingController.initiatePayment(bookingId),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
          
//           if (snapshot.hasError) {
//             return Center(child: Text('Payment failed: ${snapshot.error}'));
//           }
          
//           final paymentData = snapshot.data as Map<String, dynamic>;
          
//           return Column(
//             children: [
//               // Display booking summary
//               BookingSummaryCard(booking: paymentData['booking']),
              
//               // Payment form
//               StripePaymentForm(
//                 clientSecret: paymentData['clientSecret'],
//                 amount: paymentData['amount'],
//                 currency: paymentData['currency'],
//                 onSuccess: () {
//                   bookingController.updateBookingStatus(bookingId, 'payment_completed');
//                   Get.offAll(BookingConfirmationScreen(bookingId: bookingId));
//                 },
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }