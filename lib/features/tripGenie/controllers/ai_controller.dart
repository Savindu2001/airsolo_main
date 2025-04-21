import 'package:airsolo/config.dart';
import 'package:airsolo/features/tripGenie/models/place_guide_model.dart';
import 'package:airsolo/features/tripGenie/models/trip_plan_model.dart';
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

  Future<void> getPlaceGuide(String location) async {
    try {
      isLoading(true);
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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        placeGuide(PlaceGuide.fromJson(data['guideDetails']));
      } else {
        throw Exception('Failed to fetch guide: ${response.statusCode}');
      }
    } catch (e) {
      error(e.toString());
      ALoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> getTripPlan({
    required String startCity,
    required DateTime startDate,
    required DateTime endDate,
    required String tripType,
    required int numberOfGuest,
  }) async {
    try {
      isLoading(true);
      error('');

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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        tripPlan(TripPlan.fromJson({
          ...data['tripDetails'],
          'startCity': startCity,
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
          'tripType': tripType,
          'numberOfGuest': numberOfGuest,
        }));
      } else {
        throw Exception('Failed to fetch trip plan: ${response.statusCode}');
      }
    } catch (e) {
      error(e.toString());
      ALoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading(false);
    }
  }
}