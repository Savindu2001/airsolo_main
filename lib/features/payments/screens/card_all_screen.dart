import 'dart:async';

import 'package:airsolo/features/payments/controllers/card_controller.dart';
import 'package:airsolo/features/payments/models/card_model.dart';
import 'package:airsolo/features/payments/screens/card_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CardHomePage extends StatelessWidget {
  const CardHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PaymentCardController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wallet'),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => const CardAddPage()),
            icon: const Icon(Iconsax.add, size: 32),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.error.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.error.value),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchUserCards,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.paymentCardDetails.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.credit_card, size: 48, color: Colors.grey),
                SizedBox(height: 16),
                Text('No cards added'),
                SizedBox(height: 8),
                Text('Tap + to add a new card', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 8),
            ...controller.paymentCardDetails.map((card) {
              return _buildDismissibleCard(context, controller, card);
            }),
          ],
        );
      }),
    );
  }

Widget _buildDismissibleCard(BuildContext context, PaymentCardController controller, PaymentCard card) {
  return Dismissible(
    key: Key(card.id),
    direction: DismissDirection.endToStart,
    background: Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(Icons.delete, color: Colors.white, size: 40),
    ),
    confirmDismiss: (direction) async {
      // Use a Completer to wait for bottom sheet result
      final completer = Completer<bool>();
      
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.credit_card_off, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                "Delete ${card.nickName ?? 'Card'}?",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                "Are you sure you want to delete this payment method?",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        completer.complete(false);
                        Navigator.pop(context);
                      },
                      child: const Text("CANCEL"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        completer.complete(true);
                        Navigator.pop(context);
                      },
                      child: const Text("DELETE"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
      
      return await completer.future;
    },
    onDismissed: (direction) {
      controller.deleteCard(card.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${card.nickName ?? 'Card'} deleted"),
          action: SnackBarAction(
            label: "UNDO",
            onPressed: () {
              // TODO: Implement undo functionality
            },
          ),
        ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: _CreditCardWidget(card: card),
    ),
  );
}
}

class _CreditCardWidget extends StatelessWidget {
  final PaymentCard card;

  const _CreditCardWidget({required this.card});

  @override
  Widget build(BuildContext context) {
    final cardColors = _getCardColors(card.cardType);
    
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: cardColors,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Card background elements
          Positioned(
            top: 20,
            right: 20,
            child: _buildCardTypeIcon(card.cardType),
          ),
          
          // Card content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Card nickname
                Text(
                  card.nickName ?? 'My Card',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                // Card number
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    card.maskedNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                // Bottom row (expiry date and card type)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Expiry date
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Expiry Date',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          card.expDate,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    
                    // Card type
                    Text(
                      card.cardType.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardTypeIcon(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'visa':
        return Image.asset('assets/images/icons/visa.jpeg', height: 40);
      case 'mastercard':
        return Image.asset('assets/images/icons/mster.jpeg', height: 40);
      case 'american express':
        return Image.asset('assets/images/icons/americalexp.png', height: 40);
      case 'discover':
        return Image.asset('assets/images/icons/discover.png', height: 40);
      case 'jcb':
        return Image.asset('assets/images/icons/jcb.png', height: 40);
      case 'diners club':
        return Image.asset('assets/images/icons/dinner.png', height: 40);
      case 'unionpay':
        return Image.asset('assets/images/icons/unionpay.png', height: 40);
      default:
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.credit_card, color: Colors.white),
        );
    }
  }

  List<Color> _getCardColors(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'visa':
        return [const Color(0xFF1A1F71), const Color(0xFFF79E1B)];
      case 'mastercard':
        return [const Color(0xFFEB001B), const Color(0xFFF79E1B)];
      case 'amex':
        return [const Color(0xFF002663), const Color(0xFF0070C2)];
      default:
        return [Colors.deepPurple, Colors.indigo];
    }
  }
}