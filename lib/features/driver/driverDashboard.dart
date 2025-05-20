import 'package:airsolo/features/authentication/controllers/login_controller.dart';
import 'package:airsolo/features/taxi/controllers/taxi_booking_controller.dart';
import 'package:airsolo/features/taxi/controllers/vehicle_controller.dart';
import 'package:airsolo/features/taxi/models/taxi_booking_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DriverHomeScreen extends StatelessWidget {
  final TaxiBookingController bookingController = Get.put(TaxiBookingController());
  final VehicleController vehicleController = Get.put(VehicleController());
  final LoginController loginController = Get.put(LoginController());

   DriverHomeScreen({super.key});
   
   @override
  void initState() {
    bookingController.getNearByBookings();
    bookingController.getHistoryBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Driver Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [

                Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Obx(() => TextButton(
      onPressed: vehicleController.currentVehicle.value?.isAvailable == true
          ? null // Disabled when already online
          : () {
              vehicleController.toggleAvailability(true);
            },
      style: TextButton.styleFrom(
        backgroundColor: vehicleController.currentVehicle.value?.isAvailable == true
            ? Colors.green
            : Colors.grey[300],
        foregroundColor: Colors.white,
      ),
      child: const Text("Go Online"),
    )),
    const SizedBox(width: 10),
    Obx(() => TextButton(
      onPressed: vehicleController.currentVehicle.value?.isAvailable == false
          ? null // Disabled when already offline
          : () {
              vehicleController.toggleAvailability(false);
            },
      style: TextButton.styleFrom(
        backgroundColor: vehicleController.currentVehicle.value?.isAvailable == false
            ? Colors.red
            : Colors.grey[300],
        foregroundColor: Colors.white,
      ),
      child: const Text("Go Offline"),
    )),
  ],
),


                


                const SizedBox(width: 12),
                IconButton(
                  onPressed: () => loginController.logout(),
                  icon: const Icon(Iconsax.logout, size: 22),
                  tooltip: 'Logout',
                ),
              ],
            ),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Material(
              color: Theme.of(context).scaffoldBackgroundColor,
              elevation: 2,
              child: TabBar(
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Theme.of(context).primaryColor,
                tabs: const [
                  Tab(icon: Icon(Iconsax.clock), text: 'Pending'),
                  Tab(icon: Icon(Iconsax.activity), text: 'Active'),
                  Tab(icon: Icon(Iconsax.calendar), text: 'History'),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (bookingController.error.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Iconsax.warning_2, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading bookings',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          bookingController.error.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => bookingController.getNearByBookings(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                
                return RefreshIndicator(
                  onRefresh: () async {
                    await bookingController.getNearByBookings();
                    await bookingController.getHistoryBookings();
                  } ,
                  child: TabBarView(
                    children: [
                      _buildPendingBookings(),
                      _buildActiveBookings(),
                      _buildBookingHistory(),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingBookings() {
  return Obx(() {
    print('Building Pending Bookings - Loading: ${bookingController.isLoading.value}');
    print('Bookings count: ${bookingController.bookings.length}');
    
    if (bookingController.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (bookingController.error.value.isNotEmpty) {
      return Center(child: Text('Error: ${bookingController.error.value}'));
    }
    
    final pendingBookings = bookingController.bookings
        .where((b) => b.status?.toLowerCase() == 'pending')
        .toList();
    
    print('Pending bookings count: ${pendingBookings.length}');
    
    if (pendingBookings.isEmpty) {
      return _buildEmptyState(
        icon: Iconsax.clock,
        title: 'No Pending Rides',
        subtitle: 'When you receive new ride requests, they\'ll appear here',
        onRetry: bookingController.getNearByBookings,
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pendingBookings.length,
      itemBuilder: (context, index) {
        final booking = pendingBookings[index];
        print('Building booking card: ${booking.id}');
        return _buildBookingCard(booking,context);
      },
    );
  });
}

  Widget _buildActiveBookings() {
    return Obx(() {
      if (bookingController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      
      final activeBookings = bookingController.bookings
          .where((b) => ['driver_accepted', 'driver_arrived', 'ride_started'].contains(b.status))
          .toList();
      
      if (activeBookings.isEmpty) {
        return _buildEmptyState(
          icon: Iconsax.activity,
          title: 'No Active Rides',
          subtitle: 'Your current rides will appear here',
          onRetry: bookingController.getNearByBookings,
        );
      }
      
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: activeBookings.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final booking = activeBookings[index];
          return _buildBookingCard(booking, context);
        },
      );
    });
  }

  Widget _buildBookingHistory() {
  return Obx(() {
    if (bookingController.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (bookingController.error.value.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${bookingController.error.value}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: bookingController.getHistoryBookings,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Use historyBookings instead of filtering the main bookings list
    if (bookingController.historyBookings.isEmpty) {
      return _buildEmptyState(
        icon: Iconsax.calendar,
        title: 'No Ride History',
        subtitle: 'Your completed rides will appear here',
        onRetry: bookingController.getHistoryBookings,
      );
    }
    
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: bookingController.historyBookings.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final booking = bookingController.historyBookings[index];
        return _buildBookingCard(booking,context);
      },
    );
  });
}

  Widget _buildEmptyState({
    required IconData icon, 
    required String title, 
    required String subtitle,
    required VoidCallback onRetry,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: onRetry,
                child: const Text('Refresh'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(TaxiBooking booking, BuildContext context) {
    final timeFormat = DateFormat('hh:mm a');
    final isPending = booking.status == 'pending';
    final isActive = ['driver_accepted', 'driver_arrived', 'ride_started'].contains(booking.status);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _showBookingDetails(booking);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Booking #${booking.id.substring(0, 8).toUpperCase()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(booking.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      booking.status.replaceAll('_', ' '),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),


                  if (isActive && booking.status == 'driver_accepted')
                    IconButton(
                      icon: const Icon(Iconsax.map_1, size: 20),
                      onPressed: () => _showMapChooser(
                        context: context,  
                        lat: booking.pickupLatLng.latitude,
                        lng: booking.pickupLatLng.longitude,
                      ),
                    ),

                  if (isActive && booking.status == 'driver_arrived')
                    IconButton(
                      icon: const Icon(Iconsax.map_1, size: 20),
                      onPressed: () => _showMapChooser(
                        context: context,  
                        lat: booking.dropLatLng.latitude,
                        lng: booking.dropLatLng.longitude,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Iconsax.location, size: 16, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      booking.pickupLocation,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 7),
                child: Container(
                  height: 20,
                  width: 2,
                  color: Colors.grey[300],
                ),
              ),
              Row(
                children: [
                  const Icon(Iconsax.location, size: 16, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      booking.dropLocation,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Distance',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '${booking.distance.toStringAsFixed(1)} km',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Fare',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '\Rs:${booking.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Time',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        timeFormat.format(booking.bookingDateTime),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (isPending || isActive) const SizedBox(height: 12),
              if (isPending)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => bookingController.updateBookingStatus(bookingId: booking.id, status: 'cancelled'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Reject'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => bookingController.getAcceptedBooking(booking.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Accept'),
                      ),
                    ),
                  ],
                ),
              if (isActive && booking.status == 'driver_accepted')
                ElevatedButton(
                  onPressed: () => bookingController.updateBookingStatus(bookingId: booking.id, status: 'driver_arrived'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Mark as Arrived'),
                ),
              if (isActive && booking.status == 'driver_arrived')
                ElevatedButton(
                  onPressed: () => bookingController.updateBookingStatus(bookingId: booking.id, status: 'ride_started'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Start Ride'),
                ),
              if (isActive && booking.status == 'ride_started')
                ElevatedButton(
                  onPressed: () => bookingController.updateBookingStatus(bookingId: booking.id, status: 'ride_completed'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Complete Ride'),
                ),
            ],
          ),
        ),
      ),
    );
  }

void _showMapChooser({
  required BuildContext context,
  required double lat,
  required double lng,
}) {
  final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

  Get.bottomSheet(
    Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Title
          Text(
            'Open in Maps',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Map options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Google Maps option
              _buildMapOption(
                context: context,
                icon: Iconsax.map,
                color: Colors.red,
                label: 'Google Maps',
                onTap: () => _openGoogleMaps(lat, lng),
              ),
              
              // Apple Maps option (only on iOS)
              if (isIOS)
                _buildMapOption(
                  context: context,
                  icon: Iconsax.map,
                  color: Colors.blue,
                  label: 'Apple Maps',
                  onTap: () => _openAppleMaps(lat, lng),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}

Widget _buildMapOption({
  required BuildContext context,
  required IconData icon,
  required Color color,
  required String label,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: () {
      Get.back();
      onTap();
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ],
    ),
  );
}

// Add these to your widget class or a helper file
Future<bool> _openAppleMaps(double lat, double lng) async {
  final url = Uri.parse('https://maps.apple.com/?q=$lat,$lng');
  try {
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      return true;
    }
  } catch (e) {
    debugPrint('Error opening Apple Maps: $e');
  }
  return false;
}

Future<bool> _openGoogleMaps(double lat, double lng) async {
  final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
  try {
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      return true;
    }
  } catch (e) {
    debugPrint('Error opening Google Maps: $e');
  }
  
  // Fallback to browser if apps aren't installed
  Get.snackbar(
    'Maps App Not Found', 
    'Opening in browser instead',
    snackPosition: SnackPosition.BOTTOM,
  );
  return await launchUrl(
    Uri.parse('https://maps.google.com?q=$lat,$lng'),
    mode: LaunchMode.externalApplication,
  );
}






  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'driver_accepted':
        return Colors.blue;
      case 'driver_arrived':
        return Colors.indigo;
      case 'ride_started':
        return Colors.purple;
      case 'ride_completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showBookingDetails(TaxiBooking booking) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Booking Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Booking ID', booking.id.substring(0, 8).toUpperCase()),
              _buildDetailRow('Status', booking.status.replaceAll('_', ' ')),
              _buildDetailRow('Pickup Location', booking.pickupLocation),
              _buildDetailRow('Drop Location', booking.dropLocation),
              _buildDetailRow('Distance', '${booking.distance.toStringAsFixed(1)} km'),
              _buildDetailRow('Fare', '\Rs:${booking.totalPrice.toStringAsFixed(2)}'),
              _buildDetailRow('Booking Type', booking.isShared ? 'Shared Ride' : 'Private Ride'),
              if (booking.isShared) _buildDetailRow('Seats Booked', booking.bookedSeats.toString()),
              _buildDetailRow('Created At', DateFormat('MMM dd, yyyy hh:mm a').format(booking.bookingDateTime)),
              const SizedBox(height: 24),
              if (booking.status == 'pending')
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                          bookingController.updateBookingStatus(bookingId: booking.id, status: 'cancelled');
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Reject'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          bookingController.getAcceptedBooking(booking.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Accept'),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}