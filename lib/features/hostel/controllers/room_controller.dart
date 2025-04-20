import 'dart:convert';

import 'package:airsolo/config.dart';
import 'package:airsolo/features/hostel/models/room_model.dart';
import 'package:airsolo/utils/helpers/network_manager.dart';
import 'package:airsolo/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RoomController extends GetxController {
  static RoomController get instance => Get.find();

  final RxList<Room> rooms = <Room>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  Future<void> fetchRoomsByHostel(String hostelId) async {
    try {
      isLoading(true);
      error('');
      
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) throw Exception('No internet connection');

      final token = await _getValidToken();
      if (token == null) throw Exception('Authentication required');

      final response = await http.get(
        Uri.parse('${Config.roomsEndpoint}/hostel/$hostelId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        rooms.assignAll(data.map((json) => Room.fromJson(json)));
      } else {
        throw Exception('Failed to load rooms: ${response.statusCode}');
      }
    } catch (e) {
      error(e.toString());
      ALoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<String?> _getValidToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwtToken');
  }
}