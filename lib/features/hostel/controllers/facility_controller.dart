import 'dart:convert';

import 'package:airsolo/config.dart';
import 'package:airsolo/features/hostel/models/facility_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FacilityController extends GetxController {
  static FacilityController get instance => Get.find();

  final RxList<Facility> facilities = <Facility>[].obs;
  final RxBool isLoading = false.obs;

  Future<void> fetchFacilities(String hostelId) async {
    try {
      isLoading(true);
      
      final response = await http.get(
        Uri.parse('${Config.facilityEndpoint}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        facilities.assignAll(data.map((json) => Facility.fromJson(json)));
      } else {
        throw Exception('Failed to load facilities');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}