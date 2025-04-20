import 'dart:convert';

import 'package:airsolo/config.dart';
import 'package:airsolo/features/hostel/models/house_rule_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HouseRuleController extends GetxController {
  static HouseRuleController get instance => Get.find();

  final RxList<HouseRule> houseRules = <HouseRule>[].obs;
  final RxBool isLoading = false.obs;

  Future<void> fetchHouseRulesByHostel(String hostelId) async {
    try {
      isLoading(true);
      
      final response = await http.get(
        Uri.parse('${Config.houseRulesEndpoint}/hostel/$hostelId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        houseRules.assignAll(data.map((json) => HouseRule.fromJson(json)));
      } else {
        throw Exception('Failed to load house rules');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}