class HouseRule {
  final String id;
  final String hostelId;
  final String rule;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  HouseRule({
    required this.id,
    required this.hostelId,
    required this.rule,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

factory HouseRule.fromJson(Map<String, dynamic> json) {
  return HouseRule(
    id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
    hostelId: json['hostel_id']?.toString() ?? json['hostelId']?.toString() ?? '',
    rule: json['rule']?.toString() ?? 
          json['title']?.toString() ?? 
          json['name']?.toString() ?? 
          'House rule',
    description: json['description']?.toString() ?? 
                json['detail']?.toString(),
    createdAt: _parseDateTime(json['created_at'] ?? json['createdAt']),
    updatedAt: _parseDateTime(json['updated_at'] ?? json['updatedAt']),
  );
}

  static DateTime _parseDateTime(dynamic value) {
    try {
      return DateTime.parse(value.toString());
    } catch (e) {
      return DateTime.now();
    }
  }
}