import 'package:airsolo/features/authentication/screens/loging/login.dart';
import 'package:airsolo/features/authentication/screens/onboarding/onboarding.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthenticationRepository extends GetxController{
  static AuthenticationRepository get instance => Get.find();

  // Variables
  final deviceStorage = GetStorage();

  //-- Called from main.dart to luanch app
  
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }
    

    // Function to Show relavent screen 
    screenRedirect() async {

      // Local Storage
      if(kDebugMode){
        print('============================= GET STORAGE Auth Repo =============================');
        print(deviceStorage.read('isFirstTime'));
      }

      deviceStorage.writeIfNull('isFirstTime', true);
      deviceStorage.read('isFirstTime') != true  ? Get.offAll(()=> const LoginScreen()) : Get.offAll(()=> Onboarding());
    }


//-------------------- Email & Password sig in ---------------------

// Sign-in
// Register
// Reauthenticate


  
}