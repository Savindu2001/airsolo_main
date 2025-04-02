import 'package:airsolo/features/authentication/screens/loging/login.dart';
import 'package:airsolo/features/authentication/screens/onboarding/onboarding.dart';
import 'package:airsolo/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:airsolo/utils/exceptions/firebase_exceptions.dart';
import 'package:airsolo/utils/exceptions/format_exceptions.dart';
import 'package:airsolo/utils/exceptions/platform_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthenticationRepository extends GetxController{
  static AuthenticationRepository get instance => Get.find();

  // Variables
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

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
      deviceStorage.read('isFirstTime') != true  ? Get.offAll(()=> const LoginScreen()) : Get.offAll(()=> const Onboarding());
    }


//-------------------- Email & Password sig in ---------------------//

// [EmailAuthentication]  Sign-in

// [EmailAuthentication] Register
Future<UserCredential> registerWithEmailAndPassword( String email, String password) async {
  try{
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch (e) {
      throw AFirebaseAuthException(e.code).message;
  } on FirebaseException catch (e) {
    throw AFirebaseException(e.code).message;
  } on FormatException catch (_) {
    throw const AFormatException();
  } on PlatformException catch (e){
    throw APlatformException(e.code).message;
  } catch (e){
    throw 'Something went wrong! please try again';
  }

}

// [EmailAuthentication] Mail Verification


// [EmailAuthentication] Reauthenticate
// [EmailAuthentication] Forget Password




//-------------------- Federated identity & Social Login ---------------------//

// Google

// Facebook

//-------------------- /- End Email & Password sig in ---------------------//

// [Logoutuser] valid for any authentication

// [DeleteUser] Remove User & Firestore Data

  
}