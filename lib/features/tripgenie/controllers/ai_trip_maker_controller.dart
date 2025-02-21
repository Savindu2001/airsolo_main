import 'package:airsolo/features/tripgenie/models/ai_trip_maker_model.dart';
import 'package:flutter/material.dart';

class TripMakerController {
  final TripMakerModel model = TripMakerModel();
  final TextEditingController destinationController = TextEditingController();

  TripMakerController() {
    destinationController.text = model.destination;
  }

  DateTime? get startDate => model.startDate;
  DateTime? get endDate => model.endDate;
  int get guests => model.guests;
  String get travelPreference => model.travelPreference;
  List<String> get preferences => model.preferences;

  void updateDateRange(DateTime start, DateTime end) {
    model.updateDateRange(start, end);
  }

  void increaseGuests() {
    model.increaseGuests();
  }

  void decreaseGuests() {
    model.decreaseGuests();
  }

  void updatePreference(String preference) {
    model.updatePreference(preference);
  }

  void generateTrip() {

    print("Generating AI Trip Plan for ${model.destination}, ( ${model.startDate} ${model.endDate} ) ${model.guests} guests, ${model.travelPreference} preference.");

    
  }
}
