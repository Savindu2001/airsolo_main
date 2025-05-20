import 'dart:async';
import 'dart:convert';

import 'package:airsolo/config.dart';
import 'package:airsolo/data/repositories/authentication/authentication_repository.dart';
import 'package:airsolo/features/hostel/models/facility_model.dart';
import 'package:airsolo/features/hostel/models/hostel_model.dart';
import 'package:airsolo/features/hostel/models/house_rule_model.dart';
import 'package:airsolo/features/hostel/models/room_model.dart';
import 'package:airsolo/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HostelController extends GetxController {
  static HostelController get instance => Get.find();

  final RxList<Hostel> hostels = <Hostel>[].obs;
  final RxList<Hostel> filteredHostels = <Hostel>[].obs;
  final RxMap<String, List<Room>> hostelRooms = <String, List<Room>>{}.obs;
  final RxList<Room> rooms = <Room>[].obs;
  final RxList<Facility> facilities = <Facility>[].obs;
  final RxList<HouseRule> houseRules = <HouseRule>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingFacilities = false.obs;
  final RxBool isLoadingRooms = false.obs;
  final RxBool isLoadingHouseRules = false.obs;
  final RxInt retryCount = 0.obs;
  final RxString error = ''.obs;
  final RxString searchQuery = ''.obs;
  final int maxRetries = 2;
  final Rx<Hostel?> selectedHostel = Rx<Hostel?>(null);
  final RxBool isDetailLoading = false.obs;
  final Rx<Room?> selectedRoom = Rx<Room?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchHostels();
    debounce(
      searchQuery,
      (_) => filterHostels(),
      time: const Duration(milliseconds: 400),
    );
  }


  // Helper method to get rooms for a hostel
  List<Room> getRoomsForHostel(String hostelId) {
    return hostelRooms[hostelId] ?? [];
  }

  Future<void> fetchHostels({bool isRetry = false}) async {
    try {
      
      if (!isRetry) {
        retryCount.value = 0;
        isLoading(true);
        error('');
      }

      final authRepo = Get.find<AuthenticationRepository>();
      final token = await _getValidToken();
      if (token == null) {
        throw Exception('Authentication required');
      }

      final response = await http.get(
        Uri.parse(Config.hostelEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        hostels.assignAll(data.map((json) => Hostel.fromJson(json)));
        
        filterHostels();
      } else if (response.statusCode == 401 && retryCount.value < maxRetries) {
        await _handleUnauthorizedError();
        await fetchHostels(isRetry: true);
      } else {
        throw Exception('Failed to load hostels: ${response.statusCode}');
      }
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


Future<void> fetchRooms(String hostelId) async {
    try {
      isDetailLoading(true);
      final response = await http.get(
        Uri.parse('${Config.roomsEndpoint}/hostel/$hostelId')
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        hostelRooms[hostelId] = data.map((json) => Room.fromJson(json)).toList();
        
        // Update the hostel in the list if needed
        final index = hostels.indexWhere((h) => h.id == hostelId);
        if (index != -1) {
          hostels[index] = hostels[index].copyWith(
            rooms: hostelRooms[hostelId]!,
          );
        }
      }
    } finally {
      isDetailLoading(false);
    }
  }

  Future<Hostel?> fetchHostelDetails(String hostelId) async {
    try {
      isLoading(true);
      error('');
      retryCount.value = 0;

      final token = await _getValidToken();
      if (token == null) {
        throw Exception('Authentication required');
      }

      final response = await http.get(
        Uri.parse('${Config.hostelEndpoint}/$hostelId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return Hostel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401 && retryCount.value < maxRetries) {
        await _handleUnauthorizedError();
        return await fetchHostelDetails(hostelId);
      } else {
        throw Exception('Failed to load hostel: ${response.statusCode}');
      }
    } catch (e) {
      error(e.toString());
      return null;
    } finally {
      isLoading(false);
    }
  }

Future<void> loadHostelDetails(String hostelId) async {
  try {
    isDetailLoading(true);
    error('');
    
    // Load hostel details first
    final hostel = await fetchHostelDetails(hostelId);
    if (hostel != null) {
      selectedHostel(hostel);
      
      // Load other data in parallel but don't fail if some endpoints fail
      await Future.wait([
        fetchRoomsByHostel(hostelId).catchError((e) => debugPrint('Room error: $e')),
        fetchFacilities().catchError((e) => debugPrint('Facility error: $e')),
        fetchHouseRulesByHostel().catchError((e) => debugPrint('House rules error: $e')),
      ], eagerError: false);
    }
  } catch (e) {
    error('Failed to load hostel details: ${e.toString()}');
  } finally {
    isDetailLoading(false);
  }
}

 Future<void> fetchRoomsByHostel(String hostelId) async {
  try {
    // Only show loading if we don't already have data
    if (rooms.isEmpty) isLoading(true);
    error('');
    retryCount.value = 0;

    final token = await _getValidToken();
    if (token == null) {
      throw Exception('Authentication required');
    }

    final response = await http.get(
      Uri.parse('${Config.roomsEndpoint}/hostel/$hostelId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 15)); // Increased timeout

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        rooms.assignAll(data.map((json) => Room.fromJson(json)));
      } else {
        rooms.clear(); 
        error('No rooms available for this hostel');
      }
    } else if (response.statusCode == 401) {
      if (retryCount.value < maxRetries) {
        retryCount.value++;
        await _handleUnauthorizedError();
        await fetchRoomsByHostel(hostelId);
      } else {
        throw Exception('Maximum retry attempts reached');
      }
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  } on TimeoutException {
    error('Request timed out. Please try again.');
    // Consider implementing a retry button in the UI
  } on http.ClientException catch (e) {
    error('Connection error: ${e.message}');
  } catch (e) {
    error('Failed to load rooms: ${e.toString()}');
  } finally {
    isLoading(false);
  }
}


  Future<void> fetchFacilities() async {
    try {
      isLoading(true);
      error('');
      retryCount.value = 0;

      final token = await _getValidToken();
      if (token == null) {
        throw Exception('Authentication required');
      }

      final response = await http.get(
        Uri.parse(Config.facilityEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        facilities.assignAll(data.map((json) => Facility.fromJson(json)));
      } else if (response.statusCode == 401 && retryCount.value < maxRetries) {
        await _handleUnauthorizedError();
        await fetchFacilities();
      } else {
        throw Exception('Failed to load facilities: ${response.statusCode}');
      }
    } catch (e) {
      error(e.toString());
    } finally {
      isLoading(false);
    }
  }

 

  Future<void> fetchHouseRulesByHostel() async {
  try {
    isLoadingHouseRules(true);
    houseRules.clear();

    final token = await _getValidToken();
    if (token == null) {
      throw Exception('Authentication required');
    }

    final response = await http.get(
      Uri.parse(Config.houseRulesEndpoint),
      headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        houseRules.assignAll(data.map((json) => HouseRule.fromJson(json)));
      }
    } else if (response.statusCode != 404) {
      throw Exception('Failed to load house rules: ${response.statusCode}');
    }
    
  } catch (e) {
    if (e is! http.ClientException && e is! TimeoutException) {
      error('Failed to load house rules: ${e.toString()}');
      debugPrint('House rules error: $e');
    }
  } finally {
    isLoadingHouseRules(false);
  }
}

  Future<bool> bookRoom({
    required String roomId,
    required String bedType,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required int numGuests,
    String? specialRequests,
  }) async {
    try {
      isLoading(true);
      error('');
      retryCount.value = 0;

      final token = await _getValidToken();
      if (token == null) {
        throw Exception('Authentication required');
      }

      final response = await http.post(
        Uri.parse(Config.bookingEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'roomId': roomId,
          'bedType': bedType,
          'checkInDate': checkInDate.toIso8601String(),
          'checkOutDate': checkOutDate.toIso8601String(),
          'numGuests': numGuests,
          'specialRequests': specialRequests,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        ALoaders.successSnackBar(title: 'Success', message: 'Room booked successfully');
        return true;
      } else if (response.statusCode == 401 && retryCount.value < maxRetries) {
        await _handleUnauthorizedError();
        return await bookRoom(
          roomId: roomId,
          bedType: bedType,
          checkInDate: checkInDate,
          checkOutDate: checkOutDate,
          numGuests: numGuests,
          specialRequests: specialRequests,
        );
      } else {
        throw Exception('Failed to book room: ${response.statusCode}');
      }
    } catch (e) {
      error(e.toString());
      ALoaders.errorSnackBar(title: 'Error', message: e.toString());
      return false;
    } finally {
      isLoading(false);
    }
  }

  void filterHostels() {
    if (searchQuery.isEmpty) {
      filteredHostels.assignAll(hostels);
    } else {
      filteredHostels.assignAll(
        hostels.where(
          (hostel) =>
              hostel.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
              (hostel.address?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false) ||
              hostel.cityId.toLowerCase().contains(searchQuery.value.toLowerCase()),
        ),
      );
    }
  }

  Future<String?> _getValidToken() async {
    try {
      final authRepo = Get.find<AuthenticationRepository>();
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('jwtToken');
    } catch (e) {
      error('Failed to get authentication token');
      return null;
    }
  }

  Future<void> refreshHostels() async {
    await fetchHostels();
  }

  Future<void> _handleUnauthorizedError() async {
    retryCount.value++;
    final authRepo = Get.find<AuthenticationRepository>();
    
    try {
      error('Session expired. Please login again.');
      ALoaders.errorSnackBar(
        title: 'Session Expired', 
        message: 'Please login again to continue',
      );
    } catch (e) {
      error('Failed to refresh session: ${e.toString()}');
    }
  }

  void _handleNetworkError(http.ClientException e) {
    error('Network error: ${e.message}');
    ALoaders.errorSnackBar(
      title: 'Network Error',
      message: 'Please check your internet connection',
    );
  }

  void _handleTimeoutError(TimeoutException e) {
    error('Request timeout');
    ALoaders.errorSnackBar(
      title: 'Timeout',
      message: 'Server took too long to respond',
    );
  }

  void _handleGenericError(dynamic e) {
    error(e.toString());
    ALoaders.errorSnackBar(
      title: 'Error', 
      message: 'Failed to fetch hostels: ${e.toString()}',
    );
  }



  void applyFilters({
  String type = '',
  String city = '',
  double minPrice = 0,
  double maxPrice = double.infinity,
}) {
  try {
    isLoading(true);
    
    filteredHostels.assignAll(hostels.where((hostel) {
      // Type filter
      // if (type.isNotEmpty && type != 'All' && hostel.type?.toLowerCase() != type.toLowerCase()) {
      //   return false;
      // }
      
      // City filter
      if (city.isNotEmpty && city != 'All' && hostel.cityId?.toLowerCase() != city.toLowerCase()) {
        return false;
      }
      
      // Price filter - only apply if hostel has rooms
      final rooms = getRoomsForHostel(hostel.id);
      if (rooms.isNotEmpty) {
        final prices = rooms.map((room) => room.pricePerPerson).toList();
        prices.sort();
        final minHostelPrice = prices.first;
        final maxHostelPrice = prices.last;
        
        if (minHostelPrice < minPrice || maxHostelPrice > maxPrice) {
          return false;
        }
      }
      
      return true;
    }).toList());
    
    // If search query is active, apply that filter too
    if (searchQuery.isNotEmpty) {
      filterHostels();
    }
  } catch (e) {
    error('Failed to apply filters: ${e.toString()}');
  } finally {
    isLoading(false);
  }
}
}


