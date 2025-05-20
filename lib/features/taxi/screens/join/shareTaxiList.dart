import 'package:airsolo/features/taxi/models/taxi_booking_model.dart';
import 'package:airsolo/features/taxi/screens/join/shareTaxiBookingDetails.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:airsolo/features/taxi/controllers/taxi_booking_controller.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:intl/intl.dart';

class SharedBookingsScreen extends StatelessWidget {
  const SharedBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TaxiBookingController());
    
    // Fetch shared bookings when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAllTaxiBookings(isShared: true);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Rides'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.getAllTaxiBookings(isShared: true),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.bookings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.car_rental, size: 64, color: Colors.grey),
                const SizedBox(height: ASizes.spaceBtwItems),
                Text(
                  'No shared rides available',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: ASizes.spaceBtwItems),
                Text(
                  'Check back later or create your own shared ride',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(ASizes.defaultSpace),
          itemCount: controller.bookings.length,
          itemBuilder: (context, index) {
            final booking = controller.bookings[index];
            return _SharedBookingCard(booking: booking);
          },
        );
      }),
    );
  }
}

class _SharedBookingCard extends StatelessWidget {
  final TaxiBooking booking;

  const _SharedBookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final availableSeats = (booking.assignedVehicle?.seats ?? 0) - (booking.bookedSeats ?? 0);
    final pricePerSeat = booking.totalPrice / (booking.assignedVehicle?.seats ?? 1);
    final formattedDate = DateFormat('MMM dd, yyyy').format(booking.scheduledAt ?? booking.bookingDateTime);
    final formattedTime = DateFormat('hh:mm a').format(booking.scheduledAt ?? booking.bookingDateTime);

    return Card(
      margin: const EdgeInsets.only(bottom: ASizes.spaceBtwItems),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(ASizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status and available seats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    booking.status?.toUpperCase() ?? 'PENDING',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: _getStatusColor(booking.status),
                ),
                Chip(
                  label: Text(
                    '$availableSeats seats available',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: AColors.primary,
                ),
              ],
            ),
            const SizedBox(height: ASizes.spaceBtwItems),

            // Route information
            _buildInfoRow(Icons.my_location, 'From:', booking.pickupLocation),
            const SizedBox(height: ASizes.spaceBtwItems / 2),
            _buildInfoRow(Icons.location_on, 'To:', booking.dropLocation),
            const SizedBox(height: ASizes.spaceBtwItems / 2),
            _buildInfoRow(Icons.calendar_today, 'Date:', formattedDate),
            const SizedBox(height: ASizes.spaceBtwItems / 2),
            _buildInfoRow(Icons.access_time, 'Time:', formattedTime),
            const SizedBox(height: ASizes.spaceBtwItems / 2),
            
            // Vehicle information if available
            if (booking.assignedVehicle != null) ...[
              _buildInfoRow(Icons.directions_car, 'Vehicle:', 
                '${booking.assignedVehicle} ${booking.assignedVehicle!.model}'),
              const SizedBox(height: ASizes.spaceBtwItems / 2),
              _buildInfoRow(Icons.color_lens, 'Color:', booking.assignedVehicle!.color),
              const SizedBox(height: ASizes.spaceBtwItems / 2),
            ],

            // Price information
            _buildInfoRow(Icons.attach_money, 'Price per seat:', 
              '${pricePerSeat.toStringAsFixed(2)} Rs:'),
            
            const Divider(height: ASizes.spaceBtwSections),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () {
                    // View details action
                    Get.to(() => BookingDetailsScreen(bookingId: booking.id!));
                  },
                  child: const Text('Details'),
                ),
                ElevatedButton(
                  onPressed: availableSeats > 0 ? () {
                    // Join ride action
                    _showJoinRideDialog(context, booking);
                  } : null,
                  child: const Text('Join Ride'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AColors.primary),
        const SizedBox(width: ASizes.spaceBtwItems),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: ASizes.spaceBtwItems / 2),
        Expanded(child: Text(value)),
      ],
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'in_progress':
        return Colors.orange;
      case 'driver_accepted':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _showJoinRideDialog(BuildContext context, TaxiBooking booking) {
    final seatController = TextEditingController(text: '1');
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Join Shared Ride'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Available seats: ${(booking.assignedVehicle?.seats ?? 0) - (booking.bookedSeats ?? 0)}'),
              const SizedBox(height: ASizes.spaceBtwItems),
              TextFormField(
                controller: seatController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Number of seats',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter seats';
                  final seats = int.tryParse(value) ?? 0;
                  final available = (booking.assignedVehicle?.seats ?? 0) - (booking.bookedSeats ?? 0);
                  if (seats <= 0) return 'Enter valid number';
                  if (seats > available) return 'Only $available seats available';
                  return null;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final seats = int.tryParse(seatController.text) ?? 1;
                Get.back();
                Get.find<TaxiBookingController>().joinSharedBooking(
                  bookingId: booking.id!,
                  seatsToBook: seats,
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}

