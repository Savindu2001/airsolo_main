
class Vehicle {
  final String id;
  final String vehicleNumber;
  final String model;
  final int? year;
  final String color;
  final int? numberOfSeats;
  final int seats;
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
    this.year,
    this.seats = 4,
    required this.color,
    this.numberOfSeats,
    required this.isAvailable,
    required this.driverId,
    required this.vehicleTypeId,
    this.currentLat,
    this.currentLng,
    this.fcmToken,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as String? ?? '',
      vehicleNumber: json['vehicle_number'] as String? ?? '',
      model: json['model'] as String? ?? '',
      year: json['year'] as int? ?? 0,
      color: json['color'] as String? ?? '',
      numberOfSeats: json['number_of_seats'] as int? ?? 2,
      seats: json['seats'] as int? ?? 4,
      isAvailable: json['is_available'] as bool? ?? false,
      driverId: json['driver_id'] as String? ?? '',
      vehicleTypeId: json['vehicle_type_id'] as String? ?? '',
      currentLat: json['current_lat']?.toDouble(),
      currentLng: json['current_lng']?.toDouble(),
      fcmToken: json['fcm_token'] as String?,
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
      'seats': seats,
      'vehicle_type_id': vehicleTypeId,
      'current_lat': currentLat,
      'current_lng': currentLng,
      'fcm_token': fcmToken,
    };
  }

  Vehicle? copyWith({bool? isAvailable,}) {
    return Vehicle(
    id: id,
    vehicleNumber: vehicleNumber,
    model: model,
    year: year,
    color: color,
    numberOfSeats: numberOfSeats,
    isAvailable: isAvailable ?? this.isAvailable, 
    driverId: driverId,
    vehicleTypeId: vehicleTypeId,
    currentLat: currentLat,
    currentLng: currentLng,
    fcmToken: fcmToken,
  );
  }
}