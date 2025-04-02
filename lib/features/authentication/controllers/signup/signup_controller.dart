import 'package:airsolo/data/repositories/authentication/authentication_repository.dart';
import 'package:airsolo/features/authentication/models/user/user_model.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/helpers/network_manager.dart';
import 'package:airsolo/utils/popups/full_screen_loader.dart';
import 'package:airsolo/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SignupController extends GetxController{
  static SignupController get instance => Get.find();

  //- Variables
  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  final email = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final phoneNumber = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();


  //- Signup
  void signup() async {
    try{

      //Start Loading
      AFullScreenLoader.openLoadingDialog('We are proccessing your information..', AImages.proccessingDocer );

      //Check Internet Conectivity

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;
      

      //Form Validation
      if(signupFormKey.currentState!.validate()) return;
      

      //Privacy Policy Check
      if(!privacyPolicy.value){
        ALoaders.warningSnackBar(
          title: 'Accept Privacy Policy',
          message: 'In Order to Create Account, you must have the read and accept Privacy policy & Terms Condtions'
          );
          return;
      }

      //Register User In the Firebase Authentication & Save User Data in the Firebase

      final UserCredential = await AuthenticationRepository.instance.registerWithEmailAndPassword(email.text.trim(), password.text.trim());

      //Save Authenticated user data in the firebase firestore

      final newUser = UserModel(
        id: UserCredential.user!.uid, 
        firstName: firstName.text.trim(), 
        lastName: lastName.text.trim(), 
        username: username.text.trim(), 
        email: email.text.trim(), 
        role: '', 
        phoneNumber: phoneNumber.text.trim(), 
        profilePicture: '',
        );

      //Show Success Message

      //Move To Verify Email Screen

    } catch (e){

      // Show Some Generic Errors to User

      ALoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());

    } finally {
      //Remove Loader
      AFullScreenLoader.stopLoading();
    }
  }
}