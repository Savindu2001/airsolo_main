import 'package:airsolo/features/authentication/models/user/user_model.dart';
import 'package:airsolo/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:airsolo/utils/exceptions/firebase_exceptions.dart';
import 'package:airsolo/utils/exceptions/format_exceptions.dart';
import 'package:airsolo/utils/exceptions/platform_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository extends GetxController{
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Function to save user data to firestore
  
  Future<void> saveUserRecord(UserModel user) async {
  try{
     await _db.collection('Users').doc(user.id).set(user.toJson());
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




}

class FirebaseFireStore {
}

