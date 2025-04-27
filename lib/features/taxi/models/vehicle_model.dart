class Vehicle {
  final String id;
  final String vehicleNumber;
  final String driverId;
  final String vehicleTypeId;
  final int numberOfSeats;

  Vehicle({
    required this.id,
    required this.vehicleNumber,
    required this.driverId,
    required this.vehicleTypeId,
    required this.numberOfSeats,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      vehicleNumber: json['vehicle_number'],
      driverId: json['driver_id'],
      vehicleTypeId: json['vehicleTypeId'],
      numberOfSeats: json['number_of_seats'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicle_number': vehicleNumber,
      'driver_id': driverId,
      'vehicleTypeId': vehicleTypeId,
      'number_of_seats': numberOfSeats,
    };
  }
}


// Fetch driver details so call user model {driver_id} : user_id