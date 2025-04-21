class HostelBooking {
  final String id;
  final String userId;
  final String hostelId;
  final String roomId;
  final String bedType;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int numGuests;
  final double amount;
  final String? specialRequests;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  HostelBooking({
    required this.id,
    required this.userId,
    required this.hostelId,
    required this.roomId,
    required this.bedType,
    required this.checkInDate,
    required this.checkOutDate,
    required this.numGuests,
    this.specialRequests,
    required this.amount, 
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // Add this copyWith method
  HostelBooking copyWith({
    String? id,
    String? userId,
    String? hostelId,
    String? roomId,
    String? bedType,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    int? numGuests,
    double? amount,
    String? specialRequests,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HostelBooking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      hostelId: hostelId ?? this.hostelId,
      roomId: roomId ?? this.roomId,
      bedType: bedType ?? this.bedType,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      numGuests: numGuests ?? this.numGuests,
      amount: amount ?? this.amount,
      specialRequests: specialRequests ?? this.specialRequests,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }


 factory HostelBooking.fromJson(Map<String, dynamic> json) {
  try {
    // Helper function to parse dates safely
    DateTime parseDate(dynamic date) {
      try {
        if (date is DateTime) return date;
        if (date is String) return DateTime.parse(date);
        return DateTime.now();
      } catch (e) {
        return DateTime.now();
      }
    }

    // Helper function to parse numbers safely
    int parseInt(dynamic number) {
      if (number is int) return number;
      if (number is String) return int.tryParse(number) ?? 1;
      return 1;
    }

    return HostelBooking(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      hostelId: json['hostelId']?.toString() ?? '',
      roomId: json['roomId']?.toString() ?? '',
      bedType: json['bedType']?.toString() ?? '',
      checkInDate: parseDate(json['checkInDate']),
      checkOutDate: parseDate(json['checkOutDate']),
      numGuests: parseInt(json['numGuests']), // Fixed parsing here
      amount: (json['amount'] as num).toDouble(),
      specialRequests: json['specialRequests']?.toString(),
      status: json['status']?.toString() ?? 'pending',
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']), 
    );
  } catch (e, stack) {
    print('Error parsing HostelBooking: $e');
    print('Stack trace: $stack');
    print('Problematic JSON: $json');
    rethrow;
  }
}
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'hostelId': hostelId,
      'roomId': roomId,
      'bedType': bedType,
      'checkInDate': checkInDate.toIso8601String(),
      'checkOutDate': checkOutDate.toIso8601String(),
      'numGuests': numGuests,
      'amount': amount,
      'specialRequests': specialRequests,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}