
import 'package:airsolo/features/authentication/screens/loging/login.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

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
      Get.offAll(const  LoginScreen());
    }
  }


  /// Update Current Index & Jump to last The page
  void skipPage() {
    currentPageIndex.value = 2;
    pageController.jumpToPage(2);
  }


}