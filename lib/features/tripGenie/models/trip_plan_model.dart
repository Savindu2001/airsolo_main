class TripPlan {
  final String startCity;
  final DateTime startDate;
  final DateTime endDate;
  final String tripType;
  final int numberOfGuest;
  final String tripDetails;
  final DateTime? timestamp;

  TripPlan({
    required this.startCity,
    required this.startDate,
    required this.endDate,
    required this.tripType,
    required this.numberOfGuest,
    required this.tripDetails,
    this.timestamp,
  });

  factory TripPlan.fromJson(Map<String, dynamic> json) {
    return TripPlan(
      startCity: json['startCity'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      tripType: json['tripType'] ?? '',
      numberOfGuest: json['numberOfGuest'] ?? 1,
      tripDetails: json['tripDetails'] ?? '',
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startCity': startCity,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'tripType': tripType,
      'numberOfGuest': numberOfGuest,
      'tripDetails': tripDetails,
      'timestamp': timestamp?.toIso8601String(),
    };
  }
}