import 'package:airsolo/features/authentication/controllers/login_controller.dart';
import 'package:airsolo/features/taxi/controllers/taxi_booking_controller.dart';
import 'package:airsolo/features/taxi/controllers/vehicle_controller.dart';
import 'package:airsolo/features/taxi/models/taxi_booking_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class DriverHomeScreen extends StatelessWidget {
  final TaxiBookingController bookingController = Get.put(TaxiBookingController());
  final VehicleController vehicleController = Get.put(VehicleController());
  final LoginController loginController = Get.put(LoginController());
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Text(
    'Driver Dashboard',
    style: TextStyle(fontWeight: FontWeight.bold),
  ),
  centerTitle: true,
  actions: [
    Padding(
      padding: EdgeInsets.only(right: 12),
      child: Row(
        children: [
         

          Obx(() {
              final isAvailable = vehicleController.currentVehicle.value?.isAvailable ?? false;
              return Switch(
                value: isAvailable,
                onChanged: (value) => vehicleController.toggleAvailability(value),
                activeColor: Colors.green,
                inactiveThumbColor: Colors.grey[200],
              );
            }),


          SizedBox(width: 12),
          IconButton(
            onPressed: () => loginController.logout(),
            icon: Icon(Iconsax.logout, size: 22),
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
              child: RefreshIndicator(
                onRefresh: () async => await bookingController.getDriverBookings(),
                child: TabBarView(
                  children: [
                    _buildPendingBookings(),
                    _buildActiveBookings(),
                    _buildBookingHistory(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingBookings() {
    return Obx(() {
      if (bookingController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      
      final pendingBookings = bookingController.bookings
          .where((b) => b.status == 'pending')
          .toList();
      
      if (pendingBookings.isEmpty) {
        return _buildEmptyState(
          icon: Iconsax.clock,
          title: 'No Pending Rides',
          subtitle: 'When you receive new ride requests, they\'ll appear here',
        );
      }
      
      return ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: pendingBookings.length,
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          final booking = pendingBookings[index];
          return _buildBookingCard(booking);
        },
      );
    });
  }

  Widget _buildActiveBookings() {
    return Obx(() {
      if (bookingController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      
      final activeBookings = bookingController.bookings
          .where((b) => ['driver_accepted', 'driver_arrived', 'ride_started'].contains(b.status))
          .toList();
      
      if (activeBookings.isEmpty) {
        return _buildEmptyState(
          icon: Iconsax.activity,
          title: 'No Active Rides',
          subtitle: 'Your current rides will appear here',
        );
      }
      
      return ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: activeBookings.length,
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          final booking = activeBookings[index];
          return _buildBookingCard(booking);
        },
      );
    });
  }

  Widget _buildBookingHistory() {
    return Obx(() {
      if (bookingController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      
      final completedBookings = bookingController.bookings
          .where((b) => ['ride_completed', 'cancelled'].contains(b.status))
          .toList();
      
      if (completedBookings.isEmpty) {
        return _buildEmptyState(
          icon: Iconsax.calendar,
          title: 'No Ride History',
          subtitle: 'Your completed rides will appear here',
        );
      }
      
      return ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: completedBookings.length,
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          final booking = completedBookings[index];
          return _buildBookingCard(booking);
        },
      );
    });
  }

  Widget _buildEmptyState({required IconData icon, required String title, required String subtitle}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(TaxiBooking booking) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('hh:mm a');
    final isPending = booking.status == 'pending';
    final isActive = ['driver_accepted', 'driver_arrived', 'ride_started'].contains(booking.status);
    final isCompleted = booking.status == 'ride_completed';
    final isCancelled = booking.status == 'cancelled';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Show booking details
          _showBookingDetails(booking);
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Booking #${booking.id.substring(0, 8).toUpperCase()}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(booking.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      booking.status.replaceAll('_', ' '),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Iconsax.location, size: 16, color: Colors.red),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      booking.pickupLocation,
                      style: TextStyle(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 7),
                child: Container(
                  height: 20,
                  width: 2,
                  color: Colors.grey[300],
                ),
              ),
              Row(
                children: [
                  Icon(Iconsax.location, size: 16, color: Colors.green),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      booking.dropLocation,
                      style: TextStyle(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Divider(height: 1),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Distance',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '${booking.distance.toStringAsFixed(1)} km',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fare',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '\$${booking.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Time',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        timeFormat.format(booking.bookingDateTime),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (isPending || isActive) SizedBox(height: 12),
              if (isPending)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => bookingController.updateBookingStatus(booking.id, 'cancelled'),
                        child: Text('Reject'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: BorderSide(color: Colors.red),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => bookingController.acceptBooking(booking.id),
                        child: Text('Accept'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              if (isActive && booking.status == 'driver_accepted')
                ElevatedButton(
                  onPressed: () => bookingController.updateBookingStatus(booking.id, 'driver_arrived'),
                  child: Text('Mark as Arrived'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                  ),
                ),
              if (isActive && booking.status == 'driver_arrived')
                ElevatedButton(
                  onPressed: () => bookingController.updateBookingStatus(booking.id, 'ride_started'),
                  child: Text('Start Ride'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                  ),
                ),
              if (isActive && booking.status == 'ride_started')
                ElevatedButton(
                  onPressed: () => bookingController.updateBookingStatus(booking.id, 'ride_completed'),
                  child: Text('Complete Ride'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                  ),
                ),
            ],
          ),
        ),
      ),
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
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
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
              SizedBox(height: 16),
              Text(
                'Booking Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              _buildDetailRow('Booking ID', booking.id.substring(0, 8).toUpperCase()),
              _buildDetailRow('Status', booking.status.replaceAll('_', ' ')),
              _buildDetailRow('Pickup Location', booking.pickupLocation),
              _buildDetailRow('Drop Location', booking.dropLocation),
              _buildDetailRow('Distance', '${booking.distance.toStringAsFixed(1)} km'),
              _buildDetailRow('Fare', '\$${booking.totalPrice.toStringAsFixed(2)}'),
              _buildDetailRow('Booking Type', booking.isShared ? 'Shared Ride' : 'Private Ride'),
              if (booking.isShared) _buildDetailRow('Seats Booked', booking.bookedSeats.toString()),
              _buildDetailRow('Created At', DateFormat('MMM dd, yyyy hh:mm a').format(booking.bookingDateTime)),
              SizedBox(height: 24),
              if (booking.status == 'pending')
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                          bookingController.updateBookingStatus(booking.id, 'cancelled');
                        },
                        child: Text('Reject'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: BorderSide(color: Colors.red),
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          bookingController.acceptBooking(booking.id);
                        },
                        child: Text('Accept'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
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
      padding: EdgeInsets.symmetric(vertical: 8),
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
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}