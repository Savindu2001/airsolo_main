import 'dart:convert';

import 'package:airsolo/config.dart';
import 'package:airsolo/features/users/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';




  

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final RxList<User> user = <User>[].obs;
  final Rx<User?> currentDriver = Rx<User?>(null);
  final RxBool isLoading = false.obs;



  
  
@override
  void onInit() {
    super.onInit();
    fetchCurrentUserDetails();
    
  }

  /// Get the currently logged-in user's details from the backend
 Future<void> fetchCurrentUserDetails() async {
    try {
      isLoading(true);

      final currentUser = fb.FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      final uid = currentUser.uid;
      final token = await _getValidToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      // API call to fetch user data
      final response = await http.get(
        Uri.parse('${Config.userEndpoint}/$uid'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        user.assignAll([User.fromJson(data)]);
      } else {
        final errorMsg = jsonDecode(response.body)['message'] ?? 'Failed to fetch user data';
        throw Exception(errorMsg);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }



  // Fetch driver details 
// Future<User?> fetchDriverDetails(String driverId) async {
//   try {
//     isLoading(true);
//     final token = await _getValidToken();
//     if (token == null) throw Exception('Authentication token not found');

//     final response = await http.get(
//       Uri.parse('${Config.userEndpoint}/$driverId'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//     ).timeout(const Duration(seconds: 10));

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return User.fromJson(data);
//     } else {
//       final errorMsg = jsonDecode(response.body)['message'] ?? 'Failed to fetch driver data';
//       throw Exception(errorMsg);
//     }
//   } catch (e) {
//     Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
//     return null;
//   } finally {
//     isLoading(false);
//   }
// }

Future<void> fetchDriverDetails(String driverId) async {
  try {
    isLoading(true);
    final token = await _getValidToken();
    if (token == null) throw Exception('Authentication required');

    print('Driver id ********* $driverId');

    final response = await http.get(
      Uri.parse('${Config.userEndpoint}/$driverId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
 
    if (response.statusCode == 200) {
      print(response.body);
      final data = jsonDecode(response.body);
      if (data['role'] != 'driver') {
        throw Exception('User is not a driver');
      }
      currentDriver.value = User.fromJson(data);
    } else {
      throw Exception('Failed to load driver details');
    }
  } catch (e) {
    Get.snackbar('Error', e.toString());
    currentDriver.value = null;
  } finally {
    isLoading(false);
  }
}

  /// Get token from shared preferences
  Future<String?> _getValidToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwtToken');
  }

  /// Helper: Return current user object
  User? get currentUser => user.isNotEmpty ? user.first : null;
}
