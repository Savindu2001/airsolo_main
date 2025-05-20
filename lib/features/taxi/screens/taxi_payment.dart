import 'package:airsolo/features/taxi/models/taxi_booking_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';

class TaxiPaymentScreen extends StatefulWidget {
  const TaxiPaymentScreen({super.key});

  @override
  State<TaxiPaymentScreen> createState() => _TaxiPaymentScreenState();
}

class _TaxiPaymentScreenState extends State<TaxiPaymentScreen> {
  final TaxiBooking booking = Get.arguments as TaxiBooking;
  String _selectedPaymentMethod = 'cash';
  bool _isProcessingPayment = false;
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardNameController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? AColors.white : AColors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip Summary
            _buildTripSummaryCard(),
            const SizedBox(height: 24),
            
            // Payment Method Selection
            Text('Select Payment Method', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildPaymentMethodCard(),
            const SizedBox(height: 24),
            
            // Card Details (only shown when PayHere is selected)
            if (_selectedPaymentMethod == 'payhere') _buildCardDetailsForm(),
            
            // Pay Now Button
            const SizedBox(height: 24),
            _buildPayNowButton(),
            const SizedBox(height: 16),
            
            // Cancel Button
            if (!_isProcessingPayment) _buildCancelButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTripSummaryCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Trip Summary', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildSummaryRow('Pickup:', booking.pickupLocation),
            _buildSummaryRow('Drop-off:', booking.dropLocation),
            _buildSummaryRow('Vehicle:', booking.assignedVehicle?.model ?? 'Standard'),
            const Divider(height: 24),
            _buildSummaryRow('Base Fare:', 'LKR ${booking.totalPrice.toStringAsFixed(2) ?? '0.00'}'),
            _buildSummaryRow('Distance Fare:', 'LKR ${booking.totalPrice.toStringAsFixed(2) ?? '0.00'}'),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Amount:', style: Theme.of(context).textTheme.titleMedium),
                Text('LKR ${booking.totalPrice?.toStringAsFixed(2) ?? '0.00'}', 
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AColors.primary,
                  )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard() {
    return Card(
      child: Column(
        children: [
          RadioListTile<String>(
            title: const Row(
              children: [
                Icon(Icons.money, color: Colors.green),
                SizedBox(width: 8),
                Text('Cash Payment'),
              ],
            ),
            value: 'cash',
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value!;
              });
            },
          ),
          const Divider(height: 1),
          RadioListTile<String>(
            title: const Row(
              children: [
                Icon(Icons.credit_card, color: Colors.blue),
                SizedBox(width: 8),
                Text('PayHere (Card)'),
              ],
            ),
            value: 'payhere',
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCardDetailsForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Card Details', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: _cardNumberController,
              decoration: const InputDecoration(
                labelText: 'Card Number',
                hintText: '1234 5678 9012 3456',
                prefixIcon: Icon(Icons.credit_card),
              ),
              keyboardType: TextInputType.number,
              maxLength: 16,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _expiryController,
                    decoration: const InputDecoration(
                      labelText: 'Expiry Date',
                      hintText: 'MM/YY',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    keyboardType: TextInputType.datetime,
                    maxLength: 5,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _cvvController,
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      hintText: '123',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    obscureText: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cardNameController,
              decoration: const InputDecoration(
                labelText: 'Cardholder Name',
                hintText: 'John Doe',
                prefixIcon: Icon(Icons.person),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayNowButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isProcessingPayment ? null : _processPayment,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: AColors.primary,
          disabledBackgroundColor: Colors.grey,
        ),
        child: _isProcessingPayment
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                _selectedPaymentMethod == 'cash' ? 'PAY WITH CASH' : 'PAY WITH CARD',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => Get.back(),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: Colors.red),
        ),
        child: const Text(
          'CANCEL',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> _processPayment() async {
    if (_selectedPaymentMethod == 'payhere') {
      // Validate card details for PayHere payment
      if (_cardNumberController.text.length != 16 ||
          _expiryController.text.length != 5 ||
          _cvvController.text.length != 3 ||
          _cardNameController.text.isEmpty) {
        Get.snackbar('Error', 'Please enter valid card details');
        return;
      }
    }

    setState(() => _isProcessingPayment = true);

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isProcessingPayment = false);

    // Show payment success dialog
    _showPaymentSuccessDialog();
  }

  void _showPaymentSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Payment Successful'),
          ],
        ),
        content: Text(
          'Your payment of LKR ${booking.totalPrice?.toStringAsFixed(2)} has been processed successfully.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Update booking status to completed
              // Navigate back to home or booking completion screen
              Get.offAllNamed('/home');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}