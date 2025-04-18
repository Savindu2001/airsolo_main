import 'dart:async';
import 'dart:convert';

import 'package:airsolo/config.dart';
import 'package:airsolo/data/repositories/authentication/authentication_repository.dart';
import 'package:airsolo/features/hostel/models/facilities_model.dart';
import 'package:airsolo/utils/helpers/network_manager.dart';
import 'package:airsolo/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FacilitiesController extends GetxController {
  static FacilitiesController get instance => Get.find();

  final RxList<Facility> facilities = <Facility>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxInt retryCount = 0.obs;
  final int maxRetries = 2;

  Future<void> fetchAllFacilities({bool isRetry = false}) async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        error('No internet connection');
        isLoading(false);
        return;
      }

      if (!isRetry) {
        isLoading(true);
        error('');
        retryCount.value = 0;
      }

      final token = await _getValidToken();
      if (token == null) throw Exception('Authentication required');

      final response = await http.get(
        Uri.parse(Config.facilityEndpoint),
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
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('jwtToken');
    } catch (e) {
      return null;
    }
  }

  void _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      facilities.assignAll(data.map((json) => Facility.fromJson(json)));
    } else if (response.statusCode == 401 && retryCount.value < maxRetries) {
      _handleUnauthorizedError();
    } else {
      error('Failed to load facilities: ${response.statusCode}');
      ALoaders.errorSnackBar(title: 'Error', message: 'Failed to load facilities');
    }
  }

  void _handleUnauthorizedError() async {
    retryCount.value++;
    try {
      final authRepo = Get.find<AuthenticationRepository>();
      final refreshed = await authRepo.refreshToken();
      if (refreshed) {
        await fetchAllFacilities(isRetry: true);
      } else {
        await authRepo.logout();
        Get.offAllNamed('/login');
      }
    } catch (e) {
      error('Authentication failed');
      await Get.find<AuthenticationRepository>().logout();
      Get.offAllNamed('/login');
    }
  }

  void _handleNetworkError(http.ClientException e) {
    error('Network error: ${e.message}');
    ALoaders.errorSnackBar(title: 'Network Error', message: 'Please check your connection');
  }

  void _handleTimeoutError(TimeoutException e) {
    error('Request timeout');
    ALoaders.errorSnackBar(title: 'Timeout', message: 'Server took too long to respond');
  }

  void _handleGenericError(dynamic e) {
    error(e.toString());
    ALoaders.errorSnackBar(title: 'Error', message: 'Failed to fetch facilities');
  }

  Facility? getFacilityById(String id) {
    try {
      return facilities.firstWhere((facility) => facility.id == id);
    } catch (e) {
      return null;
    }
  }
}