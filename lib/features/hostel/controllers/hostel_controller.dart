import 'dart:async';
import 'package:airsolo/config.dart';
import 'package:airsolo/data/repositories/authentication/authentication_repository.dart';
import 'package:airsolo/features/hostel/models/hostel_model.dart';
import 'package:airsolo/utils/helpers/network_manager.dart';
import 'package:airsolo/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HostelController extends GetxController {
  static HostelController get instance => Get.find();

  final RxList<Hostel> hostels = <Hostel>[].obs;
  final RxList<Hostel> filteredHostels = <Hostel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxInt retryCount = 0.obs;
  final int maxRetries = 2;
  final RxString searchQuery = ''.obs;
  final RxString selectedCity = ''.obs;
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 1000.0.obs;
  final RxList<String> selectedFacilities = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHostels();
    debounce(searchQuery, (_) => filterHostels(), time: const Duration(milliseconds: 500));
  }

  Future<void> fetchHostels({bool isRetry = false}) async {
    try {

      // Network Check
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

      // Get Valid Auth token
      final token = await _getValidToken();
      if (token == null) throw Exception('Authentication required');

      final response = await http.get(
        Uri.parse(Config.hostelEndpoint),
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
      final authRepo = Get.find<AuthenticationRepository>();
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwtToken');
      
      if (token == null) {
        await authRepo.logout();
        Get.offAllNamed('/login');
        return null;
      }
      return token;
    } catch (e) {
      ALoaders.errorSnackBar(title: 'Authentication Error', message: 'Please login again');
      return null;
    }
  }

  void _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        final List<dynamic> data = jsonDecode(response.body);
        hostels.assignAll(
          data.map((hostelJson) => Hostel.fromJson(hostelJson)).toList()
        );
        filterHostels();
        break;
      case 401:
        if (retryCount.value < maxRetries) {
          _handleUnauthorizedError();
        } else {
          error('Session expired. Please login again.');
          ALoaders.errorSnackBar(title: 'Session Expired', message: 'Please login again');
        }
        break;
      case 403:
        error('Permission denied');
        ALoaders.errorSnackBar(title: 'Permission Denied', message: 'You don\'t have access');
        break;
      default:
        error('Failed to load hostels: ${response.statusCode}');
        ALoaders.errorSnackBar(
          title: 'Error ${response.statusCode}',
          message: 'Failed to load hostels'
        );
    }
  }

  void _handleUnauthorizedError() async {
    retryCount.value++;
    try {
      final authRepo = Get.find<AuthenticationRepository>();
      final refreshed = await authRepo.refreshToken();
      if (refreshed) {
        await fetchHostels(isRetry: true);
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
      message: 'Failed to fetch hostels: ${e.toString()}'
    );
  }

  void filterHostels() {
    filteredHostels.assignAll(hostels.where((hostel) {
      final matchesSearch = hostel.name.toLowerCase().contains(searchQuery.value.toLowerCase()) || 
                          hostel.cityId.toLowerCase().contains(searchQuery.value.toLowerCase());
      final matchesCity = selectedCity.value.isEmpty || hostel.cityId == selectedCity.value;
      final matchesPrice = hostel.rooms.any((room) => 
                          room.pricePerPerson >= minPrice.value && 
                          room.pricePerPerson <= maxPrice.value);
      final matchesFacilities = selectedFacilities.isEmpty || 
                              hostel.facilityIds?.any((id) => selectedFacilities.contains(id)) == true;
      
      return matchesSearch && matchesCity && matchesPrice && matchesFacilities;
    }));
  }

  Future<void> refreshHostels() async {
    await fetchHostels();
  }
}