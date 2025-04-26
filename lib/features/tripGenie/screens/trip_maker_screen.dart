import 'package:airsolo/features/tripGenie/controllers/ai_controller.dart';
import 'package:airsolo/features/tripGenie/screens/results_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:airsolo/utils/constants/colors.dart';

class TripMakerScreen extends StatefulWidget {
  const TripMakerScreen({super.key});

  @override
  State<TripMakerScreen> createState() => _TripMakerScreenState();
}

class _TripMakerScreenState extends State<TripMakerScreen> {
  final controller = Get.put(AIController());
  final _formKey = GlobalKey<FormState>();
  final _startCityController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String _tripType = 'Leisure';
  int _numberOfGuest = 1;

  final List<String> tripTypes = [
    'Leisure',
    'Business',
    'Adventure',
    'Family',
    'Romantic',
    'Solo',
  ];

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TripGenie Maker'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Plan your perfect trip with TripGenie',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _startCityController,
                decoration: InputDecoration(
                  labelText: 'Start City',
                  prefixIcon: const Icon(Iconsax.location),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Where are you traveling from?',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a city';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, true),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Start Date',
                          prefixIcon: const Icon(Iconsax.calendar_1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          _startDate != null
                              ? DateFormat('MMM dd, yyyy').format(_startDate!)
                              : 'Select date',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: _startDate == null
                          ? null
                          : () => _selectDate(context, false),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'End Date',
                          prefixIcon: const Icon(Iconsax.calendar_1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300),
                          ),
                        ),
                        child: Text(
                          _endDate != null
                              ? DateFormat('MMM dd, yyyy').format(_endDate!)
                              : 'Select date',
                          style: TextStyle(
                            color: _startDate == null
                                ? Colors.grey.shade400
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _tripType,
                decoration: InputDecoration(
                  labelText: 'Trip Type',
                  prefixIcon: const Icon(Iconsax.tag),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: tripTypes
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _tripType = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _numberOfGuest.toString(),
                decoration: InputDecoration(
                  labelText: 'Number of Guests',
                  prefixIcon: const Icon(Iconsax.people),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _numberOfGuest = int.tryParse(value) ?? 1;
                  });
                },
              ),
              const SizedBox(height: 30),
              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                          if (_formKey.currentState!.validate() &&
                              _startDate != null &&
                              _endDate != null) {
                            await controller.getTripPlan(
                              startCity: _startCityController.text,
                              startDate: _startDate!,
                              endDate: _endDate!,
                              tripType: _tripType,
                              numberOfGuest: _numberOfGuest,
                            );
                            if (controller.tripPlan.value != null) {
                              Get.to(() => ResultsScreen(
                                title: 'Trip Plan for ${_startCityController.text}',
                                content: controller.tripPlan.value!.tripDetails,
                              ));
                            }
                          } else {
                            Get.snackbar(
                              'Error',
                              'Please fill all fields',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AColors.secondary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Generate My Trip Plan',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}