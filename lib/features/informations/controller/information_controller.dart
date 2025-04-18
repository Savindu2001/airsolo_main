import 'dart:async';
import 'package:airsolo/config.dart';
import 'package:airsolo/data/repositories/authentication/authentication_repository.dart';
import 'package:airsolo/features/city/controller/city_controller.dart';
import 'package:airsolo/features/city/model/city_model.dart';
import 'package:airsolo/features/informations/model/information_model.dart';
import 'package:airsolo/utils/helpers/network_manager.dart';
import 'package:airsolo/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class InformationController extends GetxController {
  static InformationController get instance => Get.find();

  final RxList<Information> informations = <Information>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxInt retryCount = 0.obs;
  final int maxRetries = 2;
  final RxString selectedCityId = ''.obs;
  final RxString selectedInfoType = ''.obs;
  final RxList<City> cities = <City>[].obs;
  final RxList<String> infoTypes = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchInformations();  
    loadFilterOptions();
  }

  // Fetch informations from API
  Future<void> fetchInformations({bool isRetry = false}) async {
    try {
      // Check network connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        error('No internet connection');
        isLoading(false);
        return;
      }

      // Initialize loading state if not a retry
      if (!isRetry) {
        isLoading(true);
        error('');
        retryCount.value = 0;
      }

      // Get authentication token
      final token = await _getValidToken();
      if (token == null) {
        throw Exception('Authentication required');
      }

      // Make API request
      final response = await http.get(
        Uri.parse(Config.informationEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      // Handle API response
      _handleResponse(response);
    } on http.ClientException catch (e) {
      _handleNetworkError(e);
    } on TimeoutException catch (e) {
      _handleTimeoutError(e);
    } catch (e) {
      _handleGenericError(e);
    } finally {
      isLoading(false);
    }
  }

  // Get valid authentication token
  Future<String?> _getValidToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwtToken');
  }

  // Handle API response
  void _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      informations.assignAll(
        data.map((infoJson) => Information.fromJson(infoJson as Map<String, dynamic>)).toList()
      );
      
    } else if (response.statusCode == 401 && retryCount.value < maxRetries) {
      _handleUnauthorizedError();
    } else {
      throw Exception('Failed to load informations: ${response.statusCode}');
    }
  }

  // Handle unauthorized error (token expired)
  void _handleUnauthorizedError() async {
    retryCount.value++;
    final authRepo = Get.find<AuthenticationRepository>();
    
    try {
      // Attempt token refresh
      // await authRepo.refreshToken(); // Uncomment if you have refresh logic
      await fetchInformations(isRetry: true);
    } catch (e) {
      error('Session expired. Please login again.');
      ALoaders.errorSnackBar(
        title: 'Session Expired', 
        message: 'Please login again to continue'
      );
      // authRepo.logout(); // Uncomment to force logout
    }
  }

  // Handle network errors
  void _handleNetworkError(http.ClientException e) {
    error('Network error: ${e.message}');
    ALoaders.errorSnackBar(
      title: 'Network Error',
      message: 'Please check your internet connection'
    );
  }

  // Handle timeout errors
  void _handleTimeoutError(TimeoutException e) {
    error('Request timeout');
    ALoaders.errorSnackBar(
      title: 'Timeout',
      message: 'Server took too long to respond'
    );
  }

  // Handle generic errors
  void _handleGenericError(dynamic e) {
    error(e.toString());
    ALoaders.errorSnackBar(
      title: 'Error', 
      message: 'Failed to fetch informations: ${e.toString()}'
    );
  }

  // Refresh informations
  Future<void> refreshInformations() async {
    await fetchInformations();
  }

  Future<void> loadFilterOptions() async {
    try {
      // Load cities (assuming you have a CityController)
      final cityController = Get.find<CityController>();
      if (cityController.cities.isEmpty) {
        await cityController.fetchCities();
      }
      cities.assignAll(cityController.cities);

      // Extract unique info types from your data
      infoTypes.assignAll([
        'Police',
        'Hospital',
        'Ambulance',
        'Bus Station',
        'Train Station',
        'Visa Information',
        'Tourist Board',
        'Travel Agency',
        'Emergency Services',
        'Currency Exchange',
        'Local Attractions',
        'Restaurants',
        'Hotels',
        'Public Restrooms',
        'Parking Facilities',
        'Tour Guides',
        'Shopping Areas',
        'Cultural Sites',
        'Adventure Activities',
        'Transportation Services'
      ]);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load filter options');
    }
  }


  void applyFilters(String cityId, String infoType) {
    selectedCityId.value = cityId;
    selectedInfoType.value = infoType;
    
    // Filter logic
    final filtered = informations.where((info) {
      final matchesCity = cityId.isEmpty || info.cityId == cityId;
      final matchesType = infoType.isEmpty || info.infoType == infoType;
      return matchesCity && matchesType;
    }).toList();
    
    informations.assignAll(filtered);
  }

  void resetFilters() {
    selectedCityId.value = '';
    selectedInfoType.value = '';
    fetchInformations(); // Reload all data
  }

}