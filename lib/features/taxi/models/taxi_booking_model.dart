import 'package:google_maps_flutter/google_maps_flutter.dart';

class TaxiBooking {
  final String id;
  final String travelerId;
  final String? vehicleId;
  final String pickupLocation;
  final String dropLocation;
  final LatLng pickupLatLng;
  final LatLng dropLatLng;
  final double distance;
  final double totalPrice;
  final bool isShared;
  final int bookedSeats;
  final List<String> travelerIds;
  final DateTime bookingDateTime;
  final String status;
  final String paymentStatus;
  final DateTime? scheduledAt;
  final DateTime? startedAt;
  final DateTime? completedAt;

  TaxiBooking({
    required this.id,
    required this.travelerId,
    this.vehicleId,
    required this.pickupLocation,
    required this.dropLocation,
    required this.pickupLatLng,
    required this.dropLatLng,
    required this.distance,
    required this.totalPrice,
    required this.isShared,
    required this.bookedSeats,
    required this.travelerIds,
    required this.bookingDateTime,
    required this.status,
    required this.paymentStatus,
    this.scheduledAt,
    this.startedAt,
    this.completedAt,
  });

  factory TaxiBooking.fromJson(Map<String, dynamic> json) {
  // Check if the response has a nested 'booking' object
  final bookingData = json['booking'] ?? json;
  
  return TaxiBooking(
    id: bookingData['id'] ?? '',
    travelerId: bookingData['travelerId'] ?? '',
    vehicleId: bookingData['vehicleId'],
    pickupLocation: bookingData['pickupLocation'] ?? '',
    dropLocation: bookingData['dropLocation'] ?? '',
    pickupLatLng: LatLng(
      (bookingData['pickupLat'] ?? 0).toDouble(),
      (bookingData['pickupLng'] ?? 0).toDouble(),
    ),
    dropLatLng: LatLng(
      (bookingData['dropLat'] ?? 0).toDouble(),
      (bookingData['dropLng'] ?? 0).toDouble(),
    ),
    distance: (bookingData['distance'] ?? 0).toDouble(),
    totalPrice: (bookingData['totalPrice'] ?? 0).toDouble(),
    isShared: bookingData['isShared'] ?? false,
    bookedSeats: bookingData['bookedSeats'] ?? 1,
    travelerIds: List<String>.from(bookingData['travelerIds'] ?? []),
    bookingDateTime: DateTime.parse(bookingData['bookingDateTime'] ?? DateTime.now().toIso8601String()),
    status: bookingData['status'] ?? 'pending',
    paymentStatus: bookingData['payment_status'] ?? 'pending',
    scheduledAt: bookingData['scheduled_at'] != null ? DateTime.tryParse(bookingData['scheduled_at']) ?? DateTime.now() : null,
    startedAt: bookingData['started_at'] != null ? DateTime.parse(bookingData['started_at']) : null,
    completedAt: bookingData['completed_at'] != null ? DateTime.parse(bookingData['completed_at']) : null,
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'travelerId': travelerId,
      'vehicleId': vehicleId,
      'pickupLocation': pickupLocation,
      'dropLocation': dropLocation,
      'pickupLat': pickupLatLng.latitude,
      'pickupLng': pickupLatLng.longitude,
      'dropLat': dropLatLng.latitude,
      'dropLng': dropLatLng.longitude,
      'distance': distance,
      'totalPrice': totalPrice,
      'isShared': isShared,
      'bookedSeats': bookedSeats,
      'travelerIds': travelerIds,
      'bookingDateTime': bookingDateTime.toIso8601String(),
      'status': status,
      'payment_status': paymentStatus,
      'scheduled_at': scheduledAt?.toIso8601String(),
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}