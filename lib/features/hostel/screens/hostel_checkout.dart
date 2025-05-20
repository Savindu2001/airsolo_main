import 'dart:async';
import 'package:airsolo/features/services/payhere_service.dart';
import 'package:airsolo/features/users/user_controller.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:airsolo/features/hostel/models/room_model.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class CheckoutScreen extends StatelessWidget {
  final Room room;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int guests;
  final double total;
  final String bookingId;

  const CheckoutScreen({
    super.key,
    required this.room,
    required this.checkInDate,
    required this.checkOutDate,
    required this.guests,
    required this.total,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Payment')),
      body: Padding(
        padding: const EdgeInsets.all(ASizes.defaultSpace),
        child: Column(
          children: [
            // Booking Summary
            _buildBookingSummary(),
            const SizedBox(height: ASizes.spaceBtwSections),
            
            // Payment Options
            _buildPaymentOptions(),
            const Spacer(),
            
            // Pay Now Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handlePayment,
                child: const Text('Pay Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingSummary() {
    final days = checkOutDate.difference(checkInDate).inDays;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ASizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Booking Summary', style: Get.textTheme.headlineSmall),
            const Divider(),
            _buildSummaryRow('Room', room.name),
            _buildSummaryRow('Check-in', DateFormat('MMM dd, yyyy').format(checkInDate)),
            _buildSummaryRow('Check-out', DateFormat('MMM dd, yyyy').format(checkOutDate)),
            _buildSummaryRow('Guests', guests.toString()),
            _buildSummaryRow('Nights', days.toString()),
            const Divider(),
            _buildSummaryRow(
              'Total',
              '\$${total.toStringAsFixed(2)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: ASizes.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Get.textTheme.bodyMedium),
          Text(
            value,
            style: isTotal
                ? Get.textTheme.titleLarge?.copyWith(color: AColors.primary)
                : Get.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Methods', style: Get.textTheme.headlineSmall),
        const SizedBox(height: ASizes.spaceBtwItems),
        // PayHere payment option
        ListTile(
          leading: const Icon(Iconsax.money, color: AColors.primary),
          title: const Text('PayHere'),
          subtitle: const Text('Secure online payments'),
          onTap: _handlePayment,
          
        ),
        const ListTile(
          leading:  Icon(Iconsax.money, color: AColors.success),
          title:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Cash '),
              Text('Coming Soon!', style: TextStyle(color: Colors.red),)
            ],
          ),
          subtitle: Text('Pay by Cash to hostel  / Taxi'),
           
          
        ),
        
       
        // Add more payment options as needed
      ],
    );
  }



Future<void> _handlePayment() async {
  await Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(ASizes.defaultSpace),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Select Payment Method', style: Get.textTheme.headlineSmall),
          const SizedBox(height: ASizes.spaceBtwItems),
          
          // Card Payment Option
          _buildPaymentOption(
            icon: Icons.credit_card,
            title: 'Pay with Card',
            subtitle: 'Secure payment via PayHere',
            onTap: () => _processCardPayment(),
          ),
          
          const SizedBox(height: ASizes.spaceBtwItems),
          
          // Cash Payment Option
          _buildPaymentOption(
            icon: Icons.money,
            title: 'Pay with Cash',
            subtitle: 'Pay at the hostel reception',
            onTap: () => _processCashPayment(),
          ),
          
          const SizedBox(height: ASizes.spaceBtwSections),
          
          // Cancel Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}

Widget _buildPaymentOption({
  required IconData icon,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return Card(
    child: ListTile(
      leading: Icon(icon, color: AColors.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    ),
  );
}


Future<void> _processCardPayment() async {
  try {
    Get.back(); // Close the bottom sheet
    
    // Show confirmation dialog
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Confirm Card Payment'),
        content: const Text('You will be redirected to PayHere to complete your payment. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    AFullScreenLoader.openLoadingDialog('Processing Payment', AImages.paymentSuccess);

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    // Initialize PayHere payment (real implementation)
    final userController = Get.find<UserController>();
    await PayHereService.initiatePayment(
      amount: total,
      bookingId: bookingId,
      customerName: userController.currentUser!.fullName,
      customerEmail: userController.currentUser!.email,
    );

    AFullScreenLoader.stopLoading();
    _navigateToSuccessScreen();

  } catch (e) {
    AFullScreenLoader.stopLoading();
    Get.snackbar('Error', 'Payment failed: ${e.toString()}');
  }
}

Future<void> _processCashPayment() async {
  Get.back(); // Close the bottom sheet
  
  // Show confirmation dialog
  final confirm = await Get.dialog<bool>(
    AlertDialog(
      title: const Text('Confirm Cash Payment'),
      content: const Text('You will need to pay the amount at the hostel reception. Continue?'),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Get.back(result: true),
          child: const Text('Confirm'),
        ),
      ],
    ),
  );

  if (confirm != true) return;

  AFullScreenLoader.openLoadingDialog('Processing Request', AImages.paymentSuccess);
  
  // Simulate processing
  await Future.delayed(const Duration(seconds: 2));
  
  AFullScreenLoader.stopLoading();
  _navigateToSuccessScreen();
}

void _navigateToSuccessScreen() {
  Get.offAllNamed('/payment-success', arguments: {
    'bookingId': bookingId,
    'amount': total,
    'paymentMethod': 'Card', // or 'Cash' depending on which was selected
    'room': room,
    'checkInDate': checkInDate,
    'checkOutDate': checkOutDate,
  });
}

}