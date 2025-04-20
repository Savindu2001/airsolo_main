import 'package:airsolo/features/hostel/controllers/booking_controller.dart';
import 'package:airsolo/features/hostel/screens/hostel_checkout.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:airsolo/features/hostel/models/room_model.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';

class BookingScreen extends StatefulWidget {
  final Room room;

  const BookingScreen({super.key, required this.room});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final BookingController bookingController = Get.put(BookingController());
  final _formKey = GlobalKey<FormState>();
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _guests = 1;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _specialRequestsController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _specialRequestsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
          if (_checkOutDate != null && _checkOutDate!.isBefore(picked.add(const Duration(days: 1)))) {
            _checkOutDate = picked.add(const Duration(days: 1));
          }
        } else {
          if (picked.isAfter(_checkInDate ?? DateTime.now())) {
            _checkOutDate = picked;
          }
        }
      });
    }
  }

  double _calculateTotal() {
    if (_checkInDate == null || _checkOutDate == null) return 0.0;
    final days = _checkOutDate!.difference(_checkInDate!).inDays;
    return widget.room.pricePerPerson * _guests * days;
  }

void _submitBooking() async {
  // Validate form first
  if (!_formKey.currentState!.validate()) return;
  
  // Check dates are selected
  if (_checkInDate == null || _checkOutDate == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select check-in and check-out dates')),
    );
    return;
  }

  try {
    // Show loading indicator
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    // Get controller instance
    final bookingController = Get.find<BookingController>();
    
    // Create pending booking
    final booking = await bookingController.createPendingBooking(
      hostelId: widget.room.hostelId,
      roomId: widget.room.id,
      bedType: widget.room.bedType.name,
      checkInDate: _checkInDate!,
      checkOutDate: _checkOutDate!,
      numGuests: _guests,
      specialRequests: _specialRequestsController.text,
    );

    // Remove loading dialog
    Get.back();

    if (booking != null) {
      // Navigate to checkout screen with all required data
      Get.to(() => CheckoutScreen(
        room: widget.room,
        total: _calculateTotal(),
        checkInDate: _checkInDate!,
        checkOutDate: _checkOutDate!,
        guests: _guests,
      ));
    } else {
      Get.snackbar(
        'Error', 
        'Failed to create booking',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    // Ensure loading dialog is removed if error occurs
    if (Get.isDialogOpen!) Get.back();
    
    Get.snackbar(
      'Error',
      'Booking failed: ${e.toString()}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final dark = AHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Book ${widget.room.name}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ASizes.defaultSpace),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Room Summary
              _buildRoomSummary(dark),
              const SizedBox(height: ASizes.spaceBtwSections),

              // Booking Details
              Text('Booking Details', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: ASizes.spaceBtwItems),

              // Dates Selection
              Row(
                children: [
                  Expanded(
                    child: _buildDateField(
                      context: context,
                      label: 'Check-in',
                      date: _checkInDate,
                      onTap: () => _selectDate(context, true),
                    ),
                  ),
                  const SizedBox(width: ASizes.spaceBtwItems),
                  Expanded(
                    child: _buildDateField(
                      context: context,
                      label: 'Check-out',
                      date: _checkOutDate,
                      onTap: () => _selectDate(context, false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: ASizes.spaceBtwItems),

              // Guests Selection
              _buildGuestsSelector(),
              const SizedBox(height: ASizes.spaceBtwSections),

              // Personal Information
              Text('Personal Information', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: ASizes.spaceBtwItems),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: ASizes.spaceBtwItems),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your email';
                  if (!value.contains('@')) return 'Please enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: ASizes.spaceBtwItems),
              TextFormField(
                controller: _specialRequestsController,
                decoration: const InputDecoration(labelText: 'Special Requests (Optional)'),
                maxLines: 3,
              ),
              const SizedBox(height: ASizes.spaceBtwSections),

              // Price Summary
              _buildPriceSummary(),
              const SizedBox(height: ASizes.spaceBtwSections),

              // Book Now Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitBooking,
                  child: const Text('Confirm Booking'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoomSummary(bool dark) {
    return Container(
      padding: const EdgeInsets.all(ASizes.md),
      decoration: BoxDecoration(
        color: dark ? AColors.darkerGrey : AColors.light,
        borderRadius: BorderRadius.circular(ASizes.cardRadiusLg),
      ),
      child: Row(
        children: [
          // Room Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ASizes.cardRadiusMd),
              image: widget.room.images.isNotEmpty 
                ? DecorationImage(
                    image: NetworkImage(widget.room.images.first),
                    fit: BoxFit.cover,
                  )
                : const DecorationImage(
                    image: AssetImage(AImages.defaultRoomImage),
                    fit: BoxFit.cover,
                  ),
            ),
          ),
          const SizedBox(width: ASizes.spaceBtwItems),

          // Room Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.room.name, style: Theme.of(context).textTheme.titleLarge),
                Text(widget.room.typeDisplayName, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: ASizes.sm),
                Text(
                  '${widget.room.pricePerPerson.toStringAsFixed(2)}/person/night',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required BuildContext context,
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ASizes.inputFieldRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date != null 
                ? DateFormat('MMM dd, yyyy').format(date)
                : 'Select date',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Icon(Icons.calendar_today, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestsSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Guests', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: ASizes.sm),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                if (_guests > 1) {
                  setState(() => _guests--);
                }
              },
            ),
            Text('$_guests', style: Theme.of(context).textTheme.titleMedium),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                if (_guests < widget.room.maxOccupancy) {
                  setState(() => _guests++);
                }
              },
            ),
            const Spacer(),
            Text('Max ${widget.room.maxOccupancy} guests', 
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceSummary() {
    final total = _calculateTotal();
    final days = _checkInDate != null && _checkOutDate != null
        ? _checkOutDate!.difference(_checkInDate!).inDays
        : 0;

    return Container(
      padding: const EdgeInsets.all(ASizes.md),
      decoration: BoxDecoration(
        color: AColors.light.withOpacity(0.5),
        borderRadius: BorderRadius.circular(ASizes.cardRadiusMd),
        border: Border.all(color: AColors.grey),
      ),
      child: Column(
        children: [
          _buildPriceRow('Price per night', widget.room.formattedPrice),
          const Divider(),
          if (days > 0) _buildPriceRow('$days night${days > 1 ? 's' : ''}', '\$${(widget.room.pricePerPerson * days).toStringAsFixed(2)}'),
          if (_guests > 1) _buildPriceRow('$_guests guests', '\$${(widget.room.pricePerPerson * _guests * (days == 0 ? 1 : days)).toStringAsFixed(2)}'),
          const Divider(),
          _buildPriceRow(
            'Total',
            '\$${total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: ASizes.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: isTotal
                ? Theme.of(context).textTheme.titleLarge?.copyWith(color: AColors.primary)
                : Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}