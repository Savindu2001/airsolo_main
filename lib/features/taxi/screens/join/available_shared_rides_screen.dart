// import 'package:airsolo/features/taxi/controllers/vehicle_controller.dart';
// import 'package:airsolo/features/taxi/screens/join/join_booking_confirmation_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:airsolo/features/taxi/controllers/taxi_booking_controller.dart';
// import 'package:airsolo/features/taxi/models/taxi_booking_model.dart';
// import 'package:airsolo/utils/constants/colors.dart';
// import 'package:airsolo/utils/constants/sizes.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:intl/intl.dart';

// class AvailableSharedRidesScreen extends StatelessWidget {
//   final String pickupLocation;
//   final String dropLocation;
//   final double pickupLat;
//   final double pickupLng;
//   final double dropLat;
//   final double dropLng;
//   final int seats;
//   final DateTime? scheduledAt;

//   const AvailableSharedRidesScreen({
//     required this.pickupLocation,
//     required this.dropLocation,
//     required this.pickupLat,
//     required this.pickupLng,
//     required this.dropLat,
//     required this.dropLng,
//     required this.seats,
//     this.scheduledAt,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<TaxiBookingController>();

//     // Fetch matching shared rides when screen loads
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.getNearByBookings(); // Or use a specific endpoint for shared rides
//     });

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Available Shared Rides'),
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return Center(child: CircularProgressIndicator());
//         }

//         if (controller.bookings.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.directions_car, size: 64, color: Colors.grey),
//                 SizedBox(height: ASizes.spaceBtwItems),
//                 Text('No matching shared rides found'),
//                 SizedBox(height: ASizes.spaceBtwItems),
//                 Text('Try adjusting your search or book a private ride'),
//               ],
//             ),
//           );
//         }

//         // Filter only shared rides with available seats
//         final sharedRides = controller.bookings; 
        

//         if (sharedRides.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.directions_car, size: 64, color: Colors.grey),
//                 SizedBox(height: ASizes.spaceBtwItems),
//                 Text('No matching shared rides found'),
//                 SizedBox(height: ASizes.spaceBtwItems),
//                 Text('Try adjusting your search or book a private ride'),
//               ],
//             ),
//           );
//         }

//         return ListView.builder(
//           padding: EdgeInsets.all(ASizes.defaultSpace),
//           itemCount: sharedRides.length,
//           itemBuilder: (context, index) {
//             final booking = sharedRides[index];
//             return _buildRideCard(booking);
//           },
//         );
//       }),
//     );
//   }

//   Widget _buildRideCard(TaxiBooking booking) {
//     final availableSeats = booking.assignedVehicle?.seats?? 4 ;
//     final pricePerSeat = booking.totalPrice / booking.assignedVehicle!.seats;
//     final totalPrice = pricePerSeat * seats;

//     return Card(
//       margin: EdgeInsets.only(bottom: ASizes.spaceBtwItems),
//       elevation: 4,
//       child: Padding(
//         padding: EdgeInsets.all(ASizes.defaultSpace),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Shared Ride',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 Chip(
//                   label: Text(
//                     '$availableSeats seats left',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   backgroundColor: AColors.primary,
//                 ),
//               ],
//             ),
//             SizedBox(height: ASizes.spaceBtwItems),
//             _buildRideDetail(Icons.location_on, 'Pickup', booking.pickupLocation),
//             SizedBox(height: ASizes.spaceBtwItems / 2),
//             _buildRideDetail(Icons.flag, 'Drop', booking.dropLocation),
//             SizedBox(height: ASizes.spaceBtwItems / 2),
//             _buildRideDetail(Icons.people, 'Passengers', '${booking.bookedSeats}/${booking.assignedVehicle?.seats ?? 4}'),
//             SizedBox(height: ASizes.spaceBtwItems / 2),
//             _buildRideDetail(Icons.access_time, 'Time', 
//               DateFormat('MMM dd, hh:mm a').format(booking.scheduledAt ?? booking.bookingDateTime)),
//             SizedBox(height: ASizes.spaceBtwItems),
//             Divider(),
//             SizedBox(height: ASizes.spaceBtwItems),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Price per seat:'),
//                     Text(
//                       'LKR ${pricePerSeat.toStringAsFixed(2)}',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Total for $seats seat${seats > 1 ? 's' : ''}:'),
//                     Text(
//                       'LKR ${totalPrice.toStringAsFixed(2)}',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: AColors.primary,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ],
//                 ),
//                 ElevatedButton(
//                   onPressed: () => _joinRide(booking),
//                   child: Text('Join Ride'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRideDetail(IconData icon, String label, String value) {
//     return Row(
//       children: [
//         Icon(icon, size: 20, color: Colors.grey),
//         SizedBox(width: ASizes.spaceBtwItems),
//         Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
//         Expanded(child: Text(value)),
//       ],
//     );
//   }

//   void _joinRide(TaxiBooking booking) {
//     Get.to(() => JoinBookingConfirmationScreen(
//       booking: booking,
//       pickupLocation: pickupLocation,
//       dropLocation: dropLocation,
//       pickupLat: pickupLat,
//       pickupLng: pickupLng,
//       seats: seats,
//     ));
//   }
// }