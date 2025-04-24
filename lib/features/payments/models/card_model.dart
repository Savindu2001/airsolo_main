import 'package:flutter/material.dart';

class PaymentCard {
  final String id;
  final String? cardNumber; 
  final String? cvv; 
  final String userId;
  final String cardType;
  final String expDate;
  final String? nickName;
  final DateTime createdAt;
  final DateTime updatedAt;

  PaymentCard({
    required this.id,
    this.cardNumber, 
    this.cvv, 
    required this.userId,
    required this.expDate,
    this.nickName,
    required this.cardType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentCard.fromJson(Map<String, dynamic> json) {
   
    debugPrint('Parsing PaymentCard from JSON: $json');

    try {
      return PaymentCard(
        id: json['id'] as String,
        cardNumber: json['cardNumber'] as String?, 
        cvv: json['cvv'] as String?, 
        cardType: json['card_type'] as String, 
        userId: json['user_id'] as String,
        expDate: json['exp_date'] as String, 
        nickName: json['nickname'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
    } catch (e) {
      debugPrint('Error parsing PaymentCard: $e');
      rethrow; 
    }
  }

  // Secure display methods
  String get maskedNumber {
    if (cardNumber == null || cardNumber!.isEmpty) return '•••• •••• ••••';
    final last4 = cardNumber!.length >= 4 
        ? cardNumber!.substring(cardNumber!.length - 4)
        : cardNumber!;
    return '•••• •••• •••• $last4';
  }
}
