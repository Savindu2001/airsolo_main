import 'dart:convert';
import 'package:airsolo/config.dart';
import 'package:airsolo/features/activity/activity_model.dart';
import 'package:airsolo/features/city/model/city_model.dart';
import 'package:airsolo/features/city/controller/city_controller.dart';
import 'package:airsolo/utils/helpers/network_manager.dart';
import 'package:airsolo/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ActivityEventController extends GetxController {
  final RxList<ActivityEvent> activities = <ActivityEvent>[].obs;
  final RxList<ActivityEvent> filteredActivities = <ActivityEvent>[].obs;

  final RxList<City> cities = <City>[].obs;
  final RxList<String> activityTypes = <String>[].obs;

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  final RxString selectedCityId = ''.obs;
  final RxString selectedActivityType = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchActivities();
    loadFilterOptions();
  }

  Future<void> fetchActivities() async {
    try {
      isLoading(true);
      error('');

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        error('No internet connection');
        ALoaders.errorSnackBar(
          title: 'Connection Error',
          message: 'Check your internet connection',
        );
        return;
      }

      final token = await _getValidToken();
      if (token == null) {
        throw Exception('Authentication required');
      }

      final response = await http.get(
        Uri.parse(Config.activityEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        activities.assignAll(
          data.map((json) => ActivityEvent.fromJson(json)).toList(),
        );
        applyFilters(); // Apply filters if any
      } else {
        throw Exception('Failed to load activities: ${response.statusCode}');
      }
    } catch (e) {
      error(e.toString());
      ALoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to fetch activities',
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadFilterOptions() async {
    try {
      final cityController = Get.find<CityController>();
      if (cityController.cities.isEmpty) {
        await cityController.fetchCities();
      }
      cities.assignAll(cityController.cities);

      // Add your fixed activity types
      activityTypes.assignAll([
        'DJ Party',
        'Hike',
        'BBQ Night',
        'Dancing',
        'Concert',
        'Workshop',
        'Theater',
        'Food Festival',
        'Cultural Event',
        'Sports Event',
        'Outdoor Movie Night',
        'Art Exhibition',
        'Live Music',
        'Wellness Retreat',
        'Market Tour',
        'Photography Walk',
      ]);
    } catch (e) {
      ALoaders.errorSnackBar(title: 'Error', message: 'Failed to load filter options');
    }
  }

  void applyFilters({String? cityId, String? type}) {
    if (cityId != null) selectedCityId.value = cityId;
    if (type != null) selectedActivityType.value = type;

    final filtered = activities.where((activity) {
      final matchesCity =
          selectedCityId.value.isEmpty || activity.cityId == selectedCityId.value;
      final matchesType =
          selectedActivityType.value.isEmpty || activity.activityType == selectedActivityType.value;
      return matchesCity && matchesType;
    }).toList();

    filteredActivities.assignAll(filtered);
  }

  void resetFilters() {
    selectedCityId.value = '';
    selectedActivityType.value = '';
    filteredActivities.assignAll(activities);
  }

  Future<String?> _getValidToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwtToken');
  }
}
