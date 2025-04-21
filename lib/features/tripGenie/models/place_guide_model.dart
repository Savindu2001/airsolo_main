class PlaceGuide {
  final String location;
  final String guideDetails;
  final DateTime? timestamp;

  PlaceGuide({
    required this.location,
    required this.guideDetails,
    this.timestamp,
  });

  factory PlaceGuide.fromJson(Map<String, dynamic> json) {
    return PlaceGuide(
      location: json['location'] ?? '',
      guideDetails: json['guideDetails'] ?? '',
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'guideDetails': guideDetails,
      'timestamp': timestamp?.toIso8601String(),
    };
  }
}