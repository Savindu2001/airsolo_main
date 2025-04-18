
class HouseRule {
  final String id;
  final String? hostelId; // Nullable if not always required
  final String? roomId;   // Nullable if not always required
  final String rule;
  final DateTime createdAt;
  final DateTime updatedAt;

  HouseRule({
    required this.id,
    this.hostelId,
    this.roomId,
    required this.rule,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HouseRule.fromJson(Map<String, dynamic> json) {
    return HouseRule(
      id: json['id']?.toString() ?? '',
      hostelId: json['hostel_id']?.toString(),
      roomId: json['room_id']?.toString(),
      rule: json['rule']?.toString() ?? '',
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  static DateTime _parseDateTime(dynamic dateTimeData) {
    if (dateTimeData == null) return DateTime.now();
    
    if (dateTimeData is DateTime) {
      return dateTimeData;
    }
    
    if (dateTimeData is String) {
      try {
        return DateTime.parse(dateTimeData);
      } catch (e) {
        return DateTime.now();
      }
    }
    
    if (dateTimeData is int) {
      return DateTime.fromMillisecondsSinceEpoch(dateTimeData);
    }
    
    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hostel_id': hostelId,
      'room_id': roomId,
      'rule': rule,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'HouseRule(id: $id, hostelId: $hostelId, roomId: $roomId, rule: $rule)';
  }
}