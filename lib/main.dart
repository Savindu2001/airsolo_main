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
  
  // -- Widget Binding -- //
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // -- GetX Local Storage -- //
  await GetStorage.init();

  // -- Await Splash Screen Until Other Items Load -- //
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // -- Initialize Firebase & Authentication Repo -- //
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then(
        (FirebaseApp value) => Get.put(AuthenticationRepository()),
  );

  // -- Login COntroller -- //
  Get.put(LoginController());


  // -- Load The App -- //
  runApp(const AirsoloApp());
}