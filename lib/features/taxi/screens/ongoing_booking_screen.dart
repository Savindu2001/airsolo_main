import 'dart:ui';

import 'package:airsolo/features/taxi/controllers/taxi_booking_controller.dart';
import 'package:airsolo/features/taxi/models/taxi_booking_model.dart';
import 'package:airsolo/features/taxi/screens/taxi_payment.dart';
import 'package:airsolo/features/users/user_controller.dart' show UserController;
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:iconsax/iconsax.dart';

class OngoingBookingScreen extends StatefulWidget {
  final TaxiBooking booking;

  const OngoingBookingScreen({super.key, required this.booking});

  @override
  State<OngoingBookingScreen> createState() => _OngoingBookingScreenState();
}

class _OngoingBookingScreenState extends State<OngoingBookingScreen> {
  final TaxiBookingController _bookingController = Get.find();
  final UserController _userController = Get.find();
  TaxiBooking? _currentBooking;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentBooking = widget.booking;
    _loadUserData();
  }

  void _loadUserData() {
    if (_currentBooking?.assignedVehicle?.driverId != null) {
      _userController.fetchDriverDetails(_currentBooking!.assignedVehicle!.driverId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AHelperFunctions.isDarkMode(context);
    final isCompleted = _currentBooking?.status == 'ride_completed';

    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Details', style: Get.textTheme.headlineMedium),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? AColors.white : AColors.black),
          onPressed: () => Get.offAllNamed('/home'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Map Section
            _buildMapSection(),
            const SizedBox(height: 20),
            
            // User & Driver Cards
            Row(
              children: [
                Expanded(child: _buildUserCard()),
                const SizedBox(width: 10),
                Expanded(child: _buildDriverCard()),
              ],
            ),
            const SizedBox(height: 20),
            
            // Vehicle Details
            _buildVehicleCard(),
            const SizedBox(height: 20),
            
            // Trip Details
            _buildTripDetailsCard(),
            const SizedBox(height: 20),
            
            // Status & Actions
            _buildStatusSection(),
            const SizedBox(height: 20),
            
            // Action Buttons
            if (!isCompleted) _buildPaymentButton() else _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    return Container(
      height: 200,
      
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
        image: DecorationImage(
          image: AssetImage('assets/images/banners/taxi.jpg'),
          fit: BoxFit.cover
          )
      ),
      child: Stack(
        children: [
          // Your Map Widget Here (Google Maps or other)
          Center(child: 
          Text('Your Sri Lanka Trusted Taxi partner')
          ),
          
          // Destination Box
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
              )],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.circle, color: Colors.green, size: 12),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_currentBooking?.pickupLocation ?? 'Pickup location')),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.red, size: 12),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_currentBooking?.dropLocation ?? 'Drop location')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('YOUR DETAILS', style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            )),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                radius: 20,
                child: Icon(Icons.person),
              ),
              title: Text(_userController.currentUser?.fullName ?? 'You'),
              subtitle: Text('Traveler'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverCard() {
    return Obx(() {
      final driver = _userController.currentDriver.value;
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('DRIVER DETAILS', style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              )),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 20,
                  backgroundImage: driver?.profilePhoto != null 
                    ? NetworkImage(driver!.profilePhoto!) 
                    : null,
                  child: driver?.profilePhoto == null ? Icon(Icons.person) : null,
                ),
                title: Text(driver?.fullName ?? 'Loading...'),
                subtitle: Text('Driver | 4.8 ★'),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildVehicleCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('VEHICLE DETAILS', style: Get.textTheme.titleLarge),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AHelperFunctions.isDarkMode(context) ? AColors.primary : AColors.homePrimary,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(Iconsax.car, color: Colors.white),
              ),
              title: Text(_currentBooking?.assignedVehicle?.model ?? 'Vehicle model', style: Get.textTheme.bodyLarge,),
              subtitle: Text(_currentBooking?.assignedVehicle?.vehicleNumber ?? 'License plate', style: Get.textTheme.bodyLarge,),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripDetailsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('TRIP DETAILS', style: Get.textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.timer, 'Trip Time', '30 mins (approx)'),
            const Divider(height: 20),
            _buildDetailRow(Icons.attach_money, 'Estimated Fare', 'LKR ${_currentBooking?.totalPrice ?? '0.00'}'),
            const Divider(height: 20),
            _buildDetailRow(Icons.date_range, 'Date', 
              '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Text(title, style: const TextStyle(fontSize: 14)),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildStatusSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: _getProgressValue(_currentBooking?.status ?? 'pending'),
              backgroundColor: Colors.grey[200],
              color: AColors.primary,
            ),
            const SizedBox(height: 8),
            Text(
              _getStatusText(_currentBooking?.status ?? 'pending'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.close, color: Colors.red),
            label: const Text('CANCEL', style: TextStyle(color: Colors.red)),
            onPressed: _cancelTrip,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Colors.red),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.call, color: Colors.white),
            label: const Text('CONTACT', style: TextStyle(color: Colors.white)),
            onPressed: _contactDriver,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AColors.primary,
            ),
          ),
        ),
      ],
    );
  }

Widget _buildPaymentButton() {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {
        Get.to(() => TaxiPaymentScreen(), arguments: _currentBooking);
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: AColors.primary,
      ),
      child: const Text(
        'PAY NOW ',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

  // Helper methods
  double _getProgressValue(String status) {
    switch (status) {
      case 'driver_accepted': return 0.3;
      case 'driver_arrived': return 0.6;
      case 'ride_started': return 0.8;
      case 'ride_completed': return 1.0;
      default: return 0.1;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'driver_accepted': return 'Driver is on the way';
      case 'driver_arrived': return 'Driver has arrived';
      case 'ride_started': return 'Trip in progress';
      case 'ride_completed': return 'Trip completed - Payment pending';
      default: return 'Waiting for driver';
    }
  }

  Future<void> _cancelTrip() async {
    print(widget.booking.id);
    _bookingController.updateBookingStatus(bookingId: widget.booking.id, status: 'cancelled');
  }

  void _contactDriver() {
    Get.snackbar('Call to Driver', 'Calling........');
    
  }
}