import 'package:airsolo/features/taxi/controllers/taxi_booking_controller.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

class BookingDetailsScreen extends StatelessWidget {
  final String bookingId;

  const BookingDetailsScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TaxiBookingController>();
    
    // Fetch booking details when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getBookingDetails(bookingId);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final booking = controller.currentBooking.value;
        if (booking == null) {
          return const Center(child: Text('Booking not found'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(ASizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Booking status and ID
              _DetailItem(label: 'Booking ID:', value: booking.id ?? 'N/A'),
              _DetailItem(
                label: 'Status:', 
                value: booking.status?.toUpperCase() ?? 'PENDING',
                valueColor: _getStatusColor(booking.status),
              ),
              
              const Divider(),
              
              // Route information
              const Text('Route Information', style: TextStyle(fontWeight: FontWeight.bold)),
              _DetailItem(label: 'From:', value: booking.pickupLocation),
              _DetailItem(label: 'To:', value: booking.dropLocation),
              _DetailItem(
                label: 'Date & Time:', 
                value: DateFormat('MMM dd, yyyy - hh:mm a')
                  .format(booking.scheduledAt ?? booking.bookingDateTime),
              ),
              
              const Divider(),
              
              // Vehicle information
              if (booking.assignedVehicle != null) ...[
                const Text('Vehicle Information', style: TextStyle(fontWeight: FontWeight.bold)),
                _DetailItem(label: 'Model:', value: booking.assignedVehicle!.model),
                _DetailItem(label: 'Color:', value: booking.assignedVehicle!.color),
                _DetailItem(label: 'License Plate:', value: booking.assignedVehicle!.vehicleNumber),
                _DetailItem(
                  label: 'Seats:', 
                  value: '${booking.bookedSeats ?? 0}/${booking.assignedVehicle!.seats} booked',
                ),
                
                const Divider(),
              ],
              
              // Pricing information
              const Text('Pricing', style: TextStyle(fontWeight: FontWeight.bold)),
              _DetailItem(
                label: 'Price per seat:', 
                value: '${(booking.totalPrice / (booking.assignedVehicle?.seats ?? 1)).toStringAsFixed(2)} Rs:',
              ),
              _DetailItem(
                label: 'Total price:', 
                value: '${booking.totalPrice.toStringAsFixed(2)} Rs:',
                valueStyle: const TextStyle(fontWeight: FontWeight.bold)),
              
              
              const SizedBox(height: ASizes.spaceBtwSections),
              
              // Action buttons based on status
              if (booking.status == 'pending') ...[
                ElevatedButton(
                  onPressed: () => controller.updateBookingStatus(
                    bookingId: bookingId,
                    status: 'cancelled',
                  ),
                  child: const Text('Cancel Booking'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ],])
            
          );
          
        
      }),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed': return Colors.green;
      case 'cancelled': return Colors.red;
      case 'in_progress': return Colors.orange;
      case 'driver_accepted': return Colors.blue;
      default: return Colors.grey;
    }
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;
  final Color? valueColor;

  const _DetailItem({
    required this.label,
    required this.value,
    this.valueStyle,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: ASizes.spaceBtwItems / 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Text(
              value,
              style: valueStyle?.copyWith(color: valueColor) ?? 
                TextStyle(color: valueColor),
            ),
          ),
        ],
      ),
    );
  }
}