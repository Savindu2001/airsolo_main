import 'package:airsolo/app.dart';
import 'package:airsolo/data/repositories/authentication/authentication_repository.dart';
import 'package:airsolo/data/services/firebase_options.dart';
import 'package:airsolo/features/authentication/controllers/login_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';




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

  runApp(const AirsoloApp());

  // Initialize auth state after app loads
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Get.find<AuthenticationRepository>().initializeAuthState();
  });
}