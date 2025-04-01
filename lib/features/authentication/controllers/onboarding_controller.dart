
import 'package:airsolo/features/authentication/screens/loging/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnboardingController extends GetxController{
  static OnboardingController get instance => Get.find();

  ///Variables
  

  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;
  
  
  /// Update Current Index When page Scroll
  
  void updatePageIndicator(index) => currentPageIndex.value = index;


  /// Jump to The Specific dot selected page
  void dotNavigationClick(index) {
    currentPageIndex.value = index;
    pageController.jumpTo(index);
  }


  /// Update Current Index & Jump to next The page
  void nextPage() {
    if(currentPageIndex.value ==  2){
      final storage = GetStorage();

      if(kDebugMode){
        print('============================= GET STORAGE Next Button =============================');
        print(storage.read('isFirstTime'));
      }

      storage.write('isFirstTime', false);

      if(kDebugMode){
        print('============================= GET STORAGE Next Button =============================');
        print(storage.read('isFirstTime'));
      }

      Get.offAll(const  LoginScreen());
    }else{
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }


  /// Update Current Index & Jump to last The page
  void skipPage() {
    currentPageIndex.value = 2;
    pageController.jumpToPage(2);
  }


}