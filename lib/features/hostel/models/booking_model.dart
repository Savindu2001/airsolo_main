class HostelBooking {
  final String id;
  final String userId;
  final String hostelId;
  final String roomId;
  final String bedType;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int numGuests;
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
      specialRequests: specialRequests ?? this.specialRequests,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory HostelBooking.fromJson(Map<String, dynamic> json) {
    return HostelBooking(
      id: json['id'],
      userId: json['userId'],
      hostelId: json['hostelId'],
      roomId: json['roomId'],
      bedType: json['bedType'],
      checkInDate: DateTime.parse(json['checkInDate']),
      checkOutDate: DateTime.parse(json['checkOutDate']),
      numGuests: json['numGuests'],
      specialRequests: json['specialRequests'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
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
      'specialRequests': specialRequests,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}