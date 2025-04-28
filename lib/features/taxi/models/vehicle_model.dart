
class Vehicle {
  final String id;
  final String vehicleNumber;
  final String model;
  final int year;
  final String color;
  final int numberOfSeats;
  final bool isAvailable;
  final String driverId;
  final String vehicleTypeId;
  final double? currentLat;
  final double? currentLng;
  final String? fcmToken;

  Vehicle({
    required this.id,
    required this.vehicleNumber,
    required this.model,
    required this.year,
    required this.color,
    required this.numberOfSeats,
    required this.isAvailable,
    required this.driverId,
    required this.vehicleTypeId,
    this.currentLat,
    this.currentLng,
    this.fcmToken,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      vehicleNumber: json['vehicle_number'],
      model: json['model'],
      year: json['year'],
      color: json['color'],
      numberOfSeats: json['number_of_seats'],
      isAvailable: json['is_available'],
      driverId: json['driver_id'],
      vehicleTypeId: json['vehicle_type_id'],
      currentLat: json['current_lat']?.toDouble(),
      currentLng: json['current_lng']?.toDouble(),
      fcmToken: json['fcm_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicle_number': vehicleNumber,
      'model': model,
      'year': year,
      'color': color,
      'number_of_seats': numberOfSeats,
      'is_available': isAvailable,
      'driver_id': driverId,
      'vehicle_type_id': vehicleTypeId,
      'current_lat': currentLat,
      'current_lng': currentLng,
      'fcm_token': fcmToken,
    };
  }
}