// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:airsolo/features/taxi/controllers/taxi_booking_controller.dart';
// import 'package:airsolo/features/taxi/models/taxi_booking_model.dart';
// import 'package:airsolo/features/taxi/screens/ongoing_booking_screen.dart';
// import 'package:airsolo/utils/constants/colors.dart';
// import 'package:airsolo/utils/constants/sizes.dart';
// import 'package:intl/intl.dart';

// class JoinBookingConfirmationScreen extends StatelessWidget {
//   final TaxiBooking booking;
//   final String pickupLocation;
//   final String dropLocation;
//   final double pickupLat;
//   final double pickupLng;
//   final int seats;

//   const JoinBookingConfirmationScreen({
//     required this.booking,
//     required this.pickupLocation,
//     required this.dropLocation,
//     required this.pickupLat,
//     required this.pickupLng,
//     required this.seats,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final pricePerSeat = booking.totalPrice / booking.assignedVehicle!.seats;
//     final totalPrice = pricePerSeat * seats;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Confirm Join Ride'),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(ASizes.defaultSpace),
//         child: Column(
//           children: [
//             Card(
//               elevation: 4,
//               child: Padding(
//                 padding: EdgeInsets.all(ASizes.defaultSpace),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Center(
//                       child: Text(
//                         'Ride Summary',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: AColors.primary,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: ASizes.spaceBtwSections),
//                     // _buildDetailRow('Vehicle Type', booking.assignedVehicle?.type ?? 'Standard'),
//                     // _buildDetailRow('Driver', booking.assignedVehicle?.driverName ?? 'Not assigned'),
//                     _buildDetailRow('Vehicle Number', booking.assignedVehicle?.vehicleNumber ?? 'Not available'),
//                     Divider(height: ASizes.spaceBtwSections),
//                     _buildDetailRow('Pickup Location', pickupLocation),
//                     _buildDetailRow('Drop Location', dropLocation),
//                     _buildDetailRow('Scheduled Time', 
//                       DateFormat('MMM dd, hh:mm a').format(booking.scheduledAt ?? booking.bookingDateTime)),
//                     Divider(height: ASizes.spaceBtwSections),
//                     _buildDetailRow('Seats Booking', seats.toString()),
//                     _buildDetailRow('Price per seat', 'LKR ${pricePerSeat.toStringAsFixed(2)}'),
//                     Divider(height: ASizes.spaceBtwSections),
//                     _buildDetailRow(
//                       'Total Amount',
//                       'LKR ${totalPrice.toStringAsFixed(2)}',
//                       isTotal: true,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: ASizes.spaceBtwSections),
//             ElevatedButton(
//               onPressed: () => _confirmJoinRide(),
//               child: Text('Confirm & Pay Now'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: Size(double.infinity, 50),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: ASizes.spaceBtwItems / 2),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//               fontSize: isTotal ? 16 : 14,
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//               fontSize: isTotal ? 18 : 14,
//               color: isTotal ? AColors.primary : null,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _confirmJoinRide() async {
//     final controller = Get.find<TaxiBookingController>();
//     try {
//       final updatedBooking = await controller.joinSharedBooking(
//         bookingId: booking.id,
//         seatsToBook: seats,
//         pickupLat: pickupLat,
//         pickupLng: pickupLng,
//       );

//       // if (updatedBooking != null) {
//       //   Get.off(() => OngoingBookingScreen(booking: updatedBooking));
//       // } else {
//       //   Get.snackbar('Error', 'Failed to join ride');
//       // }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to join ride: ${e.toString()}');
//     }
//   }
// }