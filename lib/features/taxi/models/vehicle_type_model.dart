class VehicleType {
  final String id;
  final String type;
  final double priceFor5Km;
  final double additionalPricePerKm;

  VehicleType({
    required this.id,
    required this.type,
    required this.priceFor5Km,
    required this.additionalPricePerKm,
  });

  factory VehicleType.fromJson(Map<String, dynamic> json) {
  return VehicleType(
    id: json['id'] as String,
    type: json['type'] as String,
    priceFor5Km: double.tryParse(json['priceFor5Km'] as String) ?? 0.0, 
    additionalPricePerKm: double.tryParse(json['additionalPricePerKm'] as String) ?? 0.0, 
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'priceFor5Km': priceFor5Km,
      'additionalPricePerKm': additionalPricePerKm,
    };
  }
}