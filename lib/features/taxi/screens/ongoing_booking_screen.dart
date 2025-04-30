import 'dart:async';

import 'package:airsolo/features/taxi/models/taxi_booking_model.dart';
import 'package:airsolo/features/taxi/controllers/taxi_booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OngoingBookingScreen extends StatefulWidget {
  final TaxiBooking booking;

  const OngoingBookingScreen({super.key, required this.booking});

  @override
  State<OngoingBookingScreen> createState() => _OngoingBookingScreenState();
}

class _OngoingBookingScreenState extends State<OngoingBookingScreen> {
  late Timer _pollingTimer;
  final TaxiBookingController _bookingController = Get.find();
  TaxiBooking? _currentBooking;
  bool _isLoading = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _currentBooking = widget.booking;
    _startPolling();
  }

  void _startPolling() {
    if (_currentBooking?.status == 'ride_completed') return;

    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (_isDisposed) return;

      try {
        if (!mounted) return;
        setState(() => _isLoading = true);
        
        final updatedBooking = await _bookingController.getBookingDetails(_currentBooking!.id);
        
        // if (updatedBooking != null && mounted) {
        //   setState(() {
        //     _currentBooking = updatedBooking;
        //     _isLoading = false;
        //   });
          
        //   if (updatedBooking.status == 'ride_completed') {
        //     timer.cancel();
        //     _navigateToTripCompletion(updatedBooking);
        //   }
        // }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          debugPrint('Error polling booking status: $e');
        }
      }
    });
  }

  void _navigateToTripCompletion(TaxiBooking booking) {
    if (_isDisposed) return;
    Get.offAll(() => TripCompletionScreen(booking: booking));
  }

  void _navigateToHome() {
    if (_isDisposed) return;
    Get.offAllNamed('/home');
  }

  Future<void> _cancelTrip() async {
    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Trip'),
        content: const Text('Are you sure you want to cancel this trip?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (shouldCancel == true && mounted && !_isDisposed) {
      try {
        setState(() => _isLoading = true);
        await _bookingController.cancelBooking(_currentBooking!.id);
        if (mounted && !_isDisposed) {
          _navigateToHome();
        }
      } catch (e) {
        if (mounted && !_isDisposed) {
          setState(() => _isLoading = false);
          Get.snackbar('Error', 'Failed to cancel trip: ${e.toString()}');
        }
      }
    }
  }

  void _contactDriver() {
    // Implement actual contact logic here
    Get.snackbar('Contact Driver', 'Calling driver...');
  }

  @override
  void dispose() {
    _isDisposed = true;
    _pollingTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navigateToHome();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Ongoing Trip', style: Get.textTheme.headlineMedium),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _navigateToHome,
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildBookingDetails(),
      ),
    );
  }

  Widget _buildBookingDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Driver Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.person, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        
                        'Driver ID: ${_currentBooking?.assignedVehicle?.driverId.substring(0, 8).toUpperCase() ?? 'N/A'}',
                        style: const TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text('Rating: 4.8 ★'),
                      const SizedBox(height: 4),
                      Text(
                        _currentBooking?.assignedVehicle?.vehicleNumber ?? 'N/A',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Trip Details Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.red),
                    title: const Text('Pickup Location'),
                    subtitle: Text(_currentBooking?.pickupLocation ?? 'Not specified'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.flag, color: Colors.green),
                    title: const Text('Drop Location'),
                    subtitle: Text(_currentBooking?.dropLocation ?? 'Not specified'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.directions_car),
                    title: const Text('Vehicle'),
                    subtitle: Text(
                      _currentBooking?.assignedVehicle?.model != null
                        ? '${_currentBooking!.assignedVehicle!.model} (${_currentBooking!.assignedVehicle!.vehicleNumber})'
                        : 'Vehicle info not available'
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Trip Status Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TRIP STATUS', 
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _getProgressValue(_currentBooking?.status ?? 'pending'),
                    backgroundColor: Colors.grey[200],
                    color: Colors.green,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getStatusText(_currentBooking?.status ?? 'pending'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          
          // Action Buttons
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _cancelTrip,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Text(
                    'CANCEL TRIP',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _contactDriver,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'CONTACT DRIVER',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
      case 'ride_completed': return 'Trip completed';
      default: return 'Waiting for driver';
    }
  }
}

class TripCompletionScreen extends StatelessWidget {
  final TaxiBooking booking;

  const TripCompletionScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Completed'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Get.offAllNamed('/home'),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 20),
              const Text(
                'Trip Completed!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'LKR ${booking.totalPrice}', 
                style: const TextStyle(
                  fontSize: 32, 
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Thank you for using our service',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.offAllNamed('/home'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}