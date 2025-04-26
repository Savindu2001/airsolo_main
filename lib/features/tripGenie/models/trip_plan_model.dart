class TripPlan {
  final String startCity;
  final DateTime startDate;
  final DateTime endDate;
  final String tripType;
  final int numberOfGuest;
  final String tripDetails; // Ensure this is String
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
    // Convert tripDetails to String if it comes as List or other type
    String details = '';
    if (json['tripDetails'] is List) {
      details = (json['tripDetails'] as List).join('\n\n');
    } else {
      details = json['tripDetails']?.toString() ?? '';
    }

    return TripPlan(
      startCity: json['startCity'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      tripType: json['tripType'] ?? '',
      numberOfGuest: json['numberOfGuest'] ?? 1,
      tripDetails: details, // Use converted string
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