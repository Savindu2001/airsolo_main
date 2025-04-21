import 'package:airsolo/features/hostel/controllers/booking_controller.dart';
import 'package:airsolo/features/hostel/screens/hostel_checkout.dart';
import 'package:airsolo/features/users/user_controller.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
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
  final _formKey = GlobalKey<FormState>();
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _guests = 1;
  final TextEditingController _specialRequestsController = TextEditingController();

  // Get controllers
  final BookingController bookingController = Get.find<BookingController>();
  final UserController userController = Get.find<UserController>();

  @override
  void dispose() {
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

  Future<void> _submitBooking() async {
  if (!_formKey.currentState!.validate()) return;
  
  if (_checkInDate == null || _checkOutDate == null) {
    Get.snackbar('Error', 'Please select check-in and check-out dates');
    return;
  }

  try {
    AFullScreenLoader.openLoadingDialog('Processing Booking', AImages.loading);
    
    print('Creating booking with data:');
    print({
      'room': widget.room.id,
      'checkIn': _checkInDate?.toIso8601String(),
      'checkOut': _checkOutDate?.toIso8601String(),
      'guests': _guests,
    });

    final booking = await bookingController.createPendingBooking(
      hostelId: widget.room.hostelId,
      userId: userController.currentUser!.id,
      roomId: widget.room.id,
      bedType: widget.room.bedType.name,
      checkInDate: _checkInDate!,
      checkOutDate: _checkOutDate!,
      numGuests: _guests,
      amount: _calculateTotal(),
      specialRequests: _specialRequestsController.text,
    );

    AFullScreenLoader.stopLoading();

    if (booking == null) {
      throw Exception('Booking creation failed - please try again');
    }

    print('Booking created successfully. ID: ${booking.id}');
    
    
    Get.off(() => CheckoutScreen(
      room: widget.room,
      checkInDate: _checkInDate!,
      checkOutDate: _checkOutDate!,
      guests: _guests,
      total: _calculateTotal(),
      bookingId: booking.id,
    ));
    
  } catch (e, stack) {
    AFullScreenLoader.stopLoading();
    print('Booking error: $e');
    print('Stack trace: $stack');
    
    Get.snackbar(
      'Booking Failed', 
      e.toString(),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
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
              // Name Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Iconsax.personalcard, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Full Name', style: Theme.of(context).textTheme.labelSmall),
                            Text(
                              userController.currentUser!.fullName,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: ASizes.spaceBtwItems),

                // Email Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Iconsax.attach_circle, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email', style: Theme.of(context).textTheme.labelSmall),
                            Text(
                              userController.currentUser!.email,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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