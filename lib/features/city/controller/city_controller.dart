import 'dart:async';

import 'package:airsolo/config.dart';
import 'package:airsolo/data/repositories/authentication/authentication_repository.dart';
import 'package:airsolo/features/city/model/city_model.dart';
import 'package:airsolo/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CityController extends GetxController {
  static CityController get instance => Get.find();

  final RxList<City> cities = <City>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxInt retryCount = 0.obs;
  final int maxRetries = 2;



    @override
  void onInit() {
    super.onInit();
    fetchCities();  
    //_setupResumeListener();
  }




  Future<void> fetchCities({bool isRetry = false}) async {
    try {
      // final isConnected = await NetworkManager.instance.isConnected();

      // // Network Check 
      // if (!isConnected) {
      //   error('No internet connection');
      //   isLoading(false);
      //   return;
      // }
      if (!isRetry) {
        isLoading(true);
        error('');
        retryCount.value = 0;
      }
      // Get Token
      final authRepo = Get.find<AuthenticationRepository>();
      final token = await _getValidToken();
      if (token == null) {
        throw Exception('Authentication required');
      }

      final response = await http.get(
        Uri.parse(Config.cityEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

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

  Future<String?> _getValidToken() async {
    final authRepo = Get.find<AuthenticationRepository>();
    // Get token from shared preferences or auth controller
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwtToken');
  }

  void _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      cities.assignAll(
        data.map((cityJson) => City.fromJson(cityJson as Map<String, dynamic>)).toList()
      );
    } else if (response.statusCode == 401 && retryCount.value < maxRetries) {
      _handleUnauthorizedError();
    } else {
      throw Exception('Failed to load cities: ${response.statusCode}');
    }
  }

  void _handleUnauthorizedError() async {
    retryCount.value++;
    final authRepo = Get.find<AuthenticationRepository>();
    
    try {
      // Attempt token refresh
      // await authRepo.refreshToken(); // Uncomment if you have refresh logic
      await fetchCities(isRetry: true);
    } catch (e) {
      error('Session expired. Please login again.');
      ALoaders.errorSnackBar(
        title: 'Session Expired', 
        message: 'Please login again to continue'
      );
      // authRepo.logout(); // Uncomment to force logout
    }
  }

  void _handleNetworkError(http.ClientException e) {
    error('Network error: ${e.message}');
    ALoaders.errorSnackBar(
      title: 'Network Error',
      message: 'Please check your internet connection'
    );
  }

  void _handleTimeoutError(TimeoutException e) {
    error('Request timeout');
    ALoaders.errorSnackBar(
      title: 'Timeout',
      message: 'Server took too long to respond'
    );
  }

  void _handleGenericError(dynamic e) {
    error(e.toString());
    ALoaders.errorSnackBar(
      title: 'Error', 
      message: 'Failed to fetch cities: ${e.toString()}'
    );
  }

  Future<void> refreshCities() async {
    await fetchCities();
  }
}


