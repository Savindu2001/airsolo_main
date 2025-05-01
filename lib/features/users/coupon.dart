import 'package:airsolo/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CouponPage extends StatelessWidget {
  final TextEditingController _couponController = TextEditingController();
  final RxString _enteredCoupon = ''.obs;
  final RxBool _isApplying = false.obs;

  // Dummy coupon data
  final List<Map<String, dynamic>> _availableCoupons = [
    {
      'code': 'WELCOME20',
      'discount': '20%',
      'description': 'Get 20% off on your first ride',
      'validUntil': '2023-12-31',
      'isApplied': false.obs,
    },
    {
      'code': 'FREESHIP',
      'discount': '\$5',
      'description': 'Flat \$5 discount on all rides',
      'validUntil': '2023-11-30',
      'isApplied': false.obs,
    },
    {
      'code': 'WEEKEND25',
      'discount': '25%',
      'description': '25% off on weekend rides',
      'validUntil': '2023-12-15',
      'isApplied': false.obs,
    },
    {
      'code': 'SAFE10',
      'discount': '10%',
      'description': '10% off on all rides',
      'validUntil': '2023-12-31',
      'isApplied': false.obs,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Promo Codes', style: Get.textTheme.headlineMedium,),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Coupon Input Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Enter Promo Code',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Obx(
                      () => TextField(
                        controller: _couponController,
                        decoration: InputDecoration(
                          hintText: 'Enter coupon code',
                          border: OutlineInputBorder(),
                          suffixIcon: _enteredCoupon.value.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    _couponController.clear();
                                    _enteredCoupon.value = '';
                                  },
                                )
                              : null,
                        ),
                        onChanged: (value) => _enteredCoupon.value = value,
                      ),
                    ),
                    SizedBox(height: 16),
                    Obx(
                      () => ElevatedButton(
                        onPressed: _enteredCoupon.value.isEmpty || _isApplying.value
                            ? null
                            : () => _applyCoupon(_enteredCoupon.value),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AColors.primary,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:  Text('Apply Coupon'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            // Available Coupons List
            Text(
              'Available Promo Codes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _availableCoupons.length,
                itemBuilder: (context, index) {
                  final coupon = _availableCoupons[index];
                  return Obx(
                    () => CouponCard(
                      code: coupon['code'],
                      discount: coupon['discount'],
                      description: coupon['description'],
                      validUntil: coupon['validUntil'],
                      isApplied: coupon['isApplied'].value,
                      onApply: () => _applyCoupon(coupon['code']),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _applyCoupon(String couponCode) {
    _isApplying.value = true;
    
    // Simulate API call delay
    Future.delayed(Duration(seconds: 1), () {
      _isApplying.value = false;
      
      // Find the coupon in the list and mark it as applied
      for (var coupon in _availableCoupons) {
        if (coupon['code'] == couponCode) {
          coupon['isApplied'].value = true;
          break;
        }
      }
      
      Get.snackbar(
        'Success',
        'Coupon $couponCode applied successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Clear the input field if it matches
      if (_couponController.text == couponCode) {
        _couponController.clear();
        _enteredCoupon.value = '';
      }
    });
  }
}

class CouponCard extends StatelessWidget {
  final String code;
  final String discount;
  final String description;
  final String validUntil;
  final bool isApplied;
  final VoidCallback onApply;

  const CouponCard({
    required this.code,
    required this.discount,
    required this.description,
    required this.validUntil,
    required this.isApplied,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isApplied ? AColors.primary : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    code,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AColors.warning,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    discount,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AColors.homePrimary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Valid until: $validUntil',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: isApplied ? null : onApply,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40),
                backgroundColor: isApplied ? Colors.green : AColors.primary,
                foregroundColor: Colors.white,
                
              ),
              child: Text(
                isApplied ? 'Applied' : 'Apply Now',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}