import 'package:intl/intl.dart';

class ActivityEvent {
  final String id;
  final String name;
  final String? description;
  final String cityId;
  final List<String>? availableDays;
  final String? contact;
  final String activityType;
  final DateTime createdAt;
  final DateTime updatedAt;

  ActivityEvent({
    required this.id,
    required this.name,
    this.description,
    required this.cityId,
    this.availableDays,
    this.contact,
    required this.activityType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ActivityEvent.fromJson(Map<String, dynamic> json) {
  // Handle available_days which might come as String or List<String>
  List<String>? availableDays;
  if (json['available_days'] != null) {
    if (json['available_days'] is String) {
      // If it's a string, split by comma or handle as needed
      availableDays = [json['available_days'] as String];
    } else if (json['available_days'] is List) {
      availableDays = List<String>.from(json['available_days']);
    }
  }

  return ActivityEvent(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String?,
    cityId: json['cityId'] as String,
    availableDays: availableDays,
    contact: json['contact'] as String?,
    activityType: json['activity_type'] as String,
    createdAt: DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now(),
    updatedAt: DateTime.tryParse(json['updatedAt'] as String) ?? DateTime.now(),
  );
}

  String get formattedDate => DateFormat('MMM dd, yyyy').format(createdAt);
}
