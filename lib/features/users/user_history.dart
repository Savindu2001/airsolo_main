import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:airsolo/features/hostel/controllers/booking_controller.dart';
import 'package:airsolo/features/hostel/models/booking_model.dart';
import 'package:airsolo/features/taxi/controllers/taxi_booking_controller.dart';
import 'package:airsolo/features/taxi/models/taxi_booking_model.dart';
import 'package:airsolo/features/users/user_controller.dart';

class CustomerBookingHistoryPage extends StatefulWidget {
  @override
  _CustomerBookingHistoryPageState createState() => _CustomerBookingHistoryPageState();
}

class _CustomerBookingHistoryPageState extends State<CustomerBookingHistoryPage> {
  final TaxiBookingController _taxiController = Get.find();
  final BookingController _hostelController = Get.find();
  final UserController _userController = Get.find();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _taxiController.getTravelersHistoryBookings();
    await _hostelController.fetchUserBookings();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Bookings', style: Get.textTheme.headlineMedium),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _loadData,
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Taxi Rides'),
              Tab(text: 'Hostel Stays'),
            ],
            indicatorColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: TabBarView(
          children: [
            _buildTaxiHistoryTab(),
            _buildHostelHistoryTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildTaxiHistoryTab() {
    return RefreshIndicator(
      onRefresh: () => _taxiController.getTravelersHistoryBookings(),
      child: Obx(() {
        if (_taxiController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
      
        if (_taxiController.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error loading taxi history', style: TextStyle(color: Colors.red)),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _taxiController.getTravelersHistoryBookings,
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }
      
        if (_taxiController.historyTravelerBookings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.directions_car, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No taxi ride history', style: TextStyle(fontSize: 18, color: Colors.grey)),
                Text('Your completed rides will appear here', style: TextStyle(color: Colors.grey)),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Get.toNamed('/book-taxi'),
                  child: Text('Book a Ride'),
                ),
              ],
            ),
          );
        }
      
        return ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: _taxiController.historyTravelerBookings.length,
          itemBuilder: (context, index) {
            final booking = _taxiController.historyTravelerBookings[index];
            return GestureDetector(
              onTap: () => _showTaxiBookingDetails(booking),
              child: _buildTaxiBookingCard(booking),
            );
          },
        );
      }),
    );
  }

  Widget _buildHostelHistoryTab() {
    return RefreshIndicator(
      onRefresh: () => _hostelController.fetchUserBookings(),
      child: Obx(() {
        if (_hostelController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
      
        if (_hostelController.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error loading hostel history', style: TextStyle(color: Colors.red)),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _hostelController.fetchUserBookings(),
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }
      
        if (_hostelController.bookings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.hotel, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No hostel booking history', style: TextStyle(fontSize: 18, color: Colors.grey)),
                Text('Your completed stays will appear here', style: TextStyle(color: Colors.grey)),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Get.toNamed('/book-hostel'),
                  child: Text('Book a Stay'),
                ),
              ],
            ),
          );
        }
      
        return ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: _hostelController.bookings.length,
          itemBuilder: (context, index) {
            final booking = _hostelController.bookings[index];
            return GestureDetector(
              onTap: () => _showHostelBookingDetails(booking),
              child: _buildHostelBookingCard(booking),
            );
          },
        );
      }),
    );
  }

  void _showTaxiBookingDetails(TaxiBooking booking) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Text('Taxi Ride Details', style: Get.textTheme.headlineSmall),
            SizedBox(height: 16),
            _buildDetailRow('Booking ID', booking.id),
            _buildDetailRow('Status', booking.status.replaceAll('_', ' ').toUpperCase(), 
              color: _getTaxiStatusColor(booking.status)),
            _buildDetailRow('Pickup', booking.pickupLocation),
            _buildDetailRow('Dropoff', booking.dropLocation),
            _buildDetailRow('Date', DateFormat('MMM dd, yyyy - hh:mm a').format(booking.bookingDateTime)),
            _buildDetailRow('Type', booking.isShared ? 'Shared Ride' : 'Private Ride'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  void _showHostelBookingDetails(HostelBooking booking) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Text('Hostel Booking Details', style: Get.textTheme.headlineSmall),
            SizedBox(height: 16),
            _buildDetailRow('Booking ID', booking.id),
            _buildDetailRow('Status', booking.status.toUpperCase(), 
              color: _getHostelStatusColor(booking.status)),
            _buildDetailRow('Room Type', booking.bedType),
            _buildDetailRow('Check-in', DateFormat('MMM dd, yyyy').format(booking.checkInDate)),
            _buildDetailRow('Check-out', DateFormat('MMM dd, yyyy').format(booking.checkOutDate)),
            _buildDetailRow('Guests', booking.numGuests.toString()),
            _buildDetailRow('Amount', 'LKR ${booking.amount.toStringAsFixed(2)}'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: color != null ? TextStyle(color: color) : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaxiBookingCard(TaxiBooking booking) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Taxi Ride #${booking.id.substring(0, 8)}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Chip(
                  label: Text(
                    booking.status.replaceAll('_', ' ').toUpperCase(),
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: _getTaxiStatusColor(booking.status),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.red, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    booking.pickupLocation,
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.flag, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    booking.dropLocation,
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMM dd, yyyy - hh:mm a').format(booking.bookingDateTime),
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  '${booking.isShared ? 'Shared Ride' : 'Private Ride'}',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHostelBookingCard(HostelBooking booking) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hostel Booking #${booking.id.substring(0, 8)}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Chip(
                  label: Text(
                    booking.status.toUpperCase(),
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: _getHostelStatusColor(booking.status),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.hotel, color: Colors.blue, size: 20),
                SizedBox(width: 8),
                Text('Room Type: ${booking.bedType}'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.orange, size: 20),
                SizedBox(width: 8),
                Text(
                  '${DateFormat('MMM dd').format(booking.checkInDate)} - ${DateFormat('MMM dd, yyyy').format(booking.checkOutDate)}',
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.people, color: Colors.purple, size: 20),
                SizedBox(width: 8),
                Text('Guests: ${booking.numGuests}'),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'LKR ${booking.amount.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat('MMM dd, yyyy').format(booking.createdAt),
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getTaxiStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'driver_accepted':
        return Colors.blue;
      case 'in_progress':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getHostelStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      case 'checked_in':
        return Colors.blue;
      case 'checked_out':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}