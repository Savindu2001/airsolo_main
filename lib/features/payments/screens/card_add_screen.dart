import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:airsolo/features/payments/controllers/card_controller.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/constants/texts.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/services.dart';

class CardAddPage extends StatelessWidget {
  const CardAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cardController = Get.put(PaymentCardController());
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Card', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(ASizes.defaultSpace),
          child: Form(
            key: cardController.cardFormKey,
            child: Column(
              children: [
                // Card Number Field with Formatting
                TextFormField(
                  controller: cardController.cardNumber,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(19),
                    CardNumberInputFormatter(),
                  ],
                  decoration: InputDecoration(
                    labelText: ATexts.cardNumber,
                    hintText: '1234 5678 9012 3456',
                    prefixIcon: const Icon(Iconsax.card),
                    suffixIcon: IconButton(
                      onPressed: () => _scanCard(cardController), 
                      icon: const Icon(Iconsax.scan)
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Card number is required';
                    if (value.replaceAll(' ', '').length < 13) return 'Invalid card number';
                    return null;
                  },
                ),
                
                const SizedBox(height: ASizes.spaceBtwinputFields),
                
                // Expiration Date and CVV Row
                Row(
                  children: [
                    // Expiration Date Field
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: cardController.expDate,
                        decoration: const InputDecoration(
                          labelText: 'Exp Date',
                          hintText: 'MM/YYYY',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: () => _openMonthYearPicker(context, cardController),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Expiration date is required';
                          return null;
                        },
                      ),
                    ),
                    
                    const SizedBox(width: ASizes.spaceBtwinputFields),
                    
                    // CVV Field
                    Expanded(
                      child: TextFormField(
                        controller: cardController.cvv,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        decoration: const InputDecoration(
                          labelText: ATexts.cvv,
                          hintText: '123',
                          prefixIcon: Icon(Iconsax.lock)
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'CVV is required';
                          if (value.length < 3 || value.length > 4) return 'Invalid CVV';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: ASizes.spaceBtwinputFields),

                // Card Type Dropdown
                DropdownButtonFormField<String>(
                  value: cardController.cardType.text.isNotEmpty 
                      ? cardController.cardType.text 
                      : null,
                  items: const [
                    'Visa', 
                    'MasterCard', 
                    'American Express', 
                    'Discover', 
                    'Diners Club', 
                    'JCB', 
                    'UnionPay'
                  ].map<DropdownMenuItem<String>>((cardType) => DropdownMenuItem(
                    value: cardType,
                    child: Text(cardType),
                  )).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      cardController.cardType.text = value;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: ATexts.cardType,
                    hintText: 'Select card type',
                    prefixIcon: Icon(Iconsax.blend),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Card type is required';
                    return null;
                  },
                ),

                const SizedBox(height: ASizes.spaceBtwinputFields),

                // Card Nickname
                TextFormField(
                  controller: cardController.nickName,
                  decoration: const InputDecoration(
                    labelText: ATexts.nickName,
                    hintText: 'e.g. My Primary Card',
                    prefixIcon: Icon(Iconsax.note),
                  ),
                ),

                const SizedBox(height: ASizes.spaceBtwSections),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child:  ElevatedButton(
                    onPressed: () => cardController.addCard(),
                    child: const Text(ATexts.save),
                  )),
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openMonthYearPicker(BuildContext context, PaymentCardController controller) {
    final now = DateTime.now();
    
    BottomPicker.monthYear(
      pickerTitle: const Text('Select Expiration Date'),
      minDateTime: now,
      maxDateTime: DateTime(now.year + 10),
      initialDateTime: now,
      onSubmit: (date) {
        controller.expDate.text = 
          '${date.month.toString().padLeft(2, '0')}/${date.year}';
      },
      bottomPickerTheme: BottomPickerTheme.plumPlate,
    ).show(context);
  }

  Future<void> _scanCard(PaymentCardController controller) async {
    
    controller.cardNumber.text = '4242 4242 4242 4242';
    controller.expDate.text = '12/2025';
    controller.cvv.text = '123';
    controller.cardType.text = 'Visa';
    controller.nickName.text = 'world bank card';
    
    Get.snackbar(
      'Card Scanned',
      'Demo card details added',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

// Custom formatter for card number input
class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    var buffer = StringBuffer();
    
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i != text.length - 1) {
        buffer.write(' ');
      }
    }
    
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}