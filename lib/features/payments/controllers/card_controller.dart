import 'dart:async';
import 'dart:convert';

import 'package:airsolo/config.dart';
import 'package:airsolo/features/payments/models/card_model.dart';
import 'package:airsolo/features/users/user_controller.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/helpers/network_manager.dart';
import 'package:airsolo/utils/popups/full_screen_loader.dart';
import 'package:airsolo/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentCardController extends GetxController {
  static PaymentCardController get instance => Get.find();
  final UserController userController = Get.put(UserController());

  final RxList<PaymentCard> paymentCardDetails = <PaymentCard>[].obs;
  final RxString error = ''.obs;
  final RxInt retryCount = 0.obs;
  final int maxRetries = 2;

  // form controllers
  final cardNumber = TextEditingController();
  final cvv = TextEditingController();
  final expDate = TextEditingController();
  final cardType = TextEditingController();
  final nickName = TextEditingController();
  GlobalKey<FormState> cardFormKey = GlobalKey<FormState>();

   @override
  void onInit() {
    super.onInit();
    fetchUserCards();
    
  }




// Add Cards
Future<void> addCard({bool isRetry = false}) async {
  try {
    AFullScreenLoader.openLoadingDialog('Adding your card...', AImages.paperPlane);

    final isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) return;

    final token = await _getValidToken();
    if (token == null) throw Exception('Authentication required');

    final cardDetails = {
      'user_id': userController.currentUser!.id,
      'cardNumber': cardNumber.text.trim(),
      'cvv': cvv.text.trim(),
      'card_type': cardType.text.trim(),
      'exp_date': expDate.text.trim(),
      'nickname': nickName.text.trim(),
    };

    final response = await http.post(
      Uri.parse(Config.cardDetailEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(cardDetails),
    ).timeout(const Duration(seconds: 10));

    final data = jsonDecode(response.body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      AFullScreenLoader.stopLoading();
      fetchUserCards();
      ALoaders.successSnackBar(title: 'Success!', message: 'Card added successfully!');
      await fetchUserCards(); 
    } else {
      throw Exception(data['message'] ?? 'Something went wrong');
    }
  } catch (e) {
    ALoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
  } finally {
    AFullScreenLoader.stopLoading();
  }
}



//delete card
Future<void> deleteCard(String cardId) async {
  try {
    final token = await _getValidToken();
    if (token == null) throw Exception('Authentication required');

    final response = await http.delete(
      Uri.parse('${Config.cardDetailEndpoint}/$cardId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      ALoaders.successSnackBar(title: 'Deleted', message: 'Card removed successfully.');
      fetchUserCards();
    } else {
      throw Exception('Failed to delete card');
    }
  } catch (e) {
    ALoaders.errorSnackBar(title: 'Error', message: e.toString());
  }
}



// Get valid authentication token
Future<String?> _getValidToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwtToken');
}



// Fetch User's Cards Details
Future<void> fetchUserCards() async {
  try {
    error.value = '';
    final currentUser = fb.FirebaseAuth.instance.currentUser;
    final currentUserId = currentUser?.uid;
  
    
    if (currentUserId == null) {
      throw Exception('No authenticated user found');
    }

    final token = await _getValidToken();
    if (token == null || token.isEmpty) {
      throw Exception('Authentication token is missing or invalid');
    }

    final response = await http.get(
      Uri.parse('${Config.cardDetailsByUserId}/$currentUserId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    ).timeout(const Duration(seconds: 15));

    // debugPrint('Response status: ${response.statusCode}');
    // debugPrint('Response body: ${response.body}');

    if (response.statusCode == 403) {
      if (response.body.contains('expired')) {
        throw Exception('Session expired - please login again');
      }
      throw Exception('Access denied - insufficient permissions');
    }
    
    if (response.statusCode != 200) {
      throw Exception('Failed to load cards (${response.statusCode})');
    }

    final jsonData = jsonDecode(response.body);
    
    // Check if response has the expected structure
    if (jsonData is! Map<String, dynamic> || jsonData['data'] == null) {
      throw Exception('Invalid response format from server');
    }

    // Verify success flag
    if (jsonData['success'] != true) {
      throw Exception('Server reported failure: ${jsonData['message'] ?? 'Unknown error'}');
    }

    // Get the cards array from data field
    final responseData = jsonData['data'];
    if (responseData is! List) {
      throw Exception('Expected list but got ${responseData.runtimeType}');
    }

    final List<PaymentCard> cards = [];
    for (final item in responseData) {
      try {
        if (item is! Map<String, dynamic>) {
          //debugPrint('Skipping invalid card item: $item');
          continue;
        }

        // Validate required fields
        if (item['id'] == null || 
            item['card_type'] == null ||
            item['user_id'] == null ||
            item['exp_date'] == null) {
          //debugPrint('Card missing required fields: $item');
          continue;
        }

        cards.add(PaymentCard.fromJson(item));
      } catch (e, stackTrace) {
        // debugPrint('Error parsing card: $e');
        // debugPrint('Stack trace: $stackTrace');
        // debugPrint('Problematic card data: $item');
      }
    }

    paymentCardDetails.value = cards;
   // debugPrint('Successfully loaded ${cards.length} cards');

  } on TimeoutException {
    error.value = 'Request timed out. Please try again.';
  } on http.ClientException catch (e) {
    error.value = 'Network error: ${e.message}';
  } on FormatException catch (e) {
    error.value = 'Data format error: ${e.message}';
  } catch (e, stackTrace) {
    error.value = 'Failed to load cards: ${e.toString().replaceAll('Exception: ', '')}';
   // debugPrint('Error in fetchUserCards: $e');
    //debugPrint('Stack trace: $stackTrace');
  } finally {
    
  }
}





}