import 'package:airsolo/config.dart';
import 'package:airsolo/features/tripGenie/models/place_guide_model.dart';
import 'package:airsolo/features/tripGenie/models/trip_plan_model.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:airsolo/utils/helpers/network_manager.dart';
import 'package:airsolo/utils/popups/loaders.dart';

class AIController extends GetxController {
  static AIController get instance => Get.find();

  final Rx<PlaceGuide?> placeGuide = Rx<PlaceGuide?>(null);
  final Rx<TripPlan?> tripPlan = Rx<TripPlan?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwtToken');
  }




// Update getPlaceGuide method
Future<void> getPlaceGuide(String location) async {
  try {
    AFullScreenLoader.openLoadingDialog(location, AImages.loading);
    error('');

    final isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) throw Exception('No internet connection');

    final token = await _getToken();
    if (token == null) throw Exception('Authentication required');

    final response = await http.post(
      Uri.parse('${Config.tripGenieEndpoint}/guide'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'currentLocation': location}),
    ).timeout(const Duration(seconds: 30));

    final data = jsonDecode(response.body);
    debugPrint('Parsed data: $data');
    
    if (response.statusCode == 200) {
      AFullScreenLoader.stopLoading();
      // Updated to match backend response structure
      placeGuide.value = PlaceGuide(
        location: location,
        guideDetails: data['guideDetails']['guideDetails'] ?? 'No guide available',
        timestamp: DateTime.now(),
      );
      debugPrint('Updated placeGuide: ${placeGuide.value?.guideDetails}');
    } else {
      AFullScreenLoader.stopLoading();
      throw Exception(data['message'] ?? 'Failed to fetch guide');
    }
  } catch (e) {
    error(e.toString());
    ALoaders.errorSnackBar(title: 'Error', message: e.toString());
  } finally {
    AFullScreenLoader.stopLoading();
    
  }
}

// Update getTripPlan method
Future<void> getTripPlan({
  required String startCity,
  required DateTime startDate,
  required DateTime endDate,
  required String tripType,
  required int numberOfGuest,
}) async {
  try {
    error('');
    AFullScreenLoader.openLoadingDialog('Generating your trip...', AImages.loading);

    final isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) throw Exception('No internet connection');

    final token = await _getToken();
    if (token == null) throw Exception('Authentication required');

    final response = await http.post(
      Uri.parse('${Config.tripGenieEndpoint}/trip'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'startCity': startCity,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'tripType': tripType,
        'numberOfGuest': numberOfGuest,
      }),
    ).timeout(const Duration(seconds: 30));

    final data = jsonDecode(response.body);
    debugPrint('Raw API response: ${response.body}');

    if (response.statusCode == 200) {
      AFullScreenLoader.stopLoading();
      // Handle both string and list responses
      dynamic tripDetails = data['tripDetails'];
      String formattedDetails = '';
      
      if (tripDetails is List) {
        formattedDetails = tripDetails.map((item) => item.toString()).join('\n\n');
      } else if (tripDetails is Map) {
        formattedDetails = tripDetails.entries
            .map((e) => '${e.key}: ${e.value}')
            .join('\n\n');
      } else {
        formattedDetails = tripDetails?.toString() ?? '';
      }

      tripPlan(TripPlan.fromJson({
        'startCity': startCity,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'tripType': tripType,
        'numberOfGuest': numberOfGuest,
        'tripDetails': formattedDetails,
        'timestamp': DateTime.now().toIso8601String(),
      }));
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch trip plan');
    }
  } catch (e) {
    error(e.toString());
    ALoaders.errorSnackBar(
      title: 'Error',
      message: e.toString().replaceAll('Exception: ', ''),
    );
  } finally {
    isLoading(false);
    AFullScreenLoader.stopLoading();
  }
}




}