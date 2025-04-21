import 'package:airsolo/app.dart';
import 'package:airsolo/data/repositories/authentication/authentication_repository.dart';
import 'package:airsolo/data/services/firebase_options.dart';
import 'package:airsolo/features/authentication/controllers/login_controller.dart';
import 'package:airsolo/features/city/controller/city_controller.dart';
import 'package:airsolo/features/hostel/controllers/booking_controller.dart';
import 'package:airsolo/features/hostel/controllers/hostel_controller.dart';
import 'package:airsolo/features/hostel/controllers/house_rule_controller.dart';
import 'package:airsolo/features/hostel/controllers/room_controller.dart';
import 'package:airsolo/features/users/user_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';

void main() async {
  final WidgetsBinding widgetsBinding = 
      WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize dependencies
  Get.put(AuthenticationRepository(), permanent: true);
  Get.put(LoginController(), permanent: true);
  Get.put(HostelController(), permanent: true);
  Get.put(RoomController(), permanent: true);
  Get.put(HouseRuleController(), permanent: true);
  Get.put(BookingController(), permanent: true);
  Get.put(UserController(), permanent: true);
  Get.put(CityController(), permanent: true);

  // Initialize PayHere SDK - Corrected initialization
//  try {
//   await PayHere.initialize(
//     merchantId: "1226795",
//     merchantSecret: "MzM0MDE2MTU1MjkMjM3OTEwNTQ1NzM5NzM2OTczMzc1MTI4MjQzMzM0MDE2MTU1Mjk=",
//     isSandboxEnabled: true, // Set to false in production
//   );
//   print('PayHere SDK initialized successfully');
// } catch (e) {
//   print('Failed to initialize PayHere SDK: $e');
// }

  runApp(const AirsoloApp());

  // Initialize auth state after app loads
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Get.find<AuthenticationRepository>().initializeAuthState();
  });
}